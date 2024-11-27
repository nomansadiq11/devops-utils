# EMR Serverless - Create Job using AWS Cli

## Usecase

- We need to create very simple job in emr serverless to test it

## Solution

- you need following `emr` serverless `applicationid`, `S3` bucket `IAM` role to assume for the application to read files in S3
- Create s3 bucket add the following python file to the s3 bucket

> example from `aws` doc

```python

import os
import sys
import pyspark.sql.functions as F
from pyspark.sql import SparkSession

if __name__ == "__main__":
    """
        Usage: wordcount [destination path]
    """
    spark = SparkSession\
        .builder\
        .appName("WordCount")\
        .getOrCreate()

    output_path = None

    if len(sys.argv) > 1:
        output_path = sys.argv[1]
    else:
        print("S3 output location not specified printing top 10 results to output stream")

    region = os.getenv("AWS_REGION")
    text_file = spark.sparkContext.textFile("s3://" + region  + ".elasticmapreduce/emr-containers/samples/wordcount/input")
    counts = text_file.flatMap(lambda line: line.split(" ")).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b).sortBy(lambda x: x[1], False)
    counts_df = counts.toDF(["word","count"])

    if output_path:
        counts_df.write.mode("overwrite").csv(output_path)
        print("WordCount job completed successfully. Refer output at S3 path: " + output_path)
    else:
        counts_df.show(10, False)
        print("WordCount job completed successfully.")

    spark.stop()

```

> Trigger job

```bash

applicationid={applicationd}
iamrolearn="{roleARN}"
jobname="myfirstjob"
s3logpath="s3://bucketname/logpath/"
entrypoint="s3://bucketname/file.py"


aws emr-serverless start-job-run \
    --application-id $applicationid    \
    --execution-role-arn $iamrolearn \
    --name $jobname \
    --configuration-overrides '{
        "monitoringConfiguration": {
            "s3MonitoringConfiguration": {
                "logUri": "$s3logpath"
            }
        }
    }' \
    --job-driver '{
        "sparkSubmit": {
          "entryPoint": "$entrypoint",
          "entryPointArguments": ["python","file.py",""],
          "sparkSubmitParameters": "--conf spark.executor.cores=2 --conf spark.executor.memory=10g --conf spark.driver.memory=10g --conf spark.executor.instances=5"
        }
    }'

```

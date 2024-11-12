# VPC flowlogs configuration

[Documentations](https://docs.aws.amazon.com/athena/latest/ug/vpc-flow-logs.html)

## how to create Parquet format table in glue

- In the documentation, follow the parquet table creation example and make sure you are giving full S3 path till to the region like us-east-1 and create the table
- once table is created following the next step MSCK... run on athena console, the output should shows you about the partitions, that will be created after running this command
- now you will able to see the results, get the queries from the examples

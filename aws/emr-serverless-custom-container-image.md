# EMR Serverless - Custom Container Image

## Usecase

- We have requirements to run customer container for some reason like security or business customization.

## Solution

- aws provide base image to use for customization [https://gallery.ecr.aws/emr-serverless/spark/emr-7.5.0](https://gallery.ecr.aws/emr-serverless/spark/emr-7.5.0)
- we can use this image to build custom container image and run in emr serverless

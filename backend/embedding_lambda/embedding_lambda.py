import boto3


def lambda_handler(event, context):
    result = "Hello World embedder"
    return {"statusCode": 200, "body": result}

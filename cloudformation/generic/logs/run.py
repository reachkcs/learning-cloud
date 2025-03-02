#!/usr/bin/python3

import json
import lambda_function1  # Ensure this matches the filename of your function

# Load test event
with open("test.json") as f:
    event = json.load(f)

# Create a mock context (not strictly needed for boto3 calls)
class Context:
    def __init__(self):
        self.function_name = "test_lambda"
        self.memory_limit_in_mb = 128
        self.invoked_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:test_lambda"
        self.aws_request_id = "test_request_id"

context = Context()

# Invoke Lambda function
lambda_function1.lambda_handler(event, context)


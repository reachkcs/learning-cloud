Run the stacks in the below order
vpc.yaml: Created two app VPCs and one shared services VPC that hosts SQS interface endpoint
../../bin/create-or-update-cw-stack.bash vpc.yaml VPC NO

tgw.yaml: Created transit gateway. Creates tgw attachments for the three VPCs created in the previous stack
../../bin/create-or-update-cw-stack.bash tgw.yaml TGW NO

routes.yaml: Creates the routes that are required for connectivity
../../bin/create-or-update-cw-stack.bash routes.yaml ROUTES NO

sqs.yaml: Creates SQS interface endpoints and also private hosted zone for the SQS service
../../bin/create-or-update-cw-stack.bash sqs-ep.yaml SQSEP NO

test.yaml: Creates a test EC2 and SQS queue that can be used for testing purposes
../../bin/create-or-update-cw-stack.bash test-sqs-ep.yaml TEST-SQS-EP YES



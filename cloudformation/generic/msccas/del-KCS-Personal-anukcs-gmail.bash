#!/bin/bash
export AWS_PROFILE=KCS-Personal-anukcs-gmail

delete_cw_stack.bash GRANT-AUTH
delete_cw_stack.bash SQS-PHZ
delete_cw_stack.bash SQS-ENDPOINT
delete_cw_stack.bash SQS-SG
delete_cw_stack.bash ROUTES
delete_cw_stack.bash NETWORK
delete_cw_stack.bash MSC-SSM-PARAMS
delete_cw_stack.bash TGW

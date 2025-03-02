#!/bin/bash
export AWS_PROFILE=KCS-Personal-anukcs-gmail
delete_cw_stack.bash TEMP-ROUTES
delete_cw_stack.bash DEFAULT-TGW-ATT
delete_cw_stack.bash TESTEC2S
delete_cw_stack.bash SQS-EP-A-RECORD
delete_cw_stack.bash SQS-EP
delete_cw_stack.bash SEC-GRP-EP
delete_cw_stack.bash ROUTES
delete_cw_stack.bash NETWORK
delete_cw_stack.bash MSC-INFRA-SSM
delete_cw_stack.bash TGW

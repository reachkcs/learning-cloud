#!/bin/bash
export AWS_PROFILE=KCS-Personal-reachsreedhar-kcs
delete_cw_stack.bash TEMP-ROUTES
delete_cw_stack.bash TESTEC2S
delete_cw_stack.bash DEFAULT-TGW-ATT
delete_cw_stack.bash LOGS
delete_cw_stack.bash MSC-INFRA-SSM

#!/bin/bash

# Create VPCs
set -x
#../../bin/create_cw_stack.bash testvpc.yaml KCSTEMP-VPC NO

# Create TGW setup for connecting VPC1 and VPC2
#../../bin/create_cw_stack.bash testtgw.yaml KCSTEMP-TGW NO

# Create test EC2s
#../../bin/create_cw_stack.bash testec2s.yaml KCSTEMP-EC2 NO

# Create API GW Endpoint
#../../bin/create_cw_stack.bash testapigw-ie.yaml KCSTEMP-EP NO

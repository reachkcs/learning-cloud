#!/bin/bash
. ~/.bashrc
ENV=$1
set -x
dms-desc-rep-tasks | grep ${ENV}  | grep incr | grep running | awk '{print "stop-dms-task "$4" "$3}' > /tmp/stop-dms.bash
set +x

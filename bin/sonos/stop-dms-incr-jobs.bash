#!/bin/bash
. ~/.bashrc

STOP_DMS_FILE=/tmp/stop_dms.bash 
echo "#!/bin/bash -x" > ${STOP_DMS_FILE}
dms-desc-rep-tasks  | grep prod | grep incr | awk -F\| '{print "stop-dms-task "$3}' >> ${STOP_DMS_FILE}
chmod +x ${STOP_DMS_FILE}
echo "Run ${STOP_DMS_FILE}"

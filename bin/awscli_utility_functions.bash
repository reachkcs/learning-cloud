# SSO Authentication
alias login_to_dev='aws sso login --profile DBA_Admin-502397910358'
alias login_to_prod='aws sso login --profile DBA_Admin-Dev-254092030674'

# AWS DMS
alias dms-desc-rep-tasks='aws dms describe-replication-tasks --query "ReplicationTasks[*].[ReplicationTaskIdentifier,ReplicationTaskArn,Status]" --output table'

function stop-dms-task() {
    if [ -z "$1" ]; then
        echo "Usage: stop_dms_task <ReplicationTaskIdentifier>"
        echo "You can list DMS tasks using: dms-desc-rep-tasks"
        echo "Example: stop_dms_task arn:aws:dms:us-east-1:123456789012:task:EXAMPLE"
        return 1
    fi
    local TASK_ID="$1"
    aws dms stop-replication-task --replication-task-arn "$TASK_ID"
}

function stop_prod_dms_tasks2() {
    echo "Copy and paste the following commands to stop all production DMS tasks:";echo
    dms-desc-rep-tasks | grep prod | grep running | awk -F"\|" '{print "stop-dms-task "$3}'
    echo
}

function stop_prod_dms_tasks() {
    cat <<EOF
    Copy and paste the following commands to stop all production DMS tasks:

stop-dms-task arn:aws:dms:us-east-1:502397910358:task:EYJEGNADW77XSBTUIHLZ56SANWZ5YP7543NWSUI
stop-dms-task arn:aws:dms:us-east-1:502397910358:task:MMESGF6GMIUZZONQCZD4IZWD62JTEE62YIXLAZY
stop-dms-task arn:aws:dms:us-east-1:502397910358:task:T2RQJK6CHNCTSWPHNDHP3BJJDEECEU5QNF6INQQ
stop-dms-task arn:aws:dms:us-east-1:502397910358:task:AJ6PQLVSNBNKDTFMQFGFCB44WOZPZ2LCARY64DY
EOF
}

function start_prod_dms_tasks() {
    cat <<EOF
    Copy and paste the following commands to start all production DMS tasks:

start-dms-task arn:aws:dms:us-east-1:502397910358:task:EYJEGNADW77XSBTUIHLZ56SANWZ5YP7543NWSUI
start-dms-task arn:aws:dms:us-east-1:502397910358:task:MMESGF6GMIUZZONQCZD4IZWD62JTEE62YIXLAZY
start-dms-task arn:aws:dms:us-east-1:502397910358:task:T2RQJK6CHNCTSWPHNDHP3BJJDEECEU5QNF6INQQ
start-dms-task arn:aws:dms:us-east-1:502397910358:task:AJ6PQLVSNBNKDTFMQFGFCB44WOZPZ2LCARY64DY
EOF
}

function stop_sbx_dms_task2() {
    echo "Copy and paste the following commands to stop all sandbox DMS tasks:";echo
    dms-desc-rep-tasks | grep sbx | grep running | awk -F"\|" '{print "stop-dms-task "$3}'
    echo
}

function stop_sbx_dms_task() {
    cat <<EOF
    Copy and paste the following command to stop the SBX DMS task:

stop-dms-task arn:aws:dms:us-east-1:502397910358:task:OZ7KX5ZK6JH3FQKX2Y5KX7ZK4Y3V7Y3Y3Y3Y3Y3Y}
EOF
}

function start_sbx_dms_task() {
    cat <<EOF
    Copy and paste the following command to start the SBX DMS task: 

start-dms-task arn:aws:dms:us-east-1:502397910358:task:OZ7KX5ZK6JH3FQKX2Y5KX7ZK4Y3V7Y3Y3Y3Y3Y3Y}
EOF
}

function start-dms-task() {
    if [ -z "$1" ]; then
        echo "Usage: start_dms_task <ReplicationTaskIdentifier>"
        echo "You can list DMS tasks using: dms-desc-rep-tasks"
        echo "Example: start_dms_task arn:aws:dms:us-east-1:123456789012:task:EXAMPLE"
        return 1
    fi
    local TASK_ID="$1"
    aws dms start-replication-task --replication-task-arn "$TASK_ID" --start-replication-task-type reload-target
}

function restart-dms-task() {
    if [ -z "$1" ]; then
        echo "Usage: restart_dms_task <ReplicationTaskIdentifier>"
        return 1
    fi
    local TASK_ID="$1"
    stop_dms_task "$TASK_ID"
    start_dms_task "$TASK_ID"
}

# Bash functions
function switch_aws_profile() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: switch_aws_profile <Dev|Prod>"
        return 1
    fi

    case "$1" in
        Dev)
            export AWS_PROFILE="DBA_Admin-Dev-254092030674"
            echo "Switched to AWS Profile: $AWS_PROFILE"
            ;;
        Prod)
            export AWS_PROFILE="DBA_Admin-502397910358"
            echo "Switched to AWS Profile: $AWS_PROFILE"
            ;;
        *)
            echo "Invalid option: $1"
            echo "Usage: switch_aws_profile <Dev|Prod>"
            return 1
            ;;
    esac
}

function switch_aws_region() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: switch_aws_region <east|west>"
        return 1
    fi

    case "$1" in
        east)
            export AWS_REGION="us-east-1"
            echo "Switched AWS_REGION to: $AWS_REGION"
            ;;
        west)
            export AWS_REGION="us-west-2"
            echo "Switched AWS_REGION to: $AWS_REGION"
            ;;
        *)
            echo "Invalid option: $1"
            echo "Usage: switch_aws_region <east|west>"
            return 1
            ;;
    esac
}

function switch_sqlnet() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: switch_sqlnet <dev03|uat03|sbx|prod|dr>"
        return 1
    fi

    case "$1" in
        dev03)
            #DEV03-SQLNET
            export USERNAME=admin
            export SQLNET_PASSWORD=${DEV03_SQLNET_PASSWORD}
            export TNS_ALIAS=DEV03_SQLNET
            ;;
        uat03)
            #UAT03-SQLNET
            export USERNAME=admin
            export SQLNET_PASSWORD=${UAT03_SQLNET_PASSWORD}
            export TNS_ALIAS=UAT03_SQLNET
            ;;
        sbx)
            #SBX-SQLNET
            export USERNAME=admin
            export SQLNET_PASSWORD=${SBX_SQLNET_PASSWORD}
            export TNS_ALIAS=SBX_SQLNET
            ;;
        prod)
            #PROD-SQLNET
            export USERNAME=admin
            export SQLNET_PASSWORD=${PROD_SQLNET_PASSWORD}
            export TNS_ALIAS=PROD_SQLNET
            ;;
        dr)
            #DR-SQLNET
            export USERNAME=admin
            export SQLNET_PASSWORD=${PROD_SQLNET_PASSWORD}
            export TNS_ALIAS=DR_SQLNET
            ;;
        *)
            echo "Invalid option: $1"
            echo "Usage: switch_aws_region <east|west>"
            return 1
            ;;
    esac
    alias splus='sqlplus ${USERNAME}/${SQLNET_PASSWORD}@${TNS_ALIAS}'
    echo "Use splus alias to connect"
}

function switch_pg() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: switch_pg <dev03-ods|dev03-rhdb|prod-dcm|prod-ods|prod-rhdb|uat03-ods|uat03-rhdb|dr-dcm|dr-ods|dr-rhdb>"
        return 1
    fi

    case "$1" in
        dev03-ods)
            export PGHOST=tfnraurora-pgdb-dev03.cluster-cfy5stnhchzz.us-east-1.rds.amazonaws.com
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            export PGPASSWORD=${DEV03_ODS_PGPASSWORD}
            ;;
        dev03-rhdb)
            export PGHOST=tfnr-pgdb-dev03rhdb-instance-1.cfy5stnhchzz.us-east-1.rds.amazonaws.com
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            export PGPASSWORD=${DEV03_RHDB_PGPASSWORD}
            ;;
        prod-dcm)
            export PGHOST=tfnr-prod-dcm-instance-1.c4oeaf4nqbcg.us-east-1.rds.amazonaws.com
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            export PGPASSWORD=${PROD_DCM_PGPASSWORD}
            ;;
        prod-ods)
            export PGHOST=tfnr-pgdb-prod-ods-instance-1.c4oeaf4nqbcg.us-east-1.rds.amazonaws.com
            export PGPASSWORD=${PROD_ODS_PGPASSWORD}
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            ;;
        prod-rhdb)
            export PGHOST=tfnr-pgdb-prod-rhdb-instance-1.c4oeaf4nqbcg.us-east-1.rds.amazonaws.com
            export PGPASSWORD=${PROD_RHDB_PGPASSWORD}
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            ;;
        dr-dcm)
            export PGHOST=tfnr-prod-dcm-dr-cluster-1.cluster-crtvx9xlnhos.us-west-2.rds.amazonaws.com
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            export PGPASSWORD=${DR_DCM_PGPASSWORD}
            ;;
        dr-ods)
            export PGHOST=tfnr-dr-ods-database-cluster-1.cluster-crtvx9xlnhos.us-west-2.rds.amazonaws.com
            export PGPASSWORD=${DR_ODS_PGPASSWORD}
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            ;;
        dr-rhdb)
            export PGHOST=tfnr-dr-rhdb-database-cluster-1.cluster-crtvx9xlnhos.us-west-2.rds.amazonaws.com
            export PGPASSWORD=${DR_RHDB_PGPASSWORD}
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            ;;
        uat03-ods)
            export PGHOST=tfnr-aurorapgdb-uat03-instance-1.cfy5stnhchzz.us-east-1.rds.amazonaws.com
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            export PGPASSWORD=${UAT03_ODS_PGPASSWORD}
            ;;
        uat03-rhdb)
            export PGHOST=tfnr-aurorapgdb-uat03-rhdb-instance-1.cfy5stnhchzz.us-east-1.rds.amazonaws.com
            export PGPORT=5432
            export PGDATABASE=postgres
            export PGUSER=postgres
            export PGPASSWORD=${UAT03_RHDB_PGPASSWORD}
            ;;
        *)
            echo "Invalid option: $1"
            echo "Usage: switch_pg <dev03-ods|dev03-rhdb|prod-dcm|prod-ods|prod-rhdb|uat03-ods|uat03-rhdb>"
            return 1
            ;;
    esac
    echo;echo
    echo "PGHOST is set to:     ${PGHOST}"
    echo "PGPORT is set to:     ${PGPORT}"
    echo "PGDATABASE is set to: ${PGDATABASE}"
    echo "PGUSER is set to:     ${PGUSER}"
    echo;echo
    psql -c "\conninfo"
    echo;echo
    echo "Use psql to connect"
}

function connect_ec2() {
    if [ -z "$1" ]; then
        echo "Usage: connect_ec2 <instance-id>"
        echo "If you are looking for DMS EC2s, here they are:"
        list_ec2_instances  | grep -i dms
        return 1
    fi

    local INSTANCE_ID="$1"
    
    echo "Connecting to EC2 instance: $INSTANCE_ID via SSM..."
    
    aws ssm start-session --target "$INSTANCE_ID"

    if [ $? -ne 0 ]; then
        echo "Failed to start session. Ensure the instance is running and has SSM enabled."
        return 1
    fi
}

function ec2_connect() {
    echo "Available EC2 instances:"
    list_ec2_instances | egrep 'i-03cebdfe91bc55e6f|i-030980ccbda36e97b' | awk '{print $2" "$6}' | awk '{print NR ") " $0}' | grep -v '^$'
    
    echo
    read -p "Enter the number of the EC2 instance to connect: " CHOICE

    INSTANCE_ID=$(list_ec2_instances | egrep 'i-03cebdfe91bc55e6f|i-030980ccbda36e97b' | awk '{print $2}' | grep -v '^$' | sed -n "${CHOICE}p")

    if [ -z "$INSTANCE_ID" ]; then
        echo "Invalid selection."
        return 1
    fi

    echo "Connecting to EC2 instance: $INSTANCE_ID via SSM..."
    aws ssm start-session --target "$INSTANCE_ID"

    if [ $? -ne 0 ]; then
        echo "Failed to start session. Ensure the instance is running and has SSM enabled."
        return 1
    fi
}

function list_ec2_instances() {
    if [ -z "$AWS_PROFILE" ]; then
        echo "Please set the AWS_PROFILE environment variable before running this command."
        return 1
    fi
    echo "Listing EC2 instances in profile: $AWS_PROFILE"
    aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key=='Name'].Value | [0]]" --output table
}

function list_rds_clusters() {
    if [ -z "$AWS_PROFILE" ]; then
        echo "Please set the AWS_PROFILE environment variable before running this command."
        return 1
    fi
    echo "Listing RDS clusters in profile: $AWS_PROFILE"
    aws rds describe-db-clusters --query "DBClusters[*].[DBClusterIdentifier,Status,Engine,EngineVersion,Endpoint]" --output table
}

function list_rds_instances() {
    if [ -z "$AWS_PROFILE" ]; then
        echo "Please set the AWS_PROFILE environment variable before running this command."
        return 1
    fi
    echo "Listing RDS instances in profile: $AWS_PROFILE"
    aws rds describe-db-instances --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,DBInstanceStatus,Endpoint.Address]" --output table
}

function display_monitoring_mode_for_rds () {
    if [ -z "$1" ]; then
        echo "Usage: display_monitoring_mode_for_rds <DBInstanceIdentifier>"
        return 1
    fi

    #local DB_INSTANCE_ID="$1"
    local DB_CLUSTER_ID="$1"
    
    echo "Displaying monitoring mode for RDS cluster: $DB_CLUSTER_ID"
    
    #aws rds describe-db-instances \
  #--query "DBInstances[?DBClusterIdentifier=='${DB_CLUSTER_ID}'].[DBInstanceIdentifier, MonitoringInterval]" \
  #--output table

    aws rds describe-db-instances \
    --query "DBInstances[?DBClusterIdentifier=='${DB_CLUSTER_ID}'].[DBInstanceIdentifier, MonitoringInterval, MonitoringRoleArn, Engine, AvailabilityZone, Endpoint.Address ]" \
    --output table


    # Get the writer's actual instance ID
    WRITER_ID=$(aws rds describe-db-clusters \
    --db-cluster-identifier "$CLUSTER_ID" \
    --query "DBClusters[0].DBClusterMembers[?IsClusterWriter==\`true\`].DBInstanceIdentifier" \
    --output text)

    aws rds describe-db-instances \
  --query "DBInstances[?DBClusterIdentifier=='$DB_CLUSTER_ID'].[DBInstanceIdentifier, MonitoringInterval, MonitoringRoleArn]" \
  --output json | jq -r --arg WRITER "$WRITER_ID" '
    .[] | 
    "\(.0)\t" + 
    (if .0 == $WRITER then "Writer" else "Reader" end) + "\t" + 
    "Interval: \(.1)\tRole: \(.2)"
  '

}

function aurora_display_engine_version() {
    if [ -z "$1" ]; then
        echo "Usage: aurora_display_engine_version <DBClusterIdentifier>"
        return 1
    fi

    local DB_CLUSTER_ID="$1"
    
    echo "Displaying engine version for Aurora cluster: $DB_CLUSTER_ID"
    
    aws rds describe-db-clusters \
    --db-cluster-identifier "$DB_CLUSTER_ID" \
    --query "DBClusters[0].[Engine, EngineVersion]" \
    --output table
}

function aurora_display_engine_versions_all() {
    echo "Displaying engine versions for all Aurora clusters"
    
    set -x
    aws rds describe-db-clusters \
    --query "DBClusters[*].[DBClusterIdentifier, Engine, EngineVersion]" \
    --output table
    set +x
}

function aurora_display_full_engine_versions_all() {
    echo "Displaying full engine versions (including minor) for all Aurora clusters"
    
    set -x
    aws rds describe-db-clusters \
    --query "DBClusters[*].[DBClusterIdentifier, Engine, EngineVersion, DBClusterParameterGroup, DBSubnetGroup, VpcId, EngineVersion]" \
    --output table
    set +x
}   

function aurora_display_last_onehour_events() {
    if [ -z "$1" ]; then
        echo "Usage: aurora_display_last_onehour_events <DBClusterIdentifier>"
        aurora_list_all_clusters
        return 1
    fi

    local DB_CLUSTER_ID="$1"
    
    echo "Displaying events from the last hour for Aurora cluster: $DB_CLUSTER_ID"
    
    aws rds describe-events \
    --source-identifier "$DB_CLUSTER_ID" \
    --source-type db-cluster \
    --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)" \
    --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --query "Events[].[Date, Message]" \
    --output table
}   

function aurora_list_all_clusters() {
    echo "Listing all Aurora clusters"
    
    aws rds describe-db-clusters \
    --query "DBClusters[*].[DBClusterIdentifier, Status, Engine, EngineVersion, Endpoint]" \
    --output table
}  
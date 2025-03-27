# SSO Authentication
alias login_to_dev='aws sso login --profile DBA_Admin-502397910358'
alias login_to_prod='aws sso login --profile DBA_Admin-Dev-254092030674'

# AWS DMS
alias dms-desc-rep-tasks='aws dms describe-replication-tasks --query "ReplicationTasks[*].[ReplicationTaskIdentifier,ReplicationTaskArn,Status]" --output table'

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


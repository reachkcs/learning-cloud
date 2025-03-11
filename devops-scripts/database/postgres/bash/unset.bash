#!/bin/bash -x
unset PGPASSWORD
unset PGUSER_PROD_USER
unset PGUSER_STAGE_RO_USER
export PGHOST=localhost
export PG_STAGING_DB=dnom

#!/bin/bash
. ~/.bashrc
psql -c "select create_next_month_partition_user_interactions();"
#psql -c "select now()"

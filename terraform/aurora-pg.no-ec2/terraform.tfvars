vpc_id     = "vpc-08e3da5bcd04d8dc7"
primary_subnet_group = "tfnrdev-pgsql"

secondary_vpc_id = "vpc-09700fc7fa4a222f7"
secondary_subnet_group = "tfnrstg-pgsql"

# PG related
parameter_group = "pg16-cluster"
global_cluster_identifier = "test-aurora-pg-global-cluster"
primary_cluster_identifier = "test-aurora-pg-cluster-primary"
secondary_cluster_identifier = "test-aurora-pg-cluster-secondary"
primary_instance_identifier = "aurora-pg-instance-primary"
secondary_instance_identifier = "aurora-pg-instance-secondary"
instance_class = "db.r5.large"
database_name = "testdb"
master_username = "aurora_admin"
master_password = "SuperSecurePass123"
primary_pg_sec_grp = "sg-0be5594a7a6bcc133"
secondary_pg_sec_grp = "sg-0e45191b73ed7a914"
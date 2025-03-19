#!/bin/bash
. ~ec2-user/.bashrc
# Install required packages
sudo yum install -y postgresql16-16.8-1.amzn2023.0.1.x86_64
sudo yum install -y postgresql16-contrib-16.8-1.amzn2023.0.1.x86_64
sudo yum install -y git-2.47.1-1.amzn2023.0.2.x86_64
sudo yum install -y telnet-1:0.17-83.amzn2023.0.2.x86_64


# Configure .bashrc for PG connectivity
echo '# Postgres details' >> ~ec2-user/.bashrc
echo 'export PGHOST=<primary cluster end point>' >> ~ec2-user/.bashrc
echo 'export PGUSER=aurora_admin' >> ~ec2-user/.bashrc
echo 'export PGPASSWORD=SuperSecurePass123' >> ~ec2-user/.bashrc
echo 'export PGDATABASE=mydatabase' >> ~ec2-user/.bashrc
echo 'export PGPORT=5432' >> ~ec2-user/.bashrc
. ~/.bashrc

# Set up PG Bench with sample data
createdb pgbench_test
pgbench -i -s 10 pgbench_test
psql -d pgbench_test -c "\dt"
# Command to run perf test
# pgbench -c 10 -j 2 -T 60 pgbench_test
# -c 10 → 10 concurrent clients
# -j 2 → 2 worker threads
# -T 60 → Run the test for 60 seconds

# Setup Northwind database
# Download Northwind database
git clone https://github.com/pthom/northwind_psql.git
cd northwind_psql
createdb northwind
psql -d northwind -f northwind.sql
psql -d northwind -c "\dt"

# Setup DVDRental sample data
mkdir dvdrental
cd dvdrental
wget https://neon.tech/postgresqltutorial/dvdrental.zip
unzip dvdrental.zip 
createdb dvdrental
pg_restore -U aurora_admin -d dvdrental dvdrental.tar
psql -d dvdrental -c "\dt"
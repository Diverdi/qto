#!/bin/bash

run_unit_bash_dir=$(perl -e 'use File::Basename; use Cwd "abs_path"; print dirname(abs_path(@ARGV[0]));' -- "$0")
cd $run_unit_bash_dir ; for i in {1..5} ; do cd .. ; done ;
export postgres_install_proj_dir=`pwd`

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# add the PostgreSQL's repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main"' \
   > /etc/apt/sources.list.d/pgdg.list

# add the most basic binaries
apt-get clean && apt-get update && apt-get install -f -y postgresql-server-dev-11 postgresql-client-11 postgresql-contrib-11

## ensure the postresql starts on boot 
sudo update-rc.d postgresql enable

# add the required binaries
apt-get clean && apt-get update && apt-get install -y perl net-tools exuberant-ctags mutt curl wget libwww-curl-perl libtest-www-selenium-perl libdbd-pgsql libxml-atom-perl git vim libxml-atom-perl tar gzip graphviz python-selenium chromium-chromedriver python-selenium python-setuptools python-dev build-essential gpgsm nodejs lsof libssl-dev 
apt-get clean && apt-get update


mkdir -p /etc/postgresql/11/main/
mkdir -p /var/lib/postgresql/11/main

echo "postgres:postgres" | chpasswd
echo 'export PS1="`date "+%F %T"` \u@\h  \w \\n\\n  "' >> /var/lib/postgresql/.bashrc


## add the uuid generation capability enabling extensions
/etc/init.d/postgresql restart
sudo -u postgres psql -c "CREATE USER usrqtoadmin WITH SUPERUSER CREATEROLE CREATEDB REPLICATION BYPASSRLS PASSWORD 'usrqtoadmin';"
sudo -u postgres psql -c "grant all privileges on database postgres to usrqtoadmin ;"
sudo -u postgres createdb -O postgres postres
sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "pgcrypto";'
sudo -u postgres psql template1 -c 'CREATE EXTENSION IF NOT EXISTS "dblink";' 

chmod 777 $postgres_install_proj_dir/cnf/hosts/host-name/etc/postgresql/11/main/pg_hba.conf
chmod 777 $postgres_install_proj_dir/cnf/hosts/host-name/etc/postgresql/11/main/postgresql.conf

sudo -Eu postgres bash -c 'cp -v $postgres_install_proj_dir/cnf/hosts/host-name/etc/postgresql/11/main/pg_hba.conf /etc/postgresql/11/main/pg_hba.conf'
sudo -Eu postgres bash -c 'cp -v $postgres_install_proj_dir/cnf/hosts/host-name/etc/postgresql/11/main/postgresql.conf /etc/postgresql/11/main/postgresql.conf'

chmod 755 $postgres_install_proj_dir/cnf/hosts/host-name/etc/postgresql/11/main/pg_hba.conf
chmod 755 $postgres_install_proj_dir/cnf/hosts/host-name/etc/postgresql/11/main/postgresql.conf

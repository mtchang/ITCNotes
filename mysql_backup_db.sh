#!/bin/bash
# ---------------------------------------------------------
# make dblist.txt
# echo 'SHOW DATABASES' | mysql -u dbuser -h localhost -p > backup_dblist.txt
# 
# to backup mysql dbase ,account and password
DBLIST=$(grep -v '#' mysql_backup_dblist.txt)
dbuser='DBUSER'
dbpassword='DBPASSWD'
dbhost='127.0.0.1'

D='/home/backup/mysql_db/'$(date +%Y%m%d%H%M)

for db in $DBLIST
do
	echo "* RUN $db backup in $D "
	echo "mysqldump -h ${dbhost} -u ${dbuser} -p${dbpassword} --database ${db} > ${D}_${db}.sql"
	echo "mysqldump -h ${dbhost} -u ${dbuser} -p${dbpassword} --database ${db} > ${D}_${db}.sql" | sh
	echo "bzip2 -z  ${D}_${db}.sql"
	echo "bzip2 -z  ${D}_${db}.sql" | sh
done

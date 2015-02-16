[root@mail pgsql_db]# cat pgsql_backup_db.sh 
#!/bin/bash
# to backup mysql dbase ,account and password
DBLIST=$(grep -v '#' pgsql_backup_dblist.txt)
dbuser='DBUSER'
dbpassword='DBPASSWD'
dbhost='127.0.0.1'
PGPASSWORD=$dbpassword
export PGPASSWORD

D='/home/backup/pgsql_db/'$(date +%Y%m%d%H%M)

for db in $DBLIST
do
	echo "* RUN $db backup in $D "
	echo "pg_dump -h ${dbhost} -U ${dbuser} -w -d ${db} -f ${D}_${db}.sql"
	echo "pg_dump -h ${dbhost} -U ${dbuser} -w -d ${db} -f ${D}_${db}.sql" | sh
	echo "bzip2 -z  ${D}_${db}.sql"
	echo "bzip2 -z  ${D}_${db}.sql" | sh
done

#!/bin/bash
#
# 備份 MYSQL 資料庫
#
D=$(date +%Y%m%d%s)
DBuser="資料庫使用者"
DBpassword="密碼"
DBname="資料庫"
DBhost="主機位置localhost"
echo "backup to ${DBname}_${D}.sql"
echo "mysqldump -h ${DBhost} -u ${DBuser} -p${DBpassword} --database ${DBname} > ${DBname}_${D}.sql" | sh
echo "bzip2 -z ${DBname}_${D}.sql" | sh

# 執行
# [aacsb@cm backup]$ sh sqlbak.sh 
# backup to aacsb_survey_201405231400812494.sql

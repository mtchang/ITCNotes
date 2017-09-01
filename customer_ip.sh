#!/bin/bash
# 編輯網址 , google doc 權限設定控制
# https://docs.google.com/spreadsheets/d/1qMVai-0cjBNDbh3HhpOl2PfhD6XONtiDBbuBzWJ4TfE/edit#gid=0
# 將 google doc 白名單取出成為 csv
URL="https://docs.google.com/spreadsheets/d/1qMVai-0cjBNDbh3HhpOl2PfhD6XONtiDBbuBzWJ4TfE/pub?gid=0&single=true&output=csv"
echo "w3m -dump '${URL}' > whitelist.csv" | sh

# 備份原本的白名單
mv -f customer_ip customer_ip.bak
echo "# $(date -R) update." > customer_ip
# 去除註解
grep -v '#' "whitelist.csv" > tmp_file
# 取行數
max=$(wc -l tmp_file  | cut -f1 -d" ")
for i in `seq 1 $max`
do
    line=$(awk "NR==${i}" tmp_file)
    action=$(echo $line | cut -d, -f1)
    cidr=$(echo $line | cut -d, -f2)
    echo "${action} ${cidr};" >> customer_ip
done
echo "allow 10.80.0.0/16;" >> customer_ip
echo "allow 192.168.0.0/16;" >> customer_ip
echo "deny all;" >> customer_ip
rm -f tmp_file
#rm -f whitelist.csv

# nginx 重新啟動
# run in /etc/nginx/conf.d
echo "restart NGINX service"
systemctl reload nginx
# return
echo "OK! Done. csv URL in ${URL} ";
# 
echo "# $(date -R) update." >> customer_ip
tail customer_ip -n 10

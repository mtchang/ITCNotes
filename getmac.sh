#/bin/bash
# use arp -an get mac and write to ip

# use nmap get arp cache
# 透過 nmap 掃描區域網路, 並且建立本機的 ARP cache
echo 'scanning 192.168.1.0/24 ....'
nmap -v -sP 192.168.1.0/24 >> nmap.txt

# arp cache to arp.txt
# 取得本機得 ARP cache 資訊, 收集網路上的 mac address
echo 'get mac address ....'
arp -an > arp.txt

# filte source date
# cat arp.txt  | tr -d 'ether:()' | grep -E '[0-9a-fA-F]{12}' | tr ' ' '-'  > arpa.txt
# 將 arp 資料分析, 準備成為可以取用得資料
cat arp.txt  | tr -d 'thr:()' | grep -v 'incomp' | tr ' ' '-'  > arpa.txt

# generanel sql.txt
# 產生 sql.txt 的敘述句, 用 mysql command 指令寫入資料庫內
rm -f sql.txt
for line in $(cat arpa.txt)
do
	# echo $line
 	ip=$(echo $line | cut -f2 -d'-')
	mac=$(echo $line | cut -f4 -d'-')
	# echo $ip,$mac
	notes=''
	echo "INSERT INTO nms_ipmac ( no, time, ip, mac, notes) VALUES (NULL, CURRENT_TIMESTAMP, '$ip', '$mac', '$notes');" >> sql.txt
done

# write to sql
# 整批把資料庫塞進去 DB
echo 'write to sql .....'
echo "mysql --user=username --password=mysqlpassword  dbmysql < sql.txt " | bash
echo 'ok done.'

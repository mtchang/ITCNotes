#!/bin/bash
# linux firewall rule sample
# 2013.jul.18
EXTIF="br0"              	# 這個是可以連上 Public IP 的網路介面
INIF=""              		# 內部 LAN 的連接介面
INNET="192.168.188.0/24"    	# 若無內部網域介面
DMZ1="192.117.64.0/20"		# DMZ 1 
DMZ2="192.254.0.0/16"		# DMZ 2 
SRVHOST="192.117.69.188"	# SERVER IP
		
export EXTIF INIF INNET DMZ1 DMZ2 SRVHOST

# cleaner rule and set default
iptables -F
iptables -X
iptables -Z
iptables -P INPUT   ACCEPT
iptables -P OUTPUT  ACCEPT
iptables -P FORWARD ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s $SRVHOST -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT


# log for debug
# iptables -A INPUT -p TCP -i $EXTIF -j LOG

# 允許服務的進入依自己的環境開啟
iptables -A INPUT -p TCP -i $EXTIF --dport  67  --sport 1024:65534 -j ACCEPT # DHCPD
iptables -A INPUT -p UDP -i $EXTIF --dport  67  --sport 1024:65534 -j ACCEPT # DHCPD
iptables -A INPUT -p TCP -i $EXTIF --dport  21  --sport 1024:65534 -j ACCEPT # FTP
iptables -A INPUT -p TCP -i $EXTIF --dport  22  --sport 1024:65534 -j ACCEPT # SSH
iptables -A INPUT -p TCP -i $EXTIF --dport  25  --sport 1024:65534 -j ACCEPT # SMTP
iptables -A INPUT -p UDP -i $EXTIF --dport  53  --sport 1024:65534 -j ACCEPT # DNS
iptables -A INPUT -p TCP -i $EXTIF --dport  53  --sport 1024:65534 -j ACCEPT # DNS
iptables -A INPUT -p UDP -i $EXTIF --dport  161 --sport 1024:65534 -j ACCEPT # snmpd
iptables -A INPUT -p TCP -i $EXTIF --dport  161 --sport 1024:65534 -j ACCEPT # snmpd
# iptables -A INPUT -p TCP -i $EXTIF --dport  80  --sport 1024:65534 -j ACCEPT # httpd
iptables -A INPUT -p TCP -i $EXTIF --dport 3128 --sport 1024:65534 -j ACCEPT # proxy
iptables -A INPUT -p TCP -i $EXTIF --dport 443  --sport 1024:65534 -j ACCEPT # samba
iptables -A INPUT -p TCP -i $EXTIF --dport 445  --sport 1024:65534 -j ACCEPT # samba
iptables -A INPUT -p TCP -i $EXTIF --dport 139  --sport 1024:65534 -j ACCEPT # samba
iptables -A INPUT -p TCP -i $EXTIF --dport 138  --sport 1024:65534 -j ACCEPT # samba
iptables -A INPUT -p TCP -i $EXTIF --dport 111  --sport 1024:65534 -j ACCEPT # samba
# iptables -A INPUT -p TCP -i $EXTIF --dport 1723 --sport 1024:65534 -j ACCEPT # pptpd

# DMZ1 限制部分區域的連入 tcp wrapper 不支援的, 用 iptables 限制登入者
iptables -A INPUT -p TCP -s $DMZ1 --dport 1723 --sport 1024:65534 -j ACCEPT # pptpd
iptables -A INPUT -p TCP -s $DMZ1 --dport 995  --sport 1024:65534 -j ACCEPT # dovecot
iptables -A INPUT -p TCP -s $DMZ1 --dport 993  --sport 1024:65534 -j ACCEPT # dovecot
iptables -A INPUT -p TCP -s $DMZ1 --dport 110  --sport 1024:65534 -j ACCEPT # dovecot
iptables -A INPUT -p TCP -s $DMZ1 --dport 143  --sport 1024:65534 -j ACCEPT # dovecot
iptables -A INPUT -p TCP -s $DMZ1 --dport 3306 --sport 1024:65534 -j ACCEPT # mysql
iptables -A INPUT -p TCP -s $DMZ1 --dport 3690 --sport 1024:65534 -j ACCEPT # svnd
iptables -A INPUT -p UDP -s $DMZ1 --dport 123  --sport 1024:65534 -j ACCEPT # ntpd
iptables -A INPUT -p TCP -s $DMZ1 --dport 514  --sport 1024:65534 -j ACCEPT # rsyslogd
iptables -A INPUT -p TCP -s $DMZ1 --dport 631  --sport 1024:65534 -j ACCEPT # cupsd 
iptables -A INPUT -p TCP -s $DMZ1 --dport 5432  --sport 1024:65534 -j ACCEPT # postgresql

# DMZ2
iptables -A INPUT -p TCP -s $DMZ2 --dport 3389 --sport 1024:65534 -j ACCEPT # xrdp
iptables -A INPUT -p TCP -s $DMZ2 --dport 1723 --sport 1024:65534 -j ACCEPT # pptpd

# REJECT ALL
iptables -A INPUT -p TCP -i $EXTIF -j LOG 
iptables -A INPUT -p TCP -i $EXTIF -j REJECT  
# ALL EXTIF reject


# clean NAT table rule
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat
iptables -t nat -P PREROUTING  ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -P OUTPUT      ACCEPT

# nat
iptables -t nat -A POSTROUTING -s $INNET -o $EXTIF -j MASQUERADE
iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1300:1536 -j TCPMSS --clamp-mss-to-pmtu


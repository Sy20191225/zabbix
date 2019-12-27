#!/bin/bash
# init zabbix_agent server_ip|proxy_ip

ServerIP="${1}"

usage() {
    cat <<EOF
usage: $(basename $0) zabbix_server_ip|proxy_ip
EOF
}

if [ -z "${ServerIP}" ]; then
    read -p "请输入zabbix server | proxy 的IP地址：" ServerIP
fi

check_ip() {
    IP=$1
    VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
    if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
        if [ ${VALID_CHECK:-no} == "yes" ]; then
            echo "server ip is: $IP "
        else
            echo "server ip $IP not available!"
            usage; exit 1;
        fi
    else
        echo "server ip format error!"
        usage; exit 1;
    fi
}

check_ip ${ServerIP}

is_root() {
    [ "x`whoami`" = 'xroot' ] && return 0
    return 1
}

is_root || { echo "only root can init env! Abort."; exit 1; }

yumserver() {
    yum -y update >/dev/null 2>&1
    yum install -y git epel-release vim sysstat telnet \
                   curl wget salt-minion ntpdate gcc \
      		       gcc-c++ autoconf automake zlib \
      		       zlib-devel openssl openssl-devel \
      		       pcre pcre-devel net-snmp-devel \
      		       libevent-devel unzip zip >/dev/null 2>&1
}

if [ -d "/srv/zabbix-agent" ]; then
    rn -rf /srv/zabbix-agent
fi;

yumserver

cd /srv
wget https://github.com/Sy20191225/zabbix-agent/archive/master.zip -O zabbix-agent.zip -q
unzip -q zabbix-agent.zip
mv zabbix-agent-master zabbix-agent
chown -R zabbix:zabbix /srv/zabbix-agent
cd /srv/zabbix-agent
/bin/sh /srv/zabbix-agent/env-setup.agent $IP
rm -f /srv/zabbix-agent.zip

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
    yum install -y git wget unzip zip >/dev/null 2>&1
}

if [ -d "/srv/zabbix-agent" ]; then
    rm -rf /srv/zabbix-agent
fi;

echo -e "\033[38m --- $(date "+%Y-%m-%d %H:%M:%S") 检查系统是否安装git wget unzip zip包...\033[0m"
yumserver

cd /srv
echo -e "\033[38m --- $(date "+%Y-%m-%d %H:%M:%S") 正在下载zabbix-agent服务包...\033[0m"
wget https://github.com/Sy20191225/zabbix-agent/archive/master.zip -O zabbix-agent.zip -q
unzip -q zabbix-agent.zip
mv zabbix-agent-master zabbix-agent
#chown -R zabbix:zabbix /srv/zabbix-agent
cd /srv/zabbix-agent
echo -e "\033[38m --- $(date "+%Y-%m-%d %H:%M:%S") 正在执行初始化脚本env-setup.agent $ServerIP...\033[0m"
/bin/sh /srv/zabbix-agent/env-setup.agent $ServerIP
echo -e "\033[38m --- $(date "+%Y-%m-%d %H:%M:%S") 正在删除zabbix-agent.zip压缩包...\033[0m"
rm -f /srv/zabbix-agent.zip

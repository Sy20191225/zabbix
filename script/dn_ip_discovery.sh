#!/bin/bash

data_file="/srv/zabbix-agent/var/yotta_Node_ip.status"
ip_discovery_file="/srv/zabbix-agent/var/yottaNode_ip_discovery.status"

true > ${ip_discovery_file}

cat ${data_file} | while read line
do
    ip_info=( ${line} )
    if [ ${ip_info[0]} -ge 20 ]; then
       echo ${ip_info[1]} >> ${ip_discovery_file}
    fi
done

chown zabbix.zabbix ${ip_discovery_file}

ipline=($(cat ${ip_discovery_file}))
length=${#ipline[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
    printf '\n\t\t{'
    printf "\"{#IP_LINE}\":\"${ipline[$i]}\"}"
    if [ $i -lt $[$length-1] ];then
    printf ','
    fi
done
printf  "\n\t]\n"
printf "}\n"


#!/bin/bash

data_var="/srv/zabbix-agent/var"
mongo_home="/app/mongodb-4.0.10"

${mongo_home}/bin/mongoexport -h 127.0.0.1 -d yotta -c Node -o ${data_var}/yotta_Node.json &>/dev/null

cat ${data_var}/yotta_Node.json |grep '"status":1' | grep '"valid":1' |awk -F'/' '{print $3}'|sort|uniq -c|sort -nr > ${data_var}/yotta_Node_ip.status

chown zabbix.zabbix ${data_var}/yotta_Node.json
chown zabbix.zabbix ${data_var}/yotta_Node_ip.status


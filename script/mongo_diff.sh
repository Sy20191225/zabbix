#!/bin/bash
#这个脚本是监控主备mongo Node表数量是否一致的
#需要获取主节点ip

mosk="/root/mongoshake/collector.conf"
[ -f "${mosk}" ] || exit 0

pronum=`ps -ef|grep collector|egrep -v 'grep|zabbix'|wc -l`
[ ${pronum} -eq 0 ] && exit 0

m_node_ip=`cat ${mosk}|egrep -v "^#|^$"|grep "mongo_urls"|awk -F'[:/ ]' '{print $6}'`

m_node_count=`mongo ${m_node_ip}/yotta --eval "db.Node.count()"|tail -1`
b_node_count=`mongo 127.0.0.1/yotta --eval "db.Node.count()"|tail -1`
diff_num=`expr ${m_node_count} - ${b_node_count}`

echo "${diff_num}"


#!/bin/bash
#usage:
#sh mongodb.sh

mongodb_log_content() {
    PORT="${1}"
    date_stamp=`date -d "-5min" +%H:%M:%S`
    day_stamp=`date +%Y-%m-%d`
    LOG_FILE="/srv/zabbix-agent/var/mongodblog${PORT}.stats"
    MongoDBLOG="/app/mongodb/log/mongo.log"
    awk -F '[T .]' -vnstamp="$date_stamp" -vdstamp="$day_stamp" '$2>=nstamp && $1==dstamp' ${MongoDBLOG} > ${LOG_FILE}
    chown zabbix.zabbix ${LOG_FILE}
}
netstat -tnlp|awk '/LISTEN/ && /mongod\>/ {print $4}'|awk -F':' '{print $2}'|while read LINE
do
    echo "the port is $LINE";
    mongodb_log_content ${LINE};
done;

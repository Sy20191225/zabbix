#!/bin/bash
### 监控主网单个ip矿机活跃性

mongo_home="/app/mongodb-4.0.10"

IP_LINE=$1

activeminer_num=$(${mongo_home}/bin/mongo 127.0.0.1/yotta --eval "db.Node.count({status:1,valid:1,assignedSpace:{\$gt: 0},addrs:"/^.*${IP_LINE}.*$/", quota: {\$gt: 0},timestamp:{\$gt: NumberInt(new Date().getTime()/1000)-180}})" |tail -1)

echo ${activeminer_num}


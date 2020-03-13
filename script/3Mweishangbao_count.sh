count=`/app/mongodb-4.0.10/bin/mongo  127.0.0.1/yotta --eval "db.Node.count({timestamp:{\\$lt: NumberInt(new Date().getTime()/1000)-180}})"|tail -1`
echo "$count"


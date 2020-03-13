count=`/app/mongodb-4.0.10/bin/mongo  127.0.0.1/yotta --eval "db.SpotCheck.count({"status":1})"|tail -1`
echo "$count"


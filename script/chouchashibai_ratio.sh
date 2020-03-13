count1=`/app/mongodb-4.0.10/bin/mongo  127.0.0.1/yotta --eval "db.SpotCheck.count({"status":1})"|tail -1`
count2=`curl -s http://127.0.0.1:8082/statistics |awk -F':' '{print $6}' |awk -F',' '{print $1}'`
ratio=$(echo "scale=3;$count1/$count2"|bc)
echo "$ratio"


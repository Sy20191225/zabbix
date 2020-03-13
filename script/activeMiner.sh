#!/bin/bash
### 查看主网矿机数

for((i=0;i<=20;i++))
do
    sn_node=$(echo $i|egrep "^[0-9]{2}$")
    if [ -z "${sn_node}" ]; then
        eff="0$i"
    else
        eff=$i
    fi;

    link="curl -I -m 2 -o /dev/null -s -w %{http_code} http://sn${eff}.yottachain.net:8082/statistics"
    status_code=$(eval ${link})

    if [ ${status_code} -eq 200 ]; then
        amlink="curl -s http://sn${eff}.yottachain.net:8082/statistics|awk -F'[: ,]' '{print \$10}'"
        break;
    fi;

done

eval "${amlink}"

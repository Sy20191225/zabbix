#!/bin/bash
#usage:
#sh mongodb_database_discovery.sh

#mongodb 数据库信息
DATABASE=( yotta metabase )

LENDATABASE=${#DATABASE[@]}

printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<${LENDATABASE};i++))
do
    printf '\n\t\t{'
    printf "\"{#DATABASE_NAME}\":\"${DATABASE[$i]}\"}"
    if [ $i -lt $[${LENDATABASE}-1] ];then
        printf ','
    fi
done
printf  "\n\t]\n"
printf "}\n"

#!/bin/bash
count=`curl -s -X POST --url http://127.0.0.1:8888/v1/db_size/get|awk -F ':' '{print $2}' |tr -cd "[0-9]"`
count_m=`expr $count / 1048576`
echo "$count_m"

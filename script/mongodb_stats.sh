#!/bin/bash
#usage:
#sh mongodb_stats.sh <METRIC> <METHOD> <PORT>

source /srv/zabbix-agent/script/fun_check_stat_file.sh

METRIC="$1"
METHOD="$2"
HOSTNAME=127.0.0.1
PORT="${3:-27017}"

STAT_FILE="/srv/zabbix-agent/var/mongodb${PORT}.stats"
CHECK_STAT_FILE_FLAG=`fun_check_stat_file ${STAT_FILE} 120`;

if [ ${CHECK_STAT_FILE_FLAG} -ne 1 ] ;then
    exit;
fi;

case ${METRIC} in
    opcountersRepl)
    if [ ${METHOD} = "insert" ];then
        eval cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "insert"|awk '{print $3}'|sed 's/,//'

    elif [ ${METHOD} = "query" ];then
        eval cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "query"|awk '{print $3}'|sed 's/,//'

    elif [ ${METHOD} = "update" ];then
        eval cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "update"|awk '{print $3}'|sed 's/,//'
        
    elif [ ${METHOD} = "delete" ];then
        eval cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "delete"|awk '{print $3}'|sed 's/,//'
        
    elif [ ${METHOD} = "getmore" ];then
        eval cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "getmore"|awk '{print $3}'|sed 's/,//'
        
    elif [ ${METHOD} = "command" ];then
        eval cat ${STAT_FILE}|grep -A 7 "opcountersRepl"|grep "command"|awk '{print $3}'|sed 's/,//'
        
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {opcountersRepl insert|opcountersRepl query|opcountersRepl update|opcountersRepl delete|opcountersRepl getmore|opcountersRepl command}\033[0m"
t 1
    fi
    ;;
    
    connections)
    if [ ${METHOD} = "current" ];then
        # 当前的连接
        eval cat ${STAT_FILE}|grep -A 5 "connections"|grep "current"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "available" ];then
        # 可用连接
        eval cat ${STAT_FILE}|grep -A 5 "connections"|grep "available"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "totalCreated" ];then
        # 所有创建过的连接
        eval cat ${STAT_FILE}|grep -A 5 "connections"|grep "totalCreated"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {connections current|connections available|connections totalCreated}\033[0m"
        exit 1
    fi
    ;;
    
    activeClients)
    if [ ${METHOD} = "total" ];then
        # 所有活动客户端
        eval cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "activeClients"|grep "total"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "readers" ];then
        # 所有读操作的客户端个数
        eval cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "activeClients"|grep "readers"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "writers" ];then
        # 所有写操作的客户端个数
        eval cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "activeClients"|grep "writers"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {activeClients total|activeClients readers|activeClients writers}\033[0m"
        exit 1
    fi
    ;;
    
    globalLock)
    if [ ${METHOD} = "totalTime" ];then
        # 创建全局锁现在的时间（毫秒）
        eval cat ${STAT_FILE}|grep -A 12 "globalLock"|grep "totalTime"|awk '{print $3}'|awk -F '"' '{print $2}'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {globalLock totalTime}\033[0m"
        exit 1
    fi
    ;;
    
    # 文档指标，反映文档插入删除操作
    document)
    if [ ${METHOD} = "deleted" ];then
        eval cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "deleted"|awk -F '(' '{print $2}'|sed 's/),//'
        
    elif [ ${METHOD} = "inserted" ];then
        eval cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "inserted"|awk -F '(' '{print $2}'|sed 's/),//'
        
    elif [ ${METHOD} = "returned" ];then
        eval cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "returned"|awk -F '(' '{print $2}'|sed 's/),//'
        
    elif [ ${METHOD} = "updated" ];then
        eval cat ${STAT_FILE}|grep -A 300 "metrics"|grep -A 5 "document"|grep "updated"|awk -F '(' '{print $2}'|sed 's/)//'
        
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {document deleted|document inserted|document returned|document updated}\033[0m"
        exit 1
    fi
    ;;
    
    network)
    if [ ${METHOD} = "bytesIn" ];then
        # 输入字节数
        eval cat ${STAT_FILE}|grep -w -A 6 "network"|grep "bytesIn"|awk -F'"' '{print $4}'
    
    elif [ ${METHOD} = "bytesOut" ];then
        # 输出字节数
        eval cat ${STAT_FILE}|grep -w -A 6 "network"|grep "bytesOut"|awk -F'"' '{print $4}'
    
    elif [ ${METHOD} = "numRequests" ];then
        # 请求次数
        eval cat ${STAT_FILE}|grep -w -A 6 "network"|grep "numRequests"|awk -F'(' '{print $2}'|sed 's/),//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {network bytesIn|network bytesOut|network numRequests}\033[0m"
        exit 1
    fi
    ;;
    
    mem)
    if [ ${METHOD} = "mapped" ];then
        # 映射文件大小，所有数据库大小的和相近
        eval cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "mapped"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "mappedWithJournal" ];then
        # 为journal提供内存一般是mapped的2倍
        eval cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "mappedWithJournal"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "virtual" ];then
        # 虚拟内存(页面文件)使用（MB） 如果启动了journal，那么virtual至少是mapped2倍
        eval cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "virtual"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "resident" ];then
        # 在物理内存中的数据（MB）
        eval cat ${STAT_FILE}|grep -w -A 7 "mem"|grep -w "resident"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {mem mapped|mem mappedWithJournal|mem virtual|mem resident}\033[0m"
        exit 1
    fi
    ;;
    
    opcounters)
    if [ ${METHOD} = "insert" ];then
        eval cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "insert"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "query" ];then
        eval cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "query"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "update" ];then
        eval cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "update"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "delete" ];then
        eval cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "delete"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "getmore" ];then
        eval cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "getmore"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "command" ];then
        eval cat ${STAT_FILE}|grep -w -A 7 "opcounters"|grep "command"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {opcounters insert|opcounters query|opcounters update|opcounters delete|opcounters getmore|opcounters command}\033[0m"
        exit 1
    fi
    ;;
    
    currentQueue)
    if [ ${METHOD} = "total" ];then
        # 总共当前等待锁的个数
        eval cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "currentQueue"|grep "total"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "readers" ];then
        # 总共当前等待读锁的个数
        eval cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "currentQueue"|grep "readers"|awk '{print $3}'|sed 's/,//'
    
    elif [ ${METHOD} = "writers" ];then
        # 总共当前等待写锁的个数
        eval cat ${STAT_FILE}|grep -A 12 "globalLock"|grep -A 4 "currentQueue"|grep "writers"|awk '{print $3}'|sed 's/,//'
    
    else
        echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
        echo -e  "\033[33mUsage: $0 {currentQueue total|currentQueue readers|currentQueue writers}\033[0m"
        exit 1
    fi
    ;;
    
    *)
    echo -e "\033[33msh mongodb_stats.sh <METRIC> <METHOD> <PORT>\033[0m"
    echo -e  "\033[33mUsage: $0 {opcountersRepl insert|opcountersRepl query|opcountersRepl update|opcountersRepl delete|opcountersRepl getmore|opcountersRepl command}\033[0m"
    echo -e  "\033[33mUsage: $0 {connections current|connections available|connections totalCreated}\033[0m"
    echo -e  "\033[33mUsage: $0 {activeClients total|activeClients readers|activeClients writers}\033[0m"
    echo -e  "\033[33mUsage: $0 {globalLock totalTime}\033[0m"
    echo -e  "\033[33mUsage: $0 {document deleted|document inserted|document returned|document updated}\033[0m"
    echo -e  "\033[33mUsage: $0 {network bytesIn|network bytesOut|network numRequests}\033[0m"
    echo -e  "\033[33mUsage: $0 {mem mapped|mem mappedWithJournal|mem virtual|mem resident}\033[0m"
    echo -e  "\033[33mUsage: $0 {opcounters insert|opcounters query|opcounters update|opcounters delete|opcounters getmore|opcounters command}\033[0m"
    echo -e  "\033[33mUsage: $0 {currentQueue total|currentQueue readers|currentQueue writers}\033[0m"
    exit 1
esac

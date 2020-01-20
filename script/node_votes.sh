#!/bin/bash
### 监控主备超级节点票数
### sh node_votes.sh m|b

#node_votes=( $(/app/bp/nodeos/cleos -u http://47.93.13.197:8888/ get table eosio eosio prodslevel |grep total_votes |awk -F'[".]' '{print $4}') )
node_votes=( $(/app/bp/nodeos/cleos -u http://127.0.0.1:7000/ get table eosio eosio prodslevel |grep total_votes |awk -F'[".]' '{print $4}') )

m_node() {
num=0
for (( i=0;i<21;i++))
do
    if [ ${node_votes[$i]} -lt 50000000000 ]; then
        num++;
    fi;
done
echo "${num}"
}

b_node() {
num=0
for (( i=21;i<${#node_votes[@]};i++))
do
    if [ ${node_votes[$i]} -lt 20000000000 ]; then
        num++;
    fi;
done
echo "${num}"
}

case $1 in
    m)
        m_node
    ;;

    b)
        b_node
    ;;

    *)
        exit 1
esac

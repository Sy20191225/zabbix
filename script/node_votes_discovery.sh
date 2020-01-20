#!/bin/bash
### 监控主备超级节点票数
### sh node_votes_discovery.sh m|b

CLEOS="/app/bp/nodeos/cleos -u http://127.0.0.1:7000/ get table eosio eosio prodslevel"

ROWS=`eval $CLEOS | wc -l`

m_owner() {
    OWNER_M=( $(${CLEOS}|grep -A ${ROWS} "prods_l1"|grep -B ${ROWS} "prods_l2"|awk -F'[".]' '/owner/{print $4}') )
    printf "{\n"
    printf  '\t'"\"data\":["
    for (( i=0;i<${#OWNER_M[@]};i++))
    do
        printf '\n\t\t{'
        printf "\"{#OWNER_NAME}\":\"${OWNER_M[$i]}\"}"
        if [ $i -lt $[${#OWNER_M[@]}-1] ];then
            printf ','
        fi
    done
    printf  "\n\t]\n"
    printf "}\n"
}

b_owner() {
    OWNER_B=( $(${CLEOS}|grep -A ${ROWS} "prods_l2"|awk -F'[".]' '/owner/{print $4}') )
    printf "{\n"
    printf  '\t'"\"data\":["
    for (( i=0;i<${#OWNER_B[@]};i++))
    do
        printf '\n\t\t{'
        printf "\"{#OWNER_NAME}\":\"${OWNER_B[$i]}\"}"
        if [ $i -lt $[${#OWNER_B[@]}-1] ];then
            printf ','
        fi
    done
    printf  "\n\t]\n"
    printf "}\n"
}


case $1 in
    m)
        m_owner
    ;;

    b)
        b_owner
    ;;

*)
exit 1
esac

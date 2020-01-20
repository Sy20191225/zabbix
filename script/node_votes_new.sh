#!/bin/bash
### 监控主备超级节点票数
### sh node_votes_new.sh OWNER_NAME m|b

OWNER_NAME=$2

CLEOS="/app/bp/nodeos/cleos -u http://127.0.0.1:7000/ get table eosio eosio prodslevel"

VOTES=$(${CLEOS} |grep -A 6 ${OWNER_NAME}|awk -F'[".]' '/total_votes/{print $4}')

m_node() {
	if [ ${VOTES} -lt 50000000000 ]; then
		echo 0
	else
		echo 1
	fi;
}

b_node() {
	if [ ${VOTES} -lt 20000000000 ]; then
		echo 0
	else
		echo 1
	fi;
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

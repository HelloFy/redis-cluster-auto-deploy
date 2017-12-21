#!/bin/bash

PASS=$1
START_PORT=$2
END_PORT=$3
IP=$4

while [ ${START_PORT} -le ${END_PORT} ]
do
	./redis-cli -c -p ${START_PORT} -h ${IP} config set masterauth ${PASS}	
	./redis-cli -c -p ${START_PORT} -h ${IP} config set requirepass ${PASS}
	./redis-cli -c -p ${START_PORT} -h ${IP} -a ${PASS} config rewrite
	START_PORT=`expr ${START_PORT} + 1`
done

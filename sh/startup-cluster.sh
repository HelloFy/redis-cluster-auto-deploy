#!/bin/sh
START_PORT=$1
END_PORT=$2
if [ ! -n $START_PORT ]
then 
	echo "enter the start port"
	exit 1994
fi

if [ ! -n $END_PORT ]
then
	echo "enter the end port"
	exit 1994
fi

while [ $START_PORT -le $END_PORT ]
do
	./redis-server ../${START_PORT}/redis-${START_PORT}.conf
	START_PORT=`expr ${START_PORT} + 1`
done

exit 1994

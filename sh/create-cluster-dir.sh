#!/bin/bash

CUR_DIR=`pwd`

SHELL_DIR=$(cd `dirname $0`;pwd)
echo ${SHELL_DIR}
# echo $1
# if [ ! -f "$1" ]
# then
# 	echo "$1 is not a file,please confirm redis path"
# 	exit 1994
# fi


# if [ ! -f "$2" ]
# then
# 	echo "$2 is not a file,please confirm ruby path"
# 	exit 1994
# fi


# if [ ! -f "$3" ]
# then
# 	echo "$3 is not a file,please confirm ruby-gem path"
# 	exit 1994
# fi


# if [ ! -f "$4" ]
# then
# 	echo "$4 is not a tar file ,please confirm zlib path"
# 	exit 1994
# fi

# if [ ! -f "$5" ]
# then 
# 	echo "$5 is not a gem file"
# 	exit 1994
# fi

for tar in *.tar.gz  
do 
	tar -xvf $tar -C /opt
done

for tgz in *.tgz
do
	tar -xvf $tgz -C /opt
done

REDIS_HOME=/opt/`tar tf redis-*.tar.gz | head -1 | cut -d/ -f1 `
RUBY_HOME=/opt/`tar tf ruby-*.tar.gz | head -1 | cut -d/ -f1 `
RUBY_GEM_HOME=/opt/`tar tf rubygems-*.tgz | head -1 | cut -d/ -f1 `
ZLIB_HOME=/opt/`tar tf zlib-*.tar.gz | head -1 | cut -d/ -f1 `

if [ ! -n $REDIS_HOME ] || [ ! -d $REDIS_HOME ]
then
        echo "REDIS_HOME env not exist or set incorrect"
        exit 1994
fi


if [ ! -n $RUBY_HOME ] || [ ! -d $RUBY_HOME ]
then
        echo "RUBY_HOME env not exist or set incorrect"
        exit 1994
fi


if [ ! -n $RUBY_GEM_HOME ] || [ ! -d $RUBY_GEM_HOME ]
then 
        echo "RUBY_GEM_HOME env not exist or set incorrect"
        exit 1994
fi

if [ ! -n $ZLIB_HOME ] || [ ! -d $ZLIB_HOME ]
then
	echo "ZLIB_HOME env not exist or set incorrect"
	exit 1994
fi

PORT=7000
echo "${PORT} is the first PORT,y or n?"
while read YORN
do
	if [ $YORN == 'y' ]
	then 
		break
	fi
	echo "enter first PORT"
	read PORT
	echo "${PORT} is the first PORT,y or n"
done

NODES=3
echo "${NODES} is the nodes count,y or n?"
while read YORN
do
	if [ $YORN == 'y' ]
	then
		break
	fi
	echo "enter nodes count"
	read NODES
	echo "${NODES} is the nodes count,y or n?"
done

CLUSTER_DIR=/opt/cluster
if [ ! -d ${CLUSTER_DIR} ]
then
	mkdir $CLUSTER_DIR
fi

ENDPORT=`expr ${PORT} + ${NODES}`
IP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6 | awk '{print $2}' | tr -d "addr:"`

echo "ENDPORT is ${ENDPORT}"
while [ $PORT -lt $ENDPORT ]
do
	echo "mkdir ${CLUSTER_DIR}/${PORT}"
	if [ ! -d ${CLUSTER_DIR}/${PORT} ]
	then
		mkdir ${CLUSTER_DIR}/${PORT}
	fi
	if [ ! -f ${CLUSTER_DIR}/${PORT}/redis-${PORT}.conf ]
	then
		java -jar redis-cluster-gen-properties.jar ${CLUSTER_DIR}/${PORT} ${IP} ${PORT} 
	fi
	if [ ! -d ${CLUSTER_DIR}/${PORT}/data ]
	then
		mkdir ${CLUSTER_DIR}/${PORT}/data
	fi
	if [ ! -d ${CLUSTER_DIR}/${PORT}/log ]
	then
		mkdir ${CLUSTER_DIR}/${PORT}/log
	fi
	PORT=`expr ${PORT} + 1`
done

if [ ! -d ${CLUSTER_DIR}/bin ]
then
	mkdir ${CLUSTER_DIR}/bin
fi

cd ${REDIS_HOME}

make

cp ${REDIS_HOME}/src/redis-cli ${CLUSTER_DIR}/bin
cp ${REDIS_HOME}/src/redis-server ${CLUSTER_DIR}/bin
#cp ${REDIS_HOME}/src/redis-benchmark ${CLUSTER_DIR}/bin
#cp ${REDIS_HOME}/src/redis-check-dump ${CLUSTER_DIR}/bin
#cp ${REDIS_HOME}/src/redis-check-aof ${CLUSTER_DIR}/bin
cp ${REDIS_HOME}/src/redis-trib.rb ${CLUSTER_DIR}/bin


cd ${RUBY_HOME}
./configure --prefix=/opt/ruby
make && make install

cd ${RUBY_GEM_HOME}
export PATH=$PATH:/opt/ruby/bin
ruby setup.rb

cd ${ZLIB_HOME}
./configure --prefix=/lib/zlib
make && make install

cd ${SHELL_DIR}
gem install `tar tf redis-*.tar.gz | head -1 | cut -d/ -f1 `.gem --local

cp startup-cluster.sh ${CLUSTER_DIR}/bin 
cd ${CLUSTER_DIR}/bin

PORT=`expr ${PORT} - ${NODES}`
ENDPORT=`expr ${ENDPORT} - 1` 
./startup-cluster.sh ${PORT} ${ENDPORT}

cp ${CUR_DIR}/set-pass.sh ${CLUSTER_DIR}/bin

#./set-pass.sh bjcaBJCA2015 ${PORT} ${ENDPORT} ${IP}

cd ${CUR_DIR} 





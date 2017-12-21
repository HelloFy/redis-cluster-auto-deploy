# redis-cluster-auto-deploy

## Support OS
1.	CentOS6
***
Tips: Other Linux OS also **may** be supported , you can just try , it haven't damage your os.


## Install Cluster Dependecies
1. Java Runtime (Version >= 1.6) **required**
2. GCC **required**

## How To Deploy Cluster In CentOS
1.	Download the release redis-cluster-auto-deploy.tar.gz and Upload to your OS(Just like upload to /opt directory)
2.	Decompression 
	***
	`tar -zxvf redis-cluster-auto-deploy.tar.gz`
	
3.	Enter the redis-cluster-auto-deploy/ directory
	***
	`cd redis-cluster-auto-deploy/`
	
4.	exec the bash script create-cluster-dir.sh
	***
	`bash create-cluster-dir.sh`

5. If not errors in these steps,you should see the /opt directory has six new directory 
	1. cluster/ directory : it is cluster conf and bin dir
	2. redis-*.*.*/ directory : it is redis dir
	3. ruby directory : it is ruby bin install dir
	4. rubygems-*.*.* : it is rubygems install dir
	5. ruby-*.*.* : it is ruby dir
	6. zlib directory : it is zlib dir
	
6. First,import the ruby env
	`export PATH=$PATH:/opt/ruby/bin`
   Second, enter the cluster/bin dir
   Third, use the `redis-trib.rb` create cluster
   eg:
	 `./redis-trib.rb create 192.168.1.1:7000 192.168.1.2:7001 192.168.1.3:7002 `

#!/bin/bash
#Keepwalking86
#Build & run Docker for lemp stack (Linux Enginx Apache MariaDB PHP7)

DOCKER_IMAGE=keepwalking/lemp-laravel
DOCKER_CONTAINER=lemp-laravel
PORT=8081
PORTS=$(netstat -nta |grep -i listen |awk -F " " '{print $4}' |grep ":8081$" |awk -F":" '{print $NF}')

#Check image exists and build image
docker images | grep $DOCKER_IMAGE &>/dev/null
if [[ $? -ne 0 ]]; then
	docker build -t ${DOCKER_IMAGE} .
else
	echo "Docker image $DOCKER_IMAGE is existing"
fi
#Check container exists and run container
docker ps -a | awk '{print $NF}' |grep $DOCKER_CONTAINER &>/dev/null
if [[ $? -eq 0 ]]; then
	echo "$DOCKER_CONTAINER container is existing"
	exit 0;
else
	#Check port exists
	netstat -nta |grep -i listen |awk -F " " '{print $4}' |grep ":8081$" &>/dev/null
	if [[ $? -eq 0 ]]; then
		echo -n $PORTS; echo " ports are existing. Please, use other ports"
		exit 0;
	else
	 	echo "Running docker container"
		sleep 2
		docker run -d -p 8081:80 -v `pwd`/app:/var/www/example --name ${DOCKER_CONTAINER} ${DOCKER_IMAGE}
	fi
fi
# Dockerfile for LEMP STACK
Linux Enginx MariaDB PHP7 for Laravel on CentOS 7

## Exposing external port (Nginx, MariaDB, PHP-FPM)
```docker run -d -p 8081:80 -v `pwd`/app:/var/www/html --name lemp-mariadb keepwalking/lemp-mariadb```

## Connect to docker container
`docker exec -it lemp-mariadb bash`

## Set a password root user & enables to improve the security for MariaDB 
run: `bash /root/mysql_secure_installation.sh`
Replace with your root password
FROM centos:7

MAINTAINER KeepWalking86

#Installing repo epel, webstatic
RUN yum -y install epel-release && \
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

#Installing PHP7
RUN yum install -y php71w php71w-common php71w-gd php71w-phar \
    php71w-xml php71w-cli php71w-mbstring php71w-tokenizer \
    php71w-openssl php71w-pdo php71w-devel php71w-opcache php71w-pear \
    php71w-fpm unzip
#Install PHP Composer
RUN curl -sS https://getcomposer.org/installer |php -- --install-dir=/usr/bin --filename=composer

#Apply PHP configuration
COPY etc/www.conf /etc/php-fpm.d/
COPY etc/opcache.ini /etc/php.d/

###Installing & Configuring Nginx
RUN yum install -y nginx
COPY etc/nginx.conf /etc/nginx/

#Configure vhost for Laravel
RUN mkdir /etc/nginx/sites-enabled
COPY sites-enabled/example.conf /etc/nginx/sites-enabled/

#Installing & configuring MariaDB
RUN yum -y install mariadb-common mariadb-server mariadb-client
RUN /bin/mysql_install_db --datadir="/var/lib/mysql"  --socket="/var/lib/mysql/mysql.sock" --user=mysql
COPY etc/mysql_secure_installation.sh /root/

#RUN /usr/bin/mysql -e 'GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY 'P@ssw0rd' WITH GRANT OPTION;'
#VOLUME ["/var/lib/mysql"]
#RUN /usr/bin/mysqladmin -u root password 'P@ssw0rd'

#Installing & Configuring Supervisord
RUN yum -y install python-setuptools
RUN easy_install supervisor
COPY etc/supervisord.conf /etc/supervisord.conf
# Set the default command to execute
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]

##Clearing the yum Caches
RUN yum clean all

## Expose ports
EXPOSE 80 9000 3306
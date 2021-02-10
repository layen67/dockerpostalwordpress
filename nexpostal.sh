#!/bin/sh
read -p "Please enter domain:" domainname
read -p "Please enter Msql password: LFr37rG3r " domainpasspw
read -p "Please enter your Freenom.com email login:" Freenomloginpw
read -p "Please enter your Freenom.com password:" Freenompasspw

command hostnamectl set-hostname $domainname;

# freenom install
apt-get update;
apt install git -y;
git clone https://github.com/dawierha/Freenom-dns-updater.git;
cd Freenom-dns-updater;
apt-get install -y software-properties-common;
add-apt-repository ppa:ubuntu-toolchain-r/ppa -y;
apt-get update;
apt-get install -y python3-setuptools;
apt-get install -y python3.7;
python3 setup.py install;
apt-get install -y python3-click-package python3-click python-click;


echo "
login: $Freenomloginpw
password: $Freenompasspw

# list here the records you want to add/update
record:
  # the following will update both the A and AAAA records with your current ips (v4 and v6).
  # Note that if you don't have a ipv6 connection, the program'll detect it and will only update the A record (ipv4)
  - domain: $domainname

  # the following will update both your subdomain's A and AAAA records with your current ips (v4 and v6)
  - domain: $domainname
    name: www

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: click
    type: CNAME
    target: track.postal.$domainname # you can omit this line

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: postal

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: rp.postal

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: spf.postal

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: track.postal
    
  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: belgium
    type: CNAME
    target: news.oued-laou.com # you can omit this line

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: 
    type: TXT
    target: v=spf1 a mx include:spf.postal.$domainname ~all # you can omit this line

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: rp.postal
    type: TXT
    target: v=spf1 a mx include:spf.postal.$domainname ~all # you can omit this line
    
  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: POSTAL-RO9MOV._DOMAINKEY
    type: TXT
    target: v=DKIM1; t=s; h=sha256; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGCaSFpYj86cSSJpyQhs505MGoPdtfvgBryr2jlRppEQfJXkEP8uG39iLDvoLogyHNaYzsbVJL/3HBb80fnTxlYA454WMUZ0ndnnQ9Ue9AGA3Sd7tVPqaRyX0epZ2zA2/Yy+CJ5nEebt6apeUyGCGyiw+uRvnx/o0KzKk8uGPgTQIDAQAB; # you can omit this line

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: psrp
    type: CNAME
    target: rp.postal.$domainname # you can omit this line
    
  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: _DMARC
    type: TXT
    target: v=DMARC1; p=quarantine; rua=mailto:abuse@$domainname # you can omit this line

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name:
    type: MX
    target: postal.$domainname # you can omit this line
    priority: 10

  # the following will update your subdomain's A record with your current ip (v4)
  - domain: $domainname
    name: routes.postal
    type: MX
    target: postal.$domainname # you can omit this line
    priority: 10
"> /etc/freenom.yml;
fdu process -c -i -t 3600 /etc/freenom.yml&

sleep 500

fdu process -c -i -t 3600 /etc/freenom.yml&

# This will install everything required to run a basic Postal installation.
# This should be run on a clean Ubuntu 16.04 server.
#
# Once the installation has completed you will be able to access the Postal web
# interface on port 443. It will have a self-signed certificate.
#
# * Change the MySQL & RabbitMQ passwords
# * Create your first admin user with 'postal make-user'
# * Replace the self-signed certificate in /etc/nginx/ssl/postal.cert
# * Make appropriate changes to the configuration in /opt/postal/config/postal.yml
# * Setup your DNS                          [ https://github.com/atech/postal/wiki/Domains-&-DNS-Configuration ]
# * Configure the click & open tracking     [ https://github.com/atech/postal/wiki/Click-&-Open-Tracking ]
# * Configure spam & virus checking         [ https://github.com/atech/postal/wiki/Spam-&-Virus-Checking ]

set -e

#
# Installation 
#
apt update;
apt-get install -y firewalld;
systemctl enable firewalld;
systemctl start firewalld;
firewall-cmd --add-port=80/tcp --permanent;
firewall-cmd --add-port=443/tcp --permanent;
firewall-cmd --add-port=25/tcp --permanent;
firewall-cmd --add-port=2525/tcp --permanent;
firewall-cmd --add-port=587/tcp --permanent;
firewall-cmd --add-port=465/tcp --permanent;
firewall-cmd --add-port=3306/tcp --permanent;
firewall-cmd --add-port=8000/tcp --permanent;
firewall-cmd --add-port=8082/tcp --permanent;
firewall-cmd --add-port=8080/tcp --permanent;
firewall-cmd --add-port=8088/tcp --permanent;
firewall-cmd --add-port=8443/tcp --permanent;
firewall-cmd --add-port=5000/tcp --permanent;
firewall-cmd --add-port=8089/tcp --permanent;
firewall-cmd --add-port=9443/tcp --permanent;
firewall-cmd --add-port=11443/tcp --permanent;
firewall-cmd --add-port=783/tcp --permanent;
firewall-cmd --add-port=4444/tcp --permanent;
firewall-cmd --add-port=4369/tcp --permanent;
firewall-cmd --add-port=25672/tcp --permanent;
firewall-cmd --add-port=5671-5672/tcp --permanent;

firewall-cmd --add-masquerade --permanent;
firewall-cmd --add-forward-port=port=2525:proto=tcp:toport=25 --permanent;
firewall-cmd --add-forward-port=port=465:proto=tcp:toport=25 --permanent;
firewall-cmd --add-forward-port=port=587:proto=tcp:toport=25 --permanent;
systemctl restart firewalld;


sudo apt install mariadb-server libmysqlclient-dev;
sudo systemctl start mariadb.service;

sudo systemctl enable mariadb.service;

sudo systemctl restart mariadb.service;

#
echo 'CREATE DATABASE `postal` CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;' | mysql -u root;
echo 'GRANT ALL ON `postal`.* TO `postal`@`127.0.0.1` IDENTIFIED BY "LFr37rG3r";' | mysql -u root;
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`127.0.0.1`  IDENTIFIED BY "LFr37rG3r";' | mysql -u root;




#
# Dependencies
#

sudo apt-get install software-properties-common;

sudo apt-add-repository ppa:brightbox/ruby-ng;

sudo apt update;

sudo apt install ruby2.3 ruby2.3-dev build-essential;


wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -;

# Cuidado con el siguiente paso, si no usas Ubuntu Bionic debes modificar por tu version
echo "deb https://packages.erlang-solutions.com/ubuntu bionic contrib" | sudo tee /etc/apt/sources.list.d/erlang.list;

sudo apt-get update;

sudo apt-get install erlang;



sudo sh -c 'echo "deb https://dl.bintray.com/rabbitmq/debian $(lsb_release -sc) main" >> /etc/apt/sources.list.d/rabbitmq.list';

wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | sudo apt-key add -;

wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -;

sudo apt update;

sudo apt install rabbitmq-server;

sudo rabbitmq-plugins enable rabbitmq_management;





sudo systemctl enable rabbitmq-server;

sudo systemctl start rabbitmq-server;


sudo rabbitmq-plugins enable rabbitmq_management;

#
# MySQL

#
# RabbitMQ
#
rabbitmqctl add_vhost /postal;
rabbitmqctl add_user postal LFr37rG3r;
rabbitmqctl set_permissions -p /postal postal ".*" ".*" ".*";



sudo apt install curl;

curl -sL https://deb.nodesource.com/setup_10.x | sudo bash;

sudo apt-get install nodejs;


#
# System prep
#
sudo useradd -r -m -d /opt/postal -s /bin/bash postal;

sudo setcap 'cap_net_bind_service=+ep' /usr/bin/ruby2.3;



sudo gem install bundler;

sudo gem install procodile;

sudo gem install nokogiri -v '1.7.2';



#
# Application Setup
#
sudo -i -u postal mkdir -p /opt/postal/app;
wget https://postal.atech.media/packages/stable/latest.tgz -O - | sudo -u postal tar zxpv -C /opt/postal/app;
ln -s /opt/postal/app/bin/postal /usr/bin/postal;
postal bundle /opt/postal/vendor/bundle;
postal initialize-config;
sed -i -e "s/example.com/$domainname/g" /opt/postal/config/postal.yml;
sed -i -e "s/p0stalpassw0rd/$domainpasspw/g" /opt/postal/config/postal.yml;
sleep 2
postal initialize;
sudo -u postal postal start;
# postal start;

#
# nginx
#
cp /opt/postal/app/resource/nginx.cfg /etc/nginx/sites-available/default;
mkdir /etc/nginx/ssl/;
openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/postal.key -out /etc/nginx/ssl/postal.cert -days 365 -nodes -subj "/C=GB/ST=France/L=paris/O=17/CN=$domainname";
service nginx reload;


cd /etc/systemd/system;
curl -O https://raw.githubusercontent.com/layen67/docker-postal-ubuntu/master/postal.service;
systemctl daemon-reload;
systemctl enable postal;
systemctl start postal;

apt-get -y install software-properties-common;
apt-get -y update;
apt-get -y install spamassassin;
systemctl restart spamassassin;
systemctl enable spamassassin;

echo '' | sudo tee -a /opt/postal/config/postal.yml;
echo 'spamd:' | sudo tee -a /opt/postal/config/postal.yml;
echo '  enabled: true' | sudo tee -a /opt/postal/config/postal.yml;
echo '  host: 127.0.0.1' | sudo tee -a /opt/postal/config/postal.yml;
echo '  port: 783' | sudo tee -a /opt/postal/config/postal.yml;
# sed -i -e "s/use_ip_pools: false/use_ip_pools: true/g" /opt/postal/config/postal.yml;

echo '' | sudo tee -a /opt/postal/config/postal.yml;
echo 'smtp_server:' | sudo tee -a /opt/postal/config/postal.yml;
echo '  port: 25' | sudo tee -a /opt/postal/config/postal.yml;
echo '  tls_enabled: true' | sudo tee -a /opt/postal/config/postal.yml;
echo '  # tls_certificate_path: ' | sudo tee -a /opt/postal/config/postal.yml;
echo '  # tls_private_key_path: ' | sudo tee -a /opt/postal/config/postal.yml;
echo '  proxy_protocol: false' | sudo tee -a /opt/postal/config/postal.yml;
echo '  log_connect: true' | sudo tee -a /opt/postal/config/postal.yml;
echo '  strip_received_headers: true' | sudo tee -a /opt/postal/config/postal.yml;
sed -i -e "s/yourdomain.com/$domainname/g" /opt/postal/config/postal.yml;
sed -i -e "s/mx.postal.$domainname/postal.$domainname/g" /opt/postal/config/postal.yml;
echo 'postal.$domainname' > /etc/hostname;

service postal start;

sed -i -e "s/yourdomain.com/$domainname/g" /etc/nginx/sites-available/default;
sed -i -e "s/80/8082/g" /etc/nginx/sites-available/default;
sed -i -e "s/443/8443/g" /etc/nginx/sites-available/default;

service nginx restart;

#
# install docker
#


# This will install everything required to run a basic Postal installation.
# This should be run on a clean Ubuntu 16.04 server.
#
# Once the installation has completed you will be able to access the Postal web
# interface on port 443. It will have a self-signed certificate.
#
# * Change the MySQL & RabbitMQ passwords
# * Create your first admin user with 'postal make-user'
# * Replace the self-signed certificate in /etc/nginx/ssl/postal.cert
# * Make appropriate changes to the configuration in /opt/postal/config/postal.yml
# * Setup your DNS                          [ https://github.com/atech/postal/wiki/Domains-&-DNS-Configuration ]
# * Configure the click & open tracking     [ https://github.com/atech/postal/wiki/Click-&-Open-Tracking ]
# * Configure spam & virus checking         [ https://github.com/atech/postal/wiki/Spam-&-Virus-Checking ]

#
# Dependencies
#
apt-get update;
apt-get install -y docker.io;
curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose;
chmod +x /usr/local/bin/docker-compose;


# add current user to docker group so there is no need to use sudo when running docker
sudo usermod -aG docker $(whoami);
docker ps
sleep 10
sudo mkdir /var/lib/docker/wordpress;

echo "
version: '2'
services:
  https-portal:
    container_name: https-portal
    image: steveltn/https-portal:latest
    ports:
      - '80:80'
      - '443:443'
    network_mode: host
    restart: always
    environment:
      STAGE: 'production'
      NUMBITS: '4096'
#        FORCE_RENEW: 'true'
      WORKER_PROCESSES: '4'
      WORKER_CONNECTIONS: '1024'
      KEEPALIVE_TIMEOUT: '65'
      GZIP: 'on'
      SERVER_NAMES_HASH_BUCKET_SIZE: '64'
      PROXY_CONNECT_TIMEOUT: '900'
      PROXY_SEND_TIMEOUT: '900'
      PROXY_READ_TIMEOUT: '900'
      CLIENT_MAX_BODY_SIZE: 300M
      DOMAINS: >-
          $domainname -> http://172.20.128.4,
          www.$domainname -> http://172.20.128.4,
          track.postal.$domainname -> https://127.0.0.1:9443,
          click.$domainname -> https://127.0.0.1:9443,
          postal.$domainname -> https://127.0.0.1:8443
    volumes:
      - ./conf.d:/etc/nginx/conf.d/:rw
      - ./ssl_certs:/var/lib/https-portal:rw
      - /var/run/docker.sock:/var/run/docker.sock:ro

  db:
    container_name: mysql57
    image: mysql:5.7
    volumes:
      - ./db_data:/var/lib/mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: $domainpasspw
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: $domainpasspw
    command: mysqld --sql-mode=NO_ENGINE_SUBSTITUTION
    networks:
      static-network:
        ipv4_address: 172.20.128.3

  wordpress:
    depends_on:
      - db
    image: klayen/wordpress-postal:1.10
    ports:
      - "8000:80"
    volumes:
      - ./wp_data:/var/www/html
      - ./wp-content:/var/www/html/wp-content
    restart: unless-stopped
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: $domainpasspw
      WORDPRESS_CONFIG_EXTRA: |
        /* Site URL */
        define('WP_HOME', 'https://$domainname');     # <-- CHANGEME
        define('WP_SITEURL', 'https://$domainname');  # <-- CHANGEME
        /* Developer friendly settings */
        # define('SCRIPT_DEBUG', true);
        # define('CONCATENATE_SCRIPTS', false);
        # define('WP_DEBUG', true);
        # define('WP_DEBUG_LOG', true);
        # define('SAVEQUERIES', true);
        /* Multisite */
        # define('WP_ALLOW_MULTISITE', true );
        # define('MULTISITE', true);
        # define('SUBDOMAIN_INSTALL', false);
        # define('DOMAIN_CURRENT_SITE', '$domainname');  # <-- CHANGEME
        # define('PATH_CURRENT_SITE', '/');
        # define('SITE_ID_CURRENT_SITE', 1);
        # define('BLOG_ID_CURRENT_SITE', 1);
    networks:
      static-network:
        ipv4_address: 172.20.128.4

networks:
  static-network:
    ipam:
      config:
        - subnet: 172.20.0.0/16
          #docker-compose v3+ do not use ip_range
          ip_range: 172.28.5.0/24
"> /var/lib/docker/wordpress/docker-compose.yml;

cd /var/lib/docker/wordpress;

sed -i -r "s/.*tls_certificate_path.*/  tls_certificate_path: \/var\/lib\/docker\/wordpress\/ssl_certs\/postal.$domainname\/production\/signed.crt/g" /opt/postal/config/postal.yml;
sed -i -r "s/.*tls_private_key_path.*/  tls_private_key_path: \/var\/lib\/docker\/wordpress\/ssl_certs\/postal.$domainname\/production\/domain.key/g" /opt/postal/config/postal.yml;
sed -i -r "s/.*postal.cert.*/    ssl_certificate          \/var\/lib\/docker\/wordpress\/ssl_certs\/postal.$domainname\/production\/signed.crt;/g" /etc/nginx/sites-available/default;
sed -i -r "s/.*postal.key.*/    ssl_certificate_key      \/var\/lib\/docker\/wordpress\/ssl_certs\/postal.$domainname\/production\/domain.key;/g" /etc/nginx/sites-available/default;

free -h && sudo sysctl vm.drop_caches=3 && free -h

#
# add swap
#

fallocate -l 2G /swapfile;
chmod 600 /swapfile;
mkswap /swapfile;
swapon /swapfile;
free -h;
cp /etc/fstab /etc/fstab.bak;
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab;
free -h;
sed  -i '1i vm.swappiness = 0' /etc/sysctl.conf;
sed  -i '1i vm.vfs_cache_pressure=50' /etc/sysctl.conf;

free -h && sudo sysctl vm.drop_caches=3 && free -h;

docker-compose up -d;
sleep 300
docker-compose stop;
sleep 10
docker-compose up -d;
sleep 30
service docker restart;
sleep 10
su postal -c 'postal restart';
sleep 5
service postal restart;
sleep 10
service nginx restart;
sleep 5
#
#
#
chmod 777 /var/lib/docker/wordpress/wp-content;
cd /etc/nginx/sites-available;
wget https://raw.githubusercontent.com/layen67/dockerpostalwordpress/master/fast
ln -s /etc/nginx/sites-available/fast /etc/nginx/sites-enabled/;

#
# nginx proxy real ip
#
cd /etc/nginx
rm -rf /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/layen67/dockerpostalwordpress/master/nginx.conf

sed -i -e "s/yourdomain.com/$domainname/g" /etc/nginx/sites-available/fast;

#
#
#
sed -i".bak" '7,12d' /opt/postal/config/postal.yml;

echo '' | sudo tee -a /opt/postal/config/postal.yml;
echo 'fast_server:' | sudo tee -a /opt/postal/config/postal.yml;
echo '  enabled: true' | sudo tee -a /opt/postal/config/postal.yml;
echo '  bind_address: 127.0.0.1' | sudo tee -a /opt/postal/config/postal.yml;
echo '  port: 8088' | sudo tee -a /opt/postal/config/postal.yml;
echo '  ssl_port: 11443' | sudo tee -a /opt/postal/config/postal.yml;

su postal -c 'postal restart';

service nginx restart;

cd /etc/mysql;
mv my.cnf mycnfold;
wget https://raw.githubusercontent.com/layen67/dockerpostalwordpress/master/my.cnf;
service mysql restart;

command hostnamectl set-hostname $domainname;

postal make-user;

#
# All done
#
echo
echo "Installation complete your Mail server is https://postal.$domainname"
echo
echo "Installation complete your wordpress is https://$domainname"

reboot;

#!/bin/sh

set -e

read -p "Please enter domain:" domainname
read -p "Please enter Msql password: LFr37rG3r " domainpasspw
read -p "Please enter your Freenom.com email login:" Freenomloginpw
read -p "Please enter your Freenom.com password:" Freenompasspw

# freenom install
apt-get update;
apt install git -y;
git clone https://github.com/dawierha/Freenom-dns-updater.git;
cd Freenom-dns-updater;
apt-get install -y software-properties-common;
add-apt-repository -y ppa:deadsnakes/ppa;
apt-get update;
apt-get install -y python3-setuptools;
apt-get install -y python3.6;
python3 setup.py install;
apt-get install -y python3-click python-click;


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
########################################################################################"

command hostnamectl set-hostname postal.$domainname;
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

## If sudo is not available on the system,
## uncomment the line below to install it
# apt-get install -y sudo
sudo apt-get update -y
## Install prerequisites
sudo apt-get install curl gnupg -y
## Install RabbitMQ signing key
curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | sudo apt-key add -
## Install apt HTTPS transport
sudo apt-get install apt-transport-https
## Add Bintray repositories that provision latest RabbitMQ and Erlang 21.x releases
sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
## Installs the latest Erlang 22.x release.
## Change component to "erlang-21.x" to install the latest 21.x version.
## "bionic" as distribution name should work for any later Ubuntu or Debian release.
## See the release to distribution mapping table in RabbitMQ doc guides to learn more.
deb https://dl.bintray.com/rabbitmq-erlang/debian bionic erlang
deb https://dl.bintray.com/rabbitmq/debian bionic main
EOF
## Update package indices
sudo apt-get update -y
## Install rabbitmq-server and its dependencies
sudo apt-get install rabbitmq-server -y --fix-missing

rm -rf /var/lib/apt/lists/lock;

#
# Installation 
#
sudo apt-get update -y;
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
firewall-cmd --add-port=5672/tcp --permanent;
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

apt install -y software-properties-common;
apt-add-repository ppa:brightbox/ruby-ng -y;
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8;
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu bionic main';
sudo apt-get update -y;
export DEBIAN_FRONTEND=noninteractive;
apt install -y ruby2.3 ruby2.3-dev build-essential libssl-dev mariadb-server libmysqlclient-dev nodejs git nginx wget nano;
gem install bundler procodile --no-rdoc --no-ri;

#
# MySQL
#
echo 'CREATE DATABASE `postal` CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;' | mysql -u root;
echo 'GRANT ALL ON `postal`.* TO `postal`@`127.0.0.1` IDENTIFIED BY "LFr37rG3r";' | mysql -u root;
echo 'GRANT ALL PRIVILEGES ON `postal-%` . * to `postal`@`127.0.0.1`  IDENTIFIED BY "LFr37rG3r";' | mysql -u root;

#
# RabbitMQ
#
rabbitmqctl add_vhost /postal;
rabbitmqctl add_user postal LFr37rG3r;
rabbitmqctl set_permissions -p /postal postal ".*" ".*" ".*";

#
# System prep
#
useradd -r -m -d /opt/postal -s /bin/bash postal;
setcap 'cap_net_bind_service=+ep' /usr/bin/ruby2.3;

#
# Application Setup
#
sudo -i -u postal mkdir -p /opt/postal/app;
wget https://postal.atech.media/packages/stable/latest.tgz -O - | sudo -u postal tar zxpv -C /opt/postal/app;
ln -s /opt/postal/app/bin/postal /usr/bin/postal;
cd /opt/postal/app;
bundle update --all;
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
          track.postal.$domainname -> https://127.0.0.1:9443,
          click.$domainname -> https://127.0.0.1:9443,
          postal.$domainname -> https://127.0.0.1:8443
    volumes:
      - ./conf.d:/etc/nginx/conf.d/:rw
      - ./ssl_certs:/var/lib/https-portal:rw
      - /var/run/docker.sock:/var/run/docker.sock:ro
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
#chmod 777 /var/lib/docker/wordpress/wp-content;
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


echo '' | sudo tee -a /etc/sysctl.d/99-sysctl.conf;
echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.d/99-sysctl.conf;
echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.d/99-sysctl.conf;
echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.d/99-sysctl.conf;
sysctl -p;

su postal -c 'postal restart';

service nginx restart;

cd /etc/mysql;
mv my.cnf mycnfold;
wget https://raw.githubusercontent.com/layen67/dockerpostalwordpress/master/my.cnf;
service mysql restart;

command hostnamectl set-hostname postal.$domainname;

postal make-user;

#
# All done
#
echo
echo "Installation complete your Mail server is https://postal.$domainname"
echo
echo "Installation complete your wordpress is https://$domainname"

reboot;

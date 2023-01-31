# Install necessary packages
apt install -y build-essential openssl libssl-dev pkg-config

# unzip precompiled squid
tar -zxvf squid-5.7.tar.gz
cd squid-5.7

# install squid server globally
make install

# update system db
updatedb

# create ssl_cert folder to store certs
mkdir -p /usr/local/squid/etc/ssl_cert
chown -R proxy:proxy /usr/local/squid/etc/ssl_cert
chmod -R 700 /usr/local/squid/etc/ssl_cert

# create ssl certificate
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout home.pem -out home.pem
openssl x509 -in home.pem -outform DER -out home.der

# initialize ssl database
/usr/local/squid/libexec/security_file_certgen -c -s /usr/local/squid/var/logs/ssl_db -M 4MB
chown -R proxy:proxy /usr/local/squid/var/logs/ssl_db

# copy squid.conf file
cp -rf squid.conf /usr/local/squid/squid.conf

chown -R proxy:proxy /usr/local/squid

# create cache folders
/usr/local/squid/sbin/squid -z

# start squid
/usr/local/squid/sbin/squid -d 10

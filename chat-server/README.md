setup mongo https://www.linuxtechi.com/how-to-install-mongodb-rhel-centos/
public port mongo
sudo nano /etc/mongod.conf
net:
port: 27017
bindIp: 127.0.0.1,mongodb_server_ip

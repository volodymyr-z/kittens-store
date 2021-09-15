#!/bin/bash

yum update -y
amazon-linux-extras install docker -y
yum install docker -y
service docker start
usermod -a -G docker ec2-user

curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

sudo docker-compose -f /tmp/docker-compose-remote.yml up -d


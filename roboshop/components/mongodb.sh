#!/bin/bash

COMPONENT=mongodb
LOGFILE="/tmp/${COMPONENT}.log"

ID=$(id -u)

if  [$ID -ne 0] ; then
    echo -e "\e[33m This script is expected to run by a root user or with sudo previledge \e[0m"
    exit 1
fi

stat() {

    if [ $? -eq 0 ] ; then
        echo -e "\e[32m success \e[0m"
    else 
        echo -e "\e[31m failure \e[0m"
        exit 2
    fi  
}

echo -n "Configuring the $COMPONENT repo :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing $COMPONENT : "
  yum install -y $COMPONENT-org &>> LOGFILE
  stat $?

 echo -n "Starting $COMPONENT : "
 systemctl enable mongod &>> LOGFILE
 systemctl start mongod &>> LOGFILE
 stat $?

echo -n "Enabling the DB Visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?
# Install Mongo & Start Service.

# yum install -y mongodb-org
# systemctl enable mongod
# systemctl start mongod
# 1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in the config file, so that MongoDB can be accessed by other services.

  # Config file:   # vim /etc/mongod.conf

# - Then restart the service

# ```bash
# systemctl restart mongod
#```

  

#- Every Database needs the schema to be loaded for the application to work.

#---

      #`Download the schema and inject it.`
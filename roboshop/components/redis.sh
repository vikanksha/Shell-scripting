#!/bin/bash
COMPONENT=redis
LOGFILE="/tmp/${COMPONENT}.log"

ID=$(id -u)

if [ $ID -ne 0 ] ; then
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
echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

echo -n "Configuering the $COMPONENT repo :"
curl -L https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/${COMPONENT}.repo -o /etc/yum.repos.d/${COMPONENT}.repo 
stat $?

echo -n "Installing $COMPONENT :"
yum install ${COMPONENT}-6.2.11 -y    &>> $LOGFILE
stat $?

echo -n "Enabling the DB visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/${COMPONENT}.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/${COMPONENT}/${COMPONENT}.conf
stat $?

echo -n "Starting $COMPONENT :"
systemctl daemon-reload $COMPONENT  &>> $LOGFILE
systemctl enable $COMPONENT   &>> $LOGFILE
systemctl restart $COMPONENT   &>> $LOGFILE
stat $?

echo -e "*********** \e[35m $COMPONENT Installation is completed \e[0m ***********"

# vim /etc/redis.conf
# vim /etc/redis/redis.conf
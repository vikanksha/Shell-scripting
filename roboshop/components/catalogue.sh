#!/bin/bash

COMPONENT=catalogue
LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"


ID=$(id -u)

if  [ $ID -ne 0 ] ; then
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

echo -e "************ \e[35m $COMPONENT Installation has started \e[0m ************"

echo -n "Configuring the $COMPONENT repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "Installing Nodejs:"
yum install nodejs -y   &>> $LOGFILE
stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "creating the service account :"
    useradd $APPUSER &>> $LOGFILE
    stat $?
fi


echo -n "Downloading the $COMPONENT component :"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $?

echo -n "Copying the $COMPONENT to $APPUSER home directory :"
cd /home/${APPUSER}/
rm -rf  ${COMPONENT}  &>> $LOGFILE
unzip -o /tmp/catalogue.zip  &>> $LOGFILE
stat $?

echo -n "Modifying the ownership :"
mv $COMPONENT-main/ $COMPONENT
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT/
stat $?

echo -n "Generating npm $COMPONENT artifacts :"
cd /home/${APPUSER}/${COMPONENT}/
npm install &>> $LOGFILE
stat $?


 #/home/centos/Shell-scripting/roboshop

#mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install
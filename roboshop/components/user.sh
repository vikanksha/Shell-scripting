#!/bin/bash
COMPONENT=user
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

echo -e "Configuring the $COMPONENT repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -e "Installing NodeJS :"
 yum install nodejs -y   &>> LOGFILE
 stat $?

id $APPUSER &>> LOGFILE
if [ $? -ne 0 ] ; then
  echo -n "Creating the service Account :"
  useradd $APPUSER &>> $LOGFILE
  stat $?
fi

echo -n "Downloading the $COMPONENT component :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
stat $?

echo -n "Copying the $COMPONENT to $APPUSER home directory :"
cd /home/${APPUSER}/
rm -rf  ${COMPONENT}  &>> $LOGFILE
unzip -o /tmp/${COMPONENT}.zip  &>> $LOGFILE
stat $?

echo -n "Modifying the ownership :"
mv $COMPONENT-main/ $COMPONENT
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT/
stat $?

echo -n "Generating npm $COMPONENT artifacts :"
cd /home/${APPUSER}/${COMPONENT}/
npm install &>> $LOGFILE
stat $?


# $ curl -s -L -o /tmp/user.zip "https://github.com/stans-robot-project/user/archive/main.zip"
# $ cd /home/roboshop
# $ unzip /tmp/user.zip
# $ mv user-main user
# $ cd /home/roboshop/user
# $ npm install
#!/bin/bash

COMPONENT="catalogue"

source components/common.sh

echo -e "************ \e[35m $COMPONENT Installation has started \e[0m ************"

echo -n "Configuring the $COMPONENT repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "Installing NodeJS:"
yum install nodejs -y   &>> $LOGFILE
stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "creating the service account :"
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

echo -n "Updating the $COMPONENT systemd file :"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUSER}/${COMPONENT}/systemd.service
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting ${COMPONENT} service :"
systemctl daemon-reload  &>> $LOGFILE
systemctl enable $COMPONENT  &>> $LOGFILE
systemctl restart $COMPONENT  &>> $LOGFILE
stat $?

echo -e "************ \e[35m $COMPONENT Installation is completed \e[0m ************"

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
# systemctl status catalogue -l

# NOTE: You should see the log saying `connected to MongoDB`, then only your catalogue
# will work and can fetch the items from MongoDB

# Ref Log:
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":"MongoDB connected","v":1}
 #/home/centos/Shell-scripting/roboshop

#mv catalogue-main catalogue
#$ cd /home/roboshop/catalogue
#$ npm install
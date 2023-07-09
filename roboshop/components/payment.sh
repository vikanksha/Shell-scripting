#!/bin/bash
COMPONENT="payment"

source components/common.sh

echo -e "************ \e[35m $COMPONENT Installation has started \e[0m ************"

echo -n "Installing python and its dependencies :"
yum install python36 gcc python3-devel -y      &>> $LOGFILE
stat $?

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "creating the service account :"
    useradd $APPUSER &>> $LOGFILE
    stat $?
fi

echo -n "Downloading the $COMPONENT component :"
$ curl -L -s -o /tmp/payment.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"  &>> $LOGFILE
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

echo -n "Installing $COMPONENT :"
cd /home/${APPUSER}/${COMPOMENT}/
pip3 install -r requirements.txt  &>> $LOGFILE
stat $?

USERID=$(id -u roboshop)
GROUPID=$(id -g roboshop)

echo -n "Updating the uid and gid in the $COMPONENT.ini file"
sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/${APPUSER}/${COMPONENT}/${COMPONENT}.ini

echo -n "Updating the $COMPONENT systemd file :"
sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUSER}/${COMPONENT}/systemd.service  
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $? 

echo -n "Starting ${COMPONENT} service :"
systemctl daemon-reload  &>> $LOGFILE
systemctl enable $COMPONENT  &>> $LOGFILE
systemctl restart $COMPONENT  &>> $LOGFILE
stat $?
echo -e "*********** \e[35m $COMPONENT Installation has Completed \e[0m ***********"
# $ cd /home/roboshop
# $ curl -L -s -o /tmp/payment.zip "https://github.com/stans-robot-project/payment/archive/main.zip"
# $ unzip /tmp/payment.zip
# $ mv payment-main payment
# cd /home/roboshop/payment 
# pip3 install -r requirements.txt
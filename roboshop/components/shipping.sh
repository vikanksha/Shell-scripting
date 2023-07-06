#!/bin/bash

COMPONENT="shipping"

source components/common.sh

echo -e "************ \e[35m $COMPONENT Installation has started \e[0m ************"

echo -n "Installing Maven  :"
yum install maven -y   &>> $LOGFILE 
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

echo -n "Preparing $COMPONENT artifacts :"
cd /home/${APPUSER}/${COMPONENT}
mvn clean package   &>> $LOGFILE
mv target/shipping-1.0.jar shipping.jar 
stat $?

echo -n "Updating the $COMPONENT systemd file :"
sed -i -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUSER}/${COMPONENT}/systemd.service  
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $? 

echo -n "Starting ${COMPONENT} service :"
systemctl daemon-reload  &>> $LOGFILE
systemctl enable $COMPONENT  &>> $LOGFILE
systemctl restart $COMPONENT  &>> $LOGFILE
stat $?

echo -e "************ \e[35m $COMPONENT Installation is completed \e[0m ************"



# #  yum install maven -y   ( installs maven with java 8 )
# PS : Refer Lab-Tools for java11 maven installation
# Create a user

# ```sql
# # useradd roboshop
# ```

# 1. Download the repo

# ```bash
# $ cd /home/roboshop
# $ curl -s -L -o /tmp/shipping.zip "https://github.com/stans-robot-project/shipping/archive/main.zip"
# $ unzip /tmp/shipping.zip
# $ mv shipping-main shipping
# $ cd shipping
# $ mvn clean package 
# $ mv target/shipping-1.0.jar shipping.jar
# ```

# 1. Update SystemD Service file ( `SHIPPING` talks to both `CART` & `MySQL` )
    
#     Update `CARTENDPOINT` with Cart Server IP.
    
#     Update `DBHOST` with MySQL Server IP
    

# ```sql
# $ vim systemd.service 
# ```

# 1. Copy the service file and start the service.
# - Now we are good with SHIPPING.
# - Ensure you update the `SHIPPING` IP Address / DNS Name in the Nginx Reverse Proxy File

# ```sql
# On Frontend Server,
# # vim /etc/nginx/default.d/roboshop.conf
# # systemctl restart nginx
# ```

# - You should be able to see the COUNTRIES & CITIES in those countries and the associated Shipping Charge once your checkout from `CART`
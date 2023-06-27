#!/bin/bash
COMPONENT="cart"

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









# curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -
# yum install nodejs -y
# useradd roboshop
# $ curl -s -L -o /tmp/cart.zip "https://github.com/stans-robot-project/cart/archive/main.zip"
# $ cd /home/roboshop
# $ unzip /tmp/cart.zip
# $ mv cart-main cart
# $ cd cart
# $ npm install
# 1. Update SystemD service file ( As`CART` talks to both `REDIS` & `CATALOGUE` )
    
#           Update `REDIS_ENDPOINT` with REDIS server IP Address
#           Update `CATALOGUE_ENDPOINT` with Catalogue server IP address
    
#     ```sql
#     $ vim systemd.service
#     ```
    
# 2. Now, lets set up the service with systemctl.

# ```bash
# # mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
# # systemctl daemon-reload
# # systemctl start cart
# # systemctl enable cart
# ```

# 1. When you look at the status of the `cart`, it should show connected to `REDIS` 

# ```sql
# # systemctl status cart -l
# ```

# 1. Now `CART` is ready. But still, you won’t be able to add items in the `CATALOGUE` to `CART`. Because your frontend is still now aware of the `CART` component.
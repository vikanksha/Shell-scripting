#!/bin/bash

COMPONENT=frontend

source components/common.sh

echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

echo "Installing Nginx :"
yum install nginx -y  &>> $LOGFILE
stat $? 

echo -n "Downloading the frontend component :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "performing cleanup: "
cd /usr/share/nginx/html
rm -rf *   &>> $LOGFILE
stat $?

echo -n "Extracting ${COMPONENT} component :"
unzip /tmp/${COMPONENT}.zip    &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .  
rm -rf ${COMPONENT}-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Updating the backend component reveseproxy details : "
for component in cart catalogue user; do 
    sed -i -e "/$component/s/localhost/$component.roboshop.internal/"  /etc/nginx/default.d/roboshop.conf
done 
stat $? 

echo -n "Starting $COMPONENT service : "
systemctl daemon-reload  &>> $LOGFILE
systemctl enable nginx  &>> $LOGFILE
systemctl restart nginx   &>> $LOGFILE
stat $?

echo -e "************ \e[35m $COMPONENT Installation is completed \e[0m ************"


# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf

# ```

# - Finally, restart the service once to effect the changes.
# - Now, you should be able to access the ROBOSHOP e-commerce webpage as shown below
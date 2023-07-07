#!/bin/bash

COMPONENT="rabbitmq"

source components/common.sh

echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

echo -n "Configuring the $COMPONENT repo :"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash  &>> LOGFILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> LOGFILE
stat $?

echo -n "Installing $COMPONENT :"
yum install rabbitmq-server -y  &>> LOGFILE
stat $?


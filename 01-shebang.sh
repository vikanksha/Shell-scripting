#!/bin/bash
# echo welcome to visual studio

# echo line1
# echo line2
# echo line3
# echo -e line1\nline2\nline3
#echo -e "apple\n\tBanana"
#echo -e "\e[43;32m Hello this is my first script in bash color coding using green color \e[0m"
#echo -e "\e[40;33m hello this is yellow color \e[0m"
#echo -e "\e[45;34m hello this is blue color \e[0m"
#echo -e "\e[42;36m hello this is cyan color \e["0m
# a=10
#name=Vikanksha
#batch=54
#topic=shellscripting
#echo $a
# echo -e "value of the variables a is \e[32m $a\e[0m"
# TODAYS_DATE = "08-06-2023"
echo - TODAYS_DATE = $(date +%D)
echo -e "Good morning and todays date is \e[32m $TODAYS_DATE \e[0m"
NO_OF_SESSION=$(who | wc -1)
echo -e "Number of opened sessions : \e[33m $NO_OF_SESSION \e[0m"

#!/bin/bash
if [ "$1" = "reload" ];then
echo "running: whenever --update-crontab --set environment='development'"
whenever --update-crontab --set environment='development'
echo "running: crontab -l"
crontab -l
fi

# if [ "$1" = "restart" ];then
# echo "running: whenever --update-crontab"
# whenever --update-crontab
# echo "running: crontab -l"
# crontab -l
# fi

if [ "$1" = "clear" ];then
echo "running: whenever --update-crontab"
whenever -c
echo "running: crontab -l"
crontab -l
fi

#!/bin/bash
if [ "$1" = "restart" ];then
echo "restarting development server, using thin"
bundle exec thin stop
bundle exec thin start -p 3000 -d
fi

if [ "$1" = "stop" ];then
echo "stop development serve, using thinr"
bundle exec thin stop
fi

if [ "$1" = "start" ];then
echo "starting development server, using thin"
bundle exec thin start -p 3000 -d
fi

#!/bin/bash
#
# healthcheck.sh - Execute HTTP calls to a DropWizard application checking the health status
#
# Author: Rubens Goncalves
# Version: 1.0
#
# -----------------------------------------
# This program receive as parameter the HTTP port (--port) where the Dropwizard admin
# endopints are available and execute multiples calls to check the helath status.
# If something goes wrong with the application, it prints a warning in the console
# and in the log file.
# -----------------------------------------
#
# Usage:
#  $ ./healthcheck.sh --port 8889
#
# Changelog:
#   - v1.0: Initial code for healthcheck the DropWizard application
#
port='8889'
server='localhost'
restart='true'
USAGE="

Usage: $(basename "$0") [-h | -s | -p | -r]

   -h     Prints the usage instructions
   -s     Server DNS. Default: localhost
   -p     HTTP port number of the server endpoint. Default: 8889
   -r     Restart the server if it fails [true | false]. Default: true

Note: Press [CTRL+C] to stop the script when it is running!
"

# This function restart the server.
# By default it restarts, but the user can disable using the option [-r false]
function restart_service {
  if [ "$1" == "true" ]; then
    sudo service satest restart
    if [ $? != 0 ]; then
      echo "Error when starting the server!"
      echo "Exiting this script. Please check troubleshoot the service and re-execute this script"
      exit 1
    else
      echo "Server restarted with success!"
    fi
  else
    exit 1
  fi
}

# This function receives the http port as parameter and
# call the functions to execute the calls.
function health_check {
  echo "######################"
  echo "Checking server health"
  echo "######################"
  while :
  do
    monitor_ping $1 $2 $3
    monitor_health $1 $2 $3
  done
}

# This function monitors the ping endpoint <server>:<port>/ping
function monitor_ping {
  content_ok="pong"
  content=$(curl -s $1:$2/ping)
  if test "$content" != "$content_ok"
  then
    echo "$(date) - Ping is not responding"
    echo "$(date) - Ping is not responding" >> ~/wizard_monitor.log
    restart_service $3
  fi
  sleep 2
}

function monitor_health {
  content_ok="deadlocks: OK"
  content=$(curl -s $server:$port/healthcheck)
  if [[ $content != *"$content_ok"* ]]; then
    echo "$(date) - Health Check Failed. Deadlock!"
    echo "$(date) - Health Check Failed. Deadlock!" >> ~/wizard_monitor.log
    restart_service $3
  fi
  sleep 2
}

while getopts "hp:s:r:" option
do
  case $option in
    h) echo "$USAGE";;
    p) port="${OPTARG}";;
    s) server="${OPTARG}";;
    r) restart="${OPTARG}";;
    \?) echo "ERROR Invalid option: $OPTARG - Valid are [-h | -p | -s | -r]";;
    :) echo "ERROR Missing argument: $OPTARG";;
  esac
done

health_check $server $port $restart

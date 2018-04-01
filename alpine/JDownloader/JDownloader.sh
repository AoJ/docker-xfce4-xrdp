#!/bin/sh

function stopJDownloader {
  PID=/home/$(cat $APP_USER/JDownloader/JDownloader.pid)
  kill $PID
  wait $PID
  exit
}

trap stopJDownloader EXIT

java -Djava.awt.headless=true -jar /home/$APP_USER/JDownloader/JDownloader.jar &

while true; do
  sleep 8
done

#!/bin/bash
# by luciust, Łukasz Jokiel, lukasz jokiel at gmail com (c) 2019
# GPL 3.0
# This is a little monster - quick and lousy hack to get data form Tauron's e-meter WWW in XLS and push it to InfluxdB
#
cd ~/TauronPVtoGrafana
mkdir -p working_dir
#Kill any leftovers from previous session
killall Xvfb
killall fluxbox
killall x11vnc
killall firefox
#Remove old data
rm ~/Downloads/Dane.xls
#Set the DISPLAY variable and 
export DISPLAY=:1
#Run X session
/usr/bin/Xvfb :1 -screen 0 1024x768x16 &
# Lets wait for the X to come up (just a bit of safety)
sleep 10
#Start Window Manager in the X Session
/usr/bin/fluxbox -display :1 &
sleep 5
#ONLY FOR DEBUGGING - Start a debugging VNC access to the X session - only needed in case of problems with data aquisition 
x11vnc -display :1 -bg -listen raspberrypi.local -xkb
#start Firefox in full screen, enter the meter's URL
/usr/bin/firefox -url https://elicznik.tauron-dystrybucja.pl/ -fullscreen &
#Give some time to open the page... (i.e. because of slow links)
#sleep 25
#Run the python script that clicks on the Taurons interface and Downloads the data, then quits the Firefox
#./tauron-cli-browser-job.py3
#Kill all remaining programs
#killall x11vnc
#killall fluxbox
#killall Xvfb
#./convert_and_upload_to_influxdb.bash

 

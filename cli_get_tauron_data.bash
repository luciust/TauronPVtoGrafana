#!/bin/bash
# by luciust, Łukasz Jokiel, lukasz jokiel at gmail com (c) 2019
# GPL 3.0
# This is a little monster - quick and lousy hack to get data form Tauron's e-meter WWW in XLS and push it to InfluxdB
#
cd ~/TauronPVtoGrafana
mkdir -p working_dir
#Kill any leftovers from previous session
killall -9 Xvfb
killall -9 fluxbox
killall -9 x11vnc
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
x11vnc -display :1 -bg -listen atomicpi.local -xkb
#start Firefox in full screen, enter the meter's URL
/usr/bin/firefox -url https://elicznik.tauron-dystrybucja.pl/ -fullscreen &


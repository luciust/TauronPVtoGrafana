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
echo "CTRL+C to kill it ONLY (2 seconds)"
#Set the DISPLAY variable and 
export DISPLAY=:1
#Run X session
Xvfb :1 -screen 0 1024x768x16 &
# Lets wait for the X to come up (just a bit of safety)
sleep 5
#Start Window Manager in the X Session
/usr/bin/fluxbox -display :1 &
#ONLY FOR DEBUGGING - Start a debugging VNC access to the X session - only needed in case of problems with data aquisition 
## x11vnc -display :1 -bg -listen 192.168.111.249 -xkb -rfbauth ~/.x11vnc/passwd 
#start Firefox in full screen, enter the meter's URL
/usr/bin/firefox -url https://elicznik.tauron-dystrybucja.pl/ -fullscreen &
#Give some time to open the page... (i.e. because of slow links)
sleep 30
#Remove old data
rm ~/Downloads/Dane.xls
#Run the python script that clicks on the Taurons interface and Downloads the data, then quits the Firefox
./
#Convert the downloaded meter data from XLS to comma separated values for further processing
./xls2csv/xls2csv.py ~/Downloads/Dane.xls > work_dir/raw_tauron_data.txt
#Kill all remaining programs
killall x11vnc
killall fluxbox
killall Xvfb


 
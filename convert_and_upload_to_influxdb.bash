#!/bin/bash
# by lucius (2019) lukasz dot jokiel at gmail dot com
# Definicja Zmiennych
#
# Change the URL to match your settings
#
# URL to InfluxDB - IP, db - usually the same as your Raspberry
#
# Changelog:
# 23.03.2020 - Simplification based on the new cvs data format from Tauron
#
##########################################################
# 
IDB_URL="'http://grafana.local:8086/write?db=domoticz'"
#
##########################################################
#
#Create if needed and enter working directory
mkdir -p ~/TauronPVtoGrafana/work_dir
cd ~/TauronPVtoGrafana/work_dir
#Copy the downloaded csv file to work directory
cp ~/Downloads/dane.csv raw_tauron_data.txt
#Grep by date, filter out comments
/bin/grep ^[0-9] raw_tauron_data.txt | /bin/sed -e 's/,/./g' -e 's/;/,/g' | /usr/bin/awk -F, '{print 'data'","$0}' > raw_influx_data.txt
#Conversion of the date to epoch, preformating to push to Influxdb
/usr/bin/awk -F',' '{print $1,$2":00 3 hours ago,"$3","$4}' raw_influx_data.txt | /bin/sed -e 's/24:00/0:00/g' | /bin/sed -e 's/\r//g' | /usr/bin/awk -F, '{ OFS = FS;command="date -d " "\"" $1 "\""  " +%s%N";command | getline $1;close(command);print "E5K_pobrana value="$2" E5K_oddana value="$3" "$1}' | /bin/grep E5K > pre_influxdb_inject_data.txt
#Push to InfluxDB - awk and directly execute the shell command of preformated curl
/usr/bin/awk -v db_url="$IDB_URL" '{print "curl -i -XPOST "db_url" --data-binary \""$1,$2,$5"\"\ncurl -i -XPOST "db_url" --data-binary \""$3,$4,$5"\""}' pre_influxdb_inject_data.txt > exec_E5K_ALLDATA
/bin/bash exec_E5K_ALLDATA
#Cleanup
rm exec_E5K_ALLDATA
rm pre_influxdb_inject_data.txt
rm raw_influx_data.txt

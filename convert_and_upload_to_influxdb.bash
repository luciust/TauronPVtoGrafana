#!/bin/bash
# by lucius (2019) lukasz dot jokiel at gmail dot com
# Definicja Zmiennych
#
# Change the URL to match your settings
#
# URL to InfluxDB - IP, db - usually the same as your Raspberry
#
##########################################################
# 
IDB_URL="'http://grafana.local:8086/write?db=domoticz'"
#
##########################################################
#
cd ~/TauronPVtoGrafana
#Convert the downloaded meter data from XLS to comma separated values for further processing
./xls2csv/xls2csv.py ~/Downloads/Dane.xls raw_tauron_data.txt
mkdir -p work_dir
mv raw_tauron_data.txt work_dir
cd work_dir
#Grep by date, filter out some warnings unstuck the first hour, remove " and split into files
/bin/grep ^\"[0-9] raw_tauron_data.txt | /bin/sed -e s/' 1"'/'\n1"'/g | /usr//bin/tr -d [\"] | /usr/bin/csplit - '/^2[0-9][0-9][0-9]-/' {*}
#Delete old file with the output
rm raw_tauron_data.txt
#Add proper date to the filename
for stara_nazwa_pliku in `ls xx*`
do
 nowa_nazwa_pliku=`grep ^[2][0-9][0-9][0-9]- ${stara_nazwa_pliku}`
 echo ${stara_nazwa_pliku}
 mv ${stara_nazwa_pliku} ${nowa_nazwa_pliku}
done
#Format for awk, date, power used, power generated
for nazwa_pliku in `ls 20*` 
do
 /bin/grep -v [2][0][1-9][1-9] ${nazwa_pliku} | /usr/bin/awk -v data=${nazwa_pliku} '{print 'data'","$0}' >> raw_influx_data.txt
done
#Conversion of the date to epoch, preformating to push to Influxdb
/usr/bin/awk -F',' '{print $1,$2":00 1 hour ago,"$3","$4}' raw_influx_data.txt | /bin/sed -e 's/24:00/0:00/g' | /bin/sed -e 's/\r//g' | /usr/bin/awk -F, '{ OFS = FS;command="date -d " "\"" $1 "\""  " +%s%N";command | getline $1;close(command);print "E5K_pobrana value="$2" E5K_oddana value="$3" "$1}' | /bin/grep E5K > pre_influxdb_inject_data.txt
#Push to InfluxDB - awk and directly execute the shell command of preformated curl
/usr/bin/awk -v db_url="$IDB_URL" '{print "curl -i -XPOST "db_url" --data-binary \""$1,$2,$5"\"\ncurl -i -XPOST "db_url" --data-binary \""$3,$4,$5"\""}' pre_influxdb_inject_data.txt > exec_E5K_ALLDATA
/bin/bash exec_E5K_ALLDATA
#Cleanup
rm exec_E5K_ALLDATA
rm pre_influxdb_inject_data.txt
rm raw_influx_data.txt
rm x*
rm 20*

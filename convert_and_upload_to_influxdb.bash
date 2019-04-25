#!/bin/bash
# by lucius (2019) lukasz dot jokiel at gmail dot com
# Definicja Zmiennych
#
# Zmień to!
#
# URL do bazy danych InfluxDB - adres IP, nazwa bazy
#
# 
IDB_URL="'http://grafana.local:8086/write?db=domoticz'"
#
# Koniec Twoich definicji
#
cd ~/TauronPVtoGrafana
#Convert the downloaded meter data from XLS to comma separated values for further processing
./xls2csv/xls2csv.py ~/Downloads/Dane.xls raw_tauron_data.txt
mkdir -p work_dir
mv raw_tauron_data.txt work_dir
cd work_dir
#Najpierw grep po dacie aby odsciac smieci, potem sed zamienia " 1" na znak końca linii i 1 aby przeniesc do następnej linii pierwszy odczyt.
#Następnie tr kasuje cudzysłowy, a cslip po roku robi osobne pliki
grep ^\"[0-9] ../raw_tauron_data.txt | sed -e s/' 1"'/'\n1"'/g | tr -d [\"] | csplit - '/^2[0-9][0-9][0-9]-/' {*}
#Usuwamy stare dane 
#Dodawanie daty na początek pliku
for stara_nazwa_pliku in `ls xx*` 
do
 nowa_nazwa_pliku=`grep ^[2][0-9][0-9][0-9]- ${stara_nazwa_pliku}`
 echo ${stara_nazwa_pliku}
 mv ${stara_nazwa_pliku} ${nowa_nazwa_pliku}
done
#Teraz formatujemy pod awka - czyli data, pobór, genreacja, a nie że tylko data w jednej linii a potem godziny
for nazwa_pliku in `ls 20*` 
do
 grep -v [2][0][1-9][1-9] ${nazwa_pliku} | awk -v data=${nazwa_pliku} '{print 'data'","$0}' >> ../raw_influx_data.txt
done
#Konwersja daty na epoch, preformatowanie pod Influxdb
awk -F',' '{print $1,$2":00 1 hour ago,"$3","$4}' raw_influx_data.txt |  sed -e 's/24:00/0:00/g' | sed -e 's/\r//g' | awk -F, '{ OFS = FS;command="date -d " "\"" $1 "\""  " +%s%N";command | getline $1;close(command);print "E5K_pobrana value="$2" E5K_oddana value="$3" "$1}' | grep E5K > pre_influxdb_inject_data.txt
#Aktualizacja InfluxDB - przerabiamy awkiem na komendy curl'am który uzupełnia bazę po wywołaniu w szelu
awk -v db_url="$IDB_URL" '{print "curl -i -XPOST "db_url" --data-binary \""$1,$2,$5"\"\ncurl -i -XPOST "db_url" --data-binary \""$3,$4,$5"\""}' pre_influxdb_inject_data.txt > exec_E5K_ALLDATA
bash exec_E5K_ALLDATA
#Sprzątamy
rm exec_E5K_ALLDATA
rm pre_influxdb_inject_data.txt
rm raw_influx_data.txt
rm x*
rm 20*

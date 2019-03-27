#!/bin/bash
#copyright Jasper Nuyens 2019
#licensed under the GNU GPLv3 license as published on https:/www.GNU.org

if [[ $(id -u) != 0 ]]
then
 echo Error: please run with sudo rights or as the root user to avoid file permission read errors
 exit 2
fi

logfile=/tmp/wormcheck-$(date +"%Y-%m-%d-%H-%M").txt
scandir=/var/www
version=2019032701

echo Runs for a very long time.
echo You can follow progress in another terminal window with: less $logfile

echo | tee > $logfile
echo Scanning for random lenght 8 char filenames - can have false positives | tee >> $logfile
find $scandir -type f | egrep './[a-z]{8}\.php' | tee >> $logfile

echo | tee >> $logfile
echo Scanning for GLOBALS - can have false positives | tee >> $logfile
rgrep '\;\$GLOBALS\[' $scandir| tee >> $logfile

echo | tee >> $logfile
echo Scanning for encoded php worms - probably no false positives |tee >> $logfile
rgrep '<?php /\*[0-9][0-9][0-9][0-9]\*/' $scandir | tee >> $logfile


echo | tee >> $logfile
echo Scanning for fake .ico files - probably no false positives |tee >> $logfile
which locate 2> /dev/null
if [[ $? = 0 ]]
then
locate .ico | xargs file | grep 'PHP script' | awk -F: '{ print $1 }' | tee >> $logfile
else
 find $scandir -iname '*.ico' | xargs file | grep 'PHP script' | awk -F: '{ print $1 }' | tee >> $logfile
fi
 


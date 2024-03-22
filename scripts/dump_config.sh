#!/bin/bash
#
# Perform backups of all configs.

echo "-------------"
echo "Script for saving configs started"
echo "dump saved in /backup/config"
echo "dump follow this format : config_dump_month-day-year-hour-minutes-seconds/"
echo "-------------"

DATE=`date +%m-%d-%Y"_"%H_%M_%S`

sudo cp -r config/ backup/config/$DATE

echo "-------------"
echo "End of script"
echo "Config backup is not saved on git. Consider downloading it."
echo "-------------"

#!/bin/sh
#
# Create snapshot via radar search

if [ "`usbgpio statusin | awk -F ' ' '/LED 7/ {print $4}'`" = "1" ] ; then
  logger -t flypeek "Radar is active !"
  /usr/sbin/service_flypeek.sh
fi

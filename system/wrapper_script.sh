#!/bin/bash

sudo mkdir -p /run/dbus
sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf
sudo supervisord -c /etc/supervisord.conf
/bin/zsh

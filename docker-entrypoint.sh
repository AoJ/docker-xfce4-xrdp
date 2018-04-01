#!/bin/sh

#prepare xauth
touch /home/aoj/.Xauthority
chown aoj:aoj /home/aoj/.Xauthority

# generate machine-id
uuidgen > /etc/machine-id

# set keyboard for all sh users
echo "export QT_XKB_CONFIG_ROOT=/usr/share/X11/locale" >> /etc/profile


source /etc/profile

exec "$@"

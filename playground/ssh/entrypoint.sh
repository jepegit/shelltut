#!/bin/sh
set -eu

mkdir -p /home/shelltut/.ssh /data/incoming
if [ -f /keys/authorized_keys ]; then
  cp /keys/authorized_keys /home/shelltut/.ssh/authorized_keys
fi
chown -R shelltut:shelltut /home/shelltut/.ssh /data
chmod 700 /home/shelltut/.ssh
chmod 600 /home/shelltut/.ssh/authorized_keys

exec /usr/sbin/sshd -D -e

#!/bin/bash

set -e

yum install -y wget make gcc
mkdir -p /tmp/src
cd /tmp/src
wget https://github.com/jech/babeld/archive/babeld-1.8.0.tar.gz
tar xf babeld-1.8.0.tar.gz
cd babeld-babeld-1.8.0
make
make install

cat <<EOF | tee /etc/systemd/system/babeld.service
[Unit]
Description=Babel routing daemon
Documentation=man:babeld(8) http://www.pps.univ-paris-diderot.fr/~jch/software/babel/
After=network.target tinc.target

[Service]
Type=simple
# Don't write a PID file, since it prevents babeld from starting again
# in case of crash.
ExecStart=/usr/local/bin/babeld -c /etc/babeld/babeld.conf -I ''
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl enable babeld
rm -rf /tmp/src
yum remove -y wget make gcc

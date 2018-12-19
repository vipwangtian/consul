#!/bin/bash

CURRENTDIR=$(cd `dirname $0`; pwd)
ln -s ${CURRENTDIR}/consul.sh /etc/init.d/consul
chkconfig --add consul
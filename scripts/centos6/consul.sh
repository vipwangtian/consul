#!/bin/bash
#
# consul        This starts and stops consul
#
# chkconfig: 2345 20 80
# description: This starts and stops consul

CURRENTDIR=$(cd `dirname $0`; pwd)
if [ -L $0 ];then
    realpath=`readlink -f $0`
    CURRENTDIR=$(cd `dirname $realpath`; pwd)
fi
LOGDIR=${CURRENTDIR}/log
LOGFILE=${LOGDIR}/consul.log
PIDFILE=${CURRENTDIR}/consul.pid
CONFIGFILE=${CURRENTDIR}/consul.json
DAEMON_OUT=${CURRENTDIR}/consul.out
PROG=consul
CONSUL=${CURRENTDIR}/${PROG}

# Source function library.
. /etc/rc.d/init.d/functions

RETVAL=0

start(){
    test -x ${CONSUL} || exit 5
    test -f ${CONFIGFILE} || exit 6
    echo -n $"Starting $PROG: "
    if [ ! -d "${LOGDIR}" ];then
        mkdir ${LOGDIR}
    fi
    if [ -f "${PIDFILE}" ];then
        if kill -0 `cat "${PIDFILE}"` > /dev/null 2>&1; then
            echo consul already running as process `cat "${PIDFILE}"`. 
            exit 0
        fi
    fi
    daemon --check ${CONSUL} "nohup ${CONSUL} agent -config-file=${CONFIGFILE} -log-file=${LOGFILE} -pid-file=${PIDFILE} > ${DAEMON_OUT} 2>&1 < /dev/null &"
    #nohup ${CONSUL} agent -config-file="${CONFIGFILE}" -log-file="${LOGFILE}" -pid-file="${PIDFILE}" > "${DAEMON_OUT}" 2>&1 < /dev/null &
    RETVAL=$?
    echo
    [ $RETVAL = 0 ]
    return $RETVAL
}

stop(){
    echo -n $"Stopping $PROG: "
    killproc -p ${PIDFILE} ${PROG}
    RETVAL=$?
    echo
    [ $RETVAL = 0 ] && rm -f ${PIDFILE}
}

restart(){
    stop
    start
}

case "$1" in
    start)
	start
	;;
    stop)
	stop
	;;
    restart)
	restart
	;;
    status)
    status -p ${PIDFILE} ${CONSUL}
    RETVAL=$?
    ;;
    *)
	echo $"Usage: $0 {start|stop|restart|status}"
	RETVAL=3
esac

exit $RETVAL
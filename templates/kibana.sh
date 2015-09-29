#!/bin/bash
#===============================================================================
# DESCRIPTION: init.d script for kibana 4.x
# chkconfig: 345 90 10
#===============================================================================

# Source function library.
if [ -f /etc/rc.d/init.d/functions ]; then
    . /etc/rc.d/init.d/functions
fi

prog=kibana
exec=/opt/kibana/bin/kibana
lockfile=/var/lock/subsys/$prog
pidfile=/var/run/$prog.pid
STARTUP_LOG=/var/log/${prog}.log
user=$prog

touch $STARTUP_LOG
chown $user $STARTUP_LOG
chown $user $pidfile
chown $user $lockfile

start() {
	[ -x $exec ] || exit 5
	echo -n $"Starting $prog: "
	b=$(readlink /proc/$(cat $pidfile 2>/dev/null)/exe | sed -e 's/\s*(deleted)$//')
	if [ "$b" == "$exec" ]; then
		RETVAL=1
		echo -n "Already running !" && warning
		echo
		return $RETVAL
	fi
	sudo -u $user nohup $exec &>> $STARTUP_LOG &
	RETVAL=$?
	PID=$!
	[ $RETVAL -eq 0 ] && touch ${lockfile} && success || failure
	echo
	echo $PID > ${pidfile}
	return $RETVAL
}

stop() {
	echo -n $"Stopping $prog: "
	killproc -p "${pidfile}" -d 30 $prog
	RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f $lockfile
    return $RETVAL
}

rh_status() {
	status -p "${pidfile}" -l $lockfile $prog
}

case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        status)
                rh_status
                ;;
        restart)
                stop
                start
                ;;
        *)
                echo $"Usage: $0 {start|stop|status|probe|restart} [debug]"
                exit 2
esac

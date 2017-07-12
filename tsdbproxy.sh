#!/bin/sh
#
# chkconfig: 2345 64 36
# description: tsdbproxy startup scripts
#
tsdbproxy_root=/ts/sbin
# each config file for one instance
configs="/ts/etc/ks.yaml"
pidfile="/ts/etc/tsdbproxy.pid"

ulimit -c unlimited
echo 1 > /proc/sys/fs/suid_dumpable
echo  "/ts/share/%e-%p-%s-%t.core" >/proc/sys/kernel/core_pattern

ulimit -n 1024000 
 
start() {
	test -f $pidfile && echo "tsdbproxy is running" 
	nohup $tsdbproxy_root/tsdbproxy -config $configs &
	sleep 1
	test -f $pidfile && echo "Start tsdbproxy success"
}
 
stop() {
    pids=`ps aux | grep tsdbproxy | grep -v grep | awk '{print $2}' | xargs`
    kill -9 `echo $pids`
    test -f $pidfile && rm $pidfile
    echo "Stop tsdbproxy success";
} 
# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart}"
        ;;
esac
exit 0 

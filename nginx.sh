#!/bin/bash
HOST="127.0.0.1"
PORT="80"
stub_status=nginx_status
pidof_addr=`which pidof`
function check() {
        if [ -f $pidof_addr ]; then
           $pidof_addr nginx | wc -w
        else
           ps ax | grep -v "grep" | grep -c "nginx:"
        fi
}

function active() {
        /usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Active' | awk '{print $NF}'
}
function accepts() {
        /usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $1}'
}
function handled() {
        /usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $2}'
}
function requests() {
        /usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $3}'
}
function reading() {
        /usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Reading' | awk '{print $2}'
}
function writing() {
        /usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Writing' | awk '{print $4}'
}
function waiting() {
        /usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
}
function cpu_cores() {
        cat /proc/cpuinfo | grep processor | wc -l
}
function worker_processes(){
        worker_processes=`$pidof_addr nginx | wc -w`; echo "$worker_processes - 1" | bc
}
function worker_connections(){
        cat /usr/local/nginx/conf/nginx.conf | grep worker_connections | awk '{print $2}' | sed 's/\;//'
}
function max_connections(){
        worker_processes=`ps ax | grep nginx | grep -v grep | wc -l`;wkr_proce=`echo "$worker_processes - 1" | bc`;wkr_conn=`cat /usr/local/nginx/conf/nginx.conf | grep worker_connections | awk '{print $2}' | sed 's/\;//'`;echo "$wkr_conn*$wkr_proce" | bc
}
function max_file_descriptors(){
        cat /proc/sys/fs/file-nr | awk '{print $3}'
}
function open_file_descriptors(){
        cat /proc/sys/fs/file-nr | awk '{print $1}'
}
function req_per_conn(){
        handled=`/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $2}'`;handles=`/usr/bin/curl -s "http://$HOST:$PORT/${stub_status}/" 2>/dev/null| awk NR==3 | awk '{print $3}'`;echo "$handles/$handled" | bc
}

case "$1" in
        check)
                check
                ;;
        active)
                active
                ;;
        accepts)
                accepts
                ;;
        handled)
                handled
                ;;
        requests)
                requests
                ;;
        reading)
                reading
                ;;
        writing)
                writing
                ;;
        waiting)
                waiting
                ;;
        cpu_cores)
                cpu_cores;;
        worker_processes)
                worker_processes;;
        worker_connections)
                worker_connections;;
        max_connections)
                max_connections;;
        max_file_descriptors)
                max_file_descriptors;;
        open_file_descriptors)
                open_file_descriptors;;
        req_per_conn)
                req_per_conn;;
        *)
                echo $"Usage $0 {check|active|accepts|handled|requests|reading|writing|waiting|cpu_cores|worker_processes|worker_connections|max_connections|max_file_descriptors|open_file_descriptors|req_per_conn}"
                exit
esac

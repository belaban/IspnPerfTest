#!/bin/bash


# Author: Bela Ban

DIR=`dirname $0`
PT="$DIR/../"

CP=$PT/classes:$PT/lib/*:$CONF

if [ -f $HOME/log4j.properties ]; then
    LOG="-Dlog4j.configuration=file:$HOME/log4j.properties"
fi;

if [ -f $HOME/log4j2.xml ]; then
    LOG="$LOG -Dlog4j.configurationFile=$HOME/log4j2.xml"
fi;

if [ -f $HOME/logging.properties ]; then
    LOG="$LOG -Djava.util.logging.config.file=$HOME/logging.properties"
fi;


### Note: change max heap to 2G on cluster01-08 (physical mem: 4G) !
### On edg-perf, this is OK (physical mem: 32G)
FLAGS="$FLAGS -server -Xms2G -Xmx2G"
FLAGS="$FLAGS -Djava.net.preferIPv4Stack=true"

## Delay asking backup for GET in Infinispan:
FLAGS="$FLAGS -Dinfinispan.stagger.delay=5000"

## BYTEMAN: uncomment the line below if you want to get timings (avg-send-time, avg-receive-time, avg-delivery-time)
## Run probe timings / timings-reset
#BM="-javaagent:$PT/lib/byteman.jar=script:$CONF/delivery.btm,script:$CONF/send.btm,script:$CONF/requests.btm"

exec `dirname $0`/perf-test.sh -cfg dist-sync-aws.xml -jgroups-cfg control-aws.xml $*

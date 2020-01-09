#!/bin/bash

info=('opcountersRepl insert' 'opcountersRepl query' 'opcountersRepl update' 'opcountersRepl delete' 'opcountersRepl getmore' 'opcountersRepl command' 'connections current' 'connections available' 'connections totalCreated' 'activeClients total' 'activeClients readers' 'activeClients writers' 'globalLock totalTime' 'document deleted' 'document inserted' 'document returned' 'document updated' 'network bytesIn' 'network bytesOut' 'network numRequests' 'mem mapped' 'mem mappedWithJournal' 'mem virtual' 'mem resident' 'opcounters insert' 'opcounters query' 'opcounters update' 'opcounters delete' 'opcounters getmore' 'opcounters command' 'currentQueue total' 'currentQueue readers' 'currentQueue writers')

len=${#info[@]}

for (( i=0;i<$len;i++ ))
do
    echo "mongodn_stats.sh ${info[$i]}"
    ./mongodb_stats.sh ${info[$i]}
done

#!/bin/bash

ccm create test1node -v 1.2.0
ccm populate -n 1
ccm start
echo -e '\n-----------------test1node------------------------------\n'
echo -e '\n----------------10000 insert-------------------\n'
ccm stress -l 1 -n 10000 -o insert
echo -e '\n----------------10000 read----------------\n'
ccm stress -l 1 -n 10000 -o read

ccm stop

echo -e '\n-----------------test4node-----------------------------\n'

ccm create test4node -v 1.2.0
ccm populate -n 4
ccm start

cd ~/.ccm/repository/1.2.0/
chmod +x tools/bin/cassandra-stress
echo -e '\n----------------10000 insert - 4 replicats - 4 nodes contacted---------\n'
tools/bin/cassandra-stress -d 127.0.0.1,127.0.0.2,127.0.0.3,127.0.0.4 -l 4 -n 10000 -o insert
echo -e '\n----------------10000 read - 4 replicats - 4 nodes contacted-----------\n'
tools/bin/cassandra-stress -d 127.0.0.1,127.0.0.2,127.0.0.3,127.0.0.4 -l 4 -n 10000 -o read


ccm remove test4node
ccm remove test1node
echo -e '\n-------------clusters removed-------------\n'

#!/bin/bash

# Create a new instance with 8 nodes
ccm create scenarioTwo2 -v 1.2.0
ccm populate -n 8
ccm start
export CASS_HOST=127.0.0.1
echo -e '=== Nodes created and started ===\n'

# Prediction module for logging the latencies
#wget http://downloads.sourceforge.net/cyclops-group/jmxterm-1.0-alpha-4-uber.jar
echo "run -b org.apache.cassandra.service:type=PBSPredictor enableConsistencyPredictionLogging" | java -jar jmxterm-1.0-alpha-4-uber.jar -l $CASS_HOST:7100
echo -e '=== Prediction module loaded ===\n'

# Going to the tool directory
cd ~/.ccm/repository/1.2.0/
chmod +x tools/bin/cassandra-stress
echo -e '=== Cassandra Stress Program found ===\n'

# Launch the cassandra-stress
echo -e '=== Beginning to insert 10000 rows ===\n'
tools/bin/cassandra-stress -d $CASS_HOST -l 3 -n 10000 -o insert #-e ONE
echo -e '=== Insert 10000 OK === \n'
echo -e '\n === Beginning to read 10000 rows === '
tools/bin/cassandra-stress -d $CASS_HOST -l 3 -n 10000 -o read #-e ALL
echo -e '=== Read 10000 rows OK === \n'

# Rendering the analysis
echo -e '\n === Rendering the analysis - 10 MS === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 10 1

echo -e '\n === Rendering the analysis - 20 MS === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 20 1

echo -e '\n === Rendering the analysis - 30 MS === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 30 1

echo -e '\n === Rendering the analysis - 40 MS === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 40 1

echo -e '\n === Rendering the analysis - 50 MS === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 50 1

echo -e '\n === Rendering the analysis - 100 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 1

echo -e '\n === Rendering the analysis - 200 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 200 1

echo -e '\n === Rendering the analysis - 300 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 300 1

echo -e '\n === Rendering the analysis - 400 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 400 1

echo -e '\n === Rendering the analysis - 500 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 500 1

echo -e '\n === Rendering the analysis - 750 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 750 1

echo -e '\n === Rendering the analysis - 1000 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 1000 1

echo -e '\n === Rendering the analysis - 2000 MS=== \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 2000 1

# Cleaning all our stuffs
ccm stop
ccm remove scenarioTwo2
echo -e '=== Clusters removed === \n'

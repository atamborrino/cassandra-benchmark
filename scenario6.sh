#!/bin/bash

# Create a new instance with 8 nodes
ccm create scenarioSix -v 1.2.0
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
echo -e '\n === Rendering the analysis - 100 MS - Staleness 1 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 1

echo -e '\n === Rendering the analysis - 100 MS - Staleness 2 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 2

echo -e '\n === Rendering the analysis - 100 MS - Staleness 3 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 3

echo -e '\n === Rendering the analysis - 100 MS - Staleness 4 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 4

echo -e '\n === Rendering the analysis - 100 MS - Staleness 5 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 5

echo -e '\n === Rendering the analysis - 100 MS - Staleness 6 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 6

echo -e '\n === Rendering the analysis - 100 MS - Staleness 7 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 7

echo -e '\n === Rendering the analysis - 100 MS - Staleness 8 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 8

echo -e '\n === Rendering the analysis - 100 MS - Staleness 9 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 9

echo -e '\n === Rendering the analysis - 100 MS - Staleness 10 === \n'
bin/nodetool -h $CASS_HOST -p 7100 predictconsistency 3 100 10


# Cleaning all our stuffs
ccm stop
ccm remove scenarioSix
echo -e '=== Clusters removed === \n'

#!/bin/bash
PROVIDERS="aws"
CONCURRENCES="10"

for REPETITION in {1..10};do
  for i in $PROVIDERS; do
    PROVIDER=$i
    URL=$(cat ../blueprints/$PROVIDER/url_get.tmp | tail -1 | sed -e 's/[^a-zA-Z*0-9*\/*\.*:*-]//g' | sed -e 's/0m//g' | awk -F/ '{print $3}' )
      for x in $CONCURRENCES; do
        echo "CONCURRENCE=$x"
        CONCURRENCE=$x
        jmeter -n -t benchmark.jmx \
          -Jurl=${URL} \
          -Jprovider=${PROVIDER} \
          -Jrepetition=${REPETITION} \
          -Jconcurrence=${CONCURRENCE} 
      done
  done
done

# Generate dashboards
echo "Generating HTML Dashboards"
for REPETITION in {1..10};do
  for i in $PROVIDERS; do
    PROVIDER=$i
      for x in $CONCURRENCES; do
        CONCURRENCE=$x
        CSV=$(ls ../results/benchmark/${PROVIDER}/${CONCURRENCE}/${REPETITION})
        HTML="../results/benchmark/${PROVIDER}/${CONCURRENCE}/${REPETITION}/html"
        jmeter -g  ../results/benchmark/${PROVIDER}/${CONCURRENCE}/${REPETITION}/${CSV} -o ${HTML}
      done
  done
done
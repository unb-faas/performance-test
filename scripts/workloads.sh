#/bin/bash
PROVIDERS="aws"
#CONCURRENCE="10 20 30 40 50 60 70 80 90 100"
REPETITIONS=5
CONCURRENCE="10 30 50 70 100 150 200"
BASELINE=$(date +%Y%m%d%H%M%S)
WAIT_TIME=30 #SECONDS
MODE="workloads"
TIMEOUT=600 #10 MINUTES
PARAMS_FILE="../results/${MODE}/${BASELINE}/params.txt"
mkdir -p "../results/${MODE}/${BASELINE}"
echo "providers:$PROVIDERS"     >> $PARAMS_FILE
echo "repetitions:$REPETITIONS" >> $PARAMS_FILE
echo "concurrence:$CONCURRENCE" >> $PARAMS_FILE
echo "baseline:$BASELINE"       >> $PARAMS_FILE
echo "wait_time:$WAIT_TIME"     >> $PARAMS_FILE

for i in $PROVIDERS; do
    for x in $CONCURRENCE; do
        COUNT_REPETITION=1
        while [ $COUNT_REPETITION -le $REPETITIONS ]; do
            REPETITION_NOW=$COUNT_REPETITION
            CONCURRENCE_NOW=$x
            PROVIDER=$i
            URLt=$(cat ../blueprints/$PROVIDER/url_get.tmp | sed -e 's/[^a-zA-Z*0-9*\/*\.*:*-]//g' | sed -e 's/0m//g'  )
            CONT=1
            echo -e "\nRunning repetition ${REPETITION_NOW} of workload ${CONCURRENCE_NOW} on ${PROVIDER}..."
            while [ $CONT -le $CONCURRENCE_NOW ]; do
                RESULTS_PATH="../results/${MODE}/${BASELINE}/${PROVIDER}/${CONCURRENCE_NOW}/${REPETITION_NOW}/RAW"
                mkdir -p $RESULTS_PATH
                echo -e "$CONT \c$(                                                     \
                    echo -e "begin:`date +%s%N`" >> $RESULTS_PATH/$CONT;       \
                    curl -m $TIMEOUT -s -i $URLt -X POST -H 'Content-Type: application/json' --data "${line}" >> $RESULTS_PATH/$CONT ; \
                    echo -e "\nend:`date +%s%N`" >> $RESULTS_PATH/$CONT;    \
                )" &
                CONT=$((CONT + 1))
            done
            # Let server breath a lithe bit
            echo -e "\nWaiting ${WAIT_TIME}s..."
            sleep $WAIT_TIME
            COUNT_REPETITION=$((COUNT_REPETITION + 1))
        done
        echo -e "\nWaiting ${WAIT_TIME}s..."
        sleep $WAIT_TIME
    done
done
echo -e "\nWorkloads finished"
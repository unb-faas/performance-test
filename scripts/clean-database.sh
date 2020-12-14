#/bin/bash
PROVIDERS="aws"
FAAS="get post delete"
BASELINE=$(date +%Y%m%d%H%M%S)
WAIT_TIME=5 #SECONDS
BLOCKSIZE=100
MODE="delete"
CONT=0
TIMEOUT=600 #10 MINUTES
MAX_REVOLUTIONS=1000
for i in $PROVIDERS; do
    RESULTS_PATH="../results/$MODE/$BASELINE/$i/1/1/RAW"
    mkdir -p $RESULTS_PATH
    curl -s $(cat ../blueprints/$i/url_get.tmp) | jq -c .[].id > last-block-to-delete.json.tmp
    echo -e "\nDeleting records..."
    while [ $CONT -lt $MAX_REVOLUTIONS ]; do
        while IFS= read -r line;do
            URLt=$(cat ../blueprints/$i/url_$MODE.tmp | sed -e 's/[^a-zA-Z*0-9*\/*\.*:*-]//g' | sed -e 's/0m//g'  )
            echo -e "$line \c $( \
                    echo -e "begin:`date +%s%N`" >> $RESULTS_PATH/$CONT; \
                    curl -m $TIMEOUT -s -i "${URLt}?id=${line}" -X DELETE -H 'Content-Type: application/json' >> $RESULTS_PATH/$CONT ; \
                    echo -e "\nend:`date +%s%N`" >> $RESULTS_PATH/$CONT)" & 
            CONT=$((CONT + 1))
            if [ $(expr $CONT % $BLOCKSIZE) -eq 0 ]; then
                # Let server breath a lithe bit
                echo -e "Waiting ${WAIT_TIME}s ..."
                sleep $WAIT_TIME
            fi
        done < last-block-to-delete.json.tmp
        curl -s $(cat ../blueprints/$i/url_get.tmp) | jq -c .[].id > last-block-to-delete.json.tmp
    done
    CONT=0
done
echo "Database Cleaned"
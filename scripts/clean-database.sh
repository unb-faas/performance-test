#/bin/bash
PROVIDERS="aws"
FAAS="get post delete"
BASELINE=$(date +%Y%m%d%H%M%S)
WAIT_TIME=5 #SECONDS
BLOCKSIZE=100
MODE="delete"
CONT=0
MAX_REVOLUTIONS=1000
for i in $PROVIDERS; do
    mkdir -p ../results/$MODE/$BASELINE/$i/RAW
    curl -s $(cat ../blueprints/$i/url_get.tmp) | jq -c .[].id > last-block-to-delete.json.tmp
    while [ $CONT -lt $MAX_REVOLUTIONS ]; do
        while IFS= read -r line;do
            echo "$line"
            URLt=$(cat ../blueprints/$i/url_$MODE.tmp | sed -e 's/[^a-zA-Z*0-9*\/*\.*:*-]//g' | sed -e 's/0m//g'  )
            echo $( echo "begin:`date +%s%N`" >> ../results/$MODE/$BASELINE/$i/RAW/$CONT; curl -s -i "${URLt}?id=${line}" -X DELETE -H 'Content-Type: application/json' >> ../results/$MODE/$BASELINE/$i/RAW/$CONT ; echo -e "\nend:`date +%s%N`" >> ../results/$MODE/$BASELINE/$i/RAW/$CONT) & 
            CONT=$((CONT + 1))
            if [ $(expr $CONT % $BLOCKSIZE) -eq 0 ]; then
                # Let server breath a lithe bit
                sleep $WAIT_TIME
            fi    
        done < last-block-to-delete.json.tmp
        curl -s $(cat ../blueprints/$i/url_get.tmp) | jq -c .[].id > last-block-to-delete.json.tmp
    done
    CONT=0
done
echo "Database Cleaned"
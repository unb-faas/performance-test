#/bin/bash
cd ../results
for TYPE in $(ls); do
    if [ "$TYPE" != "consolidation.txt" ]; then
        echo $TYPE
        cd $TYPE
        for EXEC in $(ls); do
            if [ "$EXEC" != "consolidation.txt" ]; then
                echo "Execution: $EXEC"
                cd $EXEC
                for PROVIDER in $(ls); do
                    if [ "$PROVIDER" != "params.txt" ] && [ "$PROVIDER" != "consolidation.txt" ]; then
                        echo "Provider: $PROVIDER"
                        cd $PROVIDER
                        for WORKLOAD in $(ls); do
                            if [ "$WORKLOAD" != "consolidation.txt" ]; then
                                echo "Workload: $WORKLOAD"
                                cd $WORKLOAD
                                wCOUNTER=0
                                wAVG_SUM=0
                                wERR_SUM=0       
                                for REPETITION in $(ls); do
                                    if [ "$REPETITION" != "consolidation.txt" ]; then
                                        echo "Repetition: $REPETITION"
                                        cd $REPETITION/RAW
                                        COUNTER=0
                                        AVG_SUM=0
                                        ERR_SUM=0
                                        for FILE in $(ls); do
                                            BEGIN=$(cat $FILE | grep begin: | awk -F: '{print $2}' | sed 's/\\n//g' )
                                            END=$(cat $FILE | grep end: | awk -F: '{print $2}' | sed 's/\\n//g' ) 
                                            #echo "$FILE - b:$BEGIN - e:$END" #DEBUG
                                            AVG=$(expr $END - $BEGIN)
                                            AVG_SUM=$(expr $AVG_SUM + $AVG)
                                            COUNTER=$((COUNTER + 1))
                                            ERRORS=$(cat $FILE | grep 'HTTP/2 500' | wc -l )
                                            ERR_SUM=$((ERR_SUM + ERRORS))
                                        done
                                        if [ $COUNTER -ne 0 ]; then
                                            AVG_AVG=$(expr $AVG_SUM / $COUNTER)
                                        else 
                                            AVG_AVG=0
                                        fi
                                        echo "AVG EXECUTION TIME (nanoseconds) $COUNTER executions: $AVG_AVG"
                                        echo "ERRORs: $ERR_SUM"
                                        cd ..
                                        echo "avg-execution-time:$AVG_AVG" > consolidation.txt
                                        echo "count-executions:$COUNTER" >> consolidation.txt
                                        echo "errors:$ERR_SUM" >> consolidation.txt

                                        wCOUNTER=$((wCOUNTER + COUNTER))
                                        wAVG_SUM=$((wAVG_SUM + AVG_SUM))
                                        wERR_SUM=$((wERR_SUM + ERR_SUM))
                                        cd ..
                                    fi
                                done
                                if [ $wCOUNTER -ne 0 ]; then
                                    wAVG_AVG=$(expr $wAVG_SUM / $wCOUNTER)
                                else 
                                    wAVG_AVG=0
                                fi
                                echo "avg-execution-time:$wAVG_AVG" > consolidation.txt
                                echo "count-executions:$wCOUNTER" >> consolidation.txt
                                echo "errors:$wERR_SUM" >> consolidation.txt
                                    
                                cd ..
                            fi
                        done
                        cd ..
                    fi
                done
                cd ..
            fi
        done
        cd .. 
    fi   
done
echo "Consolidation finished"
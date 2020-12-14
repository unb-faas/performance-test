#/bin/bash
cd ../results
for TYPE in $(ls); do
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
                            ECOUNTER=0
                            EAVG_SUM=0
                            EERR_SUM=0
                            for REPETITION in $(ls); do
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
                                ECOUNTER=$((ECOUNTER + 1))
                                EAVG_SUM=$(expr $EAVG_SUM + $EVG_SUM)
                                EERR_SUM=$(expr $EERR_SUM + $ERR_SUM)    
                                cd ..
                            done
                            if [ $ECOUNTER -ne 0 ]; then
                            EAVG_AVG=$(expr $EAVG_SUM / $ECOUNTER)
                            else 
                                EAVG_AVG=0
                            fi
                            echo "avg-execution-time:$EAVG_AVG" > consolidation.txt
                            echo "count-executions:$ECOUNTER" >> consolidation.txt
                            echo "errors:$EERR_SUM" >> consolidation.txt
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
done
echo "Consolidation finished"
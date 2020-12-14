#/bin/bash
PROVIDERS="aws"
FAAS="get post delete"
URL="https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/SRAG/2020/INFLUD-07-12-2020.csv"
FILE="INFLUD-07-12-2020.csv"
BASELINE=$(date +%Y%m%d%H%M%S)
WAIT_TIME=5 #SECONDS
BLOCKSIZE=300
RECORDS=10000
TIMEOUT=600 #10 MINUTES
MODE="upload"
if test -f $FILE; then
    echo "File $FILE OK"
else 
    echo "File $FILE was not found, downloading..."
    curl $URL -o FILE
    echo "File $FILE OK"
fi
######
# Instructions to generate, if necessary
# Create a file with content of "head -1 $FILE" command
# Then execute "CONT=0; for i in $(cat temp | sed 's/"//g' | sed 's/;/ /g'); do echo "\"${i}\": .[${CONT}],"; CONT=$((CONT + 1)); done"
# Remove the last comma
######
tail -n$RECORDS $FILE | sed -e 's/"//g' | \
jq --slurp --raw-input --raw-output \
    'split("\n") | .[1:] | map(split(";")) |
        map({
            "DT_NOTIFIC": .[0], 
            "SEM_NOT": .[1],
            "DT_SIN_PRI": .[2],
            "SEM_PRI": .[3],
            "SG_UF_NOT": .[4],
            "ID_REGIONA": .[5],
            "CO_REGIONA": .[6],
            "ID_MUNICIP": .[7],
            "CO_MUN_NOT": .[8],
            "ID_UNIDADE": .[9],
            "CO_UNI_NOT": .[10],
            "CS_SEXO": .[11],
            "DT_NASC": .[12],
            "NU_IDADE_N": .[13],
            "TP_IDADE": .[14],
            "COD_IDADE": .[15],
            "CS_GESTANT": .[16],
            "CS_RACA": .[17],
            "CS_ETINIA": .[18],
            "CS_ESCOL_N": .[19],
            "ID_PAIS": .[20],
            "CO_PAIS": .[21],
            "SG_UF": .[22],
            "ID_RG_RESI": .[23],
            "CO_RG_RESI": .[24],
            "ID_MN_RESI": .[25],
            "CO_MUN_RES": .[26],
            "CS_ZONA": .[27],
            "SURTO_SG": .[28],
            "NOSOCOMIAL": .[29],
            "AVE_SUINO": .[30],
            "FEBRE": .[31],
            "TOSSE": .[32],
            "GARGANTA": .[33],
            "DISPNEIA": .[34],
            "DESC_RESP": .[35],
            "SATURACAO": .[36],
            "DIARREIA": .[37],
            "VOMITO": .[38],
            "OUTRO_SIN": .[39],
            "OUTRO_DES": .[40],
            "PUERPERA": .[41],
            "FATOR_RISC": .[42],
            "CARDIOPATI": .[43],
            "HEMATOLOGI": .[44],
            "SIND_DOWN": .[45],
            "HEPATICA": .[46],
            "ASMA": .[47],
            "DIABETES": .[48],
            "NEUROLOGIC": .[49],
            "PNEUMOPATI": .[50],
            "IMUNODEPRE": .[51],
            "RENAL": .[52],
            "OBESIDADE": .[53],
            "OBES_IMC": .[54],
            "OUT_MORBI": .[55],
            "MORB_DESC": .[56],
            "VACINA": .[57],
            "DT_UT_DOSE": .[58],
            "MAE_VAC": .[59],
            "DT_VAC_MAE": .[60],
            "M_AMAMENTA": .[61],
            "DT_DOSEUNI": .[62],
            "DT_1_DOSE": .[63],
            "DT_2_DOSE": .[64],
            "ANTIVIRAL": .[65],
            "TP_ANTIVIR": .[66],
            "OUT_ANTIV": .[67],
            "DT_ANTIVIR": .[68],
            "HOSPITAL": .[69],
            "DT_INTERNA": .[70],
            "SG_UF_INTE": .[71],
            "ID_RG_INTE": .[72],
            "CO_RG_INTE": .[73],
            "ID_MN_INTE": .[74],
            "CO_MU_INTE": .[75],
            "UTI": .[76],
            "DT_ENTUTI": .[77],
            "DT_SAIDUTI": .[78],
            "SUPORT_VEN": .[79],
            "RAIOX_RES": .[80],
            "RAIOX_OUT": .[81],
            "DT_RAIOX": .[82],
            "AMOSTRA": .[83],
            "DT_COLETA": .[84],
            "TP_AMOSTRA": .[85],
            "OUT_AMOST": .[86],
            "PCR_RESUL": .[87],
            "DT_PCR": .[88],
            "POS_PCRFLU": .[89],
            "TP_FLU_PCR": .[90],
            "PCR_FLUASU": .[91],
            "FLUASU_OUT": .[92],
            "PCR_FLUBLI": .[93],
            "FLUBLI_OUT": .[94],
            "POS_PCROUT": .[95],
            "PCR_VSR": .[96],
            "PCR_PARA1": .[97],
            "PCR_PARA2": .[98],
            "PCR_PARA3": .[99],
            "PCR_PARA4": .[100],
            "PCR_ADENO": .[101],
            "PCR_METAP": .[102],
            "PCR_BOCA": .[103],
            "PCR_RINO": .[104],
            "PCR_OUTRO": .[105],
            "DS_PCR_OUT": .[106],
            "CLASSI_FIN": .[107],
            "CLASSI_OUT": .[108],
            "CRITERIO": .[109],
            "EVOLUCAO": .[110],
            "DT_EVOLUCA": .[111],
            "DT_ENCERRA": .[112],
            "DT_DIGITA": .[113],
            "HISTO_VGM": .[114],
            "PAIS_VGM": .[115],
            "CO_PS_VGM": .[116],
            "LO_PS_VGM": .[117],
            "DT_VGM": .[118],
            "DT_RT_VGM": .[119],
            "PCR_SARS2": .[120],
            "PAC_COCBO": .[121],
            "PAC_DSCBO": .[122],
            "OUT_ANIM": .[123],
            "DOR_ABD": .[124],
            "FADIGA": .[125],
            "PERD_OLFT": .[126],
            "PERD_PALA": .[127],
            "TOMO_RES": .[128],
            "TOMO_OUT": .[129],
            "DT_TOMO": .[130],
            "TP_TES_AN": .[131],
            "DT_RES_AN": .[132],
            "RES_AN": .[133],
            "POS_AN_FLU": .[134],
            "TP_FLU_AN": .[135],
            "POS_AN_OUT": .[136],
            "AN_SARS2": .[137],
            "AN_VSR": .[138],
            "AN_PARA1": .[139],
            "AN_PARA2": .[140],
            "AN_PARA3": .[141],
            "AN_ADENO": .[142],
            "AN_OUTRO": .[143],
            "DS_AN_OUT": .[144],
            "TP_AM_SOR": .[145],
            "SOR_OUT": .[146],
            "DT_CO_SOR": .[147],
            "TP_SOR": .[148],
            "OUT_SOR": .[149],
            "DT_RES": .[150],
            "RES_IGG": .[151],
            "RES_IGM": .[152],
            "RES_IGA": .[153]
            })' > "${FILE}.json.tmp"
cat "${FILE}.json.tmp" | jq -c .[] > "${FILE}.json-inline.tmp"
CONT=0
for i in $PROVIDERS; do
    PROVIDER=$i
    if [ "$PROVIDER" == "gcp" ]; then
        EXTRA_BEGIN='{"value":'
        EXTRA_END='}'
    fi
    RESULTS_PATH="../results/$MODE/$BASELINE/$i/1/1/RAW"
    mkdir -p $RESULTS_PATH
    while IFS= read -r line;do
        URLt=$(cat ../blueprints/$i/url_post.tmp | sed -e 's/[^a-zA-Z*0-9*\/*\.*:*-]//g' | sed -e 's/0m//g'  )
        echo -e "$CONT \c$(                                                                         \
                echo "begin:`date +%s%N`" >> $RESULTS_PATH/$CONT;   \
                curl -m $TIMEOUT -s -i $URLt -X POST -H 'Content-Type: application/json' --data "${EXTRA_BEGIN}${line}${EXTRA_END}" >> $RESULTS_PATH/$CONT ; \
                echo -e "\nend:`date +%s%N`" >> $RESULTS_PATH/$CONT \
              )" &
        CONT=$((CONT + 1))
        if [ $(expr $CONT % $BLOCKSIZE) -eq 0 ]; then
            # Let server breath a lithe bit
            sleep $WAIT_TIME
        fi    
    done < "${FILE}.json-inline.tmp"
    CONT=0
done
echo "Upload finished"
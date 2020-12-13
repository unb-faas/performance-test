#garante requisitos terraform (arquivos de credencial e pacotes)


#provisiona Dbaas pegando parametros ip, user e senha
#na pasta de cada provider
terraform init
terraform plan -auto-approve
terraform apply -auto-approve
##criar tabela dinamica no banco (terraform ja cria?)

##dar carga do arquivo csv no banco
mysql -h 34.95.14.241 -ufunction -p --local-infile=1 srag2020 -e "LOAD DATA LOCAL INFILE 'INFLUD-30-11-2020_carga_mysql.csv'  INTO TABLE teste FIELDS TERMINATED BY ',' enclosed by '\"'"

#provisiona function

#start de carga da function

#coleta de dados da function

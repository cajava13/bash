#!/bin/bash

customer_start=10
ammount_of_customers=4
notificar_en_log_cada=10

customer_end=$(($customer_start+$ammount_of_customers))
customer_end_log=$(($customer_start+$ammount_of_customers-1))

# LOGS Y DIRSs
if [ ! -d /home/github/csv_generator/output ]
then
  mkdir -p /home/github/csv_generator/output
fi
if [ ! -d /home/github/csv_generator/log ]
then
  mkdir -p /home/github/csv_generator/log
fi

SCRIPTROOT=/home/github/csv_generator
LOG_FILE=$SCRIPTROOT/log/csv_generator.log
OUTPUT_ROOT=$SCRIPTROOT/output

#OUTPUT FILES
#create
CREATE_CUSTOMER=$OUTPUT_ROOT/create_customer.csv

#-------------------------------------- FUNCIONES AUXILIARES ----------------------------------------
# Funcion de logueo
# parametro 1: string a incluir
# parametro 2: tipo de log {0|1}  --  0-exito, 1-falla y aborta procedimiento
function logMe() {
        echo "$(date) ($$) - $1 .-" >> ${LOG_FILE} 2>/dev/null
        if [ $? -ne 0 ]
        then
                echo "No se puede escribir el log ${LOG_FILE} !! Abortando ejecucion."
                exit 1
        else
                if [ $2 -gt 0 ]
                then
                        exit $2
                fi
        fi
}

CODIGOEXIT=0

logMe "----------------------------------------------------" 0
logMe "INICIO DE EJECUCION" 0

logMe "Elimino los csv existentes" 0
rm -f $CREATE_CUSTOMER

logMe "Comienzo la construccion de los nuevos CVS" 0
logMe "Valor de inicio: $customer_start" 0
logMe "Valor de fin: $customer_end_log" 0
logMe "Cantidad de clientes: $ammount_of_customers" 0
logMe "Comienzo loop para crear $ammount_of_customers sentencias" 0

cuenta_actual=0
date_formated=$(date +%Y_%m_%d)
for (( i=$customer_start; i<$customer_end; i++ ))
do
	cuenta_actual=$(($cuenta_actual+1))
	#defino ids
	createDate=""$date_formated""
	customer_id="customer_"$date_formated"_"$i
	indice="${cuenta_actual: -1}"
	
	case $indice in
		0)
			city="New York"
			;;
		1)
			city="London"
			;;
		2)
			city="Paris"
			;;
		3)
			city="Tokio"
			;;
		4)
			city="Berlin"
			;;
		5)
			city="Roma"
			;;
	esac

	#CREACION ARCHIVOS CSV

	#CREATES
	#customer
	echo "CustomerId:"$customer_id",CreateDate:"$createDate",Company:ARGENTINA_SOFT,City:"$city",Phone:" >> $CREATE_CUSTOMER
	
	
	if (( $cuenta_actual % $notificar_en_log_cada == 0 && $i!=0 ))
	then
		logMe "Van $cuenta_actual de $ammount_of_customers" 0
	fi	
done

#Borro los archivos auxiliares
#logMe "Borro los archivos auxiliares" 0



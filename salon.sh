#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
CREATE_NEW_CUSTOMER(){
  
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    #echo $INSERT_CUSTOMER_RESULT
    } 

BOOK_APPOINTMENT(){
echo -e "\nWhat service would you like to request?"
read SERVICE_ID_SELECTED

if [[ ! "$SERVICE_ID_SELECTED" =~ [1-3] ]]
  then
  MAIN_MENU "Please input a valid service number"
   
  else
  echo -e "\nEnter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    CREATE_NEW_CUSTOMER
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  fi
  
    echo -e "\nWhat time should we schedule you for?"
    read SERVICE_TIME
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    #echo $INSERT_APPOINTMENT_RESULT
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/^ *| *$//g' ) at $SERVICE_TIME, $CUSTOMER_NAME."
  
  fi


}
MAIN_MENU(){
echo -e "\n~~~ Our Services ~~~\n"
OFFERED_SERVICES=$($PSQL "SELECT service_id, name FROM services")
echo "$OFFERED_SERVICES" | while read SERVICE_ID BAR NAME
do
  if [[ $NAME != 'name' ]]
  then
    echo "$SERVICE_ID) $NAME"
  fi
done
if [[ $1 ]]
    then
      echo -e "\n$1"
    fi
BOOK_APPOINTMENT
}

MAIN_MENU
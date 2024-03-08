#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"

SERVICE_LIST() { 
  if [[ $1 ]]
    then
      echo -e "\n$1"
    fi

  # get list of services
  LIST_SERVICES=$($PSQL "SELECT * FROM services")

  # display list of services
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR NAME
  do 
  echo "$SERVICE_ID) $NAME"
  done


  # pick a service
  echo -e "\nPick a service"
  read SERVICE_ID_SELECTED

  # if no service available
  case $SERVICE_ID_SELECTED in
    [1-5]) APPOINTMENT_MENU ;;
     *) SERVICE_LIST "Please enter a valid option." ;;
  esac
}

APPOINTMENT_MENU() {
  # get customer phone number
  echo -e "\nPlease, Enter your phone number"
  read CUSTOMER_PHONE

  # check if customer is in database
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
  # get customer name according the phone number
  echo -e "\nEnter your name"
  read CUSTOMER_NAME

  # insert customer name in database
  INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id =  $SERVICE_ID_SELECTED")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #  get appointment time
  echo -e "\nEnter your appointment time"
  read SERVICE_TIME
  INSERT_CUSTOMER_SERVICE_TIME=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED)") 
  if [[  $INSERT_CUSTOMER_SERVICE_TIME == "INSERT 0 1" ]]
  then
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}

SERVICE_LIST

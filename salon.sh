#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\nWelcome to ~~~ Upper Crust Salon ~~~\n"

MAIN_MENU() {
  echo -e "Please make a selection from the services we offer:\n"
  #Get list of services
  AVAIL_SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")
    echo "$AVAIL_SERVICES" | while read SERV_ID BAR SERVICE
    do
      echo "$SERV_ID) $SERVICE"
    done
    
    read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPT_MENU ;;
    2) APPT_MENU ;;
    3) APPT_MENU ;;
    4) APPT_MENU ;;
    5) APPT_MENU ;;
    6) APPT_MENU ;;
    7) APPT_MENU ;;
    8) APPT_MENU ;;
    9) APPT_MENU ;;
    10) APPT_MENU ;;
    11) EXIT ;;
    *) MAIN_MENU "Please enter a service that we offer."
  esac
}

APPT_MENU() {
  #enter phone number
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #Check if customer exists
    if [[ -z $CUSTOMER_ID ]]
    #If customer does not exist, get customer name and phone number
    then
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME
      #enter customer info into customers table
      NEW_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      #get time for appt
      echo -e "\nWhen would you like your appointment?"
      read SERVICE_TIME
      #get new customer id
      NEW_CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      #create a row in appointments table with customer_id, service_id, time
      NEW_CUST_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($NEW_CUST_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      #get service name to print
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      #Once the appointment has been added, print "I have put you down for a <service> at <time>, <name>."
      echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
      EXIT
    #set appointment for existing customer
    #get customer's name and echo back
    else 
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
      echo -e "\nWelcome back,$CUSTOMER_NAME, what time works best for you?"
      #if cust exists, go straight to setting time
      read SERVICE_TIME
      #enter appointment
      EXIST_CUST_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      #get service name and confirm appointment
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
      EXIT
    fi

  
  
  
  
  
}

EXIT() {
  echo -e "\nThank you for stopping by!"
}
MAIN_MENU

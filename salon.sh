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
      echo -e "\nWhen would you like your appointment?"
      read SERVICE_TIME
    #set appointment for existing customer
    else echo "Welcome back."
    fi

  #if cust exists, go straight to setting time
  
  #get time for appt
  #create a row in appointments table with service_id, name, phone#, time & Customer ID
  #Once the appointment has been added, print "I have put you down for a <service> at <time>, <name>."
}

EXIT() {
  echo -e "\nThank you for stopping by!"
}
MAIN_MENU

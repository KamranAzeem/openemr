#!/bin/bash


# Decide about updating the sqlconf.php ourselves? or let wizard do it?
# All of that logic is below:

echo
echo "Found USE_EXISTING_SETUP set as: ${USE_EXISTING_SETUP}"
echo

if [[ "${USE_EXISTING_SETUP}" == "Y" ]] || [[ "${USE_EXISTING_SETUP}" == "y" ] ; then

  ############################################################################
  # This option is used to retain whatever data is in the database,
  #   in-case you are migrating a running system from one computer to another.
  # This means that the setup wizard MUST NOT run, 
  #   and should simply connect to exising database, with data in it.
  # In this case we need to provide an sqlconf.php,
  #   which is populated with details of existing database.
  #   
  ############################################################################
  
  # The sqlconf.php.template file is placed in /tmp by Dockerfile . 

  # First, Check each environment variable:

  PRODUCTION_SQLCONF_FILE=/var/www/html/sites/default/sqlconf.php
 
  if [[ ! -z "${MYSQL_PORT}" ]] ; then
    MYSQL_PORT=3306
  fi

  if [[ ! -z "${MYSQL_HOST}" ]] && [[ ! -z "${MYSQL_DATABASE}" ]] && [[ ! -z "${MYSQL_USER}" ]] && [[ ! -z "${MYSQL_PASS}" ]]  ; then
    echo "Modifying/Updating  ${PRODUCTION_SQLCONF_FILE} ..."
    sed -e "s/MYSQL_HOST/${MYSQL_HOST}/g" \
        -e "s/MYSQL_PORT/${MYSQL_PORT}/g" \
        -e "s/MYSQL_DATABASE/${MYSQL_DATABASE}/g" \
        -e "s/MYSQL_USER/${MYSQL_USER}/g" \
        -e "s/MYSQL_PASS/${MYSQL_PASS}/g" \
        -e "s/CONFIG_OPTION/1/g" \
        /tmp/sqlconf.php.template > ${PRODUCTION_SQLCONF_FILE}
  else
    echo
    echo "One or more environment variables necessary to populate sqlconf.php were found empty."
    echo "Please set them up in related .env file - for docker-compose, or pass them with docker run command."
    echo "These variables are:"
    echo "MYSQL_HOST , MYSQL_PORT , MYSQL_DATABASE , MYSQL_USER , MYSQL_PASS , MYSQL_DATABASE"
    echo "Note: You do not neet to set or pass MYSQL_ROOT_PASSWORD to this openemr image. It wont do anything!"
  fi
else
  echo
  echo "The environment variable USE_EXISTING_SETUP was found empty or set to N/n."
  echo "In this case, we don't need to setup the sqlconf.php file ourselves."
  echo "The web-based setup/wizard will run,"
  echo "  the admin will provide details of the database on web interface,"
  echo "  and the setup wizard will update the sqlconf.php file itself."
fi



########################################################################################
#
# Run any additional/user-provided scripts found in the /docker-entrypoint.d/ directory.
#

# for SCRIPT_FILE in $(ls -1 /docker-entrypoint.d/*.sh); do
#   echo "Executing ${SCRIPT_FILE} ..."
#   source ${SCRIPT_FILE}
# done

#
#
########################################################################################



# As last step, execute the CMD. 
# You may not find CMD defined in our custom openemr image,
#   because it is already setup in the upstream container image: php:5.6-apache.
exec "$@"


#!/bin/bash

# Check if help is requested
if [ "-h" == $1 ]; then
    echo "[Usage]: sudo $(basename $0) [domain]"
    exit 0
fi

# Check for mysql
if [ ! -e '/usr/bin/mysql' ]; then
    echo "mysql not found. Exiting..."
    exit 1
fi

# Check if sudo/root - needed to access folders
if [ "root" != $(whoami) ]; then
    echo "This script must be run with sudo"
    echo "Run '$(basename $0) -h' for more options"
    exit 1
fi

# If no args, manually request data
if [ -z $1 ]; then
    read -p "Prefix: " Prefix
    read -p "Database: " Db_name
else
    echo "Searching for site"
    Web_path="$(find $(find /home -type d -name web) -type d -name ${1})"
    Wp_config="${Web_path}/public_html/wp-config.php"

    # Call self with no args to swap to manual input
    if [ ! -e ${Wp_config} ]; then
        echo "wp-config.php not found: changing to manual input..."
        /bin/bash ${0}
        exit 0
    fi

    echo "Reading prefix and database"
    Prefix=$(cat ${Wp_config} | grep -oP "table.*'\K(.*)(?=')")
    Db_name=$(cat ${Wp_config} | grep DB_NAME | grep -oP "'(.*?)'" | sed -r "s/'//g" | tail -n 1)

    echo "Prefix: ${Prefix}"
    echo "Database: ${Db_name}"
fi

echo "Generating drop sequence..."
mysql -B -e "SELECT CONCAT('DROP TABLE ', TABLE_SCHEMA, '.', TABLE_NAME, ';') 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME LIKE '${Prefix}%' 
AND TABLE_SCHEMA = '${Db_name}';" | tail -n +2 > ~/drop.sql.tmp

echo "===================="
echo "Commands to execute:"
echo "===================="
cat ~/drop.sql.tmp
echo "--------------------"

read -p "Continue? [Y|n]: " -n 1 -r Answer
# formatting purposes
if [ ! -z $Answer ]; then
    echo
fi
Answer=${Answer:-y}

# Check if yes was specified
if [[ ! $Answer =~ ^[yY] ]]; then
    echo "Cancelled"
    rm ~/drop.sql.tmp
    exit 0
fi

# Execute and delete tmp file
mysql < ~/drop.sql.tmp
rm ~/drop.sql.tmp
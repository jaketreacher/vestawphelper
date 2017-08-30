#!/bin/bash

source "./functions.sh"

# Check if help is requested
if [ "-h" == $1 ]; then
    show_help
    exit 0
fi

# Check for mysql
if [ ! -e '/usr/bin/mysql' ]; then
    echo "mysql not found. Exiting..."
    exit 1
fi

# Check for curl
if [ ! -e '/usr/bin/curl' ]; then
    echo "Curl not found. Exiting..."
    exit 1
fi

# Check if sudo/root - needed to access folders
if [ "root" != $(whoami) ]; then
    echo "This script must be run with sudo"
    echo "Run '$(basename $0) -h' for more options"
    exit 1
fi

# website, database, db_user, password
# -w, -d, -u, -p
if [ -z $4 ]
then
    echo "Must run with four arguments"
    show_help
    exit 1
fi

Website=$1
Db_name=$2
Db_user=$3
Db_password=$4

Web_path="$(find $(find /home -type d -name web) -type d -name ${Website})"

if [ -z ${Web_path} ]; then
    echo "Site doesn't exist."
    exit 1
fi

# Download Wordpress
cd /tmp
if [ ! -e 'latest.tar.gz' ]; then
    echo "Downloading Wordpress"
    curl -O https://wordpress.org/latest.tar.gz
else
    echo "Wordpress already downloaded"
fi

# Extract Wordpress
if [ -e 'wordpress' ]; then
    echo 'Remove old extraction'
    rm -rf wordpress
fi
echo "Extracting files"
tar xzf latest.tar.gz

# Create backup and Move Wordpress
cd ${Web_path}
if [ -e "public_html" ]; then
    echo "Backup current public_html"
    mv public_html "public_html_$(date +%s)"
fi

echo "Moving wordpress into place"
mv /tmp/wordpress public_html

# Configure wp-config.php
cd public_html
cp wp-config-sample.php wp-config.php
echo "Configure wp-config.php"
replace_key 'DB_NAME' "${Db_name}" "wp-config.php"
replace_key 'DB_USER' "${Db_user}" "wp-config.php"
replace_key 'DB_PASSWORD' "${Db_password}" "wp-config.php"
insert_after '.*DB_COLLATE.*' "define('FS_METHOD', 'direct');" 'wp-config.php'
replace_prefix "$(gen_db_prefix)" "wp-config.php"

# Configure ownership
echo "Configure ownership"
Owner=$(stat $(dirname $(pwd)) | grep -oP "Uid:.*?/\K[a-z]*")
chown -R ${Owner}:${Owner} .
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

echo "Done"
#!/bin/bash

HTML_PATH="/var/www/html"

echo "updating ubuntu"
sudo apt update
sudo apt upgrade -y
echo "completed update"

echo "installing emacs"
sudo apt install emacs -y

# echo "install meteor"
# curl https://install.meteor.com/ | sh

echo "install apache"
sudo apt install apache2 -y

echo "install mysql server"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt install mysql-server -y
mysql -uroot -ppassword -e "create database wordpress"

echo "install php"
sudo apt install php libapache2-mod-php php-mcrypt php-mysql -y
sudo apt install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc -y

# we can enable mod_rewrite so that we can utilize the WordPress permalink feature
sudo a2enmod rewrite

# restart apache2
sudo systemctl restart apache2

# download wordpress
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

# we can add a dummy .htaccess file and set its permissions
# so that this will be available for WordPress to use later
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess

# create conf file and upgrade folder
#cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
#touch /tmp/wordpress/wp-config.php
mkdir -p /tmp/wordpress/wp-content/upgrade

# copy wordpress and set user and group on files and folders under $HTML_PATH
sudo rm -rf "$HTML_PATH/"
sudo cp -a /tmp/wordpress/. $HTML_PATH
sudo chown -R www-data:www-data $HTML_PATH

# to give wordpress/apache2 permission to able to create wp-config.php file
sudo chmod 777 $HTML_PATH

# new files created within these directories to inherit the group of the parent directory
sudo find $HTML_PATH -type d -exec chmod g+s {} \;

# give group write access to the wp-content directory so that the web interface can make theme and plugin changes
sudo chmod g+w "$HTML_PATH/wp-content"

# give the web server write access to all of the content in these two directories
sudo chmod -R g+w "$HTML_PATH/wp-content/themes"
sudo chmod -R g+w "$HTML_PATH/wp-content/plugins"

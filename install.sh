#!/usr/bin/env bash

# Based on Jeffrey Way's intall script
# https://github.com/JeffreyWay/Vagrant-Setup


echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Setting up MySQL ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties

echo "--- Adding PHP repository ---"
sudo add-apt-repository -y ppa:ondrej/php5

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite

echo "--- Setting document root ---"
sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www

echo "--- Setting up apache configuration ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "--- Restarting Apache ---"
sudo service apache2 restart

echo "--- Installing composer ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Adding Nodejs repository ---"
sudo add-apt-repository -y ppa:chris-lea/node.js

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing Nodejs ---"
sudo apt-get install -y nodejs

echo "--- Installing our global node packages ---"
sudo npm install gulp -g
sudo npm install bower -g
sudo npm install coffee-script -g

echo "--- Installing RVM ---"
curl -L https://get.rvm.io | bash -s stable

echo "--- Loading RVM ---"
source ~/.rvm/scripts/rvm

echo "--- Installing RVM requirements ---"
rvm requirements

echo "--- Installing Ruby ---"
rvm install ruby
rvm use ruby --default

echo "--- Installing Rubygems ---"
rvm rubygems current

echo "--- Installing our gems ---"
sudo gem install sass compass foreman jekyll

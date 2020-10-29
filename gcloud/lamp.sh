#!/bin/bash
sudo apt update
sudo apt install apache2 mysql-server php php-mysql libapache2-mod-php php-cli
sudo systemctl enable apache2
sudo systemctl start apache2
sudo ufw allow in "Apache Full"
sudo chmod -R 0755 /var/www/html/
sudo echo "<?php phpinfo(); ?>" > /var/www/html/info.php
xdg-open "http://localhost"
xdg-open "http://localhost/info.php"

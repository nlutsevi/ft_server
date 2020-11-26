#Configure autoindex

echo "Quieres el autoindex on u off?"
read autoindex
if [ "$autoindex" == "on" ]; then
sed -i 's/autoindex off;/autoindex on;/g' /etc/nginx/sites-available/config_nginx
elif [ "$autoindex" == "off" ]; then
sed -i 's/autoindex on;/autoindex off;/g' /etc/nginx/sites-available/config_nginx
else
echo "Valor inválido" && exit
fi

service nginx start
service mysql start
service php7.3-fpm start

# Configure a wordpress database
echo "CREATE DATABASE wordpress;"| mysql -u root --skip-password
#echo "CREATE USER 'nat'@'localhost' IDENTIFIED BY '12345';"
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

bash
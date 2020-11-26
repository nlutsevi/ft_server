FROM debian:buster

RUN apt update && apt upgrade -y && apt install -y wget \
													nginx \
													mariadb-server \
													php7.3 \
													php-mysql \
													php-fpm \
													php-pdo \
													php-gd \
													php-cli \
													php-mbstring \
													openssl

WORKDIR /var/www/localhost

#Autorization

RUN chmod -R 775 /var/www/*
RUN chown -R www-data:www-data /var/www/*

#Config nginx

RUN rm -f /etc/nginx/sites-available/default && \
	rm -r /etc/nginx/sites-enabled/default
COPY ./srcs/config_nginx /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/config_nginx /etc/nginx/sites-enabled/

#Config phpmyadmin

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

#Config wordpress

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
COPY ./srcs/wp-config.php wordpress

#Config SSL

RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout /etc/nginx/ssl/localhost_key.pem -out /etc/nginx/ssl/localhost.pem -days 3650 -subj "/C=FR/ST=IDF/L=PARIS/O=42/OU=lm-h/CN=localhost"

#config index.html

COPY ./srcs/index.html /var/www/html

COPY ./srcs/init.sh ./
CMD bash ./init.sh
#!/bin/sh
# verifica se o núcleo do WordPress está instalado executando o comando wp core is-installed com o 
# caminho especificado para o diretório de instalação do WordPress. Se não estiver instalado, os seguintes comandos serão executados
if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
	# baixa os arquivos principais do WordPress para o caminho especificado
	wp core download --path=/var/www/html --allow-root
	# Importe variáveis env no arquivo de configuração
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	# cria uma cópia do arquivo wp-config-sample.php e o renomeia para wp-config.php
	cp wp-config-sample.php wp-config.php
	# instale o núcleo do WordPress com as configurações especificadas, 
	# como URL do site, nome do site e credenciais de login do usuário administrador
	wp core install --allow-root --path=/var/www/html --url=${DOMAIN_NAME} --title=${WORDPRESS_NAME} --admin_user=${WORDPRESS_ROOT_LOGIN} --admin_password=${MYSQL_ROOT_PASSWORD} --admin_email=${WORDPRESS_ROOT_EMAIL}
	# instala e ativa o tema Astra
	wp theme install astra --activate --allow-root --path=/var/www/html
	# desinstala os plugins Akismet e Hello
	wp plugin uninstall --allow-root --path=/var/www/html akismet hello
	# atualiza todos os plugins instalados
	wp plugin update --all --allow-root --path=/var/www/html
	# altera a propriedade do diretório de instalação do WordPress para o usuário e grupo www-data
	chown -R www-data:www-data /var/www/html
	# define as permissões do diretório de instalação do WordPress para 774
	chmod -R 774 /var/www/html
	# remove os arquivos e diretórios principais do WordPress baixados
	rm -rf wordpress
else
	echo "wordpress already downloaded"
fi
# inicia o servidor PHP-FPM no modo de primeiro plano, que escuta as solicitações recebidas e as trata
php-fpm7.4 -F
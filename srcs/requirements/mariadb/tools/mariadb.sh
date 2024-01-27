#!/bin/sh

mysql_install_db

/etc/init.d/mysql start

# Verifique se o banco de dados existe

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]
then
	echo "Database already exists"
else
# defina a opção root para que a conexão sem senha root não seja possível
mysql_secure_installation << _EOF_

Y
root4life
root4life
Y
n
Y
Y
_EOF_

# Adicione um usuário root em 127.0.0.1 para permitir conexões remotas, privilégios de liberação permitem que suas 
# tabelas SQL sejam atualizadas automaticamente quando você modificá-las mysql -uroot launch mysql command line client
echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

# Crie banco de dados e usuário no banco de dados para wordpress
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root

# Importar banco de dados na linha de comando mysql
mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql

fi

/etc/init.d/mysql stop

exec "$@"
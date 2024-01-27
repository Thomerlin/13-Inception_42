#!/bin/bash

# O comando mkdir para criar o diretório e seus diretórios pai se eles 
# não existirem com o nome armazenado na variável de ambiente $CERTS_.
mkdir -p $CERTS_

# O comando openssl req gera um novo certificado SSL autoassinado e o 
#salva no arquivo $CERTS_/cert.crt e a chave privada em $CERTS_/cert.key.
openssl req -x509 -nodes -days 365 -newkey rsa:2048\
		-out $CERTS_/cert.crt \
		-keyout $CERTS_/cert.key \
		-subj "/C=BR/ST=São Paulo/L=São Paulo/O=42SP/OU=Inception/CN=tyago-ri/"

# Os comandos sed substituem os valores de espaço reservado DOMAIN_NAME e CERTS_ no 
# arquivo de configuração Nginx nginx.conf pelos valores reais das variáveis de ambiente DOMAIN_NAME e CERTS_.
sed -i "s|DOMAIN_NAME|${DOMAIN_NAME}|g" /etc/nginx/conf.d/nginx.conf
sed -i "s|CERTS_|${CERTS_}|g" /etc/nginx/conf.d/nginx.conf

# O comando exec "$@" passa quaisquer argumentos de linha de comando para o ponto de entrada do contêiner Docker.
exec "$@"
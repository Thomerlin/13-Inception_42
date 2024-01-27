FROM debian:bullseye

# atualiza as listas de pacotes e instala os pacotes necessários
# wget para baixar arquivos e PHP 7.4 com extensões FPM e MySQL para executar o WordPress.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
				wget				\
				# Wordpress core depencencies
				php7.4				\
				php7.4-fpm			\
				php7.4-mysqli 		\
				mariadb-client \
				&& rm -rf /var/lib/apt/lists/*
				

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod a+x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
# copia o arquivo www.conf, que é o arquivo de configuração do PHP-FPM, 
# para o diretório /etc/php/7.4/fpm/pool.d. A única alteração feita na configuração padrão é o valor da diretiva listen.
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d

RUN mkdir -p /var/run/php && chmod 777 /var/run/php
# cria um diretório para PHP-FPM usar para armazenar seu arquivo PID.
RUN mkdir -p /var/www/html

# copia o script
COPY ./tools/startwp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startwp.sh
ENTRYPOINT ["bash", "/usr/local/bin/startwp.sh"]

WORKDIR /var/www/html/

# expõe a porta 9000, que é a porta padrão usada pelo PHP-FPM
EXPOSE 9000

# define o ponto de entrada do contêiner para o script wordpress_config.sh localizado no diretório /utils. 
# Este script é usado para configurar o WordPress.
CMD ["/usr/sbin/php-fpm7.4", "-F"]

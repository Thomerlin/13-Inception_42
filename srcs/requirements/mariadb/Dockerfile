FROM debian:bullseye

# Instale o servidor e cliente MariaDB
RUN apt-get update && apt-get upgrade -y 
RUN	apt-get install -y mariadb-server mariadb-client && \
	rm -rf /var/lib/apt/lists/*

# Permitir que o daemon mysqld execute, limpe e recrie /var/lib/mysql com propriedade apropriada 
# Certifique-se de que /var/run/mysqld seja gravável independentemente do UID do mysqld em tempo de execução
RUN mkdir -p /var/run/mysqld &&\
	chown -R mysql:mysql /var/run/mysqld &&\
	chmod 777 /var/run/mysqld

# Expor a porta 3306 (porta padrão para MariaDB)
EXPOSE 3306

# Copie o script shell que configura o banco de dados MariaDB e as contas de usuário
COPY ./tools/mariadb.sh /usr/local/bin/
COPY ./conf/wordpress.sql /usr/local/bin/

# Defina permissões para que o script seja executável
RUN chmod +x /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/wordpress.sql

# Defina ENTRYPOINT para executar o script de shell
ENTRYPOINT [ "bash", "/usr/local/bin/mariadb.sh" ]

# Defina o comando para iniciar o mysqld e vinculá-lo a todas as interfaces de rede disponíveis
CMD [ "mysqld", "--bind-address=0.0.0.0" ]
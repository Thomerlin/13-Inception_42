# A instrução FROM define a imagem base a ser usada para a construção do Docker
FROM debian:bullseye

# A instrução RUN executa os comandos apt-get update e apt-get install para atualizar 
# a lista de pacotes e instalar os pacotes necessários, neste caso, nginx e openssl.
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl && \
	rm -rf /var/lib/apt/lists/*

# A instrução EXPOSE expõe a porta 443 para permitir o tráfego de entrada.
EXPOSE 443

# Configure Nginx
# A instrução COPY contém o arquivo de configuração do Nginx nginx.conf e o diretório de ferramentas
# para os diretórios /etc/nginx/conf.d/ e /etc/nginx/tools, respectivamente.
COPY ./conf/nginx.conf ./etc/nginx/conf.d/
COPY ./tools/ ./etc/nginx/tools

# A instrução ENTRYPOINT define o comando que será executado quando o contêiner for iniciado.
ENTRYPOINT [ "bash", "/etc/nginx/tools/nginx.sh" ];

# A instrução CMD especifica o comando padrão a ser executado quando 
# o contêiner é iniciado, que neste caso é nginx -g "daemon off;".
CMD ["nginx", "-g", "daemon off;"]
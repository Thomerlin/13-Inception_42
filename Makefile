SRC = cd srcs/
DOMAIN = 127.0.0.1       tyago-ri.42.fr
# LOOKDOMAIN = $(shell grep "${DOMAIN}" /etc/hosts)

all: build up

build:
	sudo mkdir -p /home/tyago-ri/data/database
	sudo mkdir -p /home/tyago-ri/data/wordpress
	${SRC} && docker-compose build

rebuild:
	sudo docker-compose -f srcs/docker-compose.yml build --no-cache

up:
	${SRC} && docker-compose up -d



list:
	docker ps -a

list-networks:
	docker network ls

list-volumes:
	docker volume ls

down:
	${SRC} && docker-compose down -v --rmi all --remove-orphans

fclean: down
	sudo mv ./hosts_bkp /etc/hosts || echo "hosts_bkp does not exist"
	sudo rm -rf /home/tyago-ri/data
	sudo docker system prune --volumes --all --force

re: fclean all
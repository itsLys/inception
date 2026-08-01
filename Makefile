COMPOSE = docker compose -f srcs/docker-compose.yml
DATA_PATH = $(HOME)/data
all: up

$(DATA_PATH)/mysql $(DATA_PATH)/wordpress:
	@mkdir -p $(DATA_PATH)/mysql
	@mkdir -p $(DATA_PATH)/wordpress

up: $(DATA_PATH)/mysql $(DATA_PATH)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart: down up

build:
	$(COMPOSE) build

build-no-cache:
	$(COMPOSE) build --no-cache

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down --rmi all -v --remove-orphans

re-no-cache: fclean build-no-cache up
re: fclean build up

.PHONY: all up down start stop restart build logs ps fclean clean re

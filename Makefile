COMPOSE = docker compose -f srcs/docker-compose.yml
DATA_PATH = $(HOME)/data
all: up

$(DATA_PATH)/mysql $(DATA_PATH)/wordpress $(DATA_PATH)/portainer:
	@mkdir -p $(DATA_PATH)/mysql
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/portainer

up: $(DATA_PATH)/mysql $(DATA_PATH)/wordpress $(DATA_PATH)/portainer
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

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down --rmi all -v --remove-orphans

re: fclean up

obliterate:
	$(COMPOSE) down --rmi all -v --remove-orphans
	docker builder prune -af
	docker system prune -af --volumes

.PHONY: all up down start stop restart build logs ps fclean clean re

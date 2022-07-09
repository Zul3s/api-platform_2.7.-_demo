# Executables (local)
DOCKER_COMP = docker-compose

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP_CONT) bin/console

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start stop logs status composer sf

## —— 🎵 🐳 The Symfony-docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— App ⚙️ ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache
	@$(COMPOSER) install

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach
	@symfony server:start --port=8081 -d --no-tls

start: build up migration ## Build and start the containers

status: ## Check container status
	$(DOCKER_COMP) ps
	@symfony server:status

stop: ## Stop the docker hub
	@symfony server:stop
	@$(DOCKER_COMP) down --remove-orphans

logs_db: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

logs_php: ## Show live logs
	@symfony local:server:log

migration: ## Run migration
	@$(SYMFONY) doctrine:migration:migrate -n

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: c=c:c ## Clear the cache
cc: sf

default:
	help

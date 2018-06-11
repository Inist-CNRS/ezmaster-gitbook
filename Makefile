.PHONY: help

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## install dependencies thanks to a dockerized npm install
	@docker run -it --rm -v $$(pwd):/app -w /app --net=host -e NODE_ENV -e http_proxy -e https_proxy node:10.0.0 npm install --unsafe-perm
	@make chown

build: ## build the docker inistcnrs/ezmaster images localy
	@docker-compose -f ./docker-compose.yml build

run-prod: ## run ezmaster-gitbook in production mode
	@docker-compose -f ./docker-compose.yml up

start-prod: ## start ezmaster-gitbook production daemon (needs a first run-prod the first time)
	@docker-compose -f ./docker-compose.yml start

stop-prod: ## stop ezmaster-gitbook production daemon
	@docker-compose -f ./docker-compose.yml stop

run-debug: ## run ezmaster-gitbook in debug mode and pass the url repository with GITHUB_URL="name"
	@USERID=$$(id -u) GROUPID=$$(id -g) docker-compose -f ./docker-compose.debug.yml up -d
	@docker attach ezmaster-gitbook

kill: ## kill ezmaster-gitbook running containers
	@docker-compose -f ./docker-compose.debug.yml kill

rm: ## remove ezmaster-gitbook containers even if they are running
	@docker-compose -f ./docker-compose.debug.yml rm -f

chown: ## makefile rule used to keep current user's unix rights on the docker mounted files
	@test ! -d $$(pwd)/node_modules || docker run -it --rm -v $$(pwd):/app node:10.0.0 chown -R $$(id -u):$$(id -g) /app/

npm: ## npm wrapper. example: make npm install --save mongodb-querystring
	@docker run -it --rm -v $$(pwd):/app -w /app --net=host -e NODE_ENV -e http_proxy -e https_proxy node:10.0.0 npm $(filter-out $@,$(MAKECMDGOALS))
	@make chown

clean: ## remove node_modules and temp files
	@rm -Rf ./node_modules/ ./npm-debug.log

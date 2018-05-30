
.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

run-prod: ## run gitbook with prod parameters
	NODE_ENV=production docker-compose -f ./docker-compose.yml up -d

run-debug: ## run gitbook with debug parameters
	NODE_ENV=development docker-compose -f ./docker-compose.debug.yml up -d

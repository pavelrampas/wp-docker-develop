SHELL = /bin/sh

-include .env

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run-wpcs: ## Run wpcs
	docker compose -f docker-compose-wpcs.yml up --build -d

stop-wpcs: ## Stop wpcs
	docker compose -f docker-compose-wpcs.yml stop

down-wpcs: ## Drop wpcs
	docker compose -f docker-compose-wpcs.yml down

cli-wpcs: ## Run shell inside local wpcs container
	docker compose -f docker-compose-wpcs.yml exec wpcs bash

format-check: ## Check code with wp-coding-standards
	docker compose -f docker-compose-wpcs.yml exec wpcs vendor/bin/phpcs --standard=WordPress --extensions=php --ignore=*/vendor/*,*/wordpress/* ./ -s

format-fix: ## Fix code with wp-coding-standards
	docker compose -f docker-compose-wpcs.yml exec wpcs vendor/bin/phpcbf --standard=WordPress --extensions=php --ignore=*/vendor/*,*/wordpress/* --ignore=*/wordpress/* ./

run-dev: ## Run local wp development
	docker compose up --build -d

stop-dev: ## Stop local wp development
	docker compose stop

down-dev: ## Drop local wp development
	docker compose down

cli-dev: ## Run shell inside local wp container
	docker compose exec wordpress bash

run-composer: ## Run local composer
	docker compose -f docker-compose-composer.yml up --build -d

stop-composer: ## Stop local composer
	docker compose -f docker-compose-composer.yml stop

down-composer: ## Drop local composer
	docker compose -f docker-compose-composer.yml down

cli-composer: ## Run shell inside local composer container
	docker compose -f docker-compose-composer.yml exec composer bash

cp-composer: ## Copy composer.json and composer.lock files from composer container to host
	docker cp wp-docker-develop-composer-1:/app/composer.json .
	docker cp wp-docker-develop-composer-1:/app/composer.lock .

update-composer: ## Run composer update inside composer container + copy composer.lock to host
	docker compose -f docker-compose-composer.yml exec composer composer update --no-scripts --ignore-platform-reqs
	make cp-composer
	docker compose -f docker-compose-composer.yml exec composer composer show -l

linkgen: ## Show app link
	@echo "\n Root URL ---> http://localhost:${HOST_DEV_PORT_APP}"

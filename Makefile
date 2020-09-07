dir=${CURDIR}

# default is test enviroment
env=test

# test
project=-p farming-$(env)-laravel
service=farming-$(env)-laravel:latest
container=farming-$(env)-laravel
supervisord=farming-$(env)-supervisord

build:
	docker-compose -f docker-compose-$(env).yml build

build-no-cache:
	docker-compose -f docker-compose-$(env).yml build --no-cache

start:
	docker-compose -f docker-compose-$(env).yml $(project) up -d

stop:
	docker-compose -f docker-compose-$(env).yml $(project) down


restart: stop start

deploy: npm-install npm-prod composer-install-prod restart

ssh:
	docker-compose  -f docker-compose-$(env).yml $(project) exec $(container) bash

ssh-supervisord:
	docker-compose  -f docker-compose-$(env).yml $(project) exec $(supervisord) bash

exec:
	docker-compose -f docker-compose-$(env).yml $(project) exec -T $(container) $$cmd

composer-install-prod:
	make exec cmd="composer install --no-dev"

composer-install:
	make exec cmd="composer install"

composer-update:
	make exec cmd="composer update"

info:
	make exec cmd="php artisan --version"
	make exec cmd="php --version"

logs:
	docker logs -f $(container)

logs-supervisord:
	docker logs -f $(supervisord)

drop-migrate:
	make exec cmd="php artisan migrate:fresh"

migrate-prod:
	make exec cmd="php artisan migrate --force"

migrate:
	make exec cmd="php artisan migrate --force"

seed:
	make exec cmd="php artisan db:seed --force"

npm-dev:
	make exec cmd="npm run dev"

npm-install:
	make exec cmd="npm install"

npm-prod:
	make exec cmd="npm run prod"

env:
	make exec cmd="cp ./.env ./.env"



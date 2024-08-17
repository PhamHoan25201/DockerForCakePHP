setup-new-project:
	cd cake-app && rm -f dummy.txt && composer create-project --prefer-dist cakephp/app:~4.0 .
	docker-compose up -d --build
up-build:
	docker-compose up -d --build
build:
	docker-compose build --no-cache --force-rm
up:
	docker-compose up -d
down:
	docker-compose down
prune:
	docker system prune
composer-update:
	composer update
create-project:
	composer create-project --prefer-dist cakephp/app:~4.0 .
run-migrations:
	docker exec cakephp-app bash -c "bin/cake migrations migrate"
rollback-migrations:
	docker exec cakephp-app bash -c "bin/cake migrations rollback"
run-seed:
	docker exec cakephp-app bash -c "bin/cake migrations seed"
install-faker:
	cd cake-app && composer require fakerphp/faker
example-create-model-file:
	docker exec cakephp-app bash -c "bin/cake bake model Users"
example-create-controller-file:
	cd cake-app && bin/cake bake controller Users
example-create-template-file:
	docker exec cakephp-app bash -c "bin/cake bake template Users"
example-create-migration-file:
	bin/cake bake migration CreateUsers
example-create-seed-file:
	bin/cake bake seed Users
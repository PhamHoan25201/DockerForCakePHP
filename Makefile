setup:
	 docker compose up -d --build
build:
	docker-compose build --no-cache --force-rm
up:
	docker-compose up -d
down:
	docker-compose down
prune:
	docker system prune
composer-update:
	docker exec cakephp-app bash -c "composer update"
prune:
	docker system prune
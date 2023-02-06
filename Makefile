.PHONY: db test

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

db:
	docker compose run --rm web rails db:migrate

rb:
	docker compose run --rm web rails db:rollback

console:
	docker compose run web rails console

main:
	git push origin main

main-f:
	git push origin main -f

amend:
	git commit --amend --no-edit

dev_creds:
	EDITOR=nano rails credentials:edit

prod_creds:
	EDITOR=nano rails credentials:edit -e production

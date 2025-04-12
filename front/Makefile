.PHONY: build up down logs

# コンテナのビルド
build:
	docker compose build front

# コンテナの起動
up:
	docker compose up -d front

# コンテナの停止と削除
down:
	docker compose down front

# コンテナのログを表示
logs:
	docker compose logs -f front

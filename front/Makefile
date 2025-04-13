# =================================================================
# ローカル起動する時用のやつ
# =================================================================
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


# =================================================================
# awsリソースいろいろ操作する時用のやつ
# =================================================================
ENV := stg
VERSION := frontend_v0.0.0

.PHONY: auth push get-images delete-images
auth:
	aws ecr get-login-password --region ap-northeast-1 --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

push: auth
	docker build --platform linux/amd64 --no-cache \
		-t ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-ssr-web-app-frontend:$(VERSION) \
		-t ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-ssr-web-app-frontend:$(ENV) \
		-f ./build/Dockerfile .
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-ssr-web-app-frontend:$(VERSION)
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com/stg-ssr-web-app-frontend:$(ENV)

get-images:
	aws ecr list-images --repository-name stg-ssr-web-app-frontend --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' | jq .

delete-images:
	@aws ecr list-images --repository-name stg-ssr-web-app-frontend --region ap-northeast-1 --profile ${AWS_PROFILE} --query 'imageIds[*]' --output json > /tmp/images.json
	@cat /tmp/images.json | jq -c '.[]' | while read -r image_id; do \
		aws ecr batch-delete-image --repository-name stg-ssr-web-app-frontend --region ap-northeast-1 --profile ${AWS_PROFILE} --image-ids $${image_id}; \
	done | jq .

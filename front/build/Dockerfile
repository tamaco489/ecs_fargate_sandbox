# ✅ Build Stage
FROM node:22.14.0-slim AS builder

# 環境変数（本番環境向けのビルド）
ENV NODE_ENV=production

# 作業ディレクトリ
WORKDIR /app

# パッケージ定義をコピーして依存関係をインストール
COPY apps/package*.json ./
RUN npm install

# アプリのソースをコピー
COPY apps ./

# Next.js アプリをビルド
RUN npm run build

# ✅ Production Stage
FROM node:22.14.0-slim AS runner

ENV NODE_ENV=production

WORKDIR /app

# パッケージ定義をコピーして本番依存だけインストール
COPY apps/package*.json ./
RUN npm install --omit=dev

# ビルド成果物とアプリ設定をコピー
COPY --from=builder /app/.next .next
# COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/tsconfig.json ./

# 公開ポート
EXPOSE 3000

# アプリ起動コマンド
CMD ["npm", "start"]

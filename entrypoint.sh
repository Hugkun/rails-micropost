#!/bin/bash
set -e

cd /rails/app

# Railsアプリがまだなければ新規作成
if [ ! -f "Gemfile" ]; then
  echo "🚂 Railsアプリを作成中... (初回のみ2〜3分かかります)"
  rails new . --database=sqlite3 --skip-test
fi

# Gemをインストール（キャッシュがあれば高速）
echo "📦 Gemをインストール中..."
bundle install

# Active Storageのセットアップ
echo "🗄️  データベースをセットアップ中..."
bundle exec rails active_storage:install 2>/dev/null || true
bundle exec rails db:migrate

echo ""
echo "✅ 準備完了！ブラウザで http://localhost:3000 を開いてね 🚂"
echo ""

# Railsサーバー起動
exec bundle exec rails server -b 0.0.0.0 -p 3000

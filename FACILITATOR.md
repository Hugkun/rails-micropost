# 🎤 主催者向け 当日進行ガイド

## 🗺️ 全体の流れ

| 時間 | やること | コマンド/ファイル |
|------|----------|-----------------|
| 0:00〜0:20 | 起動 & 全体説明 | `docker compose up` |
| 0:20〜0:50 | scaffoldで生成 | `rails g scaffold` |
| 0:50〜1:20 | コードを読む（MVC説明） | ファイルを眺める |
| 1:20〜1:50 | 画像アップロード追加 | Active Storage |
| 1:50〜2:00 | まとめ & 投稿大会 | - |

---

## ⏱ 詳細タイムライン

---

### 🟡 0:00〜0:20「起動 & 全体像」

**参加者に実行してもらう：**
```bash
docker compose up
```

**初回起動の流れ（5〜10分）：**
1. Railsアプリを自動生成
2. Gemをインストール
3. DBをセットアップ
4. サーバー起動 → http://localhost:3000

**話すこと：**
- Railsとは「Webアプリを素早く作るための仕組み（フレームワーク）」
- 「設定より規約」= 決まりごとに従えば自動でいろいろやってくれる
- 今日作るもの：マイクロポスト（一言投稿）+ 画像アップロード

**確認：**
- 全員 http://localhost:3000 でRailsのWelcome画面が見えているか

---

### 🟠 0:20〜0:50「scaffoldで爆速生成」

**新しいターミナルでコンテナに入る：**
```bash
docker compose exec web bash
cd app
```

**マイクロポストを生成：**
```bash
rails generate scaffold Post title:string content:string
rails db:migrate
```

**説明ポイント：**
- `scaffold` = モデル・ビュー・コントローラーをまとめて自動生成する魔法のコマンド
- `title:string` = "title"という名前で文字列を保存する項目
- `content:string` = "content"という名前で文字列を保存する項目（スペース区切りで複数追加できる）
- `db:migrate` = データベースに「Postsテーブル作って」と指示する

**全員に触ってもらう：**
- http://localhost:3000/posts を開く
- 「New Post」から投稿してみる
- 編集・削除もやってみる
- 「え、これだけで動くの！？」の反応を楽しむ

**生成されたファイルを一緒に確認：**
```
app/app/
├── controllers/posts_controller.rb  ← リクエストを受け取る役
├── models/post.rb                   ← データを扱う役
└── views/posts/
    ├── index.html.erb  （一覧ページ）
    ├── show.html.erb   （詳細ページ）
    ├── new.html.erb    （新規作成ページ）
    └── edit.html.erb   （編集ページ）
```

---

### 🔵 0:50〜1:20「MVCを読んでみよう」

**MVC図を口頭で説明：**
```
ブラウザ
  ↓ リクエスト（GET /posts）
Router（config/routes.rb）  ← 交通整理係
  ↓
Controller（posts_controller.rb）  ← 司令塔
  ↓ データ取得を依頼
Model（post.rb ↔ DB）  ← データ管理係
  ↓ データを渡す
View（index.html.erb）  ← デザイン係
  ↓ HTMLを返す
ブラウザ
```

**posts_controller.rb を一緒に読む：**
```ruby
def index
  @posts = Post.all  # ← 全投稿をDBから取ってくる
end

def create
  @post = Post.new(post_params)  # ← フォームの入力を受け取る
  if @post.save                   # ← DBに保存できたら
    redirect_to @post             # ← 詳細ページに飛ぶ
  else
    render :new                   # ← 失敗したらフォームに戻る
  end
end
```

**index.html.erb を一緒に読む：**
```erb
<% @posts.each do |post| %>   ← 全投稿をループ
  <p><%= post.content %></p>  ← 投稿内容を表示
<% end %>
```

**ポイント：** 「完全に理解しなくてOK！なんとなくわかる感覚を掴もう」

---

### 🟣 1:20〜1:50「画像アップロードを追加しよう」

ここが今日のメインイベント！scaffoldが作れなかった部分を自分で書く。

**ステップ1：モデルに1行追加**

`app/app/models/post.rb` を開いて編集：
```ruby
class Post < ApplicationRecord
  has_one_attached :image  # ← この1行を追加！
end
```

説明：「このPostはimageという名前で1つの画像を持てる、という宣言」

**ステップ2：フォームに画像入力を追加**

`app/app/views/posts/_form.html.erb` を開いて、`<div class="actions">` の直前に追加：
```erb
<div>
  <%= form.label :image, "画像（任意）" %>
  <%= form.file_field :image, accept: "image/*" %>
</div>
```

**ステップ3：コントローラーのパラメーター許可に追加**

`app/app/controllers/posts_controller.rb` の一番下の方にある `post_params` を修正：
```ruby
# 修正前
def post_params
  params.require(:post).permit(:title, :content)
end

# 修正後（:imageを追加）
def post_params
  params.require(:post).permit(:title, :content, :image)
end
```

**ステップ4：表示部分に画像を追加**

`app/app/views/posts/show.html.erb` に追加：
```erb
<% if @post.image.attached? %>
  <%= image_tag @post.image, width: 300, style: "border-radius: 8px;" %>
<% end %>
```

`app/app/views/posts/index.html.erb` にも同様に追加：
```erb
<% if post.image.attached? %>
  <%= image_tag post.image, width: 200 %>
<% end %>
```

---

### 🟢 1:50〜2:00「まとめ & 投稿大会」

**全員に自由に投稿してもらう（主催者のPCにアクセスしてもらう）：**
```bash
# Macの場合
ipconfig getifaddr en0
# 例：192.168.1.10 → 全員が http://192.168.1.10:3000 にアクセス
```

**今日やったことの整理：**
1. `scaffold` でCRUDが一発生成できた
2. MVC = Controller（司令塔）・Model（データ）・View（画面）の役割分担
3. `has_one_attached` で画像アップロードができた
4. `permit` でセキュリティの仕組みを体験した

---

## 💡 よくあるトラブルと対処法

| トラブル | 対処法 |
|---------|--------|
| `docker compose up` が遅い | 初回のみ。10分程度待てばOK |
| ポート3000が使用中 | `docker ps` で確認、他のコンテナを止める |
| 画像が表示されない | `has_one_attached :image` の追記を確認 |
| `permit`エラー | `post_params`に`:image`が追加されているか確認 |
| サーバーが起動しない | `docker compose down && docker compose up` で再起動 |

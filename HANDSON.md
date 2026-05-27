# 🚂 Rails ハンズオン — マイクロポストを作ろう！

> **所要時間:** 約90分  
> **レベル:** プログラミング初心者OK

---

## 📋 目次

1. [準備確認](#1-準備確認)
2. [scaffoldで爆速生成](#2-scaffoldで爆速生成)
3. [MVCを読んでみよう](#3-mvcを読んでみよう)
4. [画像アップロードを追加しよう](#4-画像アップロードを追加しよう)
5. [まとめ](#5-まとめ)

---

## 1. 準備確認

`docker compose up` を実行して、ブラウザで以下を開いてください：

👉 **http://localhost:3000**

Railsのウェルカム画面が見えればOK！

---

## 2. scaffoldで爆速生成

### コンテナに入る

**新しいターミナルウィンドウ**を開いて：

```bash
docker compose exec web bash
cd app
```

### マイクロポストを生成する

```bash
rails generate scaffold Post title:string content:string
```

実行すると、たくさんのファイルが自動生成されます。これが **scaffold（足場）** です。

```
invoke  active_record
create    db/migrate/..._create_posts.rb   ← DBの設計図
create    app/models/post.rb               ← データを扱う役
invoke  resource_route
 route    resources :posts                 ← URLの設定
invoke  scaffold_controller
create    app/controllers/posts_controller.rb  ← 司令塔
create    app/views/posts/index.html.erb   ← 一覧ページ
create    app/views/posts/show.html.erb    ← 詳細ページ
create    app/views/posts/new.html.erb     ← 新規作成ページ
...
```

### データベースを更新する

```bash
rails db:migrate
```

### ブラウザで確認！

👉 **http://localhost:3000/posts**

「New Post」を押して投稿してみましょう。  
**これだけで投稿・編集・削除が全部できます！**

---

## 3. MVCを読んでみよう

Railsは **MVC** という設計パターンを使っています。

```
ブラウザ
  ↓ リクエスト（例: GET /posts）
Router（config/routes.rb）  ← 交通整理係
  ↓
Controller（posts_controller.rb）  ← 司令塔
  ↓ データをModelに依頼
Model（post.rb ↔ DB）  ← データ管理係
  ↓
View（index.html.erb）  ← デザイン係
  ↓ HTML
ブラウザ
```

### やってみよう①：routes.rb を確認

`app/config/routes.rb` を開いて確認：

```ruby
Rails.application.routes.draw do
  resources :posts  # ← この1行が7つのURLを自動生成！
end
```

ターミナルで確認もできます：

```bash
rails routes | grep posts
```

### やってみよう②：コントローラーを読む

`app/app/controllers/posts_controller.rb` を開く：

```ruby
def index
  @posts = Post.all  # ← 全投稿をDBから取得
end

def create
  @post = Post.new(post_params)
  if @post.save        # ← DBに保存成功したら
    redirect_to @post  # ← 詳細ページへ
  else
    render :new        # ← 失敗したらフォームに戻る
  end
end
```

### やってみよう③：Viewを読む

`app/app/views/posts/index.html.erb` を開く：

```erb
<% @posts.each do |post| %>
  <p><%= post.content %></p>
<% end %>
```

`<% %>` は「Rubyを実行（表示しない）」、`<%= %>` は「Rubyを実行して表示」です。

---

## 4. 画像アップロードを追加しよう

scaffoldでは追加されなかった機能を、自分で書いてみましょう！

### ステップ1：モデルに1行追加

`app/app/models/post.rb` を開いて編集：

```ruby
class Post < ApplicationRecord
  has_one_attached :image  # ← この1行を追加！
end
```

**意味：** 「このPostには `image` という名前で1つの画像を添付できる」

### ステップ2：フォームに画像入力を追加

`app/app/views/posts/_form.html.erb` を開いて、`<div class="actions">` の**直前**に追加：

```erb
<div>
  <%= form.label :image, "画像（任意）" %>
  <%= form.file_field :image, accept: "image/*" %>
</div>
```

### ステップ3：コントローラーのパラメーターを許可

`app/app/controllers/posts_controller.rb` の一番下近くにある `post_params` を修正：

```ruby
# 修正前
def post_params
  params.require(:post).permit(:title, :content)
end

# 修正後
def post_params
  params.require(:post).permit(:title, :content, :image)
end
```

**なぜ必要？** セキュリティのため、受け取っていいデータを明示的に許可リストに書く必要があります。

### ステップ4：詳細ページに画像を表示

`app/app/views/posts/show.html.erb` に追加：

```erb
<% if @post.image.attached? %>
  <%= image_tag @post.image, width: 300, style: "border-radius: 8px;" %>
<% end %>
```

### ステップ5：一覧ページにも画像を表示

`app/app/views/posts/index.html.erb` に追加：

```erb
<% if post.image.attached? %>
  <%= image_tag post.image, width: 200 %>
<% end %>
```

### 動作確認！

👉 **http://localhost:3000/posts/new**

画像付きで投稿して、一覧・詳細で表示されればOK！

---

## 5. まとめ

今日やったこと：

| やったこと | 使ったもの |
|-----------|-----------|
| CRUD機能を自動生成 | `rails g scaffold` |
| DBを更新 | `rails db:migrate` |
| ルーティングを確認 | `rails routes` |
| MVCの役割を理解 | Controller / Model / View |
| 画像アップロード | `has_one_attached` + Active Storage |
| セキュリティの仕組み | Strong Parameters (`permit`) |

---

## ⚡ 時間が余ったら — チャレンジメニュー

早く終わった人・もっとやりたい人向けです。好きなものをどうぞ！

---

### B. バリデーションを追加する（約5分）

> タイトルが空のまま投稿できないようにしよう

`app/app/models/post.rb` を編集：

```ruby
class Post < ApplicationRecord
  has_one_attached :image
  validates :title, presence: true  # ← この1行を追加！
end
```

**確認：** タイトルを空にして投稿してみる → エラーメッセージが出ればOK

**ポイント：** `presence: true` = 「必ず入力してね」という制約。他にも：
- `length: { maximum: 50 }` → 50文字以内
- `uniqueness: true` → 重複禁止

---

### D. トップページを変える（約2分）

> `/` を開いたときに投稿一覧が表示されるようにしよう

`app/config/routes.rb` を編集：

```ruby
Rails.application.routes.draw do
  root "posts#index"  # ← この1行を追加！
  resources :posts
end
```

**確認：** http://localhost:3000 を開くと投稿一覧が表示されればOK

---

### C. カラムを自分で追加する（約15分）

> 投稿に「名前」欄を追加してみよう

コンテナの中で：

```bash
rails generate migration AddNameToPost name:string
rails db:migrate
```

`app/app/views/posts/_form.html.erb` に追加：

```erb
<div>
  <%= form.label :name, "投稿者名" %>
  <%= form.text_field :name %>
</div>
```

`app/app/controllers/posts_controller.rb` の `post_params` に `:name` を追加：

```ruby
params.require(:post).permit(:title, :content, :name, :image)
```

`app/app/views/posts/index.html.erb` と `show.html.erb` に表示を追加：

```erb
<p><%= post.name %></p>
```

---

### A. Bootstrapで見た目をよくする（約15分）

> CSSフレームワークを使ってカードっぽいデザインにしよう

`app/app/views/layouts/application.html.erb` の `<head>` 内に追加：

```erb
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
```

`app/app/views/posts/index.html.erb` を丸ごと置き換え：

```erb
<div class="container mt-4">
  <h1 class="mb-4">投稿一覧</h1>
  <div class="row">
    <% @posts.each do |post| %>
      <div class="col-md-4 mb-3">
        <div class="card">
          <% if post.image.attached? %>
            <%= image_tag post.image, class: "card-img-top", style: "height: 200px; object-fit: cover;" %>
          <% end %>
          <div class="card-body">
            <h5 class="card-title"><%= post.title %></h5>
            <p class="card-text"><%= post.content %></p>
            <%= link_to "詳細", post, class: "btn btn-primary btn-sm" %>
          </div>
        </div>
      </div>
    <% end %>
  </div>
  <%= link_to "新しい投稿", new_post_path, class: "btn btn-success mt-3" %>
</div>
```

**確認：** http://localhost:3000/posts がカード形式になればOK

---

## 💡 困ったときのコマンド集

```bash
# ログを見る（別ターミナルで）
docker compose logs -f

# コンテナに入り直す
docker compose exec web bash
cd app

# サーバーを再起動
docker compose restart

# 完全にリセット
docker compose down && docker compose up
```

---

*Happy Coding! 🎉*

# 🚂 Rails勉強会へようこそ！

## 📋 事前準備（当日までに必ずやっておいてください）

### Docker Desktop のインストール
- Mac: https://www.docker.com/products/docker-desktop/
- Windows: 上記と同じURL（WSL2が必要な場合があります）

インストール後、Docker Desktopを起動してクジラのアイコンがメニューバーに出ればOK 🐳

---

## 🚀 当日の手順

### 1. このフォルダをダウンロード
主催者から共有されたzipを解凍して、わかりやすい場所に置く

### 2. ターミナルを開く
- Mac: `Cmd + Space` → "ターミナル" と入力
- Windows: スタートメニュー → "PowerShell" と入力

### 3. フォルダに移動
```bash
cd 解凍したフォルダのパス
# 例: cd ~/Downloads/rails-micropost-main
```

### 4. 起動！
```bash
docker compose up -d --build
docker compose logs -f web
```

**初回は5〜10分かかります。** 起動したらブラウザで確認してみましょう。 「✅ 準備完了！」 が出たら Ctrl+C でログから抜ける（サーバーは止まりません）。

### 5. ブラウザで開く
👉 **http://localhost:3000**

### 6. HANDSON.mdを開く
勉強会での内容は`HANDSON.md`に記載されているのでそこからご覧ください。

---

## 🛑 終わるとき
```bash
docker compose down
```

---

## 🌐 当日のネットワークについて

ハンズオンの後半で、全員が登壇者のPCに投稿する場面があります。  
その際、**全員が同じWi-Fiに接続している必要があります。**  
会場のWi-Fiに接続してご参加ください。
**ネットワーク名** `ie-guest`

---

## 😰 困ったら
エラーが出ても慌てずに！主催者を呼んでください。  
エラーメッセージはむしろ学びのチャンスです 💪

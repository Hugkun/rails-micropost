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
# 例: cd ~/Downloads/rails-workshop2
```

### 4. 起動！
```bash
docker compose up
```

**初回は5〜10分かかります。** 以下のメッセージが出たらOK！
```
✅ 準備完了！ブラウザで http://localhost:3000 を開いてね 🚂
```

### 5. ブラウザで開く
👉 **http://localhost:3000**

---

## 🛑 終わるとき
ターミナルで `Ctrl + C` を押してから：
```bash
docker compose down
```

---

## 😰 困ったら
エラーが出ても慌てずに！主催者を呼んでください。  
エラーメッセージはむしろ学びのチャンスです 💪

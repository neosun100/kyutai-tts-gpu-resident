# 🚀 Kyutai TTS - GPU常駐版

[English](README.md) | [简体中文](README_CN.md) | [繁體中文](README_TW.md) | [日本語](README_JP.md)

> 🎯 本番環境対応 Kyutai TTS、**GPU常駐モード**、**584種類の音声**、**カスタム音声クローン**、**ストリーミング出力**をサポート

## ✨ 主な機能

- 🔥 **GPU常駐モード** - ゼロレイテンシー応答
- 🎤 **カスタム音声クローン** - あなたの声を即座にクローン
- 🌊 **ストリーミング出力** - リアルタイム音声生成
- 🎨 **584種類のプリセット音声** - 様々な感情と言語

## 🚀 クイックスタート

```bash
# データディレクトリを作成
sudo mkdir -p /tmp/kyutai-tts/{outputs,custom_voices}
sudo chmod 777 /tmp/kyutai-tts/{outputs,custom_voices}

# コンテナを実行
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  -v /tmp/kyutai-tts/outputs:/app/outputs \
  -v /tmp/kyutai-tts/custom_voices:/app/custom_voices \
  neosun/kyutai-tts:latest
```

アクセス: **http://localhost:8900**

完全なドキュメントは [English README](README.md) を参照してください

---

Made with ❤️ by [neosun100](https://github.com/neosun100)

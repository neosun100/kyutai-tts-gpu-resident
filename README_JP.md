# Kyutai TTS Docker デプロイ

[English](README.md) | [简体中文](README_CN.md) | [繁體中文](README_TW.md) | [日本語](README_JP.md)

> 本番環境対応の Kyutai TTS Docker デプロイメント

## 🚀 クイックスタート

```bash
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  neosun/kyutai-tts:allinone
```

アクセス: http://localhost:8900

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=neosun100/kyutai-tts-docker&type=Date)](https://star-history.com/#neosun100/kyutai-tts-docker)

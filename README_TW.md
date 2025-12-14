# 🚀 Kyutai TTS - 顯存常駐版

[English](README.md) | [简体中文](README_CN.md) | [繁體中文](README_TW.md) | [日本語](README_JP.md)

> 🎯 生產級 Kyutai TTS，支援**顯存常駐模式**、**584種音色**、**自訂音色克隆**和**串流輸出**

## ✨ 核心特性

- 🔥 **顯存常駐模式** - 零延遲響應
- 🎤 **自訂音色克隆** - 上傳你的聲音即時克隆
- 🌊 **串流輸出** - 即時生成音訊
- 🎨 **584種預置音色** - 多種情緒和語言

## 🚀 快速開始

```bash
# 創建資料目錄
sudo mkdir -p /tmp/kyutai-tts/{outputs,custom_voices}
sudo chmod 777 /tmp/kyutai-tts/{outputs,custom_voices}

# 運行容器
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  -v /tmp/kyutai-tts/outputs:/app/outputs \
  -v /tmp/kyutai-tts/custom_voices:/app/custom_voices \
  neosun/kyutai-tts:latest
```

訪問: **http://localhost:8900**

完整文檔請參考 [English README](README.md)

---

Made with ❤️ by [neosun100](https://github.com/neosun100)

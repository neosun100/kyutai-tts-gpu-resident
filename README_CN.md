# Kyutai TTS Docker 部署

[English](README.md) | [简体中文](README_CN.md) | [繁體中文](README_TW.md) | [日本語](README_JP.md)

[![Docker](https://img.shields.io/badge/docker-neosun%2Fkyutai--tts-blue)](https://hub.docker.com/r/neosun/kyutai-tts)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE-MIT)

> 生产就绪的 Kyutai TTS Docker 部署方案，支持 UI、REST API 和 MCP

## ✨ 功能特性

- 🚀 **一键部署** - 自动 GPU 选择和端口检测
- 🎨 **三种访问方式** - Web UI、REST API 和 MCP 工具
- 🧠 **智能 GPU 管理** - 懒加载和自动释放显存
- 🌐 **多语言界面** - 中英文界面切换
- 📦 **All-in-One 镜像** - 无外部依赖，模型内置
- 🔒 **生产就绪** - HTTPS、健康检查和监控

## 🚀 快速开始

### 使用 Docker Hub（推荐）

```bash
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  -e NVIDIA_VISIBLE_DEVICES=0 \
  neosun/kyutai-tts:allinone
```

访问: http://localhost:8900

### 使用 Docker Compose

```bash
git clone https://github.com/neosun100/kyutai-tts-docker.git
cd kyutai-tts-docker
./start.sh
```

## 📖 使用方法

### Web UI

1. 打开浏览器: http://localhost:8900
2. 输入要合成的文本
3. 调整参数（可选）
4. 点击"生成"
5. 播放或下载音频

### REST API

```bash
curl -X POST http://localhost:8900/api/tts \
  -F "text=你好，世界！" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=neosun100/kyutai-tts-docker&type=Date)](https://star-history.com/#neosun100/kyutai-tts-docker)

## 📱 关注公众号

![公众号](https://img.aws.xin/uPic/扫码_搜索联合传播样式-标准色版.png)

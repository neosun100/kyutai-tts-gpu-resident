# 🚀 Kyutai TTS - 显存常驻版

[English](README.md) | [简体中文](README_CN.md) | [繁體中文](README_TW.md) | [日本語](README_JP.md)

[![Docker](https://img.shields.io/badge/docker-neosun%2Fkyutai--tts-blue)](https://hub.docker.com/r/neosun/kyutai-tts)
[![Version](https://img.shields.io/badge/version-v1.5--allinone-green)](https://github.com/neosun100/kyutai-tts-gpu-resident)
[![License](https://img.shields.io/badge/license-MIT%2FApache--2.0-green)](LICENSE-MIT)
[![GPU](https://img.shields.io/badge/GPU-CUDA%2012.1-brightgreen)](https://developer.nvidia.com/cuda-toolkit)

> 🎯 生产级 Kyutai TTS，支持**显存常驻模式**、**584种音色**、**自定义音色克隆**和**流式输出**

## ✨ 核心特性

### 🔥 显存常驻模式
- **零延迟响应** - 模型永久驻留显存
- **3.8GB 显存** 占用，即时生成
- **无重载延迟** - 首次请求 = 后续请求
- 通过 API 手动卸载控制

### 🎤 自定义音色克隆
- **上传你的声音** (3-10秒 WAV 文件)
- **即时克隆** - 无需训练
- **随处使用** - 应用于任何文本生成
- **持久化存储** - 音色跨重启保存

### 🌊 流式输出
- **实时生成** - 音频边生成边播放
- **更低延迟** - 完成前即可开始播放
- **适合长文本** - 理想用于有声书、文章

### 🎨 584种预置音色
- **Expresso**: 情绪音色（开心、愤怒、悲伤、平静、困惑等）
- **EARS**: 107个说话人，每人25种情绪变体
- **CML-TTS**: 法语音色
- **VCTK**: 109个英语说话人
- **Voice Donations**: 200+社区贡献音色

## 🚀 快速开始

### 前置要求
- 支持 NVIDIA GPU 的 Docker
- NVIDIA GPU，CUDA 12.1+
- 4GB+ 显存

### 一键部署

```bash
# 创建数据目录
sudo mkdir -p /tmp/kyutai-tts/{outputs,custom_voices}
sudo chmod 777 /tmp/kyutai-tts/{outputs,custom_voices}

# 运行容器
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  -v /tmp/kyutai-tts/outputs:/app/outputs \
  -v /tmp/kyutai-tts/custom_voices:/app/custom_voices \
  neosun/kyutai-tts:latest
```

访问: **http://localhost:8900**

### Docker Compose

```bash
git clone https://github.com/neosun100/kyutai-tts-gpu-resident.git
cd kyutai-tts-gpu-resident

# 创建数据目录
sudo mkdir -p /tmp/kyutai-tts/{outputs,custom_voices}
sudo chmod 777 /tmp/kyutai-tts/{outputs,custom_voices}

# 启动服务
docker-compose up -d
```

## 📖 使用方法

### Web 界面

1. 打开 **http://localhost:8900**
2. 从584种音色中选择或上传自己的音色
3. 输入要合成的文本
4. 选择普通或流式模式
5. 点击"生成语音"
6. 播放或下载音频

### REST API

#### 生成语音（普通模式）

```bash
curl -X POST http://localhost:8900/api/tts \
  -F "text=你好，世界！" \
  -F "voice=expresso/ex03-ex01_happy_001_channel1_334s.wav" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

#### 生成语音（流式模式）

```bash
curl -X POST http://localhost:8900/api/tts/stream \
  -F "text=这是流式输出！" \
  -F "voice=expresso/ex03-ex01_happy_001_channel1_334s.wav" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

#### 上传自定义音色

```bash
curl -X POST http://localhost:8900/api/voice/upload \
  -F "voice_file=@my_voice.wav" \
  -F "voice_name=my_voice"
```

#### 使用自定义音色

```bash
curl -X POST http://localhost:8900/api/tts \
  -F "text=测试我的自定义音色！" \
  -F "voice=custom/my_voice.safetensors" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

## ⚙️ 配置说明

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `PORT` | 8900 | 服务端口 |
| `DEVICE` | cuda | 设备类型 (cuda/cpu) |
| `NVIDIA_VISIBLE_DEVICES` | 0 | 使用的 GPU ID |

### Docker 卷挂载

| 卷 | 用途 |
|----|------|
| `/tmp/kyutai-tts/outputs` | 生成的音频文件 |
| `/tmp/kyutai-tts/custom_voices` | 上传的自定义音色嵌入 (safetensors) |

**隐私说明：** Docker 镜像本身不包含任何私有数据。所有用户上传和生成的文件都存储在宿主机的 `/tmp/kyutai-tts/` 目录中。

## 📊 性能指标

- **模型大小**: 16亿参数
- **显存占用**: 3.8GB（常驻模式）
- **延迟**: <100ms（显存常驻）
- **速度**: 3-5倍实时
- **音频质量**: 16位 PCM, 24kHz

## 🔧 API 端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/health` | GET | 健康检查 |
| `/api/tts` | POST | 生成语音（普通） |
| `/api/tts/stream` | POST | 生成语音（流式） |
| `/api/voices` | GET | 列出所有584种音色 |
| `/api/voices/custom` | GET | 列出自定义音色 |
| `/api/voice/upload` | POST | 上传自定义音色 |
| `/api/gpu/status` | GET | GPU 状态 |
| `/api/gpu/offload` | POST | 释放 GPU 内存 |

## 🛠️ 技术栈

- **模型**: Kyutai TTS 1.6B (延迟流建模)
- **框架**: PyTorch, Moshi
- **后端**: Flask, Python 3.10
- **前端**: 原生 JavaScript
- **容器**: Docker, NVIDIA CUDA 12.1
- **音频**: Mimi 编解码器 (24kHz, 1.1kbps)

## 🤝 贡献指南

欢迎贡献！请随时提交 Pull Request。

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📝 更新日志

### v1.5 (2025-12-14)
- ✅ 使用 safetensors 的自定义音色克隆
- ✅ 注重隐私：所有数据在宿主机
- ✅ UI 添加下载按钮
- ✅ 干净的 Docker 镜像（无私有数据）

### v1.4 (2025-12-14)
- ✨ 自定义音色克隆
- 🌊 流式输出
- 🎤 音色上传界面

### v1.1 (2025-12-14)
- ✨ 584种音色选项
- 🎨 增强的 UI 和音色选择器
- 🔍 音色搜索/过滤

### v1.0 (2025-12-14)
- 🚀 初始版本
- 💾 显存常驻模式
- 🎯 Web UI
- 📡 REST API

## 📄 许可证

- Python 代码: MIT License
- Rust 代码: Apache License 2.0
- 模型权重: CC-BY 4.0

## 🙏 致谢

- [Kyutai Labs](https://kyutai.org/) 提供 TTS 模型
- [Moshi](https://github.com/kyutai-labs/moshi) 提供实现

## 📱 链接

- **Docker Hub**: https://hub.docker.com/r/neosun/kyutai-tts
- **GitHub**: https://github.com/neosun100/kyutai-tts-gpu-resident
- **演示**: http://localhost:8900 (部署后)

---

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=neosun100/kyutai-tts-gpu-resident&type=Date)](https://star-history.com/#neosun100/kyutai-tts-gpu-resident)

## 📱 关注公众号

![公众号](https://img.aws.xin/uPic/扫码_搜索联合传播样式-标准色版.png)

---

Made with ❤️ by [neosun100](https://github.com/neosun100)

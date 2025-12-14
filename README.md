# 🚀 Kyutai TTS - GPU Resident Edition

[English](README.md) | [简体中文](README_CN.md) | [繁體中文](README_TW.md) | [日本語](README_JP.md)

[![Docker](https://img.shields.io/badge/docker-neosun%2Fkyutai--tts-blue)](https://hub.docker.com/r/neosun/kyutai-tts)
[![Version](https://img.shields.io/badge/version-v1.5--allinone-green)](https://github.com/neosun100/kyutai-tts-gpu-resident)
[![License](https://img.shields.io/badge/license-MIT%2FApache--2.0-green)](LICENSE-MIT)
[![GPU](https://img.shields.io/badge/GPU-CUDA%2012.1-brightgreen)](https://developer.nvidia.com/cuda-toolkit)

> 🎯 Production-ready Kyutai TTS with **GPU-resident mode**, **584 voices**, **custom voice cloning**, and **streaming output**

## ✨ Key Features

### 🔥 GPU Resident Mode
- **Zero-latency response** - Model stays in VRAM permanently
- **3.8GB VRAM** usage for instant generation
- **No reload delays** - First request = subsequent requests
- Manual offload control via API

### 🎤 Custom Voice Cloning
- **Upload your own voice** (3-10 second WAV file)
- **Instant voice cloning** - No training required
- **Use anywhere** - Apply to any text generation
- **Persistent storage** - Voices saved across restarts

### 🌊 Streaming Output
- **Real-time generation** - Audio streams as it's created
- **Lower latency** - Start playback before completion
- **Perfect for long texts** - Ideal for audiobooks, articles

### 🎨 584 Pre-built Voices
- **Expresso**: Emotions (happy, angry, sad, calm, confused, etc.)
- **EARS**: 107 speakers with 25 emotion variants each
- **CML-TTS**: French language voices
- **VCTK**: 109 English speakers
- **Voice Donations**: 200+ community voices

## 🚀 Quick Start

### Prerequisites
- Docker with NVIDIA GPU support
- NVIDIA GPU with CUDA 12.1+
- 4GB+ VRAM

### One-Line Deploy

```bash
# Create data directories
sudo mkdir -p /tmp/kyutai-tts/{outputs,custom_voices}
sudo chmod 777 /tmp/kyutai-tts/{outputs,custom_voices}

# Run container
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  -v /tmp/kyutai-tts/outputs:/app/outputs \
  -v /tmp/kyutai-tts/custom_voices:/app/custom_voices \
  neosun/kyutai-tts:latest
```

Access at: **http://localhost:8900**

### Docker Compose

```bash
git clone https://github.com/neosun100/kyutai-tts-gpu-resident.git
cd kyutai-tts-gpu-resident

# Create data directories
sudo mkdir -p /tmp/kyutai-tts/{outputs,custom_voices}
sudo chmod 777 /tmp/kyutai-tts/{outputs,custom_voices}

# Start service
docker-compose up -d
```

## 📖 Usage

### Web UI

1. Open **http://localhost:8900**
2. Select from 584 voices or upload your own
3. Enter text to synthesize
4. Choose Normal or Streaming mode
5. Click "Generate Speech"
6. Play or download audio

### REST API

#### Generate Speech (Normal)

```bash
curl -X POST http://localhost:8900/api/tts \
  -F "text=Hello, world!" \
  -F "voice=expresso/ex03-ex01_happy_001_channel1_334s.wav" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

#### Generate Speech (Streaming)

```bash
curl -X POST http://localhost:8900/api/tts/stream \
  -F "text=This is streaming output!" \
  -F "voice=expresso/ex03-ex01_happy_001_channel1_334s.wav" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

#### Upload Custom Voice

```bash
curl -X POST http://localhost:8900/api/voice/upload \
  -F "voice_file=@my_voice.wav" \
  -F "voice_name=my_voice"
```

#### Use Custom Voice

```bash
curl -X POST http://localhost:8900/api/tts \
  -F "text=Testing my custom voice!" \
  -F "voice=custom/my_voice.safetensors" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 8900 | Service port |
| `DEVICE` | cuda | Device type (cuda/cpu) |
| `NVIDIA_VISIBLE_DEVICES` | 0 | GPU ID to use |

### Docker Volumes

| Volume | Purpose |
|--------|---------|
| `/tmp/kyutai-tts/outputs` | Generated audio files |
| `/tmp/kyutai-tts/custom_voices` | Uploaded custom voice embeddings (safetensors) |

**Privacy Note:** The Docker image itself contains NO private data. All user uploads and generated files are stored on the host machine in `/tmp/kyutai-tts/`.

## 📊 Performance

- **Model Size**: 1.6B parameters
- **GPU Memory**: 3.8GB (resident mode)
- **Latency**: <100ms (GPU resident)
- **Speed**: 3-5x real-time
- **Audio Quality**: 16-bit PCM, 24kHz

## 🔧 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health check |
| `/api/tts` | POST | Generate speech (normal) |
| `/api/tts/stream` | POST | Generate speech (streaming) |
| `/api/voices` | GET | List all 584 voices |
| `/api/voices/custom` | GET | List custom voices |
| `/api/voice/upload` | POST | Upload custom voice |
| `/api/gpu/status` | GET | GPU status |
| `/api/gpu/offload` | POST | Release GPU memory |

## 🛠️ Tech Stack

- **Model**: Kyutai TTS 1.6B (Delayed Streams Modeling)
- **Framework**: PyTorch, Moshi
- **Backend**: Flask, Python 3.10
- **Frontend**: Vanilla JavaScript
- **Container**: Docker, NVIDIA CUDA 12.1
- **Audio**: Mimi codec (24kHz, 1.1kbps)

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Changelog

### v1.5 (2025-12-14)
- ✅ Custom voice cloning with safetensors
- ✅ Privacy-focused: All data on host machine
- ✅ Download button in UI
- ✅ Clean Docker image (no private data)

### v1.4 (2025-12-14)
- ✨ Custom voice cloning
- 🌊 Streaming output
- 🎤 Voice upload interface

### v1.1 (2025-12-14)
- ✨ 584 voice options
- 🎨 Enhanced UI with voice selector
- 🔍 Voice search/filter

### v1.0 (2025-12-14)
- 🚀 Initial release
- 💾 GPU resident mode
- 🎯 Web UI
- 📡 REST API

## 📄 License

- Python code: MIT License
- Rust code: Apache License 2.0
- Model weights: CC-BY 4.0

## 🙏 Acknowledgments

- [Kyutai Labs](https://kyutai.org/) for the TTS model
- [Moshi](https://github.com/kyutai-labs/moshi) for the implementation

## 📱 Links

- **Docker Hub**: https://hub.docker.com/r/neosun/kyutai-tts
- **GitHub**: https://github.com/neosun100/kyutai-tts-gpu-resident
- **Demo**: http://localhost:8900 (after deployment)

---

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=neosun100/kyutai-tts-gpu-resident&type=Date)](https://star-history.com/#neosun100/kyutai-tts-gpu-resident)

## 📱 关注公众号

![公众号](https://img.aws.xin/uPic/扫码_搜索联合传播样式-标准色版.png)

---

Made with ❤️ by [neosun100](https://github.com/neosun100)

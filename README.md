# Kyutai TTS Docker Deployment

[English](README.md) | [简体中文](README_CN.md) | [繁體中文](README_TW.md) | [日本語](README_JP.md)

[![Docker](https://img.shields.io/badge/docker-neosun%2Fkyutai--tts-blue)](https://hub.docker.com/r/neosun/kyutai-tts)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE-MIT)
[![GPU](https://img.shields.io/badge/GPU-CUDA%2012.1-brightgreen)](https://developer.nvidia.com/cuda-toolkit)

> Production-ready Docker deployment for Kyutai TTS with UI, REST API, and MCP support

## ✨ Features

- 🚀 **One-Click Deployment** - Automated GPU selection and port detection
- 🎨 **Three Access Modes** - Web UI, REST API, and MCP tools
- 🧠 **Smart GPU Management** - Lazy loading and automatic memory release
- 🌐 **Multi-language UI** - English and Chinese interface
- 📦 **All-in-One Image** - No external dependencies, models included
- 🔒 **Production Ready** - HTTPS, health checks, and monitoring

## 🚀 Quick Start

### Using Docker Hub (Recommended)

```bash
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  -e NVIDIA_VISIBLE_DEVICES=0 \
  neosun/kyutai-tts:allinone
```

Access at: http://localhost:8900

### Using Docker Compose

```bash
git clone https://github.com/neosun100/kyutai-tts-docker.git
cd kyutai-tts-docker
./start.sh
```

## 📦 Installation

### Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- NVIDIA GPU with CUDA support
- nvidia-docker runtime

### Method 1: Pull from Docker Hub

```bash
docker pull neosun/kyutai-tts:allinone
```

### Method 2: Build from Source

```bash
git clone https://github.com/neosun100/kyutai-tts-docker.git
cd kyutai-tts-docker
docker-compose build
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | 8900 | Service port |
| `DEVICE` | cuda | Device type (cuda/cpu) |
| `GPU_IDLE_TIMEOUT` | 60 | GPU idle timeout (seconds) |
| `NVIDIA_VISIBLE_DEVICES` | 0 | GPU ID to use |

### Example `.env` File

```bash
PORT=8900
DEVICE=cuda
GPU_IDLE_TIMEOUT=60
NVIDIA_VISIBLE_DEVICES=0
```

## 📖 Usage

### Web UI

1. Open browser: http://localhost:8900
2. Enter text to synthesize
3. Adjust parameters (optional)
4. Click "Generate"
5. Play or download audio

### REST API

#### Generate Speech

```bash
curl -X POST http://localhost:8900/api/tts \
  -F "text=Hello, world!" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

#### Check GPU Status

```bash
curl http://localhost:8900/api/gpu/status
```

#### Release GPU Memory

```bash
curl -X POST http://localhost:8900/api/gpu/offload
```

### MCP Tools

See [MCP_GUIDE.md](MCP_GUIDE.md) for detailed MCP usage.

```python
result = await mcp_client.call_tool(
    "text_to_speech",
    {
        "text": "Hello from MCP!",
        "output_path": "/tmp/output.wav"
    }
)
```

## 🏗️ Project Structure

```
kyutai-tts-docker/
├── app.py                 # Flask application
├── gpu_manager.py         # GPU resource manager
├── mcp_server.py          # MCP server
├── Dockerfile             # Docker image
├── Dockerfile.allinone    # All-in-one image
├── docker-compose.yml     # Docker Compose config
├── start.sh               # One-click startup script
├── test_api.sh            # API test script
└── docs/                  # Documentation
    ├── QUICKSTART.md
    ├── MCP_GUIDE.md
    └── TEST_REPORT.md
```

## 🛠️ Tech Stack

- **Framework**: Flask 3.0
- **ML Framework**: PyTorch 2.7 + CUDA 12.1
- **TTS Model**: Kyutai TTS 1.6B (English/French)
- **API Docs**: Swagger/Flasgger
- **MCP**: FastMCP 0.2
- **Container**: Docker + nvidia-docker

## 🔗 API Documentation

Once running, access Swagger docs at: http://localhost:8900/apidocs

### Available Endpoints

- `GET /health` - Health check
- `GET /api/gpu/status` - GPU status
- `POST /api/tts` - Generate speech
- `POST /api/gpu/offload` - Release GPU memory

## 🌐 Production Deployment

### With Nginx Reverse Proxy

```nginx
server {
    listen 443 ssl;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:8900;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Multi-GPU Setup

```bash
# GPU 0
NVIDIA_VISIBLE_DEVICES=0 PORT=8900 docker-compose up -d

# GPU 1
NVIDIA_VISIBLE_DEVICES=1 PORT=8901 docker-compose up -d
```

## 📊 Performance

- **Model Size**: 1.6B parameters
- **GPU Memory**: 3-4GB
- **Latency**: 350ms (L40S, 32 concurrent)
- **Speed**: 3-5x real-time
- **Audio Quality**: 16-bit PCM, 24kHz

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 Changelog

### v1.0.0 (2025-12-14)
- Initial release
- Docker deployment with GPU support
- Web UI with multi-language support
- REST API with Swagger docs
- MCP server implementation
- All-in-one Docker image

## 📄 License

- Python code: MIT License
- Rust code: Apache License
- Model weights: CC-BY 4.0

## 🙏 Acknowledgments

- [Kyutai Labs](https://kyutai.org/) for the TTS model
- [Moshi](https://github.com/kyutai-labs/moshi) for the implementation

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=neosun100/kyutai-tts-docker&type=Date)](https://star-history.com/#neosun100/kyutai-tts-docker)

## 📱 Follow Us

![公众号](https://img.aws.xin/uPic/扫码_搜索联合传播样式-标准色版.png)

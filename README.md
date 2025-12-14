# 🚀 Kyutai TTS - GPU Resident Edition

[![Docker](https://img.shields.io/badge/docker-neosun%2Fkyutai--tts-blue)](https://hub.docker.com/r/neosun/kyutai-tts)
[![Version](https://img.shields.io/badge/version-v1.2--allinone-green)](https://github.com/neosun100/kyutai-tts-gpu-resident)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE-MIT)
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
- **Edge-by-edge delivery** - Smooth continuous output

### 🎨 584 Pre-built Voices
- **Expresso**: Emotions (happy, angry, sad, calm, confused, etc.)
- **EARS**: 107 speakers with 25 emotion variants each
- **CML-TTS**: French language voices
- **VCTK**: 109 English speakers
- **Voice Donations**: 200+ community voices
- **Multi-language**: English, French support

## 🚀 Quick Start

### One-Line Deploy

```bash
docker run -d \
  --name kyutai-tts \
  --gpus all \
  -p 8900:8900 \
  -v $(pwd)/custom_voices:/app/custom_voices \
  neosun/kyutai-tts:latest
```

Access at: **http://localhost:8900**

### Docker Compose

```bash
git clone https://github.com/neosun100/kyutai-tts-gpu-resident.git
cd kyutai-tts-gpu-resident
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
  -F "voice=custom/my_voice.wav" \
  -F "cfg_coef=2.0" \
  --output output.wav
```

#### List All Voices

```bash
curl http://localhost:8900/api/voices
```

#### List Custom Voices

```bash
curl http://localhost:8900/api/voices/custom
```

#### Check GPU Status

```bash
curl http://localhost:8900/api/gpu/status
```

#### Release GPU Memory

```bash
curl -X POST http://localhost:8900/api/gpu/offload
```

## 🎯 Voice Categories

### Emotion Voices (EARS)
- `ears/p003/emo_amusement_freeform.wav` - Amusement
- `ears/p003/emo_anger_freeform.wav` - Anger
- `ears/p003/emo_fear_freeform.wav` - Fear
- `ears/p003/emo_sadness_freeform.wav` - Sadness
- `ears/p031/emo_happiness_freeform.wav` - Happiness
- ... and 20+ more emotions

### Style Voices (Expresso)
- `expresso/ex03-ex01_happy_001_channel1_334s.wav` - Happy
- `expresso/ex03-ex01_angry_001_channel1_201s.wav` - Angry
- `expresso/ex03-ex01_calm_001_channel1_1143s.wav` - Calm
- `expresso/ex03-ex01_confused_001_channel1_909s.wav` - Confused
- `expresso/ex03-ex01_laughing_001_channel1_188s.wav` - Laughing
- ... and 50+ more styles

### French Voices (CML-TTS)
- `cml-tts/fr/1406_1028_000009-0003.wav`
- `cml-tts/fr/2114_1656_000053-0001.wav`
- ... and 40+ French voices

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
| `./outputs` | Generated audio files |
| `./custom_voices` | Uploaded custom voices |

## 📊 Performance

- **Model Size**: 1.6B parameters
- **GPU Memory**: 3.8GB (resident mode)
- **Latency**: <100ms (GPU resident)
- **Speed**: 3-5x real-time
- **Audio Quality**: 16-bit PCM, 24kHz
- **Streaming**: Edge-by-edge delivery

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

## 🎨 Custom Voice Cloning

### Requirements
- **Format**: WAV (16-bit PCM)
- **Duration**: 3-10 seconds
- **Quality**: Clear, noise-free recording
- **Content**: Natural speech sample

### Best Practices
1. Record in quiet environment
2. Use consistent tone and pace
3. Avoid background noise
4. Speak clearly and naturally
5. 5-7 seconds is optimal

### Example Workflow

```bash
# 1. Record your voice (use any recording tool)
# Save as my_voice.wav

# 2. Upload to system
curl -X POST http://localhost:8900/api/voice/upload \
  -F "voice_file=@my_voice.wav" \
  -F "voice_name=john_doe"

# 3. Use your voice
curl -X POST http://localhost:8900/api/tts \
  -F "text=This is my cloned voice!" \
  -F "voice=custom/john_doe.wav" \
  --output output.wav
```

## 🌐 Production Deployment

### With Nginx

```nginx
server {
    listen 443 ssl;
    server_name tts.yourdomain.com;
    
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

## 🤝 Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## 📝 Changelog

### v1.2 (2025-12-14)
- ✨ Custom voice cloning
- 🌊 Streaming output
- 🎤 Voice upload interface
- 📦 Persistent custom voices

### v1.1 (2025-12-14)
- ✨ 584 voice options
- 🎨 Enhanced UI with voice selector
- 🔍 Voice search/filter
- 🌐 Multi-language support

### v1.0 (2025-12-14)
- 🚀 Initial release
- 💾 GPU resident mode
- 🎯 Web UI
- 📡 REST API

## 📄 License

- Python code: MIT License
- Rust code: Apache License
- Model weights: CC-BY 4.0

## 🙏 Acknowledgments

- [Kyutai Labs](https://kyutai.org/) for the TTS model
- [Moshi](https://github.com/kyutai-labs/moshi) for the implementation

## 📱 Links

- **Docker Hub**: https://hub.docker.com/r/neosun/kyutai-tts
- **GitHub**: https://github.com/neosun100/kyutai-tts-gpu-resident
- **Demo**: http://localhost:8900 (after deployment)

---

Made with ❤️ by [neosun100](https://github.com/neosun100)

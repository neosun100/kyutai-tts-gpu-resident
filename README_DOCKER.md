# Kyutai TTS Docker 部署指南

## 🎯 功能特性

- ✅ **三种访问模式**: UI 界面 + REST API + MCP 工具
- ✅ **自动 GPU 选择**: 自动选择显存占用最少的 GPU
- ✅ **智能显存管理**: 空闲自动释放，支持手动释放
- ✅ **多语言支持**: 中文/英文界面切换
- ✅ **实时状态监控**: GPU 使用情况实时显示
- ✅ **完整 API 文档**: Swagger 自动生成文档

## 🚀 快速开始

### 一键启动

```bash
./start.sh
```

启动脚本会自动：
1. 检测 NVIDIA 驱动
2. 选择最空闲的 GPU
3. 检查端口可用性
4. 构建 Docker 镜像
5. 启动服务

### 手动启动

```bash
# 1. 复制环境变量配置
cp .env.example .env

# 2. 编辑配置（可选）
nano .env

# 3. 选择 GPU 并启动
export NVIDIA_VISIBLE_DEVICES=2  # 使用 GPU 2
docker-compose up -d
```

## 📍 访问地址

启动后可通过以下地址访问：

- **UI 界面**: http://0.0.0.0:8900
- **API 文档**: http://0.0.0.0:8900/apidocs
- **健康检查**: http://0.0.0.0:8900/health

## 🎨 使用方式

### 方式一：Web UI

1. 打开浏览器访问 http://0.0.0.0:8900
2. 输入要合成的文本
3. 选择音色（可选）
4. 调整参数（可选）
5. 点击"生成语音"
6. 播放或下载生成的音频

**UI 功能**：
- 实时 GPU 状态显示
- 手动释放显存按钮
- 中英文界面切换
- 参数实时调整
- 音频在线播放

### 方式二：REST API

#### 生成语音

```bash
curl -X POST http://0.0.0.0:8900/api/tts \
  -F "text=Hello, this is a test." \
  -F "cfg_coef=2.0" \
  --output output.wav
```

#### 查看 GPU 状态

```bash
curl http://0.0.0.0:8900/api/gpu/status
```

#### 释放 GPU 显存

```bash
curl -X POST http://0.0.0.0:8900/api/gpu/offload
```

#### Python 示例

```python
import requests

# 生成语音
response = requests.post(
    'http://0.0.0.0:8900/api/tts',
    data={
        'text': 'Hello, world!',
        'cfg_coef': 2.0
    }
)

with open('output.wav', 'wb') as f:
    f.write(response.content)

# 查看 GPU 状态
status = requests.get('http://0.0.0.0:8900/api/gpu/status').json()
print(f"GPU Memory: {status['memory_used_gb']}GB")
```

### 方式三：MCP 工具

详见 [MCP_GUIDE.md](MCP_GUIDE.md)

```python
# 通过 MCP 客户端调用
result = await mcp_client.call_tool(
    "text_to_speech",
    {
        "text": "Hello from MCP!",
        "output_path": "/tmp/output.wav"
    }
)
```

## ⚙️ 配置说明

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `PORT` | 8900 | 服务端口 |
| `DEVICE` | cuda | 设备类型 |
| `GPU_IDLE_TIMEOUT` | 60 | GPU 空闲超时（秒） |
| `NVIDIA_VISIBLE_DEVICES` | 0 | 使用的 GPU ID |
| `HF_REPO` | kyutai/tts-1.6b | 模型仓库 |
| `VOICE_REPO` | kyutai/tts-voices | 音色仓库 |
| `DEFAULT_VOICE` | expresso/... | 默认音色 |

### 参数说明

#### cfg_coef (CFG Coefficient)
- **范围**: 1.0 - 3.0
- **默认**: 2.0
- **说明**: 控制生成质量，值越高质量越好但可能过拟合

#### voice (音色)
- **默认**: expresso/ex03-ex01_happy_001_channel1_334s.wav
- **说明**: 可在 [kyutai/tts-voices](https://huggingface.co/kyutai/tts-voices) 查看所有可用音色

## 🔧 管理命令

```bash
# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看容器状态
docker-compose ps

# 进入容器
docker-compose exec kyutai-tts bash

# 查看 GPU 使用
nvidia-smi
```

## 📊 性能优化

### GPU 显存管理

1. **自动释放**: 空闲 60 秒后自动释放（可通过 `GPU_IDLE_TIMEOUT` 调整）
2. **手动释放**: UI 点击"释放显存"或调用 API `/api/gpu/offload`
3. **按需加载**: 首次请求时加载模型，后续请求复用

### 多 GPU 部署

```bash
# 启动多个实例在不同 GPU 上
NVIDIA_VISIBLE_DEVICES=0 PORT=8900 docker-compose up -d
NVIDIA_VISIBLE_DEVICES=1 PORT=8901 docker-compose up -d
NVIDIA_VISIBLE_DEVICES=2 PORT=8902 docker-compose up -d
```

### 负载均衡

使用 Nginx 进行负载均衡：

```nginx
upstream kyutai_tts {
    server 127.0.0.1:8900;
    server 127.0.0.1:8901;
    server 127.0.0.1:8902;
}

server {
    listen 80;
    location / {
        proxy_pass http://kyutai_tts;
    }
}
```

## 🐛 故障排查

### 模型下载失败

```bash
# 手动下载模型
huggingface-cli download kyutai/tts-1.6b
huggingface-cli download kyutai/tts-voices
```

### GPU 显存不足

```bash
# 检查 GPU 使用情况
nvidia-smi

# 释放显存
curl -X POST http://0.0.0.0:8900/api/gpu/offload

# 或重启容器
docker-compose restart
```

### 端口被占用

```bash
# 查看端口占用
ss -tuln | grep 8900

# 使用其他端口
PORT=8901 docker-compose up -d
```

### 容器无法启动

```bash
# 查看详细日志
docker-compose logs

# 检查 nvidia-docker
docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi

# 重新构建
docker-compose build --no-cache
```

## 📈 监控和日志

### 实时监控

```bash
# GPU 使用监控
watch -n 1 nvidia-smi

# 容器资源监控
docker stats kyutai-tts

# 日志监控
docker-compose logs -f --tail=100
```

### 日志位置

- **容器日志**: `docker-compose logs`
- **输出文件**: `./outputs/`
- **模型缓存**: `~/.cache/huggingface/`

## 🔒 安全建议

1. **生产环境**: 添加认证中间件
2. **防火墙**: 限制访问 IP
3. **HTTPS**: 使用反向代理添加 SSL
4. **资源限制**: 设置 Docker 资源限制

```yaml
# docker-compose.yml 添加资源限制
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 16G
```

## 📚 相关文档

- [MCP 使用指南](MCP_GUIDE.md)
- [原项目 README](README.md)
- [Kyutai TTS 官网](https://kyutai.org/next/tts)
- [API 文档](http://0.0.0.0:8900/apidocs)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

- Python 代码: MIT License
- Rust 代码: Apache License
- 模型权重: CC-BY 4.0

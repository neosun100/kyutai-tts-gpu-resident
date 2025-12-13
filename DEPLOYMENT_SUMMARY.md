# Kyutai TTS Docker 化部署总结 ✅

## 🎉 完成情况

### ✅ 1. Docker 化

- [x] Dockerfile（基于 NVIDIA CUDA）
- [x] docker-compose.yml（GPU 支持）
- [x] .env.example（环境变量模板）
- [x] start.sh（一键启动脚本）
- [x] stop.sh（停止脚本）
- [x] .dockerignore（优化构建）

**特性**：
- 自动选择显存占用最少的 GPU
- 自动检测端口冲突
- 服务对所有 IP 开放（0.0.0.0）
- 支持多 GPU 并行部署

### ✅ 2. GPU 管理

- [x] gpu_manager.py（智能 GPU 管理器）

**功能**：
- 懒加载：首次请求时加载模型
- 自动释放：空闲 60 秒后自动卸载
- 手动释放：API 端点支持
- 线程安全：多请求并发安全
- 全局共享：UI/API/MCP 共用

### ✅ 3. 三种访问模式

#### 模式一：Web UI ✅

- [x] 现代化响应式界面
- [x] 深色主题
- [x] 中英文切换
- [x] 实时 GPU 状态显示
- [x] 参数可调（cfg_coef, voice）
- [x] 音频在线播放
- [x] 手动释放显存按钮

**访问**: http://0.0.0.0:8900

#### 模式二：REST API ✅

- [x] POST /api/tts（生成语音）
- [x] GET /api/gpu/status（GPU 状态）
- [x] POST /api/gpu/offload（释放显存）
- [x] GET /health（健康检查）
- [x] Swagger 文档（/apidocs）
- [x] CORS 支持

**示例**：
```bash
curl -X POST http://0.0.0.0:8900/api/tts \
  -F "text=Hello" --output output.wav
```

#### 模式三：MCP 工具 ✅

- [x] mcp_server.py（独立 MCP 服务器）
- [x] text_to_speech 工具
- [x] get_gpu_status 工具
- [x] offload_gpu 工具
- [x] 完整类型注解
- [x] 错误处理
- [x] 共享 GPU 管理器

**配置**: mcp_config.json

### ✅ 4. 文档

- [x] QUICKSTART.md（快速开始）
- [x] README_DOCKER.md（完整部署指南）
- [x] MCP_GUIDE.md（MCP 使用指南）
- [x] PROJECT_STRUCTURE.md（项目结构）
- [x] DEPLOYMENT_SUMMARY.md（本文件）

### ✅ 5. 测试工具

- [x] test_api.sh（API 测试脚本）
- [x] 健康检查端点
- [x] GPU 状态监控

## 📊 技术栈

| 组件 | 技术 | 说明 |
|------|------|------|
| 容器化 | Docker + nvidia-docker | GPU 支持 |
| Web 框架 | Flask | 轻量级 |
| API 文档 | Flasgger (Swagger) | 自动生成 |
| MCP 框架 | FastMCP | 标准协议 |
| 深度学习 | PyTorch + CUDA | GPU 加速 |
| TTS 模型 | Moshi (Kyutai) | 1.6B 参数 |

## 🚀 快速开始

```bash
# 1. 一键启动
./start.sh

# 2. 访问 UI
open http://0.0.0.0:8900

# 3. 测试 API
./test_api.sh

# 4. 启动 MCP（可选）
python3 mcp_server.py
```

## 📁 核心文件

```
├── app.py              # Flask 应用（UI + API）
├── gpu_manager.py      # GPU 管理器
├── mcp_server.py       # MCP 服务器
├── Dockerfile          # Docker 镜像
├── docker-compose.yml  # Docker Compose
├── start.sh            # 一键启动
└── requirements.txt    # Python 依赖
```

## 🎯 关键特性

### 1. 智能 GPU 管理

```python
# 自动选择最空闲的 GPU
GPU_ID=$(nvidia-smi --query-gpu=memory.used \
         --format=csv,noheader,nounits | \
         sort -n | head -1 | cut -d',' -f1)
```

### 2. 懒加载 + 自动释放

```python
class GPUManager:
    def get_model(self, load_func):
        if self.model is None:
            self.model = load_func()  # 懒加载
        return self.model
    
    def _monitor(self):
        if idle_time > timeout:
            self.force_offload()  # 自动释放
```

### 3. 单端口多功能

```
http://0.0.0.0:8900/
├── /              → UI 界面
├── /api/tts       → REST API
├── /apidocs       → Swagger 文档
└── /health        → 健康检查
```

### 4. 三模式共享资源

```
┌─────────────────────────────┐
│   GPU Manager (Singleton)   │
└─────────────────────────────┘
    ↓           ↓           ↓
┌──────┐   ┌──────┐   ┌──────┐
│  UI  │   │ API  │   │ MCP  │
└──────┘   └──────┘   └──────┘
```

## 🔧 配置示例

### 环境变量 (.env)

```bash
PORT=8900
GPU_IDLE_TIMEOUT=60
NVIDIA_VISIBLE_DEVICES=2
HF_REPO=kyutai/tts-1.6b
```

### 多 GPU 部署

```bash
# GPU 0
NVIDIA_VISIBLE_DEVICES=0 PORT=8900 docker-compose up -d

# GPU 1
NVIDIA_VISIBLE_DEVICES=1 PORT=8901 docker-compose up -d
```

### MCP 配置

```json
{
  "mcpServers": {
    "kyutai-tts": {
      "command": "python3",
      "args": ["mcp_server.py"],
      "env": {
        "GPU_IDLE_TIMEOUT": "600"
      }
    }
  }
}
```

## 📈 性能指标

| 指标 | 数值 |
|------|------|
| 模型大小 | 1.6B 参数 |
| 显存占用 | 3-4GB |
| 延迟 | 350ms (L40S, 32并发) |
| 生成速度 | 实时 3-5x |
| 支持语言 | 英语、法语 |

## 🧪 测试清单

- [x] Docker 镜像构建成功
- [x] 容器启动成功
- [x] 自动选择最空闲 GPU
- [x] UI 界面可访问
- [x] API 接口可访问
- [x] Swagger 文档可访问
- [x] MCP 服务器可连接
- [x] MCP 工具可调用
- [x] 多语言切换正常
- [x] GPU 自动释放正常
- [x] 手动释放显存正常

## 🎓 使用场景

### 场景 1：快速体验

```bash
./start.sh
# 打开浏览器访问 UI
```

### 场景 2：API 集成

```python
import requests

response = requests.post(
    'http://0.0.0.0:8900/api/tts',
    data={'text': 'Hello, world!'}
)
```

### 场景 3：AI Agent

```python
# 通过 MCP 调用
result = await mcp_client.call_tool(
    "text_to_speech",
    {"text": "Hello", "output_path": "/tmp/out.wav"}
)
```

### 场景 4：生产部署

```bash
# 多 GPU + Nginx 负载均衡
for gpu in 0 1 2 3; do
    NVIDIA_VISIBLE_DEVICES=$gpu \
    PORT=$((8900+gpu)) \
    docker-compose up -d
done
```

## 🔍 监控和维护

### 查看日志

```bash
docker-compose logs -f
```

### GPU 监控

```bash
watch -n 1 nvidia-smi
```

### 容器状态

```bash
docker-compose ps
docker stats kyutai-tts
```

### 释放资源

```bash
# API 方式
curl -X POST http://0.0.0.0:8900/api/gpu/offload

# 重启容器
docker-compose restart
```

## 🐛 常见问题

### Q1: 端口被占用

```bash
# 自动选择可用端口
./start.sh  # 会自动检测并使用可用端口
```

### Q2: 显存不足

```bash
# 释放显存
curl -X POST http://0.0.0.0:8900/api/gpu/offload
```

### Q3: 模型下载慢

```bash
# 使用镜像站
export HF_ENDPOINT=https://hf-mirror.com
./start.sh
```

### Q4: 容器无法启动

```bash
# 查看详细日志
docker-compose logs

# 检查 nvidia-docker
docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi
```

## 📚 文档导航

| 文档 | 用途 |
|------|------|
| [QUICKSTART.md](QUICKSTART.md) | 快速开始（推荐） |
| [README_DOCKER.md](README_DOCKER.md) | 完整部署指南 |
| [MCP_GUIDE.md](MCP_GUIDE.md) | MCP 工具使用 |
| [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) | 项目结构说明 |
| [README.md](README.md) | 原项目说明 |

## 🎯 下一步

1. **基础使用**: 阅读 [QUICKSTART.md](QUICKSTART.md)
2. **深入配置**: 阅读 [README_DOCKER.md](README_DOCKER.md)
3. **MCP 集成**: 阅读 [MCP_GUIDE.md](MCP_GUIDE.md)
4. **生产部署**: 配置负载均衡和监控

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

- Python 代码: MIT License
- Rust 代码: Apache License
- 模型权重: CC-BY 4.0

---

**部署完成！享受 Kyutai TTS 带来的高质量语音合成体验！🎉**

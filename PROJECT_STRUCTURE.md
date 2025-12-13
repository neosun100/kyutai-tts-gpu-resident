# 项目结构说明

## 核心文件

```
delayed-streams-modeling/
├── app.py                    # Flask 主应用（UI + API）
├── gpu_manager.py            # GPU 资源管理器
├── mcp_server.py            # MCP 服务器
├── Dockerfile               # Docker 镜像定义
├── docker-compose.yml       # Docker Compose 配置
├── requirements.txt         # Python 依赖
├── .env.example            # 环境变量模板
└── start.sh                # 一键启动脚本
```

## 文档文件

```
├── QUICKSTART.md           # 快速开始指南（推荐先看）
├── README_DOCKER.md        # Docker 部署完整指南
├── MCP_GUIDE.md           # MCP 工具使用指南
├── PROJECT_STRUCTURE.md   # 本文件
└── README.md              # 原项目说明
```

## 配置文件

```
├── .env                   # 环境变量（需创建）
├── .env.example          # 环境变量模板
├── mcp_config.json       # MCP 客户端配置示例
└── configs/              # 模型配置文件
    ├── config-tts.toml
    ├── config-stt-en-hf.toml
    └── config-stt-en_fr-hf.toml
```

## 脚本文件

```
├── start.sh              # 一键启动（自动选 GPU）
├── stop.sh               # 停止服务
├── test_api.sh          # API 测试脚本
└── scripts/             # 原项目脚本
    ├── tts_pytorch.py
    ├── tts_pytorch_streaming.py
    ├── tts_mlx.py
    └── ...
```

## 输出目录

```
├── outputs/             # 生成的音频文件
└── ~/.cache/huggingface/ # 模型缓存（自动创建）
```

## 架构说明

### 1. GPU 管理器 (gpu_manager.py)

```python
class GPUManager:
    - get_model()      # 获取模型（懒加载）
    - force_offload()  # 强制释放显存
    - _monitor()       # 后台监控（自动释放）
```

**特点**：
- 单例模式，全局共享
- 懒加载：首次请求时加载模型
- 自动释放：空闲超时后自动卸载
- 线程安全：使用锁保护

### 2. Flask 应用 (app.py)

```python
Routes:
├── /                    # UI 界面
├── /health             # 健康检查
├── /api/tts            # TTS API
├── /api/gpu/status     # GPU 状态
├── /api/gpu/offload    # 释放显存
└── /apidocs            # Swagger 文档
```

**特点**：
- 单端口多功能
- 内嵌 HTML（无需额外文件）
- CORS 支持
- Swagger 自动文档

### 3. MCP 服务器 (mcp_server.py)

```python
Tools:
├── text_to_speech()    # 文本转语音
├── get_gpu_status()    # 查询 GPU 状态
└── offload_gpu()       # 释放显存
```

**特点**：
- 独立进程运行
- 与 Flask 共享 GPU 管理器
- 标准 MCP 协议
- 完整类型注解

## 数据流

### UI 请求流程

```
用户浏览器
    ↓ HTTP POST /api/tts
Flask App
    ↓ get_model()
GPU Manager
    ↓ 加载/复用模型
TTS Model
    ↓ 生成音频
返回 WAV 文件
```

### MCP 调用流程

```
MCP Client (AI Agent)
    ↓ call_tool("text_to_speech")
MCP Server
    ↓ get_model()
GPU Manager (共享)
    ↓ 加载/复用模型
TTS Model
    ↓ 生成音频
返回结果字典
```

## 部署模式

### 单 GPU 模式（默认）

```bash
./start.sh
# 自动选择最空闲的 GPU
```

### 多 GPU 模式

```bash
# 启动多个实例
NVIDIA_VISIBLE_DEVICES=0 PORT=8900 docker-compose up -d
NVIDIA_VISIBLE_DEVICES=1 PORT=8901 docker-compose up -d
NVIDIA_VISIBLE_DEVICES=2 PORT=8902 docker-compose up -d
```

### 混合模式（Docker + MCP）

```bash
# Docker 提供 Web 服务
./start.sh

# MCP 提供 AI Agent 接口
python3 mcp_server.py
```

## 环境变量优先级

```
1. 命令行环境变量（最高）
   PORT=8901 ./start.sh

2. .env 文件
   PORT=8900

3. 代码默认值（最低）
   PORT = int(os.getenv('PORT', 8900))
```

## 端口分配建议

```
8900 - UI + API (GPU 0)
8901 - UI + API (GPU 1)
8902 - UI + API (GPU 2)
8903 - UI + API (GPU 3)
```

## 显存占用

```
模型加载: ~3-4GB
推理峰值: ~4-5GB
空闲状态: ~0GB (自动释放)
```

## 性能优化点

1. **模型复用**: 多次请求共享同一模型实例
2. **懒加载**: 首次请求时才加载模型
3. **自动释放**: 空闲超时自动卸载
4. **批处理**: 可扩展支持批量生成
5. **缓存**: HuggingFace 模型自动缓存

## 扩展建议

### 添加新 API 端点

```python
# app.py
@app.route('/api/new_endpoint', methods=['POST'])
def new_endpoint():
    """新功能"""
    # 实现逻辑
    pass
```

### 添加新 MCP 工具

```python
# mcp_server.py
@mcp.tool()
def new_tool(param: str) -> dict:
    """新工具"""
    # 实现逻辑
    pass
```

### 添加新语言支持

```javascript
// app.py 中的 UI_HTML
const i18n = {
    'ja': {
        title: "Kyutai 音声合成",
        // 添加日语翻译
    }
};
```

## 常见问题

### Q: 如何更换模型？

A: 修改 `.env` 中的 `HF_REPO`

### Q: 如何添加新音色？

A: 上传到 `VOICE_REPO` 或使用本地 `.safetensors` 文件

### Q: 如何限制并发？

A: 在 Flask 前添加 Nginx 限流或使用 Gunicorn 限制 workers

### Q: 如何监控性能？

A: 使用 Prometheus + Grafana 监控 GPU 和 API 指标

## 相关资源

- [Kyutai TTS 官网](https://kyutai.org/next/tts)
- [Moshi 包文档](https://pypi.org/project/moshi/)
- [FastMCP 文档](https://github.com/jlowin/fastmcp)
- [Flask 文档](https://flask.palletsprojects.com/)

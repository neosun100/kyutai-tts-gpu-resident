# Kyutai TTS 快速开始 🚀

## 一键启动

```bash
./start.sh
```

就这么简单！脚本会自动选择最空闲的 GPU 并启动服务。

## 访问服务

启动后访问：

- **UI 界面**: http://0.0.0.0:8900
- **API 文档**: http://0.0.0.0:8900/apidocs

## 三种使用方式

### 1. Web UI（最简单）

打开浏览器 → 输入文本 → 点击生成 → 播放音频

### 2. REST API（集成方便）

```bash
# 生成语音
curl -X POST http://0.0.0.0:8900/api/tts \
  -F "text=你好，世界！" \
  --output output.wav

# 查看 GPU 状态
curl http://0.0.0.0:8900/api/gpu/status

# 释放显存
curl -X POST http://0.0.0.0:8900/api/gpu/offload
```

### 3. MCP 工具（AI Agent）

```python
# 通过 MCP 调用
result = await mcp_client.call_tool(
    "text_to_speech",
    {
        "text": "Hello from MCP!",
        "output_path": "/tmp/output.wav"
    }
)
```

详见 [MCP_GUIDE.md](MCP_GUIDE.md)

## 常用命令

```bash
# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 测试 API
./test_api.sh
```

## 配置

编辑 `.env` 文件：

```bash
PORT=8900                    # 服务端口
GPU_IDLE_TIMEOUT=60          # GPU 空闲超时（秒）
NVIDIA_VISIBLE_DEVICES=0     # 使用的 GPU ID
```

## 多 GPU 部署

```bash
# GPU 0
NVIDIA_VISIBLE_DEVICES=0 PORT=8900 docker-compose up -d

# GPU 1
NVIDIA_VISIBLE_DEVICES=1 PORT=8901 docker-compose up -d
```

## 故障排查

### 模型下载慢？

```bash
# 使用镜像站
export HF_ENDPOINT=https://hf-mirror.com
```

### 显存不足？

```bash
# 释放显存
curl -X POST http://0.0.0.0:8900/api/gpu/offload
```

### 端口被占用？

```bash
# 使用其他端口
PORT=8901 ./start.sh
```

## 完整文档

- [Docker 部署指南](README_DOCKER.md) - 详细配置和优化
- [MCP 使用指南](MCP_GUIDE.md) - MCP 工具详解
- [原项目 README](README.md) - 模型介绍和原理

## 性能参考

- **L40S GPU**: 32 并发请求，延迟 350ms
- **显存占用**: ~3-4GB（模型加载后）
- **生成速度**: 实时 3-5x

## 支持

遇到问题？

1. 查看 [FAQ](FAQ.md)
2. 查看日志: `docker-compose logs`
3. 提交 Issue

---

**Enjoy! 🎉**

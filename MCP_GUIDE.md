# Kyutai TTS MCP Server Guide

## What is MCP?

Model Context Protocol (MCP) is an open protocol that enables programmatic access to AI models and tools. The Kyutai TTS MCP server provides three tools for text-to-speech generation and GPU management.

## Available Tools

### 1. text_to_speech

Convert text to speech and save as WAV file.

**Parameters:**
- `text` (string, required): Text to synthesize
- `output_path` (string, required): Path to save audio file (must end with .wav)
- `voice` (string, optional): Voice name (default: expresso/ex03-ex01_happy_001_channel1_334s.wav)
- `cfg_coef` (float, optional): CFG coefficient 1.0-3.0 (default: 2.0)

**Returns:**
```json
{
  "status": "success",
  "output_path": "/path/to/output.wav",
  "duration_seconds": 5.2
}
```

**Example:**
```python
result = await mcp_client.call_tool(
    "text_to_speech",
    {
        "text": "Hello, this is a test.",
        "output_path": "/tmp/output.wav",
        "cfg_coef": 2.0
    }
)
```

### 2. get_gpu_status

Get current GPU status and memory usage.

**Parameters:** None

**Returns:**
```json
{
  "available": true,
  "model_loaded": true,
  "memory_used_gb": 3.2,
  "memory_total_gb": 46.0
}
```

### 3. offload_gpu

Force unload model from GPU to free memory.

**Parameters:** None

**Returns:**
```json
{
  "status": "GPU memory released"
}
```

## Installation

### 1. Start MCP Server

```bash
# Install dependencies
pip install fastmcp moshi torch sphn

# Run MCP server
python3 mcp_server.py
```

### 2. Configure MCP Client

Add to your MCP client configuration (e.g., Claude Desktop, Cline):

```json
{
  "mcpServers": {
    "kyutai-tts": {
      "command": "python3",
      "args": ["/path/to/delayed-streams-modeling/mcp_server.py"],
      "env": {
        "GPU_IDLE_TIMEOUT": "600",
        "DEVICE": "cuda",
        "HF_REPO": "kyutai/tts-1.6b"
      }
    }
  }
}
```

## Usage Examples

### Example 1: Basic TTS

```python
# Generate speech from text
result = await mcp_client.call_tool(
    "text_to_speech",
    {
        "text": "Welcome to Kyutai TTS!",
        "output_path": "/tmp/welcome.wav"
    }
)
print(f"Audio saved to: {result['output_path']}")
```

### Example 2: Custom Voice

```python
# Use different voice
result = await mcp_client.call_tool(
    "text_to_speech",
    {
        "text": "This is a custom voice.",
        "output_path": "/tmp/custom.wav",
        "voice": "expresso/ex03-ex01_happy_001_channel1_334s.wav",
        "cfg_coef": 2.5
    }
)
```

### Example 3: Check GPU Before Generation

```python
# Check GPU status
status = await mcp_client.call_tool("get_gpu_status", {})
print(f"GPU Memory: {status['memory_used_gb']}GB / {status['memory_total_gb']}GB")

# Generate if GPU available
if status['available']:
    result = await mcp_client.call_tool(
        "text_to_speech",
        {"text": "Hello!", "output_path": "/tmp/hello.wav"}
    )
```

### Example 4: Batch Processing with GPU Management

```python
texts = ["First sentence.", "Second sentence.", "Third sentence."]

for i, text in enumerate(texts):
    result = await mcp_client.call_tool(
        "text_to_speech",
        {
            "text": text,
            "output_path": f"/tmp/output_{i}.wav"
        }
    )
    print(f"Generated: {result['output_path']}")

# Release GPU after batch
await mcp_client.call_tool("offload_gpu", {})
```

## MCP vs API Comparison

| Feature | MCP | REST API |
|---------|-----|----------|
| Access Method | Programmatic (Python/JS) | HTTP Requests |
| Authentication | Local process | None (open) |
| GPU Management | Shared manager | Shared manager |
| Use Case | AI agents, automation | Web apps, integrations |
| Latency | Lower (local) | Higher (network) |

## Troubleshooting

### Model not loading
- Check GPU availability: `nvidia-smi`
- Verify HuggingFace cache: `~/.cache/huggingface`
- Check environment variables in MCP config

### Out of memory
- Reduce `GPU_IDLE_TIMEOUT` to offload faster
- Call `offload_gpu` manually after generation
- Use smaller batch sizes

### MCP server not responding
- Check if server is running: `ps aux | grep mcp_server`
- Verify Python dependencies: `pip list | grep fastmcp`
- Check logs for errors

## Advanced Configuration

### Custom Model

```json
{
  "mcpServers": {
    "kyutai-tts": {
      "command": "python3",
      "args": ["mcp_server.py"],
      "env": {
        "HF_REPO": "your-custom-repo",
        "VOICE_REPO": "your-voice-repo",
        "DEFAULT_VOICE": "your-voice.wav"
      }
    }
  }
}
```

### Multiple GPU Support

```json
{
  "mcpServers": {
    "kyutai-tts-gpu0": {
      "command": "python3",
      "args": ["mcp_server.py"],
      "env": {
        "CUDA_VISIBLE_DEVICES": "0"
      }
    },
    "kyutai-tts-gpu1": {
      "command": "python3",
      "args": ["mcp_server.py"],
      "env": {
        "CUDA_VISIBLE_DEVICES": "1"
      }
    }
  }
}
```

## Resources

- [FastMCP Documentation](https://github.com/jlowin/fastmcp)
- [Kyutai TTS Project](https://kyutai.org/next/tts)
- [Model Context Protocol Spec](https://modelcontextprotocol.io)

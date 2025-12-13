#!/bin/bash

set -e

echo "🚀 Kyutai TTS Docker Launcher"
echo "=============================="

# Check nvidia-docker
if ! command -v nvidia-smi &> /dev/null; then
    echo "❌ nvidia-smi not found. Please install NVIDIA drivers."
    exit 1
fi

echo "✅ NVIDIA drivers detected"

# Auto-select least used GPU
echo "🔍 Detecting available GPUs..."
GPU_ID=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits | \
         sort -t',' -k2 -n | head -1 | cut -d',' -f1)
GPU_MEM=$(nvidia-smi --query-gpu=index,memory.used,memory.total --format=csv,noheader,nounits | \
          grep "^$GPU_ID," | awk -F',' '{print $2"/"$3"MB"}')

echo "✅ Selected GPU $GPU_ID (Memory: $GPU_MEM)"

# Check port availability
PORT=${PORT:-8900}
if ss -tuln | grep -q ":$PORT "; then
    echo "⚠️  Port $PORT is in use. Trying next available port..."
    for p in {8901..8999}; do
        if ! ss -tuln | grep -q ":$p "; then
            PORT=$p
            break
        fi
    done
    echo "✅ Using port $PORT"
fi

# Create .env if not exists
if [ ! -f .env ]; then
    echo "📝 Creating .env from .env.example..."
    cp .env.example .env
fi

# Set environment variables
export NVIDIA_VISIBLE_DEVICES=$GPU_ID
export PORT=$PORT

# Update .env
sed -i "s/^NVIDIA_VISIBLE_DEVICES=.*/NVIDIA_VISIBLE_DEVICES=$GPU_ID/" .env
sed -i "s/^PORT=.*/PORT=$PORT/" .env

echo ""
echo "🎯 Configuration:"
echo "   GPU: $GPU_ID"
echo "   Port: $PORT"
echo "   Idle Timeout: ${GPU_IDLE_TIMEOUT:-60}s"
echo ""

# Build and start
echo "🔨 Building Docker image..."
docker-compose build

echo "🚀 Starting service..."
docker-compose up -d

echo ""
echo "✅ Service started successfully!"
echo ""
echo "📍 Access URLs:"
echo "   UI:      http://0.0.0.0:$PORT"
echo "   API:     http://0.0.0.0:$PORT/api/tts"
echo "   Swagger: http://0.0.0.0:$PORT/apidocs"
echo "   Health:  http://0.0.0.0:$PORT/health"
echo ""
echo "🔧 Management:"
echo "   Logs:    docker-compose logs -f"
echo "   Stop:    docker-compose down"
echo "   Restart: docker-compose restart"
echo ""
echo "📚 MCP Server:"
echo "   Run: python3 mcp_server.py"
echo "   See: MCP_GUIDE.md for details"
echo ""

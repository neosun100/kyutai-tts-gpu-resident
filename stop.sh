#!/bin/bash

echo "🛑 Stopping Kyutai TTS..."

# Stop docker-compose
docker-compose down

echo "✅ Service stopped"
echo ""
echo "💡 To start again: ./start.sh"

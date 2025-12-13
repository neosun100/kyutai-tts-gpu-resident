#!/bin/bash

PORT=${1:-8900}
BASE_URL="http://0.0.0.0:$PORT"

echo "🧪 Testing Kyutai TTS API on port $PORT"
echo "========================================"

# Test 1: Health Check
echo ""
echo "1️⃣ Health Check"
curl -s "$BASE_URL/health" | jq '.'

# Test 2: GPU Status
echo ""
echo "2️⃣ GPU Status"
curl -s "$BASE_URL/api/gpu/status" | jq '.'

# Test 3: Generate Speech
echo ""
echo "3️⃣ Generate Speech"
curl -X POST "$BASE_URL/api/tts" \
  -F "text=Hello, this is a test of Kyutai TTS." \
  -F "cfg_coef=2.0" \
  --output /tmp/test_output.wav

if [ -f /tmp/test_output.wav ]; then
    SIZE=$(du -h /tmp/test_output.wav | cut -f1)
    echo "✅ Audio generated: /tmp/test_output.wav ($SIZE)"
else
    echo "❌ Failed to generate audio"
fi

# Test 4: GPU Status After Generation
echo ""
echo "4️⃣ GPU Status After Generation"
curl -s "$BASE_URL/api/gpu/status" | jq '.'

# Test 5: Offload GPU
echo ""
echo "5️⃣ Offload GPU"
curl -s -X POST "$BASE_URL/api/gpu/offload" | jq '.'

echo ""
echo "✅ All tests completed!"

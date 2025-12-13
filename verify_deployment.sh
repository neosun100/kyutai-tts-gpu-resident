#!/bin/bash

echo "🔍 Kyutai TTS Deployment Verification"
echo "======================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1 (missing)"
        return 1
    fi
}

check_executable() {
    if [ -x "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 (executable)"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $1 (not executable)"
        return 1
    fi
}

echo "📁 Core Files:"
check_file "app.py"
check_file "gpu_manager.py"
check_file "mcp_server.py"
check_file "Dockerfile"
check_file "docker-compose.yml"
check_file "requirements.txt"
check_file ".env.example"
check_file ".dockerignore"

echo ""
echo "📜 Scripts:"
check_executable "start.sh"
check_executable "stop.sh"
check_executable "test_api.sh"

echo ""
echo "📚 Documentation:"
check_file "QUICKSTART.md"
check_file "README_DOCKER.md"
check_file "MCP_GUIDE.md"
check_file "PROJECT_STRUCTURE.md"
check_file "DEPLOYMENT_SUMMARY.md"

echo ""
echo "⚙️  Configuration:"
check_file "mcp_config.json"

echo ""
echo "🖥️  System Checks:"

# Check nvidia-smi
if command -v nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓${NC} nvidia-smi available"
    GPU_COUNT=$(nvidia-smi --list-gpus | wc -l)
    echo -e "  ${GREEN}→${NC} Found $GPU_COUNT GPU(s)"
else
    echo -e "${RED}✗${NC} nvidia-smi not found"
fi

# Check docker
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓${NC} docker available"
else
    echo -e "${RED}✗${NC} docker not found"
fi

# Check docker-compose
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✓${NC} docker-compose available"
else
    echo -e "${RED}✗${NC} docker-compose not found"
fi

# Check Python
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓${NC} python3 available"
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    echo -e "  ${GREEN}→${NC} Version: $PYTHON_VERSION"
else
    echo -e "${RED}✗${NC} python3 not found"
fi

echo ""
echo "🔌 Port Check:"
PORT=8900
if ss -tuln | grep -q ":$PORT "; then
    echo -e "${YELLOW}⚠${NC} Port $PORT is in use"
    echo -e "  ${YELLOW}→${NC} start.sh will auto-select next available port"
else
    echo -e "${GREEN}✓${NC} Port $PORT is available"
fi

echo ""
echo "📦 Directory Structure:"
if [ -d "outputs" ]; then
    echo -e "${GREEN}✓${NC} outputs/ directory exists"
else
    echo -e "${YELLOW}⚠${NC} outputs/ directory missing (will be created)"
    mkdir -p outputs
fi

if [ -d "scripts" ]; then
    echo -e "${GREEN}✓${NC} scripts/ directory exists"
else
    echo -e "${RED}✗${NC} scripts/ directory missing"
fi

if [ -d "configs" ]; then
    echo -e "${GREEN}✓${NC} configs/ directory exists"
else
    echo -e "${RED}✗${NC} configs/ directory missing"
fi

echo ""
echo "🎯 Ready to Deploy:"
echo ""
echo "  1. Quick Start:"
echo "     ${GREEN}./start.sh${NC}"
echo ""
echo "  2. Manual Start:"
echo "     ${GREEN}cp .env.example .env${NC}"
echo "     ${GREEN}docker-compose up -d${NC}"
echo ""
echo "  3. MCP Server:"
echo "     ${GREEN}python3 mcp_server.py${NC}"
echo ""
echo "📖 Documentation:"
echo "   Start here: ${GREEN}QUICKSTART.md${NC}"
echo ""

#!/bin/bash

# Claude Agent Framework (Python) Setup Script
# This script sets up the Python implementation with Pixi package management

echo "🚀 Setting up Claude Agent Framework (Python)..."

# Check if pixi is installed
if ! command -v pixi &> /dev/null; then
    echo "❌ Pixi is not installed!"
    echo "Please install Pixi first: https://pixi.sh/latest/"
    echo "Quick install: curl -fsSL https://pixi.sh/install.sh | bash"
    exit 1
fi

echo "✅ Pixi found: $(pixi --version)"

# Ensure MCP dependency is in pixi.toml
echo "📦 Checking dependencies..."
if ! grep -q "mcp = " pixi.toml; then
    echo "🔧 Adding MCP dependency to pixi.toml..."
    pixi add mcp
else
    echo "✅ MCP dependency already present"
fi

# Install dependencies
echo "📦 Installing dependencies with Pixi..."
pixi install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully!"
else
    echo "❌ Dependency installation failed!"
    exit 1
fi

# Install package in development mode
echo "🔧 Installing package in development mode..."
pixi run pip install -e .

if [ $? -eq 0 ]; then
    echo "✅ Package installed in development mode!"
else
    echo "❌ Package installation failed!"
    exit 1
fi

# Test the installation
echo "🧪 Testing installation..."
echo "Testing MCP import..."
pixi run python -c 'import mcp; print("✅ MCP module imported successfully")'

if [ $? -ne 0 ]; then
    echo "❌ MCP import test failed!"
    exit 1
fi

echo "Testing Claude Agent CLI..."
pixi run claude-agent --help > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Claude Agent CLI is working!"
else
    echo "❌ Claude Agent CLI test failed!"
    exit 1
fi

# Create wrapper script for easier access
echo "🔧 Creating wrapper script..."
cat > claude-agent-wrapper << 'EOF'
#!/bin/bash
# Claude Agent Framework Wrapper Script
# This script runs the Claude Agent CLI using Pixi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if we're in the right directory
if [ ! -f "pixi.toml" ]; then
    echo "Error: Must run from the Python project directory"
    exit 1
fi

# Run with pixi
exec pixi run claude-agent "$@"
EOF

chmod +x claude-agent-wrapper

# Test examples
echo "🧪 Testing examples..."
if [ -f "examples/quick_start.py" ]; then
    echo "Testing quick start example (requires ANTHROPIC_API_KEY)..."
    if [ -n "$ANTHROPIC_API_KEY" ]; then
        pixi run python examples/quick_start.py > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "✅ Quick start example works!"
        else
            echo "⚠️  Quick start example had issues (may need API key)"
        fi
    else
        echo "⚠️  Skipping quick start test (ANTHROPIC_API_KEY not set)"
    fi
fi

echo ""
echo "🎉 Setup complete! Claude Agent Framework (Python) is ready to use!"
echo ""
echo "📋 Available run methods:"
echo ""
echo "1. Using Pixi (recommended):"
echo "   pixi run claude-agent --help"
echo "   pixi run claude-agent interactive"
echo ""
echo "2. Using wrapper script:"
echo "   ./claude-agent-wrapper --help"
echo "   ./claude-agent-wrapper interactive"
echo ""
echo "3. Using Python module directly:"
echo "   pixi run python -m claude_agent.cli.main --help"
echo ""
echo "4. Running examples:"
echo "   pixi run python examples/quick_start.py"
echo "   pixi run python examples/basic_usage.py"
echo ""
echo "📚 Common commands:"
echo "   pixi run claude-agent list-tools          # List available tools"
echo "   pixi run claude-agent interactive         # Start interactive session"
echo "   pixi run claude-agent chat --prompt 'Hi'  # Single prompt"
echo "   pixi run claude-agent generate-config     # Generate config template"
echo ""
echo "⚙️  Configuration:"
echo "   - Set ANTHROPIC_API_KEY environment variable"
echo "   - Create claude-agent.yaml for custom configuration"
echo "   - Use --config flag to specify custom config file"
echo ""
echo "🔧 Development:"
echo "   pixi run python -m pytest tests/         # Run tests"
echo "   pixi shell                               # Enter development shell"
echo ""
echo "💡 For more information, check the documentation and examples directory." 
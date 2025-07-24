# Claude Agent Framework (Python) - Setup Guide

This guide will help you set up the Python implementation of the Claude Agent Framework.

## Prerequisites

- **Pixi Package Manager**: This project uses Pixi for dependency management
  - Install from: https://pixi.sh/latest/
  - Quick install: `curl -fsSL https://pixi.sh/install.sh | bash`
- **Python 3.8+**: Managed automatically by Pixi
- **Anthropic API Key**: Required for Claude API access

## Quick Setup

Run the automated setup script:

```bash
./setup.sh
```

This script will:
- ✅ Check for Pixi installation
- ✅ Ensure MCP dependency is present
- ✅ Install all dependencies with Pixi
- ✅ Install the package in development mode
- ✅ Test the installation
- ✅ Create a wrapper script for easy access

## Manual Setup

If you prefer to set up manually:

1. **Install dependencies:**
   ```bash
   pixi install
   ```

2. **Add MCP dependency (if missing):**
   ```bash
   pixi add mcp
   ```

3. **Install in development mode:**
   ```bash
   pixi run pip install -e .
   ```

## Usage

After setup, you can run the Claude Agent CLI in several ways:

### 1. Using Pixi (Recommended)
```bash
pixi run claude-agent --help
pixi run claude-agent interactive
pixi run claude-agent chat --prompt "Hello!"
```

### 2. Using the Wrapper Script
```bash
./claude-agent-wrapper --help
./claude-agent-wrapper interactive
```

### 3. Using Python Module Directly
```bash
pixi run python -m claude_agent.cli.main --help
```

## Configuration

### API Key
Set your Anthropic API key:
```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

### Custom Configuration
Create a `claude-agent.yaml` file:
```yaml
agent:
  name: "my-agent"
  system_prompt: "You are a helpful assistant."
  verbose: true

model:
  model: "claude-3-5-sonnet-20241022"
  max_tokens: 4096
  temperature: 0.7

tools:
  enabled: ["all"]

mcp:
  servers: []
```

## Available Commands

| Command | Description |
|---------|-------------|
| `claude-agent interactive` | Start interactive chat session |
| `claude-agent chat --prompt "text"` | Send single prompt |
| `claude-agent list-tools` | Show available tools |
| `claude-agent tool-info <name>` | Show tool details |
| `claude-agent generate-config` | Generate config template |

## Examples

Run the provided examples:
```bash
pixi run python examples/quick_start.py
pixi run python examples/basic_usage.py
```

## Development

### Enter Development Shell
```bash
pixi shell
```

### Run Tests
```bash
pixi run python -m pytest tests/
```

### Available Tools
- `think` - Internal reasoning tool
- `file_read` - Read file contents
- `file_write` - Write file contents
- `code_execution` - Execute code (beta)
- `computer_use` - Computer interaction (beta)
- MCP tools (when configured)

## Troubleshooting

### MCP Import Error
If you see `ModuleNotFoundError: No module named 'mcp'`:
```bash
pixi add mcp
pixi install
```

### CLI Not Found
If `claude-agent` command is not found:
```bash
pixi run pip install -e .
```

### API Key Issues
Make sure your API key is set:
```bash
echo $ANTHROPIC_API_KEY
```

## Project Structure

```
python/
├── claude_agent/          # Main package
│   ├── cli/              # CLI interface
│   ├── core/             # Core agent logic
│   ├── tools/            # Tool implementations
│   └── utils/            # Utilities
├── examples/             # Usage examples
├── tests/               # Test suite
├── setup.sh            # Setup script
├── claude-agent-wrapper # Wrapper script
├── pixi.toml           # Pixi configuration
└── pyproject.toml      # Python package configuration
```

## Support

- Check the main README.md for general information
- Look at examples/ directory for usage patterns
- Run `claude-agent --help` for CLI help
- Use `claude-agent tool-info <tool-name>` for tool-specific help 
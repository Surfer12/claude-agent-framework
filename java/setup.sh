#!/bin/bash

# Claude Agent Framework Setup Script
# This script builds the project and sets up all access methods

echo "🚀 Setting up Claude Agent Framework..."

# Build the project
echo "📦 Building project with Maven..."
mvn clean package -q

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed!"
    exit 1
fi

# Check if JAR was created
JAR_PATH="target/claude-agent-framework-1.0.0.jar"
if [ -f "$JAR_PATH" ]; then
    echo "✅ JAR file created: $JAR_PATH"
else
    echo "❌ JAR file not found!"
    exit 1
fi

# Make wrapper script executable (if not already)
chmod +x claude-agent

echo ""
echo "🎉 Setup complete! You can now run the Claude Agent Framework using:"
echo ""
echo "1. Maven exec plugin:"
echo "   mvn exec:java"
echo ""
echo "2. Shell alias (in new terminal sessions):"
echo "   claude-agent"
echo ""
echo "3. Wrapper script (local):"
echo "   ./claude-agent"
echo ""
echo "4. Wrapper script (global, after reloading shell):"
echo "   claude-agent  # (different from alias - this uses the script)"
echo ""
echo "5. Direct JAR execution:"
echo "   java -jar target/claude-agent-framework-1.0.0.jar -v interactive"
echo ""
echo "💡 To activate the PATH changes, run: source ~/.zshrc"

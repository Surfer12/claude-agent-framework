# Claude Agent Framework - Quick Start

## Setup
Run the setup script to build and prepare all access methods:
```bash
./setup.sh
```

## Access Methods

### 1. Maven Exec Plugin (Development)
Best for development - runs from source without building JAR:
```bash
mvn exec:java
```

### 2. Shell Alias
Quick access via alias (requires built JAR):
```bash
claude-agent
```

### 3. Wrapper Script (Local)
Flexible script with error checking:
```bash
./claude-agent                    # Default: -v interactive
./claude-agent --help            # Custom arguments
./claude-agent -v batch --input examples/sample.txt
```

### 4. Wrapper Script (Global)
After running `source ~/.zshrc`, you can use the script globally:
```bash
claude-agent  # (script version, not alias)
```

### 5. Direct JAR Execution
Traditional approach:
```bash
java -jar target/claude-agent-framework-1.0.0.jar -v interactive
```

## Notes
- The alias and wrapper script require the JAR to be built first
- Maven exec plugin runs directly from source code
- The wrapper script provides the most flexibility and error handling
- All methods default to `-v interactive` mode for convenience

## Troubleshooting
If any method fails:
1. Run `./setup.sh` to rebuild
2. Check that `target/claude-agent-framework-1.0.0.jar` exists
3. For shell features, run `source ~/.zshrc` to reload configuration

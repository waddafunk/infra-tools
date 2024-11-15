# 🗂️ Directory Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Efficient command-line utilities for various tasks I need for my local systems management.

## 🚀 Features

- **Remote Download** (`dlrem`): Securely download remote directories
- **Directory Flattening** (`flatdir`): Convert nested structures into flat directories
- **Direct Pattern Exclusion**: Git-style ignore patterns right in the command
- **Smart Conflict Resolution**: Automatic handling of filename conflicts
- **Command Completion**: Built-in bash completion

## 📦 Installation

```bash
git clone https://github.com/yourusername/directory-tools.git
cd directory-tools
chmod +x *.sh
sudo ./install.sh
```

## 🛠️ Usage

### Download Remote Directory

```bash
dlrem user@host:/remote/path local/path [ignore_patterns...]
```

### Flatten Directory

```bash
flatdir source/dir target/dir [ignore_patterns...]
```

## 📋 Examples

### Basic Usage

```bash
# Download excluding common patterns
dlrem dev@server:/var/www/project ./download .git/ node_modules/ *.log

# Flatten excluding temporary files
flatdir ./source ./flat *.tmp cache/ build/
```

### Multiple Ignore Patterns

```bash
# Download excluding various patterns
dlrem user@host:/project ./local \
    .git/ \
    node_modules/ \
    *.log \
    *.tmp \
    dist/

# Flatten with complex patterns
flatdir ./source ./flat \
    .git/ \
    *.o \
    *.class \
    target/ \
    build/
```

### Common Pattern Sets

```bash
# Web project
dlrem user@host:/web ./local \
    node_modules/ \
    .git/ \
    *.log \
    dist/ \
    .cache/

# Java project
flatdir ./java ./flat \
    target/ \
    .git/ \
    *.class \
    .idea/ \
    *.iml
```

## ⚙️ Pattern Syntax

- `dir/`: Ignore directory and its contents
- `*.ext`: Ignore files by extension
- `filename`: Ignore specific file/directory
- Multiple patterns can be specified sequentially

## 🚨 Troubleshooting

1. **File Conflicts**: Handled automatically with numbered suffixes
   ```
   example.txt → example.txt
   example.txt → example_1.txt
   ```

2. **Pattern Quoting**: Use quotes for patterns with special characters
   ```bash
   dlrem user@host:/path local "*.{jpg,png}" "test*/"
   ```

## 📜 License

MIT License - see [LICENSE](LICENSE)
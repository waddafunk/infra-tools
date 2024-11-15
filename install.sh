#!/bin/bash
# install.sh - Installs directory management tools system-wide

# Default installation directory
DEFAULT_INSTALL_DIR="/usr/local/bin"
DEFAULT_COMPLETION_DIR="/etc/bash_completion.d"

# Check if running with sudo/root
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo privileges"
    exit 1
fi

# Create installation directory if it doesn't exist
mkdir -p "$DEFAULT_INSTALL_DIR"
mkdir -p "$DEFAULT_COMPLETION_DIR"

# Copy executables with concise names
cp download_remote.sh "$DEFAULT_INSTALL_DIR/dlrem"
cp flatten_directory.sh "$DEFAULT_INSTALL_DIR/flatdir"

# Make executable
chmod +x "$DEFAULT_INSTALL_DIR/dlrem"
chmod +x "$DEFAULT_INSTALL_DIR/flatdir"

# Create bash completion script
cat > "$DEFAULT_COMPLETION_DIR/dirtools-completion" << 'EOF'
_dlrem()
{
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Complete local paths
    if [[ ${cur} == /* ]] || [[ ${cur} == ./* ]] || [[ ${cur} == ~/* ]] || [[ ${cur} == "" ]]; then
        COMPREPLY=( $(compgen -f -- "${cur}") )
        return 0
    fi

    # Complete remote hosts from known_hosts
    if [[ ${cur} == *@* ]]; then
        local hosts=$(grep -h "^Host " ~/.ssh/config 2>/dev/null | cut -d ' ' -f 2-)
        COMPREPLY=( $(compgen -W "${hosts}" -- "${cur}") )
        return 0
    fi
}

_flatdir()
{
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Complete local paths
    COMPREPLY=( $(compgen -f -- "${cur}") )
    return 0
}

complete -F _dlrem dlrem
complete -F _flatdir flatdir
EOF

# Make completion script executable
chmod +x "$DEFAULT_COMPLETION_DIR/dirtools-completion"

# Source completion script
echo "# Directory Tools completion" >> /etc/bash.bashrc
echo "source $DEFAULT_COMPLETION_DIR/dirtools-completion" >> /etc/bash.bashrc

echo "Installation completed successfully!"
echo "You can now use 'dlrem' and 'flatdir' commands from anywhere."
echo "Please restart your shell or run 'source $DEFAULT_COMPLETION_DIR/dirtools-completion' to enable command completion."
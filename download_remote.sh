#!/bin/bash
# dlrem - Downloads files from remote directory
if [ "$#" -lt 2 ]; then
    echo "Usage: dlrem user@host:/remote/path local/path [ignore_patterns...]"
    echo "Example: dlrem user@host:/project ./local .git/ *.log node_modules/"
    exit 1
fi

REMOTE_USER_HOST=$1
REMOTE_PATH=$2
LOCAL_PATH=$3
shift 3  # Remove first three arguments

# Build exclude options for rsync from remaining arguments
EXCLUDE_OPTS=""
for pattern in "$@"; do
    EXCLUDE_OPTS="$EXCLUDE_OPTS --exclude='$pattern'"
done

# Ensure local directory exists
mkdir -p "$LOCAL_PATH"

# Use eval to properly handle the exclude options
eval rsync -av --progress $EXCLUDE_OPTS "\"${REMOTE_USER_HOST}:${REMOTE_PATH}/\"" "\"$LOCAL_PATH\""

echo "Download completed to $LOCAL_PATH"
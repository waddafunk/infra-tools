
#!/bin/bash
# flatdir - Flattens directory structure
if [ "$#" -lt 2 ]; then
    echo "Usage: flatdir source_dir target_dir [ignore_patterns...]"
    echo "Example: flatdir ./source ./flat .git/ *.log node_modules/"
    exit 1
fi

SOURCE_DIR=$1
TARGET_DIR=$2
shift 2  # Remove first two arguments

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Build find command with ignore patterns from remaining arguments
FIND_CMD="find \"$SOURCE_DIR\" -type f"
for pattern in "$@"; do
    # Convert glob pattern to find-compatible pattern
    if [[ $pattern == *"*"* ]]; then
        # Handle glob patterns
        FIND_CMD="$FIND_CMD ! -path \"$SOURCE_DIR/*$(echo $pattern | sed 's/\*/.*/g')\""
    else
        # Handle exact matches and directories
        FIND_CMD="$FIND_CMD ! -path \"$SOURCE_DIR/$pattern*\""
    fi
done

# Process files
eval "$FIND_CMD" | while read -r file; do
    # Generate unique name if file already exists
    filename=$(basename "$file")
    base="${filename%.*}"
    ext="${filename##*.}"
    counter=1
    target_file="$TARGET_DIR/$filename"
    
    while [ -f "$target_file" ]; do
        if [ "$ext" = "$filename" ]; then
            target_file="$TARGET_DIR/${base}_$counter"
        else
            target_file="$TARGET_DIR/${base}_$counter.$ext"
        fi
        ((counter++))
    done
    
    cp "$file" "$target_file"
    echo "Copied: $file → $target_file"
done

echo "Directory flattening completed in $TARGET_DIR"
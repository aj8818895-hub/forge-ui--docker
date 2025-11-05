#!/usr/bin/env bash
set -euo pipefail

echo "===== container start: $(date) ====="

WORKDIR="/workspace"
mkdir -p "$WORKDIR/models"
mkdir -p "$WORKDIR/logs"

# If extensions.txt exists, try to install each line.
EXT_FILE="$WORKDIR/extensions.txt"
if [ -f "$EXT_FILE" ]; then
  echo "Installing extensions from $EXT_FILE..."
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%#*}"   # remove trailing comments
    line="$(echo -n "$line" | xargs)" # trim whitespace
    if [ -z "$line" ]; then
      continue
    fi
    echo " -> Installing: $line"
    # If it's a git URL, pip can install it directly. If it's a package, pip installs it.
    pip install --no-cache-dir "$line" || {
      echo "Failed to pip install $line; continuing..."
    }
  done < "$EXT_FILE"
else
  echo "No $EXT_FILE found; skipping extension installs."
fi

# Show GPU availability (if any)
echo "Checking GPU (nvidia-smi)..."
nvidia-smi || echo "nvidia-smi not available (no GPU or driver)"

# Start the app
echo "Starting app.py ..."
python /workspace/app.py

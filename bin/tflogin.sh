#!/bin/bash

# Define target directory and file
TARGET_DIR="$HOME/.terraform.d"
TF_CLI_CONFIG_FILE="$TARGET_DIR/credentials.tfrc.json"

if [ -z "$TF_TOKEN" ]; then
  echo "Error: $TF_TOKEN environment variable is not set"
  exit 1
fi

# Check if directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "${TARGET_DIR} has been created."
fi

cat <<EOF > "$TF_CLI_CONFIG_FILE"
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TF_TOKEN"
    }
  }
}
EOF

echo "${TF_CLI_CONFIG_FILE} has been created."
#!/bin/bash

#if [ -z "$TF_CLI_CONFIG_FILE" ]; then
#  echo "Error: TF_CLI_CONFIG_FILE environment variable is not set"
#  exit 1
#fi

cat <<EOF > "$TF_CLI_CONFIG_FILE"
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TF_TOKEN"
    }
  }
}
EOF
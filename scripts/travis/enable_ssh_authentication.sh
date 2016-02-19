#!/bin/bash

cd "$(dirname "$BASH_SOURCE")"

declare -r PRIVATE_KEY_FILE_NAME='github_deploy_key'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Decrypt the file containing the private key

openssl aes-256-cbc \
    -K $encrypted_18a7d42f6a87_key \
    -iv $encrypted_18a7d42f6a87_iv \
    -in "${PRIVATE_KEY_FILE_NAME}.enc" \
    -out ~/.ssh/$PRIVATE_KEY_FILE_NAME -d

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Enable SSH authentication

chmod 600 ~/.ssh/$PRIVATE_KEY_FILE_NAME
printf '%s\n' \
    "Host github.com" \
    "  IdentityFile ~/.ssh/$PRIVATE_KEY_FILE_NAME" \
    "  LogLevel ERROR" >> ~/.ssh/config

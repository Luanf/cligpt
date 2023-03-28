#!/bin/bash

if [[ -n "$BASH_VERSION" ]]; then
  cat cligpt.zsh >> ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
  cat cligpt.zsh >> ~/.zshrc
else
  echo "Install unsuccessful. Shell is not supported."
  return 1
fi

echo "Installed. Reload your shell to use cligpt, and make sure you have the OPENAI_API_KEY environment variable set."

#!/bin/bash

# Check for the --shell argument
shell=""
if [ "$1" == "--shell" ] && [ ! -z "$2" ]; then
  if [[ "$2" =~ ^(bash|zsh)$ ]]; then
    shell="$2"
  else
    echo "Invalid shell option. Supported shells: bash, zsh."
    exit 1
  fi
fi

# Determine the default shell if not provided
if [ -z "$shell" ]; then
  if [ ! -z "$BASH_VERSION" ]; then
    shell="bash"
  elif [ ! -z "$ZSH_VERSION" ]; then
    shell="zsh"
  else
    echo "Unable to determine the default shell. Please use the --shell option."
    exit 1
  fi
fi

# Determine the shell-specific installation steps
if [ "$shell" == "bash" ]; then
  rc_file="${HOME}/.bashrc"
  function_path="${HOME}/.bash/cligpt.sh"
elif [ "$shell" == "zsh" ]; then
  rc_file="${HOME}/.zshrc"
  function_path="${HOME}/.zsh/cligpt.sh"
else
  echo "Unsupported shell."
  exit 1
fi

# Create the function directory and copy the function
mkdir -p "$(dirname "$function_path")"
cp cligpt.sh "$function_path"

# Add the source command to the appropriate rc file, if not already present
source_command="source $function_path"
if ! grep -qxF "$source_command" "$rc_file"; then
  echo "$source_command" >> "$rc_file"
else
  echo "Previous installation detected, reinstalling."
fi

echo "Installation successful for $shell."

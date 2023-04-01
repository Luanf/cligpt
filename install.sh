#!/bin/bash

INSTALLER=$(realpath "$0")
CLIGPT=$(dirname "$INSTALLER")/cligpt
chmod +x $CLIGPT 

CLIGPT_TARGET_DIR=$HOME/.local/bin
mkdir -p $CLIGPT_TARGET_DIR && \
ln -sf $CLIGPT $CLIGPT_TARGET_DIR && \
{
  echo "CliGPT installed successfully at $CLIGPT_TARGET_DIR/cligpt. You can now run it by typing cligpt in your terminal."
  echo "If the command is not found, you may need to add $CLIGPT_TARGET_DIR to your PATH environment variable."
  echo "Also, make sure that you have the env variable OPENAI_API_KEY set to use the application."
}

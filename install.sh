#!/bin/bash

# Append the cligpt definition to the user's .zshrc file
cat cligpt.sg >> ~/.zshrc

echo "Installed. Reload your shell to use cligpt, and make sure you have the OPENAI_API_KEY environment variable set."

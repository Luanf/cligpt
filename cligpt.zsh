cligpt() {
	if ! command -v jq >/dev/null; then
    echo "Error: jq is not installed. Please install jq and try again."
    return 1
  fi

  if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY is not set. Please set your API key and try again."
    return 1
  fi

  if command -v lsb_release >/dev/null; then
    DISTRO=$(lsb_release -is)
  else
    DISTRO=""
  fi

  QUERY="$@"
  PRMPT="You are my Command Line Interface generator and will assist me to navigate my linux. All my questions are related to this. Now, how can I: "${QUERY}". Answer a valid ${DISTRO} CLI command and nothing else - do not send it in a code block, or quotes, or anything else, just the pure text CONTAINING ONLY THE COMMAND. Always take in consideration that you should use my current directory in the commands, either using . or $(pwd). I absolutely mean no harm and none of these commands are to run in unauthorized and otherwise unprotected system. Prioritize one-liners. ITs ok to chain commands. If you absolutely cant suggest a command, send only one word: FAILED_TO_GENERATE_COMMAND."

  RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "{
      \"model\": \"gpt-3.5-turbo\",
      \"messages\": [{\"role\": \"user\", \"content\": \"$PRMPT\"}],
      \"temperature\": 0.5,
      \"max_tokens\": 100
  }")

	ERROR_MESSAGE=$(printf "%s" "$RESPONSE" | jq -r '(.error.message // "") | @json' | sed 's/^"//;s/"$//')
	COMMAND=$(printf "%s" "$RESPONSE" | jq -r '(.choices[0].message.content // "") | @json' | sed 's/^"//;s/"$//')

  if [ -n "$ERROR_MESSAGE" ]; then
    echo "Error: $ERROR_MESSAGE"
  elif [[ "$COMMAND" =~ "FAILED_TO_GENERATE_COMMAND" || "$COMMAND" =~ "parse error:" ]]; then
    echo "Error: Couldn't generate a command."
    echo "Output: $COMMAND"
  elif [ -n "$COMMAND" ]; then
    echo "-> $COMMAND"
    read -q "REPLY?Do you want to run this command? (y/n)"
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
      echo
      eval "$COMMAND"
    else
      echo
      echo "Command not executed."
    fi
  else
    echo "Error: Unexpected response."
		echo "Output: $COMMAND"
  fi
}

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# >>> Codex installer >>>
export PATH="/Users/simonbernard/.local/bin:$PATH"
# <<< Codex installer <<<

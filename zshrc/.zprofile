# Initialize Homebrew before the interactive shell loads its tools and plugins.
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Keep user executables available without duplicating entries in nested shells.
typeset -U path
path=("$HOME/.local/bin" "$HOME/.rbenv/bin" $path)
export PATH

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

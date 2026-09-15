eval "$(jump shell)"
export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)
source $ZSH/oh-my-zsh.sh

## JAVA & ANDROID
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# CODEX editor setting 
export EDITOR="nvim"

# Aliases
alias lz="lazygit"
alias xcode="open -a xcode"

# Custom agent CLIs 
codex-afk() {
  codex \
    --sandbox workspace-write \
    --ask-for-approval on-request \
    -c 'approvals_reviewer="auto_review"' \
    "$@"
}


codex-n8n() {
  codex \
    --profile n8n \
    --sandbox workspace-write \
    --ask-for-approval on-request \
    -c 'approvals_reviewer="auto_review"' \
    "$@"
}

pi-n8n() {
  pi \
    --mcp-config "$HOME/.pi/mcp/n8n.json" \
    "$@"
}


# Conv check on disk sizes in current dir
stored-sizes() {
  local entry size 
  for entry in * .*; do 
    [[ "$entry" == "." || "$entry" == ".." ]] && continue
    [[ -e "$entry" ]] || continue

    size=$(du -sh -- "$entry" | cut -f1)
    printf '%s\t%s\n' "$size" "$entry"
  done
}

# Nuke xcode build/dep caches 
# Usage:  xcclean        -> derived data + spm caches
#         xcclean --sims -> also erase all simulators 
xcclean() {
  emulate -L zsh 
  setopt local_options no_unset

  if pgrep -xq Xcode; then 
    print -u2 "XCode is running. Quit it first, then re-run. Aborting"
    return 1
  fi

  local -a targets=(
    "$HOME/Library/Developer/Xcode/DerivedData"
    "$HOME/Library/Caches/org.swift.swiftpm"
    "$HOME/Library/org.swift.swiftpm"
  )

  print "Cleaning Xcode caches"

  local t 
  for t in $targets; do 
    if [[ -e $t ]]; then 
      local size=$(du -sh "$t" 2>/dev/null | cut -f1)
      print " - removing $t (${size:-?})"
      rm -rf -- "$t"/
    fi
  done

  if [[ "$1" == "--sims" ]]; then 
    print " - erasing all simulators"
    xcrun simctl shutdown all 2>/dev/null
    xcrun simctl erase all
  fi

  print "Done. Next build will be slow (re-resolving packages + reindexing)"
}


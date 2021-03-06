# Setup fzf
# ---------
if [[ $(uname -p) != 'arm' ]]; then
    if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
      export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
    fi
# Auto-completion
# ---------------
   [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
   source "/usr/local/opt/fzf/shell/key-bindings.zsh"
fi

# Setup fzf
# ---------
if [[ $(uname -p) == 'arm' ]]; then
  if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
  fi

# Auto-completion
# ---------------
  [[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
fi

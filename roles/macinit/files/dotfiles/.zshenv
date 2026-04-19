# Template zshenv file

alias ll='ls -lah'
alias gs='git status'

if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi

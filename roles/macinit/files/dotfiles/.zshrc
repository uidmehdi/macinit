# ──────────────────────────────────────────────────────────────────────────────
# Instant prompt (must be very first)
# ──────────────────────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Basic environment
# ──────────────────────────────────────────────────────────────────────────────
export TERM=xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export HOMEBREW_CASK_OPTS='--no-quarantine'

# ──────────────────────────────────────────────────────────────────────────────
# PATH (consolidated & Homebrew-first)
# ──────────────────────────────────────────────────────────────────────────────
typeset -U PATH path
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/bin/scripts"
  /usr/local/sbin
  /usr/local/bin
  /usr/sbin
  /usr/bin
  /sbin
  /bin
  $path
  # Add more tool-specific paths only if needed
)

export PATH

# ──────────────────────────────────────────────────────────────────────────────
# Oh My Zsh
# ──────────────────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"

ZSH_TMUX_AUTOCONNECT='false'

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

plugins=(
  git
  history
  tmux
  zsh-autosuggestions
  kubectl
  kube-ps1
  brew
  docker
  nvm
  autoupdate
)

command -v brew >/dev/null && plugins+=(brew)
command -v tmux >/dev/null && plugins+=(tmux)

# ──────────────────────────────────────────────────────────────────────────────
# Completion paths (must be set before Oh My Zsh runs compinit)
# ──────────────────────────────────────────────────────────────────────────────
typeset -U fpath
if command -v brew >/dev/null; then
  brew_zsh_completions="$(brew --prefix)/share/zsh-completions"
  [[ -d "$brew_zsh_completions" ]] && fpath=("$brew_zsh_completions" $fpath)
  unset brew_zsh_completions
fi

# ──────────────────────────────────────────────────────────────────────────────
# Load Oh My Zsh *before* heavy customizations
# ──────────────────────────────────────────────────────────────────────────────
source "$ZSH/oh-my-zsh.sh"

# ──────────────────────────────────────────────────────────────────────────────
# Powerlevel10k
# ──────────────────────────────────────────────────────────────────────────────
if [[ -d "$(brew --prefix)/share/powerlevel10k" ]]; then
  source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Cache completions for better performance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"

# Color completion entries using LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Prioritize hosts over files for scp/rsync
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'

# Filter out localhost and broadcast hosts from ssh/scp/rsync completion
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost

# Filter out invalid and local IP addresses from ssh/scp/rsync completion
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Enable case-insensitive and fuzzy completion matching
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# Allow Docker option stacking (e.g., -it instead of -i -t)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Enable interactive menu selection for completions
zstyle ':completion:*' menu select

# Group completions by type with descriptive headers
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# Highlight process IDs in red for kill command completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# ──────────────────────────────────────────────────────────────────────────────
# Tool completions loaded late (after compinit)
# ──────────────────────────────────────────────────────────────────────────────

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Flux completion (only if installed)
command -v flux >/dev/null && . <(flux completion zsh)

# Stern completion (only if installed)
command -v stern >/dev/null && source <(stern --completion=zsh)

# kubectl krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
path+="$PNPM_HOME"
export PATH

# NVM – lazy loading using oh-my-zsh plugin
export NVM_DIR="$HOME/.nvm"
zstyle ':omz:plugins:nvm' lazy yes

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
if command -v jenv >/dev/null; then
  eval "$(jenv init -)"
fi

# ──────────────────────────────────────────────────────────────────────────────
# syntax highlighting (must come AFTER compinit & most plugins)
# ──────────────────────────────────────────────────────────────────────────────
# Install with: brew install zsh-syntax-highlighting
if [[ -r "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Custom aliases last
source ~/.aliases

# Local overrides last (e.g., CIDR variable for ssh completion)
CIDR="10.110.0.0/16 10.100.0.0/16 10.200.0.0/16"

#eval "$(direnv hook zsh)"

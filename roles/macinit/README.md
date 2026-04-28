macinit
=======

Ansible role to bootstrap macOS (Apple Silicon) with Homebrew packages, casks, uv-managed Python tools, and dotfiles for a DevOps/SRE workstation.

Requirements
------------

- macOS on Apple Silicon (M-series)
- `community.general` collection (`ansible-galaxy collection install -r requirements.yml`)
- Xcode Command Line Tools (`xcode-select --install`)

Role Variables
--------------

All variables have defaults in `defaults/main.yml`. Package lists are defined in `group_vars/all/vars.yml` at the playbook level.

| Variable | Default | Description |
|---|---|---|
| `brew_prefix` | `/opt/homebrew` | Homebrew prefix path |
| `brew_bin_path` | `{{ brew_prefix }}/bin` | Homebrew bin directory |
| `homebrew_tap` | `[]` | List of taps to add |
| `homebrew` | `[]` | List of formulae to install (packages not in this list are removed). Use fully qualified names like `fluxcd/tap/flux` when a tapped formula conflicts with a core formula. |
| `homebrew_cask` | `[]` | List of casks to install (casks not in this list are removed) |
| `homebrew_upgrade_all` | `true` | Upgrade all formulae and casks on each run. Set to `false` to skip upgrades. |
| `homebrew_cask_sudo_keepalive` | `true` | Keep the sudo timestamp warm during cask operations to avoid repeated installer prompts |
| `homebrew_cask_sudo_keepalive_interval` | `60` | Seconds between sudo timestamp refreshes during cask operations |
| `homebrew_cask_temporary_passwordless_sudo` | `false` | Temporarily create a sudoers drop-in for the cask phase only, then remove it |
| `uv_tools` | `[]` | Python CLI tools to install via `uv tool install --upgrade` |
| `do_customize` | `true` | Copy dotfiles and clone Git repos |
| `vim_plugins_dir` | `~/.vim/pack/plugins` | Vim plugins directory |
| `vim_colors_dir` | `~/.vim/pack/colors` | Vim color schemes directory |
| `omz_plugins_dir` | `~/.oh-my-zsh/custom/plugins` | Oh My Zsh custom plugins directory |
| `vim_plugins` | see defaults | List of `{name, url}` Vim plugins to clone |
| `vim_color_schemes` | see defaults | List of `{name, url}` Vim color schemes to clone |
| `tmux_repo` | gpakosz/.tmux | tmux config repo URL |
| `zsh_plugins` | see defaults | List of `{name, url}` Oh My Zsh plugins to clone |

Tasks
-----

| Task file | Description |
|---|---|
| `main.yml` | Entry point; fails on non-macOS platforms |
| `Darwin.yml` | Orchestrates homebrew → packages → dotfiles → cleanup |
| `homebrew.yml` | Installs Homebrew if not already present |
| `packages.yml` | Taps, formulae, casks, uv tool installs and upgrades; removes packages not in the desired list |
| `dotfiles.yml` | Configures passwordless sudo, installs oh-my-zsh, clones Vim plugins/colors, tmux and zsh plugins, copies dotfiles |
| `cleanup.yml` | `brew autoremove`, `brew cleanup`, and `brew doctor` |

Dotfiles managed
----------------

| File | Description |
|---|---|
| `.zshrc` | Zsh configuration (Oh My Zsh + Powerlevel10k) |
| `.zshenv` | Environment variables; sources `.zshenv.local` for machine-specific overrides |
| `.aliases` | Shell aliases; sources `.aliases.local` for machine-specific aliases |
| `.p10k.zsh` | Powerlevel10k prompt configuration |
| `.vimrc` | Vim configuration |
| `.fzf.zsh` | fzf shell integration (zsh) |
| `.fzf.bash` | fzf shell integration (bash) |
| `.tmux.conf.local` | tmux local overrides for gpakosz/.tmux |
| `.iTerm2/` | iTerm2 dynamic profile |

Example Playbook
----------------

```yaml
- hosts: all
  roles:
    - role: macinit
```

Override package lists inline (or via `group_vars`):

```yaml
- hosts: all
  roles:
    - role: macinit
      vars:
        do_customize: false
        homebrew:
          - git
          - vim
        homebrew_cask:
          - visual-studio-code
```

License
-------

MIT

Author
------

Mehdi Hassanpour

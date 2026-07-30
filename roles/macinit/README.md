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
| `macinit_brew_prefix` | `/opt/homebrew` | Homebrew prefix path |
| `macinit_brew_bin_path` | `{{ macinit_brew_prefix }}/bin` | Homebrew bin directory |
| `macinit_homebrew_tap` | `[]` | List of taps to add |
| `macinit_homebrew` | `[]` | List of formulae to install (packages not in this list are removed). Use fully qualified names like `fluxcd/tap/flux` when a tapped formula conflicts with a core formula. |
| `macinit_homebrew_cask` | `[]` | List of casks to install (casks not in this list are removed) |
| `macinit_homebrew_upgrade_all` | `true` | Upgrade all formulae and casks on each run. Set to `false` to skip upgrades. |
| `macinit_homebrew_cask_sudo_keepalive` | `true` | Keep the sudo timestamp warm during cask operations to avoid repeated installer prompts |
| `macinit_homebrew_cask_sudo_keepalive_interval` | `60` | Seconds between sudo timestamp refreshes during cask operations |
| `macinit_homebrew_cask_temporary_passwordless_sudo` | `false` | Temporarily create a sudoers drop-in for the cask phase only, then remove it |
| `macinit_uv_tools` | `[]` | Python CLI tools to install via `uv tool install --upgrade` |
| `macinit_do_customize` | `true` | Copy dotfiles and clone Git repos |
| `macinit_zsh_fix_compinit_permissions` | `true` | Remove group/world write permissions from zsh completion directories and clear `.zcompdump` |
| `macinit_zsh_compinit_permission_dirs` | `{{ macinit_brew_prefix }}/share/zsh` | Directories to secure for zsh `compinit` |
| `macinit_vim_plugins_dir` | `~/.vim/pack/plugins` | Vim plugins directory |
| `macinit_vim_colors_dir` | `~/.vim/pack/colors` | Vim color schemes directory |
| `macinit_omz_plugins_dir` | `~/.oh-my-zsh/custom/plugins` | Oh My Zsh custom plugins directory |
| `macinit_vim_plugins` | see defaults | List of `{name, url, version}` Vim plugins to clone |
| `macinit_vim_color_schemes` | see defaults | List of `{name, url, version}` Vim color schemes to clone |
| `macinit_tmux_repo` | gpakosz/.tmux | tmux config repo URL |
| `macinit_tmux_repo_version` | `master` | tmux config repo branch/tag/commit to check out |
| `macinit_zsh_plugins` | see defaults | List of `{name, url, version}` Oh My Zsh plugins to clone |

Tasks
-----

| Task file | Description |
|---|---|
| `main.yml` | Entry point; fails on non-macOS platforms |
| `Darwin.yml` | Orchestrates homebrew → packages → dotfiles → cleanup |
| `homebrew.yml` | Installs Homebrew if not already present |
| `packages.yml` | Taps, formulae, casks, uv tool installs and upgrades; removes packages not in the desired list |
| `dotfiles.yml` | Configures passwordless sudo, installs oh-my-zsh, clones Vim plugins/colors, tmux and zsh plugins, copies dotfiles |
| `zsh.yml` | Secures zsh completion directories to avoid `compinit: insecure directories` warnings |
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
        macinit_do_customize: false
        macinit_homebrew:
          - git
          - vim
        macinit_homebrew_cask:
          - visual-studio-code
```

License
-------

MIT

Author
------

Mehdi Hassanpour

Bootstrap macOS with Ansible
=========

An Ansible role to fully bootstrap macOS (Apple Silicon) for a DevOps/SRE workstation — from a bare machine to a fully configured environment.

**What gets automated:**
- Homebrew installation
- Homebrew taps, formulae, and casks
- Python tools via uv
- oh-my-zsh installation
- Vim plugins and color schemes
- tmux and zsh plugins
- Dotfiles deployment

## Requirements

Only one manual step is needed before running the playbook:

1. Install Ansible:

   ```bash
   pip3 install --user ansible
   ```

   Then add the pip user bin to your PATH (required to find `ansible-playbook`):

   ```bash
   export PATH="$HOME/Library/Python/$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')/bin:$PATH"
   ```

   Or bootstrap via the system Python if Homebrew is not yet present.

2. Install required Ansible collections:

   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

> Homebrew, oh-my-zsh, and all packages are installed automatically by the playbook.

## Usage

> **Before running:** The file [group_vars/all/vars.yml](group_vars/all/vars.yml) includes a comprehensive, opinionated selection of Homebrew formulae and casks designed for a personal DevOps/SRE workstation. Make sure to review and adjust the lists to match your needs before executing the playbook — it will strictly enforce this configuration and remove anything not explicitly defined.

Run the playbook (installs all packages, skips dotfiles):

```bash
ansible-playbook playbook.yml -K
```

> `-K` prompts for your sudo password. On first run it is required to install Homebrew and to write the passwordless sudoers entry (when `do_customize=true`). After that first full run, sudo is passwordless and `-K` is no longer needed.

Run with dotfile deployment (existing files are backed up in-place):

```bash
ansible-playbook playbook.yml -K -e "do_customize=true"
```

> This also configures passwordless sudo for your user (`/etc/sudoers.d/<user>`). Subsequent runs do not need `-K`.

## Customisation

Edit [group_vars/all/vars.yml](group_vars/all/vars.yml) to manage package lists:

| Variable | Description |
|---|---|
| `homebrew_tap` | Homebrew taps to add |
| `homebrew` | Homebrew formulae to install (packages not in this list are removed). Use fully qualified names like `fluxcd/tap/flux` when a tapped formula conflicts with a core formula. |
| `homebrew_prune_enabled` | Remove packages not listed in `homebrew`/`homebrew_cask` (formulae and casks). Default is CI-aware: enabled in CI (`CI=true`), disabled for local runs unless explicitly set to `true`. |
| `homebrew_cask` | Homebrew casks to install (casks not in this list are removed) |
| `uv_tools` | Python CLI tools to install via `uv tool install --upgrade` |
| `homebrew_upgrade_all` | Upgrade all formulae and casks on each run (default: `true`). Set to `false` to skip upgrades. |
| `homebrew_cask_sudo_keepalive` | Keep the sudo timestamp warm during cask operations to avoid repeated installer prompts (default: `true`). |
| `homebrew_cask_temporary_passwordless_sudo` | Temporarily create a sudoers drop-in for the cask phase only, then remove it. Use this if keepalive is not enough for long or stubborn cask installers (default: `false`). |
| `zsh_fix_compinit_permissions` | Remove group/world write permissions from zsh completion directories and clear `.zcompdump` to avoid `compinit: insecure directories` warnings (default: `true`). |

## Project structure

```
.
├── ansible.cfg               # Project-level Ansible config
├── requirements.yml          # Ansible collection dependencies
├── inventory                 # Local inventory (localhost)
├── playbook.yml              # Entry point
├── group_vars/
│   └── all/
│       └── vars.yml          # Package lists and defaults
└── roles/
    └── macinit/
        ├── defaults/main.yml # Role defaults
        ├── tasks/
        │   ├── main.yml        # OS guard
        │   ├── Darwin.yml      # Orchestrator
        │   ├── homebrew.yml    # Homebrew install
        │   ├── packages.yml    # Formulae, casks, uv tools
        │   ├── dotfiles.yml    # oh-my-zsh, plugins, dotfiles
        │   ├── zsh.yml         # zsh completion permission fixes
        │   └── cleanup.yml     # brew cleanup & doctor
        └── files/
            └── dotfiles/       # Dotfiles copied to ~/
```

## Testing

Install test dependencies:

```bash
make install-deps
```

| Command | What it does |
|---|---|
| `make lint` | yamllint + ansible-lint |
| `make test` | Full Molecule run (packages + dotfiles) |
| `make test-packages` | Packages-only scenario |
| `make test-dotfiles` | Dotfiles-only scenario |
| `make test-full` | lint + full Molecule run |

CI runs automatically on push/PR via GitHub Actions (lint on Ubuntu, Molecule scenarios on `macos-latest`).

## Troubleshooting

- Run `brew doctor` to diagnose Homebrew issues.
- If you see "zsh compinit: insecure directories" warnings, run the playbook again. The role removes group/world write permissions from Homebrew zsh completion directories by default.
- Force-rebuild zsh completions cache:
  ```bash
  rm -f ~/.zcompdump; compinit
  ```

## License

MIT

## Author

Mehdi Hassanpour

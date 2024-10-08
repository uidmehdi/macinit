Bootstrap macOS with Ansible
=========

An ansible approach to automate macOS initial setup for mainly DevOps/SRE toolsets.

## Requirements

  1. Install Homebrew using the following command or follow the instructions on [Homebrew's official website](https://brew.sh/).

     1. Run the following command
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
> Note: Homebrew will install Apple's command line tool as part of the installation. To check this, after successful installation, run `xcode-select -p` or install again `xcode-select --install`.

  2. Install Ansible using Homebrew or pip.

     1. Install Ansible using Homebrew `brew install ansible`.

     2. Install Ansible using pip. Follow the [installation instruction](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-macos)

  3. Install Rosetta 2, in case you've got a new Apple Silicon (M1) Mac with following command.
  
```
sudo softwareupdate --install-rosetta --agree-to-license
```

## Instalation

Install oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Run the ansible playbook without customization keeping your existing dotfiles un-changed:
```
ansible-playbook -i inventory playbook.yml -e "do_customize=no"
```

OR, if you want all customizations and existing dotfiles to be overriten: (there will be a backup of the changed file in the same folder)
```
ansible-playbook -i inventory playbook.yml
```

## zsh-completions

To activate these completions, add the following to your .zshrc:

```  
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi
```
You may also need to force rebuild `zcompdump`:

```  
rm -f ~/.zcompdump; compinit
```
Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
to load these completions, you may need to run this:

```  
chmod -R go-w '/opt/homebrew/share/zsh'
```

## Troubleshooting

In case of issues with Homebrew packages, run `brew doctor`.

License
-------

BSD

Author Information
------------------

Mehdi Hassanpour

Bootstrap macOS with Ansible
=========

An ansible approach to automate macOS initial setup for mainly DevOps/SRE toolsets.

## Requirements

  1. Install Homebrew using the following command or follow the instructions on [Homebrew's official website](https://brew.sh/).

     1. Run the following command`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

> Note: Homebrew will install Apple's command line tool as part of the installation. To check this, after successful installation, run `xcode-select -p` or install again `xcode-select --install`.

  2. Install Ansible using Homebrew or pip.

     1. Install Ansible using Homebrew `brew install ansible`.

     2. Install Ansible using pip. Follow the [installation instruction](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-macos)

  3. Install Rosetta 2, in case you've got a new Apple Silicon (M1) Mac with following command.
  
  `sudo softwareupdate --install-rosetta --agree-to-license`

## Instalation

Run the ansible playbook.
`ansible-playbook -i inventory playbook.yml`

Install oh-my-zsh
`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

## Troubleshooting

In case of issues with Homebrew packages, run `brew doctor`.

License
-------

BSD

Author Information
------------------

Mehdi Hassanpour

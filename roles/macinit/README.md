Bootstrap macOS with Ansible
=========

An ansible approach to automate macOS initial setup for mainly DevOps/SRE toolsets.

Requirements
------------

Install Homebrew using the following command or follow the instructions on [Homebrew's official website](https://brew.sh/).

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

> Note: Homebrew will install Apple's command line tool as part of the installation. To check this, after successful installation, run `xcode-select -p` or install again `xcode-select --install`.


Role Variables
--------------

Settable variables for this role should be found in defaults/main.yml, and all packages to be installed are set in vars/main.yml.


Example Playbook
----------------

```yaml
- hosts: localhost
  roles:
    - macinit
  vars:
    homebrew:
      - ansible
      - git
      - pipx
    homebrew_cask:
      - docker
      - visual-studio-code
```

License
-------

BSD

Author Information
------------------

Mehdi Hassanpour

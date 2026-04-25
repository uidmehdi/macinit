.PHONY: lint test test-dotfiles test-packages test-full install-deps help

ANSIBLE_LINT := ansible-lint
YAMLLINT     := yamllint
MOLECULE     := molecule

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install-deps: ## Install test dependencies via uv
	uv tool install ansible-lint
	uv tool install yamllint
	pip install molecule
	ansible-galaxy collection install -r requirements.yml

lint: ## Run yamllint and ansible-lint
	$(YAMLLINT) .
	$(ANSIBLE_LINT) .

test: ## Run Molecule default scenario (lint + full role)
	$(MOLECULE) test

test-dotfiles: ## Run Molecule dotfiles-only scenario
	$(MOLECULE) test -s dotfiles

test-packages: ## Run Molecule packages-only scenario
	$(MOLECULE) test -s packages

test-full: lint test ## Run lint then full Molecule test

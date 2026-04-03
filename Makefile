# Makefile for setting up environment
#################### Read Environment
RUNTIME_FILE := ./config/runtime/runtime.env
PYTHON_FILE  := ./config/runtime/python.env
include $(RUNTIME_FILE)
include $(PYTHON_FILE)

export PACKAGE_INSTALL_NAME

#################### Makefile Configuration
GIT_ROOT ?= $(shell git rev-parse --show-toplevel)
# e.g., Darwin for MacOS
PLATFORM_TYPE = $(shell uname)
# dynamically detect shell type as bash or zsh
ifeq ($(shell basename $(SHELL)), zsh)
        SHELL := zsh
		SHELL_CONFIG := $(HOME)/.zshrc
else
        SHELL := bash
		SHELL_CONFIG := $(HOME)/.bashrc
endif

#################### Makefile Context
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := info

.PHONY: help info info_dotfiles
help:
	@echo "Commands  : "
	@echo "download  : downloads dependencies distribution"
	@echo "system    : Installs System Libraries per $(PLATFORM_TYPE)"
	@echo "install   : create environment based on project $(PACKAGE_INSTALL_NAME)"
	@echo "format    : formatting and linting of project $(PACKAGE_NAME)"
	@echo "clean     : cleans all files or project $(PACKAGE_INSTALL_NAME)"
	@echo "test      : execute unit testing"

info:
	@echo "Git Root:       $(GIT_ROOT)"
	@echo "Package:        $(PACKAGE_INSTALL_NAME) - $(PACKAGE_NAME)"
	@echo "Platform:       ${PLATFORM_TYPE}"
	@echo "Architecture:   $$(uname -m)"
	@echo "Shell:          $(SHELL)"

info_dotfiles:
	@echo "Dotfiles Repo:      $(DOTFILES_REPO)"
	@echo "Dotfiles Remote:    $(DOTFILES_REMOTE)"
	@echo "Dotfiles Branch:    $(BRANCH)"


#################### Installation
.PHONY: install install_setup install_dotfiles link_dotfiles link_vaultspace

install:
	@echo "Installing package $(PACKAGE_INSTALL_NAME) for development..."
	$(MAKE) install_dotfiles

install_dotfiles:
	@echo "Installing Dotfiles from $(DOTFILES_REPO)..."
	@if [ ! -d $(DOTFILES_DIR) ]; then \
		git clone $(DOTFILES_REPO) $(DOTFILES_DIR); \
	fi
	$(MAKE) link_dotfiles

# links dotfiles contents individually so existing entries (e.g. .github/workflows) are preserved
link_dotfiles:
	@echo "Linking Dotfiles..."
	@for dir in .vscode .github; do \
		mkdir -p $$dir; \
		find $(GIT_ROOT)/$(DOTFILES_DIR)/$$dir -maxdepth 1 -mindepth 1 | \
		while read src; do \
			dest="$$dir/$$(basename $$src)"; \
			{ [ -d "$$dest" ] && ! [ -L "$$dest" ]; } || ln -sfn "$$src" "$$dest"; \
		done; \
	done


#################### Python / uv
.PHONY: conda_config uv_download download_python
.PHONY: install_python uv_sync_project_name format lint test clean_python

download_python:
	@echo "Downloading Python version $(PYTHON_VERSION) with UV..."
	$(MAKE) conda_config
	$(MAKE) uv_download

conda_config:
	@if command -v conda >/dev/null 2>&1; then \
		echo "Configuration of Conda Environment..."; \
		conda config --set ssl_verify false; \
		conda config --set auto_activate_base false; \
		conda deactivate; \
	else \
		echo "Conda Environment not present; skipping conda_config."; \
	fi

uv_download:
	@echo "Installing UV package manager..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
	uv   self update
	@echo "UV version: $$(uv --version)"


install_python:
	@echo "Installing Python environment with uv..."
	uv python install $(PYTHON_VERSION)
	@echo "$(PYTHON_VERSION)" > .python-version
	$(MAKE) uv_sync_project_name
	uv sync --all-extras
	uv pip install --upgrade pip
	uv run ipython kernel install --user --name=$(PACKAGE_INSTALL_NAME)
	@echo "UV version: $$(uv --version)"

uv_sync_project_name:
	@test -f "$(RUNTIME_FILE)" || { echo "Missing $(RUNTIME_FILE)"; exit 1; }
	@test -f "$(PYTHON_FILE)"  || { echo "Missing $(PYTHON_FILE)"; exit 1; }
	@echo "Using PACKAGE_INSTALL_NAME=$(PACKAGE_INSTALL_NAME)"
	@echo "Before: $$(grep -E '^name[[:space:]]*=' pyproject.toml)"
	@if [ "$(PLATFORM_TYPE)" = "Darwin" ]; then \
		sed -E -i '' "s|^name[[:space:]]*=.*|name = \"$(PACKAGE_INSTALL_NAME)\"|" pyproject.toml; \
	else \
		sed -E -i "s|^name[[:space:]]*=.*|name = \"$(PACKAGE_INSTALL_NAME)\"|" pyproject.toml; \
	fi
	@echo "After : $$(grep -E '^name[[:space:]]*=' pyproject.toml)"

format:
	@echo "Formatting $(PACKAGE_NAME)..."
	uv run ruff format .

lint:
	@echo "Linting $(PACKAGE_NAME)..."
	uv run ruff check .

test:
	@echo "Running tests for $(PACKAGE_NAME)..."
	uv run pytest

clean_python:
	@echo "Cleaning Python artifacts for $(PACKAGE_INSTALL_NAME)..."
	rm -rf $(PYTHON_VENV_DIR) .pytest_cache dist
	find . -not -path './.git/*' -type d -name "__pycache__" -exec rm -rf {} +
	find . -not -path './.git/*' -type f -name "*.pyc" -delete

#################### General
.PHONY: clean
clean:
	@echo "Cleaning project files for installed package ..."
	$(MAKE) clean_python
	find . -not -path './.git/*' -type d -name "outputs" -exec rm -rf {} +
	find . -not -path './.git/*' -name "*.out" -delete
	find . -not -path './.git/*' -name ".DS_Store" -delete

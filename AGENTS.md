# AGENTS.md

AI agent context for the `github-workflows` repository.

## Project

- **Package**: `velari-github-workflows`
- **Language**: Python 3.12 (managed via `uv`)
- **License**: Apache-2.0

## Purpose

Tutorial repository demonstrating GitHub Actions workflows — covering shell runners, Python CI with uv, and multi-job workflows with environment variable scoping and JS actions.

## Key Files

| Path | Description |
|---|---|
| `.github/workflows/` | GitHub Actions workflow definitions |
| `Makefile` | Primary automation: install, python, agents, dotfiles |
| `config/runtime/runtime.env` | Package name, repo URLs, branch config |
| `config/runtime/python.env` | Python version and venv config |
| `pyproject.toml` | Python project metadata, ruff and pytest config |

## Makefile Targets

| Target | Description |
|---|---|
| `install` | Full environment setup |
| `install_python` | Install Python 3.12 and sync dependencies via uv |
| `install_dotfiles` | Clone/update dotfiles repo |
| `install_agents` | Setup agent infrastructure and skills |
| `format` / `lint` / `test` | Code quality and testing |

## Structure Notes

- `_build/` contains externally cloned repos (`dotfiles`, `agent-skills`) — not tracked by git
- `.vscode/` and `.github/copilot-instructions.md` are symlinked from `_build/dotfiles/`
- Agent skills live in `_build/agent-skills/toolkit/`

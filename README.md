# github-workflows

Github Action Workflows — a tutorial repository demonstrating GitHub Actions with Python CI, shell automation, and AI agent integration.

## Quick Links

- [Workflows](#workflows)
- [Directory Structure](#directory-structure)
- [Setup](#setup)

## Workflows

| Workflow | Trigger | Description |
|---|---|---|
| [basic-workflow.yml](.github/workflows/basic-workflow.yml) | Manual | Multi-job workflow with JS action, env variable scoping |
| [python-workflow.yml](.github/workflows/python-workflow.yml) | Push/PR/Manual | Python CI with uv package manager and caching |
| [shell-workflow.yml](.github/workflows/shell-workflow.yml) | Manual | First workflow — self-hosted and Ubuntu runners |
| [claude.yml](.github/workflows/claude.yml) | Issue/PR comments, Issues | Claude AI agent integration via `@claude` mentions |
| [claude-code-review.yml](.github/workflows/claude-code-review.yml) | Pull Request | Automated code review on PRs using Claude |
| [daily-repo-status.lock.yml](.github/workflows/daily-repo-status.lock.yml) | Schedule (daily) | Daily repo status report generated as a GitHub issue |

## Directory Structure

```
github-workflows/
├── .agents/                          # Agent runtime directory
├── .claude/                          # Claude Code configuration
│   └── settings.json                 # Plugin settings
├── .github/
│   ├── copilot-instructions.md       # Copilot style guide references
│   └── workflows/
│       ├── basic-workflow.yml        # Advanced workflow with JS action
│       ├── claude.yml                # Claude AI agent integration
│       ├── claude-code-review.yml    # Automated PR code review via Claude
│       ├── daily-repo-status.lock.yml # Daily repo status report (compiled)
│       ├── daily-repo-status.md      # Daily repo status source (gh-aw)
│       ├── python-workflow.yml       # Python CI with uv
│       └── shell-workflow.yml        # First workflow (shell runners)
├── .vscode/                          # VS Code settings (symlinked from dotfiles)
├── _build/                           # External cloned repositories (not tracked)
│   ├── agent-skills/                 # AI agent skills and commands
│   └── dotfiles/                     # Shared dotfiles and symlink sources
├── config/
│   └── runtime/
│       ├── python.env                # Python version config
│       └── runtime.env               # Package and repo config
├── AGENTS.md                         # AI agent context file
├── CLAUDE.md                         # Claude Code entry point
├── LICENSE                           # Apache-2.0
├── Makefile                          # Setup and automation targets
├── pyproject.toml                    # Python project config (uv/ruff/pytest)
└── uv.lock                           # Locked dependency versions
```

## Setup

```bash
# Install dependencies and setup environment
make install

# Install Python environment (uv)
make install_python

# Run tests / lint / format
make test
make lint
make format
```

See `make help` for all available targets.

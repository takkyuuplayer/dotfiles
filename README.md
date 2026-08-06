# dotfiles

Managed by [chezmoi \- chezmoi](https://www.chezmoi.io/)

## Install

### macOS

```bash
$ brew install chezmoi
$ chezmoi init --apply --mode symlink --verbose takkyuuplayer
```

## Coding agents

`dot_config/agents/` is the single source shared by Claude Code and Codex. `AGENTS.md` is symlinked to `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` by chezmoi; `skills/*` are linked into `~/.claude/skills` and `~/.codex/skills` with:

```bash
$ make link
```

## gh extensions

`gh-extensions/gh-*` are local [gh](https://cli.github.com/) extensions. Install (symlink) them with:

```bash
$ make gh
```

- `gh merge-ready` : squash-merges merge-ready Dependabot PRs. See `gh merge-ready --help`.

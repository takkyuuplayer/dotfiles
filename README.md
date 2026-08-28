# dotfiles

Managed by [chezmoi](https://www.chezmoi.io/)

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

### Repository-specific agent overrides

`agent-overrides/` contains optional, reusable instructions that chezmoi does not apply automatically.
Copy an override into a repository only when it is needed:

```bash
$ cp "$(chezmoi source-path)/agent-overrides/Learning.md" /path/to/repository/AGENTS.override.md
```

Add repository-specific instructions to the copied `AGENTS.override.md`. If an improvement is useful
across multiple repositories, apply it to `agent-overrides/Learning.md` as well.

## gitignore

`dot_config/git/ignore` is generated — do not edit it directly. Its sources are the manifests
under `gitignore/`:

- `github` : paths under [github/gitignore](https://github.com/github/gitignore), without the `.gitignore` suffix
- `gitignore.io` : template names that github/gitignore does not carry
- `local` : patterns no upstream template covers, emitted verbatim

Regenerate after editing a manifest with:

```bash
$ make git/ignore
```

## gh extensions

`gh-extensions/gh-*` are local [gh](https://cli.github.com/) extensions. Install (symlink) them with:

```bash
$ make gh
```

- `gh merge-ready` : squash-merges merge-ready Dependabot PRs. See `gh merge-ready --help`.

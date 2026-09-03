# dotfiles

Managed by [chezmoi](https://www.chezmoi.io/)

## Install

### macOS

```bash
$ brew install chezmoi
$ chezmoi init --apply --mode symlink --verbose takkyuuplayer
```

## Coding agents

`dot_agents/` is the single source shared by Claude Code and Codex. `AGENTS.md` lands on `~/.agents/AGENTS.md` and is symlinked from `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` by chezmoi; `skills/*` are linked into every directory an agent scans for user-level skills — `~/.claude/skills` for Claude Code and `~/.agents/skills` for Codex, which chezmoi leaves to `make link` so that a skill stays a single symlinked directory:

```bash
$ make link
```

### Third-party skills

Skills maintained outside this repository are listed in the `skills` target of the `Makefile` and
installed globally with the [`skills`](https://github.com/vercel-labs/skills) CLI, which takes any
Git repository, URL or local path as a source:

```bash
$ make skills        # install every source listed in the skills target
$ make skills/update # update the installed skills
```

Add a skill by appending an `npx skills add` line, choosing its `--agent` targets.
[skills.sh](https://www.skills.sh/) indexes what is out there.

Claude Code takes a source through `dot_claude/settings.json` (`enabledPlugins` /
`extraKnownMarketplaces`) instead whenever that source ships a plugin covering only the wanted
skill, so that the same skill is not registered twice under two update paths. Otherwise the skill is
installed on its own with `--skill <name>`.

### Repository-specific agent overrides

`dot_agents/overrides/` contains optional, reusable instructions that no agent reads on its own.
Copy an override into a repository only when it is needed:

```bash
$ cp ~/.agents/overrides/Onboarding.md /path/to/repository/AGENTS.override.md
```

Add repository-specific instructions to the copied `AGENTS.override.md`. If an improvement is useful
across multiple repositories, apply it to `overrides/Onboarding.md` as well.

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

# dotfiles

Managed by [chezmoi](https://www.chezmoi.io/)

## Install

### macOS

```bash
$ brew install chezmoi
$ chezmoi init --apply --mode symlink --verbose takkyuuplayer
```

## Coding agents

`dot_agents/` is the single source shared by Claude Code and Codex, third-party skills included.
`AGENTS.md` lands on `~/.agents/AGENTS.md` and is symlinked from `~/.claude/CLAUDE.md` and
`~/.codex/AGENTS.md` by chezmoi. `skills/` is left to `make link`, which links it into every
directory an agent scans for user-level skills:

```bash
$ make link
```

- `~/.agents/skills` : the directory itself, since Codex reads that path and the
  [`skills`](https://github.com/vercel-labs/skills) CLI writes into it
- `~/.claude/skills/<skill>` : one link per skill, the only user-level location Claude Code reads

### Third-party skills

Skills maintained outside this repository live under `dot_agents/skills/` like the handwritten ones,
because `~/.agents/skills` is this repository. Install one with the `skills` CLI, which takes any Git
repository, URL or local path as a source, then commit what it wrote:

```bash
$ npx --yes skills add mattpocock/skills --skill grilling --global --yes
$ make skills/update # update every skill recorded in dot_skill-lock.json
```

Run `make link` afterwards so that a newly added skill also reaches `~/.claude/skills`.
[skills.sh](https://www.skills.sh/) indexes what is out there.

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

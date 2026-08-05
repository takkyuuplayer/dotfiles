# dotfiles

Managed by [chezmoi \- chezmoi](https://www.chezmoi.io/)

## Install

### macOS

```bash
$ brew install chezmoi
$ chezmoi init --apply --mode symlink --verbose takkyuuplayer
```

## gh extensions

`gh-extensions/gh-*` are local [gh](https://cli.github.com/) extensions. Install (symlink) them with:

```bash
$ make gh
```

- `gh merge-ready` : squash-merges every merge-ready PR of the owner. See `gh merge-ready --help`.

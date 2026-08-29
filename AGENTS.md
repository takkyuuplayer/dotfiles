# Git Commit Rules

This repository overrides the global rule that requires a dedicated worktree.

- Do not create a Git worktree. Work in the main worktree.
- Do not commit directly to the base branch (`main`). Create a dedicated branch from the up-to-date
  `origin/main` and commit there.
- A pull request is not required. The branch may be merged or fast-forwarded into `main` locally.

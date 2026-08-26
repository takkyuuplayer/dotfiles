# Git Commit Rules

- Always commit immediately after editing files. Do not wait for the user to ask.
- Follow [Conventional Commits](https://www.conventionalcommits.org/) format: `<type>(<scope>): <description>`. Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`, `perf`, `build`.
- Never commit directly to main/master, and never commit in the main worktree. Always create a dedicated worktree with a new branch, based on the up-to-date remote default branch rather than the possibly stale local one: `git fetch origin <default-branch>`, then `git worktree add <path> -b <branch> origin/<default-branch>`.
- When you have edited files in the commit — not when you only write the commit message — also include:
  - a `Co-Authored-By` trailer with your agent name and the actual model name powering the current session (e.g., `Co-Authored-By: Claude <model> <noreply@anthropic.com>`, `Co-Authored-By: Codex <model> <noreply@openai.com>`);
  - a `Prompt:` section listing every user prompt that led to the changes, in chronological order, not just the most recent one;
  - a `Context:` section, when the user had an IDE file open or a selection, preferring GitHub permalink format (`https://github.com/<owner>/<repo>/blob/<sha>/<path>#L<start>-L<end>`) and falling back to `<path>#L<start>-L<end>` without a GitHub remote.

# GitHub Rules

- Sign anything you post on GitHub with `🤖 <agent> (<model>)` — your agent name and the actual model name powering the current session — so readers can tell an agent wrote it. Put it on the first line of a comment, or on the last line of an issue or pull request body.
- When asked to create a pull request, do not run `gh pr create` directly. Instead, write the PR body to a temp file outside the working tree (your session's scratch directory, or `$TMPDIR`), then output a `gh pr create --web --title "<title>" --body-file <path>` command for the user to run.

# Code Editing Rules

- When editing source code, do not add comments that simply restate what is already obvious from the code itself.

# Git Commit Rules

- Always commit immediately after editing files. Do not wait for the user to ask.
- Follow [Conventional Commits](https://www.conventionalcommits.org/) format: `<type>(<scope>): <description>`. Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`, `perf`, `build`.
- Only add a `Co-Authored-By` trailer when you have edited files in the commit. Do not add it when you only create the commit message. Use your agent name and the actual model name powering the current session (e.g., `Co-Authored-By: Claude <model> <noreply@anthropic.com>`, `Co-Authored-By: Codex <model> <noreply@openai.com>`).
- When you have edited files, include the user's original prompts (the instructions that led to the changes) in the commit message body under a `Prompt:` section. If multiple prompts contributed to the changes, list every one of them in chronological order (e.g. as a bullet list), not just the most recent one. If the user had an IDE file open or a selection when giving the instruction, also include that context under a `Context:` section, preferring GitHub permalink format (e.g., `https://github.com/<owner>/<repo>/blob/<sha>/<path>#L<start>-L<end>`) when the repository has a GitHub remote; otherwise fall back to `<path>#L<start>-L<end>`.
- Never commit directly to main/master, and never commit in the main worktree. Always create a dedicated git worktree with a new branch and commit there.
- When branching off the default branch (especially `main`), base the worktree on the up-to-date remote default branch, not the local one which may be stale: run `git fetch origin <default-branch>` first, then `git worktree add <path> -b <branch> origin/<default-branch>`.

# Pull Request Rules

- When asked to create a pull request, do not run `gh pr create` directly. Instead, write the PR body to a temp file outside the working tree (your session's scratch directory, or `$TMPDIR`), then output a `gh pr create --web --title "<title>" --body-file <path>` command for the user to run.

# GitHub Rules

- When creating something on GitHub as an agent, add a signature line so readers can tell an agent wrote it. Use your agent name and the actual model name powering the current session, in the form `🤖 <agent> (<model>)` (e.g., `🤖 Claude (<model>)`, `🤖 Codex (<model>)`).
- For comments (issue comments, pull request comments, review comments), put the signature on the first line, followed by a blank line, before the body.
- For issues and pull requests, put the signature on the last line of the body, after a blank line.

# Code Editing Rules

- When editing source code, do not add comments that simply restate what is already obvious from the code itself.

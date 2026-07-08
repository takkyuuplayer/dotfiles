# Git Commit Rules

- Always commit immediately after editing files. Do not wait for the user to ask.
- Follow [Conventional Commits](https://www.conventionalcommits.org/) format: `<type>(<scope>): <description>`. Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`, `perf`, `build`.
- Only add `Co-Authored-By` trailer when Claude has edited files in the commit. Do not add it when Claude only creates the commit message. Use the actual model name powering the current session (e.g., `Co-Authored-By: Claude <model> <noreply@anthropic.com>`).
- When Claude has edited files, include the user's original prompt (the instruction that led to the changes) in the commit message body under a `Prompt:` section. If the user had an IDE file open or a selection when giving the instruction, also include that context under a `Context:` section, preferring GitHub permalink format (e.g., `https://github.com/<owner>/<repo>/blob/<sha>/<path>#L<start>-L<end>`) when the repository has a GitHub remote; otherwise fall back to `<path>#L<start>-L<end>`.
- Never commit directly to main/master. Always create a feature branch and commit there.

# Pull Request Rules

- When asked to create a pull request, do not run `gh pr create` directly. Instead, write the PR body to a temp file under the repository's `.claude/.cc-writes/` directory (e.g., `.claude/.cc-writes/pr-body.md`), then output a `gh pr create --web --title "<title>" --body-file <path>` command for the user to run.

# Code Editing Rules

- When editing source code, do not add comments that simply restate what is already obvious from the code itself.

# Git Commit Rules

- Commit each logical change as soon as it is complete and the necessary checks pass. Do not wait for the user to ask.
- Follow [Conventional Commits](https://www.conventionalcommits.org/) format: `<type>(<scope>): <description>`.
- Never commit directly to main/master. Use a dedicated worktree unless explicit repository-specific rules require a different workflow.
- For new work, create a new branch based on the up-to-date remote default branch: `git fetch origin <default-branch>`, then `git worktree add <path> -b <branch> origin/<default-branch>` when using a worktree. Continue related work in its existing branch and working directory.
- When you have edited files in the commit — not when you only write the commit message — include a `Co-Authored-By` trailer with your agent name and the actual model name powering the current session (e.g., `Co-Authored-By: Claude <model> <noreply@anthropic.com>`, `Co-Authored-By: Codex <model> <noreply@openai.com>`).
- Explain why the change was made.
- When collaboration materially shaped the change, briefly describe the relevant request, AI proposal, and user decision. Make the explanation understandable without the conversation.
- Link to the original conversation or saved transcript when available.
- Cite sources next to the decisions they support, when needed.
- Do not require Prompt or Context sections, reproduce every prompt, or list every referenced file. Do not invent missing history.

# GitHub Rules

- Keep issues, pull requests, and comments as concise as possible. Do not write what is already evident from the diff or the commit history; explain only the why and the context that cannot be read from the code.
- When writing a pull request body, omit primary-source evidence and decision context that can be added to specific changed lines as review comments using [gh-draft-review-comments](skills/gh-draft-review-comments/SKILL.md). Keep only the context needed to understand the pull request as a whole in the body.
- Sign anything you post on GitHub with `🤖 <agent> (<model>)` — your agent name and the actual model name powering the current session — so readers can tell an agent wrote it.
- The user reviews and submits pull requests and issues in the browser. Do not create them directly through the CLI, an API, or another tool. Prepare them using this workflow:
  1. Write the body to a temp file outside the working tree (your session's scratch directory, or `$TMPDIR`). For a pull request, also prepare candidate inline review comments and their supporting sources before handing over the browser command, then push the head branch.
  2. Output one single-line command that chains `pbcopy` with the appropriate browser command for the user to run. Do not split them into separate lines: copying the second line would replace the body in the clipboard. Always omit both `--body` and `--body-file` to avoid `cannot open in browser: maximum URL length exceeded`. Keep the explicit repository, base, and head arguments so the command works from any directory. Tell the user to paste the clipboard into the body field, review it, and submit.
  3. After the user reports that the pull request has been created, identify it and check the comment candidates against its current HEAD and diff. Use [gh-draft-review-comments](skills/gh-draft-review-comments/SKILL.md) to create a pending review for applicable comments as part of the pull request task, without requiring a separate request. The user submits the review.

  Command to output, one of:
  - `pbcopy < "<path>" && gh pr create -R <owner>/<repo> --base <base> --head <branch> --web --title "<title>"`
  - `pbcopy < "<path>" && gh issue create -R <owner>/<repo> --web --title "<title>"`

# Code Editing Rules

- When editing source code, do not add comments that simply restate what is already obvious from the code itself.
- Name identifiers in code for ESL (English as a Second Language) readers: prefer plain, widely known words over idioms, rare vocabulary, or wordplay, as long as accuracy is not lost.

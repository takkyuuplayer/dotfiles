# Git Commit Rules

- Only add `Co-Authored-By` trailer when Claude has edited files in the commit. Do not add it when Claude only creates the commit message. Use the actual model name powering the current session (e.g., `Co-Authored-By: Claude <model> <noreply@anthropic.com>`).
- When Claude has edited files, include the user's original prompt (the instruction that led to the changes) in the commit message body under a `Prompt:` section.

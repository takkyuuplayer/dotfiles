#!/usr/bin/env python3
"""Create an evidence-comment review on GitHub without submitting it."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import Any


ALLOWED_COMMENT_KEYS = {
    "path",
    "line",
    "side",
    "body",
    "start_line",
    "start_side",
}


class DraftReviewError(Exception):
    pass


def run_gh(*args: str, input_text: str | None = None) -> subprocess.CompletedProcess[str]:
    try:
        return subprocess.run(
            ["gh", *args],
            input=input_text,
            text=True,
            capture_output=True,
            check=False,
        )
    except OSError as error:
        raise DraftReviewError(f"could not run GitHub CLI: {error}") from error


def gh_json(*args: str) -> Any:
    result = run_gh(*args)
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        raise DraftReviewError(f"gh {' '.join(args)} failed: {detail}")
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as error:
        raise DraftReviewError("GitHub CLI returned invalid JSON") from error


def validate_repo(repo: str) -> None:
    parts = repo.split("/")
    if len(parts) != 2 or not all(parts):
        raise DraftReviewError("--repo must be OWNER/REPO")


def require_positive_int(value: Any, field: str, index: int) -> None:
    if isinstance(value, bool) or not isinstance(value, int) or value < 1:
        raise DraftReviewError(f"comments[{index}].{field} must be a positive integer")


def validate_comment(comment: Any, index: int) -> dict[str, Any]:
    if not isinstance(comment, dict):
        raise DraftReviewError(f"comments[{index}] must be an object")

    unknown = set(comment) - ALLOWED_COMMENT_KEYS
    if unknown:
        names = ", ".join(sorted(unknown))
        raise DraftReviewError(f"comments[{index}] has unsupported keys: {names}")

    for field in ("path", "body"):
        value = comment.get(field)
        if not isinstance(value, str) or not value.strip():
            raise DraftReviewError(f"comments[{index}].{field} must be a non-empty string")

    require_positive_int(comment.get("line"), "line", index)
    if comment.get("side") not in {"LEFT", "RIGHT"}:
        raise DraftReviewError(f"comments[{index}].side must be LEFT or RIGHT")

    has_start_line = "start_line" in comment
    has_start_side = "start_side" in comment
    if has_start_line != has_start_side:
        raise DraftReviewError(
            f"comments[{index}] must provide start_line and start_side together"
        )
    if has_start_line:
        require_positive_int(comment["start_line"], "start_line", index)
        if comment["start_side"] not in {"LEFT", "RIGHT"}:
            raise DraftReviewError(
                f"comments[{index}].start_side must be LEFT or RIGHT"
            )

    return comment


def load_payload(path: Path) -> dict[str, Any]:
    try:
        raw = json.loads(path.read_text(encoding="utf-8"))
    except OSError as error:
        raise DraftReviewError(f"cannot read {path}: {error}") from error
    except json.JSONDecodeError as error:
        raise DraftReviewError(f"invalid JSON in {path}: {error}") from error

    if not isinstance(raw, dict):
        raise DraftReviewError("input must be an object with commit_id and comments")
    unknown = set(raw) - {"commit_id", "comments"}
    if unknown:
        names = ", ".join(sorted(unknown))
        raise DraftReviewError(f"input has unsupported keys: {names}")

    commit_id = raw.get("commit_id")
    if (
        not isinstance(commit_id, str)
        or len(commit_id) != 40
        or any(character not in "0123456789abcdefABCDEF" for character in commit_id)
    ):
        raise DraftReviewError("commit_id must be a 40-character Git SHA")

    comments = raw.get("comments")
    if not isinstance(comments, list) or not comments:
        raise DraftReviewError("comments must be a non-empty array")

    return {
        "commit_id": commit_id,
        "comments": [
            validate_comment(comment, index) for index, comment in enumerate(comments)
        ],
    }


def pending_reviews(repo: str, pull_number: int, login: str) -> list[dict[str, Any]]:
    pages = gh_json(
        "api",
        f"repos/{repo}/pulls/{pull_number}/reviews",
        "--paginate",
        "--slurp",
        "-H",
        "Accept: application/vnd.github+json",
    )
    reviews = [review for page in pages for review in page]
    return [
        review
        for review in reviews
        if review.get("state") == "PENDING"
        and review.get("user", {}).get("login") == login
    ]


def create_review(
    repo: str, pull_number: int, payload: dict[str, Any]
) -> subprocess.CompletedProcess[str]:
    return run_gh(
        "api",
        "--method",
        "POST",
        f"repos/{repo}/pulls/{pull_number}/reviews",
        "--input",
        "-",
        "-H",
        "Accept: application/vnd.github+json",
        input_text=json.dumps(payload),
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create a GitHub pull request review in PENDING state."
    )
    parser.add_argument("--repo", required=True, help="GitHub repository as OWNER/REPO")
    parser.add_argument("--pr", required=True, type=int, help="Pull request number")
    parser.add_argument("--input", required=True, type=Path, help="Review payload JSON")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        validate_repo(args.repo)
        if args.pr < 1:
            raise DraftReviewError("--pr must be a positive integer")
        payload = load_payload(args.input)

        viewer = gh_json("api", "user", "-H", "Accept: application/vnd.github+json")
        login = viewer.get("login")
        if not isinstance(login, str) or not login:
            raise DraftReviewError("could not determine the authenticated GitHub user")

        pull = gh_json(
            "api",
            f"repos/{args.repo}/pulls/{args.pr}",
            "-H",
            "Accept: application/vnd.github+json",
        )
        if pull.get("state") != "open":
            raise DraftReviewError("the pull request is not open")
        current_head = pull.get("head", {}).get("sha")
        if current_head != payload["commit_id"]:
            raise DraftReviewError(
                "the pull request HEAD changed after the comments were prepared; "
                "re-read the diff and rebuild the input"
            )

        existing = pending_reviews(args.repo, args.pr, login)
        if existing:
            review_id = existing[0].get("id", "unknown")
            raise DraftReviewError(
                f"pending review {review_id} already exists for {login}; "
                "no new review was created"
            )

        result = create_review(args.repo, args.pr, payload)
        if result.returncode != 0:
            recovered = pending_reviews(args.repo, args.pr, login)
            if recovered and recovered[0].get("commit_id") == payload["commit_id"]:
                print(
                    json.dumps(
                        {
                            "id": recovered[0].get("id"),
                            "state": "PENDING",
                            "html_url": recovered[0].get("html_url"),
                            "recovered_after_uncertain_response": True,
                        }
                    )
                )
                return 0
            detail = result.stderr.strip() or result.stdout.strip()
            raise DraftReviewError(
                "review creation did not return success and no matching pending review "
                f"was found; do not retry automatically: {detail}"
            )

        try:
            review = json.loads(result.stdout)
        except json.JSONDecodeError as error:
            raise DraftReviewError(
                "review may have been created, but GitHub returned invalid JSON; "
                "inspect the PR before retrying"
            ) from error
        if review.get("state") != "PENDING":
            raise DraftReviewError(
                f"unexpected review state {review.get('state')!r}; inspect the PR"
            )

        print(
            json.dumps(
                {
                    "id": review.get("id"),
                    "state": review.get("state"),
                    "html_url": review.get("html_url"),
                    "comments": len(payload["comments"]),
                }
            )
        )
        return 0
    except DraftReviewError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())

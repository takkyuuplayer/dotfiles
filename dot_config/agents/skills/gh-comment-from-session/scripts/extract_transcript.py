#!/usr/bin/env python3
"""Claude Code のセッション transcript (jsonl) から人間が読める会話ログを抽出する。

GitHub のコメントに <details> で会話ログを添付する用途を想定しているため、
思考ブロック・ツール呼び出し・ツール結果・system-reminder といった
読み手にとってノイズになる要素は既定で落とす。
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

PROJECTS_DIR = Path.home() / ".claude" / "projects"

# 会話に紛れ込むハーネス由来のタグ。引用しても読み手には意味がないので落とす。
NOISE_TAGS = (
    "system-reminder",
    "command-message",
    "command-name",
    "command-args",
    "local-command-stdout",
    "task-notification",
)
NOISE_RE = re.compile(
    r"<(" + "|".join(NOISE_TAGS) + r")>.*?</\1>", re.DOTALL
)
# スラッシュコマンドの起動は「ユーザーが何を指示したか」そのものなので、
# ノイズとして落とす前にコマンド名だけ本文として残す。
COMMAND_RE = re.compile(r"<command-name>(.*?)</command-name>", re.DOTALL)
COMMAND_ARGS_RE = re.compile(r"<command-args>(.*?)</command-args>", re.DOTALL)


def project_dir_for(cwd: Path) -> Path:
    """cwd を Claude Code の projects ディレクトリ名に変換する。

    区切りの `/` とドットがいずれも `-` になる規則
    (例: /Users/foo/.local/share/x -> -Users-foo--local-share-x)。
    """
    return PROJECTS_DIR / re.sub(r"[/.]", "-", str(cwd))


def resolve_session(session: str | None, project: Path) -> Path:
    if session:
        p = Path(session)
        if p.is_file():
            return p
        p = project / f"{session}.jsonl"
        if p.is_file():
            return p
        sys.exit(f"session が見つかりません: {session}")
    files = sorted(project.glob("*.jsonl"), key=lambda f: f.stat().st_mtime)
    if not files:
        sys.exit(f"transcript がありません: {project}")
    return files[-1]


def clean(text: str) -> str:
    invoked = ""
    if (m := COMMAND_RE.search(text)):
        invoked = m.group(1).strip()
        if (a := COMMAND_ARGS_RE.search(text)) and a.group(1).strip():
            invoked += " " + a.group(1).strip()
    body = NOISE_RE.sub("", text).strip()
    if invoked:
        return f"{invoked}\n\n{body}".strip()
    return body


def blocks_to_text(content) -> str:
    """message.content から表示すべき本文だけを取り出す。"""
    if isinstance(content, str):
        return clean(content)
    parts = []
    for block in content or []:
        # thinking / tool_use / tool_result は引用しない
        if isinstance(block, dict) and block.get("type") == "text":
            parts.append(block.get("text", ""))
    return clean("\n\n".join(parts))


def answers_from_tool_result(rec: dict) -> str:
    """AskUserQuestion の選択結果を user の発言として復元する。

    選択肢による回答は tool_result として記録され、そのままでは
    「ユーザーが何を選んだか」が会話ログから丸ごと抜け落ちてしまう。
    """
    result = rec.get("toolUseResult")
    if not isinstance(result, dict):
        return ""
    answers = result.get("answers")
    if not isinstance(answers, dict) or not answers:
        return ""
    return "\n".join(f"Q: {q}\nA: {a}" for q, a in answers.items())


def load_turns(path: Path, include_sidechain: bool) -> list[dict]:
    turns = []
    with path.open(encoding="utf-8") as f:
        for index, line in enumerate(f):
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError:
                continue
            if rec.get("type") not in ("user", "assistant"):
                continue
            if rec.get("isMeta"):
                continue
            if rec.get("isSidechain") and not include_sidechain:
                continue
            text = blocks_to_text(rec.get("message", {}).get("content"))
            if not text and rec["type"] == "user":
                text = answers_from_tool_result(rec)
            if not text:
                continue
            turns.append(
                {
                    "role": rec["type"],
                    "text": text,
                    "timestamp": rec.get("timestamp"),
                    "sidechain": bool(rec.get("isSidechain")),
                    "uuid": rec.get("uuid"),
                    "index": index,
                }
            )
    return turns


def merge_adjacent(turns: list[dict]) -> list[dict]:
    """1 ターンが複数レコードに割れる分だけを結合する。

    元の jsonl 上でも連続している場合に限る。間にツール往復を挟んだ発言まで
    つなげてしまうと、何度も往復した会話が 1 つの長い独白に見えてしまう。
    """
    merged: list[dict] = []
    for t in turns:
        prev = merged[-1] if merged else None
        contiguous = (
            prev is not None
            and prev["role"] == t["role"]
            and prev["sidechain"] == t["sidechain"]
            and t["index"] == prev["index"] + 1
        )
        if contiguous:
            prev["text"] += "\n\n" + t["text"]
            prev["index"] = t["index"]
        else:
            merged.append(dict(t))
    return merged


def parse_ts(value: str | None) -> datetime | None:
    if not value:
        return None
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return None


def to_markdown(turns: list[dict], quote: bool) -> str:
    label = {"user": "user", "assistant": "assistant"}
    out = []
    for t in turns:
        who = label[t["role"]] + (" (subagent)" if t["sidechain"] else "")
        body = t["text"]
        if quote:
            body = "\n".join("> " + line if line else ">" for line in body.splitlines())
            out.append(f"> **{who}**\n>\n{body}")
        else:
            out.append(f"**{who}**\n\n{body}")
    return "\n\n".join(out)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--session", help="セッション ID または jsonl のパス（既定: 最新セッション）")
    ap.add_argument("--cwd", default=".", help="対象プロジェクトの作業ディレクトリ")
    ap.add_argument("--project-dir", help="projects 配下のディレクトリを直接指定")
    ap.add_argument("--list", action="store_true", help="セッション一覧を出して終了")
    ap.add_argument("--last-n", type=int, help="末尾 N 発言だけ出力")
    ap.add_argument("--since", help="この ISO8601 時刻以降の発言だけ出力")
    ap.add_argument("--include-sidechain", action="store_true", help="subagent の会話も含める")
    ap.add_argument("--quote", action="store_true", help="Markdown の引用記法 (>) を付ける")
    ap.add_argument("--format", choices=("md", "json"), default="md")
    args = ap.parse_args()

    project = Path(args.project_dir) if args.project_dir else project_dir_for(Path(args.cwd).resolve())
    if not project.is_dir():
        sys.exit(f"projects ディレクトリがありません: {project}")

    if args.list:
        for f in sorted(project.glob("*.jsonl"), key=lambda f: f.stat().st_mtime, reverse=True):
            mtime = datetime.fromtimestamp(f.stat().st_mtime, timezone.utc).astimezone()
            print(f"{mtime:%Y-%m-%d %H:%M}  {f.stem}")
        return

    path = resolve_session(args.session, project)
    turns = merge_adjacent(load_turns(path, args.include_sidechain))

    if args.since:
        since = parse_ts(args.since)
        if since is None:
            sys.exit(f"--since を解釈できません: {args.since}")
        turns = [t for t in turns if (ts := parse_ts(t["timestamp"])) and ts >= since]
    if args.last_n:
        turns = turns[-args.last_n :]

    if args.format == "json":
        json.dump({"session": path.stem, "turns": turns}, sys.stdout, ensure_ascii=False, indent=2)
        print()
    else:
        print(f"<!-- session: {path.stem} / turns: {len(turns)} -->")
        print(to_markdown(turns, args.quote))


if __name__ == "__main__":
    main()

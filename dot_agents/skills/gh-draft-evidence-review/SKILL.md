---
name: gh-draft-evidence-review
description: "Pull Request 作成後、変更の根拠となる一次情報のリンクと短い抜粋を該当 diff 行へ配置し、GitHub の pending review として保存する。『Files changed に根拠コメントを付けて』『レビュー用の補足を下書きして』など、レビュアー向けの evidence comment を求められたときに使う。コードレビューそのもの、PR 本文の作成、レビューの submit には使わない。"
---

# GitHub Draft Evidence Review

PR の diff だけでは分からない「なぜこの実装なのか」を、レビュアーが変更行から直接たどれる状態にする。コメント数ではなく、判断コストを下げる根拠の質を優先する。

## 境界

- 対象は作成済み PR の `Files changed` に置く review comment。
- GitHub への書き込みは `PENDING` review の作成まで。レビューを submit する API、`APPROVE`、`REQUEST_CHANGES`、`COMMENT` event は呼び出さない。
- pending review の作成は外部への書き込みである。ユーザーがコメントを「追加する」「置く」「下書きとして作る」と依頼した場合だけ実行する。「案を見せて」「コメントを考えて」ならプレビューまでに留める。
- 一般的なコードレビューや、diff から自明な実装説明は追加しない。

## 根拠を置く変更の選び方

PR 全体へ機械的にコメントを付けない。次のような、コード単体では判断理由を復元しにくい箇所を選ぶ。

- API・言語・ライブラリの仕様に合わせた実装
- 互換性対応、回避策、非自明な分岐や定数
- セキュリティ、アクセシビリティ、プロトコル上の要件
- 特定バージョンの挙動や、採用案と代替案の境界

コメントを置かなくても PR 本文やテストから十分理解できる箇所、同じ根拠の重複、変更と直接関係しない参考資料は除く。根拠を確認できない意図は推測で補わない。

## ワークフロー

1. ユーザー指定の URL / 番号、または現在のブランチに対応する `gh pr view` から PR を特定する。PR のリポジトリ、番号、URL、`headRefOid` を記録する。
2. PR 本文、commit、diff、周辺コード、テストを読み、根拠が必要な判断点を絞る。コメント対象行は現在の unified diff に実在することを確認する。
3. 各判断点について一次情報を調べる。公式仕様・標準・RFC・公式 API ドキュメント・当該プロジェクトのソースコードや maintainer の release note を優先する。検索結果、まとめ記事、AI 生成文は根拠として使わない。
4. バージョンと該当箇所を直接示す安定した URL を選ぶ。ソースコードなら可能な限り tag または commit の permalink を使う。記述が変更へどう適用されるかまで確認する。
5. コメント本文と配置先を組み立て、投稿前に全件を見直す。リポジトリの言語と署名規約に従う。
6. ユーザーが pending review の作成を依頼している場合だけ、後述のスクリプトで一括作成する。結果の `state` が `PENDING` であることを確認し、件数と PR URL を報告する。

## コメントの書き方

基本形は次のとおり。見出しは内容に合わせて省略してよい。

```markdown
<必要な署名>

根拠: [資料名 — 該当節](https://primary.example/spec#section)

> 原文からの短い抜粋

この変更では、上記の要件を満たすために `<変更の判断>` としています。
```

- 冒頭で一次情報へ直接リンクし、直後に関連部分だけを抜粋する。
- 抜粋は原文どおり、1 資料につき合計 25 語以内に留める。翻訳は引用に混ぜず、必要なら「要旨」と明記して言い換える。
- 最後の 1〜2 文で、資料の記述と対象行の関係を説明する。diff の言い換えではなく「この仕様だから、この選択」の接続を書く。
- 一つのコメントには一つの判断を載せる。複数行が一つの判断を構成するときだけ multi-line comment にする。
- リンク先が主張を直接支えていない、対象バージョンが違う、引用の前後で意味が変わる場合は使わない。

## Pending review の作成

[GitHub REST API](https://docs.github.com/en/rest/pulls/reviews#create-a-review-for-a-pull-request) では `event` を省略すると review が `PENDING` になる。一時 JSON をワーキングツリー外に作り、調査時に記録した PR の HEAD SHA を `commit_id` に入れる。

```json
{
  "commit_id": "<40-character PR head SHA>",
  "comments": [
    {
      "path": "path/to/file.ts",
      "line": 42,
      "side": "RIGHT",
      "body": "根拠: [公式仕様](https://example.com/spec)\n\n> Short exact quote.\n\nこの変更との関係を説明します。"
    }
  ]
}
```

`line` は diff 上の blob 行番号を使う。追加行またはコンテキスト行は `RIGHT`、削除行は `LEFT`。複数行には `start_line` と `start_side` も指定する。[review comment API](https://docs.github.com/en/rest/pulls/comments#create-a-review-comment-for-a-pull-request) で廃止予定とされる `position` は使わない。

```bash
python3 <skill-dir>/scripts/create_pending_review.py \
  --repo OWNER/REPO \
  --pr NUMBER \
  --input "$TMPDIR/evidence-review.json"
```

スクリプトは次を投稿前に検証する。

- input に review を submit できる `event` や review 本文が含まれていないこと
- JSON の `commit_id` が現在の PR HEAD と一致すること
- 現在のユーザーによる pending review がまだ存在しないこと
- コメントが `path`、`line`、`side`、`body` を持つこと

既存の pending review がある場合は、新規 review を作らずユーザーへ報告する。POST の成否が不明な場合も自動で再試行せず、pending review の有無を一度確認して結果を報告する。レビューの submit は常にユーザーが GitHub 上で行う。

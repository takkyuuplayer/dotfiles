---
name: gh-draft-review-comments
description: "Pull Request の Files changed に、一次情報またはセッション文脈を根拠にした review comment を pending review として下書きする。『Files changed に根拠コメントを付けて』『レビュー用の補足を下書きして』などで使う。issue コメント、PR 通常コメント、レビュー返信、コードレビューそのもの、PR 本文作成、レビューの submit には使わない。"
---

# GitHub Draft Review Comments

PR の diff だけでは分からない「なぜこの実装なのか」を、レビュアーが変更行から直接たどれる状態にする。根拠は公式仕様などの一次情報と、このセッションで確認した判断背景を分けて扱う。コメント数ではなく、判断コストを下げる文脈の質を優先する。

## 境界

- 対象は作成済み PR の `Files changed` に置く review comment だけ。issue コメント、PR の通常コメント、レビューコメントへの返信本文は扱わない。
- ユーザーが「この会話を PR にコメントして」のように通常コメントとも Files changed コメントとも取れる依頼をしたら、Files changed に置く意図か確認する。
- GitHub への書き込みは `PENDING` review の作成まで。レビューを submit する API、`APPROVE`、`REQUEST_CHANGES`、`COMMENT` event は呼び出さない。
- pending review の作成は外部への書き込みである。ユーザーがコメントを「追加する」「置く」「下書きとして作る」と依頼した場合だけ実行する。「案を見せて」「コメントを考えて」ならプレビューまでに留める。
- 一般的なコードレビューや、diff から自明な実装説明は追加しない。

## コメントを置く変更の選び方

PR 全体へ機械的にコメントを付けない。次のような、コード単体では判断理由を復元しにくい箇所だけを選ぶ。

- API・言語・ライブラリの仕様に合わせた実装
- 互換性対応、回避策、非自明な分岐や定数
- セキュリティ、アクセシビリティ、プロトコル上の要件
- 特定バージョンの挙動や、採用案と代替案の境界
- セッション中の調査・合意・却下判断が、特定の変更行の意味を左右する箇所

コメントを置かなくても PR 本文やテストから十分理解できる箇所、同じ根拠の重複、変更と直接関係しない参考資料は除く。根拠を確認できない意図は推測で補わない。

## ワークフロー

1. ユーザー指定の URL / 番号、または現在のブランチに対応する `gh pr view` から PR を特定する。PR のリポジトリ、番号、URL、`headRefOid` を記録する。
2. PR 本文、commit、diff、周辺コード、テストを読み、根拠が必要な判断点を絞る。コメント対象行は現在の unified diff に実在することを確認する。
3. 根拠の種類を決める。公式仕様・API docs・ソース permalink などは [一次情報](#一次情報) として扱う。このセッションでの調査や合意は [セッション文脈](#セッション文脈) として扱う。同じコメントに両方を入れてよいが、ラベルを分ける。
4. コメント本文と配置先を組み立て、投稿前に全件を見直す。本文には `🤖 <agent> (<model>)` の署名を必ず含め、位置はそのコメントが読みやすい形に合わせて決める。セッション文脈を details に入れる場合は、漏えいチェックを必ず通す。
5. ユーザーが pending review の作成を依頼している場合だけ、後述のスクリプトで一括作成する。結果の `state` が `PENDING` であることを確認し、件数と PR URL を報告する。

PR の当たりを付けるとき:

```bash
gh pr view --json number,url,title,headRefOid
```

## 一次情報

各判断点について一次情報を調べる。公式仕様・標準・RFC・公式 API ドキュメント・当該プロジェクトのソースコードや maintainer の release note を優先する。検索結果、まとめ記事、AI 生成文は根拠として使わない。

バージョンと該当箇所を直接示す安定した URL を選ぶ。ソースコードなら可能な限り tag または commit の permalink を使う。記述が変更へどう適用されるかまで確認する。

基本形:

```markdown
根拠: [資料名 - 該当節](https://primary.example/spec#section)

> 原文からの短い抜粋

この変更では、上記の要件を満たすために `<変更の判断>` としています。
```

- 冒頭で一次情報へ直接リンクし、直後に関連部分だけを抜粋する。
- 抜粋は原文どおり、1 資料につき合計 25 語以内に留める。翻訳は引用に混ぜず、必要なら「要旨」と明記して言い換える。
- 最後の 1〜2 文で、資料の記述と対象行の関係を説明する。diff の言い換えではなく「この仕様だから、この選択」の接続を書く。
- リンク先が主張を直接支えていない、対象バージョンが違う、引用の前後で意味が変わる場合は使わない。

## セッション文脈

セッション中の会話は、仕様根拠ではなく判断背景として扱う。Files changed に置くのは、特定の変更行と判断に直結する場合だけ。会話ログそのものではなく、レビュアーやレビュアーが使う AI が判断を再現できる材料に凝縮する。

現在の会話だけで足りない場合や別セッションを参照する場合は、同梱スクリプトで transcript から材料を取り出す。

```bash
python3 <skill-dir>/scripts/extract_transcript.py --quote > "$TMPDIR/session-log.md"
```

よく使うオプション:

- `--list` - セッション一覧を表示する
- `--session <id|path>` - 対象セッションを指定する
- `--last-n <N>` / `--since <ISO8601>` - 必要な範囲に絞る
- `--format json` - 発言単位で取捨選択する

本文は固定寄りの形にする。`<details>` は原則入れるが、対象行との関係が 1〜2 文で十分なら省略してよい。details の中身は、AI に聞き直す材料になる 10〜20 行程度を目安にする。

```markdown
この行では、セッション中に確認した `<判断>` に合わせて `<変更の要点>` としています。

<details>
<summary>判断の背景</summary>

- 決定に影響した観察や制約
- 採用した判断と、その決め手
- 検討したが採らなかった案と理由

</details>
```

入れるもの:

- 出発点。何が問題だったのか、何を頼まれたのか
- 途中で分かった、結論を左右した観察（数値・エラーメッセージ・仕様の制約など）
- 決めたことと、その決め手
- 検討したが採らなかった選択肢と、採らなかった理由

落とすもの:

- 結論に影響しなかった試行錯誤、ツール実行の失敗と再試行
- 誰がいつ何を言ったかという会話順や発言者ログ
- 投稿先のリポジトリと無関係な話題

一次情報とセッション文脈を同じ inline comment に入れる場合は、`根拠:` と `判断の背景:` のようにラベルを分ける。

### 漏えいチェック

セッション文脈を `<details>` に入れる場合は、本文を書き出した一時ファイルに対して必ずチェックする。見つかったものは置き換えるか、記述ごと削る。

```bash
grep -niE '/Users/|/tmp/|\$TMPDIR|/private/var/folders|api[_-]?key|token|secret' "$TMPDIR/review-comments.md"
```

特に削るもの:

- 一時ディレクトリ、ホームディレクトリを含む絶対パス、worktree の置き場所
- API キー・トークン・社内固有の URL・第三者の個人名
- ローカルブランチの試行錯誤など、レビュアーの判断に不要な作業環境情報

GitHub のコメントは削除しても編集履歴とメール通知に残る。投稿前が唯一の防波堤だと考えて扱う。

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
  --input "$TMPDIR/review-comments.json"
```

スクリプトは次を投稿前に検証する。

- input に review を submit できる `event` や review 本文が含まれていないこと
- JSON の `commit_id` が現在の PR HEAD と一致すること
- 現在のユーザーによる pending review がまだ存在しないこと
- コメントが `path`、`line`、`side`、`body` を持つこと

既存の pending review がある場合は、新規 review を作らずユーザーへ報告する。POST の成否が不明な場合も自動で再試行せず、pending review の有無を一度確認して結果を報告する。レビューの submit は常にユーザーが GitHub 上で行う。

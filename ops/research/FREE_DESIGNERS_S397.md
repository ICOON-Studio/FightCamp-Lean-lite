# Free seats for all work (S397)

Operator S397: "the designer seat can be our free agents dola, arena etc to save your tokens?" Yes for the DESIGNER role
(writing "the version that would score 8/10"). The CRITIC stays a fresh Claude sub-agent: the bar lives in the judging,
and a weak judge passes weak work. Claude reads the designer's text, keeps what it agrees with, and owns the design.

## Who, and how (all free, all scriptable from a session)
| seat | best for | how |
|---|---|---|
| Qwen (qwen3-coder) | designs that need the code: it reads the repo | write a prompt file, then `cmd /c ops\Tools\qwen_task.cmd <prompt-file> <your-worktree> <out-file>`; read the out file. Minutes. Several may run at once (API). |
| Dola (Cici app) | ideas and design text from attached docs; no repo access | `python ops/Tools/cici/cici.py status` (if down: `cici.py launch`); `cici.py open --new`; `cici.py attach --path <doc>` per file; `cici.py send --file <brief.md> --wait 900`; `cici.py read --out <file>`. ONE chat at a time: the app is shared - if another session is mid-send, wait. |
| agy (Antigravity, Gemini flash) | reading many files and writing a design doc; no shell | `agy -p "<prompt>"` run in your worktree (file tools only), or a seat_dispatch brief. |
| Cline (CLI 3.0.74, verified S397) | code drafts and code-aware design in a worktree; plan mode for design text | act: `cline -c <your-worktree> -y -t 1800 "<task or @file brief>"`; design only: `cline -p -c <worktree> -t 900 "<prompt>"`; add `--json` to capture output to a file. Runs on this PC: one at a time beside Godot work. |
| Goose (cloud, Qwen model) | whole tasks with no PC load, landing as a branch/PR | commit a TASK file, `gh issue create --label goose --body-file <TASK.md>` (workflow `.github/workflows/goose.yml`); collect branch `goose/issue-<n>` by diff only (its old stale-tree revert trap); about 3 a day, 2 in flight |
| Arena | NOT a token saver: it is driven through a browser, which costs Claude tokens per step | only for whole coding tasks that land as PRs |
| Grok bots | down (502 since S389) | - |

## The designer prompt (copy, fill in)
"You are a game designer. Here is the design (attached/path) and a critic's review that scored it N/10 (attached/path).
Write the version that would score 8/10 against shipped Steam management games: say exactly what changes and why, keep
what already works, stay inside these limits: <limits>. Plain text, under 1500 words, no code."

## Rules
- A designer never scores its own version; a NEW fresh Claude critic does, blind (no old score, no author).
- Build a part only at 8/10 from two fresh critics; re-score the built thing.
- Write each designer's output and Claude's verdict (yes / no / later, with reasons) into the session's design doc.

## Not only design (operator S397: "let them use any free agent available to save claude tokens")
Every session hands any work a free seat can do to a free seat; Claude plans, reviews, judges, merges and decides.
| work | seat |
|---|---|
| map code, find callers, read many files, summarise | agy (`agy -p`), Qwen (`qwen_task.cmd`) |
| research with sources (real-world numbers) | Dola (`cici.py`, web on), agy |
| first-draft code on files nobody else owns, with its test | Qwen (`qwen_task.cmd` or a `seat_dispatch.py` brief), Cursor (Composer 2.5, `seat_dispatch.py`, allowance permitting) |
| ideas, alternatives, "the version that would score 8" | Dola, Qwen, agy |
| log/test output digests | Ollama local (`qwen2.5:14b`, keep_alive 0, RAM permitting) |
| cloud coding task as a PR | Goose (GitHub issue, 3 a day) |
Keep: critics and judges are fresh Claude sub-agents; Claude reads every seat diff before a merge (a green seat test has
hidden unwired code and a dead harness - S396, S397); one owner per file; seats on this PC wait for the watchdog; never
send secrets or the operator's personal data to a seat.

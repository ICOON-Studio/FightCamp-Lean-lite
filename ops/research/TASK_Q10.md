# TASK Q10 — QWEN — THE MEDAL TABLE'S TEST

Model: qwen3.7-plus, effort **high**, Fast off. One session, in this checkout.

**Agent:** qwen · **Opened:** 2026-09-08

**This is your first task with a shell.** It is deliberately small: ONE new
test file, nothing modified. Take it slowly and follow the loop exactly — the
point is as much to prove the working habits as to land the file.

## Why this exists

`Godot/scripts/MedalTable.gd` landed today (G26). Nothing tests it.

R74 made every seat in an event-discipline Grand Prix produce an
`EventResult`, and `EventResult.medal_tally(results)` counts ONE athlete's
golds, silvers and bronzes. `MedalTable` is the next step up: it takes those
per-competitor tallies and produces the ordered table — a gym's trophy
cabinet, a nation's medal count, a division's.

## THE RULE THAT SHAPES THIS TASK

**Write every assertion from the CONTRACT BELOW, not from the implementation.**

A test written by reading the code only ever agrees with the code: it re-states
what the function happens to do, including its bugs. A test written from the
contract can disagree — which is the entire point, and how G23's module was
caught agreeing with an unseen test first time.

So: **do not open `Godot/scripts/MedalTable.gd` until your test is written and
saved.** Then run it. If the test fails, read the module and decide honestly
whether the MODULE is wrong or your TEST is wrong — say which in your report,
and do not "fix" a correct test to make a wrong module pass. If you do open the
module early, say so in your report; that is a smaller problem than hiding it.

## The contract

```
static func table(entries: Array) -> Array
static func rank_of(table_rows: Array, entry_id: String) -> int
static func totals(table_rows: Array) -> Dictionary
static func row_words(row: Dictionary) -> String
static func leader(table_rows: Array) -> Dictionary
```

### `table(entries)`

Each entry is a Dictionary with `id` (String), `name` (String, may be `""`),
and `gold` / `silver` / `bronze` (int). Missing keys default to `""` / `0`.
Non-Dictionary entries are skipped. Entries sharing an `id` are **merged**,
counts summed, keeping the first non-empty `name` seen.

Returns a NEW Array of NEW Dictionaries with two extra keys: `total`
(`gold + silver + bronze`) and `rank` (1-based, **shared by ties**).

**Order**: most gold first; ties broken by silver, then bronze, then `name`
ascending case-insensitively, then `id` ascending.

**Ties share a rank and the next rank SKIPS** — two competitors level on all
three counts are both `rank` 1 and the next is `rank` 3, never 2. A tie is
decided ONLY by the three counts: two competitors separated by the name or id
tiebreak still share a rank when their medals are equal.

A competitor with three zeroes is KEPT and ranked last, never dropped.

### `rank_of(table_rows, entry_id)`

That id's `rank`, or **`-1`** when the id is not in the table. Never `0`.

### `totals(table_rows)`

`{"gold", "silver", "bronze", "total", "competitors"}` summed over the rows.
No other keys; every key present even at `0`.

### `row_words(row)`

`"<RANK>. <NAME> — <G>G <S>S <B>B"`, e.g. `1. IRONSIDE GYM — 3G 1S 2B`. Name
upper-cased. When `name` is empty the `id` takes its place; when both are empty
the name section AND its `" — "` are dropped. A zero count still prints `0G`.

### `leader(table_rows)`

The single `rank` 1 row, as a copy. `{}` when the table is empty, **and `{}`
when more than one row shares rank 1** — a tied table has no leader.

## Your file

`Godot/tests/medal_table_test.gd`

Follow the house test shape exactly — copy the skeleton from
`Godot/tests/event_result_test.gd` (264 lines of module, its test is the
closest sibling to yours: a pure module, no GameState, no save, no JSON):

```gdscript
extends SceneTree

var failures := 0

func _initialize() -> void:
	await process_frame
	var Table = load("res://scripts/MedalTable.gd")
	...
	_finish()
```

**The `load()` gotcha:** a static called on a `load()`ed script returns
Variant, so `var x := Table.table(...)` is a PARSE ERROR. Always write the
type: `var rows: Array = Table.table(...)`, `var n: int = Table.rank_of(...)`.

End with a `_check(condition, message)` helper and a `_finish()` that prints
`"medal table test done, failures=%d" % failures` and `quit(1 if failures > 0 else 0)`.

**Cover at least:** the ordering including every tiebreak; the shared rank with
a skipped next rank; merging two entries with the same id; a zero-medal
competitor kept and ranked last; `rank_of` returning `-1` for an absent id;
`totals` over an empty array giving five zero keys; `row_words` with a name,
with only an id, and with neither; `leader` returning `{}` for both an empty
table and a tied one; and a non-Dictionary entry being skipped rather than
crashing.

## Owned files

* `Godot/tests/medal_table_test.gd` — **NEW. This is the only file you create.**
* `research/Q10_DIGEST.md` — short.

Touch nothing else. Do NOT edit `MedalTable.gd` even if you find it wrong —
report it instead. Do NOT edit `HANDOFF.md`; Claude writes your block.

## Gates

```bash
python Godot/tools/check_scripts.py Godot/tests/medal_table_test.gd
```

```bash
"$GODOT" --headless --path Godot --script tests/medal_table_test.gd
```

Then `smoke_test.gd`, then the full suite ONCE in the background before the
commit. The suite was **184/0** at `3b5f65c` and your new file makes it 185.
**185 or better; if it is lower, say so and push anyway** rather than holding a
good result back.

## THE TRAP

**The working tree is SHARED and live.** Claude and Cursor have uncommitted
work in it right now. `git add -A`, `git add .` and `git commit -a` would sweep
their work into your commit — on 2026-09-07 an agent's careless git wiped a
finished stage off disk. Stage explicit paths and nothing else:

```bash
git status -s
git add -- Godot/tests/medal_table_test.gd research/Q10_DIGEST.md
```

If `git status -s` shows staged paths that are not yours, STOP and report
rather than committing them. Never a bare `git stash`, `reset --hard`,
`checkout .` or `clean`.

## Start prompt

```bash
git fetch origin && git rebase origin/master && cat research/TASK_Q10.md
```

> You own Q10. The task file is self-contained: read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
> digest, and do not explore to "get oriented". Read `QWEN.md` at the repo root
> and `AGENTS.md` — those are your standing rules — then this task file. You
> create ONE new file, `Godot/tests/medal_table_test.gd`, plus a short digest.
> `Godot/tests/event_result_test.gd` is the sibling to copy the shape from;
> read it whole, it is small. **Do NOT open `Godot/scripts/MedalTable.gd` until
> your test is written and saved** — the whole value of this test is that it
> was written from the contract in the task file rather than from the code.
> Parse gate before any test, your own test first, then `smoke_test.gd`, then
> the full suite once in the background before the commit. Commit explicit
> paths only, push, write the digest, and send one line with
> `python Tools/agent_comms.py send --from qwen --to claude`. Do NOT edit
> `HANDOFF.md`. The trap: the working tree is SHARED with two other agents
> right now — `git add -A` would commit their unfinished work, so stage
> `git add -- <your two files>` and check `git status -s` first.

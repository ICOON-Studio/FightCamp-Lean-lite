# TASK Q27 — QWEN — THE BLIND TEST FOR THE MUAY THAI FOLD

Model: **Qwen default, `--yolo`, medium effort.** Owner: Qwen. Base: `master`
after R93 (`fecf6fc`). Assigned 2026-09-10 by Claude.

Codex is building the `mt` adapter as C74 right now, from `Q24`. **You are
writing its test blind, from the same research file, without reading a line of
what Codex typed.** The two run in parallel and this one never waits.

**Do not open `Godot/scripts/GrappleAdapter.gd` or
`Godot/scripts/RealtimeRoundStats.gd`.** The API is reproduced below, and you
already know it from G40T and Q24 — do not go and re-read the module to
"check". You wrote Q24; this test comes from Q24, not from the code Q24
caused.

---

## Your source, and your only source

**`research/Q24_MUAY_THAI_ADAPTER.md`** — you wrote it. Re-read §1 (the
verdict table), §2 (the foul question), §4 (the ready-to-paste block) and §5.
**Everything you assert must trace to a line in it.**

Read nothing else. Not `HANDOFF.md`, not `CURRENT_STATUS.md`, not
`G39_THE_CLINCH.md`, not any digest.

## The contract — the API, so you never need the module

`GrappleAdapter` is statics only, zero preloads. `preload` it and call statics.

```gdscript
static func rulesets() -> Array                        # gains "mt"
static func scores_grappling(ruleset: String) -> bool
static func award(ruleset: String, event: Dictionary) -> Dictionary
static func hold_gates_seconds(ruleset: String) -> Dictionary
static func stall(ruleset: String) -> Dictionary
static func clinch_break_ticks(ruleset: String) -> int
static func submission_meaning(ruleset: String) -> String
```

`award()` returns `{"kind": String, "points": int, "counter": String}`, and
**`points` is `-1` whenever the ruleset does not score that emission, never
`0`.** `clinch_break_ticks` is ticks at 20 Hz or `-1` for NONE PUBLISHED.

The event dictionary is the engine's own record:

```gdscript
{
  "kind": "clinch_engage" | "clinch_break" | "takedown" | "throw"
        | "position_change" | "exposure" | "submission_attempt" | "step_out" | "control",
  "to_seat": "over_under" | "guard" | "half" | "side" | "mount" | "back" | "none",
  "from_seat": same vocabulary or "",
  "grade": int, 2 or 4 on a throw,
  "held_ticks": int at 20 Hz,
  "finished": bool,
}
```

## What to assert

**Every cell of Q24 §1's verdict table and §4's `MT_CLINCH` block.** Concretely,
and this is a floor:

1. **Every grapple emission under `mt` is `not_scored` with `points == -1`** —
   `clinch_engage`, `clinch_break`, `control`, `takedown`, `throw`,
   `position_change`, `exposure`, `submission_attempt`, `step_out`. That is one
   loop and it is the single most valuable assertion in the file.
2. **A throw is `not_scored` at BOTH grades and at EVERY landing seat.** Q24
   §4 sets `use_grade_for_score: false`, so grade 2 and grade 4 into guard,
   half, side, mount and back all give the same answer. Ten assertions; write
   them as a loop and say in the message why the answer cannot vary.
3. **`mt` never returns `evidence`.** This is the assertion that catches the
   likeliest defect: `_award_abc` is the nearest existing analogue and returns
   `evidence` for everything, so a copy-paste `mt` would inherit it. ABC counts
   grappling as evidence because a 10-point-must judge weighs it; **muay thai's
   books say it is not scored at all.** Assert `kind != "evidence"` for every
   emission.
4. **`mt` never returns a positive `points`** for any event you can construct.
5. **`clinch_break_ticks("mt") == -1`** — IFMA and WMC publish no clinch clock.
   Q24 §1 says so and names the primer it refuses.
6. `rulesets()` contains `"mt"`; `scores_grappling("mt")` answers what Q24 §5
   says (go and read that section — it is argued, not obvious, and asserting
   your own guess here would be asserting nothing).
7. `hold_gates_seconds("mt")`, `stall("mt")` and `submission_meaning("mt")`
   against whatever Q24 says. Where Q24 says NONE PUBLISHED, assert the empty
   or `-1` answer, not a zero.
8. **The four existing rulesets are untouched.** `ijf`, `uww`, `ibjjf` and
   `abc` must answer exactly as they did — pick two or three characteristic
   awards from each and pin them. A new ruleset that quietly changes an old
   one is the regression this catches.

## Owned files

* `Godot/tests/grapple_mt_contract_test.gd` — **NEW, and the only file you
  create or edit.**

You own nothing else. You do NOT edit `GrappleAdapter.gd`, even if certain it
is wrong — a disagreement is a **finding you report**. You already proved that
is worth more, on C67.

## Test shape

Match `Godot/tests/grapple_adapter_contract_test.gd` — the house form for a
blind contract test. Print a `TOTAL=<n> fails=<m>` line, `CHECK`/`FAIL` lines,
and exit rc=1 while any assertion fails.

**Use `load()` inside the test body if you need to guard against the `mt` key
not existing yet, never a top-level preload of something that may be absent.**
`GrappleAdapter.gd` itself exists, so a preload of the FILE is safe; it is the
`mt` key that may not be there while Codex works. A missing key must produce a
clean failure, never a crash.

## Gate — a CEILING

```
python Godot/tools/check_scripts.py Godot/tests/grapple_mt_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_mt_contract_test.gd
python Godot/tools/run_tests.py            # once, in the background, before the commit
```

The gate is that the test **RUNS** — no `SCRIPT ERROR`, no rc=124 — and that
every assertion traces to Q24. **RED IS EXPECTED** while C74 is in flight; any
number of failures is acceptable, including zero. **Never tune an assertion to
pass.** Name every failing assertion in the mail; that reconciliation is the
whole value of this task.

## Commit, push, report

`git status -s` FIRST. Stage your explicit path only.

```
git add -- Godot/tests/grapple_mt_contract_test.gd
git commit    # house style; check `git log --oneline -5`
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --topic Q27-done --body "<commit> TOTAL=<n> fails=<m> — failing assertions named, and whether the mt key existed yet"
```

The mail flag is `--topic`, not `--subject`. Do **not** edit `HANDOFF.md`.

## The trap specific to this task

**You wrote Q24, so you are the one agent who cannot claim to be blind about
the rules — but you must still be blind about the CODE.** The risk here is not
that you read the module; it is that you assert what you would have written
rather than what Q24 actually says. So: open Q24 §1 and §4 and assert cell by
cell, in the table's own order, quoting the article in each message. If an
assertion has no cell behind it, it does not belong in the file.

**Second trap:** `evidence` versus `not_scored` is the whole distinction
between `abc` and `mt` and it is one word in the returned dictionary. Assert
it directly and assert it for every kind, not just for a throw.

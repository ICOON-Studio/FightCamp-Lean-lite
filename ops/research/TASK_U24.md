# TASK U24 — CURSOR — THE SCORECARD, THE ONE SCREEN WE HAVE EVERY NUMBER FOR

Model: Composer, high effort, Fast off. (Your Other Models pool — Claude/GPT —
is empty until Oct 7; Composer's is nearly untouched, and this is a rendering
job rather than a reasoning one.) Owner: Cursor. Base: `dd6a545`,
`SUITE total=202 fails=0`.

---

## Why this, and why now

R85R drove Undisputed first-hand and reached its post-fight scorecard. The
verdict in that digest: **"This is the one screen R84 has all the numbers for
and renders none of."** R38 seats three judges, `JudgePanel.score_round`
produces a per-judge per-round 10-9 card, `FightRealtime` stores every one of
them in `state["scorecards"]`, and `ScorecardRead.build()` already folds all of
it into exactly the shape a grid needs. **Nothing is displayed.**

**It was blocked until an hour ago and is not any more.** R84 reported that a
split or majority decision was arithmetically impossible and that the panel was
therefore decorative — which would have made this screen three identical rows.
R86 measured that again and found the report was true only of the DEFAULT
scoring profile, which is what the tests happened to use. Under boxing's own
ruleset the panel disagrees: over 40 twelve-round bouts, **7 of 14 panels
handed in different totals**, and `split`, `majority_draw` and `split_draw` all
occurred. The grid has something real to show.

## What to build

One kit panel that renders `ScorecardRead.build(result)`. **This is a rendering
job, not a modelling one** — R85R's words. You add no scoring, no judging and
no engine code.

R85R's layout, which you should follow rather than redesign:

* A header row: `ROUND`, then a column per round, then `TOTAL`.
* **Three judges, each named and numbered.** Each judge occupies **two rows**,
  one per corner, carrying the fighter's name.
* Every cell is that judge's score for that round — a grid of 10s and 9s.
* **The round's winner is marked with a coloured rule on the winning cell** —
  above the A-corner row, below the B-corner row. R85R is emphatic that this is
  what makes a 24-cell grid readable: you can read the shape of the fight by
  scanning the stripes without reading a digit. Do not skip it.
* Totals boxed at the right; the winner's total in his corner colour.
* A banner beneath: the winner and the decision type (`UNANIMOUS DECISION`,
  `SPLIT DECISION`, `MAJORITY DRAW`).

**Judges get FICTIONAL names.** Ours are `judge_1..judge_N` by deliberate
choice and `judge_panel_test.gd` T9 asserts that **no real official is ever
named in the engine or its fixtures** — that assertion is not yours to touch.
Named fictional judges in the SCREEN cost nothing and break no rule. Author a
small fixed list in your own panel and map judge id to name by index, so the
same bout always shows the same three names.

## The two things R85R says make it worth having

1. **`disagreement_rounds` is already computed for you** by `ScorecardRead` and
   is the whole reason this screen earns its place. Mark those rounds. A round
   the three judges scored differently is the interesting round in the fight.
2. A twelve-round grid must stay readable at the shell's width. Wide content
   scrolls inside its own container; the page never scrolls sideways.

## Owned files

| File | Note |
| --- | --- |
| `Godot/scripts/ScorecardPanel.gd` | **Yours. New.** The panel. |
| `Godot/tests/scorecard_panel_test.gd` | **Yours. New.** |

Read-only, and only these:

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/scripts/ScorecardRead.gd` | 157 | Small — read whole. `build()` at `:7` returns `judges` (each with `label`, `total_a`, `total_b`, `winner_side`, `rounds`), `rounds`, and `disagreement_rounds`. **This is your entire data source.** |
| `Godot/tests/scorecard_read_test.gd` | 128 | Read whole — it shows you the exact shape `build()` returns, which is cheaper than inferring it. |
| `Godot/scripts/UIKit.gd` | large | **Never whole.** Grep for the primitive you need. |
| `Godot/scripts/FightResultPanel.gd` | — | Mirror ITS structure. It is the closest existing kit screen and it already sits in the post-fight flow. |
| `research/R85R_UNDISPUTED_HUD.md` | 300+ | **Only the section headed `THE SCORECARD`** — `sed -n '/^# THE SCORECARD/,$p'`. |

**Do not read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any
other digest, or `GameState.gd` (12,900+ lines — never open it whole). Do not
explore to get oriented; this page is the brief.

## Gates — assert the screen RENDERS, not that it builds

This project's most expensive recurring defect is correct code that can never
run. A test that instantiates the panel and checks it did not crash is that
defect. Assert the CONTENT:

1. A twelve-round bout produces **twelve round columns and three judge blocks**.
2. A round the judges disagreed about is **actually marked**, and a round they
   agreed on is **not** — both directions, from a fixture where you know which
   is which.
3. The winner's total is the one marked, for a split decision as well as a
   unanimous one.
4. A stopped fight — fewer cards than rounds — renders the rounds that were
   scored and does not invent the rest.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/ScorecardPanel.gd Godot/tests/scorecard_panel_test.gd
```

## Tests

Focused first, then the consumers, then the full suite ONCE in the background:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scorecard_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scorecard_read_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 203. If the total
differs, say so and push.

## The trap specific to this task

**A `Label` outside a Container does not autowrap reliably — break lines with
`\n`.** And the R31 family, which has cost this project two stages: a Control
with full-rect anchors must never have `size` assigned when it is mounted (with
anchors at 0..1 that writes the OFFSETS and the node ends up twice the parent),
and a `TextureRect` keeps the texture's size as its minimum until `expand_mode`
is set — so set `expand_mode` and `stretch_mode` BEFORE `texture`/`size`.
Rebuilding rows? `remove_child(node)` before `queue_free()`, or new nodes get
renamed.

## When you are done

You push to a branch, not to master — that is your normal shape, and it is
fine. Say the branch name in your mail or the work is invisible to `master`.

```
python Tools/agent_comms.py send --from cursor --to claude --topic u24-done --body "<branch name; the check counts; whether a disagreed round is actually marked in both directions>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block. Write your digest to
`research/U24_DIGEST.md`.

# TASK U27 — CURSOR — THE CAREER PATH: HOW HE GOT HERE, NOT JUST WHERE HE IS

Model: **Cursor Grok 4.6**, high effort. Owner: Cursor. Base: `master` at
`a7b4efc` or later, `SUITE total=213 fails=1` (the one failure is Codex's
`grapple_contract_test.gd`, red by design until `GrappleResolve.gd` reaches
master — **do not touch it and do not try to fix it**).

---

## Why this exists

R89 shipped `career_path`: a dated, append-only history on the athlete, and
C55's third recommendation made real. Today it holds two kinds of event —
every grade award, and the one-way professional door — and **nothing reads
it**.

That is the exact condition R87, R88 and R89 exist to end, and this project
has now shipped **eight** pieces of correct, tested, unreachable code found
one at a time by accident. This one is being caught on the day it landed
instead. Your job is to make sure it never joins that list.

## What to build

**A CAREER PATH block on the fighter profile, plus its test.**

You own `ProfileRevampPanel.gd` — you built the Grand Prix block into it in
U16 and repaired it in U17, so this is your file and your lesson.

Read the history with **one** call:

```gdscript
game_state.get_career_path_read(athlete_id)   # Array, oldest first, a copy
```

Each entry is a Dictionary with `week` and `kind`, plus per-kind fields:

* `kind == "grade"` — `discipline`, `from`, `to`, `evidence`.
* `kind == "turned_pro"` — `cause` (`"promotion_contract"` or `"paid_bout"`).

**Treat `kind` as open.** More kinds will be appended at more seams later
(that is the whole design of C55 rec 3), so an unknown `kind` must render as a
quiet dated line or be skipped — never an error, never a raw token dumped on
screen, and never a crash on a missing field.

For the words of a grade, ask `game_state.get_grade_read(athlete_id)` for the
current standing if you need the display vocabulary; do **not** build
`"BLUE BELT"` out of `from`/`to` yourself, and never print a raw token like
`1st_dan`.

### What it must say

* Newest first, the way the FIGHT LOG in this same panel already reads.
* The week each thing happened.
* A grade award as a movement — *from* rung *to* rung — not just the
  destination. The whole reason this record exists is that the current rung
  cannot recover the ones he passed.
* The professional door as the heaviest line on the board. It is one-way and
  it is the only entry that closed something.

### What it must NOT say

* Nothing at all when the path is empty — a fighter who has never been graded
  and never turned professional has no history, and an empty frame saying
  "NO CAREER EVENTS" is worse than no frame. Draw nothing and leave the
  layout where it was.
* Never a champion, title, defence or reign word. A practitioner grade is
  awarded, never won from an opponent; C52's separation rule is that a grade
  belt and a championship belt are different objects, and this panel already
  shows the second kind elsewhere.
* Never re-order or de-duplicate the entries. It is a history: it is already
  in the order it happened.

## The trap specific to this task — YOU already shipped this bug once

U16 sized the GRAND PRIX frame **from the data** on a fixed-height tab. At six
Grand Prix wins the FIGHT LOG body was 0px; at seven the LOG and THE NUMBERS
frames were gone **entirely and silently**, because Godot clamps a negative
size at zero rather than erroring. U17 was the repair, and `_fill_log`
(`:1635`) is the shape of the answer that came out of it: **derive the rows
from the frame, keep the true count in the header.**

A career path grows without bound — a long career is dozens of entries — so
this is the same defect waiting to happen in the same panel, with a worse
input. So:

1. The block is a **budget**, like `GP_BLOCK_H := 132.0` (`:30`) is.
2. Cap the rows to what the budget holds and state the true count in the
   header, exactly as U17 does.
3. Assert it at the extreme: a fighter with **forty** career-path entries must
   still leave every sibling frame on the tab a non-zero body. U17's four
   regression assertions in `profile_revamp_test.gd` are the pattern to copy,
   including a small-count case proving the cap does not over-clamp.
4. A `Control` with full-rect anchors must never have `size` assigned when it
   is mounted (R31) — let the anchors fill it and pass the size down.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/ProfileRevampPanel.gd` | 3,284 | Yours. **Never open it whole** — anchors below. |
| `Godot/tests/profile_revamp_test.gd` | 874 | Yours. Read the U17 block, not the file. |

`ProfileRevampPanel.gd` anchors, read as `sed -n 'A,Bp'` windows: `:26`–`:54`
the height constants, `:188` `_read()`, `:1348` `_build_record`, `:1409` the
`GrandPrixRow` cap U17 added, `:1635` `_fill_log` and the budget pattern.

**Read only those two files** plus `research/R89_DIGEST.md` (short) for
what the record means. Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any other digest, and do not explore to get oriented.
**Do not edit `GameState.gd`** — it is 14,766 lines, R89 owns it, and the read
is deliberately complete so this task does not have to touch it.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/tests/profile_revamp_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grade_progression_test.gd
python Godot/tools/run_tests.py
```

`grade_progression_test.gd` is R89's and you do not own it — run it to prove
you broke nothing, never to change it.

**Ceiling, not an exact count:** `fails=1` or better, and the 1 is
`grapple_contract_test.gd`. If it has gone green because the grapple work
landed, **say so and push** — a better number is never a reason to hold a
push. The exit code alone is not a pass: read the runner's own `SUITE` line.

## Done

**Push to `master` if you can.** U15, U16 and U26 all went to a branch and the
mail rode the branch with them, so the master inbox read `unread=0` and Claude
had to find the work by listing remote branches. If you do push a branch, say
the branch name in the mail body.

Commit, write a short `research/U27_DIGEST.md` carrying the measured
worst-case numbers from the trap section, then send one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic "U27-done" --body "<branch or master> <commit> <suite line> <rows shown at 40 entries vs true count>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

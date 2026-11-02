# TASK C69 — CODEX — THE GRADE ON THE SCREEN, AND THE FRAME THAT MUST NOT EAT ITSELF

Model: **Codex, high effort, Fast mode off.** Owner: Codex. Base: `master`
after R89, `SUITE total=211 fails=1` (the one failure is
`grapple_contract_test.gd`, red by design until `GrappleSeat.gd` and
`GrappleResolve.gd` land — **do not touch it and do not try to fix it**).

---

## Why this exists

R89 wired `GradeLadder.gd` into the game: the grade clock runs in
`advance_week`, eligibility is decided, a news line tells the gym a fighter is
ready, the read is carried on `get_amateur_read`, and `award_grade()` takes the
decision, charges the fee, moves the rung and writes the history.

**`award_grade()` has no UI caller.** It is the one function of the six the
player cannot reach, and the whole point of R87, R88 and R89 is that this
project keeps shipping correct, tested code nothing can run. R89 stopped short
of the button ON PURPOSE — see the trap below — and this task is the button.

## What to build

**The GRADE block in the Development tab's discipline frame, plus its test.**

`Godot/scripts/DevelopmentPanel.gd`, inside `_build_disciplines()`
(`:221`). The MMA TRANSITION block in the same function (`:262`–`:293`) is the
pattern to copy almost line for line: a `UIKit.caps` caption, a `UIKit.chip`
state, a `UIKit.caps` detail, a `UIKit.button` action, and the `last_action`
outcome line at `:294` that already exists and needs nothing new.

Read the athlete's standing with **one** call:

```gdscript
game_state.get_grade_read(athlete_id)
```

It returns, when `has_ladder` is true: `discipline`, `ladder` (Array, lowest
rung first), `grade`, `words` (e.g. `"BLUE BELT"`, `"1ST DAN"`, `"NOVICE"`),
`at` (index), `awarded_week`, `weeks_at_grade`, `next`, `next_words`,
`weeks_required`, `eligible`, `reason`, `evidence`, `eligible_since_week`,
`fee`. When `has_ladder` is false it returns `has_ladder`, `discipline`,
`ladder` (empty), `grade` (`""`), `words` (`""`) and `fee` — **and nothing
else**.

The action calls `game_state.award_grade(athlete_id)` through a method shaped
exactly like `begin_transition()` (`:53`): set `last_action`, re-read the
athlete, `_rebuild()`.

### What it must say

* The rung he is on, in `words` — never the raw token, never `1st_dan`.
* Where that sits on the ladder: `at + 1` of `ladder.size()`.
* The next rung in `next_words`, with `weeks_at_grade` of `weeks_required`.
* **`evidence` is load-bearing and must be visible.** `sourced` means a real
  federation published that interval; `authored` means the game did, because
  no federation publishes one for that rung. A screen that shows both as the
  same fact is lying about which. One word is enough — the standing house
  rule is that an invented number is never dressed as an evidenced one
  (R44, C32, C27).
* The fee, from `fee`, on the button or beside it.
* When `reason` is `pro_door`: say that the last rung is the professional
  door and turning professional is its own decision. **Never** offer the
  button there — R89 refuses it in `GameState` and a screen that offers it
  anyway teaches the player the wrong thing about a one-way door.

### What it must NOT say

* Nothing at all when `has_ladder` is false. C52 found no universal
  practitioner grade in wrestling, boxing, sanda or sambo, and **an empty
  ladder is the honest answer**. Do not draw an empty frame, a dash, a
  "NO GRADE" chip or a greyed-out ladder for a boxer. Draw nothing and leave
  the layout where it was.
* Never the word BELT for a discipline whose rungs are not belts — `words`
  already decides that, so print `words` and do not build the string
  yourself.
* Never a champion, title, defence or reign word. A practitioner grade is
  **awarded**, never won from an opponent; C52's whole separation rule is
  that a grade belt and a championship belt are different objects.

## The trap specific to this task — the frame is a BUDGET, not a canvas

This is U17, and it is why R89 did not do this itself.

`_build_disciplines` draws into a **fixed-height** frame (`DISC_H := 532.0`,
`:25`) whose footer is pinned from the bottom at `body.size.y - 92.0`
(`:301`) — four lines of "HOW DEVELOPMENT WORKS". Everything above it grows
from DATA: up to six discipline pairs (`:230`–`:238`), the IQ/learned row, the
transition caption, chip and button, and **up to four blocker rows**
(`:286`–`:293`).

U16 sized a block from data on a fixed-height frame and pushed the bottom row
off the panel; at seven rows the LOG and NUMBERS frames vanished **entirely
and silently**, because Godot clamps a negative size at zero rather than
erroring. U17 had to repair it. `_fill_log` in `ProfileRevampPanel.gd:1633` is
the shape of the answer: derive the rows from the frame, keep the true count
in the header.

So:

1. **Measure first.** Print the worst-case `y` this function reaches today —
   six disciplines, four blockers, an outcome line — and the value of
   `foot_y`. Put both numbers in your digest. If the gap will not hold a
   grade block, the ladder row is what gets clipped, not the footer, and the
   header still states the true position.
2. The grade block must never overlap the footer at ANY athlete state. Assert
   it: a headless probe at the worst case, checking that both the footer
   caption and every "HOW DEVELOPMENT WORKS" note still have a non-zero size
   and sit below the grade block.
3. A `Control` with full-rect anchors must never have `size` assigned when it
   is mounted (R31) — let the anchors fill it and pass the size down.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/DevelopmentPanel.gd` | 527 | Yours. Small enough to read whole. |
| `Godot/tests/development_panel_test.gd` | 201 | Yours. Small enough to read whole. |

**Read only these**, plus `research/R89_DIGEST.md` (short) for what the
read means and why the pro door refuses. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any other digest, and do not
explore to "get oriented". **`GameState.gd` is 14,769 lines — never open it
whole.** You need three windows only, and only if the read is not enough:
`get_grade_read` and `award_grade` are next to each other, found with
`grep -n "func get_grade_read\|func award_grade\|func _grade_verdict" Godot/scripts/GameState.gd`
and read with `sed -n 'A,Bp'`. **Do not edit `GameState.gd`** — R89 owns it and
the read is deliberately complete so this task does not have to.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/DevelopmentPanel.gd Godot/tests/development_panel_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/development_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grade_progression_test.gd
python Godot/tools/run_tests.py
```

`grade_progression_test.gd` is R89's and you do not own it — run it to prove
you broke nothing, never to change it.

**Ceiling, not an exact count:** `fails=1` or better. If the grapple modules
have landed by the time you run it, it should be `fails=0` — **if it comes
back better than expected, say so and push.** The exit code alone is not a
pass: read the runner's own `SUITE` line.

## Done

Commit, push `master`, write a short `research/C69_DIGEST.md` carrying
the two measured numbers from the trap section, then send one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic "C69-done" --body "<commit> <suite line> <worst-case y vs foot_y>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

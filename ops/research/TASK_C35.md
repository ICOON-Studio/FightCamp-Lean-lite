# TASK C35 — THE CORNER: THE LAST UNSPENT READ GETS A SCREEN (Codex)

**Status: COMPLETE (2026-09-07).** Landed `38f2a35`. C34 is landed (`b44347d`) — this is
next, in a fresh session.

Model: top tier, effort high, Fast off. One session.

## Why this exists (verified 2026-09-07, not assumed)

The 2026-09-07 screens cycle existed because six read APIs had no caller
outside `Godot/tests/`. Five have been spent — C23 and C25 by R45, C27 and
C28 by R46, C26 by R47, C24 by R50. **One is left.**

`get_corner_rules_read()` (`GameState.gd:9946`) returns
`CornerRulesRead.build()` and is called by exactly two files: `GameState.gd`
itself and `Godot/tests/corner_rules_read_test.gd`. The player has never
seen a line of it.

The read is unusual and that is the point: `CornerRulesRead.gd` grades every
value it returns with a SOURCE — `SOURCE_INVENTED` ("invented") and
`SOURCE_ABSENT` ("absent") are constants in the file, and each value carries
a `why`. **It is a read that knows what it does not know.** The screen's job
is to show that honestly rather than to print numbers as if they were rules.

## Owned files

- `Godot/scripts/CornerRulesRead.gd` — small, read it whole. **Read only:
  do not change the module.**
- The screen you add for it, following whichever panel C30–C33 established
  for a read of this shape.
- `Godot/tests/corner_rules_read_test.gd` and your new screen's test.

**Do not touch:** `Godot/scripts/Aging.gd` (R52 is live in it),
`ProfileRevampPanel.gd` (R53 is live in it), `GameState.gd` beyond adding
nothing at all if the read already suffices.

## Second item, and ONLY after R52 has landed

R52 splits `Aging.peak_window()` / `band_for()` by sex, with the argument
DEFAULTED so your C34 code keeps compiling unchanged. Once R52 is on
`master`, thread the world's own sex through the two `Aging` calls in
`WorldPopulation.gd` — `WorldPopulation.athlete_sex(athlete)` is already the
one spelling for it. That is a two-line change and it is what makes the
world's windows right for female fighters.

**If R52 has not landed when you start, ship the screen alone and say so in
your digest.** Do not author a window of your own; there is one age curve.

## Settled

- **The grade is not decoration.** A value marked `invented` must read as
  invented and a value marked `absent` must read as absent. A screen that
  prints an invented number in the same ink as a real rule is the bug this
  task exists to avoid.
- No new UIKit factory and no new token (K10 standing, M11 standing).
- Reuse the panel grammar C30–C33 already landed. Do not invent a second
  way to draw a read.
- A Control with full-rect anchors must never have `size` assigned when it
  is mounted (R31). A `TextureRect` needs `expand_mode` before
  `texture`/`size`.
- Scene scripts compile before the autoloads: use
  `get_node_or_null("/root/GameState")` plus `has_method`, never the bare
  `GameState` identifier.
- A `Label` outside a Container does not autowrap; break lines with `\n`.

## Parse gate (before ANY test run)

```
python Godot/tools/check_scripts.py <every .gd you touched>
```

A parse error that reaches a headless test HANGS it until the timeout
instead of failing.

## Tests

```
--script tests/corner_rules_read_test.gd
```

Then your new screen's test, then the full suite ONCE in the background
before the commit.

## Done

Commit, push `master`, write `research/C35_DIGEST.md` (short), send one
line with `agent_comms.py send`. **Do NOT edit `HANDOFF.md`** — Claude writes
your block.

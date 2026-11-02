# TASK U90 — CURSOR — WHICH JOINS BREAK R5: THE TRANSITION WINDOWS BY PAIR, CUT OR FINISHED

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U80`.
Stage: S4a (transitions must read as a real fight) - a TRACE. No behaviour change.

**Test tier: ONE TEST FILE EDITED, REPORT LINES ONLY.** Parse gate on the test, then run that test once
(`fight_stage_realism_test.gd` exits rc=1 by design - read its RULE lines). No subset, no suite.

## Owned files

- `Godot/tests/fight_stage_realism_test.gd` - report lines only; no rule's gate, bound or study line changes.
- `research/U90_JOIN_PAIRS.md` - NEW, yours, 40 lines at most.

## First: park U89 (it is not lost)

In the worktree, on `cursor/u89-travel`: commit your uncommitted SEND-BACK 6 work with the paths on the commit line -
`Godot/scripts/FightStagePlayer.gd`, `Godot/scripts/FightWorldLiveScreen.gd`, `Godot/tests/fight_stage_realism_test.gd` -
message `U89 WIP (parked): watchable-gap contract, best R3 0.224 v BASELINE 0.172 - waits for the foot lock`.
`git show --stat HEAD`, `git push origin cursor/u89-travel`. U89 is PARKED, not failed: your sweep proved that moving
bodies only while a walk plays ends the slide (20,823 -> 227 frames) but short walks are mostly crossfade, so the
missing piece is a foot lock that absorbs small moves - Claude is building it. Then:
`git fetch origin && git checkout -b cursor/u90-join-pairs origin/master`.

## Why this exists

R5 and R5b are the two join rules still failing on master: a join moves the joints faster than the performance
itself (R5 worst RightUpperArm 3.42x; R5b worst LeftUpperLeg 2.09x). Nobody knows WHICH joins do it. A fix for a
punch cut by a hit is not the fix for stance into a jab, and the next build (layering a punch over a step, or longer
blends) depends on which pairs dominate.

## What to read - ONLY these

- `Godot/tests/fight_stage_realism_test.gd` (935 lines - NEVER open it whole): `sed -n '192,232p'` (`_sample`: what
  `take`, `pos`, `changed`, `seen`, `clip` hold per frame) and `sed -n '709,800p'` (`_rule_joins`: the R5 window opens
  at a take change into anything but a hit, for `TRANSITION_S` seconds; `seen` is the body's joint speed, `clip` the
  incoming take's own speed over the same frames).

## The trace (inside `_rule_joins`, report only)

For every window R5 opens (same condition, same length), record ONE row per side per window:
- `pair`: role of the take BEFORE the change (`_role_of` of `take[f-1]`, "none" if empty) -> role of the take at `f`;
- `ending`: `cut` if the take before was non-looping and its `pos[f-1]` was more than one frame (1/30 s) before its
  own length, else `finished` (a looping take - stance, walk - is always `finished`);
- for the ARM bones (LeftUpperArm, LeftLowerArm, RightUpperArm, RightLowerArm) and the LEG bones (LeftUpperLeg,
  LeftLowerLeg, RightUpperLeg, RightLowerLeg): the window's max `seen` speed and max `clip` speed, and whether any of
  those bones' seen max exceeds 1.2 x its clip max (`over`).

Print, after the R5b rule line:
1. `R5-PAIRS` table: the 15 pairs with the most `over` windows - pair, ending, windows, over windows, share over,
   worst bone, mean seen/clip ratio over the over windows.
2. `R5-ENDING` table: cut v finished - windows, over windows, share over.
3. `R5-GROUP` table: arms v legs - over windows each.

## Gate

- Parse gate on the test; run it once (PRODUCTION, no arg) through
  `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tests/fight_stage_realism_test.gd --timeout 900`.
- Every RULE line (R1-R6) must be BYTE-IDENTICAL to master's: run the test ONCE BEFORE you edit it (your new branch
  is master) and keep that log as BASELINE, then diff the RULE lines after. Only new report lines may differ.
  Never `git stash` in this shared setup.
- Digest `research/U90_JOIN_PAIRS.md`: opens with `## DECISIONS` - the three tables, the population line the
  test prints, and one sentence: which pairs and which ending hold most of the over-bound windows.
- Commit the two owned files with paths on the commit line, `git show --stat HEAD`, push `cursor/u90-join-pairs`
  (never master), mail `--topic "U90 ready"`. Do NOT edit HANDOFF.md. STOP.

## The trap

A window can open at the very first frames of a bout or right after a knockdown hold; `take[f-1]` may be empty - call
that pair's left side "none", never skip it. And a hit closes an open window early (the test's own rule) - count the
window's frames as the test does, not a fixed length.

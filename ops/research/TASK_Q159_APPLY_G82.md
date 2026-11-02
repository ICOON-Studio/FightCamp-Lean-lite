# TASK_Q159 - apply G82's lie list to the family bindings, then the striking FAMILY class (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S62, 2026-09-24, after Q158.

## Why
Q158 Part 1 found "no seat contradictions" in Q157's 190 family bindings - but it ran BEFORE
`research/G82_GRAPPLING_POSITION_TAXONOMY.md` existed. Grok's independent audit (read its
"GROK'S VERDICT" block and Section 2 whole; Section 1 only as reference) names the lies precisely:
- **bjj_5050** is the wrong picture for every leg entanglement that is not literally 50/50 (saddle,
  inside/outside ashi, SLX, sambo straight-leg entries).
- **grapple_takedown** is a neutral-to-floor film and lies for mat return, guard pull, knee-slice,
  toreando, Thai clinch dump, seoi nage / uchi mata / o soto gari (those are grapple_throw), arm
  drag, chain wrestle. Only high crotch, ankle pick and a clean double may use it.
- **mma_dirty_boxing** lies for plum, body-lock, fence ride, whizzer: strikes are a layer, not a grip.
- **grapple_sweep** lies for the upa / bridge-and-roll (an IBJJF sweep starts from guard).
- **bjj_back_control** lies for crucifix; **bjj_side_control / bjj_mount** for knee-on-belly;
  **bjj_turtle / bjj_front_headlock** for the sprawl; **grapple_stand_up** for a wall walk.
Q158 also found only 10 of the "21" holds are referenced and that PAIRED_STRIKE_BINDINGS holds 12 of
them - say in the digest exactly which keys are real paired holds today.

## Part 1 - remove the lies
For every row of `PAIRED_FAMILY_BINDINGS` (Q157), decide with G82 Section 2 in hand: KEEP (the hold
honestly shows the technique's seat), or REMOVE to a new `FAMILY_GAPS` const
(`technique_id -> {"needs": "<G82 gap-list hold>", "why": "<one line>"}`), or RE-SEAT to a different
owned hold G82 names honest. Print the counts per hold BEFORE and AFTER, and the FAMILY_GAPS table
grouped by the G82 gap rank (1 saddle/ashi, 2 knee-on-belly, 3 plum, 4 sprawl, 5 fence ride, ...).
That grouped table IS the Cascadeur authoring order with real technique counts behind it - the
thing G82 could only estimate. `q133_clip_coverage.gd` reports `FAMILY` and a new `GAP` line;
"Covered" stays EXACT+NEAR.

## Part 2 - the striking FAMILY class (Q158 deferred it; it is due now)
Build `STRIKE_FAMILY_BINDINGS` for the 186 striking NONE the way Q157 built the paired table:
technique id -> existing BINDINGS key + a one-word limb-and-line reason. Rules: a spinning technique
never maps to a non-spinning clip; a kick never maps to a punch; an elbow never to a hand strike; a
knee never to a kick; lead never to rear unless the clip has a mirror (FightClipMirror exists - a
mirrored binding is legal and is the reason lead/rear both cover). What has no honest family stays
NONE and is listed by limb and line as the striking authoring order. Wire it as the LAST fall-through
in the same seam Q157 used; the coverage tool prints `FAMILY grappling=N striking=M`.

## Owned files
`Godot/scripts/FightClipBinding.gd` (windows only; grep), the ONE seam in `FightBeatAdapter.gd`,
`Godot/tools/q133_clip_coverage.gd`, `research/Q159_DIGEST.md` (new). Nothing else.

## Gate
Parse gate on every .gd touched; `run_tests.py --only fight_hold_binding,paired_clip_mount,fight_clip_alias,fight_beat,grapple_adapter,fight_clinch_binding,grapple_naming_contract`;
coverage tool before and after both parts, pasted. No full suite. One `send` per part. Branch
`qwen/q159-apply-g82`; fresh worktree: `git fetch origin && git checkout -B qwen/q159-apply-g82 origin/master`
first; on a "TitleHonours" parse error run `--import` once. Do NOT edit HANDOFF.md.
Trap: removing a lie is the DELIVERABLE, not a failure - "unmapped 0" was the claim under test.

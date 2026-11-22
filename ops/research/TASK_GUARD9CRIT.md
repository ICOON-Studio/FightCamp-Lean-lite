# GUARD9CRIT - a code-checked critic of guard map v9 (S537)

Kind: research. Model: claude-fable-5-2 (Agent SDK, API credit). RESEARCH ONLY - no game code changes, do not run Godot.

## Your job
Read `ops/research/DESIGN_GUARDDMG1_V9_CRITIC_KALLI.md` - the full critic brief (the critic pack, then the map). Do what it
asks (DEPTH / GENERAL DESIGN / PLAY /10, missing and useless options, the "To reach 10/10" list, your 10/10 page described),
plus three things a chat critic cannot do:

1. CHECK EVERY "CODE" CLAIM in `ops/research/DESIGN_GUARDDMG1_V9.md` (each `File.gd:line`) against scripts/: TRUE (file +
   function + line) / FALSE (what the code does) / NOT FOUND. Do not cite by line LineGrade.gd, LiveRound.gd, StepWire.gd,
   MHRig.gd (other sessions' uncommitted edits).
2. CHECK THE PROBE: `tools/guardprobe10.gd` against the map and `docs/GUARDPROBE10_RESULT.md`. Does it model what the map says
   (guard lines only on the opponent's moments, three guards with their feet, the moved stance "not owned yet")? Are the
   controls fair? Is anything true by construction?
3. CHECK THE ONE FAILED BAR (bar 4: only 1-2 of 10 opponent cells clear when the seven boxers are pooled). The probe's reading:
   the right guard differs by natural stance, so the pooled best is an average of three answers; by boxer 7 of 7 are clear.
   Is that a real depth (the player reads HIS boxer x THIS opponent) or noise dressed up? Does the player have the information
   on screen to make that read? Score what is measured, not what is promised.

## Deliverable
ONE new file `ops/research/DESIGN_GUARDDMG1_V9_CRITIC_FABLE.md`: scores (bar 8 DEPTH and 8 PLAY, owner S534), the code-claim
table, the probe check, the bar-4 verdict, the 10/10 list (most important first, specific enough to build), and the code
files you opened.

## Prior research
docs/GUARDPROBE9_RESULT.md, docs/GUARDPROBE10_RESULT.md, ops/research/DEPTH_AUDIT_S534.md (maps that passed critics and failed
when measured).

## What would a human do?
Open every cited line before believing it, and ask whether a manager would really change the guard for this opponent.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_GUARDDMG1_V9_CRITIC_FABLE.md
`git add -- <file>` then `git commit -m ... -- <file>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push,
report in two lines, stop.

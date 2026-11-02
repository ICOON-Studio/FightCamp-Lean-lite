# TASK Q203 - QWEN - THREE REALISM REDS THAT ARE NOT PINS (S99)
Owner: qwen. Assigned 2026-09-27 (S99). Model: qwen3-coder medium, `--yolo`. Branch `qwen/q203-realism-reds` from
`origin/master`. Claude merges. **Launch after Q202 lands (two-agent cap).**

## Why
Q199 (`Q199_DIGEST.md`, branch qwen/q199-red-triage) named culprits for 17 nightly reds. Claude's ruling (S99): these
three are realism checks against real bands, so they are DEFECTS and never re-pinned:
1. `boxing_output_test` - jab share 20.4%, outside G99's band. Culprit 792e84e4 (Q192 plan separation,
   `ROLE_PRIORITY_FROM_PLAN`).
2. `fight_ring_position_test` - RULE R16 `cut_off_closes_the_gap` fails. Culprit 14c1955f (Q186 KB head damage).
3. `fight_defence_model_test` - landing order head < body < legs: legs do not land more often than body
   (LR 0.529/0.538/0.531). It fails with footwork_economy OFF too (Q201), so it predates Q183. Find its commit.
(Do not touch feint bites in the same test. That row is Cursor's U191.)

## What would a human do?
A boxing analyst knows the jab is the most-thrown punch (CompuBox puts it at roughly a third or more of punches thrown).
A pressure fighter still cuts the ring off. A defence coach knows the legs are the least-defended target. The engineer
finds the exact change in the culprit commit that moved each number and repairs the mechanism, not the band. Read G99
and the R16 rule's own comment for the real figures before touching anything.

## Do
For each: reproduce it, then revert the culprit's relevant hunk LOCALLY to confirm it is the cause (the control arm).
Then fix forward with the smallest gated change. Print before/after with the population named (never identical fighters).

## Gate (a CEILING)
Each of the three is green or explained.
`python Godot/tools/run_tests.py --jobs 2 --only boxing_,fight_ring_position,fight_defence_model,fight_realtime,plan`
must be no worse than master, apart from the rows you turned green. Parse gate. Never the full suite.

## Owned files
`Godot/scripts/FightRealtime.gd` (~6,300 lines - never open it whole; grep, then read `sed -n` windows). Also the plan
script, if the culprit hunk lives there (grep `ROLE_PRIORITY_FROM_PLAN` to find it). Plus `Godot/tools/q203_*.gd` and
`research/Q203_DIGEST.md`.

## Deliver
Commit explicit paths, push the branch, write `Q203_DIGEST.md`, then run
`python Tools/agent_comms.py send --from qwen --to claude --topic Q203 --body "<three rows before/after>"`.
Do NOT edit HANDOFF.md. All research is open: RESEARCH_INDEX.md.
**Trap:** Q192's plan separation is wanted (plans must differ). Keep it and fix how it starves the jab.

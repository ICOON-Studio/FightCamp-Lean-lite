# TASK Q194 - QWEN - PLAN ROLES FOR BOXING ONLY, EVERY OTHER RULESET BYTE-IDENTICAL (S92)
Owner: qwen (CLI in its worktree, `--yolo`). Assigned S92, 2026-09-26. Model: qwen3-coder, medium.

## Why
Your Q193 (research/Q193_DIGEST.md) flipped `ROLE_PRIORITY_FROM_PLAN` globally. Claude did NOT merge the flip:
the bar was "all three anchors hold", and kickboxing pace FELL 6.26 -> 5.17 /min (anchor 6.85, J20) - further from
real. No subset tests were run either. But boxing is a clear win: plan separation 1/6 -> 6/6, D3 head 53.6% -> 63.6%
(J20 band 61-65), knockdowns 0.05 -> 0.13 per fighter-fight toward the anchor, pace only 5.56 -> 5.35. So: turn it on
where it helps, and prove nothing else moves. Master has your instrument (`tools/q193_anchor_measurement.gd`) and
digest; the flag is `false` on master.

## What would a human do?
A game designer who finds a rule that makes one sport truer and another less true scopes the rule to the sport - the
boxing coach's game plan shapes his punch selection; a kickboxing plan already works through the kick palette.

## The work
1. Replace the global const with a per-ruleset switch in `FightMoves.gd` (e.g. `ROLE_PRIORITY_RULESETS := ["boxing"]`
   and a helper `role_priority_on(ruleset)`), threaded to where `select()` decides (`FightMoves.gd:508-620`; find how
   the caller knows the ruleset - pass it in, do not read a global).
2. Re-run your instrument: boxing ON must reproduce Q193's boxing ON numbers (separation >= 5/6, head in 61-65,
   knockdowns not lower than OFF, pace >= 5.2/min). Print the numbers beside their bands.
3. **Kickboxing and MMA must be BYTE-IDENTICAL to master** - same seed, same fighters: hash the full fight log (see
   `tools/s70_feint_off_hash.gd` for the pattern) on master and on your branch, 3 seeds each ruleset, print both hashes.
   Never identical fighters (a kicker vs a puncher in KB, a grappler vs a striker in MMA; name the population).

## Owned files
`Godot/scripts/FightMoves.gd` (1,685 lines - never open it whole; windows `:100-140` and `:500-630`), the caller that
passes the ruleset (find it with rg `Moves.select(`), `Godot/tools/q194_*.gd`, `research/Q194_DIGEST.md`.

## Gate (tier: a script edited)
Parse gate on every touched .gd; then
`python Godot/tools/run_tests.py --jobs 2 --only fight_moves,fight_plan,broadcast,fight_simulation,fight_realtime,knockdown,judge_panel,grapple_adapter`
on master FIRST, then on your branch - fails no worse than master's (a ceiling: fewer is fine, say so). Paste both
SUITE lines in the digest.

## Deliver
Commit on branch `qwen/q194-boxing-plan-roles`, push, write `research/Q194_DIGEST.md`, send one line with
`python Tools/agent_comms.py send`. Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** Q193 reported the gate as "parse gate PASS" - that is not the gate. The subset run on BOTH trees is the gate;
a digest without the two SUITE lines is not a delivery.

# TASK Q193 - QWEN - FLIP ROLE_PRIORITY_FROM_PLAN, MEASURED AGAINST ALL THREE ANCHORS (AND THE EMPTY-ID THROWS) (S91)
Owner: qwen. Assigned S91, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q193-plan-roles`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-Q164` (`git fetch origin && git checkout -B qwen/q193-plan-roles
origin/master`). Lane: engine (agents own it).

## Why
Your Q192 (merged S91, `research/Q192_DIGEST.md`) found the root cause: `FightMoves.gd:112`
`ROLE_PRIORITY_FROM_PLAN := false`, so a plan's PRIMARY/SECONDARY roles never reach technique selection and only
pace moves. Boxing 4/6 plan pairs distinct, kickboxing 2/3. The flag's own comment says it moves the D3 split, the
pace and the knockdown anchors at once and must be measured on all three before it is flipped. **You measure it.**
Second finding in the same census: **1,819 of 2,343 MMA throws (78%) carry an EMPTY technique id** - the engine's
fallback path. Find which path emits them and whether they are real strikes with a lost name.

## What would a human do?
A fight analyst checks a game-plan change the way a corner does: does the out-boxer now actually jab more and the
pressure fighter throw more power, and did the whole fight (volume, knockdowns, how often it goes the distance)
stay inside what real bouts look like? One change, both arms, every anchor, before anyone calls it better.

## Do
1. Run `tools/q192_plan_separation.gd` for boxing / kickboxing / MMA with the flag OFF (control arm) and ON. Report
   distinct pairs beside the noise floor both ways.
2. With the flag ON vs OFF, measure the three anchors the comment names: the D3 split, the pace (output/min), the
   knockdown rate (see the knockdown-rate definition recorded in RESEARCH_INDEX.md: per fighter-fight). Use the
   existing tools that report them (grep `tools/` for `d3`, `knockdown`, `pace`); name the population and catalogue in
   the output (NEVER identical fighters; legal for the ruleset - a kicker vs a puncher in kickboxing, both able to kick).
3. The empty ids: trace where a throw with `technique_id == ""` is emitted (FightMoves / FightRealtime / the pair
   script), say what those throws are, and fix the naming if they are real strikes. Re-run `tools/q192_mma_jab_census.gd`.
4. If all three anchors hold within their bands with the flag ON and separation improves: flip it ON. If an anchor
   breaks, leave it OFF and say by how much and which constant would need to move.

## Owned files
`Godot/scripts/FightMoves.gd` (1,685 lines - never open it whole; windows around `:100-140` and the selection walk),
the emitter you find for step 3, `Godot/tools/q193_*.gd`, `research/Q193_DIGEST.md`.

## Gate (tier: a script edited)
Parse gate on every touched .gd; then `python Godot/tools/run_tests.py --jobs 2 --only fight_moves,fight_plan,broadcast,fight_simulation,fight_realtime,knockdown`
- fails no worse than master's (compare with the same command on master first). Separation and all three anchors
printed ON beside OFF in the digest.

## Deliver
Commit, push the branch, write `research/Q193_DIGEST.md`, send one line with `python Tools/agent_comms.py send`.
Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** a monotone check does not prove a rate - print the knockdown number itself beside its band, ON and OFF.

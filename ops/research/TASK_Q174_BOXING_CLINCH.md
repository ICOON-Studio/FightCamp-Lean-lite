# TASK Q174 - QWEN - THE BOXING AND KICKBOXING CLINCH (holding, and the referee's break)
Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S74 end, 2026-09-25. Engine lane. Builds ON Q173.

## Why
Q173 pass 2 found boxing and kickboxing fight with almost no clinch (~0.3 entries a fight: low grapple stats x a low
base rate, no ruleset gate). Real boxers hold - to rest, to smother a puncher, to stop a combination - and the referee
calls "break". Kickboxing permits a brief clinch (rules vary by organisation). The engine has no holding at all there.

## What would a human do? (answer this in the digest BEFORE any constant)
Who holds in boxing and why (the tired man, the out-boxer smothered by a pressure fighter, the hurt man buying time);
what happens inside (short shots, leaning, tying the arms); how the referee breaks it and how fast; what the rules
allow in kickboxing (K-1 style one knee then break vs. no clinch) and Muay Thai (the full plum). Sources: J20, K38,
J32, J38, any CompuBox/referee-guideline figure; NOT FOUND is a result.

## The work
1. Measure first on the Q173 branch: boxing and kickboxing entries/fight, mean duration, time share.
2. A HOLD for boxing that is not the MMA clinch: short, broken by the referee after a sourced/PROXY number of seconds,
   entered by who needs it (fatigue, hurt, being out-worked at range) - never a flat rate. Kickboxing per its rule.
3. Anchors (ceilings): any SOURCED holding share or duration for boxing; if NOT FOUND, report the behaviour and mark
   every constant PROXY with its basis. D1 for boxing stays in its band; MMA numbers from Q173 unchanged (hash it).
Population: never identical fighters; an out-boxer vs a pressure fighter, legal for the ruleset; print it.

## Owned files
`Godot/scripts/FightRealtime.gd` (~5,850 lines - grep -n "clinch" then sed -n windows), `Godot/tools/q171_pace_decompose.gd`,
`research/Q174_DIGEST.md`; tests only to re-pin with a one-line reason each.

## Gate (tier: script edited)
Parse gate first; then ONE `--only` per run for fight_pace, fight_realtime, feint, judge, clinch, ground. MMA OFF hash
unchanged vs Q173; boxing/kickboxing hashes change only because of the hold - say so.
Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-Q164`: `git fetch origin && git checkout -B qwen/q174-boxing-clinch origin/qwen/q173-clinch-duration`.
Commit explicit paths, push, `python Tools/agent_comms.py send --from qwen --to claude --topic Q174 --body "<entries, duration, share, anchors, hashes>"`.
Do NOT read HANDOFF.md or CURRENT_STATUS.md. Research is open via RESEARCH_INDEX.md.

## The one trap
Q172 and Q173 both tuned constants until a share landed. A hold that exists only to make a percentage appear is the
same fit: the hold must be CAUSED by fatigue, damage or being out-worked, and the digest must show that link.

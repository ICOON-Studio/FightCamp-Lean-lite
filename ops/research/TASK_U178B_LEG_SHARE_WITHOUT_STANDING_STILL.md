# TASK U178B - CURSOR - MMA LEG SHARE 12-18% WITHOUT STANDING STILL (queued; launch after U179 lands)
Owner: cursor. Assigned 2026-09-26 (S83). Model: Composer, medium, `-p --force --trust`. Branch `cursor/u178b-leg-share-moving`.

## Why
U178 (yours) lifted MMA significant leg share 6.3% -> 13.5% by multiplying leg regions at LONG/MID in
`FightMoves.select`. Claude merged it and the subset caught a regression: `fight_footwork_economy_test` MMA ON fell
**14.6 -> 11.2 m/min** against its floor of 12. Control run (the pre-merge `FightMoves.gd` + `FightRealtime.gd`, same
test, same machine): 14.6. So the reweight is the cause. **Master carries a revert of the U178 merge (commit 354cf4f9).**

## What would a human do?
A UFC striking coach does not trade movement for leg kicks: the low kick is thrown OFF the movement - step, kick, step
out. A fighter who stands at kicking range planting to throw is the one who gets taken down. So the fix must keep both
numbers inside their real bands at once: leg share 12-18% of landed significant strikes (J20 D3, UFC) AND MMA footwork
>= 12 m/min (the Q183 anchor).

## The work
1. Branch from master, then `git revert 354cf4f9` to restore your U178 work (code, census tool, digest).
2. Find WHY more leg kicks cost movement: is it kick recovery time, a range hold at LONG/MID, or fewer steps chosen
   while a kick is live? Measure it with your census tool plus the footwork economy numbers - name the stage, with the
   divisor, before changing anything.
3. Fix at that stage. Both gates must pass: `fight_realtime_test` C85 leg share 12-18% and
   `fight_footwork_economy_test` MMA ON >= 12 m/min. Do not lower either floor.

## Owned files
`Godot/scripts/FightMoves.gd`, `Godot/scripts/FightRealtime.gd` (MMA selection / footwork only),
`Godot/tests/fight_realtime_test.gd` (C85 block only), `Godot/tools/u178_leg_share_census.gd`,
`research/U178_DIGEST.md` (append a U178B section).

## Tier
Parse gate on touched files, then `python Godot/tools/run_tests.py --only fight_realtime,fight_footwork,fight_scoring,fight_stage --jobs 2`.
Ceiling: the subset may only fail what it failed on master before your change - on 2026-09-26 that was
`fight_scoring_test`, `fight_stage_realism_test`, and six JUDO rows inside `fight_realtime_test` (throw_points_round,
yuko, pinned ippon seeds) which pre-date U178. Fewer is better; say so and push.

## Research
All research is open: root `RESEARCH_INDEX.md`. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.
`FightRealtime.gd` is large - read `sed -n` windows around `MMA_LEG_REGION_SELECT_MULT` and the footwork economy block,
never the whole file.

## Done
Commit, push your branch, `python Tools/agent_comms.py send --from cursor --to claude --topic U178B --body "<leg %, m/min>"`.

## The trap
Lowering `MMA_LEG_REGION_SELECT_MULT` until m/min crosses 12 and leg share sits at 12.0% passes both gates and fixes
nothing. Name the mechanism first; a knob tuned to straddle two floors is the failure.

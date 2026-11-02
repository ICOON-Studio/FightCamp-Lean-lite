# TASK U178 - CURSOR - MMA LEG-STRIKE SHARE 5% AGAINST THE UFC'S 16%
Owner: cursor. Assigned S82, 2026-09-26. Model: Composer, medium, `-p --force --trust`.
Branch: `cursor/u178-mma-leg-share` (worktree `%TEMP%\FightCamp-U171`, reset onto origin/master).

## Why
Q183 (`research/Q183_DIGEST.md`, MMA table) measured landed **leg share 5.1% (footwork OFF) / 4.8% (ON)** of
significant strikes, 90 bouts per condition. G108 (`research/G108_FINISH_RATES.md` section 1, last paragraph)
sources UFC **head 64 / body 20 / legs 16** of significant strikes landed, leg volume ~14 per fight (2021). Footwork
economy is now ON for every ruleset (Q183 merged), so the fix must hold with it ON. Kickboxing reads 10% and is not
this task.

## What would a human do?
An MMA striking coach knows leg kicks are thrown from kicking range, as counters to a planted lead leg, and as the
cheap low-risk strike used when the opponent's hands are high. A data analyst counts kick ATTEMPTS by distance band
and by target before touching weights: is the leg kick never chosen, chosen but out of range, or thrown and mostly
missed/checked? Fix the stage that loses them.

## The work
1. Instrument: copy `Godot/tools/q183_footwork_full_census.gd` to `Godot/tools/u178_leg_share_census.gd`, MMA only,
   same 3 matchups x 30 seeds. Per bout: kick attempts by target region and by distance band, landed/checked/missed per
   target, leg share of landed significant strikes, leg strikes landed per bout (UFC ~14). Label every divisor.
2. Find where legs are lost. Anchors: `Godot/scripts/FightRealtime.gd:796-840` (region weights, `left_leg`/`right_leg`
   0.06; boxing's zeroed legs at :823), `:2497` / `:2528` `_region_bias(plan)`, and the comments at :169 and :499 that
   record earlier leg-share shifts (8% -> 5.5%). Also `Godot/scripts/FightMoves.gd` (1,533 lines, windows only) for
   which techniques target legs.
3. Fix the mechanism (MMA-scoped or plan-scoped, not a blanket weight bump that also moves kickboxing). Target: landed
   leg share 12-18%, head stays the majority. CEILING gate: if it lands lower but moved toward the band, say so and push.
4. Test: extend `Godot/tests/fight_realtime_test.gd`'s MMA leg-share check (read it first; bound the value).

## Owned files
`Godot/tools/u178_leg_share_census.gd`, `research/U178_DIGEST.md`, the region/intent code you change in
`FightRealtime.gd` (NEVER open it whole - `sed -n 'A,Bp'` windows) / `FightIntent.gd` (216 lines, read whole) /
`FightMoves.gd`, and the leg-share check in `fight_realtime_test.gd`. Qwen works on kickboxing STOPPAGES in the same file
in parallel (Q184): stay out of the stoppage/knockdown code (:270-:340, :1500-:1830).

## Fixtures
Never identical fighters; both MMA fighters legal and able to kick; differentiate by style and attributes (grappler vs
striker, as R133). Name the population in the output.

## Tier
Parse gate (`python Godot/tools/check_scripts.py <files>`), the focused test, then
`python Godot/tools/run_tests.py --only fight_realtime,fight_stage,fight_footwork,fight_scoring --jobs 2`. NO full suite.
Commit after each step.

## Research
Open to all: root `RESEARCH_INDEX.md`. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit, push your branch, then
`python Tools/agent_comms.py send --from cursor --to claude --topic U178 --body "<where legs were lost + leg share before->after + KB leg share unchanged?>"`.
Do not edit HANDOFF.md.

## The trap
Q180's MMA flip already showed leg share is sensitive to range dynamics: raising the leg weight while kicks cannot reach
kicking range buys misses, not landed leg strikes. Count by distance band first.

# TASK Q205 - QWEN - WHERE OUR MMA FIGHT SPENDS ITS TIME, AGAINST G138 (S102)
Owner: qwen. Assigned 2026-09-27 (S102). Model: qwen3-coder medium, `--yolo`. Branch `qwen/q205-mma-state-share` from
`origin/master`, own worktree. Claude merges.

## Why
G138 (`research/G138_MMA_FIGHT_STATE_TIME_SHARE.md`, Grok, sourced to FightMetric/Kuhn) gives the real clock:
distance ~50-52%, clinch ~15-18% (most of it on the fence), ground ~25-32%; ground seats guard 40-50% of ground, half
20-25, side 10-15, mount 8-12, back 8-12; takedowns 1.5 attempts per 5:00 with 39% landing; stuffed shots go 25-35%
reset, 25-35% fence clinch, 15-25% front headlock, 10-15% turtle. Nobody has measured our engine against this. The
engine is the product; if it spends 70% of an MMA fight standing, every system downstream (scoring, corner, result
screen) inherits the error.

## What would a human do?
A FightMetric analyst codes position every second of the tape (distance / clinch / ground, and the ground seat with who
is on top), counts takedown attempts and where each failed one ends up, then compares the division to the league
table. The engineer then finds WHICH transition makes the engine's clock wrong (too few shots? clinches broken too fast?
stand-ups too early?) and moves that lever, not the final share.

## Prefab check
None applies: this measures our own engine. Data is already collected (G138). Reuse existing census tools before
writing new ones: `Godot/tools/q168_*`, `Godot/tools/q172_*`/`q173_*` (clinch volume/duration), `Godot/tools/q204_*`
(funnel pattern). `BroadcastRead.gd` already folds stance from the log (`last_stance`, grapple kinds) - read it first.

## Do
1. Census, 40 seeds, MMA 3 x 5 min, a DIFFERENT pair in each of THREE matchups (never identical fighters; name every
   population in the output): striker vs grappler, grappler vs grappler of different frames, striker vs striker of
   different reach/power. Both men legal MMA palettes. Report per matchup and pooled with 95% CIs:
   distance / clinch / ground share of the clock; ground seat split with top/bottom; takedown attempts per 5:00 and
   landed share; destination of every failed shot.
2. Name the largest gap to G138 (pooled, CI clear of the band) and find the transition behind it with a CONTROL ARM
   (change that lever alone, show the share moves and nothing else does).
3. Fix that one lever, gated to rulesets that allow ground, so boxing/kickboxing stay byte-identical (print hashes on 4
   seeds each before/after). Target: the gap you picked lands inside G138's band or closer; a CEILING gate - say which.
Do NOT build the missing states (fence clinch, one-down, front headlock) - that is a later task; just report how much
clock our engine gives to whatever currently stands in for them.

## Gate
Research half: no gate. Engine half: parse gate, then
`python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,grapple,fight_defence` no worse than master except pins
your change moves (list them; Claude re-pins). Never the full suite. Check the PC first:
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` - exit 1 means stop and say so.

## Owned files
`Godot/scripts/FightRealtime.gd` (~6,550 lines - never open it whole; grep `takedown_attempt`, `clinch`, `_grapple_ground`,
`stand_up`, then `sed -n` windows), `Godot/tools/q205_*.gd`, `research/Q205_DIGEST.md`. `BroadcastRead.gd`
(~330 lines) may be read whole.

## Deliver
Commit and push AS YOU GO. Digest with the census table first, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q205 --body "..."`. Do NOT edit HANDOFF.md. All
research is open: root `RESEARCH_INDEX.md`. **Trap:** a stance share read off the log must weight each state by the
TIME it lasted (tick spans), not by the number of events - a busy clinch prints many events in few seconds.

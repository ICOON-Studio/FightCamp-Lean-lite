# TASK Q180 - QWEN - SHOULD THE FOOTWORK ECONOMY BE ON BY DEFAULT? (measurement)
Owner: qwen. Assigned S81, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch: `qwen/q180-footwork-default`.

## Why
Your Q178 (merged S81) made the footwork economy honest against G100's bands - bursts and holds - but it is still
**OFF by default** (`FightRealtime.gd:957`, `options.get("footwork_economy", false)`), so the game the operator plays does
not use it. Flipping it changes every fight, so the flip needs its knock-on effects measured first: does the fight still
land on the anchors the engine already meets when the feet move this way?

## What would a human do?
A fight-sim designer does not ship a movement change because its own metric improved; they check what it did to
everything downstream - strikes thrown and landed, clinch time, knockdowns, finishes, round scores - against the real
numbers, on real matchups, and only flip the default when nothing else broke. Do exactly that.

## The measurement (a new tool, no shipped script edited)
`Godot/tools/q180_footwork_default_census.gd`: the same seeded bouts run twice, economy OFF and ON, for each ruleset
(boxing, kickboxing, MMA), with **legal, differentiated fighters** (CLAUDE.md: never identical fighters; a boxer never
in a kickboxing bout; differentiate by style and attributes inside the ruleset - e.g. counter-puncher vs pressure
fighter; outside kicker vs pressure puncher; grappler vs striker). At least 20 seeds per ruleset. Print, per ruleset,
OFF vs ON side by side:
- your Q178 footwork bands (burst p50, hold p50, m/min) - they must still pass ON;
- strikes thrown and landed per round, land %, significant strikes;
- clinch share of fight time, knockdowns per fight, finish rate (KO/TKO/SUB), decision rate, draws;
- any anchor the existing tests already gate (find them: `grep -rn "anchor\|G100\|J20" Godot/tests/fight_*`).
**Name the population in the output** (the fighters, the rulesets, the catalogue) - CLAUDE.md requires it.

## Verdict (in `research/Q180_DIGEST.md`)
One line: FLIP / DO NOT FLIP / FLIP FOR <rulesets> ONLY, with the numbers that decide it. Say which downstream number
moved most and whether it moved toward or away from its real anchor. You do NOT flip the default in this task.

## Owned files
`Godot/tools/q180_footwork_default_census.gd`, `research/Q180_DIGEST.md`. Nothing in `Godot/scripts/` is edited.
Read windows of `FightRealtime.gd` (large - grep -n and sed -n 'A,Bp', never whole) around `:957`, `:1246`, `:2922`.
Your own `Godot/tools/q176_decompose_travel.gd` and `Godot/tests/fight_footwork_economy_test.gd:139-160` show how to run a
bout with the option set.

## Tier
Parse gate on your tool: `python Godot/tools/check_scripts.py Godot/tools/q180_footwork_default_census.gd`. Then run the
tool headless. No test suite. One Godot at a time; the PC runs hot.

## Done
Commit on `qwen/q180-footwork-default`, push, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q180 --body "<one line: verdict + the deciding number>"`.
Do not edit HANDOFF.md.

## The trap
A counter that cannot move reads as "unchanged". Before you report any row as unchanged OFF vs ON, grep the engine for
the exact event string your counter filters on and prove it fires at least once.

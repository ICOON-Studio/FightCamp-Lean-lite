# TASK U172 - CURSOR - THE DEFENDER MODEL, SLICE 1: read, choose, place the guard, time it
Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S74, 2026-09-25. Engine lane.

## Why (operator, 2026-09-25, verbatim)
"the defender logic is this : he either choose to block or dodge, is there anything other inbetween ? how succesful he
is depends on how fast and agile is to doge and Dodge opens possible weakness ... Block should be placed at the right
timing, and decision where to block(head,body,legs)" and "the defnder, also should to chose to anticipate and counter".

## What would a human do?
ANSWERED in `research/J50_HOW_A_DEFENDER_DEFENDS.md` §1 (read it, and §2, §3, §4, §5, §10). A fighter READS the
tell (~405 ms jab tell-to-contact, 300-400 ms realistic defence), picks from eight families, and a guard in the wrong
place is a clean hit - the body shot under a high guard. Build what that section describes, not a new invention.

## Today (read these windows, never the whole file)
`Godot/scripts/FightRealtime.gd` (~5,850 lines). Pre-contact evasion `:2655-2720` (one roll on `defense` x fatigue,
picks a movement guard, blow becomes `slipped`). At-contact answer `:3440-3500` (roll `DEFENSE_BASE + DEFENSE_SPAN *
defense` turns clean->absorbed/blocked, glancing->slipped). Guard kinds `FightMoves.gd:1201-1225`. Missing: speed or
agility deciding a dodge; guard HEIGHT (head/body/legs); TIMING (early/right/late); a dodge costing position; a block
costing arm wear / stamina / a busy hand.

## Slice 1 (this task) - behind a NEW switch `defence_model`, default OFF
1. PERCEIVE: P(he reads it) from reaction (speed stat), fight IQ, fatigue (J50 §3: fatigue RT 145->223 ms), and the
   strike's tell time (J50 §3 per strike). Not read = no defence (the "never saw it" family).
2. CHOOSE: family among block / evade / reduce(roll) weighted by style + stats; BLOCK picks a HEIGHT (head/body/legs)
   from what he expects; wrong height = the blow lands as if unguarded.
3. EXECUTE: evade success from agility/speed vs strike speed; block timing early/right/late -> blocked / absorbed /
   clean (J50 §4 block bleed-through where SOURCED, else PROXY and labelled).
4. CONSEQUENCE: a successful evade leaves an opening flag for the attacker's NEXT strike by type (J50 §5 risks); a
   block spends a little stamina. Counters and anticipation are SLICE 2 - leave a clearly named hook, build nothing.
Every constant named, with a comment SOURCED (J50 §x, source) / PROXY / AUTHORED.

## Anchors (ceilings, not exact) - measured ON vs OFF, 60+ bouts per arm
UFC sig-strike defence median 55.3% (J50 §8, UFCStats COUNT) -> the pooled defence rate ON lands within 45-65%;
head/body/leg landing order head < body < legs (J50: 36.5 / 69.2 / 80.4%). D1 stays 6.0-8.0.
Population: NEVER identical fighters; MMA grappler vs striker and boxing out-boxer vs pressure fighter, both legal
for the ruleset; print the population in the output.

## Owned files
`Godot/scripts/FightRealtime.gd`, `Godot/scripts/FightMoves.gd` (guard windows only), a new
`Godot/tools/u172_defence_measure.gd`, a new `Godot/tests/fight_defence_model_test.gd`, `research/U172_DIGEST.md`.

## Gate (tier: script edited)
Parse gate on every touched .gd first. Then the new test, then `python Godot/tools/run_tests.py --only <x>` one at a
time for fight_realtime, feint, judge, fight_pace, fight_hit. With `defence_model` OFF, boxing/kickboxing/MMA hashes
from `Godot/tools/s70_feint_off_hash.gd` byte-identical to master (paste both). Prove the test with a mutant.
Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-U171`: `git fetch origin && git checkout -B cursor/u172-defender-model origin/master`.
Commit explicit paths, push the branch, then
`python Tools/agent_comms.py send --from cursor --to claude --topic U172 --body "<defence rate ON/OFF, landing by zone, D1, hashes, test>"`.
Do NOT read HANDOFF.md or CURRENT_STATUS.md. All research is open: RESEARCH_INDEX.md.

## The one trap
Q172 tuned one rate until a share matched. Do not tune a single defence probability until 55.3% appears: the rate must
EMERGE from read + choice + placement + timing. Report the decomposition (read %, family split, wrong-height %,
timing split) so a reader can see where the number came from.

## PASS 2 (S74 end) - FINISH THE GATE ON A TREE THAT COMPILES
Pass 1 (daaee9da) ran only its own test: `run_tests.py --only fight_realtime` failed on "RawAsset not declared". That
was CLAUDE'S defect, not yours - `RawAsset` was a class_name, unknown in a worktree whose untracked class cache predates
it. Fixed on master (explicit preloads, no class_name). Now: rebase on origin/master, then run the gate the task names
- `--only` fight_realtime, feint, judge, fight_pace, fight_hit one at a time, and the boxing/kickboxing/MMA OFF hashes
from `s70_feint_off_hash.gd` before/after pasted in the digest - plus the J50 anchors ON vs OFF (defence rate 45-65%,
head < body < legs landing) with the decomposition. Report numbers, not "focused gates passed".

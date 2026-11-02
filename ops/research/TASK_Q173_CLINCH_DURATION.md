# TASK Q173 - QWEN - CLINCH DURATION (the time share Q172 could not reach)
Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S74, 2026-09-25.

## Why
Q172 doubled `CLINCH_ENGAGE_BASE` (0.0020 -> 0.0040) and matched J20's clinch STRIKE share (13.9% vs 13.4%), but your
own pass-2 answer says clinch TIME share is 5.3% against K38's 13.36%. So the engine makes MORE clinches that are TOO
SHORT. A real clinch is not entered twice as often; it lasts. Q172 is NOT merged - Q173 replaces its rate change.

## What would a human do? (answer this in the digest BEFORE the fix)
Your Q172 answer is the start: a wrestler pins a striker to the cage and stays there; a Muay Thai fighter holds the
plum and knees until the referee separates them; a tired boxer holds to rest. How LONG does each last, what ends it
(referee break, a shove, a knee that lands, a trip, the bell), and who wants it longer? Use J20, K38, J32, J38.

## The work
1. Measure first (extend `Godot/tools/q171_pace_decompose.gd`): per ruleset, clinch ENTRIES per fight, MEAN and
   MEDIAN duration (s), and time share - on master, BEFORE any change.
2. Put the base rate back to 0.0020 and model duration instead: how a clinch ENDS per tick (break chance by who
   wants out, referee break after N seconds per ruleset if SOURCED, fatigue). Name every constant; mark each
   SOURCED/PROXY/AUTHORED in a comment.
3. Targets (ceilings, not exact): MMA clinch time share within 3 points of 13.36%; D1 stays in 6.0-8.0; clinch strike
   share within 4 points of 13.4%. If boxing clinches exist in the engine, report boxing too; if not, say so.
4. Population: name it in the output (never identical fighters; legal for the ruleset).

## Owned files
`Godot/scripts/FightRealtime.gd` (~5,850 lines - NEVER open whole; `grep -n "clinch"` then `sed -n 'A,Bp'`),
`Godot/tools/q171_pace_decompose.gd`, `research/Q173_DIGEST.md`. Tests: `fight_realtime_test.gd`,
`judge_panel_test.gd` only to re-pin with a one-line reason each. Do NOT loosen a gate to fit.

## Gate (tier: script edited)
Parse gate first. Then `fight_pace_anchor_test` alone; then `python Godot/tools/run_tests.py --only <x>` ONE per run
for fight_pace, fight_realtime, feint, judge, clinch, ground. Boxing/kickboxing OFF hashes (`s70_feint_off_hash.gd`)
before/after in the digest. No new red vs master.
Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-Q164`: `git fetch origin && git checkout -B qwen/q173-clinch-duration origin/master`.
Commit explicit paths, push the branch,
`python Tools/agent_comms.py send --from qwen --to claude --topic Q173 --body "<entries, duration, time share before/after, D1, split, hashes>"`.
Do NOT read HANDOFF.md or CURRENT_STATUS.md. All research is open: RESEARCH_INDEX.md lists every study.

## The one trap
Q172's pass-1 digest tuned a rate until a SHARE matched. A duration model that only gets the share right by
stretching every clinch to the same length is the same fit - report the duration DISTRIBUTION, not just the mean.

## PASS 2 (S74, Claude review of 610cadbd) - NOT MERGED YET
Pass 1 is the right mechanism: duration decoupled from rate (mean 7.4 -> 17.7 s, median 11.9 s, 30% past 20 s), strike
share 10.8% and D1 6.17 in band. But MMA time share is 3.63% against 10.36-16.36%. Your own finding names the lever:
the engine throws too many SIGNIFICANT strikes per clinch minute, so more clinch time drags strike share over band.
1. Per your "What would a human do?" answer, most clinch work is NON-significant (pummelling, framing, short shots).
   Split clinch strike output into significant / non-significant with a named, SOURCED-or-PROXY fraction (J20, K38,
   J32, J38 - say which), so D1 counts only the significant share. Then raise entries (or duration) until MMA time
   share lands in 10.36-16.36% with strike share still 9.4-17.4% and D1 6.0-8.0. Report the decomposition.
2. Boxing and kickboxing show ZERO clinches. Boxers hold and the referee breaks them; kickboxing allows a brief clinch.
   Find why none are entered (a ruleset gate?) and report it with the source for how often it happens (J20/K38 or
   NOT FOUND). Do NOT build boxing clinching in this pass unless it is a one-line gate fix - report it.
Same branch, same gate (OFF hashes: boxing/kickboxing may only change if item 2 changes them - say so).

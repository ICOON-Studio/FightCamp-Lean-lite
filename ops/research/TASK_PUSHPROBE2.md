# TASK PUSHPROBE2 - measure the fight bars through the game's real bout (no screen)

Operator S443, Q-S294-203: "Measure now". Model: Opus, high. Discipline: boxing (demo).
Design under test: ops/research/PUSHTANK_MAP_V2_S442.md (read sections 3, 5 and 6 whole). Critics:
PUSHTANK_V2_CRITIC_A_S442.md (coach, 7/6) and PUSHTANK_V2_CRITIC_B_S442.md (systems, 5/4); their musts are in the arms below.

## What is measured
Arms, each through the game's REAL bout (Bouts.fight_step + LiveRound with the auto corner, as tools/adapt_probe.gd and
tools/ask_probe_honest.gd play it - read both first; never roll your own dice for a punch, a round or a result):
- A today (the control).
- B v1's switch: Push on / off, Save into Breathe (map v1, PUSHTANK_MAP_S442.md).
- C HANDS only: Push / Steady / Coast spends and refills WIND, Coast WITHOUT the flat refill; a change is a shout.
- D HANDS + FEET + HEAD: all of map v2 section 3 (LEGS as a new resource, Press / Hold / Move, HEAD = damage nothing refills).
  Decision 1: HOLD = today's place, so D with Hold everywhere must equal A (a check, printed).
Arms B-D are probe-only layers on top of the real bout: put their rules in ONE probe-side module
(tools/pushprobe2_rules.gd), never in scripts/. Every number the map marks NEW / ESTIMATE is a named constant there.
Lengths: 3 rounds and 6 rounds. Cells: the map's 17 cases as starting states (plus the critics' missing cases: after a count,
a closing eye, the opponent switching stance). Two DIFFERENT fighters each side (never identical stats), paired dice: the same
seed plays the same bout under every policy.
Policies: the named habits ("Push while wind is above 45", "Push above 55", "always Press", "always Move", "always Hold",
"Push + Press always", "Steady + Hold always") and the COACH (the case table's answer, read from the corner's read, not the
cards). The critic's must: a hurt fighter told to Push has to take MORE head (open while trading); the probe shows whether
Coast + Move beats Push for a hurt fighter.

## Pass line (from the map)
No named habit is best in more than 6 cells of 10; the coach beats every habit by 3 points; "Push five, Save one" is gone in
C and D. Log per policy: win %, rest days (Aftermath.toll), head at the last bell, wind and legs at each bell.

## Cost and heat
400 paired bouts a cell is the map's number. FIRST time a pilot (one cell, 20 bouts, every arm) and print the projected wall
time; if the full run passes 90 minutes, cut to the bout count that fits and say so in the result. Runs only through
`python ops/Tools/godot_slot.py run --who pushprobe -- <godot> --headless --audio-driver Dummy --path . --script
res://tools/pushprobe2.gd -- <args>` (it waits while the PC is RED). Never the full test suite.

## Owned files
tools/pushprobe2.gd, tools/pushprobe2_rules.gd (each under 500 lines), docs/PUSHPROBE2_RESULT.md (the table: arms x
lengths x cells, the habit wins per cell, the pass line verdict, what the numbers say about the design in plain words).
Touch nothing in scripts/ or tests/.

## Prior research
PUSHTANK_MAP_S442.md, PUSHTANK_MAP_V2_S442.md and the four critic pages; U100_PUSH_EASE.md; C84_THE_PUSH_APART.md;
FIRELEVEL2_ADAPT1_RESULT_S442.md (how a probe through the real bout is built and read).

## What would a human do?
A coach watches many rounds of real sparring before changing how the corner talks; a race strategist sims the stint before
choosing tyres. Same here: numbers from the real fight before any screen.

## Prefab check
None needed: the probe reuses the game's own bout, corner and aftermath code.

## The one trap
A probe that rolls its own dice still prints a pass line (ASKPROBE1, S442). Every punch, round and result comes from the
game's code; the probe only chooses the corner's call and keeps the new bars' sums.

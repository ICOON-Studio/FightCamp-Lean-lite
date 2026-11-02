# TASK Q211 - QWEN - BOXING WITH THE GAME'S SWITCHES STOPS TOO MANY FIGHTS (S118)
Owner: qwen. Model: qwen3-coder, medium, `--yolo`. Assigned 2026-09-28 (S118). Branch `qwen/q211-boxing-stoppages` from
`origin/master`, own worktree. Claude decides and merges. Milestone: PLAYABLE WITH A BOXER - "stoppages happen at a real
rate" is in its finish line.

## Why
S118 census (`Godot/tools/u195_engine_census.gd -- bouts=20 ruleset=boxing switch=feint`, 3 populations pooled, 60 bouts
an arm, master 74488aaf):

| arm | sig/min | acc | finish | KO+TKO | bouts with a KD |
|---|---:|---:|---:|---:|---:|
| all switches OFF | 5.77 | 52.9% | 33.3% | 33.3% | 20.0% |
| the GAME (all ON incl. boxing_output) | 10.83 | 40.6% | 75.0% | 63.3% | 45.0% |
| all ON minus feint | 9.24 | 39.6% | 71.7% | 65.0% | 50.0% |

Real anchor: boxing ~47% KO/TKO in BoxRec's modern census (`G108_FINISH_RATES.md`, `topics/knockdowns_stoppage.md`).
The overshoot is not the feint (minus-feint is the same) - it arrives with `boxing_output` (U174/Q203, switched ON S117).
Also on the sweep fixture (switches OFF, outboxer v pressure): 40 of 300 boxing bouts were UNANIMOUS DRAWS (13%);
real draws are rare - report the draw share beside the finish share.

## What would a human do?
A sim designer calibrating fight outcomes (Fight Night's tuning pass): fix the target table first (finish rate,
knockdowns per bout, output, connect), change ONE constant at a time on a fixed seed set, and read which constant moves
which row - never retune the whole block at once. Stoppage rate is driven by damage per landed power punch and by how
many power punches land, not by output alone: the jab-heavy output U174 added should add volume without adding KOs.

## Prior research
`G108_FINISH_RATES.md` (the 47% anchor), `G99` (boxing output/connect/jab share: CompuBox 45-56 thrown/round, connect
27-32%), `U174_DIGEST.md` / `Q203_DIGEST.md` (what boxing_output changed and why), `topics/knockdowns_stoppage.md`,
`topics/pace_calibration.md`, `S118_DIGEST.md` (feints now bank the throw - boxing_output only), `J20` anchors.

## Prefab check
None: this tunes our own engine constants (`BOXING_OUTPUT_*`, FightRealtime.gd:107-111, and whatever damage path the
census shows moving).

## Build
1. Run the census as above on your branch first and confirm the table (same seeds). Add a draw-share column.
2. Find WHICH boxing_output constant (or which damage/KD path it feeds) takes KO+TKO from 33% to 63%: one-constant arms.
3. Tune so the GAME arm lands KO+TKO 40-55%, KD-bouts below 40%, thrown/round 45-56 and connect 27-35% held (G99), feints
   6-14/min held. Ceiling gates, not exact numbers; if one row cannot be reached without breaking another, stop and say
   which. Never make two fighters identical to get there (CLAUDE.md rule) - name the populations in the output.
4. Draw share: measure; if a cause is obvious (e.g. 10-10 rounds on the consensus card) report it, do not fix it here.

## Gate (tier: a script edited)
PC watchdog first (`Tools\pc_watchdog.ps1 -Once`; RED = stop). Parse gate `python Godot/tools/check_scripts.py <files>`.
Focused: `python Godot/tools/run_tests.py --only boxing_output`, `--only fight_feint`, `--only judge_panel`,
`--only fight_strike_whole`. No full suite. Pinned hashes/cards that move because of your constant: re-pin with the
test's own two-run check and name them.

## Owned files
`Godot/scripts/FightRealtime.gd` (boxing_output constants and the paths they gate only - ~7,700 lines, never open whole:
`sed -n` windows at :100-115, grep `BOXING_OUTPUT_`), `Godot/tools/u195_engine_census.gd`, `Godot/tools/q211_*.gd`,
`Godot/tests/boxing_output_test.gd`, pinned expectations in `judge_panel_test.gd` / `fight_strike_whole_test.gd`,
`research/Q211_DIGEST.md`.

## Deliver
Commit and push to your branch; Q211_DIGEST.md first line `boxing KO+TKO (game arm) 63.3% -> N%`, the full before/after
table; one `python Tools/agent_comms.py send --from qwen --to claude --topic Q211 "<one line>"`. Do NOT edit HANDOFF.md,
do NOT push master. **Trap:** fewer KOs by making nobody land is the wrong fix - connect must stay in 27-35%.

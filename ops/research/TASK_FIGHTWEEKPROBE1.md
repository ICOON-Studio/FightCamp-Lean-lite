# TASK FIGHTWEEKPROBE1 - QWEN (qwen3-coder) - the fight week's price list: what the tank and a flat round 1 are worth

Status: OPEN (S449, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: AMATEURWEEK1, the amateur fight week. Spec: ops/research/AMATEURWEEK1_MAP_V3_S449.md (READ sections 1, 4, 9 and 11).
The design pays every fight-week choice on ONE box: the tank at the first bell (energy off, 0 to 25 today) and SHARP or FLAT
in round 1. Before any rule is written we need the PRICE of each in wins, measured through the game's real bout. The target:
the best week against the laziest week is worth 10 to 12 wins in 100, and no single job is worth more than half of that.
THIS task is a measurement probe and its result page only: no rule module changes.

## Contract
OWNS: tools/fightweek_probe.gd, docs/FIGHTWEEKPROBE1_RESULT.md
RED_TEST: tools/fightweek_probe.gd -> FIGHTWEEK_PROBE done
REGRESSION: file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- tools/ask_probe2.gd (330 lines): copy its bout loop, population and seeds. Never roll your own dice.
- scripts/rules/BoutRules.gd:
  - tank_parts, tank, tank_read (lines ~185-235): the bout reads the tank from bout["stale"] or bout["tank_ahead"]
  - the round-n stance cost (~line 160): -NEVER_FACED 0.6 power in round 1 only
- scripts/rules/BoutRead.gd: _energy (~186), chance
- scripts/state/BoutNight.gd: how a played bout reads the tank and the round-1 stance cost (~350)
- scripts/state/LiveRound.gd: the night edge (~60)

## What to measure (under 450 lines)
1. TANK PRICE CURVE:
   - Set the energy off at the first bell to 0, 4, 8, 12, 16, 20 and 25 on OUR boxer only, through the field the bout reads (bout "stale"; quote file:line of where the played bout picks it up).
   - Play each through the real bout (Bouts.fight_step + LiveRound as ask_probe2 does).
   - Three matchups, from the real roster and rivals, never two identical fighters: EVEN (rating gap 0 to 1), SLIGHT EDGE (ours +3 to +5) and UNDERDOG (ours -3 to -5). Name each pair and its gap.
   - At least 400 bouts a cell.
   - Print: `TANK off=<n> pair=<even|edge|under> win=<pct> stoppage_won=<pct> stoppage_lost=<pct> r3_lost=<pct>`.
2. ROUND-1 PRICE: the same three pairs at tank 0, with a round-1-only power edge against us of 0.0, 0.3, 0.6 and 1.0.
   - Use the game's own round-1 path: the stance cost. An orthodox boxer who never faced a southpaw against a southpaw opponent gives 0.6 through BoutRules. If you cannot set 0.3 and 1.0 without editing a rule, measure 0.0 and 0.6 only and say so.
   - Also print round 1's own win rate.
   - Print: `R1 edge=<x> pair=<..> win=<pct> r1_won=<pct>`.
3. THE THREE WEEK SHAPES from the map, run as given (tank and round 1 together), each pair:
   - Rest up: tank 0 + flat (round-1 edge 0.6).
   - Tick over: tank 8, sharp.
   - Train through: tank 12, sharp.

   Print `SHAPE <name> pair=<..> win=<pct>`, then the spread best-minus-worst per pair.
4. Robustness: seeds 4421, 4422 and 4423, plus a men's division (name it). Print each headline's seed-to-seed spread.

PASS LINE: the last line `FIGHTWEEK_PROBE done cells=<n>`.

docs/FIGHTWEEKPROBE1_RESULT.md holds:
- the run command
- one table per section
- the seed spread
- one plain paragraph that answers each of these:
  - how many wins in 100 is one point of tank worth, near 0 and near 25 (is it flat or curved?)
  - what is a flat round 1 (0.6) worth
  - does any single shape win for all three pairs (if yes, the shapes are a lookup and the design must change)
  - what tank and round-1 prices would make best-minus-laziest 10 to 12 in 100

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first: typed Dictionary reads, no `:=` on a Variant, `%%`.
- Run every Godot job through `python ops/Tools/godot_slot.py run --who FIGHTWEEKPROBE1 -- <godot.exe> ...`; rule_guard blocks a bare one.
- Every bout is the game's real bout. Never two identical fighters. Do not delete or weaken any test.
- Write the PR body last, from the final run, with the RESULT line copied exactly.

## Prior research
- docs/AMATEURPROBE1_RESULT.md: the short lead alone gives 9 bouts a boxer a year at the same win share.
- docs/ASKPROBE2_RESULT.md and docs/ASKPROBE3 (closed: a later date buys nothing until the fight week exists).
- BoutRules header notes S433 NOCAMP1 + TANK1.

## What would a human do?
A club coach eases a tired boxer off in fight week. They keep a fresh one sharp with a light pad session two days out. They know a flat first round loses the round on the cards, not the fight. The probe must show whether the game agrees.

## Prefab check
None: the probe re-uses ask_probe2's loop and the game's real bout.

Test command: `python ops/Tools/godot_slot.py run --who FIGHTWEEKPROBE1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tools/fightweek_probe.gd` (the plain win64 exe, never the console one).
RESULT line for the PR body: `RESULT: tools/fightweek_probe.gd -> FIGHTWEEK_PROBE done cells=<n>`.

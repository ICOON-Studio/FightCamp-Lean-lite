# TASK CARDFIX2 - after the S466 card-table fix, does every best answer fire? (probe, no screen)

Status: OPEN (S466, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
CARDFIX1 (docs/CARDFIX1_RESULT.md, tools/cardfix_probe.gd, both on main) found 7 best pairs never fire, all but one in
she_tired / she_hurt, because LiveRound.gd put her on a FIXED card whenever she was tired or hurt. Claude's S466 fix (main):
- scripts/state/LiveRound.gd ~262: her own trouble no longer moves her; she is tired/hurt on the card she stands on; only a
  LOST exchange moves her (PlanFight.where_next).
- scripts/rules/PlanFight.gd GAME_CARD: "counter": "outside".
Your probe's _reach() also under-counts: it uses only the base id's "from" card, but StrikeMap has card variants
("tie_up@own_ropes", "slip 2-3@own_ropes", "3b-3@corner"...). A move reaches a situation on ANY of its rows' "from" cards.

## What to build (tools/cardfix2_probe.gd; start from tools/cardfix_probe.gd on main)
Same fighters (60, seeds 7100-7159), same four opponents, same CALIBRATE block, 2 bouts each, bars 45, same BASE plan.
ONE arm: MAIN = the game as it is on main now - NO local card table, NO forcing of lv["at"]; read lv["at"] after LiveRound
sets it. Fix _reach(): a pair (move, sit) counts an exchange when at == the "from" of the base row OR of any "<move>@<card>" row.
Print: card x situation table, REACH for every ANSWERS pair, WINS per opponent, and wins at step/defence bars 0 vs 70 for
step_in, feint, step_out.

## Pass lines (print each, yes/no)
- every StrikeMap card reached >= 1 in 100
- every ANSWERS "best" pair REACH >= 1 in 100 (list the failures)
- BASE wins per opponent within 40-60 of 100
- step_in, feint, step_out each: bar 70 - bar 0 >= 1.5 wins in some cell
Final line: `CARDFIX2 never_best=<n> cards_never=<n> wins=<min>-<max> bar_sensitive=<yes|no>`.
CONTROL: same seeds twice = identical tables (print `determinism yes|no`).

## Contract
OWNS: tools/cardfix2_probe.gd, docs/CARDFIX2_RESULT.md (written by the probe's own writer, never by hand)
RED_TEST: tools/cardfix2_probe.gd -> CARDFIX2 never_best=
REGRESSION: plan_bout_test, fire_level_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Never change a rule; report.
Runs only through `python ops/Tools/godot_slot.py run --who cardfix2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cardfix2_probe.gd`.
Under 500 lines. PR body: `RESULT: tools/cardfix2_probe.gd -> CARDFIX2 never_best=...`.

## Prior research
docs/CARDVISIT1_RESULT.md, docs/CARDFIX1_RESULT.md.
## What would a human do?
A coach watching tape counts where each answer could have been thrown; a fighter tired at range steps out, not teleports inside.
## Prefab check
None: an in-house probe on our own rules.

# TASK ASKPROBE2 - QWEN (qwen3-coder) - Ask for a fight: re-measure on map v3 (cases C and E as written)

Status: OPEN (S445, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: ASK FOR A FIGHT. Spec: ops/research/ASKFIGHT_MAP_S441.md v3 (READ IT FIRST, whole; section 7 step 0 is this task).
Two critics (ASKFIGHT_CRITIC_S444_KALLI.md, _JOHN.md) scored map v2 at 5/6 and 6/6 and asked for this run before any
drawing. The rules changed in S445 (scripts/rules/AskBout.gd + FightLearn.gd, already on main, tests green): picks above or
level only, honest step-up label, camp words by phase, a scale miss closes Ask on that date (`strip.ask_ok`), the road says
when the nationals cannot be made, teach words cut at 0.6 / 0.85. THIS task is a probe and its result page only.

## Contract
OWNS: tools/ask_probe2.gd, docs/ASKPROBE2_RESULT.md
RED_TEST: tools/ask_probe2.gd -> ASK_PROBE2 spread ok | ASK_PROBE2 DOMINANT (either line is a valid result; a missing line is red)
REGRESSION: ask_bout_test, fight_learn_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file (tools/ask_probe.gd is at the 500-line cap: READ it and copy what you need, never edit it).
Read, never edit: tools/ask_probe.gd (500 lines: the case table, the bout loop, the three players, the levers incl. pick_down),
tools/ask_probe_honest.gd (151: the real division, sheet and scale), scripts/rules/AskBout.gd (256), scripts/rules/FightLearn.gd,
scripts/state/Bouts.gd (fight_step, legal_index, AFTER_FIGHT), scripts/state/Sim.gd (weigh_forecast), scripts/rules/PlanLines.gd
or whichever module the fight prep's written plan lives in (grep `plan_lines` / `write_plan` under scripts/ - name it in the PR).

## What the probe does (under 400 lines)
1. Same population, seed and bout loop as tools/ask_probe.gd (seed 4421), with picks ABOVE or LEVEL only (AskBout.picks as it is
   now; no pick_down lever), step teaching x1, gate $450, AskBout.strip per show: when `ask_ok` is false the answers on that
   date are NOT playable; the probe plays Wait and the show after (AskBout.show_day with that night taken) instead.
2. Case C exactly as the map writes it: a 4-1 fighter, 3 bouts short of the nationals' 5, on day 40 (ask_probe used a 2-0).
3. Case E with a WRITTEN PLAN: the fighter's plan written by the game's own plan module against pressure; the presser two places
   up, a counter-puncher the name above. No win-chance oracle: every answer's result comes from the game's real bout with that
   plan loaded. Print the plan lines used.
4. Over the 60 fighters: per player (RECORD / GROWTH / SAFE SEASON) and overall, how often each answer wins; AND how often the
   three cards on one panel show at least two DIFFERENT teach words (FightLearn.word).
PASS LINE: `ASK_PROBE2 spread ok: no answer wins more than 6 in 10; teach words differ on N of M panels` or
`ASK_PROBE2 DOMINANT: <answer> wins N of 60`. Name the population in the output. Never two identical fighters.
docs/ASKPROBE2_RESULT.md: the run command, the tables, cases A-G winners, and the teach-word line. If an answer dominates, say
which lever the map names moves it (what a step up teaches first, the gate second) and show ONE re-run with it.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%`).
- Every Godot run through `python ops/Tools/godot_slot.py run --who ASKPROBE2 -- <godot.exe> ...` (rule_guard blocks a bare one).
- Do not delete or weaken any test. Write the PR body last, from the final run.

## Prior research
docs/ASKPROBE1_RESULT.md (round 2: a pick from below won 6 of 7 cases; above only, the plan's pick wins 4 of 7),
ops/research/ASKFIGHT_CRITIC_S444_KALLI.md + _JOHN.md (the cases they said were not tested: C as written, E without an oracle).
## What would a human do?
A coach with a written plan for pressure asks the matchmaker for the presser, not the counter-puncher one place nearer.
## Prefab check
None: the probe re-uses ask_probe.gd's own loop and the game's real bout.

Test command: `python ops/Tools/godot_slot.py run --who ASKPROBE2 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tools/ask_probe2.gd` (the plain win64 exe, never the console one).
RESULT line for the PR body: `RESULT: tools/ask_probe2.gd -> <the pass line>`.

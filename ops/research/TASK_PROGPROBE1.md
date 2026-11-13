# TASK PROGPROBE1 - GOOSE (cloud probe) - progression cadence and the hold rule (PROGPROBE1 + HOLD1) over two seasons

Status: WAITS FOR MOVETREE1 TO MERGE (it reads scripts/rules/MoveTree.gd). Discipline: boxing. Model: Goose + qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211). Spec: ops/research/PROGRESSION_MAP_S448.md sections 3, 4 (M1-M3), 9 rows PROGPROBE1 and
HOLD1 - READ THEM. A MEASUREMENT ONLY: no rule module changes. The rules not built yet (learning slot, hold rule, step mastery) are
modelled INSIDE the probe, clearly marked, so their numbers can be set before they are built.

## Contract
OWNS: tools/prog_probe.gd, tools/prog_probe_rules.gd, docs/PROGPROBE1_RESULT.md
RED_TEST: tools/prog_probe.gd -> PROG_PROBE done
REGRESSION: file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- tools/career_harness.gd (224 lines): plays careers through the real game (Main.act, the golden path's route) - copy its loop.
- scripts/rules/MoveTree.gd (MOVETREE1): rows, open nodes, style sets, day-0 and steps.
- scripts/rules/MoveMastery.gd (gain, decay, cap), scripts/rules/PadWeek.gd (PAD_NIGHT_MINUTES 240, SPAR_NIGHT_MINUTES 180,
  spar_pool, project), scripts/state/DrillWeek.gd (when the week's nights land: Sunday night).
- scripts/rules/WeekPhase.gd (BASE / BUILD / PEAK / TAPER).

## What to measure (prog_probe.gd under 450 lines; the modelled rules in prog_probe_rules.gd under 250)
Population: the four quick-start fighters and 60 generated walk-ins (Recruit / AttrGen as the game makes them; never two identical).
Two seasons (104 weeks) each, seeds 4481-4483.
ARM A = today's game as it runs (cards as the coach deals them). ARM B = the map: the coach's pick of three (first card) fills ONE
learning slot (two when the pads rating running the nights is 65+); pad cards carry only the slot's move or moves at 30+; steps and
defences tracked with the same MoveMastery formula on the units the probe gives them (pad share, shadow mornings 0.85 an hour, sparring
share); the HOLD RULE of M3: each Sunday a move at 60+ whose share of the week's units was under its hold (Sharp 20, Signature 40) fades
1.5 toward 50 / 70; frozen in fight week, TAPER and while injured.
1. CADENCE (both arms), per fighter per week: lines crossed (30/60/85, punches, steps, defences, book combinations opened), picks made,
   rows opened, styles named (MoveTree.styles_held), awards passed (SkillAwards.assess). Print
   `CADENCE arm=<A|B> crossed_weeks=<pct of weeks with a line crossed> picks_per_fighter=<n> first_pick_week=<n> row2_week=<n>
   row3_week=<n> style_week=<n or none> silver_week=<n or none>`, and `EMPTY_GYM_WEEKS arm=<A|B> n=<weeks with nothing crossed>`.
2. HOLD1 (arm B), four hold policies: COACH (holds the plan's moves and any Signature), WIDEST (tops up everything at 60+), DEEPEST (only
   the two highest), PLAN_ONLY (no top-ups); plans of 4, 6 and 7 moves; FOUR BOXERS sharing 8 pad nights; a BUSY AMATEUR (a bout every
   other Saturday); one injury layoff of 4 weeks. Print per policy and plan size:
   `HOLD policy=<..> plan=<4|6|7> sharp_held=<mean> signature_held=<mean> weeks_to_usable=<mean of new moves> distinct_sets=<n of same-start
   pairs ending season 2 with different held sets>`.
3. HOLD UNITS SWEEP: Sharp hold 10 / 20 / 30 and Signature 20 / 40 / 60 under COACH; print the pair that lets a careful player hold 4 Sharp
   and 1 Signature AND bring a new move to 30 within 4 weeks.
PASS LINE: last line `PROG_PROBE done cells=<n>`.
docs/PROGPROBE1_RESULT.md: the run command, a table per section, the seed spread, and one plain paragraph each: does arm B cross a line
3 weeks in 4 (and arm A?); when do row 2, row 3, the first style and Silver come (Silver must not be later than arm A); which hold units
pass; is plan size a real trade (no policy or size best in more than 2 of 3 line-ups); anything the map's numbers got wrong.

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first. Every bout is the game's real bout (career_harness's route); never roll your own fight dice.
- Mark every modelled rule in prog_probe_rules.gd with `# MODELLED (PROGRESSION_MAP M<n>)`; it must not touch scripts/.
- Godot jobs only through `python ops/Tools/godot_slot.py run --who PROGPROBE1 -- <godot.exe> ...` when run on the PC; the plain win64
  exe, never _console. Write the PR body last, from the final run, the RESULT line copied exactly.

## Prior research
- docs/ASKPROBE2_RESULT.md and tools/career_harness.gd (how seasons were played through the real game before).
- ops/research/FIRELEVEL2_ADAPT1_RESULT_S442.md (what a level is worth in a bout today).

## What would a human do?
A coach looks back over a year and asks: did every boxer learn something most weeks, and did the ones who kept a few moves sharp
become different boxers? The probe answers that before anything is built.

## Prefab check
None: career_harness.gd is the in-house season player; this probe adds the map's rules beside it.

Test command: `godot --headless --audio-driver Dummy --path . --script res://tools/prog_probe.gd -- seasons=2`
RESULT line for the PR body: `RESULT: tools/prog_probe.gd -> PROG_PROBE done cells=<n>`.

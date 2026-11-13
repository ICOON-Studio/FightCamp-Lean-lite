# TASK ASKPROBE3 - QWEN (qwen3-coder) - Ask for a fight: make waiting cost something, measure a real step up and two dates

Status: OPEN (S447, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: ASK FOR A FIGHT. Spec: ops/research/ASKFIGHT_MAP_S441.md v4 (READ IT FIRST, whole). Two fresh critics scored v4
5/5 (Kalli) and 6/6 (John): ops/research/ASKFIGHT_CRITIC_S447_KALLI.md and _JOHN.md - read both "Depth" sections and both
"To reach 10/10" lists. Their shared verdict: for RECORD and SAFE the ask is even with waiting for most fighters because
(1) waiting costs nothing in the probe (mood, members and ladder places are not scored) and (2) the ask's date lands where the
sheet's lands, so it trades nothing; and x1.25 sits exactly on both bars on one seed and one division. THIS task is a probe
and its result page only: it measures the v5 candidates below as LEVERS; no rule module changes.

## Contract
OWNS: tools/ask_probe3.gd, docs/ASKPROBE3_RESULT.md
RED_TEST: tools/ask_probe3.gd -> ASK_PROBE3 done
REGRESSION: ask_bout_test, fight_learn_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit: tools/ask_probe2.gd (330 lines: copy its loop, population, cases and players),
scripts/rules/AskBout.gd, scripts/rules/FightLearn.gd (STEP_TEACH, teach_for), scripts/rules/RankLine.gd (after/before: ladder
places), scripts/rules/BoutRules.gd (WIN_MEMBERS, tank_read), scripts/state/Bouts.gd, scripts/state/BoutNight.gd (what a result
does to morale and members - quote the lines you use), scripts/state/Sim.gd (weigh_forecast).

## What the probe adds to ask_probe2 (under 450 lines; split a helper file only if you must - then own it and name it)
1. SCORE WHAT WAITING COSTS. Each season policy also reports: MOOD at day 70 (start 60; apply the game's own morale moves
   for a win, a loss and a booking as BoutNight / the fighter code applies them - find them by grep and quote file:line; for
   "a month without a fight" use the game's rule if one exists, else use -6 per 30 days without a bout and SAY in the result
   that the game has no such rule yet), MEMBERS (+BoutRules.WIN_MEMBERS per win, the game's loss cost per loss), and LADDER
   PLACES gained (RankLine.after on the division rows before/after each bout). RECORD becomes places gained + wins - losses;
   print the three parts separately too.
2. STEP-UP LEVER `step=label|gap3|gap5`: label = today (AskBout.step_up, teach x FightLearn.STEP_TEACH); gapN = the step up
   is the nearest legal name at least N rating points above ours (ranked AND unranked: by rating, not by record), teach
   x1.0 (the bigger gap teaches more by FightLearn.teach itself). Print how often each panel has a step-up card at all.
3. DATE LEVER `dates=one|two`: two = every ask answer may be booked on the next show (>= 14 days) OR the show after
   (>= 28 days); the later date gives the weight forecast more days (Sim.weigh_forecast on that day) and, if the fighter's
   tank rule reads days since the last bout (BoutRules.tank_read / LAST_BOUT), its effect. The sheet stays 2-4 weeks, date
   unknown. Report how often the later date is the best choice per player.
4. Cases rewritten: C = a 1-1 fighter on day 40 (really 3 bouts short of the nationals' 5); E = Counter Cara as the step up and
   Press Pat as the PAID A NAME (gate taken), Press Pat and Counter Cara at the SAME rating so the style edge is apart from
   rating; B with the fighter 4th; D at morale 52 (Steady). Report how often A NAME YOU PICK is present on the 60 panels.
5. Robustness: every arm on seeds 4421, 4422, 4423 AND a men's division (Career men's lightweight rivals; name it). Print the
   seed-to-seed spread of each headline count.
6. Arms to run, each over the 60 x 3 seeds + the men's 60 (reduce n_night / seasons as ask_probe2 did if time needs it, and
   say so): A = label x1.25, one date (today's v4); B = gap3, one date; C = gap5, one date; D = gap3, two dates; E = label
   x1.25, two dates.
PASS LINE (one per arm): `ASK_PROBE3 arm=<X> best: RECORD <answer> N/60, GROWTH <answer> N/60, SAFE <answer> N/60; even
ask-vs-wait R/G/S = a/b/c of 60; teach words differ on N of M; name card present on N of 60` then a last line
`ASK_PROBE3 done arms=5`. docs/ASKPROBE3_RESULT.md: the run command, one table per arm, the seed spread, cases A-G per arm,
and a plain paragraph: which arm gets RECORD and SAFE off "even" for most fighters while no answer is best in more than 6 of 10.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%`).
- Every Godot run through `python ops/Tools/godot_slot.py run --who ASKPROBE3 -- <godot.exe> ...` (rule_guard blocks a bare one).
- Never roll your own dice for a punch, a round or a result: every bout is Bouts.fight_step + LiveRound as in ask_probe2.
- Never two identical fighters. Do not delete or weaken any test. Write the PR body last, from the final run.

## Prior research
docs/ASKPROBE2_RESULT.md (x1 flat, x1.5 dominant, x1.25 at the edge); docs/ASKPROBE1_RESULT.md; the two S447 critic files.
## What would a human do?
A coach whose boxer is going stale asks for any fight soon; one with a boxer a kilo over asks for the later show; one chasing
the table asks for the name above that a win would pass. Each of those is worth something the probe must score.
## Prefab check
None: the probe re-uses ask_probe2's loop and the game's real bout.

Test command: `python ops/Tools/godot_slot.py run --who ASKPROBE3 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tools/ask_probe3.gd` (the plain win64 exe, never the console one).
RESULT line for the PR body: `RESULT: tools/ask_probe3.gd -> ASK_PROBE3 done arms=5`.

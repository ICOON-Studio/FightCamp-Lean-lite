# TASK WEIGHTMOVE1 - WEIGHT as one deep mechanic, aimed at 10/10 (design map from the code + greybox probe)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535, verbatim: "The boxer should be able to change weight classes", then "Go deep with weight mechanic for 10/10 it
should be manageable to a certain point and affect various things about fighters performance,scaling etc".
Bar (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics AFTER the probe; aim the map at 10/10.

## What "manageable to a certain point" means (Claude's reading - design it, then challenge it)
The player steers weight (diet, cut pace, fight-week water cut, class choice, rehydration, when to move) but never owns it:
each boxer has a natural walking weight that drifts (age, growth in a young boxer, appetite / discipline, injury layoffs,
holidays, the season), a body that resists a cut past its limit, and a price for every kilo taken off. Control is real and
bounded - the interesting decisions live at the edge of the bound.

## What weight must touch (each with a CODE path, or say it is new)
1. PERFORMANCE: a drained boxer (deep cut, poor rehydration) loses gas tank, late-round output, speed and chin (real: dehydration
   and concussion risk - COUNTED source or ESTIMATE flagged for John); a boxer fighting at a comfortable weight is fresher.
2. SCALING: the size gap inside a bout - weight / frame / reach / height against the opponent - moves power, chin taken, clinch,
   inside work and ring control (Duels, Exchanges, Knockdowns, WorldBout profiles; the 3D view already scales arms by Strength -
   say whether the body should scale by weight too). Power and chin carry-over on a class move.
3. CLASSES: move up or down between bouts (amateur: the class at the next weigh-in; pro: a table move, ranking lost or kept by
   rule; ProLadder.division_for and its L2 mismatch). The boxer may ask for a move or refuse one (FighterGoal, morale).
4. THE WEEK: training load vs cut (the morning sessions and intensity, BodyLoad / BodyTrack / WeekPlan / FightWeekPlan / CampForecast),
   injury risk while cutting, recovery, sparring.
5. THE CLUB: missed weight (today: bout off, $300) and its reputation cost, matchmakers booking off the walking weight, a nutritionist
   or a diet as a real spend (the coach's hands as the club's currency, DEPTH_SCOPE_S534).
6. KNOWLEDGE: what the player can read about the body (a scale reading is exact; how drained he is, is a read with error -
   Knowledge.gd misread pattern), what the opponent's weight story tells you.
7. LONG CAREER: growth into a heavier class, age making cuts harder, a career-long arc (start light, fill out, move up for money).

## What to write
A. `ops/research/DESIGN_WEIGHT2.md` (from the code; words CODE file:line / COUNTED / ESTIMATE as in DESIGN_DMGCLASS1_V3.md):
   today's weight path end to end (Sim.gd, WeekPlan, CampForecast, Bouts, WeighIn / FightWeek modals, FightWeekPlan, TapeRows,
   TaleOfTape, RosterTable, FighterPage, Body*.gd, Data.DIVISIONS, ProLadder, every read of div / limit / weight); then the design
   for 1-7 above as decisions with trade-offs; what it deepens, what it makes redundant (FREE HAND: remove / add / interconnect);
   every menu it appears on and what each is wired to; a no-dominant-pick check for 4 shapes (puncher, volume, big chin, drained
   cutter) x stay / cut harder / move up / move down; what is cut to keep it manageable (one screen of decisions a week, at most).
   Fold in BOARD_WEIGHT1_R5_S478.md (declared walking weight, one amateur scale, weight target with a date) and list its 3 open
   owner questions with the answer this design needs from each.
B. THE PROBE first (METHOD, owner S534): `tools/weight2_probe.gd` (greybox, headless, through godot_slot; may hold a scratch model,
   builds nothing into scripts/) - real Data people (never quick_start's one boxer: memory feedback_probe_population_and_dice_s533),
   4 shapes x the 4 choices x 20 seeds over N bouts with the BoutNight / PlanTest loop; print win share, stoppage share, late-round
   share, weeks lost, missed weights, ladder place. PASS = each lever moves the result and no single pick is best in more than 6 of
   10 cells. `docs/WEIGHT2_PROBE.md`.
C. A list for John (real-world numbers the design needs: performance lost per % body mass cut, rehydration gain amateur vs pro,
   concussion / dehydration, growth per year 16-23, class-move carry-over) in `ops/research/JOHN_WEIGHT2_ASK.md`, 10 questions max.

## Prior research
`python ops/Tools/prior_research.py weight class cut division rehydration` first. BOARD_WEIGHT1_R5_S478.md, DESIGN_WEIGHT1_R*_*,
DESIGN_DMGCLASS1_V3.md + its FABLE critic (L1 pro count limit and L3 towel price are FIXED on branch s535/dmgfix - read, do not
redo), DEPTH_AUDIT_S534.md, DEPTH_SCOPE_S534.md, ARMBUILD1 (arms by Strength in 3D).

## What would a human do?
A coach watches the scale every Monday, eases the cut over weeks, keeps the last kilos for water at the end, and moves a boxer up
when the cut takes his legs or the money is a class above; he moves down a small boxer. Young boxers grow out of classes. A bad cut
shows in round 3, not round 1.

## Prefab check
None: data in Data.DIVISIONS / ProLadder / Body*.gd exists; no assets.

## Contract
OWNS: ops/research/DESIGN_WEIGHT2.md, ops/research/JOHN_WEIGHT2_ASK.md, tools/weight2_probe.gd, docs/WEIGHT2_PROBE.md
RED_TEST: tools/weight2_probe.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who weight2 -- <command>` (the queue is busy: patient, not stuck).
Other sessions have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them. No file over 500 lines.
Stage explicit paths, commit to main with the Co-Authored-By line, push, report in two lines (map written; probe PASS/FAIL with
the cell table), stop.

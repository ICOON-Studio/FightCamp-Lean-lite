# TASK KNOWREV4 - write the knowledge stakes map v4 (KNOW_STAKES1_V4) from the code, answering both v3 critics

Kind: research
Status: DONE (S533: map delivered, later versions on main) - was OPEN (S531, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
KNOW_STAKES1 v3 (`ops/research/DESIGN_KNOW_STAKES1_V3.md`) scored Arena 6/6 (`ops/research/DESIGN_KNOW_STAKES1_V3_CRITIC_ARENA.md`)
and Dola 6 depth / 7 general (`ops/research/DESIGN_KNOW_STAKES1_V3_CRITIC_DOLA_DOLA.md`, her answer is the LAST ~120 lines;
the top is her page's menu text). Bar: 7+ DEPTH and 7+ GENERAL from two fresh critics.

Claude checked (S531): `scripts/rules/PlanLines.gd` HABIT_SITS answers only 7 of the 20 habits in
`assets/data/fight_habits.json` (fades_late, slow_starter, admires_her_work, drops_right_after_jab, lunges_with_jab,
digs_body_when_hurt, loads_up_when_hurt). A known habit with no answering line is information without an action.

## Your job
Write `ops/research/DESIGN_KNOW_STAKES1_V4.md` (same sections as v3), changed so that:
1. EVERY habit gets one answering plan line, mapped to a situation that ALREADY exists in PlanLines (the CALL_SITS values:
   press, range, counter, loadup, tiring, hurt, she_hurt, she_tired) - a table of 20 rows; a habit no situation fits is
   named and CUT from the notebook rather than shown dead.
2. Severity: v3 has one HABIT_COST (HabitFix.gd). Decide from the code whether tiers are a data change only (a cost per
   habit in fight_habits.json read by HabitFix.cost) - tag ESTIMATE with the probe line that would check it; no invented
   numbers outside an ESTIMATE row.
3. Answer each item of both critics' "To reach 10/10" lists: KEEP (with the build line), or CUT with the reason from the code.
   Dola asks for: a weekly lever per known habit, a "watch for this one" pick that shifts the sparring reveal odds, and read
   names that say what they reveal (KnowReads.gd). Use an EXISTING lever wherever one exists (grep before you add).
4. Keep the wire table (every menu, what it shows, what it opens) and the probe (population named, pass lines).
Every row tagged CODE (file + function), ESTIMATE (a target a probe checks) or CUT. Plain game words, names only in headers,
no critic scores in the map. End with "Changed from v3".

## Deliverable
ONE new file `ops/research/DESIGN_KNOW_STAKES1_V4.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 420 lines.

## Contract
OWNS: ops/research/DESIGN_KNOW_STAKES1_V4.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_KNOW_STAKES1_V3.md and both v3 critics above; CRITIC_PACK.md; KNOWBOTS probes (`python ops/Tools/prior_research.py knowbots`).
## What would a human do?
A coach who spots a flaw tells the boxer what to do when it shows up in the fight, and drills it in the week.
## Prefab check
None: a design document on our own code.

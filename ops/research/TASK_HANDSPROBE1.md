# TASK HANDSPROBE1 - QWEN (qwen3-coder) - how scarce are Reid's hands really? Measure only

Status: OPEN (S428, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: two fresh critics scored week design v3 depth 5 and 5 (docs/mockups/s427/week_v3_critic_coach.md and
week_v3_critic_simvet.md). Both say the whole week rests on Reid's hands being scarce (v3 says two evenings, the game has three
pad nights) and that this is UNMEASURED. Offers come 8 to 12 weeks out and a single move is usable in week 2, so every answer
may be owned long before taper and then there is no squeeze at all. This task measures it in the game as it is. It changes no
game file.

## Contract
OWNS: tools/hands_probe.gd, docs/HANDSPROBE1_RESULT.md
RED_TEST: tools/hands_probe.gd -> HANDSPROBE1 camps=<n> (measure only)
REGRESSION: golden_path_test
VISUAL: no

## The job
1. Read tools/thursday_probe.gd (on main) for the harness: it builds 40+ camps that differ (5 boxers x 4 bouts x seeds),
   books bouts, steps days and has `_owns_answer_for_tell` (mastery 30 or more on a line that fits the tell's situation).
   Reuse it. Its camp spread rule applies: fewer than 10 opponents or 12 distinct rows = VOID.
2. For every camp, at TAPER START (find it: grep TAPER in scripts/rules/WeekPlan.gd and WeekPhase.gd; say which day you use)
   record: A) the tells of this opponent's file that the plan has a line for (OppFile.tells, PlanLines.tell_sit); B) how many
   of those lines the boxer OWNS and can use (mastery 30 or more, same test as the thursday probe); C) the week of the camp
   in which each owned line first reached 30; D) weeks between the offer and the bell.
3. Run each camp in four cells on the same seeds: (a) the coach's default week as the game plays it (PadWeek.nights_of with
   Reid hired, his default); (b) the same with no coach hired; (c) the default plus one extra pad night (what a SENIOR
   clubmate would add, if the game has it, else say "the game has no senior pad night" and use the night count from
   PadWeek.NIGHTS "camp" row); (d) the default with the bag night taken out. Say how you set each cell from the code.
4. Print one line per camp and cell: `HANDS camp=<n> cell=<a|b|c|d> opp=<name> needs=<n> owned_at_taper=<n> weeks_offer_to_bell=<n>`.
5. docs/HANDSPROBE1_RESULT.md: the spread; a table per cell of needs / owned at taper (how many camps own all, all but one,
   half or fewer); the share of camps where EVERY answer is owned at taper before the player makes any choice (if that is
   70 percent or more, Reid's hands are not scarce on the default week: say so plainly); the mean weeks from offer to bell and
   the mean first-usable week; then five sentences: how often does the default week leave an answer missing at taper? does a
   missing extra night or no coach change it? is "two evenings" true of the game or a design number (PadWeek.NIGHTS says
   what)? which cell comes closest to a real squeeze? what could you not measure? Bend no threshold.

## Prior research
tools/thursday_probe.gd and docs/THURSDAY2_RESULT.md (harness, spread rule, Thursday counts), ops/research/WEEK_DESIGN_V3_S427.md
section 3.2 and the gate table, docs/READBACK1_RESULT.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach with one assistant and a ten-week camp knows by week two whether he can cover everything before the fight; the
number of nights he has decides whether the week is a choice or a to-do list.

## Prefab check
The harness exists (tools/thursday_probe.gd). No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://tools/hands_probe.gd` (the plain win64 exe, never the console one). Parse first:
`python ops/Tools/check_scripts.py tools/hands_probe.gd`.
RESULT lines for the PR body: `RESULT: tools/hands_probe.gd -> HANDSPROBE1 camps=<n> all_owned_default=<x>%`.

# TASK LOYAL1 - a season of club weeks: who goes short, and what it does to loyalty (SHORTWEEK1 + LOYAL1, no screen)

Status: OPEN (S461, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: CLUB WEEK (approved map ops/research/CLUBWEEK_MAP_V41_S432.md - READ sections 3.1, 3.1a, 3.8 and 8 WHOLE). The pure rules
are built: scripts/rules/ClubDeal.gd (the deal: pad places, coached mornings, Coach's evenings, who goes short) and
scripts/rules/Loyalty.gd (bands, causes, forecast, leaves). Neither is wired (ops/research/INTEGRATION_S459.md rows 6 and 11).
The map's section 8 says these two probes run BEFORE either is wired. This task runs them.

## What is measured
tools/loyal1_probe.gd (a SceneTree script, pure: preloads ClubDeal and Loyalty only) runs 52 club weeks for the start squad:
FOUR fighters (three boxers and one BJJ fighter, the S428 scope: ops/research/SCOPE_FOUR_FIGHTERS_S428.md), each with a bout
calendar (amateur bouts 1 to 2 weeks out, a fight week every 4 to 6 weeks, staggered by seed), loyalty from the trait (Data.gd
personality "loyalty", 45-70 across the four). Each week builds ClubDeal's `week` dict (fighters with pads asked = ASK ordinary 3,
+2 in a fight week; two coached mornings asked each; Coach's evenings ["pads","pads","pads"]; own evening "pads"), deals it, and
applies Loyalty causes per fighter: "short" when the deal's row says short, else "full_week"; "held_pads" for a valid holder.
Policies (who deals):
- COACH: ClubDeal.deal(week) with its own coach_order.
- EVEN: rotate the order each week so the fighter dealt last last week is first.
- STARVE: the fighter with no bout inside 4 weeks always last.
- CLASS: one of Coach's evenings a "class" every week (ClubDeal.coach_evenings's money lever), else COACH.
40 seeds each.

## Pass lines (the map's section 8, verbatim targets)
- SHORTWEEK1: asked is over owned in 9 weeks of 10, and COACH leaves nobody short more than 2 weeks running.
- LOYAL1: COACH never drives anyone under 50 in a season; STARVE loses one fighter a season (Loyalty.leaves after two talks:
  count a talk as the WANTS A WORD card answered "give the pad place back" when under 50 - Loyalty MOVES talk_back); EVEN holds
  everyone over 60.
Print per policy: weeks short per fighter (mean, max run), loyalty at week 52 (min / mean), fighters lost, class cash. Then the
verdict per line, and if a line fails, which ESTIMATE in ClubDeal / Loyalty (named constant) would have to move and which way.
Do NOT change any constant in scripts/: report only.

## Contract
OWNS: tools/loyal1_probe.gd, docs/LOYAL1_RESULT.md
RED_TEST: tools/loyal1_probe.gd -> LOYAL1 done (a probe; docs/LOYAL1_RESULT.md is the deliverable)
REGRESSION: club_deal_test, loyalty_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only).
(loyal1_probe.gd under 500 lines; pure, runs in seconds. Run: `python ops/Tools/godot_slot.py run --who loyal1 -- <godot> --headless
--audio-driver Dummy --path . --script res://tools/loyal1_probe.gd`. PR body: `RESULT: tools/loyal1_probe.gd -> SHORTWEEK1=<pass|fail>
LOYAL1=<pass|fail>`.)

## Prior research
CLUBWEEK_MAP_V41_S432.md (3.1, 3.1a, 3.8, 8); TASK_R73DEAL1 (ClubDeal's contract, if present); tests/club_deal_test.gd and
tests/loyalty_test.gd (how each module is called).

## What would a human do?
A club coach with four fighters and eight pad places knows somebody goes short most weeks; the good ones rotate it so nobody feels
second in line. Measure whether the rules make that true before the game charges loyalty for it.

## Prefab check
None: pure probe over the two built modules.

## The one trap
Never write your own deal or loyalty arithmetic: every number comes from ClubDeal.deal and Loyalty.apply; the probe only builds
the weeks and picks the order.

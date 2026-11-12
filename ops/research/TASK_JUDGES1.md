# TASK JUDGES1 - set the judges' weights, give BoutRead the judges, re-measure, then let the judges decide (one switch)

Status: OPEN (S443, Claude side session, on the S443 coordinator's HOLD). Discipline: boxing. Model: a strong code seat
(Opus-class) - this is a probe + model task across BoutRead, not a pure module.
Mechanic: R29 "Scorecards after each round" / M2 THE JUDGES (ops/research/FIGHT_LINK_MAP_S432.md lines 200-226, the
spec; PROBE JUDGES1 gates (a)-(f) at line 222). Built and collected S443: scripts/rules/Judges.gd (the rule,
ops/research/R29JUDGES1_REVIEW_S443.md), scripts/state/JudgeNight.gd (fight night: the judges on every judged bout's
m["judges"]), scripts/ui/JudgeCards.gd (the result page's three cards, hidden until the judges decide).

## Why it is held (S443 coordinator: "HOLD. BoutNight keeps deciding on today's cards until JUDGES1")
With `judgesdecide` on, measured S443 with tools/judges_agree_probe.gd (Lucy -6 / as signed / +6 against every OPPONENT +
MISMATCH + RIVAL, 30 bouts each, 990 bouts, 897 decisions, BoutNight.play_out = fight night's own rounds):

| Gate | Band | S443 (Judges.WEIGHTS estimates, LEAN_MULT 2.0) |
|---|---|---|
| (a) the exchange winner takes the round on the judges' majority | 80-90 in 100 | **92.0** (just above) |
| (b) out-landed and lost the decision | under 15 in 100 | 8.2 (holds) |
| (c) split decisions | 10-25 in 100 | **3.3** (too few; majority 0.3, unanimous 93.8, draw 2.6) |
| decisions that change hands against today's rounds-won cards | (a balance change: re-measure) | 10.7 |
| (d) BoutRead.chance within 6 in 100 of played bouts (tests/bout_read_test.gd) | 6 | **4 cases out** |

The four bout_read cases with the judges deciding (chance() shown / real bouts):
Lucy v Maria 0.459 / 0.366; Lucy -6 v Maria 0.251 / 0.178; Lucy +6 v Erin 0.505 / 0.570; Lucy, a plan v Priya 0.407 / 0.498.
A shown chance off by 9 in 100 is a number the player cannot trust (operator rule: no numbers that lie).

## The job
1. WEIGHTS (scripts/rules/Judges.gd WEIGHTS / LEAN_MULT, nothing else in that file): set them so (a) sits 80-90, (b)
   under 15 and (c) 10-25 on the probe's population. The S443 reading: clean punches (about 10 a round each side) swamp
   the other parts (ring 0-6, big 0-2, initiative 0-2), so the three leans rarely disagree; the lean must move a close
   round, not every round. Report the grid you tried and the pick, each with its (a)/(b)/(c).
2. BOUTREAD (scripts/rules/BoutRead.gd chance(): today P(win) = P(2 of 3 rounds) on ComboOdds.round_odds per round):
   give it the judges' model - a judged round's odds from the exchange odds plus what the judges add (landed punches,
   ring, counts), and the decision from three cards (two of three) instead of one rounds-won card. Bar: bout_read_test
   green with the judges deciding (all its cases inside CALIBRATED 0.06, the four above included); no case may get worse
   than it is today with them off.
3. RE-MEASURE: the first season's records with the judges deciding (the career harness / ask_bout_test season probe,
   plan_effect_probe's spread (gate e), BalanceHarness), against today's; report what moved.
4. SWITCH: `JudgeNight.DECIDES := true` in ONE commit with 1-3 green, the tests below green, and stills of the result page
   with JudgeCards placed (the result page session owns where).
5. Gate (f) (knowing the leans is worth 1.5 in 100 to a bot that picks WHERE by them) waits for the Officials rule; not this job.

## Contract
OWNS: scripts/rules/Judges.gd (WEIGHTS, LEAN_MULT only), scripts/rules/BoutRead.gd, scripts/state/JudgeNight.gd (DECIDES),
tools/judges_agree_probe.gd, tests/bout_read_test.gd (new cases only, never a loosened bar).
RED_TEST: `tests/bout_read_test.gd` run with `-- judgesdecide` -> today FAIL 4; must read `BOUT_READ PASS`.
REGRESSION: judges_test, bout_rules_test, bout_stoppage_test, result_defects_test, plan_bout_test, ask_bout_test,
golden_path_test (its `_judged` check), file_limits_test - each with and without `judgesdecide`.
Probe: `godot --headless --audio-driver Dummy --path . --script res://tools/judges_agree_probe.gd -- 30 judgesdecide`
(the probe reads m["judges"] either way; the flag matters for the tests).
VISUAL: the result page stills once switched (tools/judges_news_still.gd -- <out> judgesdecide).
Every Godot job through `python ops/Tools/godot_slot.py run --who <you> -- ...`.

## Traps
- The judges stay a READ of the exchanges: no randomness in scoring, no number from outside the round.
- Do not tune the weights against bout_read_test: the weights answer (a)-(c); BoutRead answers (d).
- Never land the switch with a test knowingly red (coordinator S443).

## Prior research
`python ops/Tools/prior_research.py judges scorecard` -> topics/scoring_results.md, J1_ORGANIZATION_RULES_AND_JUDGES.md,
FIGHT_LINK_MAP_S432.md M2, R29JUDGES1_REVIEW_S443.md, this file's table.

## What would a human do?
A boxing analyst checks the scoring against real cards: close rounds split, clear rounds do not, a knockdown is a 10-8;
then the odds a bookmaker offers follow the scoring, not the other way round.

## Prefab check
None: our own rule and our own read.

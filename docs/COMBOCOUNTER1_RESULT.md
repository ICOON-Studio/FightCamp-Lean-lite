# COMBOCOUNTER1 - the combo counter on the wired game (S540)

Rule: scripts/rules/ComboCounter.gd (READ_AT 2, ring-smart 65+ one sooner, CHANCE 0.35, counter-puncher x1.75, margin -10, fade 1 a bell, film half-read). 60 boxers x 6 opponents x 3 nights = 1080 bouts a plan, each played OFF and ON through Bouts.fight_step, scored by the real outcome.

| plan | opponent's style | bouts | wins OFF | wins ON | change | 2 x error | bouts the read fires (of 100) | throws into a read a bout | counters a bout |
|---|---|---|---|---|---|---|---|---|---|
| SPAM | Pressure fighter | 180 | 27.2% | 26.7% | -0.6 | 1.1 | 6 | 0.09 | 0.03 |
| SPAM | Counter-puncher | 180 | 20.0% | 13.3% | -6.7 | 4.3 | 74 | 3.05 | 1.92 |
| SPAM | Volume puncher | 180 | 9.4% | 9.4% | +0.0 | 0.0 | 7 | 0.09 | 0.05 |
| SPAM | Boxer-puncher | 180 | 17.8% | 13.9% | -3.9 | 2.9 | 57 | 1.77 | 0.61 |
| SPAM | Out-boxer | 180 | 46.1% | 41.1% | -5.0 | 3.2 | 69 | 2.56 | 0.95 |
| SPAM | Slugger | 180 | 67.8% | 67.2% | -0.6 | 1.1 | 13 | 0.23 | 0.06 |
| SPAM | ALL SIX | 1080 | 31.4% | 28.6% | -2.8 | 1.1 | 38 | 1.30 | 0.60 |
| WEAPON | Pressure fighter | 180 | 40.0% | 39.4% | -0.6 | 1.1 | 53 | 1.11 | 0.42 |
| WEAPON | Counter-puncher | 180 | 26.1% | 15.6% | -10.6 | 4.8 | 78 | 3.36 | 2.12 |
| WEAPON | Volume puncher | 180 | 18.3% | 16.1% | -2.2 | 2.7 | 81 | 2.69 | 0.93 |
| WEAPON | Boxer-puncher | 180 | 20.6% | 17.2% | -3.3 | 2.7 | 64 | 2.08 | 0.72 |
| WEAPON | Out-boxer | 180 | 48.9% | 41.7% | -7.2 | 3.9 | 78 | 2.97 | 1.11 |
| WEAPON | Slugger | 180 | 72.8% | 70.6% | -2.2 | 2.2 | 58 | 1.78 | 0.59 |
| WEAPON | ALL SIX | 1080 | 37.8% | 33.4% | -4.4 | 1.3 | 69 | 2.33 | 0.98 |
| SPREAD | Pressure fighter | 180 | 26.1% | 26.1% | +0.0 | 0.0 | 1 | 0.01 | 0.00 |
| SPREAD | Counter-puncher | 180 | 21.1% | 18.9% | -2.2 | 2.7 | 48 | 1.33 | 0.87 |
| SPREAD | Volume puncher | 180 | 12.8% | 12.8% | +0.0 | 0.0 | 24 | 0.39 | 0.15 |
| SPREAD | Boxer-puncher | 180 | 18.9% | 18.3% | -0.6 | 1.1 | 18 | 0.32 | 0.10 |
| SPREAD | Out-boxer | 180 | 46.7% | 46.7% | +0.0 | 0.0 | 28 | 0.62 | 0.24 |
| SPREAD | Slugger | 180 | 65.0% | 65.0% | +0.0 | 0.0 | 1 | 0.01 | 0.00 |
| SPREAD | ALL SIX | 1080 | 31.8% | 31.3% | -0.5 | 0.5 | 20 | 0.45 | 0.23 |

- (a) SPAM v the counter-puncher -6.7, overall -2.8 -> PASS
- (b) WEAPON beats SPREAD (ON) against: Pressure fighter +13.3, Volume puncher +3.3, Slugger +5.6 -> PASS
- (c) effects v 2 errors: counter-puncher 6.7 v 4.3, overall 2.8 v 1.1 -> PASS
- (d) the read fires in 38 bouts of 100 for SPAM (25-60), 20 for SPREAD (under 15) -> FAIL
- (e) the best plan (ON) by style: { "Pressure fighter": "WEAPON", "Counter-puncher": "SPREAD", "Volume puncher": "WEAPON", "Boxer-puncher": "SPREAD", "Out-boxer": "SPREAD", "Slugger": "WEAPON" } -> PASS

WIRED VERDICT: FAIL (a true, b true, c true, d false, e true)

## What the wired numbers say (written after the run, S540)

| | greybox P2 (REPEATBITE1/2) | wired game (this run) |
|---|---|---|
| SPAM v the counter-puncher | -6.1 (2 x error 3.6) | **-6.7** (4.3) |
| SPAM overall | -2.2 (0.9) | **-2.8** (1.1) |
| SPAM: bouts the read fires (of 100) | 34 | **38** |
| SPREAD: bouts the read fires (of 100) | 17 | **20** |
| SPREAD overall | -0.3 | **-0.5** (0.5, inside the noise) |
| WEAPON overall | -4.4 | **-4.4** |

1. **It bites the repeater, as measured.** Spamming one line against the counter-puncher costs 6.7 wins in 100 and 2.8
   overall, a little more than the greybox (a counter now also moves what comes after it: energy, damage, reads).
2. **The varied plan is read a little more than the greybox said: 20 bouts in 100, not 17** (bar d asks under 15, so (d)
   fails by 5 where the greybox failed by 2 - the owner's yes was given on the 17). It still costs the varied plan nothing
   measurable (-0.5 wins in 100, inside 2 errors). The drift has two causes, both deliberate: (i) the film now carries the
   last bout's most-thrown PLAN line (the greybox took the most-thrown move of any kind, often an instinct move that is never
   counted, so its film was often wasted); (ii) the bout is scored by its real outcome, not by the greybox's round majority.
3. Bars (a) (b) (c) (e) hold: a main weapon still beats the spread against three styles (Pressure fighter, Volume puncher,
   Slugger), and no plan shape is best against all six (the counter-puncher, boxer-puncher and out-boxer flip to SPREAD).
4. If (d) should be met, the cheapest lever is the film alone (it only matters against the 4 opponents below rating 65):
   a rerun with the film off is one flag in the probe. Not done here - the build follows the measured P2 the owner approved.

## How it stacks with "opponents adjust" (PlanRead.ADJUST)
ADJUST trims a right answer's EDGE after its third right use in a round; the counter takes the whole EXCHANGE on a
repeated plan line (any fit, counted across rounds, fading one a bell, and from film). Both stay; the greybox measured the
counter laid over a game that already had ADJUST in it, so these are the stacked numbers.

## Where it shows
- The live fight: every counter is a feed line / caption, "They timed your <line>: countered, the exchange is theirs."
  (FightNight's tooltip on it explains the counter, PlanReadShow.tip_for).
- The result Plan tab: the line's row says "countered N of M throws into the read (first in round R)", tooltip with the
  rule's numbers (PlanReadShow.tip_counter, filled from ComboCounter's constants).
- The Playbook lean chip's tooltip adds the counter's sentence.

Probe: `godot --headless --script res://tools/combocounter1_probe.gd -- boxers=60 nights=3` (6,480 bouts, ~11 min through
godot_slot). Tests: combo_counter_test (rule + wire + control arm + Plan tab), plan_read_shown_test, result_tabs_test,
golden_path_test, file_limits_test PASS; plan_templates_test fails "t_turn answers Maria better than the starter plan" with
the counter ON and OFF alike (red in the nightly since 11-22, NIGHTREDS1) - not this change.

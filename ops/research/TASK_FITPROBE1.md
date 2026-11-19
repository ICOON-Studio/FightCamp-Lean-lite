# TASK FITPROBE1 - coach fit: is a TOP fit worth having, and is it not too much? (FITPROBE1 + TRAINBALANCE, probe only)

Status: OPEN (S524, Claude main). Discipline: boxing. Model: any seat that runs Godot headless (Qwen or Goose).
Approved: coach fit design v8 (board Q-S294-235 "Yes, approve"; critics Dola 7/7, John 7/6).
Map: `ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md` sections 2.1-2.2 (fit), 12 (probes and pass lines), 13 (build).
The maths exists: `scripts/rules/CoachFit.gd` (fit(p), gain_mult(fit), tired_mult(fit), capped(gain, camp), word(fit);
tests/coach_fit_test.gd). Nothing in the game calls it yet; the design's build waits for these probes.

## Contract
OWNS: tools/fit_probe.gd, docs/FITPROBE1_RESULT.md
RED_TEST: tools/fit_probe.gd -> FITPROBE1 done
REGRESSION: coach_fit_test, training_week_test, two_boxers_two_years_test (read-only: run them, never edit)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Under 500 lines. The result page is written BY THE PROBE.

## The job - tools/fit_probe.gd (extends SceneTree)
Two arms on the SAME seeds (paired): AVERAGE (fit 50 - CoachFit.gain_mult(50) and tired_mult(50) must equal 1.0; print
it, the design's "fit 50 equals today exactly") and TOP (the fit CoachFit.word calls the top band; print the number used).
1. FITPROBE1 - 26 weeks of the game's own week (Sim.step_day, the boxer's own plan and focus), 60 different boxers
   (Data.fighter_state on varied stats / styles / ages - never identical, CLAUDE.md s5; print the population). Probe-side
   only: after each day, the gain the day gave the FOCUS stat is scaled by gain_mult(fit) - 1 extra (and the day's
   tiredness by tired_mult), through CoachFit.capped(gain, camp mult) so the stack cap holds. Print per arm: FOCUS stat
   gain over 26 weeks (mean, 10th/90th), the weeks a drilled move takes to reach Sharp (mastery 60). PASS: TOP - AVERAGE =
   +3 to +5 on the focus stat; Sharp 2-4 weeks sooner.
2. TRAINBALANCE - each boxer from part 1 at week 26 (both arms) fights 40 bouts (Bouts / LiveRound with the auto corner,
   as tools/adapt_probe.gd and tools/exchange_balance.gd play them) against the same fixed opponent set (print it).
   PASS: TOP wins +4 to +8 in 100 over AVERAGE - under a good plan's +14 (59 against 45) - with the headroom clamp on.
3. Print the control: AVERAGE against an untouched run of the same seeds (no probe scaling) must match to the digit.

## Prior research
`python ops/Tools/prior_research.py coach fit gain` -> the v8 map and its critics; tools/adapt_probe.gd, tools/exchange_balance.gd
(playing bouts); tools/fight_toll_probe.gd (52-week careers through Sim.step_day).

## What would a human do?
Put two identical twins with two coaches for six months: the better-matched coach's boxer should be clearly sharper on what
they worked on, but not unbeatable - the plan still matters more.

## Prefab check
None: the probe plays the game's own weeks and bouts.

## The one trap
Scaling gains by editing scripts/ (the arms must differ only inside the probe), or comparing arms on different seeds.
PR body: `RESULT: tools/fit_probe.gd -> top_fit=<n> focus_gain_diff=<x> sharp_weeks_sooner=<x> win_diff_in_100=<x>
control=<match|DIFF> fitprobe1=<pass|fail> trainbalance=<pass|fail>`. Run through `python ops/Tools/godot_slot.py run --who
fitprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/fit_probe.gd`; pilot first, stop at 60 min.

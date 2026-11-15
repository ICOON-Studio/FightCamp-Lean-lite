# TASK COACHFIT2 - coach fit as numbers: fit, its word, the gain and tiredness multipliers, coach time, ceilings (pure module + test)

Status: OPEN (S480, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
The owner approved the coach fit design (board Q-S294-235, "Yes, approve"). Map: ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md
sections 2.1, 2.2, 3.3, 3.4, 4.1, 5.2, 6.1 (they are the spec; this brief copies every number you need). Its balance probes
(FITPROBE1, TRAINBALANCE, COACHTIMEPROBE) need the fit maths as code before anything is built on a screen. This module is that
maths; nothing calls it yet (Claude wires it later).

## Prior research
- The map above (v8, passed critics Dola 7/7, John 7/6). Code today: a session's gain = pace x coach factor x headroom clamp x
  Light/Normal/Hard (scripts/rules/WeekPlan.gd); fit 50 must leave that chain EXACTLY as it is (multiplier 1.0).
## What would a human do?
A coach who suits a boxer gets more out of a session; one stretched over too many boxers gets less. Model it as one number
around a neutral 50, so the old game is the 50 case.
## Prefab check
None: game-specific rule maths; no library fits.

## What to build: scripts/rules/CoachFit.gd (new, under 250 lines)
`extends RefCounted`, pure static functions, no class_name, no preload, no game state. Tabs for indent. No `:=` on a value read
from a Dictionary or Array (type it: `var x: int = int(d.get("k", 0))`).

Constants (keep the names):
- NEUTRAL := 50, FIT_MIN := 10, FIT_MAX := 90
- OVER_FREE := 0.5, OVER_MID := 1.5, OVER_MAX := 2.0, PEN_MID := -8, PEN_HIGH := -18
- BOND_STEPS := [["Stranger", 0, -4], ["Working", 8, 0], ["Trusted", 45, 6], ["Corner", 110, 12]]  ([word, bond from, fit])
- STRANGER_EVENINGS_ONLY := true  (the Stranger -4 counts on evenings only)
- TAUGHT_OUT_WITHIN := 5, TAUGHT_OUT := -6, ABOVE_CEILING := 0.5
- FOCUS_MORNING := 10, FOCUS_OTHER_MORNING := -3
- TEMPER_SUITS := 6, TEMPER_CLASH := -8, STEADY_ALWAYS := 2, MODE_RIGHT := 4, MODE_WRONG := -4
- STACK_CAP := 1.6
- WORDS := [["TOP FIT", 75], ["GOOD", 58], ["MIXED", 40], ["RISKY", 0]]
- COACH_TIME := {"sessional": 10.0, "fulltime": 14.0, "head": 4.0, "club2": 2.0, "promoted": 8.0, "promoted_l2": 10.0}
- COST := {"pads": 1.0, "pads_shared": 1.5, "spar": 1.5, "spar_two": 2.0, "film": 0.0, "corner": 3.0,
  "morning_normal": 0.5, "morning_hard": 1.0}

Functions:
1. `bond_step(bond: float) -> Dictionary` - {"word", "fit"} of the highest step whose "bond from" <= bond.
2. `time_penalty(over: float) -> int` - 0 when over <= 0.5; -8 when 0.5 < over <= 1.5; -18 when over > 1.5.
3. `temper_part(temper: String, mode: String, boxer: Dictionary) -> int` - boxer = {"morale_word": "Flat"|"Low"|"Steady"|...,
   "coachability": int, "cards_known_share": float (share 0..1 of this week's drill cards that are Usable or Sharp)}.
   temper "motivator": +6 when morale_word is Flat or Low; mode "lift" adds +4 when Flat or Low (no wrong value for shield/lift).
   temper "technician": +6 when coachability >= 70, -8 when coachability < 30; mode "polish" +4 when cards_known_share > 0.5
   else -4; mode "teach" +4 when cards_known_share < 0.5 else -4 (exactly 0.5 = wrong for both).
   temper "steady": +2 always (no modes). Anything else: 0. Result clamped -12..+10.
4. `fit(p: Dictionary) -> int` - p = {"temper", "mode", "boxer" (as above), "over": float (the coach's hours past budget this
   week), "bond": float, "evening": bool, "mastery_or_stat": float, "ceiling": float, "focus": "this"|"other"|"" (mornings
   only: "this" = the morning trains the FOCUS stat)}. Fit = 50 + temper_part + time_penalty(over) + bond fit (Stranger's -4
   only when evening) + taught out (-6 when ceiling - 5 <= mastery_or_stat < ceiling; 0 otherwise, also 0 at or above the
   ceiling, where ceiling_mult takes over) + focus (+10 "this", -3 "other", 0 otherwise and always 0 on evenings).
   Rounded to int, clamped 10..90. An empty p returns 50 only if bond defaults to 8 (Working): use `p.get("bond", 8.0)`.
5. `gain_mult(fit: int) -> float` = 0.5 + fit / 100.0  (x0.60 at 10, x1.00 at 50, x1.32 at 82).
6. `tired_mult(fit: int) -> float` = 1.125 - 0.0025 * fit  (x1.10 at 10, x1.00 at 50, x0.92 at 82).
7. `ceiling_mult(value: float, ceiling: float) -> float` - 0.5 when value >= ceiling, else 1.0.
8. `capped(gain_mult: float, camp_mult: float) -> Dictionary` - {"mult": mini(gain_mult * camp_mult, 1.6), "capped": bool}
   (use minf).
9. `word(fit: int) -> String` - the first WORDS row whose floor <= fit.
10. `morning_ceiling(area_rating: float) -> int` = floor(55 + area_rating * 0.35);  `evening_ceiling(area_rating) -> int` =
    floor(area_rating).
11. `week_cost(nights: Array) -> float` - sum of COST over the ids in nights (unknown id = 0).
12. `over(coach: String, cost: float, borrowed: float) -> float` - cost - (COACH_TIME[coach] - borrowed); can be negative.
13. `can_take(coach: String, cost: float, borrowed: float) -> bool` - over(...) <= 2.0.
14. `next_week_time(coach: String, over_now: float, rested: bool) -> float` - rested: COACH_TIME + 3 (any borrowing wiped);
    else COACH_TIME - maxf(0, over_now).

## The test: tests/coach_fit_test.gd (new)
Same shape as tests/partner_match_test.gd (extends SceneTree, `_check(cond, label)`, prints `COACH_FIT checks=<n> failures=<n>`,
quit(1) on any failure). At least 40 checks, including:
- fit({}) == 50 and gain_mult(50) == 1.0 and tired_mult(50) == 1.0 (the RED-FIRST line: "fit 50 equals today exactly")
- gain_mult 10 -> 0.60, 82 -> 1.32; tired_mult 10 -> 1.10, 82 -> 0.92 (is_equal_approx)
- time_penalty: 0.5 -> 0, 0.6 -> -8, 1.5 -> -8, 1.6 -> -18, 2.0 -> -18
- bond_step: 0 Stranger, 7.9 Stranger, 8 Working, 45 Trusted, 110 Corner; Stranger's -4 only on evenings
- temper_part: Motivator + LIFT with a Flat boxer = +10; Technician coachability 20 + POLISH with share 0.2 = -12; Steady = +2
- TEACH vs POLISH fork: one boxer share 0.2, one 0.9: TEACH gives +4 and -4, POLISH -4 and +4
- taught out: ceiling 74, mastery 70 -> -6; mastery 68 -> 0; mastery 74 -> 0 and ceiling_mult 0.5
- focus: morning "this" +10, "other" -3, evening "this" 0
- clamp: a fit that sums past 90 reads 90, under 10 reads 10
- words at 75 / 74 / 58 / 57 / 40 / 39
- capped(1.32, 1.35) -> 1.6 and capped true; capped(1.0, 1.2) -> 1.2, false
- morning_ceiling(58) == 75, morning_ceiling(90) == 86 (55 + 31.5 floored), evening_ceiling(74.9) == 74
- the map's coach-time table: one boxer BASE (3 pads + 1 spar) = 4.5; two boxers = 9.0; sessional over(10.5) = 0.5 (penalty 0);
  over(11.0) = 1.0 (penalty -8); fulltime over(11.0) < 0; can_take sessional 12.0 true, 12.1 false
- next_week_time: sessional over 1.0 -> 9.0; rested -> 13.0

## Contract
- OWNS: scripts/rules/CoachFit.gd, tests/coach_fit_test.gd (both new; nothing else edited, no test deleted or weakened)
- RED_TEST: tests/coach_fit_test.gd
- REGRESSION: tests/week_phase_test.gd (untouched file; must stay green)
- VISUAL: none

## Test command (tier: a new pure module + its test)
`godot --headless --audio-driver Dummy --path . --script res://tests/coach_fit_test.gd`
Your sandbox has no Godot and cannot download it: parse-check the GDScript (gdtoolkit) and mirror the expectations in Python;
say so in the PR body. The PR body carries `RESULT: tests/coach_fit_test.gd -> COACH_FIT checks=<n> failures=0` as the
expected shape, marked NOT RUN. Claude runs it on the PC.

## The one trap
fit 50 MUST be exactly neutral: no part may default to a non-zero value (bond defaults to Working 8 = 0 fit; temper "" = 0;
over 0 = 0; focus "" = 0). A wrong default silently changes every session in the game once it is wired.

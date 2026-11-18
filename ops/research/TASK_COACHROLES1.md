# TASK COACHROLES1 - coach roles r6, the pure rules: class nights vs pad minutes, hire runway, belt ceiling, held night

Status: OPEN (S515, Claude main line). Discipline: boxing (+ the BJJ belt rule). Model: qwen3-coder (or any seat that runs Godot).
Source: coach roles and specialties r6, owner's yes on the board (Q-S294-271: "Yes, build it"). Map:
ops/research/DESIGN_COACHSPEC1_R6_DOLA.md lines 1066-1208 (R13, R7, R14, R8, R5 runway, R4/R15). Summary:
ops/research/APPROVE_COACHSPEC1_R6_S514.md. A PURE module + its test; Claude wires the Staff cards, the Week board's
priority switch and the no-gi page after this lands. The Week Priority switch (R14) is NOT in this task (it changes
CoachedMornings' deal; Claude does it).

## Contract
OWNS: scripts/rules/CoachRoles.gd, tests/coach_roles_test.gd
RED_TEST: tests/coach_roles_test.gd -> COACH_ROLES PASS
REGRESSION: coach_fit_test, coached_mornings_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py coach class nights runway belt`. Read the map lines above, then scripts/rules/CoachFit.gd,
CoachedMornings.gd, CoachMarket.gd (do NOT change them), and how cash/burn is read today (grep `runway` and `weekly_net` in
scripts/). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A club owner knows each class night pays the bills but eats pad time; before hiring they ask "how many weeks of money
does that leave me?"; a BJJ coach can only promote below their own belt.

## Prefab check
None: the numbers are our own decided ones (CLAUDE.md "Decided numbers": classes +$350/week with a coach, 75-min pad nights).

## The job: scripts/rules/CoachRoles.gd (extends RefCounted, no preloads, every func static, under 250 lines)
1. Constants: CLASS_PAY 175, CLASS_MIN 60, PAD_BASE_MIN 75, PAD_MIN_FLOOR 45, UNITS_PER_MIN 3.2, CLASS_DEFAULT 2,
   CLASS_MAX 3, RUNWAY_WARN 8, RUNWAY_RED 6.
2. `class_week(class_nights: int) -> Dictionary` (R13 table): {nights: [mon, wed, fri pad minutes], pad_min, pad_units,
   class_pay}. Must reproduce the map's 4 rows exactly: 0 -> 105/105/75, 285 min, 912 units, $0; 1 -> 105/75/75, 255,
   816, $175; 2 -> 75/75/75, 225, 720, $350; 3 -> 75/75/45, 195, 624, $525. Clamp class_nights to 0..CLASS_MAX.
   `class_pill(class_nights) -> String` = "-1 class -> +60 pad min · -$175/wk ($2.9/min)" (only when a class can be dropped).
3. `runway(cash: float, weekly_net: float) -> int`: weeks until cash runs out (weekly_net >= 0 -> 999). 
   `hire_line(cash, weekly_net, wage_change, income_added) -> Dictionary` = {before, after, band} where band is "red"
   (after < RUNWAY_RED), "amber" (< RUNWAY_WARN), else "ok"; text "Runway: N weeks -> M weeks". Never blocks a hire.
4. `can_promote(coach_belt: String, coach_degree: int, to_belt: String) -> bool` (R8): belts white < blue < purple <
   brown < black; brown coach -> up to purple; black 1st degree -> up to brown; black 2nd degree+ -> black.
   `academy_month() -> Dictionary` = {fee 450, weeks 4, label "Academy Month - get promoted · $450 · away 4 weeks"}.
5. `held_night(kind: String) -> Dictionary` (R4 + R15): "full" = {minutes 75, mornings_cost 2, load_mult 1.38/1.3 as the
   ratio string "1.3 -> 1.38", risk_mult 1.4, mastery_share 1.0}; "half" = {minutes 40, mornings_cost 1, ratio "1.3 ->
   1.34", risk_mult 1.2, mastery_share 0.53}. `held_allowed(fight_week: bool, held_this_week: int) -> Dictionary` =
   {ok, why}: fight week -> "Taper week: athlete needs rest"; already one this week -> not ok.
A `## why` header names the map lines each func comes from; ESTIMATE numbers keep a comment saying so.

## tests/coach_roles_test.gd (SceneTree, headless)
All four class_week rows exactly; clamp at -1 and 5; runway (zero burn, a burn, cash 0); hire_line bands at 9, 7, 5 weeks
after; every can_promote case incl. the ceiling and a white/blue coach promoting nobody above their own belt; held_night
both kinds; held_allowed in a fight week and on a second hold. Last line `COACH_ROLES PASS` (or FAIL n).

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--log-file E:/FightCamp/tmp/<run>.log`. No screens.
Nothing outside OWNS; never touch scripts/fight3d/.

## The one trap
The class table moves minutes nights by night, not evenly: dropping one class adds 60 minutes to ONE night (Monday first),
adding a third class takes 30 from Friday only down to the 45 floor. Test the per-night list, not just the total.

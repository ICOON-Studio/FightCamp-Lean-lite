# TASK PACING1 - the floor day's decision budget as one pure module (S237, K87 approved)

Seat: Arena (pure module + test, cloud). Branch `arena/<chat-id>-fightcamp`, PR to master; Claude reviews and merges by diff - never the
Merge button. Model: Arena default. Discipline: BOXING (the demo's gym floor).
Operator ruling (board Q-S235-1, "Approve"): "Floor decisions per day (Kalli K87): max 6 cards a day, 2 an hour, the coach decides the
rest and logs it; injury always first; quiet days shown as pips."
This round is a pure module only (no switch). Grok Dev wires it into GymHall3D.push_card next round (switch `decision_pacing`, GAME_ON).

## What is on master already (read, do not edit)
- `research/K87_DECISION_PACING_REPLY.md` - THE SPEC (Kalli). Every number below comes from it.
- `Godot/scripts/GymHall3D.gd` ~2000 `push_card(kind, data)`: the floor's card kinds are `niggle`, `breakthrough`, `corner`, `form`,
  `floor_event`; sparring adds `spar` (SparringBlock, next round). Do not edit GymHall3D - it only tells you the kind ids.

## Do - new `Godot/scripts/rules/DecisionPacing.gd`
extends RefCounted, static funcs only, no class_name, no autoload, NO preload, NO randomness (any "pick" is
`float(absi(hash("%s|%d" % [seed, i])) % 10000) / 10000.0`). Never modify an argument; return fresh dictionaries.
1. `const KINDS` table per kind: {priority (niggle 1, spar 2, breakthrough 3, corner 4, form 5, floor_event 6), max_per_day (2,3,1,5,4,2),
   wait_minutes (niggle 30, spar 0, breakthrough -1 = until block end, corner -1 = until next block, form 15, floor_event 60),
   never_dropped (niggle, breakthrough true)}.
2. `day_budget(day_ctx: Dictionary) -> int`: day_ctx {template ("recovery_day" etc. from DayPlan), days_to_fight (-1 none), weekday 0..6,
   days_since_fight (-1 none)}. Normal 6; template "recovery_day" 2; days_to_fight 3..5 (fight week Mon-Wed) 4; days_to_fight 2 (Thursday,
   the test spar) 3; days_to_fight 1 (weigh-in) and 0 (fight day) -> 0; days_since_fight 1 or 2 -> 2. The lowest applicable value wins.
   Write the mapping in the function comment.
3. `pips(budget: int, used: int) -> String`: always 6 characters - `used` cards as "●", the rest of the budget as "○", the slots beyond
   the budget as "·" (budget 2, used 1 -> "●○····"). Plus `pips_label(budget) -> String`: "quiet day" when budget <= 2, "fight week" when
   3..4, "" at 6.
4. `admit(state: Dictionary, kind: String, minute: int, speed: int, info: Dictionary) -> Dictionary` - the gate push_card will call.
   state = {budget, shown: [{kind, minute}], counts: {kind: n}} (a fresh state from `new_day(budget)`). info = {soreness 0..100,
   cut_or_knockdown bool}. Returns {"verdict": "show"|"coach"|"wait", "reason", "state": the new state}.
   Rules: hour cap 2 per 60 game minutes AND >= 20 minutes since the last shown card; day budget; per-kind max_per_day; at speed 3 only niggle
   with soreness > 60, breakthrough, and spar with cut_or_knockdown may show - the rest "coach". Over a cap: a never_dropped kind returns
   "wait" (niggle, breakthrough), spar returns "coach" (never waits), the rest "coach". Breakthrough and a niggle with soreness > 60 always
   show at speed 1 even over budget (injury first) - say so in a comment.
5. `merge(queue: Array) -> Array`: a `form` and a `corner` at the same minute merge into one `corner` whose data has "form_line": true; two
   `niggle` on the same data.region merge into one. Order the result by priority, then minute.
6. `expired(item: Dictionary, minute: int, block_changed: bool) -> bool` from wait_minutes (corner expires on block_changed, breakthrough on
   block_changed, spar at once).
7. `coach_call(kind: String, best_option: String, other_option: String, coach_skill: float, seed: String, i: int) -> Dictionary` =
   {"option", "value_share" (1.0 for the best call, else 0.6 + skill * 0.003), "stars" 1..3, "pushed_niggle" bool, "line" one plain
   sentence for the day log starting "Coach: "}. Best-call chance 0.5 + skill/200. A niggle with skill < 40: pushed through when the pick
   < 0.3; skill > 70 never. Breakthrough is never coach-called by choice: it returns option "bank" (Kalli: the player always makes it;
   the auto default when it expires is "bank it").

## Test - new `Godot/tests/decision_pacing_test.gd` (red first: the module does not exist on master)
Print the population: "a normal day (budget 6), a recovery day, fight week Tue/Thu/Fri, the day after a fight; coach skills 20, 55, 90".
Assert: 9 corner/form/floor_event cards spread over a day -> at most 6 "show", the rest "coach"; 3 cards in one hour -> the third is not
"show"; a card 10 minutes after a shown one is not "show"; a niggle soreness 80 at speed 1 over budget -> "show"; a niggle soreness 40
over budget -> "wait"; spar over budget -> "coach" never "wait"; at speed 3 a corner -> "coach", a breakthrough -> "show"; budgets: normal 6,
recovery 2, fight week Tue 4, the day before weigh-in 3, weigh-in 0, day after fight 2; pips length 6 and its filled count = used; merge
turns form+corner at one minute into one corner with form_line; two niggles on "left_hand" -> one; coach_call over 400 seeds: best-call
share for skill 90 > skill 20 (bound: skill 90 >= 0.85, skill 20 in 0.45..0.75), skill 20 pushes niggles in 0.15..0.45 of seeds,
skill 90 never; value_share in 0.6..1.0; same seed same call; arguments unchanged after every call.
Bound values, never exact float extremes. Print "DECISION_PACING failures=N", quit(0/1).
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/rules/DecisionPacing.gd Godot/tests/decision_pacing_test.gd`.
One test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/decision_pacing_test.gd` (no LFS needed).
Do NOT delete or weaken any existing test. Read research/GDSCRIPT_TRAPS.md first (no `:=` on a Variant, no `%%`).

## The one trap
Injury first: a niggle over soreness 60 and a breakthrough are never coach-called away and never silently dropped - over every cap they
show (speed 1) or wait; only the routine cards go to the coach.

## Prior research
K87_DECISION_PACING_REPLY.md (Kalli, the spec), K86 (sparring moments, max 2 a block), DayPlan.gd TEMPLATES (template ids), LUDO_R100 PART B
(the FloorDecisionCard), GYMFLOOR_MECHANICS_IDEAS_S234.md (L3 coach bandwidth).

## What would a human do?
A head coach on a busy floor answers the fighter's real problems himself and only calls the owner over for the two or three that matter -
an injury, a breakthrough - and on a recovery day he does not call him at all.

## Prefab check
None - RimWorld's letter split (pause for red, log for the rest) is the model, per K87; no library does this.

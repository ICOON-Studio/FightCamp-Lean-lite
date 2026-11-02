# TASK STRESS1B_A - one week of a boxer's life -> stress events -> the week's stress tick (pure module + contract test)

Model: Arena Agent Mode (cloud). Repo ICOON-Studio/FightCamp, branch: your own arena/ branch, open a PR into master, never merge.

FightCamp is a Godot 4.7.2 GDScript boxing-manager game. `Godot/scripts/rules/StressRules.gd` (166 lines, already on master)
holds the stress table: `apply(state, event_id, composure)`, `weekly_decay(state)`, `band(stress)`,
`resolve(state, composure, roll_0_100)`, `effects(affliction, virtue)`, consts `GAINS` and `RELIEF`. Read it whole first.
This task adds the layer that turns WHAT HAPPENED IN A WEEK into those events. Nothing else in the game changes.

## New file 1: `Godot/scripts/rules/StressWeek.gd`
`extends RefCounted`, NO class_name, one preload: `const StressRules := preload("res://scripts/rules/StressRules.gd")`.
No other preloads, no autoloads, no randomness (the roll is passed in).

### Week facts (input dictionary; every key optional, missing = the default shown)
```
{
  "fight": {},                 # {} = no bout. Else {"result": "win"|"loss"|"draw", "method": "ko"|"tko"|"ud"|"sd"|"md"|"dq",
                               #   "knockdowns_suffered": int (default 0), "title": bool (default false)}
  "training_days": [],         # 0-7 entries, each "rest" | "light" | "hard" | "extreme", in day order
  "deload": false,
  "weight_cut_pct": 0.0,       # this week's cut, % of bodyweight
  "weigh_in": "",              # "" | "made" | "failed"
  "injured_this_week": false,
  "withdrew": false,
  "opponent_pulled_out": false,
  "promise": "",               # "" | "kept" | "broken"
  "request_ignored": false,
  "physio_sessions": 0,
  "office_talk": false
}
```

### `static func events_for(facts: Dictionary) -> Array` - event ids, GAINS first, then RELIEF, in exactly this order:
GAINS, in this order:
1. each "hard" day -> "hard_day"; each "extreme" day -> "extreme_strain" (in day order, one event per day)
2. "back_to_back": once for EACH adjacent pair of days that are both "hard" or "extreme" (["hard","extreme","hard"] = 2)
3. "overreach_week": once, if 5 or more days are "hard" or "extreme"
4. "inactive_week": once, if `fight` is empty AND no day is "light"/"hard"/"extreme" (an empty list counts as inactive)
5. fight loss: method "ko"/"tko" -> "loss_ko"; "sd"/"md" -> "loss_split"; anything else -> "loss_ud"
6. "knockdown" once per `knockdowns_suffered` (any result)
7. weight: `weight_cut_pct` >= 5.0 -> "severe_cut"; else >= 3.0 -> "cut_3_5"; then `weigh_in` "failed" -> "failed_weigh_in"
8. "injury" if injured_this_week; "withdrawal" if withdrew; "opponent_pullout" if opponent_pulled_out
9. "broken_promise" if promise == "broken"; "ignored_request" if request_ignored
RELIEF, in this order:
10. each "rest" day -> "rest_day"; "deload_week" if deload
11. fight win: method "ko"/"tko" -> "win_ko", else "win_decision"; plus "title" if title and result == "win"
12. "clean_cut" if weigh_in == "made" and 0.0 < weight_cut_pct < 5.0
13. "promise_kept" if promise == "kept"; "physio" once per physio_sessions; "office_talk" if office_talk
A draw adds no fight event. Every id returned must exist in StressRules.GAINS or StressRules.RELIEF.

### `static func tick(state: Dictionary, facts: Dictionary, composure: float, roll_0_100: float) -> Dictionary`
Returns `{"state": <new state>, "events": <events_for(facts)>, "band": <StressRules.band(new stress)>, "new_outcome": "" | "virtue" | "affliction"}`.
Never mutates the input `state` (work on a deep copy).
1. For each event in order: `s = StressRules.apply(s, id, composure)`. STEELED rule: if the state's "virtue" == "STEELED", a GAINS
   event adds HALF its normal amount - after apply, set `s.stress = prev + (s.stress - prev) * 0.5` and take the same half back
   off that category in `s.history` (relief events are unchanged).
2. `s = StressRules.weekly_decay(s)`.
3. `before = s.get("outcome", "")`; erase "outcome" from s; `s = StressRules.resolve(s, composure, roll_0_100)`;
   new_outcome = s.get("outcome", "") (it is "" when stress < 100 - resolve then returns the state unchanged).

## New file 2: `Godot/tests/stress_week_test.gd`
`extends SceneTree`, `_init()` runs the checks, prints one line per check ("PASS <name>" / "FAIL <name>: got X want Y"), a final
`stress_week_test checks=<n> failures=<f>`, then `quit(0)` if no failures else `quit(1)`. Preload the module by path.
It must contain AT LEAST these contract cases, with these exact expected values (floats compared within 0.001):
- A. composure 60, state {}, facts {"training_days": ["hard","rest","hard"]} -> events ["hard_day","hard_day","rest_day"];
  stress after = 0.0 (3+3-6 = 0, decay keeps it 0); new_outcome "".
- B. composure 60, state {}, facts {"fight": {"result":"loss","method":"ko","knockdowns_suffered":2}} ->
  events ["loss_ko","knockdown","knockdown"]; stress 24.0 (22+5+5 = 32, decay 8); band "CALM"; history.trauma 32.0.
- C. composure 60, state {"stress": 95.0, "history": {"weight_cut": 30.0}}, facts {"weight_cut_pct": 6.0, "weigh_in": "failed"},
  roll 99 -> events ["inactive_week","severe_cut","failed_weigh_in"] (no training days and no fight = inactive); new_outcome "affliction"; state.affliction "STARVING"; stress 60.0.
- D. same as C with roll 10 -> new_outcome "virtue"; virtue "STEELED"; stress 50.0.
- E. composure 60, state {"stress": 50.0, "virtue": "STEELED"}, facts {"training_days": ["hard"]} -> stress 47.5
  (50 + 3*0.5 = 51.5, decay 4).
- F. composure 0 -> one "hard" day from stress 50 gives 50 + 4.8 = 54.8 then decay 4 = 50.8; composure 100 -> 50 + 1.8 - 4 = 47.8.
- G. ["hard","extreme","hard","hard","extreme"] -> events start ["hard_day","extreme_strain","hard_day","hard_day","extreme_strain"],
  then 4 x "back_to_back", then "overreach_week"; no "inactive_week".
- H. facts {} -> events ["inactive_week"]. facts {"fight": {"result":"draw","method":"sd"}} -> events [] (fight present, not inactive).
- I. win: {"fight": {"result":"win","method":"ud","title":true}} -> ["win_decision","title"]; method "tko" -> ["win_ko"].
- J. weight (each with "training_days": ["light"] so the week is not inactive): cut 4.0 + "made" -> ["cut_3_5","clean_cut"];
  cut 2.0 + "made" -> ["clean_cut"]; cut 5.0 + "made" -> ["severe_cut"].
- K. every id from 20 varied fact dictionaries is a key of StressRules.GAINS or StressRules.RELIEF.
- L. tick does not mutate its input state (compare a deep copy before/after).

## Acceptance
- CI on your PR is green (parse gate + changed tests). Locally if you can: `godot --headless --path Godot --script tests/stress_week_test.gd`
  exits 0 with `failures=0`. Do NOT compile or import the whole Godot project (it is large and has no LFS in the cloud) - only the
  parse check and this one test.
- Do not edit StressRules.gd or any other existing file. Do not delete or weaken any test.

## The one trap
The ORDER of events matters (stress clamps at 0 and 100 after every event): gains first, then relief, exactly as listed.

## Prior research
Ludo round 42 part B (operator-approved): stress meter, four afflictions OVERCOOKED / GUN-SHY / STARVING / FRAGILE, one virtue STEELED,
boxing-true causes, no random punishment. TASK_STRESS1A built the table this task feeds.
## What would a human do?
A systems designer writes a "what happened this week" record and one function that turns it into stress, with a test per rule.
## Prefab check
Game-specific rules; no library applies.

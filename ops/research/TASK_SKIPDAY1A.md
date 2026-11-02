# TASK SKIPDAY1A - a skipped day as one pure call + its preview (Ludo r32 5.3, operator-approved Q-S196-3) (S198)
Model: Qwen (qwen3-coder) - pure module, no UI, no GameState. Worktree E:/FightCamp/wt/NIGHTLY2. NEW branch qwen/skipday1a:
`git fetch && git checkout -B qwen/skipday1a origin/master`.

## Owned files
- `Godot/scripts/rules/SkipDay.gd` (NEW)
- `Godot/tests/skip_day_test.gd` (NEW)

## Spec (operator approved, board Q-S196-3 "approve all": "skipping a day = the coach runs it at 80-95% by skill, never below 25
stamina, half card drill, a preview of what you lose")
`class_name SkipDay extends RefCounted`, pure static, preload only `res://scripts/DayLap.gd` (pure). API:
`static func run(start_stamina: float, plan: Array, coach_skill: float, card_minutes: Dictionary, discipline: String = "") -> Dictionary`
- `plan` = DayLap orders (`{"station": id, "minutes": n}` / `{"idle": n}`); `coach_skill` on OUR 1-20 scale (clamp 1..20);
  `card_minutes` = {card_id: minutes the player planned to drill that card today}.
- EFFICIENCY = 0.80 + 0.15 * (coach_skill - 1) / 19  -> 0.80 at skill 1, 0.95 at skill 20 (named consts, comment the source).
- SAFETY FLOOR 25 (named const): walk the plan order by order; run each order through `DayLap.run_day` minute-limited so that the
  fighter never ENTERS a working minute below 25 stamina - at that point every remaining WORKING order is dropped (recovery orders
  with negative drain still run); report the dropped minutes per station in `dropped_minutes`.
- gains = DayLap gains of the minutes actually run x EFFICIENCY. injury_risk = 0.0 always (the coach never pushes into the red).
- cards: every card gets floor(minutes * 0.5) drilled (`card_minutes_done`), and `card_minutes_missed` = planned - done, PLUS all of
  its minutes if its station was dropped by the floor (a card id maps to its station through the plan order that names it:
  orders may carry `"card": id`).
- Return `{ok, efficiency, gains, end_stamina, injury_risk, dropped_minutes, card_minutes_done, card_minutes_missed, preview}` where
  `preview` = `{"lines": [ ... ]}` plain strings for the confirmation drawer, e.g. "82% of a full day (coach skill 7)",
  "Lead Hook 2 misses 45 drill minutes", "Ends the day at 34 stamina - no injury risk". `ok:false + reason` on a bad plan (pass
  DayLap's own refusal through).

## Test - `Godot/tests/skip_day_test.gd` (extends SceneTree; prints `SKIPDAY total=N fails=M`; quit(1) on fail)
(a) skill 1 -> efficiency 0.80, skill 20 -> 0.95, skill 10.5 -> 0.875; (b) gains == DayLap gains x efficiency for a plan that never
nears the floor (compare against DayLap.run_day directly); (c) a long heavy-bag plan from 40 stamina stops before any working minute
entered under 25, `dropped_minutes` > 0, end_stamina >= 24 (one minute's drain below the floor at most - say which in a comment);
(d) a recovery order after the drop still runs and raises stamina; (e) injury_risk is 0 even where DayLap alone reports > 0 for the
same plan; (f) cards: 90 planned -> 45 done / 45 missed; a card on a dropped station -> all minutes missed; (g) preview has a line
naming each card with missed minutes. 3 mutants named in your final message must each fail (e.g. efficiency on the 0-100 scale,
floor check on exit stamina instead of entry, cards not halved).

## Gates
- `python Godot/tools/check_scripts.py Godot/scripts/rules/SkipDay.gd Godot/tests/skip_day_test.gd`
- `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/skip_day_test.gd`
  -> exit 0, no FAIL, no SCRIPT ERROR. Typed GDScript (never := on a Variant). One Godot process at a time.

## Prior research
research/LUDO_ROUND32_S197.txt "5.3 Auto-Play Skip Rule" (lines ~535-570), LUDO_ROUND33_S198.txt "The Auto-Play Skip-Day
Mechanics", scripts/DayLap.gd (the clock rule: a minute reads the stamina it is ENTERED with), FLOORGAIN2 (the coach finishes a day at 0.8).
## What would a human do?
A head coach handing the floor to his assistant for the day writes down what will be cut short and checks it before leaving.
## Prefab check
None - our own rules.

## The one trap
DayLap's clock rule: gain and the floor check read the stamina the fighter ENTERS the minute with; drain applies after. Checking the
floor after the drain stops one minute early and (c) would still pass for the wrong reason - test the exact boundary minute.
Commit on qwen/skipday1a, push; never master; never open windows, image viewers or browsers.

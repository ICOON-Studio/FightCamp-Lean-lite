# TASK MORNING1 - the career morning rules (pure module + test)

Model: any strong coding model. Seat: Arena (own branch `arena/<chat-id>-<repo>`, open the PR yourself, NEVER merge).

## Goal (one paragraph)
FightCamp is a boxing gym-management game (Godot 4.7, GDScript). A career is a chain of MORNINGS. Time is frozen
inside a visit to the gym floor; one day passes when the visit ends; the player may SKIP a day only from the morning.
This task writes the RULES of those mornings as ONE pure static module + its data + ONE test. Nobody calls it yet;
Claude wires it into the game after the merge.

## Prior research
- `research/DAYLAP1_DESIGN.md` (the day is a lap of 600 minutes, 3 blocks of 200; stamina is the resource).
- `Godot/scripts/DayLap.gd`, `PitStop.gd`, `CoachPool.gd`, `MoveCards.gd` - the existing pure modules. COPY THEIR STYLE
  (static funcs, data JSON read once and cached, deep copy handed out, arguments never mutated, no GameState, no RNG,
  no autoload, no preload of game scripts).
- Existing diets: `Godot/assets/data/weight_classes.json` key `diet` has exactly three ids: `none`, `moderate`,
  `aggressive`. This module only NAMES which of the three a lived week files as; it never moves kilograms.
- G102 (hype research): hype is the bout's existing 0-100 number.

## What would a human do?
A boxing manager does not watch every day. A quiet week (no bout booked) passes in a minute or two. When a bout is
booked, the coach insists on seeing the fighter on the floor: once for a club debut, once a week for a pro bout, and
every day of the last week before a title. Food is the weight lever: skip the meal on a cardio day and the weight comes
off; keep it and it holds.

## Prefab check
None: game-specific rules. No new dependency.

## Files you OWN (create; touch nothing else)
1. `Godot/scripts/CareerMorning.gd` (new, ~200 lines)
2. `Godot/assets/data/career_morning.json` (new, all tuning numbers below)
3. `Godot/tests/career_morning_test.gd` (new, extends SceneTree, prints `PASS`/`FAIL <name>` lines and a final
   `CAREER_MORNING_TEST passed=<n> failed=<m>`, `quit(1)` when any failed, `quit(0)` otherwise)

## The rules (the spec - every number lives in career_morning.json, not in code)

### 1. Forcing - read from the booked bout
`static func bout_kind(bout: Dictionary) -> String`
- `bout` empty -> `"none"`
- `bout.title == true` -> `"title"`
- `bout.debut == true` OR `bout.level == "club"` -> `"club"`
- otherwise -> `"pro"`

`static func morning_forces_visit(bout: Dictionary, camp: Dictionary) -> bool`
`camp` = `{"day": int (0 = first camp day), "days": int (camp length in days, fight night = day == days),
"visits_this_week": int, "visits_this_camp": int}`.
- `"none"`: false.
- fight night (`day >= days`): false for every kind (the bout is the bout, not a lap).
- `"club"`: true while `visits_this_camp == 0`, then false for the rest of the camp.
- `"pro"`: true while `visits_this_week == 0` (each camp week = 7 days, week index = day / 7).
- `"title"`: true only when the morning is inside the LAST 7 days of the camp (`days - day <= 7`), every such morning;
  earlier weeks false.

`static func can_skip(bout: Dictionary, camp: Dictionary, at_home_morning: bool) -> bool`
- false when `at_home_morning` is false (skip only from the home morning - a visit holds the clock).
- otherwise `not morning_forces_visit(bout, camp)`.

`static func title_week_stops(bout: Dictionary, camp: Dictionary) -> Array`
- `"title"` inside the last 7 days -> `["blocks", "meal", "weigh_in"]`; otherwise `[]`.

### 2. Block stop choices and the bars
`static func block_choices() -> Array` -> exactly `["send_on", "rest", "leave"]`.

`static func stamina_word(stamina: float, strain: float) -> String`
- `"at_risk"` when stamina < 15 (data `risk_line`) or strain >= 80 (data `strain_high`)
- `"spent"` when stamina < 35, `"working"` when stamina < 75, else `"fresh"`.

`static func sending_on_holds(stamina: float, strain: float) -> bool` -> true when strain >= 80 AND stamina < 15:
sending him on from there becomes the existing medical hold (the caller applies it).

`static func strain_after(strain: float, station: String, minutes: int) -> float` -> strain + per-hour fill of the
station (data `strain_per_hour`: heavy_bag 10, pads 10, ring_sparring 16, weights 12, treadmill 6, bike 5,
speed_bag 4, defence_drill 6, recovery -20), clamped 0..100. Strain never changes what a minute pays.

### 3. The meal, the week diet
`static func meal_stamina(kept: bool) -> float` -> `meal_restore` (25) when kept, `skipped_restore` (8) when skipped.

`static func file_week_diet(days: Array) -> String`
Each lived day = `{"trained": bool, "meal": bool, "minutes": {station_id: int}}`.
- every day `meal == true` (or `days` empty) -> `"none"`
- a day with `meal == false` AND `trained == true` AND (`minutes.bike + minutes.treadmill`) >= `heavy_cardio_minutes`
  (90) -> `"aggressive"` (one such day is enough)
- else any day with `meal == false` AND `trained == true` -> `"moderate"`
- a skipped meal on a day he did NOT train (rest, ice, tape, physio, film only) counts as nothing for the diet -> if
  that is the only kind of skip, `"none"`.
The result is ALWAYS one of `none`, `moderate`, `aggressive`.

### 4. Coach tags (one tag stored on the hired coach)
`static func coach_tags() -> Array` -> exactly `["regional", "film", "pad_man", "conditioner"]`.
`static func tag_effects(tag: String) -> Dictionary` - every key present for every tag (defaults neutral):
- `gain_mult_by_station`: pad_man -> `{"heavy_bag": 1.15, "pads": 1.15}`; others `{}`.
- `recovery_mult_by_station`: conditioner -> `{"bike": 1.25, "treadmill": 1.25, "weights": 1.25, "recovery": 1.25}`
  (stamina comes back faster there); others `{}`.
- `move_minutes_mult`: conditioner 0.85; others 1.0.
- `film_depth_start`: film 2; others 0 (it applies only once a bout is booked - the caller checks).
- `known_first_combo`: regional true; others false.
- unknown tag -> the neutral dictionary.

### 5. Hype (the bout's existing 0..100 number - never a bar on the fighter, never changes a punch)
`static func booking_floor(card: int, feud: bool, gym_rivalry: bool, title: bool) -> int`
-> clamp(card + (10 if feud) + (6 if gym_rivalry) + (15 if title), 0, 100). `card` is the card's own base hype.
`static func week_hype(hype: int, floor: int, pushed: bool) -> int`
-> pushed: min(100, hype + 4); not pushed: max(floor, hype - 3). Never below `floor`.
`static func push_cost() -> int` -> 150 (cash, data).
`static func push_kinds() -> Array` -> `["poster", "quote", "photo"]`.

### 6. Go Watch (one later activity)
`static func go_watch_card_minutes(coach_went: bool, progress_minutes: int) -> int`
- adds 80 (coach went) or 40 (alone), but the result never reaches `usable_minutes` (120): one trip can START a move
  and cannot finish it -> return `min(progress_minutes + add, max(progress_minutes, 119))`.
`static func go_watch_film(layers: int, layers_this_week: int, film_coach: bool) -> Dictionary`
- first trip of the week (`layers_this_week == 0`): `layers + 1` (or `+2` for the film coach), capped at 3 total;
  returns `{"layers": n, "named_card": false}`.
- a second trip the same week: layers unchanged, `{"layers": layers, "named_card": true}` (it names one of his cards;
  it never skips a layer).
`static func go_watch_drain_mult() -> float` -> 0.6 (less than sparring = 1.0).

### 7. Week length targets (real minutes the player spends; data only, read back for a test)
`static func week_minutes_target(kind: String) -> Array` -> none [1, 2], club [8, 12], pro [12, 18], title [20, 30].

## Acceptance test (the ONE command)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/career_morning_test.gd`
must print `CAREER_MORNING_TEST passed=<n> failed=0` with n >= 40 and exit 0. Cover EVERY bullet above, including:
a club camp of 21 days where only the FIRST morning is forced after zero visits (then visits_this_camp=1 -> no day
forces); a pro camp of 28 days forces once per week; a title camp of 28 days forces days 21..27 and not day 20;
fight night never forces; can_skip false away from the home morning; file_week_diet returns each of the three ids
for a hand-built week; hype never falls below the floor across 6 unpushed weeks; go_watch never reaches 120 from 100.
Also prove the test can fail: a commented MUTANT block at the bottom (e.g. change 4 to 5 in the data) that the test
would catch - describe it in the PR body.

Parse gate first: `python Godot/tools/check_scripts.py Godot/scripts/CareerMorning.gd Godot/tests/career_morning_test.gd`

## The one trap
GDScript: `var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`). A variable name reused
inside one function is a parse error even across blocks. Do NOT delete or weaken any existing test. CI may not run
(minutes exhausted) - say so in the PR, do not "fix" CI by editing workflows.

## Rules
Everything you send is public: no secrets. Do not open images or start windows. Do not touch any file outside the
three you own. Open the PR from your own branch to master; do not merge it.

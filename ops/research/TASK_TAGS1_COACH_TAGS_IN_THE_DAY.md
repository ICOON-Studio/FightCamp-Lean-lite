# TASK TAGS1 - the coach's tag changes the played day (DayLapSplice)

Model: any strong coding model. Seat: Arena (own branch `arena/<chat-id>-<repo>`, open the PR yourself, NEVER merge).
DO NOT BUILD OR DOWNLOAD GODOT in your sandbox (a past run spent 25 min compiling it and died). Write the code and the
test, push, open the PR - CI and Claude run the test.

## Goal (one paragraph)
FightCamp is a boxing gym-management game (Godot 4.7, GDScript). A training day is a list of station orders that
`Godot/scripts/DayLapSplice.gd` (117 lines, pure static) turns into gains, stamina and move-card progress. A hired
coach carries ONE tag (`regional`, `film`, `pad_man`, `conditioner`); `CareerMorning.tag_effects(tag)`
(`Godot/scripts/CareerMorning.gd` lines 121-136, data `Godot/assets/data/career_morning.json` "coach_tags") already
returns what each tag does, but nothing applies it. Make `DayLapSplice.run` apply three of those effects when the
caller passes `ctx["coach_tag"]`.

## Spec
In `DayLapSplice.run(start_stamina, plan, ctx)` add one optional ctx key `coach_tag` (String, default `""`).
Read `var fx: Dictionary = CareerMorning.tag_effects(tag)` once (add `const CareerMorning := preload("res://scripts/CareerMorning.gd")`).
For each station order (the loop at ~line 80):
1. GAIN (pad_man): when the order has `"coach": true`, multiply that order's `mult` by
   `float(fx.gain_mult_by_station.get(station, 1.0))`. No coach at the station -> no effect (he holds the pads).
2. RECOVERY (conditioner): let `delta = leg.end_stamina - entering stamina`, `m = fx.recovery_mult_by_station.get(station, 1.0)`.
   If `m != 1.0`: delta > 0 -> delta * m; delta < 0 -> delta / m. New stamina = clamp(entering + delta, 0, 100).
   ("stamina comes back faster there" - drains less on bike/treadmill/weights, refills more at recovery.) Gains of the
   leg are NOT recomputed. Applies whether or not the coach stood there (it is his programme).
3. MOVE MINUTES (conditioner, 0.85): minutes that count on a move card = `roundi(minutes / fx.move_minutes_mult)`
   (a move needs 85% of the time) - pass that to `MoveCards.train`. Applies with or without the coach.
4. Add `"tag_gain": g, "tag_recovery": m` to each entry of the returned `orders` list ONLY when coach_tag is non-empty.
5. ctx without `coach_tag`, or `""`, or an unknown tag: the result must be EXACTLY what it is today (byte-identical
   dictionary - no new keys). `regional` and `film` change nothing here (their effects live elsewhere).
Update the header comment: one line per applied effect. Do not touch any other file except the new test.

## Owned files
- `Godot/scripts/DayLapSplice.gd` (117 lines; edit the `run` loop ~lines 44-116 and the preloads ~line 23).
- NEW `Godot/tests/daylap_coach_tags_test.gd`.

## The test (new file `Godot/tests/daylap_coach_tags_test.gd`, `extends SceneTree`, prints `FAIL: ...` per failure,
ends `print("DAYLAP_COACH_TAGS_TEST FAILS=%d" % fails)` and `quit(1 if fails else 0)`) - copy the shape of
`Godot/tests/daylap_splice_test.gd`. Plan P = pads 60 min with coach + card `jab`, heavy_bag 60 min no coach, bike 60,
recovery 30 (use station ids that exist in `assets/data/day_lap_stations.json`; check them). Arms:
- A: no tag vs `""` vs `"nonsense"` vs `"regional"` vs `"film"` -> all equal to the no-ctx-key run (compare with `==` and
  `var_to_str`).
- B: `pad_man` -> pads gains = A's pads gains x 1.15 (within 1e-6 per stat); heavy_bag gains unchanged (no coach there);
  add a plan with heavy_bag + coach -> x 1.15.
- C: `conditioner` -> end_stamina higher than A's; at the recovery order the stamina gain is 1.25x A's (within 1e-6);
  `progress["jab"]` minutes = roundi(60 / 0.85) = 71 (vs 60 in A).
- D: mutant check written as a comment block telling how to break it (set 1.15 -> 1.0 in the JSON: B must FAIL).
Population line printed first: `population: one plan, five tags, no fighter`.

## Gate
Parse: `python Godot/tools/check_scripts.py Godot/scripts/DayLapSplice.gd Godot/tests/daylap_coach_tags_test.gd`.
Test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/daylap_coach_tags_test.gd` (CI runs it).
Neighbours that must stay green, UNCHANGED (do not edit them): `tests/daylap_splice_test.gd`, `tests/day_lap_test.gd`,
`tests/career_mornings_path_test.gd`.

## Prior research
`python Tools/prior_research.py coach tag pad_man conditioner DayLapSplice` -> S176_DIGEST.md ("The coach tag effects
are encoded (tag_effects) but not yet applied in DayLapSplice") and TASK_MORNING1_CAREER_MORNING_RULES.md section 4
(the effect definitions). No study sets the numbers: they are the operator's (+15%, 85%) and labelled in the JSON.

## What would a human do?
A designer gives each coach one visible strength the player can feel within one day: the pad man's pads session pays
more, the conditioner's fighter recovers on the bike and learns moves sooner. Apply it at the one place the day is
computed so the HUD and the engine cannot disagree.

## Prefab check
Nothing to buy: this is a 20-line rule inside our own pure module.

## The one trap
Byte-identity: with no tag the returned dictionary must be identical - do NOT add the new `orders` keys or any
float multiply-by-1.0 that changes a value's type. CI has no Git LFS: do not load any model or texture.

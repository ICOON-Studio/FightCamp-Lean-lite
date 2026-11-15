# TASK MORNINGS1 - coached mornings and the weak spot: the club week's morning maths (pure module + test)

Status: OPEN (S483, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
The owner said "Yes, build it after the fight week" to the club week (board Q-S294-241). Its map,
ops/research/DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md sections 3.5 and 3.3 (WEAK SPOT), is the spec; this brief copies every
number you need. Its probe MORNINGS1 (map section 9, probe 5) needs this maths as code first. Nothing calls it yet (Claude
wires it later). Pure rules only: no game state, no UI.

## What to build: scripts/rules/CoachedMornings.gd (extends RefCounted; pure static; NO preload, NO class_name)
Constants at the top (tags as in the map; ESTIMATE = a design value a probe will check):
- SOLO := 1.25, SOLO_WEAK := 1.4, SHARED := 1.15, MORNING_PADS := 0.8, NOT_COACHED := 1.0
- YOU_OWNED := 4, COACH_OWNED := {"sessional": 2, "full_time": 3, "none": 0}
- FIGHT_ABILITIES := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]   (the six the fight reads,
  BoutRules.fight_power)
- WEAK_GAP := 3.0
- FINDS := {"defense": "pressure fighters", "conditioning": "volume punchers", "fight_iq": "counter-punchers",
  "speed": "out-boxers", "power": "sluggers", "technique": "counter-punchers"}
- WORDS := {"power": "Power", "speed": "Speed", "technique": "Technique", "defense": "Defence", "conditioning": "Cardio",
  "fight_iq": "Ring IQ"}

Functions:
1. `owned(coach_kind: String) -> int` - coached mornings in a week: YOU_OWNED + COACH_OWNED.get(coach_kind, 0)
   (sessional 6, full_time 7, none 4).
2. `mult(use: String, on_weak: bool) -> float` - the multiplier on a morning's normal gain: "none" -> 1.0; "solo" -> 1.4 when
   on_weak else 1.25; "shared" -> 1.15; anything else -> 1.0. ("pads" is not a stat morning: see pads_rate.)
3. `pads_rate() -> float` - MORNING_PADS (0.8: a morning pad turn runs at 0.8 of the pads rate).
4. `weak_spot(stats: Dictionary) -> String` - the lowest of FIGHT_ABILITIES (missing = 0.0) that is at least WEAK_GAP under
   the fighter's level (the mean of the six); "" when none is. A tie for lowest goes to the earlier id in FIGHT_ABILITIES.
5. `weak_line(stats: Dictionary) -> String` - "" when no weak spot, else "Low <WORDS[id]>: <FINDS[id]> find it"
   (example: "Low Defence: pressure fighters find it").
6. `deal(asks: Array, coach_kind: String) -> Array` - hands out the week's coached mornings. asks = [{"id": String,
   "ability": String, "use": "solo"|"shared"|"pads", "weak": bool}], in priority order. Walk the list in order; a "solo" or
   "pads" ask takes 1 morning; a "shared" ask takes 1 morning that also covers the NEXT "shared" ask in the list with the
   same ability (both get the shared multiplier; the second takes no extra morning). When the owned mornings run out, the
   rest get use "none". Return one dict per ask, same order: {"id", "ability", "use", "mult"} where mult = mult(use, weak)
   for "solo"/"shared"/"none" and pads_rate() for "pads". A "shared" ask with no partner left in the list counts as "solo".
7. `added(dealt: Array) -> float` - the week's extra in morning-equivalents: sum over dealt of (mult - 1.0) for stat uses
   ("solo", "shared"); "pads" and "none" add 0.0.
Comment block at the top in the house style: what it is, the owner's ruling (Q-S294-241 "Yes, build it after the fight
week"), the map sections, one usage line per function.

## Test: tests/coached_mornings_test.gd (extends SceneTree; preload the module by path; prints "ok   <what>" /
"FAIL <what>", ends with one line `COACHED_MORNINGS PASS fails=0` or `COACHED_MORNINGS FAIL fails=<n>`, quit(0) on pass,
quit(1) on fail)
Cover at least: owned("sessional") == 6, owned("full_time") == 7, owned("none") == 4, owned("x") == 4; mult("solo", false)
== 1.25, mult("solo", true) == 1.4, mult("shared", false) == 1.15, mult("none", true) == 1.0; weak_spot of
{power 50, speed 50, technique 50, defense 44, conditioning 50, fight_iq 50} == "defense" (mean 49, 44 is 5 under);
weak_spot of all 50 == ""; weak_spot of {defense 48, others 50} == "" (48 is under 3 below the mean 49.67); a tie
(defense 40, speed 40, others 50) == "speed"; weak_line for the defence case == "Low Defence: pressure fighters find it";
deal: 6 solo asks + 1 more with "sessional" -> the 7th gets "none"; two "shared" asks on the same ability take 1 morning and
both read 1.15; a lone "shared" reads as "solo" 1.25; "pads" reads 0.8 and adds 0.0; added of 6 shared (3 pairs) == 0.9
(6 x 0.15) using 3 mornings; added of 6 solo == 1.5.

## Pass lines
RESULT: tests/coached_mornings_test.gd -> COACHED_MORNINGS PASS fails=0
(Arena's runner has no Godot: write the code and test exactly to this brief; Claude runs the test on the PC.)

## Contract
OWNS: scripts/rules/CoachedMornings.gd, tests/coached_mornings_test.gd
RED_TEST: tests/coached_mornings_test.gd -> COACHED_MORNINGS PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/coached_mornings_test.gd (the only caller; no game system calls it yet)
VISUAL: no
NOT YOURS: every other file. Both files under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/coached_mornings_test.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge.

## Prior research
DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md 3.5 (the multipliers and what 6 mornings add: shared +1.8 over 12 sessions, solo
+1.5, one weak spot +2.4) and 3.3 (WEAK SPOT: the lowest ability the fight reads, 3+ under the fighter's level, with who finds
it). BoutRules.fight_power reads the six FIGHT_ABILITIES. CoachAreas: coach factor 0.5 + rating x 0.7%.

## What would a human do?
A coach with six mornings to give either works one boxer's hole alone or runs two through the same drill; working the hole
pays most on that one thing, pairing pays more in total.

## Prefab check
None: game-specific rules, a few lines of pure GDScript.

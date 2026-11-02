# TASK PROGSIGNS1 - progression you can see: ring, posture, gain floaters, snap (Ludo r105 D1-D4 as one pure rules module)

Seat: SuperGrok Expert (grok.com, shell-less) - answer with the two complete files in code blocks; Claude tests, wires and merges.
Model: Grok Expert. Discipline: BOXING (the demo). Godot 4.7.2 GDScript.

## Why
Operator LOOP1 approval (Q-S237-1): "the loop, animations, workout, feeling of progression and improvement from training these are what
matters for now". Lead designer Ludo r105 part D ranked five visible progression signs; #1 (work clip faster with skill) is live. This
module gives the game the NUMBERS for #1's blend time and #2-#4; Claude wires them into the 3D floor.

## Deliver 1 - `Godot/scripts/rules/ProgressionSigns.gd`
`extends RefCounted`, NO class_name, NO preload, NO autoload, NO Node, static funcs only, typed GDScript 4 (no `:=` on Variant values -
write the type: `var x: float = float(d.get("k", 0.0))`). Every design value a named const with a comment "Ludo r105 D<n>".
1. `static func snap(technique: float, speed: float) -> Dictionary` (D1): avg = clamp((technique+speed)/2, 0, 100);
   returns {"speed_scale": lerp(0.85, 1.30, avg/100), "blend_s": lerp(0.18, 0.05, avg/100), "return_scale": lerp(1.0, 1.85, technique/100)}.
2. `static func station_ring(stat: float) -> Dictionary` (D2): stat <= 50 -> radius_m 1.4, colour "#FBBF24", alpha 0.30, jitter_m 0.04;
   stat >= 80 -> radius_m 0.375 (0.75 m DIAMETER), colour "#2DD4BF", alpha 0.80, jitter_m 0.0; between 50 and 80 interpolate radius,
   alpha, jitter linearly and the colour channel-wise (return the colour as "#RRGGBB"). Returns {"radius_m","colour","alpha","jitter_m","band": "novice"|"improving"|"mastered"}.
3. `static func idle_posture(conditioning: float, fatigue: float) -> Dictionary` (D3): effective = conditioning - 0.5 * max(fatigue - 50, 0);
   effective < 50 -> {"torso_pitch_deg": 12.0, "hands_on_hips": true, "head_down": true, "bounce": false, "band": "spent"};
   effective > 75 -> {"torso_pitch_deg": 0.0, "hands_on_hips": false, "head_down": false, "bounce": true, "band": "sharp"};
   between: pitch interpolates 12 -> 0, hands_on_hips false, head_down false, bounce false, band "steady".
4. `static func gain_floaters(before: Dictionary, after: Dictionary, best: Dictionary) -> Array` (D4): before/after = stat name -> float
   (keys among technique, speed, power, conditioning, chin, defense, fight_iq); best = the fighter's previous personal best per stat.
   For every stat whose after - before >= 0.05 return one floater {"stat","text","colour","font_px","rise_m":0.8,"fade_s":1.2,"pop":bool,"milestone":bool}:
   regular -> text "+0.2 SPD" (delta to 1 decimal, 3-letter upper code: TEC SPD POW CON CHN DEF IQ), colour "#CBD5E1", font_px 12, pop false;
   MILESTONE when the after value crosses a multiple of 10 that it had not reached before (floor(after/10) > floor(before/10)) OR beats
   best[stat] by >= 1.0 -> text "★ MILESTONE: 80 SPEED" (the crossed multiple of 10, or the new best rounded, full stat word upper-case),
   colour "#F59E0B", font_px 16, pop true. At most 3 floaters, milestones first, then largest delta. Deterministic order on ties (stat name).
5. `static func band_changed(before: float, after: float) -> bool` - true when station_ring(before).band != station_ring(after).band.

## Deliver 2 - `Godot/tests/progression_signs_test.gd`
`extends SceneTree`, `func _initialize() -> void:`, `const PS = preload("res://scripts/rules/ProgressionSigns.gd")`, prints one line
`PROGRESSION_SIGNS failures=N checks=M` then `quit(1 if failures > 0 else 0)`. THREE different boxers as fixtures (never identical:
a raw 0-0-0 welterweight tech 38/speed 44/cond 41, a 9-3 middleweight tech 63/speed 58/cond 70, a 21-1 lightweight tech 86/speed 91/cond 88).
At least 25 checks: snap ends (0 and 100) and ordering across the 3 boxers (better boxer = higher speed_scale, lower blend_s); ring at
40/50/65/80/95 (radius strictly shrinking 50->80, colour hex at 65 between the two, bands); posture bands incl. fatigue 90 pulling a
cond-78 boxer out of "sharp"; floaters: +0.2 regular, a 79.6->80.1 milestone "★ MILESTONE: 80 SPEED", a new-best milestone, cap of 3 with
milestones first, no floater for a 0.01 change, empty dicts -> []; band_changed true 49->51, false 60->70.

## Rules
GDScript 4.7 traps: no `:=` from Dictionary.get/Variant; `%` formatting needs `%%` for a literal percent; no reused local names in one
func; typed `Array[Dictionary]` only when every element is a Dictionary. THE ONE TRAP: the test must be able to FAIL - assert exact
values, never `>= 0`.

## Prior research
Ludo r105 part D (above, quoted values); live: GymHall3D.skill_clip_speed uses the same 0.85..1.30 lerp (keep it identical).

## What would a human do?
Watch a boxer for a week and see it: the tight feet, the upright chest between rounds, the snap on the return - and a small gold
"80 SPEED" the day he gets there.

## Prefab check
None - 150 lines of our own design numbers.

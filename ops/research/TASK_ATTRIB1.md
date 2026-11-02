# TASK ATTRIB1 - the 11 boxer attributes as one pure rules module (Arena). Model: Arena (cloud). Discipline: BOXING (demo).
Status: OPEN
Operator board Q-S256-1 (S259): "add them all , wire them properly to training and fight" - approves
research/ATTRIBUTES_S259_VERDICT.md (Ludo S259, research/ludo_rx/LUDO_ATTRIBUTES_S259.txt). This task is PART A only: the
pure module + its test. Claude wires it into the save, the gym and the fight (Part B) on this module's contract.

## Prior research
- research/topics/attributes_skill.md (canonical page); ATTRIBUTES_S259_VERDICT.md; LUDO_ATTRIBUTES_S259.txt sections 1-5 (every
  number below comes from there); same gain shape as scripts/rules/MoveMastery.gd and CornerShouts.gd (read them for style).

## What would a human do?
A boxing coach thinks in exactly these: fast hands vs quick feet, a tight guard vs a slick head, a cool head under fire, how fast
he recovers on the stool. Football Manager / Fight Night split attributes the same way; one number per visible behaviour.

## Prefab check
None: no Godot asset/library models boxing attributes; this is game rules (pure GDScript, like the other scripts/rules modules).

## Build: `Godot/scripts/rules/Attributes.gd` (NEW) - `extends RefCounted`, ALL functions `static`, ZERO preloads, no autoloads,
no file reads, no RNG, never mutates an argument. Every function documents its source (Ludo section) in a `##` comment.

1. `const ATTRS := ["hand_speed","footwork","guard","head_movement","technique","power","conditioning","fight_iq","composure","recovery","chin"]`
   `const INNATE := ["chin"]`; `aggression` stays a mental trait outside ATTRS; `grapple` is not touched (MMA, parked).
2. `static func migrate(old: Dictionary) -> Dictionary` - returns a COPY of `old` with every ATTRS key added when MISSING (an existing
   key is never overwritten; old keys speed/defense/grapple/aggression are KEPT so today's readers still work). Missing old inputs = 50.
   hand_speed = round(speed*0.70 + technique*0.30); footwork = round(speed*0.60 + fight_iq*0.40);
   guard = round(defense*0.70 + chin*0.30); head_movement = round(defense*0.60 + speed*0.40);
   composure = round(fight_iq*0.50 + defense*0.30 + chin*0.20); recovery = round(conditioning*0.70 + chin*0.30);
   technique/power/conditioning/fight_iq/chin copied. Each new value clamped to [1, 99].
   ALL-50 fighter -> every attribute 50 (the test proves it).
3. `static func derived(s: Dictionary) -> Dictionary` (Ludo section 1, inputs default 50):
   accuracy = technique*0.60 + fight_iq*0.25 + hand_speed*0.15; evasion = head_movement*0.50 + footwork*0.35 + fight_iq*0.15;
   ko_leverage = power*0.70 + technique*0.30; damage_mitigation = guard*0.65 + composure*0.20 + technique*0.15;
   trauma_threshold = chin*0.60 + composure*0.25 + conditioning*0.15.
4. Training (Ludo section 2). `const STATIONS := {attr: {"stations": [...], "pts_hr": f, "cap": int or -1 (-1 = the fighter's gen_cap),
   "decay_day": f, "age_pivot": int}}` with EXACTLY: hand_speed [speed_bag, focus_mitts] 0.35 cap -1 decay 0.15 pivot 27;
   footwork [jump_rope, agility_ladder] 0.40 -1 0.12 28; guard [double_end_bag, sparring] 0.30 95 0.05 34;
   head_movement [slip_bag, focus_mitts] 0.35 -1 0.10 29; technique [heavy_bag, shadowbox] 0.25 99 0.02 36;
   power [heavy_bag, medicine_ball] 0.20 -1 0.08 33; conditioning [roadwork, air_bike] 0.50 95 0.25 26;
   fight_iq [film_study, sparring] 0.20 99 0.0 40; composure [sparring, ice_bath] 0.15 90 0.04 35;
   recovery [pool, physio] 0.30 -1 0.18 25; chin [] 0.0 cap -1 decay 0.0 pivot 24.
   `const GROUP := {"twitch": [hand_speed, footwork, recovery], "density": [power, guard, technique], "wisdom": [fight_iq, composure]}`
   (head_movement and conditioning count as twitch).
   `static func gain(attr: String, current: float, hours: float, coach_eff: float, age: int, gen_cap: float = 99.0) -> float` =
   pts_hr * hours * coach_eff * max(0, 1 - (current / cap)^1.6) * age_factor; cap = gen_cap when -1 else min(cap, gen_cap);
   age_factor: twitch -> 0.6 when age >= 32 else 1.0; density/wisdom -> 1.0. chin (innate) -> 0.0 always.
   Returns the POINTS gained (>= 0), never more than cap - current.
   `static func decay(attr: String, current: float, idle_days: float, age: int) -> float` = points LOST (>= 0):
   decay_day * idle_days * (1.12 ^ max(0, age - age_pivot + 1) for twitch, else 1.0); fight_iq 0; chin 0; never below 1.
   `static func wisdom_round_gain(attr: String) -> float` = 0.05 for fight_iq / composure (per sanctioned round boxed), else 0.
   `static func chin_after(chin: float, flash_knockdowns: int, ko_losses: int) -> float` = chin - 1.5*kd - 4.0*ko, floor 1.
5. Motion (Ludo section 3) - `static func motion(s: Dictionary, tank01: float = 1.0) -> Dictionary`: each value is a LINEAR map of
   its attribute from 20 -> 80 (clamped outside 20..80), names and units exactly:
   jab_extend_s 0.275 -> 0.200, jab_retract_s 0.245 -> 0.180, cross_extend_s 0.360 -> 0.280 (hand_speed);
   step_speed_mps 1.10 -> 2.45, step_cycle_s 0.360 -> 0.180, pivot_dps 140 -> 380, resets_per_min 8 -> 26 (footwork);
   glove_height_m -0.12 -> 0.06, elbow_flare_deg 24 -> 4, block_recoil_m 0.14 -> 0.03 (guard);
   slip_lean_deg 6 -> 22, slip_speed_mps 0.85 -> 2.30, slip_reset_s 0.420 -> 0.140 (head_movement);
   straight_elbow_flare_deg 28 -> 2, fist_turn_deg 45 -> 90 (technique);
   hitstop_frames 1 -> 3, target_head_disp_m 0.04 -> 0.16 (power);
   flinch_deg 24 -> 4, hitstun_s 0.380 -> 0.090 (composure);
   range_error_m 0.35 -> 0.06, range_fix_s 1.40 -> 0.25, feint_bite 0.72 -> 0.14 (fight_iq).
   Fatigue (conditioning tank, tank01 0..1): below 0.5, per 0.1 lost: glove_height_m -0.03, stance_narrow_m +0.04 (key
   `stance_narrow_m`, 0 above half tank), jab_extend_s / jab_retract_s / cross_extend_s +0.015 each.

## Test: `Godot/tests/attributes_test.gd` (NEW, `extends SceneTree`, prints `ATTRIBUTES failures=<n>`, quit(1) on any failure)
Two DIFFERENT fighters (e.g. a fast technician {speed 80, technique 75, defense 60, fight_iq 70, chin 55, conditioning 65, power 50}
and a slow banger {speed 40, technique 50, defense 45, fight_iq 45, chin 80, conditioning 70, power 85}) plus an all-50 control:
- migrate: all-50 -> all ATTRS 50; existing key kept (input hand_speed 33 stays 33); old keys still present; input not mutated;
  the two fighters migrate to different hand_speed/footwork/guard/head_movement (print them).
- derived: all-50 -> accuracy 50, evasion 50, ko_leverage 50, damage_mitigation 50, trauma_threshold 50.
- gain: hand_speed at 50, 10 h, coach 1.0, age 24 -> 0.35*10*(1-(50/99)^1.6) (assert to 1e-4); at cap -> 0; age 33 twitch ->
  x0.6; chin -> 0; never exceeds cap - current.
- decay: fight_iq 0; hand_speed age 30 pivot 27 -> 0.15*days*1.12^4; never below 1.
- motion: hand_speed 20 -> jab_extend_s 0.275, 80 -> 0.200, 50 -> 0.2375, 95 -> 0.200 (clamped); tank01 0.3 -> glove_height_m
  lowered by 0.06 and jab_extend_s +0.03 vs tank 1.0.
- chin_after(70, 2, 1) == 63.0.
- MUTANT PROOF (in the PR body): flip one migrate weight or one motion endpoint and show the test going red.

## Contract
OWNS: Godot/scripts/rules/Attributes.gd, Godot/tests/attributes_test.gd
RED_TEST: Godot/tests/attributes_test.gd -> ATTRIBUTES failures=0
REGRESSION: attributes_test
VISUAL: no

## Run
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/rules/Attributes.gd Godot/tests/attributes_test.gd`.
Test: `godot --headless --path Godot --script tests/attributes_test.gd`. The PR body carries:
`RESULT: tests/attributes_test.gd -> ATTRIBUTES failures=0`.
Plain `--script` tests are the OFF control arm (as_game turns the game switches on) - this module has no switch (pure rules).

## The one trap
Do NOT edit any other file (FightLink.gd, FightRealtime.gd, GameState.gd, MoveMastery.gd): Claude wires Part B. Do not delete or
weaken any existing test.

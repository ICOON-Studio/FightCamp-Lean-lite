# TASK FOOTCONTACTS1 - find a captured step's own foot plants (pure module + test)

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo).

## Why (Claude S274, FOOTWORK_PLAN_S273.md step 5)
The fight's feet skate on 13-15 % of planted frames because a procedural planner pins feet where it guesses, not where the
actor planted them. With captured steps (StepPicker.gd + StepIntent.gd on master, Ziva cutting the library) the foot lock must
pin a foot ONLY on the frames where the take's own foot was planted, and release it on the take's own lift. This module
finds those frames from the take's foot positions. You do not touch the player or the probe.

## What to write
`Godot/scripts/rules/FootContacts.gd` - `extends RefCounted`, PURE (static funcs, zero preloads, no file read, no RNG, no
argument modified). Header style of `Godot/scripts/rules/StepPicker.gd`.

1. `plants(track: Array, fps: float, floor_y: float = 0.0) -> Array` - `track` = one foot's world positions per frame
   (Vector3, metres). Returns `[{ "from": int, "to": int, "at": Vector3 }]`, frame ranges (inclusive) where the foot is
   PLANTED, `at` = the mean position over the range.
   PLANTED frame: horizontal speed (x/z, centred difference; one-sided at the ends) <= SPEED_MPS (0.25, the same threshold
   as tools/fight_motion_probe.gd planted_skate) AND height <= floor_y + HEIGHT_M (0.06).
   Debounce: a planted run shorter than MIN_FRAMES (3) is dropped; a gap of <= GAP_FRAMES (2) unplanted frames between two
   planted runs whose `at` points are within 0.03 m is merged (mocap jitter).
2. `skate(track: Array, plants: Array) -> float` - the largest horizontal drift (m) of the foot from its plant's `at` inside
   any plant (what a foot lock must remove; 0 for a perfect take).
3. `both(left: Array, right: Array, fps: float, floor_y: float = 0.0) -> Dictionary` -
   `{"left": plants, "right": plants, "airborne": Array of [from, to] where NEITHER foot is planted}` (a boxer's step should
   have at most a few airborne frames; a long airborne run flags a bad cut).

## The test
`Godot/tests/foot_contacts_test.gd` - `extends SceneTree`, preload the module only, `_check` + `print("FOOT_CONTACTS failures=%d")`,
`quit(1 if failures > 0 else 0)`. SYNTHETIC tracks built in the test (30 fps):
- a foot standing still 20 frames -> one plant 0..19, at = its position;
- stand 10, lift and move 0.35 m forward over 8 frames at 0.1 m height, stand 12 -> two plants with the right ranges, the
  second `at` 0.35 m ahead;
- the same with 1 cm random-free jitter (a fixed sine pattern, no RNG) -> still two plants (jitter merge works);
- a planted foot sliding 0.20 m/s (under the threshold) for 15 frames -> one plant, skate() reports the drift (~0.10 m);
- a 2-frame planted blip mid-swing -> dropped (MIN_FRAMES);
- height 0.08 m and still -> NOT planted (a hovering foot is not a plant);
- both(): a step where the left lifts while the right stays -> airborne empty; a hop where both lift 6 frames -> airborne
  one range of 6 frames;
- empty track -> []; the input arrays unchanged (compare to duplicate()).
RED on master (module missing), green with yours. PR body: one MUTANT proof (raise SPEED_MPS to 1.0 -> which check goes red).

## Parse gate and tests
`python Godot/tools/check_scripts.py scripts/rules/FootContacts.gd tests/foot_contacts_test.gd`;
`$GODOT --headless --path Godot --script tests/foot_contacts_test.gd`. Pure - no LFS. PR body:
`RESULT: tests/foot_contacts_test.gd -> FOOT_CONTACTS failures=0`.

## Owned files
Godot/scripts/rules/FootContacts.gd (new), Godot/tests/foot_contacts_test.gd (new). Nothing else.

## Prior research
FOOTWORK_PLAN_S273.md (step 5: foot lock only on the take's own contact frames), tools/fight_motion_probe.gd lines 732-752
(planted_skate: 0.25 m/s, both-feet-down rule), S258 FIGHTMOTION1 (skate 26-28 % -> 13-15 %).

## What would a human do?
An animator scrubs the take and marks "foot down" where the heel stops moving and "foot up" where it leaves the floor -
then locks only between those marks.

## Prefab check
Foot-contact detection is standard in mocap cleanup (MotionBuilder, Cascadeur auto-contacts); nothing for Godot 4.7 we can
drop in. ~100 lines.

## The one trap
Never loosen SPEED_MPS or HEIGHT_M to make a synthetic case pass - a "plant" that slides is the skate we are removing; the
drift goes to skate(), visibly.

## Contract
OWNS: Godot/scripts/rules/FootContacts.gd, Godot/tests/foot_contacts_test.gd
RED_TEST: Godot/tests/foot_contacts_test.gd -> FOOT_CONTACTS failures=0
REGRESSION: foot_contacts_test
VISUAL: no

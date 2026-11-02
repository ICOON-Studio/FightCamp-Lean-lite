# TASK BROADCASTCUT1A - broadcast camera auto-cut on big moments (pure decision module + blind test)

Model: OpenCode (cloud, `/oc` on the issue). Repo ICOON-Studio/FightCamp, its own branch + PR into master; never merge.
Approved: operator board Q-S205-2 "keep Godot, take the 4 ideas (recommended)" - idea 2 from his Game Notes Sheet8: the fight
camera cuts on a significant hit instead of one fixed broadcast angle. This task is ONLY the pure decision rules; wiring it to the
live fight camera (behind a switch, OFF until the operator OKs a video) is a later task.

## Our camera facts (read, do not change)
`Godot/scripts/FightCameraRig.gd` (199 lines) holds the named shots ("broadcast" = the live default, "standing", "house_wide"...).
Operator rule S191: every STILL must show both men head to feet - so every shot this module may choose must keep BOTH fighters in
frame: allowed shots are "broadcast", "broadcast_tight" and "reverse_broadcast" (new names; the wiring task will add their numbers).

## Spec - NEW `Godot/scripts/rules/BroadcastCut.gd` (`extends RefCounted`, `class_name BroadcastCut`, static funcs, PURE: no
preload/load, no GameState, no Node, no files, no randomness - variety comes from the beat index; never mutate arguments)
`const SHOTS := ["broadcast", "broadcast_tight", "reverse_broadcast"]`, `const MIN_HOLD_S := 3.0`, `const BIG_DAMAGE := 10.0`,
`const RETURN_AFTER_S := 4.0`.
1. `static func next_shot(state: Dictionary, beat: Dictionary, now_s: float) -> Dictionary` - state = {"shot": String,
   "since_s": float, "cuts": int} (empty dict = start on "broadcast" at now_s); beat = one presenter beat {"type", "damage",
   "knockdown": bool, "contact": String, "round_end": bool}. Returns the NEW state (a new dict):
   - never cut before MIN_HOLD_S has passed on the current shot (except a knockdown, which always cuts);
   - a knockdown or damage >= BIG_DAMAGE on a landed contact ("clean"/"solid") cuts to the next shot in SHOTS after the current
     one (cycling, skipping the current), cuts += 1;
   - round_end always returns to "broadcast";
   - on any other beat, a non-broadcast shot held for RETURN_AFTER_S returns to "broadcast";
   - otherwise unchanged (same dict values, new dict).
2. `static func is_allowed(shot: String) -> bool` -> shot in SHOTS.

## Test - NEW `Godot/tests/broadcast_cut_test.gd` (SceneTree `_initialize()`, prints `BROADCAST_CUT total=N fails=M`, quit(1) on
fail, `const BroadcastCut = preload("res://scripts/rules/BroadcastCut.gd")`). Blind, from this contract: a scripted 60 s round of
beats (literal array) -> no two cuts closer than 3 s except knockdowns; every chosen shot is_allowed; a damage-9 beat never cuts, a
damage-10 clean beat does; a damage-20 MISS does not cut; round_end returns to broadcast; a tight shot returns after 4 s of quiet;
deterministic (same input twice -> same output); inputs not mutated; an inline MUTANT (MIN_HOLD_S = 0) must fail a check; a
source scan of BroadcastCut.gd for preload / load( / GameState / randf / randi / Node / FileAccess (must be absent).

## Owned files
The two new files only. GDScript 4 syntax: `const` (never `static const`), `for x in arr`, `dict.has()`, `_initialize()`.
Gate: `python Godot/tools/check_scripts.py <both files>`, then the test -> fails=0; CI green. Never delete or shrink a test.

## Prior research
GAME_NOTES_SHEET8_REVIEW_S206.md (idea 2), topics/camera_broadcast.md (our broadcast camera history), FightCameraRig.gd.

## What would a human do?
A TV director's rule set: hold a shot long enough to read, cut on the big moment, come home to the wide when it calms down.

## Prefab check
None - 60 lines of rules.

## The one trap
A cut on every punch is unwatchable - the minimum hold is the feature, not a detail.

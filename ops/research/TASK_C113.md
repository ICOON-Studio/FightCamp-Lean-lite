# TASK C113 — CODEX — WHERE DOES A PUNCH END? HAND-TO-TARGET DISTANCE AT CONTACT, IN THE LIVE ROOM

Model: `gpt-5.6-luna`, medium (the only setting). Owner: codex. Main checkout, launched by Claude through
`Tools/codex_task.cmd`. Stage: S4a (every action reads as a real fight) - forecast work: the instrument for "range
follows the take".

**Test tier: A NEW TOOL FILE ONLY, no game script edited.** Parse gate on your tool, then run it HEADLESS (two
variants x three seeds, a few minutes). No test suite. No commit: your sandbox cannot write `.git`; Claude commits.
`python research/C113_check.py` must exit 0.

## Owned files

- `Godot/tools/measure_contact_clearance.gd` - NEW, yours.
- `research/C113_contact_clearance.json` - NEW, written by your tool.
- `research/C113_CONTACT_CLEARANCE.md` - NEW, yours, 30 lines at most.

## Why this exists

On 2026-09-14 every striking role started carrying its source hips' travel (`087a3c9`): planted-foot skate fell
0.218 -> 0.172 m/s, because the mocap punches STEP IN. The cost: on a still body the hand now reaches further from
the fighter's origin (jab 0.82 -> 1.03 m, hooks 0.65 -> 0.99 m), and the room's distances (LONG 1.10, MID 0.95,
POCKET 0.80 m between the two bodies) were set with pinned hips. Nobody has measured where a punch actually ENDS
relative to the other man. That number decides the next build step.

## What to read - ONLY these

- `Godot/tests/fight_stage_realism_test.gd` (935 lines - NEVER open it whole): `sed -n '30,40p'` (FPS, SEEDS,
  ROUNDS), `sed -n '86,147p'` (how it mounts `FightWorldLive.tscn`, passes `sway_roles`, and steps the room with
  `live.call("_process", dt)`), `sed -n '149,232p'` (`_side_context` and `_sample`: bone world positions from
  `skel.get_bone_pose` composed parent-first times the node chain's transform - a headless Skeleton3D reports REST
  from `get_bone_global_pose`, so never use that), and `sed -n '889,915p'` (`_parent_first`, `_world_of`).
- `Godot/scripts/FightStagePlayer.gd` (1,407 lines - NEVER open it whole): `sed -n '17,27p'` (the constants
  `RECEIVER_SWAY_ROLES`, `STRIKER_SWAY_ROLES`, `SWAY_CARRY_ROLES`), `sed -n '1026,1046p'` and line 970 (`_contact_s`: take name ->
  seconds of farthest reach). Read it from outside with `(player as Object).get("_contact_s")`.

## The tool (`measure_contact_clearance.gd`, extends SceneTree)

Copy the realism test's population EXACTLY: seeds 94301, 51227, 77003; 3 rounds; `FPS` 30; the room's own two men.
Run every seed twice - variant `production` (no `sway_roles` option: today's production) and variant `receivers`
(`sway_roles` = `RECEIVER_SWAY_ROLES` read from the player script's constant map, as the realism test's
`sway=receivers` does). Step each bout to its end as the realism test does.

Every frame, for each side: if its AnimationPlayer holds a take whose role (the name before `#`) is in
`STRIKER_SWAY_ROLES`, and that take's `current_animation_position` crossed `_contact_s[take]` between the previous
frame and this one, record ONE contact:
- `hand_to_target_m`: world distance from the striking hand to the RECEIVER's target bone - the striking hand is
  whichever of `LeftHand` / `RightHand` is farther along the thrower's facing (his node's +Z) at that frame; the
  target bone is `Chest` for `strike_body`, `Head` for every other role. Skip `strike_leg` (count it in
  `summary.skipped`).
- `gap_m`: `live.get("_gap")` at that frame.
Row: `[variant, seed, frame, side, take, role, contact_s, gap_m, hand_to_target_m, target_bone]`.

JSON `res://research/C113_contact_clearance.json`:
```
{"population": {"seeds": [94301, 51227, 77003], "rounds": 3, "fps": 30,
                "fighters": ["<A's name>", "<B's name>"], "striker_roles": [<STRIKER_SWAY_ROLES as read>]},
 "columns": ["variant", "seed", "frame", "side", "take", "role", "contact_s", "gap_m", "hand_to_target_m", "target_bone"],
 "contacts": [[...], ...],
 "summary": {"production": {"<role>": {"n": 0, "p10": 0.0, "p50": 0.0, "p90": 0.0, "mean": 0.0}},
             "receivers": {...}, "skipped": 0}}
```
Percentiles by linear interpolation between closest ranks. Fighter names: `live.call("_fighter", "a")["name"]`.

## Gate - in this order, from the repo root

1. `python Godot/tools/check_scripts.py Godot/tools/measure_contact_clearance.gd`.
2. Run the tool headless with a hard timeout (a GDScript runtime error HANGS a headless run instead of exiting - if
   the log shows `SCRIPT ERROR`, kill it and fix):
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_contact_clearance.gd --timeout 1200`
   (if your sandbox cannot run that wrapper, run the console exe from Python `subprocess.run(..., timeout=1200)` with
   output to a log file - never a PowerShell pipe).
3. `python research/C113_check.py` exits 0. It recomputes every summary from your rows, requires the SAME
   per-role contact counts in both variants (the engine decides strikes; hip carry is presentation only), and bounds
   every row by physics.

## The digest `C113_CONTACT_CLEARANCE.md`

Opens with `## DECISIONS`. Names the population. One table: role x variant -> n, p10 / p50 / p90 hand-to-target
(m). One line: for which roles production's p50 is SMALLER than receivers' (the carry brings the hand closer) and
by how much. No interpretation beyond the numbers - Claude decides what a good distance is.

## When done

Your last message: the three owned files, the check's last line, and the production p50 for jab, cross, hook_lead
and hook_rear. Claude commits.

## The trap

A take can be cut before it reaches its contact time (a hit lands mid-punch): that is NOT a contact and must not be
recorded - only a position that actually crossed `_contact_s[take]` inside one take counts. And read bone poses
AFTER `live.call("_process", dt)` for that frame.

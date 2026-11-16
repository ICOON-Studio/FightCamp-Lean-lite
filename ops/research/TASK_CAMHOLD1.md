# TASK CAMHOLD1 - the fight camera never cuts while a punch is in flight

Status: OPEN (S497, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
FIGHT MOTION WEEK (owner S496: "The fight looks terrible should we stop this project?"). Two blind critics scored the
filmed bout 4/10. The coach's note on the camera: "ex4 #1-#5 cuts twice in four frames; ex3 #7 and ex5 #11 cut in the
middle of a punch. Hold the shot through an exchange." A cut in the middle of a punch hides the one moment the viewer
must see (the glove arriving, the head answering).

## Read first
- `scripts/fight3d/RingCamera.gd` lines 168-226 (`broadcast`, `_due`): `_due` returns why the shot must end
  ("emergency", "hidden", "behind", "close", "frame", "clinch", "hold" or ""). `broadcast` cuts when it is not "".
  `_boxer(i)` gives a boxer's Dictionary (`"ap"` = her AnimationPlayer). The file is 490 lines: add at most 4 lines.
- `scripts/fight3d/BeatClips.gd` `contact_row(clip)` (non-empty for a punch clip) and `contact(clip, fallback)`.

## What to build
1. `scripts/fight3d/CamHold.gd` (new, `extends RefCounted`, pure, under 80 lines, no scene tree):
   - `const AFTER_HIT_S := 0.35` - the shot also holds this long after a punch's contact (the head's answer).
   - `static func may_cut(why: String, punching: bool) -> bool` - true for "start", "jump" and "emergency" always (a
     blocked lens must still be left at once); for every other reason only when `punching` is false.
   - `static func punching(clip: String, at_s: float, contact_s: float) -> bool` - true when `clip` is a punch clip that
     has not yet passed its contact by AFTER_HIT_S (`at_s <= contact_s + AFTER_HIT_S`); false for "" and for a clip with
     no contact (`contact_s < 0`).
   - `static func boxer_punching(bx: Dictionary) -> bool` - reads `bx["ap"]` (AnimationPlayer): its
     `current_animation`, `current_animation_position`, and `BeatClips.contact(clip, -1.0)` only when
     `BeatClips.contact_row(clip)` is not empty; false on an empty Dictionary or a missing player.
   - `-- nocamhold` in `OS.get_cmdline_user_args()` = the control arm (`may_cut` always true).
2. Wire it in `RingCamera.broadcast`: after `why` is known and before `_cut`, a reason that `CamHold.may_cut` refuses
   becomes "" (the shot rides on this frame). Count refused cuts in a new `var held_cuts := 0` (probes read it).
3. `tests/cam_hold_test.gd` (new, SceneTree script, prints `PASS`/`FAIL` lines and `CAM_HOLD failures=<n>`, exits with
   the failure count): the truth table of `may_cut` (each reason x punching), `punching` before contact / inside the
   0.35 s / after it / no contact / empty clip, `boxer_punching({})` false.

## Contract
OWNS: scripts/fight3d/CamHold.gd, tests/cam_hold_test.gd, scripts/fight3d/RingCamera.gd
RED_TEST: tests/cam_hold_test.gd -> CAM_HOLD failures=0
REGRESSION: cam_line_test, ring_lens_test, file_limits_test
VISUAL: no - Claude checks the cuts on the week's fight film (cuts inside a punch must be 0).
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2).
Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's monitors.
PR body: `RESULT: tests/cam_hold_test.gd -> CAM_HOLD failures=0` and one RESULT line per regression test.

## Prior research
`docs/TV_CAMERA_RULES.md` (the broadcast rulebook the camera follows), RingCamera.gd's own header (S379 shots, the
emergency cut). `E:/FightCamp/tmp/fightweek/r0/critic_coach.md` is the critic's text quoted above.

## What would a human do?
A TV director never cuts on the punch: he holds the shot through the exchange and cuts on the reset, unless the lens is
blocked.

## Prefab check
None: a rule inside our own camera.

## The one trap
`broadcast` runs every frame. Refusing a cut must leave every counter (`_shot_t`, `_hid_s`, `_behind_s`) running as
today, so the cut comes on the first frame after the punch; do not reset them and do not call `_cut` late with stale
points. The "hidden" branch sets `_hid_wait` before the cut: refuse the cut BEFORE that line or the wait is spent on a
cut that never came.

# TASK_C177 - a hit reaction knows which side it was hit on (Codex, AFTER C176)

Model: gpt-6-astra, MEDIUM (3D animation: clip classification and mirroring on a skeleton). Owner: codex.
Queued S60, 2026-09-23 - launch the moment C176 is collected.

## What the operator asked
> "It does not yet vary by side (left or right)" - "when this will be fixed"

Today `FightBeatAdapter._react_role_for(region)` picks `react_head` / `react_body` / `react_leg`
by REGION only. A lead hook and a rear hook to the head play the same take pool.

## Owned files
- `Godot/scripts/FightReactionSide.gd` (NEW, pure): classify and choose.
- `Godot/scripts/FightBeatAdapter.gd` - only `_react_role_for` and its caller (grep it; ~:950).
- `Godot/scripts/FightClipBinding.gd` - only the `react_*` entries (:92-:140): tag each variant.
- `Godot/tools/c177_reaction_direction.gd` (NEW) - measures each take.
- `Godot/tests/fight_reaction_side_test.gd` (NEW), `research/C177_DIGEST.md`.

## Spec
1. MEASURE, do not guess: for every `react_*` variant, retarget it onto our rig and record the
   Head (for react_head) / Chest (react_body) displacement from its first to its readable frame,
   in the man's own frame: lateral (+ right), back, up, in metres. Print the table.
2. Tag each variant `"dir": "left"|"right"|"back"|"up"` from the dominant component.
   Build the missing side with `FightClipMirror.mirror()` (exists) - a mirrored "left" is a "right".
3. Choose by the incoming strike: hook/overhand -> the side of the target that the fist comes
   from, given the THROWER's stance (orthodox lead hook lands on the target's right side of the
   head as he faces it; southpaw flips); straight/jab/cross -> back; uppercut -> up; kick/body ->
   side of impact. Put this table in `FightReactionSide.gd` with its reasoning; it is geometry.
4. Fall back to the current region-only pool when no tagged take matches (never play nothing).

## Gate (tier: scripts edited)
- Parse gate on touched files. Test: the chooser table (orthodox and southpaw throwers, lead and
  rear hooks, straight, uppercut); mirrored take's head moves the opposite lateral way (measured,
  sign flips, magnitude within 10%); fallback path. Break the chooser 4 ways - show the test catches each.
- `run_tests.py --only clip`, `--only react`, `--only room`. No full suite.
- Stills: one orthodox lead hook and one rear hook landing, target's head at the readable frame,
  into `previews/reaction_side/`. OPEN them: the head must turn AWAY from the fist.
- Push master from the main checkout, digest, one `agent_comms.py send`. Do NOT edit HANDOFF.md.

## Trap
Mirroring swaps Left*/Right* bone tracks AND negates the lateral axis; a mirror that only swaps
names plays a reaction that twists the wrong way. Verify with the measured displacement, not the name.

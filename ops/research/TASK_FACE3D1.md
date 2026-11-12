# TASK FACE3D1 - ARENA - which marks a hurt face shows in 3D: one pure module + its test

Status: OPEN (S439, Claude main). Discipline: boxing.
Source: the operator: "do we have mechanic to show damage done during the fight on the faces ?" and his ruling "Stop,
show damage" (no new damage rules: SHOW what the game already computes). Today the 2D close-up draws the marks
(scripts/ui/FaceMarks.gd `marks`: a swollen eye, a shut eye, a red nose, a cut on the brow or the nose bridge) from the
body map (scripts/rules/BodyMap.gd). The 3D boxers show nothing. THIS task is the pure rule that turns a boxer's body
map into the list of 3D face marks: what, where on the head, how strong. No scene, no mesh, no material, no decal:
plain dictionaries. The 3D wiring is a later task and is not yours.

## Contract
OWNS: scripts/rules/FaceMark3D.gd, tests/face_mark3d_test.gd
RED_TEST: tests/face_mark3d_test.gd -> FACE_MARK3D failures=0
REGRESSION: body_map_test, file_limits_test
VISUAL: no
NOT YOURS: every other file. BodyMap.gd and FaceMarks.gd are read, never edited.

## What exists (read first)
- scripts/rules/BodyMap.gd: PLACES, FACE_PLACES (left_eye, right_eye, nose), HURT 55, CRITICAL 35, DOCTOR 15,
  `value(map, who, place)` (0..100, 100 = untouched), `band(v)` (the band's word), the per-boxer dict
  `{"cuts": {place: true}, "closed": {place: true}, ...}`.
- scripts/ui/FaceMarks.gd `marks(vals, side)`: the 2D rule. Your module must AGREE with it on WHICH marks exist for
  the same input (same kinds, same places): the test asserts that against FaceMarks.marks itself.

## The job: scripts/rules/FaceMark3D.gd (pure, static, under 200 lines; it may preload BodyMap.gd only)
1. `SPOTS`: a const Dictionary of head-space anchor names -> a short plain description, exactly these keys:
   `brow_l`, `brow_r`, `eye_l`, `eye_r`, `nose_bridge`, `nose_tip`. (Her LEFT eye is `eye_l`. The 3D side maps a name
   to a point on the head; you only name it.)
2. `steps(v: float) -> int`: 0 when the place is fine (above BodyMap.HURT), 1 hurt (HURT down to above CRITICAL),
   2 badly hurt (CRITICAL down to above DOCTOR), 3 at DOCTOR or under. It must change exactly where `BodyMap.band`
   changes its word (assert that in the test by walking v from 100 to 0 in 0.5 steps: a step change if and only if the
   band word changes).
3. `specs(vals: Dictionary, side: Dictionary) -> Array` of Dictionaries, one per mark, in a fixed order (right eye,
   left eye, nose; within a place: swell or shut first, then cut):
   - a swollen eye: `{kind: "swell", place, spot: "eye_l"|"eye_r", step: 1..3, k: float, size_m: float}` with `k`
     STEPPED (not continuous, so a mark does not flicker as points come off): step 1 -> 0.45, 2 -> 0.75, 3 -> 1.0;
     `size_m` 0.030 / 0.036 / 0.042 (the bruise around the eye, metres across).
   - a shut eye (side.closed[place]): `{kind: "shut", place, spot, step: 3, k: 1.0, size_m: 0.042}` INSTEAD of the swell.
   - a hurt nose: `{kind: "nose", place: "nose", spot: "nose_bridge", step, k (same steps), size_m: 0.024/0.028/0.032}`.
   - a cut (side.cuts[place]): `{kind: "cut", place, spot: "brow_l"|"brow_r" for an eye, "nose_bridge" for the nose,
     step: 3, k: 1.0, size_m: 0.022, bleeding: true}`.
     (`closed` means the EYE is swollen shut, not that a cut was treated: a cut is always bleeding today.)
     Keep the key so the 3D side has it; say in a comment that the game has no "treated cut" state yet.
4. `lids(vals, side) -> Dictionary` `{"left": 0..1, "right": 0..1}`: how far each eyelid is down (0 open, 1 shut):
   0 when fine; step 1 -> 0.25, step 2 -> 0.50, step 3 -> 0.70; a closed eye -> 1.0.
5. `changed(before: Array, after: Array) -> Array`: the specs in `after` that are new or whose step or kind differs
   from `before` (matched by place + kind family: swell and shut are one family). The 3D side redraws only these.
6. `summary(vals, side) -> String`: one plain line for a tooltip, worst first, e.g. "Left eye shut, cut over the right
   eye, nose hurt" ("" when nothing shows). Words: use `BodyMap.band`'s own words for the level; no pronoun; "left" and
   "right" are the BOXER's own left and right.

## The test FIRST: tests/face_mark3d_test.gd (extends SceneTree; prints `FACE_MARK3D failures=N`; quits with N)
- AGREEMENT with the 2D rule: for at least 60 generated inputs (every combination of each face place at 100, 55, 54,
  35, 34, 15, 0 on a spread, with and without cuts and closed; build them in loops, never two identical inputs in a
  comparison), the multiset of (kind, place) from `specs` equals the multiset of (kind, place) from
  `preload("res://scripts/ui/FaceMarks.gd").marks(vals, side)`. Print the first disagreement in full.
- steps change exactly where BodyMap.band changes (the walk described above).
- k and size_m are the step's table values; a shut eye replaces the swell and reads lid 1.0; lids for both eyes
  independently; an untouched face gives `[]`, lids 0 and 0, summary "".
- order is fixed (right eye, left eye, nose; swell/shut before cut) whatever order the input dictionaries were built in.
- changed(): nothing new -> []; a place going from step 1 to 2 -> that one spec; swell -> shut on one eye -> that one
  spec; a new cut -> the cut only.
- summary names the worst place first and uses the band words that BodyMap.band returns for those values (assert by
  calling BodyMap.band in the test, not by typing the words).
- MUTANTS inside the test: a copy of `steps` with one boundary off by one band, and a copy of `specs` that keeps the
  swell beside a shut eye: each must fail the asserts above; print `MUTANT caught` for each; an uncaught one fails.

## Traps
- GDScript 4 in this project: type every variable read from a Dictionary (`var v: float = float(vals.get(place, 100.0))`);
  `:=` on a Variant is an error here. `%%` for a literal percent in a format string.
- A test that only your own function can pass is not a test: agreement is asserted against FaceMarks.marks and
  BodyMap.band, never against values copied from your own output.
- Do NOT delete, skip or weaken any existing test. Do not touch CI files. No asset loads (none exist in this mirror).
- If FaceMarks.marks cannot be loaded headless in CI (it is a UI script), say so in the PR body with the error, and
  assert the agreement against a line-for-line copy of its `marks` rule kept INSIDE THE TEST FILE with a comment naming
  the source lines.

## Prior research
scripts/ui/FaceMarks.gd (the 2D rule and its comments), scripts/rules/BodyMap.gd.

## What would a human do?
A cutman reads a face in steps, not in points: fine, marked, bad, the doctor looks. A swelling grows in stages, an eye
closes, a cut opens on the brow. The module is that reading as a list.

## Prefab check
FaceMarks.marks already decides which marks exist; this module restates it for 3D with stepped strength.

Test command: `godot --headless --audio-driver Dummy --path . --script res://tests/face_mark3d_test.gd`. Parse first:
`--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/face_mark3d_test.gd -> FACE_MARK3D failures=0`.

# TASK COACHNECK2 - round 2: the corner coach's neck upright in his close-up (owner C415), for Ziva

Status: OPEN (S501, Claude main). Discipline: boxing. Model: Ziva (in-editor, can render).

## Why round 2
Round 1 (Qwen, PR 329 `qwen/coachneck1`, NOT merged) built `tools/coach_neck_probe.gd` and a pitch cap in
`scripts/fight3d/CornerIK.gd`. Claude rendered the corner minute on the game camera before and after (S498,
`E:/FightCamp/tmp/coachneck/`) and dumped the coach's pose at still c07 both times:

    before: COACH_NECK neck_vs_chest=131.4 neck_vs_vertical=38.7 head_ahead_cm=7.3 ok=0
    after:  COACH_NECK neck_vs_chest=130.0 neck_vs_vertical=38.1 head_ahead_cm=7.2 ok=0

Two faults: (1) the neck moves under 1 degree, the two stills show the same jutting neck; (2) the probe's chest axis is
wrong: it reads 131 deg on a pose where the neck is visibly within ~40 deg of the trunk, because MetaHuman spine bones
do not have +Y up, so the 25 deg bar can never pass.

## What to build
1. Start from branch `qwen/coachneck1` (its probe + CornerIK change). Fix the probe's chest axis: the vector from the
   `spine_03` bone ORIGIN to the `spine_05` bone origin in world space (not a basis axis). Neck = `neck_01` origin ->
   `head` origin. Re-run it on `docs/playtest/bodylook1/coach_c07_pose.json`: report the numbers, they should now
   match what the still shows.
2. The fix in `scripts/fight3d/CornerIK.gd` only: when the coach looks down/forward at the seated boxer, the PITCH goes
   into spine_05/04/03 and the neck keeps within ~20 deg of the corrected chest line; yaw stays shared as today.
3. Prove it on the GAME's pose: re-dump through the corner film (`tools/corner_film.gd ... posedump=<out>/c07_after.json`,
   windowed only through `tools/hidden_desktop.py`), run the probe on it, and render the c07 close-up before and after.
   Look at both stills yourself: the neck must visibly rise, not just the number.

## Contract
OWNS: scripts/fight3d/CornerIK.gd, tools/coach_neck_probe.gd
RED_TEST: tools/coach_neck_probe.gd -- docs/playtest/bodylook1/coach_c07_pose.json -> COACH_NECK
REGRESSION: corner_crew_bodies_test, corner_face_line_test, corner_jobs_test
VISUAL: yes - the c07 close-up before/after on the game camera; the owner judges it. Not merged before.
NOT YOURS: every other file. Never delete or weaken a test. Own branch `ziva/coachneck2`, PR into main, never merge.
PR body: the probe lines (saved pose, game pose before, game pose after), the two stills, `RESULT:` per regression test.

## Prior research
PR 329 comment (S498 collect check); `docs/playtest/bodylook1/README.md`; CornerIK.gd S309/S310/S437 comments.

## What would a human do?
A seated man leaning in to talk bends at the hips and upper back; his neck stays in line with his chest, chin tucked.

## Prefab check
None: a limit inside our own look IK.

## The one trap
The saved pose is AFTER CornerIK ran: changing CornerIK changes nothing in that file. Only the re-dump shows the fix.
Never open a window on the owner's monitors; never kill a Godot process by name.

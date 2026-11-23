# PICSFIX1 - the fight pictures: no body through a body, a blocked punch ends on the block (S543)

Kind: build (the picture tool + a re-render). Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing. Estimate: 2-3 h.
The owner (S543, on two pictures of "Watch it in pictures"): "why fighters are entagled like that on the left and on the
right the punch does not touch the opponent", then "Yes, fix them now".
Commit only your paths (`git commit -m "..." -- <files>`), do not push. Godot only through `python ops/Tools/godot_slot.py
run --who PICSFIX1 -- <cmd>`; the renders are WINDOWED and run only on the never-shown desktop (`python
tools/hidden_desktop.py run --timeout=<s> <godot.exe> --path . --windowed ...`, as `tools/pics2d_set.gd`'s header says),
ONE windowed render at a time on the whole PC (another worker, TURNPROBUILD17, renders stills at the end of its task:
wait for the queue). Nothing opens on the owner's screens: view every picture with the file tool only. Before each run:
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait.

## What is wrong (checked by the coordinator in `tools/pics2d_set.gd`, 475 lines, and the pictures)
1. A BLOCKED PUNCH TOUCHES NOTHING. `assets/ui/fight_pictures/m/blue_body_cross_blocked.png` (the owner's right picture):
   the glove stops in the air at belly height while the defender's guard stays at the face. `contacts.json` says the same
   for every blocked picture: the glove is 0.28-0.38 m from its target and on nobody's arm (`_arm_block`, line 238).
2. A BODY INSIDE A BODY. To make a punch land the tool slides the puncher in until the glove reaches the target (lines
   190-216). The only limit is `MIN_APART_M` 0.40 between the two ROOT points, so a leaning puncher's chest ends inside the
   other boxer's, and a hook's glove ends on the FAR side of the head. The owner's left picture is one of these (find it:
   blue's glove behind red's head, red's glove at blue's chin, the two bodies overlapping).
3. `scripts/ui/FightPictures.gd` has 11 raw colours (tests/palette_guard_test.gd red since S540).

## Do
1. A GATE in the tool (new file `tools/pics2d_gate.gd`; the tool is near the 500-line limit), measured on the posed pair
   at the frame that is saved, and written into `contacts.json` for every picture:
   - `apart_m`: the smallest distance between the two boxers' torsos (spine / chest / hips bones as capsules, not the
     roots). No picture with torsos overlapping; the limit is a number you measure on the good pictures and write down.
   - LANDED: the glove's front within 0.04 m of the target AND on the puncher's side of it (never behind the head or
     through the body, seen from the picture's camera).
   - BLOCKED: `block_m` - the glove within 0.05 m of the DEFENDER'S glove or forearm (the hand-to-elbow segment). A body
     punch is blocked by the elbow and forearm brought down to the ribs; a head punch by the glove or forearm at the head.
   - MISSED: as today (clear of the head and both gloves on the picture), and the two bodies still pass `apart_m`.
   - The clinch has its own check: chest to chest, heads side by side, no head inside a head, no arm through a torso.
   A picture that fails is NOT written (the old file removed), is listed with the measure that failed, and the tool exits
   non-zero.
2. Make the poses pass, by RANGE and by the DEFENDER'S ARMS, never by pushing a body into a body: for a landed short
   punch pick the range and the contact frame at which the glove meets the near side of the target with the torsos
   apart; for a blocked punch pose the defender's block for that punch and height (the game's own defence clips,
   `BeatClips.defence`, the guard work in `scripts/fight3d/v2`) and end the glove on it. NO edit under `scripts/fight3d`
   (the fight animation METHOD line: v2 only, no new correction layer): if a clip or a defence the pictures need does
   not exist, list it in the result as missing; do not invent a layer.
3. Re-render both sets (w and m, 58 pictures each). Then build a contact sheet per set (a few PNGs of thumbnails with the
   file names, under `docs/playtest/s543_pics/`), open every sheet with the file tool, and open at full size every picture
   that looks wrong. Write down, per picture, anything a boxing coach would call wrong (a punch from a standing-still
   body, a head through a glove, feet crossed).
4. `scripts/ui/FightPictures.gd`: the 11 raw colours through `Palette.gd`; the screen looks the same.
5. `tests/fight_pictures_gate_test.gd`, written FIRST and red on today's sets: for both sets 58 pictures exist; every
   landed `hit_m` <= 0.04; every blocked `block_m` <= 0.05; every `apart_m` over the limit; the clinch entry carries its
   check. Add it to the list in `tools/run_tests.sh`. Must stay green: `palette_guard_test`, `move_pics_test`,
   `session_pics_test`, `file_limits_test`, and the pictures' own screen test if one exists (find it).
6. Result `docs/PICSFIX1_RESULT.md`: before / after numbers per picture family (a table), the pictures that could not be
   made to pass and why, the missing clips, the contact sheets, the test's pass lines.

## Prior research (name the study and the reference clip each pose follows; numbers beside ours - owner S537)
Run `python ops/Tools/prior_research.py block guard body shot elbow parry` and `... clinch pose`. The guard protects the
head (owner S531: hands at the head, not away from it); the block and guard studies under `ops/research` (GUARD*, the
Undisputed posture reads); our own reference clips. Say which study each of the three fixes follows.

## What would a human do?
A boxing illustrator draws a blocked body shot ON the elbow, a landed hook on the near cheek with daylight between the
two chests, and a miss with the head visibly gone from where the glove is.

## Prefab check
None (our own tool, clips and renders).

## Contract
OWNS: tools/pics2d_set.gd, tools/pics2d_gate.gd, assets/ui/fight_pictures/w/, assets/ui/fight_pictures/m/, scripts/ui/FightPictures.gd, tests/fight_pictures_gate_test.gd, tools/run_tests.sh, docs/PICSFIX1_RESULT.md, docs/playtest/s543_pics/
RED_TEST: tests/fight_pictures_gate_test.gd
REGRESSION: tests/palette_guard_test.gd, tests/move_pics_test.gd, tests/session_pics_test.gd
VISUAL: docs/playtest/s543_pics/ (contact sheets, opened by the worker, then by the coordinator)

Do not ask questions: decide, and write what you decided in the result.

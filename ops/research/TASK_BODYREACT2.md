# TASK BODYREACT2 - in the 3D fight, a landed body punch folds the hit boxer (S547)

Kind: build (one rule in the v2 fight player, red ruler first, films). Model: claude-fable-5-2.
Discipline: boxing (demo path). Seat: Claude worker in a console tab. Estimate: 2-3 hours.

## Why
Owner, review mark C502 on the body cross sheet: "there is no elbow bent , the reaction should force the opponent to
bend hisposture a bit". Before that, on the live fight: S305 "body shots do not seem to have any impact", S310 "body
shots still have no reaction", S369 "hits on body still no reaction from other fighter" (old brief TASK_BODYREACT1.md,
the old player). BODYCROSS3 (S546, `docs/BODYCROSS3_RESULT.md`) made the take that does it
(`pro_hit_by_gutshot_v3_fold`: the hit boxer folds 18-19 deg inside 0.15 s, 21-22 at the deepest) and showed it on the
sheet, the film and the game's 2D pictures. But THE 3D FIGHT NEVER PLAYS IT: `scripts/fight3d/v2/ChoreoReact.gd`
`react` picks a body reaction by head travel (nearest 0.30 m for his size, 0.42 for a big shot, a draw among those
within 4.5 cm); the fold take's head travel from its first key is 0.153 m, so it is never drawn. In the fight a landed
body punch still folds the man 4.5-8.4 deg inside 0.15 s: he does not see a bend.

## METHOD (quote in your first message)
- FIGHTPLAYER2: v2 only. NO NEW CORRECTION LAYER: nothing is added that runs every frame over a playing take, and
  nothing in the old player (`scripts/fight3d/*.gd` outside `v2/`) changes. This task changes WHICH take the v2 player
  picks for a landed body punch - a rule of the player itself.
- THE OWNER'S EYE IS THE RULER (owner S546: "there is no elbow bent" on a sheet whose table said it was): every bar is
  read on the pictures he will see, from a FIXED SIDE CAMERA, never on a key between pictures; a NaN or an unread
  number is no evidence. Before/after films: fixed side camera, never moved (owner S537).
- ANIMATIONS FROM OUR RESEARCH AND CLIPS (owner S537: "the power does not come from twisting the knee"): name the
  study line and the reference take beside every number. Run `python ops/Tools/prior_research.py body shot reaction
  fold` first and read `ops/research/topics/hit_reactions.md`; say in your first message which study's verdict the
  work follows.
- THE GUARD PROTECTS THE HEAD (owner S531): the folded man's gloves stay by his head or drop to cover the body, as
  the captured take has them; never arms flung wide.

## Where you work
In the main checkout `E:\FightCamp\Lean` (the take files are LFS-heavy; no worktree). Two other workers share it:
PLANREAD2 (scripts/rules/BoutRead.gd, PlanChain.gd) and the coordinator. Touch ONLY your OWNS list; commit with
`git commit -m "..." -- <your paths>`; do not push. Godot only through
`python ops/Tools/godot_slot.py run --who BODYREACT2 -- <command>`, headless for rulers, the never-shown desktop for
films (`python tools/hidden_desktop.py run --timeout=<s> --log=<file> <godot.exe> --path . --windowed --resolution
1920x1080 --audio-driver Dummy --script res://tools/<tool>.gd -- <args>`); never `_console.exe`; two windowed
renders never at once. Watchdog before each job (`powershell -NoProfile -ExecutionPolicy Bypass -File
ops\Tools\pc_watchdog.ps1 -Once`): RED = wait. Images and films are read with the file tool only; nothing opens on a
monitor. Read `ops/research/GDSCRIPT_TRAPS.md` first.

## What the code says today (read before you write)
- `scripts/fight3d/v2/ChoreoReact.gd` (157 lines) `react(db, rows, move, big, from_left, rng, hfh, log, sc, used)`:
  l.24 keeps the takes named "gutshot" for a body punch; then the head-travel pick. `start_s` decides where a
  reaction take starts.
- `assets/data/clip_db.json`: the rows of `pro_hit_by_gutshot_v2`, `_v2_short`, `_v3`, `_v3_fold`.
- `tools/bodycross3_ruler.gd`, `tools/pics2d_bodycross_film.gd`: how BODYCROSS3 read the fold on pictures (the fold =
  the change of the hips-neck line on the screen since the touch picture). Reuse the reading; do not edit those files.
- `tests/player2_test.gd`: the v2 player's own ruler (glove on target, foot slide, feet on the floor).
- `tools/fight3d_play.gd` (the real fight flow) for the films.

## The steps
0. RED FIRST: `tools/bodyreact2_ruler.gd` (headless, v2 player, `-- fightplayer2`): for a men's and a women's pair,
   land a body hook (the body punch the 3D fight throws today) through the player's own route (Choreographer ->
   ChoreoReact.react, 60 seeds a size, normal and big) and read, on pictures 1/60 s apart from the fixed side camera's
   projection: the fold of the hit boxer's hips-neck line at 0.15 s after the touch and at its deepest. Bars: 10 deg or
   more inside 0.15 s on at least 3 pictures; deepest 15-25 deg (he asked for "a bit": not doubled over); upright
   again (within 5 deg) inside 0.8 s; no head inside the other body (the picture set's 0.60 m rule); feet on the floor
   (player2_test's bars). It prints which take was drawn, how often. It must read RED on the shipped tree: commit it.
1. THE RULE: for a landed body punch `react` picks by WHEN THE FOLD ARRIVES (the take's fold at 0.15 s after its start,
   read once from the take's own keys and stored on its clip_db row by a small bake step in your ruler tool or a
   `tools/bodyreact2_bake.gd`), not by head travel: a normal body punch draws among the takes whose fold at 0.15 s
   is 10 deg or more; a big one takes the deepest. A size with no such take falls back to today's pick and the ruler
   says so. Head punches are untouched (prove it: the same 400 seeds a size pick the same head reactions before and
   after - the control arm).
2. GREEN on the ruler, both pairs; `tests/player2_test.gd`, `tests/clip_db_test.gd`, `tests/fight_pictures_test.gd`
   green. Add one check to `tests/player2_test.gd` (or a small `tests/body_react_test.gd` if player2_test is near
   500 lines): a landed body punch draws a take that folds 10 deg inside 0.15 s.
3. FILMS for his eye, real fight flow, fixed side camera, both pairs: before (the shipped pick) left, after right,
   twice at real speed then once at quarter speed; and a sheet of twelve pictures (3 before the touch to 8 after),
   each captioned with what the ruler read ON THAT PICTURE. All pictures through the framing check (both boxers head
   to feet). Put them on the review board:
   `cd ops && python Tools/review_add.py --stage S547 --rating "not scored: your eye" --title "<what it shows>" <files>=<caption>`.
4. SAID, NOT DONE, if true: the body CROSS is still not thrown in the 3D fight (`"played": false`, family body_cross
   has no pool). Say what it would take (a second take? a pool rule?) in the result; do not start it.

## Not allowed
No change to bout numbers (the fight shows a settled round: nothing here may reach `scripts/state` or `scripts/rules`).
No edit outside `scripts/fight3d/v2/ChoreoReact.gd` in scripts/. No new per-frame layer. No bought or generated
animation. No file over 500 lines.

## Feedback loops
None in the game's numbers: the reaction is drawn after the round is settled and nothing reads it back. One loop in
the player: a longer or deeper reaction can delay the hit boxer's next move (`ChoreoWait`) and change what the
choreographer plays next - check that a round's count of shown punches is the same before and after on 10 seeds (the
one-rep trial: one pair, one seed, before the 60-seed run; stop if the drawn take never changes).

## Prior research
`docs/BODYCROSS3_RESULT.md` (the take, its numbers, K46 and K52 cited by line), `ops/research/topics/hit_reactions.md`,
`docs/BODYCROSS2_RESULT.md`, memory notes "Animation bars on the pictures he sees (S546)", "Before/after films: fixed
side camera (S537)", "Animations from our research + clips (S537)".

## What would a human do?
An animator would open the fight, land a body hook, scrub frame by frame from the side, see the man barely move, and
swap in the reaction that folds on time - then watch ten exchanges to be sure nothing else changed.

## Prefab check
None to take: the take exists (captured gut-shot v3, re-cut in S546); the rule is ours.

## VISUAL GATE
Red on the shipped clip first (step 0, committed). Game-camera AND fixed-side-camera stills through the framing check;
per still: the gap between the boxers, noses not inside the other body, wrists, feet on the floor. The owner closes it
on the films; the green ruler closes nothing alone.

## Contract
OWNS: scripts/fight3d/v2/ChoreoReact.gd, assets/data/clip_db.json, tools/bodyreact2_ruler.gd, tools/bodyreact2_bake.gd, tools/bodyreact2_film.gd, tests/body_react_test.gd, tests/player2_test.gd, tools/run_tests.sh, docs/BODYREACT2_RESULT.md
RED_TEST: tools/bodyreact2_ruler.gd
REGRESSION: tests/player2_test.gd, tests/clip_db_test.gd, tests/fight_pictures_test.gd
VISUAL: before/after films and a twelve-picture sheet for a men's and a women's pair, fixed side camera, framed

## Result
`docs/BODYREACT2_RESULT.md`: which study the work follows, the rule in one sentence, the ruler's table before and
after (both pairs, normal and big), how often each take is drawn, the control arm (head reactions unchanged), the
round's punch count before and after, the films and the sheet (paths, and that you opened them), what is still not
right to your own eye, and `RESULT: tests/<x>_test.gd -> <exact pass line>` lines. Commit only your own paths with a
pathspec; do not push; do not ask questions: decide, and write what you decided.

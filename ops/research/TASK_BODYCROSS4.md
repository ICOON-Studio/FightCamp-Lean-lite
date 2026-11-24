# TASK BODYCROSS4 - the body cross is thrown in the 3D fight (S548)

Kind: build (animation, the v2 fight player). Model: claude-fable-5-2. Discipline: boxing (demo path). Seat: Claude
worker in a console tab. Estimate: 3-4 hours.

## Why
The owner asked for the rear straight to the body three sessions running (BODYCROSS1-3; S546: "there is no elbow bent ,
the reaction should force the opponent to bend hisposture a bit"). The take is made and passes its ruler
(`pro_body_cross`, docs/BODYCROSS3_RESULT.md, 13 of 13), the hit boxer now folds on a body punch (BODYREACT2,
docs/BODYREACT2_RESULT.md) - and the punch is still never thrown in the 3D fight. BODYREACT2 "SAID, NOT DONE" lists
exactly what is missing; this task does that list and nothing else.

## METHOD (quote in your first message)
- FIGHTPLAYER2: v2 only (`scripts/fight3d/v2/`), NO new correction layer - nothing runs over a playing take. The fix
  is in which take is chosen and when it starts.
- THE OWNER'S EYE IS THE RULER: every bar is read on pictures 1/60 s apart as a fixed side camera sees them; a green
  number closes nothing alone. Bars on the pictures he sees: a bend under 10 deg or shorter than 3 pictures is invisible.
- THE 3D FIGHT NEVER DECIDES: it shows the settled round. No bout number moves: thrown, landed, cut and reached are the
  same before and after, round by round (the control).
- Every animation brief names its study and reference clip: K51_THE_HIT_RESPONSE (body punch: forward crumple, on the
  blow), K48 (bend / brace, reset 0.5-1 s); reference MoCap Online Punch PRO body cross as re-cut in BODYCROSS3. Run
  `python ops/Tools/prior_research.py body cross straight rear body` and say which study's verdict the work follows.

## The steps (from BODYREACT2_RESULT "SAID, NOT DONE")
0. RED FIRST, committed: a ruler (`tools/bodycross4_ruler.gd`, built on `tools/bodyreact2_ruler.gd`) that asks the v2
   player for a landed body cross through its own route (Player2.queue -> Choreographer.plan -> the player's events)
   and fails today because the move does not exist.
1. A SOURCE: `scripts/rules/RoundScript.gd` names a landed rear straight to the body. Today l.281 draws
   `"body_hook" if r < 0.94 else "rear_uppercut"`. Split the body_hook share with the SAME draw (no new random
   number, so every other draw of the round is what it was): a share of body punches becomes `body_cross`. Decide the
   share from the game's own data (what FightLog and the 2D pictures already call a body cross) and write the reason.
2. `ChoreoRules.gd`: body_cross in PUNCH_MOVES with its impact time, hand (rear) and reaction size; every
   `move == "body_hook"` in `ChoreoReact.gd` (is_body, the fold join, start_s) and `Player2.gd` (the rib aim l.288,
   l.303, l.358), `Choreographer.gd` l.190 and `ClipCensus.gd` reads "a body punch" - one helper `R.is_body(move)`,
   used everywhere, so a third body punch later is one line.
3. A POOL: `pro_body_cross` gets `"played": true` for the v2 player and its family a pool. One take exists; S513's
   variety rule wants two. Decided here: one is enough to start; say so in the result as a debt.
4. The hit boxer answers with the fold rule as it is (BODYREACT2: the gut-shot take that shows 10 deg or more 0.117 s
   after its start). Do not change that rule.

## The bars (on pictures, men's pair mh_boxer_02 v 01 and women's pair 11 v 14, 60 seeds each)
- THROWN: over 240 planned rounds a body cross is landed in at least 1 round in 6, and never in the same exchange slot
  twice running.
- ON THE BODY: on the touch picture the glove is on his trunk (ribs to belt), within 6 cm of the surface, not inside it.
- THE ELBOW: the punching arm is bent under 150 deg on the picture before the touch and straightens through it
  (his words: "there is no elbow bent").
- HE BENDS: BODYREACT2's ON TIME bar (10 deg or more on 3 pictures inside 0.15 s) on 60 of 60.
- APART and FLOOR: as BODYREACT2 (no head inside the other man on any picture; no foot over 3 cm under the canvas).
- CONTROL: head punches pick what they picked (9,600 of 9,600); a round's thrown / landed / cut / reached counts are
  the same before and after over 10 played rounds; `player2_test`, `body_react_test`, `choreographer_test`,
  `round_script_test`, `fight_pictures_test`, `clip_db_test` green.

## VISUAL GATE
Red on the shipped tree first (step 0, committed). Game-camera AND fixed-side-camera stills through the framing check
(`tools/still_framing.gd` save_if_framed: both boxers head to feet, never a feet-only picture); per still: the gap
between the boxers, noses not inside the other body, wrists, feet on the floor. Films before / after (fixed side
camera, twice at real speed, once at quarter speed) and a twelve-picture sheet for each pair, put on the review board
with `python ops/Tools/review_add.py --stage S548 --rating "not scored: your eye" --title "<what it shows>" <files>`.
The owner closes it on the films.

## Not allowed
No change to a bout rule, to `LiveRound`, `BoutNight` or anything that settles a round. No layer over a take. Nothing
opens on a monitor: windowed Godot only through `python tools/hidden_desktop.py run ...` inside
`python ops/Tools/godot_slot.py run --who BODYCROSS4 -- ...`; headless otherwise, `--audio-driver Dummy`, never the
`_console.exe`; watchdog before each job. Open pictures with the file tool only. Other workers share this checkout and
the Godot queue: keep each run under 20 minutes.

## Feedback loops
None in the bout (the 3D fight shows a settled round). Inside the show: a body cross takes a body hook's slot, so the
body hook is seen less - print both counts before and after; if the body hook falls under half its old count the
share is too big. One-rep trial: one seed, one pair, the ruler and one film, before the 60-seed runs.

## Prior research
docs/BODYCROSS1_RESULT.md to BODYCROSS3_RESULT.md, docs/BODYREACT2_RESULT.md (its "SAID, NOT DONE" and "Decided"),
`ops/research/K51_THE_HIT_RESPONSE.md`, K48, memory notes "Animation bars on the pictures he sees (S546)", "Before/after
films: fixed side camera (S537)", "Animations from our research + clips (S537)".

## What would a human do?
An animator with a finished take would put it in the punch list, aim it at the ribs, check it on film beside the hook
it replaces, and show the director the film - not another table.

## Prefab check
None to take: the take is ours (owned mocap, re-cut in BODYCROSS3); BODYREACT2's ruler and film tool are the harness.

## Contract
OWNS: scripts/rules/RoundScript.gd, scripts/fight3d/v2/ChoreoRules.gd, scripts/fight3d/v2/ChoreoReact.gd, scripts/fight3d/v2/Player2.gd, scripts/fight3d/v2/Choreographer.gd, scripts/fight3d/v2/ClipCensus.gd, assets/data/clip_db.json, tools/bodycross4_ruler.gd, tools/bodycross4_film.gd, tests/body_cross_play_test.gd, docs/BODYCROSS4_RESULT.md
RED_TEST: tools/bodycross4_ruler.gd
REGRESSION: tests/player2_test.gd, tests/body_react_test.gd, tests/choreographer_test.gd, tests/round_script_test.gd, tests/fight_pictures_test.gd, tests/clip_db_test.gd
VISUAL: before/after films and a twelve-picture sheet for a men's and a women's pair, fixed side camera and game camera, framed

## Result
`docs/BODYCROSS4_RESULT.md`: NOT GREEN first; what now works; the bars before / after per pair; the control; the films
and sheets (opened by you, each one, with what your eye says is still wrong); decided; how to run it again. Add the new
test to `tools/run_tests.sh` (tell the coordinator in the result: that file is shared). Commit ONLY your own paths with
`git commit -m "..." -- <paths>`; do not push; do not ask questions: decide, and write what you decided.

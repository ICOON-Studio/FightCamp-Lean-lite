# TASK HOLDTAKES1 - a hand held high or low, seen: four guard takes for Ring Switches (S552)

Kind: build (a bake tool under `tools/`, pictures under `proto/twohands/img/anim/`; nothing under scripts/).
Model: claude-fable-5-2 (animation: owner S512 "use fable for animations"). Discipline: boxing (demo path).
Seat: the next session itself. Estimate: 3-4 hours, about 20 minutes of it GPU renders.

## Why
Ring Switches is about one choice: each hand punches, or is HELD high or low and blocks one kind of punch (owner S551:
"a hand left off defends"). RINGANIM1 (S552) made every other action seen; the holds are the one thing the page cannot
show (`docs/RINGANIM1_RESULT.md` NOT GREEN). Our library has no take that holds ONE hand, and its two-hand blocks read
wrong: `pro_idle_to_block > pro_block_loop` lifts the lead glove over the head, `mc_to_block > mc_block` does the same
and never brings the elbows to the ribs (`ops/previews/s552_ringanim/ringanim_holds_read_wrong.png`).
Owner S552: "you can try tripo or ludo for animations if it speeds up things".

## METHOD (quote in your first message)
- FIGHT ANIMATION: v2 only, NO new correction layer in scripts/fight3d. An AUTHORED TAKE baked by a tool is the accepted
  route (BODYCROSS1, S542: `tools/pics2d_bodycross_bake.gd`), not a layer.
- THE GUARD PROTECTS THE HEAD (owner S531: "holding their hands away from their heads and they look like robots"): a
  high hold has the glove AT the face, never over the crown, never out in front.
- ANIMATIONS FROM OUR RESEARCH AND CLIPS (owner S537): each pose names its study and reference. A BAR IS READ ON THE
  PICTURE HE SEES (owner S546): a move of a few centimetres is invisible at 480 px.
- THE OWNER'S EYE IS THE RULER; before / after on the fixed side camera.
- HIS GAME FIRST: `Get-Process ArcheAgeChronicles` before any render.

## The four takes (each 0.3-0.4 s from the guard, then held; both corners)
| Run | What the page says it stops | The pose |
|---|---|---|
| lead_high | his jab and his cross (head, straight) | lead glove in front of the nose and forehead, elbow down |
| lead_low | his body hook and body cross | lead elbow on the ribs, glove at the belt line across the stomach |
| rear_high | his lead hook and his overhand (head, from the side) | rear glove at the temple and cheek, forearm upright |
| rear_low | his uppercuts (chin, from below) | rear glove under the chin, elbow tight, forearm across the chest |
The hand that is not named stays in its guard. The four must be told apart at a glance on the side camera: that is the bar.

## Steps
0. RED FIRST: `node proto/twohands/tools/anim_check.mjs` already lists the eight runs as NO TAKE and the four two-hand
   holds as MISSING. Move the eight into the required list (they then fail) and drop `hold_high` / `hold_low`. Commit.
1. Read how the body cross take was authored and baked; reuse its stage and its IK. Try Ludo or Tripo ONLY if a
   generated take can be on our bodies within the hour (time-box it; say what happened).
2. ONE pose first: lead_low, a strip and a 480 px picture beside today's guard. Go on only when it reads.
3. The four takes, both corners, through `tools/pics2d_anim_more.gd` (a `_hold_run` exists).
4. The page: a held hand is shown when the player sets it (`showHold` in `switch.html` plays `blue_hold_*` today: make it
   play the hand that was clicked) and, during a beat, the blocking man's hold could be the first picture of a blocked
   run - decide and say. `order.html` is generated: `python proto/twohands/tools/make_order.py .`
5. Sheets and a film on the review board.

## VISUAL GATE
Red first (step 0). Fixed-side-camera strips through the framing check (both boxers head to feet). Per held pose: the
glove's distance to the place it guards (face / ribs / temple / chin) under 8 cm; no glove above the head bone; the
other hand within 5 cm of its guard place. The four poses side by side at 480 px on the review board
(`python ops/Tools/review_add.py --stage S553 --rating "not scored: your eye" ...`). The owner closes it by playing.

## Not allowed
No change under scripts/. Windowed Godot only through `python tools/hidden_desktop.py run ...` and the queue
(`python ops/Tools/godot_slot.py run --who HOLDTAKES1 -- <command>`), `--audio-driver Dummy`, never `_console.exe`. The
toy's rules (`resolve`, `ai`) are not touched. Commit ONLY your own paths.

## Feedback loops
None: pictures and playback only.

## Prior research
`docs/RINGANIM1_RESULT.md`, `docs/BODYCROSS3_RESULT.md`, `docs/BODYCROSS4_RESULT.md`, `scripts/fight3d/v2/GuardHold.gd`
(where a held wrist goes, from the head bone: lead 0.21 / 0.06 / -0.11 m), `scripts/fight3d/BeatClips.gd` DEFENCE (S304:
every Pro block holds a glove over the head), J50 (the low block / elbow-down body guard, quoted in
`tools/pics2d_set.gd`). Run `python ops/Tools/prior_research.py guard block parry elbow high low` first.

## What would a human do?
A coach would stand a boxer side-on and show the four holds one after another. If two of them look the same from the
side, he would change the pose, not the label.

## Prefab check
`tools/pics2d_bodycross_bake.gd` (authoring and baking a take), `tools/pics2d_anim_more.gd` (`_hold_run`, `_solo`),
`proto/twohands/tools/anim_web.py`, `anim_sheets.py`, `anim_film.py`. Ludo CLI (skill `ludo`), Tripo (his subscription).

## Contract
OWNS: tools/pics2d_hold_bake.gd, tools/pics2d_anim_more.gd, proto/twohands/tools/anim_check.mjs, proto/twohands/img/anim/, proto/twohands/switch.html, proto/twohands/order.html, docs/HOLDTAKES1_RESULT.md
RED_TEST: proto/twohands/tools/anim_check.mjs
REGRESSION: `node --check` of both pages' scripts; the 59 runs of RINGANIM1 unchanged
VISUAL: strips, the four poses side by side and a film on the review board

## Result
`docs/HOLDTAKES1_RESULT.md`: a NOT GREEN list first; the four poses with their measures; what the page now shows.

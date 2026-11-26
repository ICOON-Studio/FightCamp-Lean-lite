# TASK HEADPICS1 - the head-movement pictures: slip, roll, lean back, slip in (S560)

Kind: build (takes + pictures). Model: claude-opus-5-5. Discipline: boxing (Ring Switches, the main line).
Seat: console worker. Estimate: 3-4 hours, ~20 min of GPU renders.

## Why
`proto/twohands/head.html` plays four head moves (slip, roll, lean back = `pull`, slip in = `slipin`, on the feet switch)
and none has a picture: a punch that is slipped shows the plain "missed" run, so the player cannot SEE why it missed.
HEADART1 (`ops/research/HEADART1_SOURCES.md`, read "Recommended route") found the takes on disk, nothing to buy: the Punch PRO
dodges / weaves / pull are already on our MetaHuman. Owner S559: "check all these animations i want you to match those"
(`ops/research/BML1_MOVEMENT_CATALOGUE.md`: the head leaves the line by the knees and the trunk, the guard stays up, the
feet stay under him).

## S560 state - a first worker was stopped after 14 minutes (the owner opened his game; one worker at a time then)
- On disk from it: `tools/pics2d_head.gd` (new, uncommitted: read it, keep what is good), first-pass frames in
  `E:/FightCamp/tmp/headpics1/try1` and strips in `try1_strips` (jab_slipped, lead_hook_rolled, lead_uppercut_landed_on_roll,
  slip_in_r2). Its second render never started (the Godot queue was RED).
- Its own verdict on try 1: "Slip and guard are fine, but the roll gives him too little ground and the slip-in's upper body
  is weak, plus the uppercut-on-roll is crowded."
- The session's read of the two strips it opened: (1) jab_slipped: the head leaves the line and the guard stays, but he
  drops about a head's height - it reads as a duck; a slip is small (head just outside the glove, knees a little). (2)
  lead_hook_rolled: the defender does not move at all, the men stand too far apart for a hook to reach, and the puncher's
  arm ends above his own head on the follow-through: this run is not usable; the roll must go DOWN and ACROSS under the arm.
- HIS GAME FIRST: before every render run `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1
  -Once`; if a game (ArcheAge) is in its list or it is RED, do the no-render work (page part, checks) and wait.

## Do (HEADART1's route, first slice)
1. Frame runs from the owned Punch PRO takes: `pro_left/right_dodge` (slip), `pro_left/right_weave` (roll), `pro_back_dodge`
   (lean back), side chosen as `BeatClips.defence` does, cut where both feet stand - a new block in `tools/pics2d_anim_more.gd`.
   Runs, both corners: `slip`, `roll`, `lean_back`, each as the DEFENDER'S half of a missed punch: `jab_slipped`,
   `cross_slipped`, `lead_hook_rolled`, `overhand_rolled`, `jab_leaned`, `cross_leaned` (the puncher throws his own take, the
   other man moves his head; the glove must pass the place the head WAS).
2. Slip in: the `st_in_m` step with a slip's upper body (hold-bake method, `tools/pics2d_hold_bake.gd`), runs `slip_in` and
   `_r1` / `_r2` as the steps have.
3. The uppercut that catches a roll: `lead_uppercut_landed` / `rear_uppercut_landed` on a man rolling (`_on_roll`).
4. The pictures through the picture tools on HIS CAMERA (`tools/pics2d_camera.json`, save #16: raised 31 deg, from the side;
   the fixed ring camera of RINGCAM1), every render south=blue; the frames gate, `anim_web.py` (merge - ADD rows, never rebuild
   `frames.json` whole), `anim_check.mjs`.
5. head.html, PAGE PART ONLY (below the `// ---- the page` mark): `runOf` picks the new run when an event's words say
   "slipped", "rolled under", "leaned back out of reach" or a slip in; a missing run falls back as today.
6. Strips to `ops/previews/s560_head/` and one sheet on the board: `python ops/Tools/review_add.py --stage S560 --rating
   "not scored: your eye" --title "Head moves: slip, roll, lean back, slip in" <png>`. Play a beat with each move on head.html
   (server already up: http://127.0.0.1:8797/head.html) and look at it.

## VISUAL GATE (every picture, opened by you with the file tool)
- Both men head to feet in the frame, on his camera; no picture cut at the edge.
- The guard stays up through the move (the rear glove beside the jaw, GUARDEAR1: 5 cm ahead of the ear line).
- The head is OFF the punch's line at the contact frame: measure the glove-to-head gap in the picture plane and print it
  (bar: 12 cm or more for a slip / lean back; the glove passes OVER the head for a roll).
- Neither man turns his back, feet stay on the canvas (no foot under it, no float), no limb through a body.
- A run that fails a bar is NOT put on the page: list it as failed with its still.

## Contract
- OWNS: tools/pics2d_anim_more.gd (head runs only), tools/pics2d_hold_bake.gd (a slip-in variant), proto/twohands/img/anim
  (the new runs' pictures), proto/twohands/img/anim/frames.json (new rows only), proto/twohands/head.html (page part only),
  proto/twohands/tools/anim_check.mjs (the required list), ops/previews/s560_head/, docs/HEADPICS1_RESULT.md
- RED_TEST: anim_check.mjs with slip / roll / lean_back / slip_in added to its required list (fails today)
- REGRESSION: anim_check.mjs PASS for every existing run; head_test.mjs 11 passed; page_play_test.mjs 4 passed; page_parse ok
- VISUAL: the strips, opened by you, with the gate above

## Not allowed
No change to any page's RULES (above the page mark) and no change to order.html / kick.html / body.html: balance runs read
them. No change under scripts/. MetaHuman bodies only. Godot only through `ops/Tools/godot_slot.py` + `tools/hidden_desktop.py`,
never `_console.exe`, nothing on his monitors; watchdog before each render; if he is playing a game, wait.
Appended code comments are `/* */`, never `//`. Commit ONLY your paths by pathspec (`git commit -- <files>`), look at
`git diff --cached --stat` first (S559: a worker swept 8,200 files into a commit); never `git add -A` or a folder you do not own.

## Result
`docs/HEADPICS1_RESULT.md`: runs made, the gate table (gap in cm per run), runs failed and why, what head.html now shows.
End with one line `HEADPICS1 DONE` or `HEADPICS1 BLOCKED: <why>`.

## Prior research
ops/research/HEADART1_SOURCES.md; ops/research/BML1_MOVEMENT_CATALOGUE.md; ops/research/TASK_KICKTAKE1.md and
docs/RENDERFIT1_RESULT.md (the same tools, his camera, what failed last time); docs/RINGANIM1_RESULT.md.

## What would a human do?
An animator picks the library dodge, lines the puncher's contact frame up with the head already gone, and checks the still
on the game's camera before anything reaches the page.

## Prefab check
Done by HEADART1: owned Punch PRO takes; the Fab Boxing Animation Pack only if the slips turn his back (owner's buy).

## Feedback loops
None: pictures only.

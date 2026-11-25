# S552 digest (2026-11-25, Fable) - Ring Switches is seen: every action frame by frame

## What now works
- RING SWITCHES PLAYS ITS ACTIONS. Both pages (`proto/twohands/switch.html`, `order.html`) show each action of a beat as a
  run of pictures at recorded times: every punch lands / blocked / missed for both corners, step in, back off, feint,
  push off, clinch, knockdown. 59 of 64 runs, 591 pictures, 13 MB. The contact picture is held with the flash and the
  sound; a missing run falls back to its still. Checked in the browser on both pages, no console errors.
- The runs are recorded from the v2 fight player on the fixed side camera and timed by its own rules (when the hit head
  snaps, when a dodge starts, when the arm comes home). Tools: `tools/pics2d_anim.gd`, `tools/pics2d_anim_more.gd`,
  `proto/twohands/tools/anim_web.py`, `anim_check.mjs`, `anim_sheets.py`, `anim_film.py`.
- COACHMAP2 checked by hand (`COACHMAP2_CHECK_S552.md`): the FAIL stands. Board Q-336: keep the two hire cards, or cut.
- Kalli's and John's defence ideas read against Ring Switches (`TWOHANDS_IDEAS_VS_RINGSWITCHES_S552.md`): both picked
  "the hand that does not punch is your guard" first - his own rule. Three additions noted, none built.
- `move_tip_test` green again (one of the three old 05:00 reds): since S449 a block plays no clip; the test now reads
  the catch.

## Evidence
- `node proto/twohands/tools/anim_check.mjs` -> `runs=64 ok=59 missing=5 no_take=8 borrowed=8 FAIL` (red on purpose).
- Review board, stage S552: 3 films, 10 sheets (`ops/previews/s552_ringanim/`).
- Commits: 5899e3f5f (the red check), 2f9849464 (move_tip), 2ace377f3 (RINGANIM1).

## NOT GREEN
- A held guard is not seen: the two-hand block takes read wrong (glove over the head; the low hold does not cover the
  body) and no take holds one hand. This is the choice the game is about -> `TASK_HOLDTAKES1.md`, first work of S553.
- The overhand borrows the rear hook; the push is the game's mutual push-off; red's blocked body hook keeps its still.
- Inside punches (hooks, uppercuts): the two guards overlap on the picture in the frames before the punch.
- Men's pair only. Nobody but Claude has judged the films.
- The guard BAR of the toy almost never breaks as tuned (6 points, +1 a beat, -1 a blocked big punch): asked, not changed.
- No export since S547. `block_meet_test` and `matchmaking_bots_test` still red at 05:00.

## Running at the handover
- STYLEPLACE1 (Opus, console tab c1 of the S552 session, launched 00:55): control and bar 5 done, full arms running;
  due about 04:00-05:00. Its tab lives with the S552 session window.

## Lessons (also in memory)
- A frame run is each frame replayed from the start and frozen: waiting "to settle" after the freeze lets the
  clock-driven layers (join smoother, PunchAim, BlockCatch) run on, so the arm was home 0.05 s early.
- The clinch and the push-off leave the stage's reach layer on: render them last and let go, or every later run has an
  arm held straight out.
- A Bash heredoc with an apostrophe breaks here; a `cd` in Bash moved the session folder once more.

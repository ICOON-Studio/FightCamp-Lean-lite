# S436 digest (2026-11-11, night)

## What happened
- START: no open board questions. The S434 session's workflows last wrote at 21:40 (weight map round 2, foundation
  PUNCHSTART1): left alone. PR 213 (INTROCORNER1) closed with the S435 reasons.
- ANIMATION D0 step 1 DONE: the two punch rulers hold their gap and read every row (commit 6091c364).
  Why they read so little: head_aim compared the HIPS gap (about 0.78 m at once, 0.87-0.91 m settled) with
  stage.gap_m (ROOT to root, 0.90-0.99 m); block_meet's fixed 0.80-1.10 m band sat above what a 3-frame wait gives.
  Both waited 3 frames after moving the bodies back, while ShownRoot eases the place and the feet rig steps after it.
  tests/ruler_stand.gd: bodies back, feet and fidgets held, wait until the hips gap is still (at least 45 frames, 10
  still frames), `open` marks the stage's own gap from two stands, a row outside 0.04 m of it is VOID = failure.
  Twice in a row: head_aim 12 of 12, GREEN (its no-aim jab still fails the height bar). block_meet 27 of 27, ONE real
  red: A_B rear hook sinks 3.3 cm into the blocking glove (bar 3.0). That red is CONTACT1's first target.
- INTROCORNER2 (Qwen) read on stills, NOT collected as it stood: SHOTS ran 4.5 s ahead of CUES (the red name call was
  filmed on the blue boxer, the blue one on an empty ring), no personality reached the planner (both "default"), one
  warm clip each and both on the same fidget. Third failed seat round on a job that needs eyes: Claude took it.
- THE INTRO REWRITTEN (7a8d6b2d, 64e1b927 + the tape rows): FightIntro on ONE clock (T_TAPE 7.4, T_RED 11.9, T_BLUE
  14.9, T_WALK 17.9, T_TOUCH 22.2, about 24.8 s); IntroStyle (pure) plans segments of 3.7 s by style (showman /
  worker / nervous / default from f["personality"]; the opponent's from her name), the second corner refused the
  first one's clip at each segment and name call; celebration windows start past the clip's first third (they open in
  the guard). The rope entry and IntroEntry are out (ROPEENTRY2 stays a later task). tests/intro_style_test.gd in the
  daily list: 640 plan pairs, the camera on the boxer being named, no shot under 2 s.
- HIS WORDS on the old dark tape card, shown at his ask: "thats terrible i asked to be switched with the one that was
  shown when negotiating a contract"; shown the versus screen: "yes use this one for taleof tape", "of course adjust
  without the contract offer options and refine it a little bit", "animations on tale of tape cannot be identical at
  the same time for both fighters please", then on the card "add a bit mor stats here , like record , from where ,
  reach etc". Built: TapeVersus.mount(.., false) = full screen over the film bars, title, bout line, VS, rows From /
  Record / Age / On the scales / Height / Reach / Stance / Style (a missing fact is a dash), no camp or scouting lines,
  SKIP at the bottom while it is up; WoodKit.ink run on it (outside the menus nobody runs the ink pass: the slate's
  words were dark on dark). VersusLive: each side its own takes (it was 50 % the same take; also at the bout offer).
- HIS WORDS on the glove-touch two-shot: "this pose is wrong ,not normal". The rear glove was IK'd low beside the lead
  one (S399) from a hunched back. Now: rear glove by her own hip, trunk up 9 degrees, the touch point read every
  frame. Still docs/mockups/s436/intro/07_touch.png.
- GYMLIFE2 (Cursor) collected (adf60a70): walks follow the route's bends, no placed person under a hub button, the
  shadow strip's slip meets its pull; the jab's join stays open (no owned clip that close). PR 215, 214 closed.

- LATE, after `ship` (stage gate off, a reply on the shipped stage): "remove the panel and makeittransparent and do it
  similar to ufcs presentations" -> TapeVersus._broadcast: no slate, no wooden frame; a title, the bout line, one
  translucent band a fact (name in the middle, red edge left, blue edge right). broadcast_rows() is pure. Exported
  23:01 with it and smoke-run 40 s on the hidden desktop: no script error. Builds/FightCamp.exe is complete for S436.

## Traps
- A `cd` into a seat worktree in a Bash call moves the session's working directory there: use `git -C`.
- A python heredoc holding GDScript with quotes can break bash: write the edit script with the Write tool.
- Never edit game files while tools/export.sh runs; stop the export (TaskStop) first.
- godot_slot waits behind a seat's job: two renders this session waited 6 and 8 minutes. Not a hang.
- intro_shots.gd's `t` is wall time: the same game moment lands on a different still when the PC is busy.
- The operator was playing another game (9 GB): the watchdog went RED on memory once; nothing was started on RED.

## Open
- The test-jump men's opponent has no height or reach on file (the tape shows dashes): check whether generated men's
  opponents carry them (the women's Data.OPPONENTS do).
- The blue showman's name call can still land on a quiet part of a win take: pick windows by eye per clip.
- TapeCard.gd is used only by tests/tape_rows_test.gd now: retire it with that test's rows.
- Miro "Where we are": three old "Added in S435" cards still sit in the frame (a delete needs his yes).

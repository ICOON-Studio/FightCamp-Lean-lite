# S359 DIGEST - 2026-11-02 - update 61: the whiteboard reads at a glance

Repos: Lean 450482d (code + test + stills tool), e8d532c (WHAT_TO_TRY + S360 prompt). Game: roadmap, this digest.

## What now works
Kalli SQ25 (research/KALLI_WHITEBOARD_S357.md), built as decided in S358's next action (no ask):
- Fatigue under each day is a word - FRESH (<50), WORKED (50-79), RED DAY (second Hard morning in a row), OVERCOOKED (80+).
  The hover gives the number and the cost the maths really runs: a morning started at 80+ trains at 60 % (WeekPlan.TIRED_GAIN),
  and a camp that peaks at 80+ fails its fatigue line. Kalli's "injury risk doubled" is NOT claimed: injury reads the load
  ratio (Injuries.ratio), not fatigue.
- Magnets say LIGHT / NORMAL / HARD (WhiteboardKit.level), evenings too.
- The camp phase strip (WhiteboardKit.phase_strip, WeekBoard.phase_cells counted back like WeekPhase.phase) with "you are
  here" and a red FIGHT cell; no bout = the old phase chip.
- Twist sticky: COACH'S PICK over the default answer; "No answer by Monday = the coach's pick. Hover an answer to see where
  the camp lands." Hovering an answer writes each goal line's landing ("-> 64.3" / "same").
- A goal line that moved since the last draw (static per-fighter memory) flashes its band twice and shows the delta for 2 s.
- First open: until a twist is answered once (f.board_taught, set by BoutActs twistpick) the grid + foot are dimmed and the
  sticky heads THIS CAMP with START HERE + the coach's line.
- One undo route: 'undo' on a changed day (back to WeekPlan.coach_of's card) + Coach's week; the "pick the coach's card
  again" wording is gone.

## Evidence
- tests/week_board_clarity_test.gd: 22 checks on the real board through jump=camp - WEEK_BOARD_CLARITY PASS.
- Related tests green (week_plan/phase/twist/coach/actual, peak_camp, plan_test_it, test_jump, golden_path); full Lean suite
  103/103 (JOBS=2, watchdog AMBER on memory); export rebuilt Builds/FightCamp.exe.
- Stills (hidden desktop, tools/s359_stills.gd) on /review S359: first open, hover answer, answered, day changed. The first
  render caught the sticky below the fold on first open and a misaligned Sunday column (undo padding) - both fixed, re-shot.

## Decided (developer calls)
- Fatigue bands 50/80 tie to the existing amber 70 / red 80 colours; the coach's week settles ~68, so WORKED is the normal
  camp state (honest, not alarming).
- Kalli's "More" row (diet/new move/combo collapsed until camp week 2) is NOT built - it belongs with Q-S294-90's layout.

## Next
All waits on the operator: Q-S294-90 (amber opponent line, evening magnet cut), 89 (SMOOTH3 film), 86, 78/80, 87, 88.
Lean NEXT_SESSION_PROMPT.md holds the order.

## HANDOFF
- last working commit: Lean e8d532c
- next action: roadmap now.next_action (S360) - act on each board answer in that order.

## Addendum - the operator's notes after the ship (same session, Lean 5489553 .. 0f8a2f4)
He watched the S358 film and played the Training tab / Playbook; each note was fixed and measured:
- "wtf is this ??" (intro glove raise): the IK target sat 0.12 m to her RIGHT over the head bone whichever hand rose; a
  southpaw's left arm crossed her head. Now above the raising arm's own shoulder and out to that side. Stills both corners.
  Both sides of the SMOOTH3 A/B film were identical there: not a SMOOTH3 matter.
- "the referee walking between the fighters for no reason": his side was re-picked from the camera every frame. Sticky
  side + round a boxer's back; then (operator) "make ref transparent and appear only to clear clinch": unseen while
  watching, fades in to break a clinch. ref_probe 150 s same fight: between 417 -> 51 frames (all 4 = the break), walks
  across 7 -> 0, drawn 12.7 %.
- "unreadable" tooltip: the engine's see-through grey. Theme TooltipPanel solid; then "see how the best games make
  tooltips ... and do better": research J90_TOOLTIPS_PRAISED.md (subagent) -> Tips.gd index cards (beside the control,
  never over it, magnet lock 0.7 s, Shift pin, Esc, numbers + Means:) on the whiteboard magnets / tiredness words / the
  Combos gas line. tests/tips_test.gd.
- "whats the top row, what is the second row?" / "what is worked showing ??": rows labelled MORNING / EVENING / TIRED BY
  NIGHT; tiredness words FRESH / OK / TIRED / RED DAY / OVERCOOKED.
- Playbook: map's top bar overflowed onto the player column (clip + trimmed punches line); "See the flow" over the whole
  screen; player 400 x 440 ("remove the player or make it smaller?"); "plays only 1 animation" - move_player_probe:
  combos fell back to guard between punches, forced moves played nothing, the partner always played the jab reaction:
  fixed; "pivot ... backkick", "step in ... weird": the old walking strides the fight dropped in S320 - the player now
  steps as the fight does (feet <= 0.08 m off the floor); "slip and roll ... better timing": chains hand over at measured
  points (defence_peak_probe: deepest 13-46 % of a clip). "escapes has nothing": Escapes tab = MoveBook (8 escapes).
- He LIKES the Combos tab: "really fun to try and also learn from the book !!" (memory).
- Open: Q-S294-91 Moves -> move book, Plans -> game plan written as lines (PLAYBOOK_CLARITY_S359.md). Film on /review.

# S362 digest (2026-11-02) - update 64: the BJJ belt road, index cards on the money and the gym

Lean commits: f40e8c4 (WeekCamp split), b146d4a (belt road), 4638ca3 (index cards + T3 notes + card size fix), 647197d (update 64
notes, jump=belt), 2752e10 (the open stops the clock), f6fb32c (Ziva ZIVAFOOT1 collected), ab20e8a (notes), 90dfcd8 (week_actual_test seeded). Model: Opus 5.5.
Operator rulings acted on: Q-S294-80 "Yes, build both" (the belt road half; the week was built S354-S356); J90 6c/6g
(index cards, S359 brief).

## What now works
1. **WeekBoard split** (scripts/ui/WeekCamp.gd): THIS CAMP (goal lines, pulse, FIX IT / WAIT preview, injury load, the twist
   sticky) is its own node "Goal". WeekBoard.gd went from 489 to 282 lines, WeekCamp.gd is 235. week_board_clarity_test now
   reads the preview off the Goal node.
2. **The belt road** (scripts/rules/NoGi.gd, state/Grapplers.gd, ui/areas/GrapplerPage.gd; BeltRoad.gd from S353 holds the
   IBJJF floor). Career.grapplers (saved; an old save gains her) holds Ana Ribeiro, a no-gi featherweight: white belt, 2
   stripes, 130 classes, 9 of 14 syllabus moves owned, 4-2 in opens (the mockup's numbers; 130 rather than the mockup's
   96, so that she starts at the 2 stripes the rule gives her).
   - THE WEEK: 3 classes on Sunday's tick (200 classes white -> blue = ~15 months, inside the belt guides' 1-2 years). The
     class drills the move she is closest to owning, +3.2 a week (3 x 0.5 h at the pads rate 2.1/h).
     DECIDED: I chose closest-to-owned over the least-owned move. A coach finishes a move first, and least-owned left
     Armbar at 28/30 waiting while every other move caught up.
   - STRIPES: one due each quarter of the way (BeltRoad.stripes_for); the professor gives it (Give stripe N). Her 3rd comes
     due in 7 weeks.
   - PROMOTE: refused under the IBJJF floor (with the reason); above it allowed early, owing 25 % of the new belt's mat time.
   - OPENS: every 35 days on a Saturday (first Sat 7 Feb), 8-woman single elimination. Win chance 0.35 + 0.30 x her share
     of the way to the next belt, clamped 0.2-0.8 (0.54 now). A third of the matches end by submission; points come from
     BeltRoad.POINTS. Measured over 400 seeds: 1.06 wins an open, 70 golds (p^3 predicts 64).
   - FIGHTERS > Roster: ON THE MAT - NO-GI row; jump=belt opens her page; the board button is "Test: the BJJ belt road".
3. **Index cards** (scripts/ui/TopCards.gd, Glossary.gd, Tips T3). Cards: the cash (a week's money in rows: dues, classes,
   sponsors, rent and fees, coach, stipends, net; the runway), the date (next stop, month-end bill), GYM > Members, each
   piece of kit. T3: terms on a card are underlined in dashed red; resting on one for 0.25 s opens a yellow sticky note (the
   term, a definition of 15 words or fewer, Why:) beside the card, on the side away from the control. A pinned card keeps its
   note. 10 terms, each checked against the module named beside it (I fixed the "phase" entry, which first missed BASE).
4. **Defect fixed (found by the stills, not by the tests)**: every S359 index card measured itself before it was on screen.
   Off the tree its labels measure 0, so the card was placed as a 0-wide box: near the right edge it ran off the screen,
   and a note placed beside it landed on top of it. Cards now measure once on screen. tip_notes_test was red on the shipped
   code (size (0, 8)) and is green now.

## Evidence
- Flaky test fixed: week_actual_test took quick_start's random seed, and on one export run the injury roll took 6 days of
  week 2 (export.sh red). It now plays one known career (seed 1, as the golden path and TestJump do); 3 of 3 runs green.
- Lean suite (tools/run_tests.sh, JOBS=3): 112/112 after the belt road, 113/113 after the cards; export.sh ran it again.
- New tests: no_gi_test (40 checks: week, opens, career, save, page), tip_notes_test (24 checks), test_jump_test belt.
- Stills opened by Claude, sent to him, on /review S362: docs/playtest/S362/s362_belt_road_real.png,
  s362_belt_road_stripe_due_real.png, s362_roster_real.png, s362_whiteboard_real.png (the split board, unchanged),
  s362_money_card_real.png, s362_members_card_real.png.

## Decided (developer calls, why)
- Grapplers live in their own list, not in Career.fighters: 63 places iterate the boxers (camps, bouts, stipends, the
  whiteboard), and a no-gi athlete must not walk into any of them.
- Her page shows one tab (Record), as approved. A tab that leads nowhere would be a defect.
- I left out the mockup's "Goal: blue belt by the summer" chip, because no goal system for her exists yet. A chip with
  nothing behind it would be fake.
- The coach's warning text says what the rule does ("starts blue owing a quarter of its mat time"), not the mockup's
  "confidence drops after each loss": grapplers have no morale to drop.

## Agents
- Ziva TASK_ZIVAFOOT1 COLLECTED (Lean f6fb32c = its diff c37006f..54c5aec applied onto main). Its _join_dbg hung once more
  (await ready after add_child, the S361 cause); I killed it by PID 38536 and gave it the cause plus "timeout on every run".
  I re-ran tools/join_probe.gd myself: BEFORE (main's MovePlayer, unchanged since c37006f) worst 95.0, mean 29.6; AFTER worst
  45.1, mean 13.7 (-52 % / -54 %), its numbers exactly; travel within 7 %. move_book, game_plan, combo_builder, move_clips,
  strike_browser and move_player_probe (30 moves, 0 missing) are green on the merged tree. The film
  docs/playtest/ZIVAFOOT1/footwork.mp4 (each move BEFORE then AFTER) was opened as a contact sheet, sent to him and put on
  /review. MY BRIEF'S ERROR: its 0.12 m foot gate was an absolute ankle height, but her ankle stands 0.155 m in guard, so no
  build could pass it. Ziva's rise-from-own-floor reading (0.053 m worst) is the gate's meaning. Next brief: gate the rise.
- Kalli K-BELTROAD1 queued (SQ26, seat_queue): a game-design review of the belt road. Its answer lands in
  research/K_BELTROAD1_KALLI.md and is S363's first input.
- No other seat: every other item was mechanics/UI (operator S338 rule). Ziva is free: the SMOOTH3 film waits on his
  verdict (Q-S294-89), and the footwork's remaining peaks (feint 45, slip counter 31) are the clips' own motion.

## Not done / next (roadmap now = S363)
1. Kalli's ONE first change for the belt road (SQ26).
2. The week review shows Ana's week on the mat and her open (today only the news does).
3. His /review comments on update 64; Q-S294-89 when he answers.
- Miro production map not moved this session (handover at 430k context).

## HANDOFF
Working commit Lean 90dfcd8; update 64 exported (Builds/FightCamp.exe, 113/113 tests); board Test button "the BJJ belt road".

# S341 digest - update 43: scouting in stages, every opponent's record kept, plan branches, real fight plans (2026-11-01)

Work in E:\FightCamp\Lean (main 50e583c). Build: Lean/Builds/FightCamp.exe (full suite green, 80 tests, tools/export.sh).

## Operator inputs this session (verbatim)
- Q-S294-65 board answer: "Yes, build it in that order" (scouting in stages, SCOUTING_S340.md).
- "can you find real fight plans to compare them or add them as situation templates on grappleflows"
- "if we done it right will the video (upload your own footage) will decode some of our footage and make the flow for that scenario ?"
- "also the records should always keep all information available for the other opponents (history)"
- "use some imageneries scenarios for the fighters past victories to see what and how it will show on the fighters card history panel"
- "goose and cursor finished ? you need to trim the text walls, use modals/tooltips and smarter use of space (icons) and refer to research on what UIs player like"

## What now works (evidence)
1. Main CI was red on every push since 07:39 (grapple_contact_test "push-out costs 9.6 ms" on CI runners vs 1.5 ms here). The
   cost is now measured against a reference workload timed beside it: 3.99x here, bound 8; a mutant that pushes out twice
   reads 8.41x and fails. Main CI green since 9b62838.
2. Fight flows step 2 - WHEN branches (c6c2130): an arrow may carry `when` (the opponent's game); a card holds one arrow per
   situation + one any-time; PlanFight throws the situation's arrow first. plan_bout_test (Lucy vs Maria, 80 bouts): the good
   plan + 3 branches wins 0.556 of exchanges vs 0.534 without (edge +3.62 vs +2.57), branches thrown 142 times. WHEN picker on
   her board; flow view fixes (Mid stays under Long; an arrow and its way back no longer share a curve; branch line wraps).
3. Scouting in stages steps 1-2 (071c437): OppFile - record/look/style free at booking; best weapon, habits, weakness hidden,
   each with its answer (plan branch / corner call / drill). Tape study opens one every 2 camp days (weapon first, weakness
   last); film depth follows the share found, so a full camp still ends at depth 3 (balance unchanged). Offer page SCOUTING
   card, Camp tab and fight night read the file. opp_file_test 16/16; every threat/weakness of 16 fighters has an answer.
4. Real fight plans (803807c): research REALPLANS_S341.md (subagent; 14 boxing + 9 wrestling documented plans with sources,
   spot-checked B8 Fury-Wilder II and B12 Taylor-Serrano I). PlanTemplates: 8 boxing + 4 wrestling templates, legal on our
   maps; "Real fight plans" on her board, the ones for her next opponent's game first, Load merges. Measured vs the starter
   plan (40 bouts): presser +2.10 vs +1.75, waiter +2.73 vs +2.13, long boxer +1.98 vs +1.80; Holyfield's "push her back"
   +0.40 - our answer table gives push_off nothing against a presser -> Q-S294-67 (5 table edits, the operator decides).
5. Records kept (50e583c): the file is written to the career's rival record (a rematch starts with it; a bout opens it whole).
   RivalPast: every rival starts with an invented past matching her W-L (vs the division's women and real-club boxers, points
   / split / stopped in round N), then every club-show and our bout (draws too). HER RECORD + WITH US on the offer page, Camp
   tab and WORLD > Rankings (any name opens her file). Fix found on the way: `fightstep end` before the last bell booked a
   0-round 0-0 draw (layout_snapshot never shouted) - it now boxes out the rest.
6. CLINCH2 round 1 (Goose #14, ed71b0b) NOT merged: CLINCH OK 1/6, probe measured a mock stage, spine set from _process (the
   clip overwrote it, and leaned back), every operator-ruling comment deleted. Round 2 brief in TASK_CLINCH2.md + issue #14
   (probe on the real FightStage via clinch_still's route; A-frame via CornerIK.upright(-deg), e59c478).

## Decided (developer calls)
- Template core arrows are any-time (a plan for an opponent's game is the fight's default); situation templates are all-`when`
  add-ons; Load merges the template first, her arrows on the free places after.
- Tape mail: only the best weapon is mail (1 a camp, was 2); later finds are news + the file card.
- accept() gives the bout its own copy of the opponent (the offer's dict was shared: save/load diverged).
- The opponent's corner tell waits for OPPPLAN1 (no data for it yet); scout trip + sparring partner are steps 3 and 5.

## Not done / next (S342)
- UI DEFECT the operator saw: S341's cards are text walls (HER FILE, Real fight plans, WHEN picker) -> icons + tooltips +
  modals; research J52_TOOLTIPS_AND_TUTORIAL, K_HUD2_KALLI, M_HUD2_MARIA, topics/ui_screens.md.
- Collect CLINCH2 r2, PADWORK1 r2 (Goose, running), FIGHTCARD1 r2 (Cursor pushed 1f48154, still running); SMOOTH2 and
  TAKEFIX1 (Goose, older) on the board.
- GrappleFlows video test (render our grapple chain, upload, compare its flow) - only with the operator's OK.
- Q-S294-67 answer; scouting step 3 (scout trip), OPPPLAN1, step 5 (sparring partner), PLANPADS1. Miro map not updated.

## Lessons
- A plan measured only in its own situation looks worse than an always-on plan: compare like with like (any-time cores).
- A shared Dictionary between an offer and a bout passes every test until state changes after a save.
- Check test lists (run_tests.sh is an explicit list) whenever a test file is added.

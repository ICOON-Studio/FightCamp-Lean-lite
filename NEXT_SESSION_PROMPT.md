# S428 handover: side panels round 3, the week design's critics, his marks on the fight screen (written 2026-11-10, end of S427)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S428` and redraw the Miro map.
S427 has no digest: its facts are here, in roadmap.json `now` and in memory (project_s427_outline_cornerbar, feedback_proper_outlines_s427).

## His words in S427 (verbatim)
- C273, Dues tab still: "use proper outline effects throught all project not cheap solutions."
- C274, BJJ bout film: "looks ok but maybe add some options for te player to decide during the fight ? and also add the missing refinement art and add visual effects"
- Corner bar marks (ops/Feedback/2026-11-10-20): calls box "make them smaller . and use the space to add some live stats ? or add more options (mechanic) or what else the coach can change/say during the corner minute for the player ?" + an arrow to the bottom-left; the name label "need better presentation"; Say nothing "same with 1 and 2".
- Boxing Manager stills: chips over the heads "i like the status indicator showing intention we can improve this"; their corner "their stats screen is useful but other than that they do only offer 1 option to the player and leaving him a bit clueless."; their week skip "this means there is not much for the player to do ?"

## Done in S427 (main, pushed; exported again at the end with the final bar; WHAT_TO_TRY current)
- ONE OUTLINE: scripts/ui/Halo.gd + halo.gdshader (Halo.ring / hover / cutout), on DuesBoards, CornerBar's call in force, NowPlate, GuideLight; tests/halo_test.gd. Dues paintings are cut-outs (assets/ui/dues/*_cut.png) with a chalk figure line (cutout.gdshader).
- CORNER BAR: calls + Say nothing small on the left under Pace/Aim (CALL_Y 90, CALL_H 66); the right is scripts/fight3d/RoundBoard.gd (landed, her game now, your calls with ticks); tests/round_board_test.gd. NowPlate's cost in words.
- TvShot.BAR_CLEAR 0.68: feet clear the bar at a cut. NOT enough when a boxer stands right at the lens (see corner_bar_board_real.png: Lucy's boots under the bar).
- Collected by diff: FIRELEVEL1 (PR 175, with the no-key fix; rule on main, switched off), KDFIX5 (PR 178; knockdown_still_test holds the stage still: 4 of 4). PRs 162/166/169/175/176/177/178 closed.
- WEEK DESIGN V3: ops/research/WEEK_DESIGN_V3_S427.md + docs/mockups/s427/week_v3_camp.png, week_v3_quiet.png. TWO FRESH CRITICS SCORED IT DEPTH 5 AND 5 (coach: look 6, clear 6, depth 5, to do 4, anticipation 6, reward 6; sim veteran: 6.5, 5.5, 5, 5, 6, 6). NOT on his board. Reviews + their 10/10 drawings: docs/mockups/s427/week_v3_critic_coach.md, week_v3_critic_simvet.md, week_v3_10_coach.png, week_v3_10_simvet.png.
  What both say (v4 changes the MECHANIC, not the wording):
  1. The squeeze has no fork: one claim on Friday can still land, one thing uses the body. Give each resource a rival: every tape find offers "teach the new move (raw, fires 1 in 2, costs evenings)" against "point an owned line at it (fires 3 in 4, free)" (coach); evenings cut into thirds so problems are part-paid (sim veteran; the game's pad night is 75 minutes).
  2. Wednesday's tap and Thursday's stop are one decision made twice. ONE mid-week stop: Wednesday sparring gets a job the player sets before the rounds (an answer under fire, the habit, engine, light), it costs the body (so the scale has a rival inside 80), and it shows the line fire n of 6 with the fight's own plates.
  3. The four answers as named tiles (situation, line, level, "fires 1 in 2", worth against this opponent), not dots: by the measured numbers sharpening an owned line (+2.8) beats the last missing answer.
  4. The quiet week needs a call every week: from a block's second Friday "call the test" (pass chance as a band) or "one more week"; Saturday chosen after the result; in the open spar the player picks WHICH line is shown.
  5. Everything rests on Reid's hands being scarce, unmeasured: the design says two evenings, the game has three pad nights; offers come 8 to 12 weeks out and a move is usable in week 2, so every answer may be owned before taper. MEASURE THIS FIRST (a probe: answers owned at taper on the coach's default week, with and without senior / bag nights).

## Running (yours to collect)
- cursor/fightdisplay3 (TASK_FIGHTDISPLAY3): the wooden side panels on today's main: the 'stamina' script error, the overlap, the symbol box, the name plate, IntentChip over the heads, the stale S382 check in tools/fight3d_play.gd. RENDER IT and read the log before collecting.
- THURSDAY2 LANDED AND IS ON MAIN (docs/THURSDAY2_RESULT.md, PR 180 closed): 10 opponents, 5 boxers, 525 camp-week Thursdays: 2 or more problems open in only 34% (0 open 28%, 1 open 38%); tiredness and cards NEVER a problem on the coach's default week; habit is nearly always the one open. So by v3's own gate the Thursday stop goes: the squeeze is laid on Monday with the named problems and clocks, and "the body" is not scarce in today's game (nothing pushes tiredness near 80). Its "lookup 100%" is by frequency, not priced: weak. WRITE THIS INTO v3/v4's gate table (not edited in S427: the critics were reading the file).
- qwen/moodhabit1 (TASK_MOODHABIT1): what Flat against Steady and each habit are worth in wins (two of v3's "to run" gates).
- Kalli: SQ39 BJJ in-fight choices, SQ40 what else the corner can say; John SQ37 belt ladder.
- Queued for Cursor after FIGHTDISPLAY3: HALOSWEEP1 (the outline on 12 more screens; dispatch_queue).
- PR 179 TRAININGB1 (Training tab B) landed, NOT looked at: render it, judge the stills, collect by diff.

## Open, in this order
1. (export is current: nothing to do here.)
2. His marks on the two new stills (8787/review, posts 2026-11-10_1821).
3. Week v4 from the two critics' lists above (and THURSDAY2: no Thursday stop), the hands-scarcity probe first; then two FRESH critics; 7+ from both -> his board.
4. Collect FIGHTDISPLAY3, TRAININGB1, THURSDAY2 as they land. RoundBoard's "<NAME> NOW" column goes when the chips are in (the brief says so).
5. More to say in the corner / BJJ choices: Kalli's pages -> design map + picture each -> two critics 7+ -> his board. BJJ "refinement art and visual effects" is NOT briefed yet (the bout is on old cream panels and a bare mat): brief it to Cursor after the choices are designed.
6. Cutman v3 (K_R28_CUTMAN_V3_PASTE_BRIEF_KALLI.md, unread by critics): make the map file, picture, two critics.
7. Legs: qwen/legtremble4's code retry on today's main (look at its four films first), then the legs brief (fewer, longer clips). Feet under the bar up close: a camera brief (the lens must keep both boots above the bar's top while a shot holds, not only at the cut).
8. Unread seat answers: SQ31 dues choice, SQ33 amateur ask (R37 map), SQ34 cheap club money, SQ38 small world (design only, after the week).

## Not done, say so
- ZIVA is down (start said FIX IT NOW; no free Godot slot all session). Fix it first: the command is in `start`'s ZIVA DOWN line.
- E: is 92% full (AMBER, 37 GB free). Rule is under 85%. Find what can go (wt_salvage, old tmp renders under E:\FightCamp\tmp) and ask him before deleting anything that is not a scratch render.
- Miro P0 frame: cards updated, the frame resize was refused (it is 5210 tall with old surplus cards low in it). Deleting those needs his yes.
- tools/fight3d_play.gd exits 1 on the stale S382 holo check (in FIGHTDISPLAY3's brief).
- The LAST CALL box now repeats the round board's YOUR CALLS: fold one into the other when the side panels land.

## Traps
- Parse before test: a parse error in a preloaded module hangs a headless test; wrap runs in `timeout 240` and grep "Parse Error".
- A shell command whose text holds the console exe's name is blocked, heredoc briefs too: write briefs with the Write tool.
- `seat_dispatch.py --task <ID> --seat <seat> --act` launches at once; the brief must be on origin/main; REGRESSION must list real test names.
- A seat's "all green" is a claim: FIGHTDISPLAY2's nine green tests hid a script error a real render printed twice.
- RingCamera.gd is exactly 500 lines; CornerBar.gd is 492; SidePanel.gd (on the branch) 499.

SETTINGS: S427 ran on Fable 5.2 and went long (two stages: the outline, then his fight-screen marks). Next session: Sonnet 5.5, high effort, Fast off (collecting, rendering, reading critics: no hard design problem unless the critics score under 7).

# S430 handover: two design maps at v2 waiting for fresh critics, his play fixes, seats running (written 2026-11-11, end of S429)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S430` and redraw the Miro map.
S429 has no digest: its facts are here, in roadmap.json `now` and in memory (project_s429_four_fighters_maps).

## USAGE (his words, S429): "you have approximately 30 hours to burn all weekly credits , donot drain it before thursday 4pm"
The weekly allowance resets Thursday 2026-11-12 16:00 local. Plan is Ultra. At the end of S429: weekly all-models 5%, Fable 9%, extra usage EUR 37.92 of 40 (unchanged all session). So: critic rounds and seat work are wanted, paced so the allowance lasts to the reset. Run `get_usage` at the start and before each critic round. A round of two fresh critics is about 600k subagent tokens.

## FIRST MOVES
1. `get_usage`. Collect what landed: FIGHTDISPLAY4 (Cursor: RENDER and read its stills, VISUAL), AMATEURPROBE1 (Qwen, measure only: check its sums), then the queue launches by itself (Cursor: TRAININGB2, GYMLIFE1; Qwen: CAMLINE1). If a runner hangs after "SEAT exit 0" (it waits on a Godot slot), mark the run `landed` in ops/AgentComms/live_runs.json after you collect, then `seat_dispatch.py --task <ID> --seat <seat> --act`.
2. TWO FRESH CRITICS ON EACH v2 MAP (he said "yes run them" for round 1; round 2 is the same work): ops/research/FOURSTART1_MAP_V2_S429.md and ops/research/AMATEURWEEK1_MAP_V2_S429.md. Make clean copies first (no scores, no "v2", no "critics"; docs/mockups/s429/*_for_critics.md are the round-1 copies: write new ones). Use the round-1 prompts as the shape (CRITIC_PACK.md + CRITIC_ACCESS.md first, depth score, dominant plays, menus, the list to 10/10, one 1920x1080 drawing through tools/render_mockup.py). New seats, never the same four: e.g. a Football Manager designer and an amateur club owner for FOURSTART; a boxing judge or referee and a roguelike or card-game designer for AMATEURWEEK. 7+ from both = his board, with a picture and the menus table. Under 7 = another revision, never the board.
3. Read AMATEURPROBE1 into AMATEURWEEK v2 section 3 (the stakes: best fight week against the laziest should be 10 to 12 wins in 100).
4. The build in Builds/S429 (see below): tell him, and move it to Builds/ when his game is closed.

## His words in S429 (all acted on unless marked)
- "on the new 3-4 fighter start try to use the guide to pinpoint different trainings according to different ratings and styles of fighters" -> the coach's read (TrainRead.gd built), FOURSTART1 section 3.
- "\"fix the hole\" i do not understand it , maybe use fix weakness ?" -> `weakness` everywhere.
- "check my board comments and then yes run them" -> C282 to C286 read (seen flags set); critics round 1 ran.
- Marks C282/C283 (fight screen): "remove these and restore the previous version and maybe put the bars at thebottom hud or fill up the top. Now these box panels blocking too much of the view" / "move bars uphere keep the holo as in previous version ?" -> TASK_FIGHTDISPLAY4 (Cursor, RUNNING).
- Marks C284 to C286 (Training tab): "check alignement on the texts/icons. What raw means ?" / "what are these , i do not learn information by looking at them" -> "Raw" is now "Learning" (done); TASK_TRAININGB2 (queued).
- "can you write scripts and animations for the fighters/customers that work out on the gym or this is work for later ?" -> TASK_GYMLIFE1 (queued, Cursor).
- "the pads animation is broken btw but it is not important for now since there isno mechanic on it" -> PADSANIM1 parked in roadmap plan.parked.
- "how do i save the combo ?" -> Save sat under the lessons, off the panel on a six-move chain: moved above (done).
- "Can you change the word 'Engine\" to something more appropriate" -> Stamina / fitness / tireless on every screen (done; internal ids keep "engine").
- "poster isnot centered correctly" -> the poster never grows wider than its slot (done, tests/fight_poster_test.gd; NOT proven red on the old code).
- "text is unreadable and out of limits" (Playbook > Game plan answers) -> chalk words on the wood button; UI.button2 grows to hold its words (done).
- "still i see bad camera angles and the fading effect you have on the background ropes looks weird when fighters head are at the same drawing height" -> TASK_CAMLINE1 (queued, Qwen: ruler on the game path first). Then his correction: "actually its the gloves that have a weird b;lur effect can yhou check that": the motion-blur add-on smears the gloves; CAMLINE1 step 3 measures it with and without `noblur` and is the task's first priority. NOT checked by Claude on a film: one guard still (E:/FightCamp/tmp/barguard1) cannot show it.
- "hits never go to the ribs ? also remove the stupid scoring its round 1 and it shows 2-3 it confusing for the player" -> the two big counts on the scoreboard are hidden, the lights stay (done). RIBS: in the rules a body shot does land on left_ribs / right_ribs (BodyMap.gd line 67), but the screen only names the WORST place, so ribs rarely show. NOT fixed: show the place each hit landed (fold into FIGHTDISPLAY4's review or a small FIGHTDISPLAY5: a rib spot lights on the figure when a body shot lands, and the tag names the last place hit, not only the worst).

## Done in S429 (main, pushed)
- Collected by diff: WEEKTESTS1 (PR 185), RANKSHOW1 (RankLine.gd), HALOSWEEP1 (PR 184), TRAINREAD1 (TrainRead.gd, reworded to weakness), MONEYFOUR1 (measure), BARGUARD1 (tests + a real fight render read: boots clear of the bar). PRs 181, 182, 184, 185, 188, 189 closed.
- MONEYFOUR1 (docs/MONEYFOUR1_RESULT.md, read not re-run): ONE stipend keeps the four-fighter club at 1.9 to 2.9 months of costs on today's start cash ($17,200); two: 1.2 months by week 52; four: 8 clubs in 10 close; none: $31,000 at year end. 46 bouts a year for four, about $12,600 in tickets.
- Critics round 1 (docs/mockups/s429, reviews + each one's 10/10 drawing): FOURSTART1 4 (sim veteran) and 4 (club coach); AMATEURWEEK1 3 (systems) and 4 (matchmaker). What all four found: fight strength is a plain average (`BoutRules.fight_power`), so "train the lowest number" beats the guide; the stipend switch is free and instant; a pass is free and the same name comes back in 5 days; the cut costs no tiredness; the tape only runs inside a camp and a no-camp bout still loses 1.5 (`night_edge`); a day job is only x0.85 in code; pad nights are per fighter; "read" clashes with TheRead.gd.
- v2 of both maps written from the reviews (FOURSTART1_MAP_V2_S429.md: one Club week board, seats as mornings, coached mornings, weighted fight strength, one place two takers; AMATEURWEEK1_MAP_V2_S429.md: a bout sheet of three names, one "tank at the first bell" bar, three week shapes, a film evening that answers one question, plan-line upkeep, pull-outs).
- Briefs written: FIGHTDISPLAY4, TRAININGB2, GYMLIFE1, CAMLINE1, AMATEURPROBE1, MONEYFOUR1, TRAINREAD1 (ops/research/TASK_*.md).
- The 10/10 drawings were NOT opened by Claude (only the critics checked them): open them before quoting.

## Running / queued at the end of S429
- Cursor: FIGHTDISPLAY4 RUNNING (launched ~09:50); then TRAININGB2, GYMLIFE1 from ops/AgentComms/dispatch_queue.json.
- Qwen: AMATEURPROBE1 RUNNING (launched 09:27); then CAMLINE1.
- Open PRs not collected (old): 163 LEGTREMBLE3, 168 LEGTREMBLE4 (legs: retry qwen/legtremble4's code on main, re-render).

## The build
Builds/FightCamp.exe is the S427 build and he was PLAYING it during S429 (do not overwrite a running game). A fresh build with everything above was exported to Builds/S429/ (check `/e/FightCamp/tmp/export_s429.out` ends "built ..."; if not, run `OUT=E:/FightCamp/Lean/Builds/S429 sh tools/export.sh` through godot_slot). WHAT_TO_TRY for it: Builds/S429/WHAT_TO_TRY.txt.

## Not done, say so
- No picture for either map; nothing of FOURSTART or AMATEURWEEK is built except TrainRead.gd and RankLine.gd (neither is wired to a screen).
- The Miro P0 map was redrawn once mid-session; the cards added after (TRAINREAD1, MONEYFOUR1, BARGUARD1 done; FIGHTDISPLAY4, TRAININGB2, GYMLIFE1, CAMLINE1 next) are in where_we_are.py but NOT on Miro. The frame resize is refused by Miro; four surplus cards (ids ...087362639, ...036993814, ...087362638, ...036993813) need his yes to delete. P1-P9 frames not touched.
- E: 91% full (about 40 GB free, AMBER). Nothing deleted: ask him.
- Week design v4 not started (it is re-based on the two maps once they pass).
- Kalli's corner answer (ops/research/K_CORNER_MORE_S427_BRIEF_KALLI.md) is filed, not read.
- tests/head_aim_test.gd has an uncommitted change from before S429: not mine, left alone.

## Traps
- A `cd` into another folder moves the session's working directory: use absolute paths.
- Every Godot job goes through `python ops/Tools/godot_slot.py run --who claude -- <command>` (rule_guard blocks a bare start); headless tests two at a time on AMBER.
- A Cursor run can die silently with a 0-byte out file; the 30-min reconcile then archives it as "collected" because its branch equals main. Check the worktree has a commit before trusting "collected".
- The seat runner's own checks wait while one of your renders holds a Godot slot.
- GamePlan.gd 499 lines, UI.gd 498, RingCamera.gd 500, CornerBar.gd 492, WeekBoard.gd 471.
- MoveMastery words: New / Learning / Usable / Sharp / Signature.

SETTINGS: S429 ran on Fable 5.2. Next session: the same, default effort, Fast off: the work is critic rounds, collects with renders, and map revisions.

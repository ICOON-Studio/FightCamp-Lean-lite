# S360 DIGEST - update 62: the Playbook as a move book and a game plan; the opponent on the whiteboard (2026-11-02)

Lean d9a1251..c37006f (main, pushed) + this Game commit. Model Opus, one stage.

## Board answers acted on (operator, verbatim)
- Q-S294-91 Playbook: "build it make it interactive for player, with meaningful options and not chores and visually and
  progressively rewarding" -> BUILT (Lean 7749bec).
- Q-S294-90 whiteboard: "Both" -> BUILT (Lean c37006f).
- Q-S294-88 disk: "Yes, delete all 4" -> DONE. E: 12.5 -> 34.1 GB free. Kept first: wt\ZIVA pushed as
  backup/ziva-playtest-s358 (it was NOT on origin despite the attachment - pushed now, 0bd06242), its 7 code files + a
  patch in E:\FightCamp\wt_salvage\ZIVA_S360; final_sheet.png + jab_sheet.png in E:\FightCamp\archives\metahuman_pilot_sheets.
  tmp: 3.7 of its 3.7 GB was under 7 days old, so only the older files went (the attachment's 26 GB estimate counted it).
- Q-S294-89 SMOOTH3: "no clue, need to see video" -> smooth3_ab.mp4 sent to him as a file (SendUserFile); question stays.
- Q-S294-86 "Yes, build them" (review reveal, push back, fight poster) -> next session. Q-S294-84/80 "Yes" (whiteboard tab
  built S356; belt road v3 to build). Q-S294-85 "Yes, that order" (kickboxing + wrestling with the MMA update) noted.
  Q-S294-87 "Not yet" (no outside testers).

## What now works
1. PLAYBOOK > Moves = a move book (MoveWords: all 30 StrikeMap moves in one line each, grouped by ring place). Cards carry
   their tier (READY / RAW / USABLE / SHARP / SIGNATURE / LOCKED) and a pad-time bar; "11 of 27 moves ready" and the next
   combination to drill head the book; each group "2 / 8 ready". MoveBook gained `progress` (Escapes uses it too).
2. PLAYBOOK > Game plan (tab renamed from Plans) = GamePlan + pure PlanLines: fighter.arrows as lines, one per place and
   situation. Every answer is rated against the opponent's game the way the bout scores it (PlanFight.fit + edge minus the
   no-plan average): Beats it / Works / Walks into it with its +n. Decisions it creates: which 4-9 places get a line (coach
   limit), which answer per place, which situations get their own answer, rate against another game. No chores: picks save
   at once, hover plays the move, Real fight plans load in one click. Rewards: the plan-edge bar tweens and its band
   flashes on a change; locked lines name the coach rating that opens them (36/48/60/72/84 for lines 5-9); Test it shows
   up/down on the last test. The StrikeBrowser map stays behind Open the map.
3. Whiteboard: WeekOpp - the opponent's goal line ("VS MARIA 0 of 2 - 2 SHORT"): presser 2 slip rope, range boxer 3
   intervals, counter-puncher 2 shadow, big hitter 2 neck mornings (fight week 1). Coach weeks miss it 73 of 84
   game x phase x focus; every miss fixed in 1-2 edits. Sim records each camp week that starts with it met (bout.prep);
   LiveRound adds up to +3 power points (EDGE x share) in exchanges on the opponent's own game. WeekCoach: "My lines all
   land. Maria is your call - you watched the tape." Evenings are words on the day; Pads/Combo dials behind "More" in camp
   week 1 (WeekBoard.camp_week, shared with the header).

## Evidence
- New tests: plan_lines_test (pure, 2 fighters differing in pad time x 2 games), game_plan_test (real path: quick start,
  sign, Moves + Game plan), week_opp_test (every style's game x phase x focus). All PASS.
- Focused runs green: move_book, combo_builder, strike_browser, plan_screen, plan_board, plan_test_it, plan_templates,
  week_board_clarity, test_jump, week_coach/actual/twist/phase/plan, balance_harness, perk_fight, peak_camp, save_load,
  golden_path. Export with the full list: see the export line in roadmap NIGHTLY/now.
- Stills (hidden desktop, Lean tools/s360_playbook_stills.gd): docs/playtest/S360/*_real.png, opened by Claude, on /review S360.
  Two defects seen on them and fixed before shipping: UTF-8 "·" mangled by a PowerShell rewrite (GamePlan.gd), move-book
  card lines cut at the edge (now wrap, cards 380 x 104).

## Decided (developer calls)
- Lines rate against the opponent's MAIN game for any-time lines and their own situation for When lines - the same
  numbers PlanFight uses in the bout, so the screen never promises what the fight does not do.
- No Save button: a legal plan writes on every pick (the old Save was the chore he meant).
- Opponent line counts only weeks that START with it met (Monday snapshot) - no reward for a week edited after it ran.
- Prep edge +3 (a third of a best plan arrow's 9): it matters in her-game exchanges, never outweighs the plan itself.

## In flight
- Ziva TASK_ZIVAFOOT1 (research/TASK_ZIVAFOOT1.md): Playbook player's steps/pivots/slips/rolls clip joins, branch
  ziva/footwork1 in wt/ZIVA_LEAN, red first with tools/join_probe.gd; chat "Task Setup for Ziva Footwork 1" at 127.0.0.1:7012.

## Structural debt queued
- WeekBoard.gd 484 lines (rule 500): split THIS CAMP (_camp/_line_under/_pulse/_preview) into WeekCamp.gd before the next edit.

## Lessons
- Never rewrite a UTF-8 .gd through PowerShell Get-Content/WriteAllText: it mangles non-ASCII. Edit tool or Python utf-8.
- GDScript helper names that shadow Object/Node virtuals (_ready, _set) break the parse: name helpers _is_ready/_write.
- A disk attachment's "kept" claims must be re-checked (the backup branch did not exist).

## HANDOFF
Working commit: Lean c37006f (main, pushed); Game this commit. Next: S361 in order - (1) collect Ziva ZIVAFOOT1 (read the
probe lines yourself, film to him); (2) Q-S294-86: week-review reveal, then she pushes back (morale = trust), then a fight
poster per bout; (3) belt road v3 in the Record tab (Q-S294-80); (4) WeekBoard split; (5) Tips cards on the top bar/gym +
T3 keyword notes (J90 6c/6g); Q-S294-89 waits on his look at the film.

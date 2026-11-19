# S527 handover (written 2026-11-19, S526 - Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. S526 is in roadmap `now`.

## GOAL (owner, verbatim, still on): "i want animations fixed (at least 7/10)"
The ONLY animation session is now "anim-range" (Claude Desktop, Fable, local_ffb51673; lean-f3 stopped at the owner's
$60 cap). Do not start another while it runs. Its state: the ANIMATION LOOP STATE section below (third v2 film 4.0 / 4.5).
METHOD line below (S510) - quote it in the first message.

## MAIN LINE - DO FIRST (S526 state; S526 is in roadmap `now`)
1. STEPTUNE1 (Goose #394, TASK_STEPTUNE1.md): sizes StepEffect.TABLE toward StepValue.TARGET on the 20 best / wrong
   cells, from a PARTIAL TREEVALUE3 (docs/TREEVALUE3_RESULT.txt). The PC run's full file is E:/FightCamp/tmp/treevalue3.txt
   (feint / tie_up / roll_out / push_off rows came after the copy): read it beside Goose's result. Collect by diff (TABLE
   numbers only), rerun the step_* tests + golden_path; then STEPVALUE1's "step worth on the learn card".
2. Goose #391 KNOWBOTS6 (TASK_KNOWBOTS6.md): a shared per-prospect misread rho 0/0.5/0.8/1.0. Decision rule is in
   KNOWLEDGE_SCOPE_S525.md "Phase 2 decision (S526)". KNOWBOTS5 said: potential readers LOSE, shown rating off 0.83 only.
3. Goose #392 TURNPROBE2 (TASK_TURNPROBE2.md): turning pro lines 2/4/7 measured as the design means them (debut's own
   money, each ask played forward from one snapshot, paired PREP-YES). TURNTUNE1: no constant moved them; none taken.
4. COACHFIT1 v9 revise at Dola SQ231 (FITPROBE2: TOP fit = Sharp 1.53 weeks sooner, +0.08 wins in 100, FOCUS +0.95:
   no stakes as a multiplier). Then two fresh critics (Goose + Dola chat), 7+/7+. COACHFIT1 is NOT wired until then.
5. LEDGER1 v1: Dola 8 / 8, Goose 7 / 6 (#393) -> v2 revise at Dola SQ232 (both critics + Claude's code check); then two
   fresh critics, 7+/7+ -> his board with `ask --attach`.
6. Guard v4: step 6 camp notes DONE S526 (GuardNotes under THIS CAMP's vs line; not rendered yet - render it on the
   hidden desktop when no game is open). Left: step 5 HUD (scripts/fight3d = the animation session's files) and the
   fight plan defence tab - posture (GuardWear.POSTURE_*) is not wired into GuardState: design call first (a new choice
   needs a probe), not a menu alone. S526b: written up in GUARDWEAR_WIRE_S524.md bottom (HIGH dominates while body
   punches are 6% of the mix) -> GUARDPROBE2 brief next.
7. GROK CHAT SEATS ARE DOWN (gbot 404): Kalli / Maria / John queue items fail. Use Dola (chat) and Goose (critic issues).
8. Ludo (paid to ~11 Dec): no asset job in S525/S526 (S526 ran at 98% weekly usage and saved it for the animation session).
9. Qwen SPLIT500C running (GymSpend -> GymDeals, E:/FightCamp/wt/LEAN_SPLIT500C): collect by diff.

## DONE IN S525 (Opus; all on main, tests named in each commit green)
- Collected 7 probes: GUARDPROBE1, MORNINGSPROBE2, MONEYFOUR2, FITPROBE1 (Qwen), KNOWBOTS4 (Goose #379), TURNPROBE1 (Goose
  #380, finished before its job died on network errors), PROCONTRACT1 (Arena #383). PRs 382-387 closed, issues 379/380 closed.
- GUARD v4 step 2 damage LIVE: amateur and pro wear scales (AMATEUR_SCALE 0.28, WEAR_SCALE 0.40), each block leaks
  transmission x base x K_THROUGH 0.038 into m.damage. tools/guard_onoff.gd (200 bouts a cell, 4 s): damage +7.3..10.5%,
  stoppages up to +3.5 points (6-round mismatch), amateur last bell 0.53, pro6 0.32. Step 3 decided not built. Step 5: result
  row "Got through the guard (in punches)", Ludo's icon beside the corner guard line (FightNight). Guard habits wired
  (slow starter / fades late / chases the stoppage -> wear and recovery, GuardState.after(.., n, opp_habits)); the opponent
  file's habit read names the guard effect (OppFile.GUARD_NOTE).
- TURNING PRO: Arena's blind contract test found the 3rd-decline news line wrong (Roster.DECLINE_NEWS per the design);
  decline_pro with no offer is a no-op; pro_signed keeps the house key. tests/pro_contract_test.gd in run_tests.sh.
- KNOWLEDGE: KNOWBOTS4 yardstick VOID twice -> CLAUDE.md item 8: scope plan KNOWLEDGE_SCOPE_S525.md + KNOWBOTS5.
- STEP LEVERS wired (see 1). tests/step_levers_test.gd (control arm levers_on = false).
- CLASS NIGHTS: a class pays only on an evening it takes from pads (GymSpend.paying_classes) - MONEYFOUR2's free Tue+Thu
  arm is not reachable from the button; the Wednesday class (+$3,042 for 6.9 mastery in 26 weeks) is a real choice.
- LEDGER1 v1 (Dola SQ227) extracted to DESIGN_LEDGER1_V1.md; critics queued.
- The owner asked why memory was full: ~19 idle Claude Code sessions (250-500 MB each) + the app. He closed some (RAM 93% -> 71%).
- Exported (Builds/FightCamp.exe), WHAT_TO_TRY S525 on top.

## DONE IN S524b (second stage, after `ship`)
- Guard step 4: the "Tie up" shout is the clinch (+10 under half guard, once a round), "Hands up" gives +5 at the next
  corner (GuardState.after(.., call)). Corner minute: CornerCard.guard_line - "Guard down to 40% (leaking): Hands up or a
  tie-up buys it back." (words fight night: FightNight GuardLine; 3D cast card text). Stamina / Strength hovers name the
  shoulders (AttrBoard.shoulder_line). guard_state_test 19 checks. NOT rendered: the corner GuardLine (shows only under half).
- LEDGER1 (contracts, Q-210's 4th) v1 design map brief -> Dola SQ227 (ops/research/DESIGN_LEDGER1_V1_WRITE_DOLA.md);
  then two fresh critics (design_loop.py critic), his board at 7+/7+.
- lean-f3 (the anim session) was idle a day: S524 sent it a resume message (film + blind round of the S513 fixes).
  Check it moved; if it did not answer, the next session starts the animation item first (CLAUDE.md "ANIMATION PROGRESSES").
- PR #381 closed (collected). Stopped at 509k context; weekly usage 92% (resets 19 Nov 14:00).

## DONE IN S524
- Collected Goose #378 KNOWLEDGE1A. Fixes on collect: legacy expose() of a spar/bout opens under fire; potential never
  "known". Goose dropped 7 old checks -> tests/knowledge_keep_test.gd (13 checks, red before the fix).
- TURNPRO1 M11: scripts/ui/ProWeekLines.gd + WeekReview split (WeekPlanBlock.gd); turn_pro records stipend + costs,
  BoutFinish the debut's gym cut; tests/pro_week_lines_test.gd; golden_path checks the ledger.
- KNOWLEDGE1 step 2: KnowWire (+ Sim.gd split: goal_read -> SimGoal.gd), tests/know_wire_test.gd.
- GUARDWEAR1 collected (Arena lite PR 19): Arena caught the design's multiplier error (0.5 + .. vs the table's 1.0 + ..);
  'trait' is reserved in GDScript 4.7 -> trait_id. Mutant cap 0.85 -> 4 checks red.
- Guard v4 steps 1-2 + result rows: tests/guard_state_test.gd (13 checks). Render ops/previews/s524/result_numbers.png
  (review board): WEAR_SCALE 0.45 emptied both guards -> 0.28 (Lucy 52%, Priya 62% after 3 amateur rounds).
- Seen defects fixed: file_limits red (BoutRead 501, Main 471).
- Briefs: TASK_GUARDWEAR1, TASK_KNOWBOTS4, TASK_GUARDPROBE1, TASK_PROCONTRACT1, TASK_FITPROBE1. Plans: GUARDWEAR_WIRE_S524.md.
- Exported (WHAT_TO_TRY S524 on top). ONELOOK1: GuideBubble OFF FRAME is headless-only (real render fine).
- TRAP: a `cd` into a worktree in Bash moves the session's folder - use `git -C` or a subshell.
- TRAP: ops/Tools/lite_mirror.py `push` still targets the deleted old repo; Lean-lite is synced by board_reconcile (fine).

## BILLING (S513) - unchanged, see S518's block in git history (support.claude.com/en/articles/17154008; claude -p only).

## GOAL (owner, verbatim, still on): "i want animations fixed (at least 7/10)"
The ONLY animation session is the terminal CLI session "anim S513" (peer lean-f3, Fable). Do not start another.
METHOD line below (S510) - quote it in the first message.

## MAIN LINE - DO FIRST
1. His board: Q-S294-275 guard damage v4 (critics Dola 8/8/7, Goose 8/7/7; design + both critics attached). His yes =
   build after turning pro. His look at the turning pro offer (review board S523, map frame s523_pro).
2. TURNPRO1 rest: everything in the design's section 6 is wired EXCEPT M11 (the week review's signing / debut ledger
   line): scripts/ui/modals/WeekReview.gd is at 497 lines - split it first (e.g. the pads block into its own file),
   then add the line. The probes: TASK_TURNPROBE1.md is queued for Qwen (dispatch_queue, behind MORNINGSPROBE2 and
   MONEYFOUR2); collect it and size the ESTIMATEs in ProCall.gd from its pass lines.
3. Collect TREEVALUE2 (Qwen, E:/FightCamp/wt/LEAN_TREEVALUE2) -> tune StepEffect. Then MORNINGSPROBE2 + MONEYFOUR2.
4. (streak_probe rerun DONE S523: docs/ASKGAP1_RESULT.md "Rerun 2" - ON A RUN 13.4% of active weeks, 0.50 ducks a
   season, 47 OWED reached, 21 owed bouts booked (w-l 8-13). All three lines YES; nothing to tune.)
5. KNOWLEDGE1 build (v3 approved; scripts/rules/Knowledge.gd exists - diff it against DESIGN_KNOWLEDGE_V3 first).
6. LUDO: his Q-274 answer "Neither - keep today's screens" -> no repaint of screens. Ludo makes asset pieces only
   (icons, pictures, props); sounds stay Qwen's. Give it one asset job a session while paid (~11 Dec).

## DONE IN S523
- Collected Goose #376 TURNPRO1A (scripts/rules/ProCall.gd + tests/pro_call_test.gd, PRO_CALL failures=0) and Goose #375
  guard v4 critic (ops/research/DESIGN_GUARDDMG1_V4_CRITIC_GOOSE.md, 8/7/7). Issues closed; stale PR #377 closed.
- TURNPRO1B WIRED: scripts/state/ProOfferWire.gd (c.pro_offer keeps its old keys = first house; adds offers, forecast,
  expires, asked, plain). Roster.check_pro builds it (lapse check, waited, age gate), turn_pro(c, house) signs on the
  house's deal (debut weeks, opp gap, costs from the purse, morale), decline_pro (same house next time, titles at
  decline, morale), debut_night pays the purse cut + ticket share under a deal (old saves keep the S329 night).
  ProOffer modal: two columns, one ask grid each (won't = disabled), Back to the plain offer after a counter, gym and
  boxer money, pays-back line, morale on buttons, days left, age line, declines left; costs and what ends as one line
  each (fits 1080). Needs: both houses + days to answer. Acts: turnpro <house>, proask house|kind, proplain.
  DECIDED: the window running out is not a decline - the promoter waits 2 more wins, no morale or loyalty change.
- Tests: pro_offer_wire_test (21 checks, in run_tests.sh), pro_call, loyal_pro_share, loyalty_hooks, pro_ladder,
  promises, pro_debut, golden_path (its debut check now reads Roster.debut_night), test_jump, world_slate, menu_world.
- S523b: M14 the house's lean - ProLean.extra adds the next-nearest tune-up (Harrow & Finch) or step up (Bow Lane) for
  the first 6 pro fights; the softer ask = tune-ups only for pro_tune_ups sets (spent on each booking); Fights line.
  ProLadder 481 lines. pro_lean_test (7 checks), pro_ladder, golden_path green.
- S523d-h: M7 stipend hover, M15 History milestone (f["pro_signed"]), M13 the debut corner note (FightNight DEBUT_NOTE,
  golden_path checks it), M9 club show followers (+10, HomeBout.SHOW_FOLLOWERS, in ProOfferWire.forecast), M19 the
  signing week's two extra people (GymPeople.buzz_members), Ludo promoter badges (assets/ui/art/promoters). M18 was
  already there (Stamina for five rounds is always offered). CRITIC_PACK item 9 updated.
- KNOWLEDGE1A pure rules briefed to Goose (issue #378, ops/research/TASK_KNOWLEDGE1A.md). Collect, then wire per the
  design's build order (section 14).
- Exported; WHAT_TO_TRY S523 on top. Render: ops/previews/s523/pro_offer.png (review board + map).

## DONE IN S522
- TURNPRO1 (approved Q-227, the fight week is built) is now being built: TURNPRO1A brief (ops/research/TASK_TURNPRO1A.md,
  pure scripts/rules/ProCall.gd + tests/pro_call_test.gd: who calls by ticket forecast, the two houses' terms, one ask
  with a counter, the gym's and the boxer's money apart, morale, age 32, the 14-day window) -> Goose issue #376. CHECKs
  settled from code: the gym's 25% (Roster.GYM_SHARE) is taken from the purse and from the ticket share (ProDebut.night);
  the signing card's ambitions (Recruit.ambition) never say "turn pro" - "A regional title within a year" = the title
  ambition, the pro row waits for an ambition that says it. NEXT after #376 lands: collect, then wire into Roster
  check_pro / turn_pro / decline_pro (two offers side by side in the band, the ask on the offer card, the pays-back line),
  then the map's probes (section 7) with a bot per policy.
- The design loop tracker is stale: TURNPRO1, KNOWLEDGE1, WEIGHT1, STEPVALUE1 all passed critics AND his board
  (Q-227/228/230/232). KNOWLEDGE1 (v3, approved) is the next build after TURNPRO1 (scripts/rules/Knowledge.gd exists:
  diff it against DESIGN_KNOWLEDGE_V3 first).

## DONE IN S520
- Q-S294-273 ("what do you think ?"): full pads, his Q-260 ruling; nothing to change.
- ASKGAP1: the Ask door opens the day after a bout (AskBout.rest_gap / ASK_AFTER_DAYS 1). The 10-day rest gates the bout,
  not the call: AskFlow.rest_end drops show nights before the rest ends (AskFlow.shows) and book refuses them; the host's
  late ask (LateAskWire.ready_for) still waits the whole rest. Rerun: docs/ASKGAP1_RESULT.md - door open 671 of 1377 hot
  Mondays (was 0), 187 asks, 64 booked, 123 ducks, 48 OWED, 18 owed bouts booked; points at day 728 within a few.
  Tests: ask_bout (cases + a mutant), ask_wire 1b/1c, rival_offer_wire; 12 touched tests green. CRITIC_PACK Ask line current.
- PRs #373 / #374 closed (collected in S517b / S518b). Exported, WHAT_TO_TRY S520 on top.

## DONE IN S519
- Q-S294-272 "Yes, build it" -> club week v11 BUILT with pads FULL (Q-S294-273: he asked "what do you think ?" -> full
  pads, his Q-260 ruling). Coached mornings (CoachedMornings.week_deal + MorningWire, read by WeekPlan.day via
  Sim.week_ctx dow/coached), class nights (ClubClasses; the coach's $350 untouched), half sponsorship (DayJob.count_of,
  GymSpend.set_half), loyalty trend (Loyalty.trend), film alone = half a read (OppFile.half_tape), forecast + clash
  (ClubForecast), second-signing note. Tests: morning_deal, class_nights, loyalty_trend, half_tape, half_sponsor,
  club_forecast, club_week_walk (golden path). Sim.gd is at 500 lines: the next line there needs a split first.
- STREAKPROBE1 collected: HotStreak.POINTS 15 -> 8 (1.2% -> 11.6% of active weeks).
- Side task: a Steamworks status email drafted for him. Steam: tax/identity file RECEIVED, up to 45 business days from
  ~2 Oct (~8 Dec). The 2 Oct "No tax information on record" note was stale - corrected in memory.

## DONE IN S518b (second stage, same session - owner: "one stage per session ... there is no such thing, you invented it")
- Rule fix: WORKFLOW s3's "ONE stage per session" line (written by an earlier session, never his) removed; `ship` now
  says start again and keep working; hand over only at ~420k context.
- Critics moved off John (Grok bot, out since S512; 14 failed sends "listAgents 404") to Dola: SQ223 guard v3, SQ224
  club week v11.
- ONELOOK1 real render (layout_snapshot on the hidden desktop): Playbook > Combos pushed the page to 2055 px (Menu off
  screen, 3D preview cut) -> ComboStrip tiles two rows of three; Game plan bell box cut move names -> BELL_W 420;
  "Say nothing" min 140 px; the sparring day reads SPARRING / night - referee only. The headless OFF FRAME on the
  guide bubble is a headless window artefact (real render fine).
- LADDERPROBE4 (Qwen) collected: NO rival call in 60 two-year runs - the Ask door was read today and was shut on 99.7%
  of ranked Mondays (booked 60%, resting after a bout 34%). FIX: RivalOfferWire reads the door on the day the rest ends
  (AskFlow.open/book take at_day) and names a show after the rest; rival_offer_wire_test checks it. Rerun the probe on
  the fix (tools/ladder_probe.gd, its own doc) before tuning OFFER_GAP_WEEKS.

- STEPVALUE1 the Why (map s7) CODED, NOT YET RUN (PC RED: the owner was playing, Godot blocked): FightWhy._step_lines -
  the step fired 3+ times weighed against the opponent's style (StepValue.TARGET) on YOUR PLAN / AGAINST YOU, and
  "Learn Pivot off the ropes" on NEXT when the ropes count fired and no way off did; AfterFight stores m["opp_style"],
  ResultCause passes it. FIRST: run tests/step_why_test.gd + fight_why_test + result_tabs_test, then commit
  (scripts/rules/FightWhy.gd, scripts/state/AfterFight.gd, scripts/ui/ResultCause.gd, tests/step_why_test.gd, add the
  test to tools/run_tests.sh). Then rerun tools/ladder_probe.gd on the rival-call fix.

## DONE IN S518
- Rival gym offer (R9) checked on the real screens: tools/rival_offer_still.gd -> ops/previews/s518 (Overview card +
  Home red need), on the review board. Reads right.
- HOT STREAK + DUCKED/OWED (map R6) wired: scripts/state/HotStreak.gd - on a run = won the last 3 AND +15 ladder points
  in 8 weeks (c.results rows now carry "pts", BoutFinish); AskLadder passes the streak and the points gap to
  LadderRep.yes_score (-20 when the rival is 0-8 points above); AskFlow.book: a No while on a run from a rival 0-8 above
  = DUCKED (f["ducks"][name] = [weeks], once a week), news line; two inside 8 weeks = OWED: AskLadder scores 95 (Leans
  Yes - they owe you this bout), booking clears the ducks. AskPanel: "On a run: 3 wins, +17 points in 8 weeks." (green)
  and the DUCKED / OWED chip. tests/hot_streak_test.gd (19 checks; in tools/run_tests.sh). ask_wire, ask_bout,
  ask_dates, ladder_table, rival_offer_wire, golden_path green. Exported; WHAT_TO_TRY S518 on top.
- R6 note: OWED's "a No pays +3" (RivalOffer.owed_answer) never fires - our yes score is deterministic and 95 is a Yes.
- Goose critics #369/#371 pushed but could not open PRs: files copied to main by hand, issues closed.

## DONE IN S517b (second stage of S517)
- RIVALOFFER1 collected (Goose #372: scripts/rules/RivalOffer.gd + rival_offer_test). WIRED: scripts/state/RivalOfferWire.gd
  (monday from GymSpend.day_events beside LateAskWire; only ranked boxers, 4 weeks between calls a boxer, the rival's own
  8 weeks; Accept books through AskFlow.book keeping the sheet's turn; Not this show / Pass with points; lapses as a pass;
  1 Jan season_reset from LadderSeason.close), scripts/ui/RivalOfferCard.gd (Overview card, Needs row + blocker, Main act
  chain), TestJump._tidy answers Not this show. tests/rival_offer_wire_test.gd.
- LADDERPROBE3 collected (Qwen): no frozen novice in 60 runs; Lucy 43 -> 59 points; ~26% rows at 0 = idle rivals ->
  Region._inactive: no bout in 52 weeks = off the table (map R8). ladder_season_test checks it.
- C433 (owner: Ana's mat plan "too confusing"): MatPlanPanel says what to do, each line one sentence (MatPlanPanel.say),
  the scoreboard explains its calls; still ops/previews/s517/matplan_plain_words.png on the review board.

## DONE IN S517 (tests green, see the commit; WHAT_TO_TRY S517 at the top)
- LADDERPROBE1 collected (Qwen #370: tools/ladder_probe.gd + docs/LADDERPROBE1_RESULT.md); it ran before the clock, so
  rerun on main: docs/LADDERPROBE2_RESULT.md - with the clock our novices drained to ~1 point: in 23 of 30 runs every name
  on her sheet had passed 10 bouts (no legal name, never another bout).
- FIX scripts/state/Newcomers.gd: a novice with nobody legal gets a newcomer novice on her sheet (0-2 bouts, a club of the
  division, a news line; at most 3 a sheet, the oldest graduated leaves the sheet). Every sheet reader (Bouts, AskFlow,
  HomeBout, PullOutWire) goes through Newcomers.sheet. tests/newcomers_test.gd.
- Region._free_week (map R8): the idle clock waits while our boxer is booked, injured or has nobody legal in reach.
- LADDERWIRE stage 3 season: scripts/state/LadderSeason.gd - 1 Jan keeps each division's final table (c.seasons, saved)
  and writes "Season N ends: <first> finishes Kth of M ... on P ladder points (top: ...)" into Records (Honours).
  World > Rankings shows "LAST SEASON (2026): 1 ... 54 · 2 ... · Lucy 5th, 40" under each amateur table
  (LadderSeason.last_line). tests/ladder_season_test.gd.
- Seen defect: home_bout_test red since S513 - a boxer 6 kg over could be re-matched on the night. PullOutWire.weigh_miss:
  no spare past the class gap (WeighGap.gap_kg).
- golden_path: a newcomer's legal offer for the other boxer is a NEEDS YOU blocker before Lucy's debut: the test answers it.
- Club week v11 saved (Dola SQ220 -> DESIGN_CLUBWEEK1_V11.md); critics queued. CRITIC_PACK carries the mat plan number.
- Trap: a background test batch keeps running while you edit; files edited mid-run may or may not be in it - rerun.

## DONE IN S516 (on main, exported, WHAT_TO_TRY S516 at the top)
- MATRECEIPT1 collected (Goose #367, MatReceipt.gd). Wired: the open's result YOUR PLAN, LINE BY LINE (OpenNight._done);
  every open adds to her season book (Grapplers._close -> f["mat_book"]); the Playbook plan rows show "this season N of M:
  works / fails / too early" (MatPlanPanel). mat_book_test new.
- LADDERWIRE stage 2: one order rule (RankLine._before: points, then net wins, wins, rating; a row without "rep" reads at
  LadderPoints.seed_of, so old tables keep their order); Region.before delegates; BoutRead.rank_move moves both sides'
  points. World > Rankings: Points column on the amateur table (WorldLadder 499 -> 473: lookups in WorldLadderPick.gd).
  Ask card (AskLadder.gd): points + price in points; for step up / a picked name: OUT OF REACH (needs N) and Leans Yes/No
  with the biggest reason (LadderRep.yes_score; inputs the game lacks - protecting, hot streak - stay neutral). A No or
  out-of-reach ask is refused with the reason (AskFlow.book -> f["ask_no"], BoutActs toast); the sheet's name is never
  refused. ladder_table_test new; ask_wire_test picks a Yes card and seeds the 4-3 boxer's points.
- Stage 3 part 1: the idle clock (LadderPoints.clock_tick every Monday from Region.day_events; settle(..., day) sets
  clock_from unless the bout was 20+ below); news line for our boxers.
- Stills: tools/ladder_still.gd (TEST CLUB, hidden desktop) -> ops/previews/s516, on the review board.
- Critics: guard damage v2 Dola 8/8/8, Goose 5/6/5; club week v10 Dola 7/8/8, Goose 6/7/6 -> revise SQ219/SQ220.
- Traps: CI's full list runs past the 32-min timeout (cancelled, no results) - for a branch check push a CI-only commit
  that cuts run_tests.sh's TESTS list; run_tests prints PASS/FAIL only at the end. Local Godot goes through godot_slot.
  The PC was RED on memory (a game, 7 GB) for the first hour: no local Godot then.

## DONE IN S515 (on main, exported twice, WHAT_TO_TRY S515 + S515b at the top)
- FAVOURPROBE1 collected; LateAskWire.ready_for needs a legal experience match.
- FAVOURS2 (docs/FAVOURS2_RESULT.md): every 2nd bout a club boxes on a host's show earns a favour (FightWeekEvents.card_bout,
  Career.host_bouts); fight week chip + result page. 0.24 -> 0.77 a host for a club that spends every favour at once.
- MATWALK1: BjjBeat._choose takes MatLines.pick (frame first / set it up work the hands to 2 stacks, sit tight works),
  the scoreboard sets pace from the score each beat, a line is read like a plan step. No lines = today's walk, seed for seed.
- MATPLANUI1: scripts/ui/MatPlanPanel.gd under Ana's A-game (lines, timing, chance, chips, drop / add, scoreboard, Coach's
  draft = the white hand of 3 with one finish); MatTreeInfo.set_plan keeps lines on a new route; OpenNight says YOUR PLAN.
- COACHROLES1 (Qwen) + LADDERREP1 (Goose) collected; coach hire cards say "Money lasts N -> M weeks" (scripts/ui/HireRunway.gd);
  People page back under 110 words (coach_areas was red since S510 and not in the nightly list - added).
- LADDERWIRE1 stage 1: ladder points on every amateur bout, result page line.
- Nightly list (tools/run_tests.sh) now runs ladder_rep, ladder_points, coach_roles, mat_plan_walk, mat_plan_ui, coach_areas.

## DONE IN S514 (all on main, exported, WHAT_TO_TRY S514 at the top)
- STOPWORD1 collected (Qwen, 960 bouts: gap < 0 unlikely, 0-8 possible, 8+ a real risk); AskFlow.gap_of feeds both the
  teaching word and StopWord; every Ask card says "Getting stopped: <word>." (ask_wire 2g, stop_word_test).
- FIGHTWEEK3 favours earned: scripts/state/LateAskWire.gd + scripts/ui/LateAskCard.gd. On the Monday 5 days before a
  show, the host rolls once (1 in 6); a ready boxer (Ask door open ignoring a waiting sheet offer, inside the club-show
  weight gap with the sheet's boxer, none of ours already on that show) gets the ask: red need HOST ASKS, a card on the
  Overview. Yes = short-notice fight week at that host, x2 reputation on a win, +1 favour (cap 3), never rolled for a
  pull-out; no = nothing. tests/late_ask_test.gd (14 checks); still tools/late_ask_still.gd.
- Win band on the fight week's ON FIGHT NIGHT: FightWeekPlan.band (BoutRead.band on a copy with the plan's r1 edge,
  partner edge, tank) - Rest up reads better than Train through (fight_week_screen 2b). Still checked: THE WEIGHT renders.
- FIX: Ask for a bout greyed dates "Weight at risk" on the class-limit forecast though club shows box inside the
  walking-weight gap (Bouts.weigh): AskFlow.in_gap keeps such a date askable and says so (ask_wire 2h).
- R58 approach card still checked (reads right).

## METHOD (operator S510, CLAUDE.md item 8 - quote this in your first message)
Fight animation: STOP PATCHING. 14 rounds of correction layers scored 4.5-5/10 while the Undisputed / Boxing Manager /
Blood & Canvas studies said the method is wrong (punches recorded per distance, captured reactions, motion matching /
inertial blending - no layers bending arms and heads). Next: FIGHTPLAYER2 - the baseline diagnosis
(ops/research/FIGHTPLAYER2_BASELINE_S510.md, part 3), the full scope (ops/research/FIGHTPLAYER2_SCOPE_S510.md), two fresh
critics judge the scope (owner: "have that judged"; 7+), then build it phase by phase. HIS APPROVAL IS STANDING: "i approve
anything that will fix animations do not post stupid questions that i do not understand" - never ask him about animation
work; report the critics' scores and what changed in plain words (money for a mocap pack is still his explicit yes).
No new correction layer in scripts/fight3d until v2 is built. No new animation purchase until the baseline says the clips
themselves are the limit (owner: "why should i buy more animations if the ones we have right now are so bad").

## First
- Q-267 answered "Only when I'm not playing": before any film, list windowed processes (Get-Process with a MainWindowTitle);
  a game window (ArcheAgeChronicles, FightCamp, Steam games) = no film. Q-268 "Yes, medium": effortLevel is medium.
- He sent a usage-cost video (Fable 5.2 cheap). Done: `.claude/agents/Explore.md` puts search helpers on Haiku. The video's
  other rule for us: do not split small jobs across helpers (briefing + re-reading costs more than doing it).

## Traps seen this session
- S514: a club show matches WALKING weights within a gap (WeighGap, Bouts.weigh), not the class limit - any "will she make
  weight" gate for a club show reads AskFlow.in_gap, not Sim.weigh_forecast alone (that one is for camps / titles).
- S514: a Bash heredoc that writes a .gd and then starts Godot is blocked whole by rule_guard: write the file with the
  Write tool, start Godot through `python ops/Tools/godot_slot.py run --who S<n> -- ...`.
- EVERY in-session Godot test takes `--fixed-fps 60` (tools/run_tests.sh passes it, S470). Without it hit_carry read 29-33
  and join_return 2-4 run to run, and older debt numbers (block_meet 3) were measured that way.
- A capped trunk cannot give back the body's own slide: a head that rides the root/hips needs the slide fixed, not PopCap.
- `cd` into E:/FightCamp/tmp moved the session folder: use absolute paths.
- watch-video skill: local faster-whisper fails on this PyAV (`metadata_errors`); feed it numpy from `wave` instead.

## MAIN LINE STATE (main-line side session, S511, 2026-11-17 ~21:30)
- FIGHTFILM1 slices 1-9 on main. S511 added (d3c340fbc..7e7a21e25): Game plan lines on filed film claims (GamePlanRows
  film_fit/film_tag: "Film 85%" = Works at best, "Film: confirmed", "Cleared - change this line"; FilmNight.sit_of /
  claim_on); own-bout mode scripts/ui/FightAnalysisOwn.gd (result page tab PUNCH BY PUNCH, History > Analysis, corner
  minute "The round so far"; WHAT DECIDED IT + WHAT THE OTHER CORNER WILL SEE with Fix it on the pads = f.habit_fix);
  AfterFight.keep_tape keeps the last 20 tapes on c.results; scripts/ui/FightAnalysisTape.gd = film night "Write the
  answer" (Game plan over the film) + Fight prep "Watch the tape" (no checks). TapeRoom.gd + tape_room_test REMOVED.
  tests/film_night_test.gd 51 ok (in run_tests list). Stills: tools/fight_analysis_still.gd (hidden desktop) - looked
  right; the film slot is still an empty box (no 3D film in the page yet).
  LEFT: the 3D film in the page's FilmSlot (TapeFilm), the 3D CornerOverlay line (fight3d = animation session), Settings
  fight-log On/Off, "walks the other down" divider words read oddly on your own bout.
- ASKFIGHT1 NOT built on purpose: map v4 critics 5/6 and the owner's 7+ rule. Round 4 queued S511 to Kalli/John/Dola
  (SQ206-208, brief ops/research/ASKFIGHT_CRITIC_S511_BRIEF.md: does the fight week make the date a real trade?). Read the
  answers in `start` (SEAT ANSWERS); build only at 7+ (AskBout/FightLearn are ready, map section 6 lists the menus).
- IN FLIGHT: Qwen ASKPROBE4 (branch qwen/askprobe4, near vs far show with the fight week; collect its PR by diff - it
  only adds tools/ask_probe4.gd + docs/ASKPROBE4_RESULT.md), then MORNINGSPROBE1 queued (dispatch_queue). Ask critics
  SQ206-208 land as ops/research/ASKFIGHT_CRITIC_S511_{KALLI,JOHN,DOLA}.md. With both: map v5, then wire AskBout +
  FightLearn only at 7+ (menus: map section 6; golden path: map 7 step 4).
- CLUB WEEK: S511 wired the WEAK SPOT line (Training > MORNINGS, CoachedMornings.weak_line, training_k_test). v1 (S485 build plan) is wired - day job, loyalty bar/leaving/pro share, film seats. Left and GATED: the second
  class night (ClubDeal.class_cash needs COACHFIT1's coach time; COACHFIT1 critics 6/5, 6/6) and coached mornings
  (CoachedMornings: CHECK 7 with COACHFIT1 + a drawn page). ClubDeal's pad dealer is superseded (Q-242/Q-260 never short).
- Unwired audit (S511): AskBout, FightLearn, ClubDeal, CoachFit, CoachMarket, CoachedMornings, MatPrice, BoutSheet,
  Knowledge, TapeClips (old Tape Room), TrainingWeek; the rest are rulers/tools (BalanceHarness, GroundRules, HeadEase,
  HeadSplit, HookPast, PunchSnap, StandOff). Script: python <scratch>/unwired.py logic = a module no other script names.
- SPLIT500B collected (Qwen PR 352, diff applied, PR closed). CI FIX: run_tests.sh used /e/FightCamp/tmp on the Linux
  runner - every CI test failed since 8d0e67650; now only where /e exists. grapple_fix_test fails 18 on main (pre-existing,
  not in the run list): look at it.
- C: TRAP: every Godot run takes --log-file E:/FightCamp/tmp/<run>.log; a `cd` in Bash moves the session folder.

## S512 SIDE SESSION (Opus, beside animation part 3, 2026-11-17 ~21:00) - main line only
- Committed Dola's Ask-for-a-fight round 4 (ops/research/ASKFIGHT_CRITIC_S511_DOLA.md): depth 7 / play 7. Its #1 for 10/10:
  show the next TWO club shows side by side (soonest = fight week only, next = full prep), each with its own cards; say
  why a card is absent; per-date prep checkmarks (film evening, spars, week-before). Kalli SQ206 / John SQ207 still queued:
  build AskBout + FightLearn at a second 7+.
- ASKPROBE4 (Qwen, E:/FightCamp/wt/LEAN_ASKPROBE4) was still writing at 21:00: a count=2 smoke run already says YES (far
  +7.5 win, +5.5 plan mastery, +6.3 injury). Its grep: NOT WIRED - FightWeek.spar_night.costs_pad_night (week-before pad
  night), SPAR_LATE_INJURY_X / SPAR_LATE_CUT_STOP, FightWeek.banked mastery units -> INTEGRATE1 work. Collect by diff.
- Palette (ONELOOK1, Q-251): tools/palette_sweep.py --training swept the Training tab, drill cards and scorecard; guard
  baseline 73 -> 29. Left on purpose: WeekCards TILE/SPARE (one colour per ability), fight3d (animation session).
- FightAnalysisList.GAME_WORDS now subject-free ("pressing forward"...). Settings "Show the fight log" waits for the live
  log panel (map card "Live fight log", Grok Dev) - the settings page offers only options that work.
- tests/grapple_fix_test.gd failing 18 is the S399 GRAPPLEFIX1 TARGET test (red on purpose, not in the run list, BJJ
  parked) - not a regression.
- Not exported: the .exe does not carry the S512 UI changes yet (the animation session's next export picks them up).
- FIGHTPLAYER2 HAND-OFF (the S510 supervisor, closing, to S512): part 3 (local_b19ae020) does ONLY the baseline ->
  ops/research/FIGHTPLAYER2_BASELINE_S510.md, then stops. Everything after it (scope critics, the build) is the main line's.
  S512 queued the scope critics on the free seats: SQ209 Dola, SQ210 John, brief
  ops/research/FIGHTPLAYER2_CRITIC_S512_BRIEF.md -> ..._S512_DOLA.md / _JOHN.md. Next: read the baseline against the
  scope's table 1d, read both critics (7+ = build phase 1, the clip census; under 7 = revise the scope, another round),
  build on Fable (the owner's "Keep Fable" for animation) in scripts/fight3d/v2/ behind `-- fightplayer2`.
- BASELINE LANDED (027098b04, part 3 stopped): raw 4.5/4.5 = placement-only 4.5/4.5 = full 4.5/4.5 (six blind critics).
  Table 1d verdict: the layers buy nothing -> the scope AS WRITTEN; retargeting keeps poses -> no phase 1b, except restore
  the jab's cut tail (bake 0.84 of 1.07 s) in phase 1; the travel lost to FightClips.hold_root_xz is phase 3's root motion;
  the feet stack squashes the bought upright stance (knees 146-151 -> 125-135) - the v2 foot lock must keep the clip's knee.
  The critic brief now carries the baseline (SQ209/210 not sent yet). Part 3's round-15 edits stay PARKED
  (E:/FightCamp/tmp/fightweek/s512/r15_parked.patch): they are new correction layers, which the METHOD forbids.
- GROK BOTS OUT OF QUOTA (owner S512: "use arena or ludo or goose grokbots are out of quota"): Kalli/John/Maria queue
  items PARKED in seat_queue.json (SQ202-207, SQ210). The second critics went to GOOSE instead: issue 353 FP2CRITIC1 ->
  ops/research/FIGHTPLAYER2_CRITIC_S512_GOOSE.md, issue 354 ASKCRITIC5 -> ops/research/ASKFIGHT_CRITIC_S511_GOOSE.md
  (each a PR adding one file; collect by diff). Dola (free) still answers: SQ209 FIGHTPLAYER2 critic sent 21:10.
  Owner "assign them to others": Kalli's revisions -> Dola SQ211 (ladder v6 -> DESIGN_LADDER1_V6_DOLA.md), SQ212 (coach
  spec r6 -> DESIGN_COACHSPEC1_R6_DOLA.md); John's guard damage critic -> Goose issue 355 (DESIGN_GUARDDMG1_V1_CRITIC_GOOSE.md).
- LEAN CI (owner "Yes, switch it", S512): November was at ~28,100 of 50,000 Actions minutes on the 17th (pace ~49,500).
  ci.yml now runs tools/ci_pick.py: ONLY changed files (owner: "i do not want checks on things that were not change") -
  changed tests (+ the brief's own RED_TEST on a PR) and a parse check of changed scripts; anything else passes at once; full suite = the PC's 05:00 run or `gh workflow run ci.yml
  -f full=true`. There is NO nightly suite on GitHub (no workflow has a schedule).
- ASK FOR A FIGHT BUILT (S512, d1fa334c3; owner "Yes, build it"): AskDates (Goose ASKDATES1, collected by diff), AskFlow,
  AskPanel, BoutFinish (host gate, every amateur bout teaches), ResultPage (WHAT IT TAUGHT), Main.nav keeps "ask";
  tests/ask_wire_test.gd + ask_dates_test in run_tests.sh. Exported. Left: Home DO NEXT, the stoppage-risk word.
- RAM: ~10 finished sessions sit idle with Remote Control on (~750 MB each, S491 note); watchdog AMBER on memory.

## ANIMATION LOOP STATE (the animation session's own section; S525 block added 2026-11-19 ~11:30 by the animation session on Fable; the blocks under it are older)
Owner: "i want animations fixed (at least 7/10)" = two fresh blind critics (coach + animator) both 7.0+ on one film. You are
the ONLY animation session; you own `scripts/fight3d` (v2 in `scripts/fight3d/v2/`) and this section. Quote the METHOD line.
WHERE WE ARE: FIGHTPLAYER2 (the rebuild, `ops/research/FIGHTPLAYER2_SCOPE_S510.md`, section 8 = the critics' changes).
The v2 player EXISTS and plays the real bout behind `-- fightplayer2`. FIRST BLIND ROUND: coach 3.5, animator 3.0 -
BELOW the old player (see FIRST FILM below). When this section was first written it had not been filmed: the owner's
game (ArcheAge) was open the whole session and films run only when no game window is open (Q-267). r14 = 4.5 / 4.5 is the
control arm; the shipped player is untouched without the switch.
- S527 (2026-11-19 ~15:50, the same animation session, context near its cap). READ THIS FIRST, it is the newest:
  * THE OWNER ON FILM 5 (comment C434 at 82.2 s, the film's last frame, STILL OPEN - not fixed, do not let a commit
    message cite the id or the board closes it): "why the fighter do not walk ?". He is right, and it is the same
    thing as both critics' items 1 and 2: v2 plays NO step take. When the plan moves a boxer (step in, step out,
    the ease to rest) his body is moved while the guard take plays and FootPlant drags each foot after it (the end
    of film 5: blue backs off 0.6 m in 0.7 s on the guard pose); and the plan only sets the DISTANCE between the
    two men, never a place in the ring, so the pair stays on one spot (blue's back on one corner post from ex2 to
    ex5). Answered on the board in plain words (`2026-11-19_1545_answer_to_your_comment...`, "not fixed yet").
  * FIRST TRY, MEASURED WORSE, OFF (`-- fp2steps` turns it on; Player2._step): a planned step plays the owned step
    take (advance / retreat, in-place cycles, stride 1.74 m/s at 1x) at the rate of the ground the plan covers.
    Headless, seed 7 (`s525/m`): support-foot slip 7.0 / 7.5 -> 20.6 / 27.9 m, knee jerks 21-42 -> 27-59.
    Why: FootPlant still owns the feet and fights the take's own steps; the step takes are another actor's stance
    (knees 122 deg, the guard 141-150); a 0.2 s ramp is a fifth of a step cycle.
    TO FINISH IT (this is NEXT item 1 now, before the waits): (a) hand the feet to the take while a step plays
    (FootPlant off for that boxer, re-planted where the feet land); (b) plan WHOLE steps - ChoreoGap segments of
    0.4-0.5 s a step, lead foot first going in, rear foot first going out, the step in still ending as the glove
    lands; (c) start the cycle on the right foot (find each take's foot-down times: a census column); (d) then a
    place in the ring: the pair's middle walks (off the ropes, toward the centre) between exchanges, the side-on
    turn becomes circling steps; (e) film it, look at the feet, then a round. The Rokoko step takes
    (`rk_step_in`, `rk_step_back`, `rk_loc_*` in RkClips) are captured with their own travel: try them before
    the in-place ones (v2 already moves a body along a take's own path: RootPath).
- S526b (2026-11-19 ~14:15, the same animation session; film 5):
  * FIFTH FILM + BLIND ROUND (`E:/FightCamp/tmp/fightweek/v2r9/`, film = commit fc9c17ecc, seed 7, 75 s):
    coach 5.0, animator 4.5. Film 4 was 4.5 / 4.5, film 3 4.0 / 4.5, film 2 3.5 / 3.5; the old player r14
    4.5 / 4.5. v2 is ABOVE the old player on the coach's seat for the first time. THE GATE (7 + 7) IS NOT MET.
    | critic | whole | punches | defence + reactions | footwork + stance | transitions | waiting |
    |---|---|---|---|---|---|---|
    | coach | 5.0 | 5.5 | 5.0 | 4.0 | 5.0 | 4.0 |
    | animator | 4.5 | 5.5 | 4.5 | 3.0 | 4.5 | 3.5 |
    Defence + reactions moved most (3 / 3.5 -> 5.0 / 4.5: the three S526 items below + two defence sheet sets);
    footwork is now the lowest area on both seats. Reviews `v2r9/critic_coach.md`, `critic_animator.md`, pictures
    `critic_*_10.png`; 54 sheets cut by `s525/round.py`; critics on Opus.
    Rulers film 4 -> film 5: the hit head 7.3 -> 14.3 cm at the median (body 8.9 -> 28.1, cross 9.2 -> 17.5, hook
    10.5 -> 19.4, jab 6.3 -> 8.8); arm left out after the contact 3 -> 2 frames, worst 15 -> 8; chest over 70 deg
    off the line 38 / 26 -> 23 / 10 frames; slip 8.1 / 8.0 -> 7.0 / 7.5 m; head jumps 11 -> 16 (the snaps);
    waiting in the guard 62 / 60 -> 76 / 72 % of the round (the arm home hands punches back sooner), longest wait
    4.5 / 4.3 -> 5.1 / 4.3 s. The habit caption under the clock is CONFIRMED on this film (`s525/caption_film.jpg`).
  * BOTH LISTS AFTER FILM 5, most important first (they agree on the first four):
    (1) THE WAIT IS A LIVE FIGHT, WITH RING MOVEMENT (both, item 1): each man does one thing every 0.5-1.2 s (a head
    move 8-12 cm off the line, a step in and out, a side step 20-30 cm, a pivot, a feint, a 10 cm dip); never over
    1-1.5 s with feet and head still (72-76 % of the round reads frozen: ex3 #49-#75, wait2 #1-#48); the man on
    the ropes circles out in 3-5 steps, the other cuts him off; blue's back is on the same corner post from ex2
    to ex5; both reset to the centre after a big shot.
    (2) FEET (both, item 2): planted feet pinned, real steps, a 2-4 cm bounce every 0.4-0.6 s; slip 7-7.5 m now,
    under 1-1.5 m asked; over a third of it in the guard take (measured: see the feet block below).
    (3) THE FREE GLOVE STAYS HOME (coach 3, animator 5): within 10-15 cm of the chin during every punch; it swings
    wide or behind at ex1 #54-#56, ex5 #53-#56, def1 #25, def2 #42 and winds up at the hip before the uppercut
    (ex4 #9-#12). The punching arm: back in the guard within 8 frames hit or miss (the missed jab at def1
    #14-#21 stays out 8).
    (4) HITS MOVE THE MAN, FEET INCLUDED, AND NEVER INTO THE OTHER MAN (coach 4 + 5, animator 3): a cross a 15-25 cm
    step back (3 cm now), the feet stop 6-8 frames on a jab; a body shot folds to the SIDE - after it the heads
    and arms pass through each other (ex3 #17-#24, def2 #45-#52: he folds onto the puncher, who is ducked at his
    belt); no head over 12-15 cm in a frame inside a clip (16 now, worst 21.8: the cross and gut-shot snaps).
    (5) CLOSE RANGE AND COMBINATIONS (coach 5, animator 4): the body shot as a 20-25 cm drop of the hips, not the
    take's near-metre lunge; inside 0.6 m short punches or a tie-up and a push off in 1-2 s, no glove-touching
    standoff (ex5 #25-#34); the next punch of a combination starts 2-4 frames before the last arm is home, half
    the exchanges with two or more punches.
    Also: slips / rolls / parries in a third of the exchanges (they were shown two and scored it up; more), the
    waits repeat (red's one fidget twice in 20 s), knee and hip twitching, ropes that give.
  * AFTER THE FILM, NOT FILMED: a dodge started late keeps its sidestep (the hip travel its take made before the
    start point; on film 5 the jab passed at head height at def1 #14-#20) - the last S526 commit on Player2.
  * NEXT, in order: (1) the wait's second half: half steps on the edge of range, a circle step, the other man's
    answer, off the ropes to the centre (list item 1; ChoreoWait + ChoreoGap, planned like the rest);
    (2) feet for the plan's own moves (item 2; FootPlant stays, see the feet block); (3) the free glove (item 3:
    which takes drop it - a census flag `free hand off the chin` per punch take, then pass over them like the
    back-turning ones); (4) the body shot's fold onto the puncher (item 4: pick the gut-shot take by its head
    direction against where the puncher's head is, or plan the body shot from further out); (5) film + round.
    Each round this session moved the item built by +0.5 to +2; the gate is 7 + 7.
- S526 (2026-11-19 ~13:30, the same animation session; built HEADLESS while the owner's game was open, then filmed
  and judged as film 5 above). Commits 541bf1ea5, c2c61cbfa, 4f4cb2a59:
  * REACTIONS SIZED TO THE PUNCH (541bf1ea5; film-4 list item 1). Cause found: a reaction was started at the head's
    furthest point WITH the body's travel - on a gut shot the end of the stagger, 0.5-0.8 s after the fold, on a
    combination take the third hit - so the snap itself never played. clip_db now carries `head_rel_s` (the head's
    first peak against the hips; `tools/clip_census.gd`, the table otherwise unchanged) and a reaction starts so
    that peak is on the blow. `ChoreoReact` picks the take whose own head travel (`head_rel_m`) is nearest what the
    punch should do (`ChoreoRules.REACT_HEAD_M`: jab 0.15, cross 0.24, hooks 0.24, uppercuts 0.18, body 0.30 m; a
    big shot x1.4). A take dropped ONLY for a face tipped up to 30 deg plays for a cross / hook / uppercut
    (`pro_hit_by_cross_v3`, the one owned reaction that is a cross landing flush). A head reaction hands back to
    the guard 0.45 s after its peak; `pro_hit_by_jab_v1` (peaks 9 frames late) plays only when nothing else fits.
    Headless, seed 7 (`s525/h`), against film 4: the hit head 7.3 -> 14.4 cm at the median; body 8.9 -> 28.1 cm
    (33 in the ring), cross 9.2 -> 17.3 (the flush take 25), hook 10.5 -> 19.4, jab 6.3 -> 8.7 (12 in the ring);
    reactions peaking later than 4 frames 1 -> 0. Head jumps 11 -> 16: the bigger snaps themselves.
  * DEFENCE (c2c61cbfa; list item 2). TWO findings. (a) THE CRITICS WERE NEVER SHOWN ONE: the five sheet sets are
    cut round the landed punches and none contains a defence (8 play in 75 s: film s 18.6, 22.4, 23.3, 30.6, 40.1,
    47.3, 47.9, 68.6). On film 4's own frames the duck under the jab at 23.0-23.2 s reads (`s525/look_def/`).
    THE NEXT BRIEFS MUST ADD TWO DEFENCE SETS (e.g. 22.4-24.0 s and 46.8-48.8 s; check the times on the new film).
    (b) Timing: the dodge / weave takes take 0.43-0.93 s to their furthest point and were started from their first
    frame, so the man ducked before the punch was thrown. A defence now starts `DEF_LEAD_S` 0.33 s before the
    contact, part-way into its take, its head still furthest off the line on the blow (test R8).
  * THE ARM COMES HOME (4f4cb2a59; list item 3). The bought takes bring the hand back 0.3-0.5 s after the contact
    (hooks 0.6-1.4 s: clip_db `home_s` is a DURATION after the contact). A punch take is handed to the guard 0.07 s
    after its contact (a hook, an uppercut or a body shot 0.14 s) with a 0.22 s join; PunchAim eases its finish
    out on its own clock when the take is cut. Headless (`s525/j`): arm left out after the contact 3 -> 2 frames
    at the median, 15 -> 8 at worst; frames with the chest over 70 deg off the line to him 38 / 26 -> 23 / 10;
    all 15 landed gloves unchanged (2-18 cm); slip 7.9 / 7.5 -> 7.0 / 7.5 m. Watch on film: does a punch cut this
    soon still show its weight (the owner's C432: "the shoulder movement needs to generate the power")?
  * FEET, MEASURED FOR THE NEXT ITEM (no code): with the arm home the slip sits mostly in the GUARD take (2.5-2.9 of
    ~7 m a boxer, `s525/j/rulers_raw.txt`): about half while the plan moves the body (creep, step out, the ease to
    rest, the breath, the side-on turn), a third in the 0.3 s after a clip change (the join into the guard), the
    rest standing. `fp2carry` (FootCarry) is WORSE with today's code: 9.6 / 10.6 m against 7.0 / 7.5, knee jerks
    21-42 -> 37-54: keep FootPlant, plan the feet's steps for the plan's own moves instead.
    Tests: choreographer_test R15 (reactions sized, started at the snap, the arm home), fc9c17ecc.
  * (DONE: filmed and judged as film 5, see S526b.) OLD NEXT: (1) FILM the moment no game window is listed (this film carries SEVEN unfilmed commits: e56c96814,
    6a4f9ffea, 541bf1ea5, c2c61cbfa, 4f4cb2a59 and the main session's caption dfb6ee2c1) and LOOK: the spins, the
    cross reaction with the face tipped up, the fold, the arm home, the caption under the clock; (2) cut the
    sheets WITH two defence sets, briefs from `s525/BRIEF_critic_*.tmpl` (they carry the press-flash line; add the
    new sets to the list), blind round on Opus; (3) then feet (list item 4) and the waits' second half (item 5).
- S525b (2026-11-19 ~12:00, the same session's second stage; film 4):
  * FOURTH FILM + BLIND ROUND (`E:/FightCamp/tmp/fightweek/v2r7/`, film = commit 06f2dc3a9, seed 7, 75 s):
    coach 4.5, animator 4.5. Film 3 was 4.0 / 4.5, film 2 3.5 / 3.5, the old player r14 4.5 / 4.5: v2 now EQUALS
    the old player. THE GATE (7 + 7) IS NOT MET; v2 stays behind its switch.
    | critic | whole | punches | defence + reactions | footwork + stance | transitions | waiting |
    |---|---|---|---|---|---|---|
    | coach | 4.5 | 5.5 | 3 | 4 | 4.5 | 4.5 |
    | animator | 4.5 | 5 | 3.5 | 3.5 | 4.5 | 3.5 |
    Waiting moved most (coach 2.5 -> 4.5, animator 3 -> 3.5); reactions did not (3 / 3.5). Reviews
    `v2r7/critic_coach.md` (10 items), `critic_animator.md`, pictures `critic_*_10.png`; critics on Opus. The animator
    wrote "they stand 2 m apart" (the ruler: heads 1.45 m, hips 1.42-1.55) and "14-15 m of slide" (the `slide by
    clip` lines of rulers_raw; the support-foot slip is 8.1 / 8.0 m): check a number against the ruler before building.
  * WHAT WAS IN THAT FILM beyond film 3: the waits (af6b11d7b); reactions that give their ground (aa159ef33: the
    hip travel a reaction's take had made before the point it is started from is given on the blow, every reaction
    plays with its own travel, inside a burst too when the next punch can follow, takes under 11 cm / 21 cm of head
    travel passed over); no "back to the other man" take while its family owns another, a defence waits for his own
    punch, he comes up before he counters (df140cd07); hits.json read after the frame's pose (06f2dc3a9).
    Rulers film 3 -> film 4: longest wait 5.97 / 5.7 -> 4.5 / 4.3 s; paws and feints 1 / 0 / 0 / 2 -> 7 / 6 / 7 / 5;
    worst head jump 26.6 -> 17.1 cm (11 jumps both times); a cross: the hit man steps back 2.9 -> 7.0 cm, his head
    travels 14.6 -> 17.8 cm in the ring; support-foot slip 6.6 / 6.3 -> 8.1 / 8.0 m (the price of the movement).
  * A RULER WAS WRONG FOR THREE FILMS: hits.json `miss` read the glove one frame BEFORE it lands (the contact fires
    before that frame's pose is on the skeleton): "10-28 cm short", which both critics of film 3 quoted. Read after
    the pose: 2-13 cm, median 4-5 (the 60 Hz test said 4 cm all along). Nothing to build for "the glove ends short".
  * AFTER THE FILM, NOT FILMED (the owner started a game, Q-267): e56c96814 (a hook thrown second in a combination
    gets 0.26 s of wind, not 0.12) and 6a4f9ffea (it joins over 0.24 s): headless, the fastest chest turn in a frame
    50 / 36 -> 41 / 28 deg, player2_test head jumps outside a contact 4 -> 0. Ruler: `s525/range.py` prints it.
  * BOTH LISTS AFTER FILM 4, most important first (they agree on the first four):
    (1) REACTIONS SIZED, the whole body (both, item 1): jab 10-12 cm, cross 20-25 cm + a 15-20 deg turn + a
    15-25 cm step back, hook 25-30 cm sideways + 30-40 deg, body a 30-50 cm fold + a step back; keep the 2-3
    frame peak, hold 2-4 frames, back over 8-12; a flush shot adds a stagger step. MEASURED LIMIT: against his own
    hips the head moves 7.3 cm at the median whatever the plan does - that is the owned takes (light 8-10 cm,
    medium 11-17 cm of head from hips; the heavy ones are staggers of 38-59 cm, two of them dropped for a face
    tipped up 29 deg). What is left inside the method: play a size up (a medium take for a jab, a heavy one for a
    clean cross), start the reaction further back in its take (REACT_PEAK_S) so more of it plays, or better takes
    (the owner's mocap buy is his end-of-November call: do not ask, report this limit).
    (2) DEFENCE THAT SHOWS (both, item 2): one punch in three meets a slip 15-20 cm off the line, a roll 25-30 cm
    under a hook, a pull back 15 cm or a glove catch, started 4-6 frames BEFORE the contact. Both saw none in 75 s,
    though the plan plays dodges and weaves: look at why they do not read (timed to the head's peak 0.4-0.9 s after
    their start, started early and far out; a miss is planned 15-30 cm short, so nothing has to be dodged).
    (3) THE ARM COMES HOME, NO BACK SHOWN (coach 3, animator 3 + 5): the glove leaves the target in 1-2 frames, at
    the chin by frame 6 (it stays out 8-15 frames: ex1 #13-#22, #61-#68, ex5 #17-#24); the shoulder turn after a
    rear hand capped at 45-60 deg (blue's back to the camera at ex1 #57-#68, ex5 #37-#43, #56-#66: the cross takes'
    own follow-through, pelvis 28-43 deg, the trunk 41-70).
    (4) FEET (both, item 4): planted feet pinned, every move over 8 cm a real step of 10-30 cm in 6-8 frames, feet
    never cross (ex4 #19-#20), blue's lean-back waiting shape gone (hips under the shoulders, chin down).
    (5) WAITING THAT HUNTS (coach 7, animator 5): something changes every 10-20 frames (still 1-1.3 s freezes at
    ex3 #37-#75, ex4 #49-#75), circling, a feint every 2-3 s, a half step in and out.
    Also: combinations as drilled with an exit at 45 deg, inside work or a clinch under 0.7 m (no owned take), the
    hit man answers back in half the exchanges, and - not animation - the habit caption covers the boxers' heads
    for seconds (coach: bottom third, 1.5 s): told to the main session.
  * NEXT, in order: (1) film e56c96814 + 6a4f9ffea when no game is open and LOOK (the spin at 62 s and 23.3 s). ON
    THAT FILM ALSO CHECK THE HABIT CAPTION: the main session moved it to the bottom third and to 1.5 s (FightHud.gd
    anchors y 1, offsets -170..-112; FightView._say takes secs; ExchangeBeats' habit beat) and asked the animation
    session to confirm it clears the heads AND the lower HUD on film (it shows at about 61.9 s, seed 7: ex5), and to
    move it if it collides. No film was possible (the owner in ArcheAge, the watchdog RED on memory), so both boxes
    were drawn on a 1920x1080 frame of film 4 (`E:/FightCamp/tmp/fightweek/s525/caption_check.jpg`): at -170..-112
    the box (y 910-968) sits ON the lower HUD (AIM, NEXT EXCHANGE, the counter chip, LANDED; the HUD starts at y ~905,
    the boots end at ~880: no free band at the bottom). Told the main session, with two free places (under the
    clock, y 172-220, clock width; or inside the NEXT EXCHANGE box). IT CHOSE UNDER THE CLOCK: offsets (-320, 172,
    320, 220), 22 px, 1.5 s. On the same frame that box is clear (`s525/caption_check2.jpg`: off both stat blocks,
    ~80 px above the heads); a caption longer than ~63 characters wraps past the 48 px box. Confirm it on film;
    (2) reactions a size up + more of the take (list item 1; measure `head in the ring` and the head against the
    hips per kind before and after); (3) defence that shows (item 2: start it on the punch's start, plan the punch
    at full reach when a defence is drawn - that is what `def != ""` already does - and check the sheets);
    (4) the arm home (item 3: `home_s` per take is in clip_db; hand control back and start the guard join at it);
    (5) the waits' second half (half steps on the edge of range, the answer, circling); then a blind round.
    The gate is 7 + 7. Each round so far: +0.5 to +1 on the item built.
- S525 (2026-11-19, commits 5147163fd range + af6b11d7b waits). The first stage of the same session (film 3):
  * THIRD FILM + BLIND ROUND (`E:/FightCamp/tmp/fightweek/v2r3/`, film = commit 5147163fd, seed 7, 75 s):
    coach 4.0, animator 4.5 (second v2 film 3.5 / 3.5; first 3.5 / 3.0; the old player r14 4.5 / 4.5).
    THE GATE (7 + 7) IS NOT MET; v2 stays behind its switch. RANGE is off both top-five lists (animator: "the two men
    always face each other at a believable range"; coach: "real steps into range").
    | critic | whole | punches | defence + reactions | footwork + stance | transitions | waiting |
    |---|---|---|---|---|---|---|
    | coach | 4.0 | 4.5 | 3 | 4 | 4 | 2.5 |
    | animator | 4.5 | 5 | 3 | 4 | 4.5 | 3 |
    Reviews `v2r3/critic_coach.md` (11 items), `critic_animator.md` (10 items), pictures `critic_*_10.png`. Critics ran
    on Opus (two Fable helpers died on a 529 overload before writing anything). The animator wrote "46 sheets" (there
    are 41): check a frame reference before building on it. Sheets are now cut at 30 a second (`--fps 30`), as the brief says.
  * WHAT WAS BUILT FOR RANGE (5147163fd): (1) `v2/PairPlace.gd` = the pair's place and facing, split out of Player2
    (478 -> 386 lines with the waits); the pair turns about its middle to stay SIDE-ON to the fixed camera (the old
    player does it in RingPlace, v2 had lost it: by 50 s of the second film the line between them pointed at the lens,
    which is why both critics saw "gloves touching" at a real 1.7 m). (2) The plan keeps a floor on the HEAD distance
    at every landed punch (`ChoreoRules.HEAD_FLOOR_M`: straights 0.80, hooks 0.58, uppercuts 0.60, body 0.58), plans a
    take up to its REACH further out (PunchAim finishes) and passes over a take still short (the 0.64 m cross).
    (3) `ChoreoGap`: rest 1.55 m (heads 1.46), a creep to one step from the punch, a 30 cm step in that ends as the
    glove lands, the puncher steps out 35 cm 0.2 s after a burst's last punch, then both ease to rest; 0.9 s or more
    to the next punch = he steps out to the pocket (1.2 m). (4) The bodies follow the plan at its own speed + 0.7 m/s
    (was a flat 2.4: a stepped punch's travel slid off in two frames).
    Rulers, film 2 -> film 3 (`python E:/FightCamp/tmp/fightweek/s525/range.py <shown.csv>`): heads under 0.5 m
    2.0 -> 0.5 % of frames; the line off side-on to the camera p50 85 -> 3 deg; support-foot slip 9.2 / 7.2 ->
    6.6 / 6.3 m; both waiting: heads 1.61 -> 1.46 m. Still close: the body shot (the one fresh take dives the head
    to his belt, heads 0.36-0.47 m) and the uppercut against a block (0.43 m).
  * BOTH LISTS AFTER FILM 3, most important first (they agree on the first five; the order differs):
    (1) WAITING ALIVE (coach 1, animator 3): every 0.6-1.5 s each man does one thing - a half step in or out
    15-25 cm on the EDGE of range (1.1-1.3 m between chests; both say the wait at 1.45 m threatens nothing), a
    circle step 20-30 cm, a paw 15-35 cm in 6-8 frames, a head or level feint; the other man ANSWERS within 6-10
    frames; a bounce 2-3 cm twice a second, out of step; nothing still over 0.5-1.5 s.
    (2) REACTIONS THAT HURT (animator 1, coach 2): jab head 8-14 cm, cross 18-25 cm + a 15-25 cm step back + a
    15-20 deg turn, hook 20-30 cm sideways + 30-40 deg, body a 30-50 cm fold rising over 8-12 frames; peak at 2-3
    frames (that part holds), back in 8-12; never under 10 cm for a counted hit. Today the median is 7.5 cm.
    (3) THE GLOVE REACHES THE FACE, THEN SNAPS HOME (animator 2, coach 3 + 4): 0-3 cm at the contact (the film reads
    10-28 cm at 30 pictures a second; the 60 Hz test reads 4 cm: check which is true before building), a 1-2 frame
    hold, home in 4-8 frames on the line it went out (worst today 15); the other glove stays on the cheek (it drops
    to the hip at ex2 #13-#18, ex4 #9-#12); no over-the-head hook finish (ex5 #17-#24); a punch that stops on his
    glove is SHOWN as a block.
    (4) NO FACING FLIPS, NO POPS (animator 5 + 10, coach 6 + 7): the trunk never more than 70 deg off the line to
    him, 15 deg a frame at most; blue spins in 1-3 frames and shows his back at ex1 #55-#58 and ex5 #44-#45,
    #55-#72 (62.1 s, `pro_left_hook_ft`: the take's own turn, also 2 of the 11 head jumps); 11 head jumps inside takes.
    (5) FEET (animator 4, coach 7): planted feet pinned, real lifted steps 15-30 cm in 6-10 frames, the rear heel
    turns on a straight; they read 11.5-12 m of planted slide a round off rulers_raw (the slip ruler says 6.6 / 6.3).
    (6) DEFENCE WITH THE HEAD (coach 5, animator 7): one punch in three at a ready man meets a slip / roll / pull /
    catch started 4-6 frames before the contact, a counter within 8 frames after a slip.
    Also both: "the hit flash is drawn over the crowd / by the ring post" (ex1 #43-#46, ex4 #13-#16). CHECKED: it is
    NOT a hit flash and not a v2 bug - it is a press camera flash in the crowd (`CrowdFlashes.gd`, the owner's S447
    ask, 0.7 a second all round). Two blind critics read it as a misplaced hit effect: the next briefs say what the
    white stars are (done in `s525/BRIEF_critic_*.tmpl`); whether a flash should fire so near a punch is the main
    session's / owner's call, not animation. Also: stance, power from the rear heel, combinations that overlap.
  * THE WAITS ARE BUILT, NOT FILMED (af6b11d7b, after the film the critics scored): `v2/ChoreoWait.gd` plans, on each
    man's own clock, a fidget take (or a 1.4-2.4 s window of a long one), a paw or a cross / body / jab feint into
    every quiet stretch, never over his own take or through a landing punch; the holds at rest and at the pocket
    rock in 5-9 cm and back, one man then the other. Headless (`s525/b`): longest wait 5.97 / 5.7 -> 4.5 / 3.5 s,
    paws and feints 1 / 0 / 0 / 2 -> 8 / 4 / 8 / 4, slip 6.6 / 6.3 -> 7.5 / 6.5 m, 0 script errors. `waits: false` in
    the plan's opts = without them. It does NOT yet do what both critics now ask on top: the half steps on the edge
    of range, the circle step, the other man's answer.
  * (SUPERSEDED by the S525b NEXT above; kept for the film commands.) OLD NEXT: (1) film the waits as they are (seed 7, 75 s: `sh E:/FightCamp/tmp/fightweek/s511/film_only.sh
    <out> fightplayer2`, sheets with `--fps 30`, the briefs in `v2r3/BRIEF_critic_*.md`) and LOOK before any round;
    (2) nothing to fix on the "hit flash" (see above); (3) reactions sized (list item 2: start each reaction further back in
    its take or pick the bigger takes by the punch; `REACT_PEAK_S` skips the take's own travel); (4) the facing
    clamp for takes that turn their own root (`pro_left_hook_ft`) + the minimum play time; (5) the waits' second
    half (edge-of-range half steps, the answer); then a blind round. The gate is 7 + 7; the old player is 4.5 / 4.5.
  * PC: the watchdog was RED on memory (93-94 %, the Claude app 19 GB across 39 processes, browsers 9 GB) for a few
    minutes; rule_guard blocks every Godot start on RED. It cleared by itself; a film needs AMBER or better.
- S513 (CLI session on the Console credits, 2026-11-18 ~00:10-02:30; headless only, his game was open all session;
  commits ac4ce0972, 95ab3f180). READ THIS FIRST, it is newer than the lists below:
  * Built after the first blind round (causes b and c below): a reaction starts part-way into its take so the head is
    furthest 0.13 s after the glove lands (`ChoreoRules.REACT_PEAK_S`), reaction takes vary by the plan's seed
    (`REACT_VARY_SCORE`), the join into a reaction is 0.11 s; a boxer turns at most 3.5 rad/s and holds his facing
    while the places are under 0.5 m apart (`Player2.FACE_MAX_RPS`, `FACE_HOLD_M`). Headless bout (`s512b/v2l`): head
    jumps 14 -> 10, none on a contact or a clip change. NOT FILMED, NOT JUDGED.
  * The film's rulers now SEE v2's hits (NEXT item 3 done): `Player2._record` fills `stage.hit_gaps` (hits.json) and
    the film's `hold` column reads `Player2.hit_until`. First reading: the reaction ruler still says 15 frames / 9 cm
    (it measures the head from the hips over a 15-frame window; the snap itself now shows as it should) - check that
    ruler against the next film's pictures before trusting it.
  * FEET (NEXT item 2): measured, not solved. `v2/FootCarry.gd` (opt-in `-- fightplayer2 fp2carry`; FootPlant stays the
    default): the take's own footwork shown as captured, the plan's travel stepped from the plan, a reaction on the
    spot keeps its feet. Real bout headless: slip 7.5 / 7.3 m (FootPlant 9.5 / 6.5), in the guard 0.5 m (2.3), knee
    jerks 36-46 (16-26). WHY the ruler stays high whatever the layer (`tools/fp2_take_feet.gd`, `s513/slipwhy.py
    <shown.csv>`, `FootCarry.tally` with `fp2log`): (1) about half is the bought takes' OWN shuffles when their hip
    travel is on the body (alone: kidney shot 0.89 m, dodges 0.6 m, gut-shot stagger 0.41 m, hooks 0.2-0.27 m, a jab
    0.11 m); (2) the plan moves the body 0.4-0.5 m in 0.3-0.4 s WHILE a take has one foot in the air, so the support
    foot has to move (the body shot: 21 m of body travel each in 75 s). So the feet are a PLANNER problem first: end
    the step in before a take that steps itself, plan less travel (cause a: head distance, fewer chest-to-chest
    bursts), then film `fp2carry` beside the default and let the eye pick. Tried and dropped (no gain): letting a
    foot the take has in the air ride the body, holding a planted foot's turn when the plan turns the body.
  * THE OWNER'S OWN REVIEW COMMENTS (relayed by the main session 2026-11-18; critic input, quote them, weigh them
    with the blind critics' lists): C430 at 43.7 s "the guard is wrong their hands are too stiff and they do not move
    their feets , they only slide" (= critics' item 5, causes d and the feet block above); C431 at 51.0 s "too many
    shots go through heads or hands and there is no collision" (= item 4 "the glove stops on what it hits", and
    blocked punches get no finish yet); C432 at 10.3 s on bought_vs_ours.mp4 "the punches on the first 2 animations
    have no power behind them , the shoulder movement needs to generate the power" (look at which two takes those
    are before acting; his S439 note said the same: the torso follows, the shoulder loads).
  * SECOND FILM + BLIND ROUND (2026-11-19 ~03:10-03:25 UTC, `E:/FightCamp/tmp/fightweek/v2r2/`, the S513 fixes:
    reactions on the blow, varied takes, no whirls): coach 3.5, animator 3.5 (first v2 film 3.5 / 3.0; the old
    player r14 4.5 / 4.5). THE GATE IS NOT MET; v2 stays behind its switch.
    | critic | whole | punches | defence + reactions | footwork + stance | transitions | waiting |
    |---|---|---|---|---|---|---|
    | coach | 3.5 | 3.5 | 3 | 4 | 3.5 | 2 |
    | animator | 3.5 | 4 | 3.5 | 3.5 | 4 | 2.5 |
    Rulers on this film: the hit head peaks 2 frames after the contact (was 15+), moves 6.6 cm (jab) / 12.9 cm
    (cross) / 8.7 cm (body); head jumps 10, none on a contact; slip 9.2 / 7.2 m (FootPlant, the default).
    BOTH LISTS, most important first (they agree on all five): (1) RANGE - 40-60 cm of air between the lead gloves at
    rest (today 0: they wait with gloves touching), a 20-25 cm step in that lands with the glove, a step out 30-40 cm
    within 15-30 frames of the last punch, chests under 35-45 cm = a tie-up and push off; (2) SOLID BODIES - a glove
    stops on the surface, never through or round the back (ex3 #9-#19, ex5 #47-#49); move the hitter's feet instead
    of bending the arm round him; (3) REACTIONS SIZED AND LASTING - now on time but a 2-frame twitch: jab 8-12 cm,
    cross 18-25 cm + 15-20 deg turn + a 15-25 cm half step back, hook a 30-40 deg head turn, body shot a 30-50 cm
    fold over 8-12 frames, recovery 10-20 frames (REACT_PEAK_S skips the take's own travel: start further back, or
    pick the bigger takes, and check the ruler's 2-frame reading against the sheets); (4) WAITING ALIVE - never 6-10
    still frames, weight shift, an 8-15 cm step every 0.5-1 s, a feint every 1-3 s (wait and wait2 are a second of
    identical pictures); (5) READABLE FROM THE FIXED CAMERA - keep the line between them within 35 deg of side-on
    (red's back hides blue through ex4, the waits and half of ex5; half the landed punches cannot be seen). Also:
    the straight-arm hook (ex5 #5-#10), 10 head jumps inside takes, planted feet, 4-6 frame blends.
    Reviews: `v2r2/critic_coach.md`, `critic_animator.md`, pictures `critic_*_10.png`. The animator wrote "40 sheets"
    (there are 30): check a frame reference before building on it.
  * (DONE S525: Player2 split, range built - the S525 block above replaces this NEXT list.)
  * OLD NEXT, kept for its reasons: (1) RANGE, cause a (plan in head distance, drop or restrict the
    short takes, a step out after a burst's last punch) - the critics' item 1 and the feet's biggest cause; (2) the
    minimum play time for a take (events cut each other after 1-4 frames, cause c); (3) waiting alive, cause d;
    (4) film (seed 7, 75 s; also once with `fp2carry`) and a fresh blind round - the gate is still 4.5 + 1.
- PHASE 1 DONE (0b1a1d50d): the clip census, `assets/data/clip_db.json`, `ops/research/CLIP_CENSUS_S512.md`.
- PHASE 2 DONE: Goose's choreographer collected by diff (79b9dee65, issue 356 closed), then tightened here (2759011cb):
  `v2/Choreographer.gd` (plan(beats, db, opts): punches planned in the order they LAND, the Punch PRO takes first, a hit
  cuts what the hit man was doing, he gives ground only on a combination's last punch), `v2/ChoreoGap.gd` (the distance
  plan: rest 1.7 m, creep to 1.4, the step in ends 0.08 s before the glove lands, the pocket 1.2 m between a burst's
  punches, the leave), `v2/ChoreoReact.gd` (reaction / block / defence takes), `v2/ChoreoRules.gd` (the constants).
  `tests/choreographer_test.gd`: its sweep now FAILS on a plan fault - 40 seeds, 840 punches, 0 distance faults, 6
  punches off their take's distance, 24 cut by a stun. `tools/fp2_plan_dump.gd` prints one exchange's plan
  (`sh E:/FightCamp/tmp/fightweek/s512b/dump.sh seed=9 from=2 to=5`).
- PHASE 3 BUILT (e73a523a7), NOT JUDGED: `v2/Player2.gd` (414 lines) plays the timeline: a take starts when its event
  says, through the join smoother with the join time of its kind; the take's own hip travel moves the BODY (RootPath);
  the distance plan moves the pair (the man it names covers the ground); back to `pro_idle` when a take ends. Every
  shipped pose layer is OFF in the fight (kept: JoinSmoother, MetaHumanTwist, FootPlant with no stance stretch,
  FloorStand, TiredSag, PunchAim); a director's scene (walk-in, corner minute, the count) gets the old stack back.
  `v2/PunchAim.gd` = the ONE arm finish (scope 3a): a landed punch's glove front ends on the lower face / the ribs, at
  most 0.30 m, eased in over the last 0.22 s (two-bone IK solved for the glove front; not for a miss or a block).
  Hooks: FightStage (v2 node, `_process` / guard / `_on_finished` / scene_mode / `_shown_at`), FightView (`_queue` plans
  the exchange, `_process` hands the clock, `_ambient` off), BeatFire (`stage.v2.takes`), FightClips.untouched (pinned
  takes from the untouched bake: the census's contact times hold). FightStage is at 495 lines, FightView 491: no room.
- NUMBERS (headless; `tests/player2_test.gd` = two exchanges, two different bodies; `sh .../s512b/t.sh player2_test`,
  `TARGS="-- show" ` prints every contact): landed gloves median 4.4 cm off the target (26 cm with no finish), 11 of 14
  within 12 cm, counts kept, no head inside the other man, rest 1.36-1.66 m, no missed glove on him. DEBT lines (guards,
  not passes): 5 head jumps (the body shot's own dip plus the step in), foot slide 3-4 m an exchange by that ruler.
  The REAL bout headless (`sh .../s512b/bout.sh v2a 75 fightplayer2 fp2log` = human_fight_film with `show3d`, no GPU,
  allowed while he plays): 0 script errors, three exchanges planned and played; the film's own rulers
  (`s512b/v2a/rulers_motion.txt`, `rulers_raw.txt`): support-foot slip 9.5 / 6.5 m in 75 s (RAW 33-37, shipped
  0.2-0.4, bar 1), head jumps over 12 cm 13 (r14 14, bar 0; all inside a take: jab_a 26 cm, hook_ft 22 cm), heads
  inside 0, distance p50 1.5 m, knees p50 150 / 141 and 133 / 123 (the bought stance is back on boxer 0).
- FIRST FILM + BLIND ROUND (2026-11-18 ~00:20-00:45, `E:/FightCamp/tmp/fightweek/v2r1/`): v2 scored LOWER than the old
  player. Coach 3.5, animator 3.0 (r14, the old player: 4.5 / 4.5). The gate is NOT met; v2 stays behind its switch.
  | critic | whole | punches | defence + reactions | footwork + stance | transitions | waiting |
  |---|---|---|---|---|---|---|
  | coach | 3.5 | 3.5 | 3 | 3 | 3.5 | 3.5 |
  | animator | 3 | 4 | 2.5 | 3.5 | 3 | 2.5 |
  Reviews with every frame reference: `v2r1/critic_coach.md` (12-item 10/10 list), `v2r1/critic_animator.md`; their
  10/10 pictures `v2r1/critic_coach_10.png`, `critic_animator_10.png`; film `v2r1/men.mp4`, sheets `v2r1/sheets_close/`.
  THEIR 10/10 LISTS, most important first (both agree on 1, 2 and 5):
  1. RANGE. Wait with heads 1.3-1.6 m apart; straights land with heads 0.8-1.1 m apart, hooks 0.5-0.85, uppercuts and
     body hooks 0.55-0.65; one visible step in (lead foot 25-35 cm in 5-6 frames, down 1-2 frames before the glove);
     under 0.45 m = a real tie-up or a 30-40 cm step out inside 10 frames. Today every exchange ends chest to chest
     with gloves parked on faces (ex1 #5-#30, ex4 #43-#60, ex5 #1-#56).
  2. EVERY LANDED PUNCH SHOWS ON THE HIT MAN FROM THE CONTACT FRAME: head starts 1 frame after, peaks in 3-4, back in
     10-14; jab 5-8 cm, right hand 12-18 cm + a 20-30 deg turn, body shot hips back 8-10 cm + a 15-25 deg fold inside
     2-4 frames. Today the hit head moves 0-8 cm, an uppercut gets nothing (ex4 #45-#60), the body fold starts a third
     of a second late (ex3 #25-#40).
  3. NEVER SHOW THE BACK, NO WHIRLS: hips at most 60 deg off the other man, at most 6-12 deg of turn and 6-9 cm of head
     travel a frame, 6-8 frames from a dip to standing. Today: side view to back view in one picture (ex2 #18-#19),
     backs in ex1 #41-#48, ex4 #42-#48, ex5 #5-#12 and #42-#52; 13 head jumps; takes played for 1 and 4 frames.
  4. ONE STANCE HELD ALL BOUT (lead foot 50-55 cm ahead, feet 20-30 cm apart sideways, trunk 5-10 deg toward him);
     punches from the floor and straight home (arm straight 1-2 frames, no back-swing behind the ear, free hand on
     the chin, the glove stops on what it hits: an arm goes through the body at ex3 #15-#18).
  5. WAITING ALIVE + FEET PINNED: bounce, head movement, a feint every 2-3 s, a side step a second; a foot carrying
     weight slides 2 cm at most. Today both are frozen 31 % of the round, one guard take fills 59 %, the planted feet
     slide 15.6 / 13.4 m (the animator's own reading of shown.csv).
  6. A defence plays only against a punch and timed to it (the squat at ex2 #7-#24 dodges nothing); every exchange has
     an end (step out or turn off); keep the pair readable for the fixed camera; use the ropes or leave them.
  MY READING OF THE CAUSES (code, not taste; check each before building):
  a. Range: the planner's gap is pelvis to pelvis and the short takes (cross_c 0.64 m, uppercuts 0.53 m) put heads
     0.5 m apart; inside a burst the pair holds there and each take's leftover travel is added to the body's place.
     Plan in HEAD distance, drop or restrict the short takes, step out after every burst's last punch.
  b. Reactions start at second 0 of their take (the old player started them past the lead-in, "the peak on the
     blow": BeatClips.react_from): start each at its `head_peak_s` minus 3-4 frames. Light reactions fall back to one
     take (hit_by_hook_v3) for every punch: the size / direction pools are phase 4b.
  c. Whirls and backs: Player2._face turns each man to the other man's PLACE; chest to chest a take's travel carries
     a body past that place and the facing flips. Also events cut each other after 1-4 frames (defence, then a
     reaction, then his own punch). Face along a smoothed fight line, hold a minimum play time, cap the turn rate.
  d. Waiting: only pro_idle plays; the eight fidget takes, feints and the plan's pivots / side steps are not wired.
  e. PunchAim solved the body shot through the body: the target must be the SURFACE (ribs + a glove's depth), and a
     blocked or missed punch gets no finish at all today.
  THE SHEETS: tools/film_sheets.py cut 12 pictures a sheet at 24 a second; the briefs say 15 at 30. Fix the brief's
  words (or the tool call) before the next round. `hits.json` is empty for v2 (NEXT item 3).
- NEXT, in order (each is v2 work, not a correction layer on the old player):
  1. FILM IT the moment no game window is open (`sh E:/FightCamp/tmp/fightweek/s511/film_only.sh <out> fightplayer2`
     - it refuses while a game is open; seed 7, 75 s, beside r14) and run the blind coach + animator round (briefs in
     `E:/FightCamp/tmp/fightweek/r14blind/`). Look at the stills yourself first: nothing of v2 has been SEEN yet - the
     guard hands, the block take, PunchAim's elbow and the joins are only numbers so far.
  2. FEET (the biggest number left): (a) a reaction played "upper" is pinned WHOLE-BODY today (its feet step while the
     hips are held = skating: gutshot 1.2 m, hit_by_hook 0.9 m of the slip) - build the upper-body mask (legs stay on
     the guard take) or play it with its travel; (b) steps: FootPlant only reacts once the body is 10 cm off a foot.
     The plan KNOWS every step (tracks' `step` events: start, end, metres): drive the feet from it - lift the lead
     foot as the ramp starts, land it where the ramp ends, then the rear - so a planted foot never moves. FootLock
     (`-- fp2lock`) was worse (a spring: 14 m).
  3. The film's rulers cannot see v2's hits (reactions read 0): fill `stage.hit_gaps` from Player2's contact callback
     (`Player2.contacts` holds t, who, move, result, take, gap) so reaction delay / size and "cut by his own punch" read.
  4. Head jumps: the step in overlaps the take's own dip (body shot, jab_a); end the step earlier for takes whose head
     travels over 15 cm before the contact (`head_max_m` in the table), or slow the step for them.
  5. Hooks on boxer 1 pass 14 cm beside the face point (the path, not the timing): aim hooks at the side of the jaw,
     not the face centre. Blocked punches get no finish yet (they stop 5-10 cm long by plan): look at the film first.
  6. Not built: pivots (the plan writes them, the player ignores them - the camera is fixed side-on), the clinch (no
     owned take; they stay at range), the knockdown falls through to the old code (untested in v2), the HUD body map
     gets `view.body.land` only. Light reactions for a jab fall back to hook reactions (no straight-back light take
     is owned: the buy list).
  THE GATE: v2 must beat 4.5 by a point with the blind critics; then phase 5 deletes the replaced layers.
- PHASE 4 (after the gate work): 4a stills of every reaction / block / defence take, fix the table's bars by eye; 4b
  wire the pools (size and direction), block flinch, whole-body stumbles, hurt idles.
- EXPECT (say it plainly when asked): Dola expects 6.5-7.0 on owned clips, Goose 5.5-6.5; with the end-of-November
  purchase 6.5-7.5. Buy order: stepping punches, hooks at head height, straight-back light reactions, longer uppercuts.
  Money is still his explicit yes, after he sees the motion.
- TOOLS (E:/FightCamp/tmp/fightweek/s512b/): t.sh <tests...> (60 fps through the slot; `TARGS="-- ..."`), dump.sh (a
  plan), tool.sh <tool> (a headless v2 tool, e.g. fp2_feet_probe), bout.sh <name> <secs> fightplayer2 (the real bout,
  no picture, both ruler reports), census.sh. Film: s511/film_only.sh.
- TRAPS: a test that prints `failures=0` may still have SCRIPT ERRORs (a parse error in a preloaded module): t.sh
  prints them, read the line. Write patch scripts with the Write tool (a heredoc with an apostrophe broke the shell
  again). A hook's glove front covers ~20 cm a frame: read its PATH between frames, never one frame. The glove
  follows the skeleton a frame late: call `gloves._follow()` after a seek before reading `glove_front`. `.uid` files
  under scripts/fight3d are untracked on purpose. Never `cd` out of E:/FightCamp/Lean. Goose: 5 used on 2026-11-17.
- r14's parked patch (`E:/FightCamp/tmp/fightweek/s512/r15_parked.patch`) stays parked: correction layers.

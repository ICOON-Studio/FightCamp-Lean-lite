# S429 handover: the critics' round results, week design v4, collects (written 2026-11-10, end of S428)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S429` and redraw the Miro map.
S428 has no digest: its facts are here, in roadmap.json `now` and in memory (project_s428_bjj_critics_collects).
FIRST, BEFORE ANY CRITIC ROUND: run `get_usage` (ccd_session_mgmt). In S428 the plan showed weekly all-models 100% and extra usage EUR 24.41 of 40 spent; each round of two fresh critics is ~330k subagent tokens. Ask him about the money before another round.

## SCOPE CHANGE (his yes, late S428): read ops/research/SCOPE_FOUR_FIGHTERS_S428.md FIRST
His words: "ok p[roceed with this plan and adjust miro opsboard and everything else". The plan: (1) FOUR FIGHTERS at the start (three boxers + one BJJ, four weight classes, a staggered first week); (2) amateur bouts need NO CAMP (a light fight week, offers 1 to 2 weeks out; camps stay for pro, title, nationals); (3) the RANK on every fight (a regional ladder first); (4) a small HOSTED CLUB SHOW after those; the full promotion waits until after the small living world; (5) a COMPARE TAB while searching for an opponent (his later message: "also during searching for opponent add a compare tab like boxing managers"), in R37. Task ids in the roadmap plan: FOURSTART1, AMATEURWEEK1, RANKSHOW1 (Qwen first: pure ladder module + tests), HOSTSHOW1; WEEK4 is re-based on four fighters and fight weeks. CLAUDE.md item 4 carries the change. DONE for it in S428: CLAUDE.md, the scope file, roadmap plan/now, the Miro P0 map redrawn (frame height still 5210: its resize is refused), memory. NOT done: the Miro P1-P9 production frames (cards not moved), any design map or brief for the four tasks, the money re-measure for four fighters (start cash, stipends, Reid's wage).
FIRST MOVE of S429: write the FOURSTART1 and AMATEURWEEK1 design maps (menus table each), brief RANKSHOW1 to Qwen, and run the money re-measure for four fighters; ask him about critics money before any round.

## His words in S428
None new (the session was the start command, then the work in the handover below). His open marks: the two S427 stills (8787/review, 2026-11-10_1821), and the new posts (Training tab B, the fight screen: 2026-11-10_1854, _1858).

## Done in S428 (main, pushed)
- MOODHABIT1 collected (docs/MOODHABIT1_RESULT.md): mood is under 1 point of win chance (Flat vs Steady -0.8, 0 with the corner silent); habits 6 to 15 points against the right opponent; HabitFix.cost is one flat cost so a habit's name only changes WHICH opponent punishes it; CornerTrust.lands is called nowhere in the fight (Low = Flat).
- TRAININGB1 (PR 179) collected: Training tab B with the tiredness curve; week_b / slate / plan / coach / training_week / weekend_plan tests green; real render read.
- FIGHTDISPLAY3 collected: wooden side panels, IntentChip over the heads, name plate, EnergyForecast; four new tests green; fight3d_play failures=0. STILL OPEN: the chip over the right fist covers the R3 card; the head tooltip ("HEAD 89 - ...") sits on the brain icon; the corner card's text overlaps ("Your coach has seen it..." over "Leave it"). Brief a small FIGHTDISPLAY4 or fold into HALOSWEEP1's review.
- Ziva fixed: its worktree moved to main (old project.godot re-save on wip/ziva-s427), editor started hidden, port 7012 answers.
- Briefed: HANDSPROBE1 (Qwen: how scarce Reid's hands are; first run VOID, spread rule), BARGUARD1 (Cursor, queued: boots above the corner bar while a shot holds; the ANIMATION item of the session, with the legs retry still to do), HALOSWEEP1 launched (Cursor).
- Critic rounds (all in docs/mockups/s428: reviews + each critic's 10/10 drawing):
  - BJJ live choices: Kalli's nine decisions 4 and 5; v2 (ops/research/BJJ_LIVE_CHOICES_V2_S428.md) 5 and 5; v3 5 and 6; v4 (V4 file: orders dial and cue bar cut; PREDICT, BAIT, work the grips, the 3 s hold, defender's card, hidden mode, ear) went to two critics at the end. Economy/hidden-information critic: 6 (ear and PREDICT 4; everything else 6; anticipation 7). Its list: write the mode x kind matrix with magnitudes per archetype; show the win-chance change per arrow; make PREDICT worth more than waiting 5 s for the free clue (lock the pick before the clue, show the bet's EV, fix the 3 s vs 5 s lag); state the defender's card cost and match its timer to the 3 s hold, show pin escape odds; the book should shift her MODE weights, not only her answer odds; make gas bind (as coded it ends near 0.58). The BJJ black-belt critic (bjj_v4_critic_bjj.md): 5.5 (rival mode 6.5; open day and corner minute 4; crises 4.5). Its list: the 3 s hold cannot fit a 6 to 8 s card and the clue is 3 s in one place, 5 s in another (slow the mat to 0.3x inside a hold, give the attacker a mini-card, resolve both sides at once); write the mode x move-kind matrix (spread 0.15 or more, each pick best against two modes; scouted reaction rows go stale with use); rebuild the ear (cap from Fight IQ and trust, one pip held for defence, one prediction per mode window); add Pace and a Chase / Even / Protect stance; a gas price on parking a pin and on grips. Dominant plays found: scout then always bait, spam the modal PREDICT, park a pin, take the first penalty free. So BJJ v4 stands at 5.5 and 6 (not 7).
  - Cutman v3 (Kalli): 5 and 5 (cutman: a closed cut is a thin patch that reopens; seats not 3+3 hands; head-clash cannot trigger in a 4-round debut. Systems: a cut night is ~2 a gym-year, so put swelling and bruising in every bout, reprice tiers from EV, pin opening depth / close-reopen / hunt rate / doctor timing, hidden doctor temperament, send-out priced through InjuryRoll, finger test, a cut ledger in the Why).
  - R37 ask for a fight (ops/research/R37_ASK_FOR_A_FIGHT_MAP_S428.md): coach/matchmaker critic 5 (make the SHOW the unit: ask against fixtures; a two-way favour ledger; targeted asks, host mode, incoming asks; the readiness read picks the kind for the player). The management-designer critic also 5 (r37_critic_designer.md): show the POOL (which clubs have a free fighter at her weight, who is booked or hurt); odds before the ask per channel (the app at $10 a month is a toggle that cuts "nobody" from 52% to 9% in a thin pool: give it a per-fight fee or a 12 to 18% pull-out rate); favours must buy something (a free sparring partner worth $160, a reserved slot); the wait must carry decisions (morale clock, two asks held, the pool moves); price each kind (amateurs have no purse: a step-up win needs a reward such as a shortcut to the pro offer).
- Verified in code (BJJ): BjjMatch.can_call needs init == 0 (nothing is offered while she is being passed); BjjRef says pins never stall; tick() calls level points a draw and decide() passes advantages as [0,0].

## Running (yours to collect)
- qwen/handsprobe1 (TASK_HANDSPROBE1): Reid's hands; first result VOID (5 opponents, 20 rows): the spread rule needs 10 opponents and 12 distinct rows.
- cursor/halosweep1 (TASK_HALOSWEEP1): the outline on 12 more screens. RENDER and read the log before collecting.
- Queued: BARGUARD1 (Cursor). SQ40 (Kalli: what else the corner can say) sent; its answer lands in ops/research/K_CORNER_MORE_S427_BRIEF_KALLI.md.

## Open, in this order
1. Read the last critic reviews above (BJJ v4 x2, R37 designer), and his marks on the review board.
2. WEEK DESIGN V4 (the recorded next action): from the two S427 critics' five points (see git show 42729e87 NEXT_SESSION_PROMPT, section "What both say") + THURSDAY2 (no Thursday stop) + MOODHABIT1 (mood claim goes, habit claim stays, priced by the opponent's file) + HANDSPROBE1 when it has a valid result. Then two fresh critics (money first), 7+ from both -> his board.
3. Which design goes on? He decides taste and money: BJJ is at 5 to 6 after four rounds (not 7), cutman 5 and 5, R37 5. The pattern every critic finds: anything the card prints from the visible scoreboard is a lookup. Recommended: one more BJJ round only with the v4 fixes, then stop and show him the best picture and ask.
4. Collect HALOSWEEP1, HANDSPROBE1 (valid result), BARGUARD1 when they land. Legs: retry qwen/legtremble4's code on main (its salvage is only code, no films in wt_salvage: re-render).
5. Cutman v4 and R37 v2 from their critics' lists (above); Kalli's SQ40 corner options page.
6. Unread seat answers: SQ31 dues choice, SQ34 cheap club money, SQ37 belt ladder, SQ38 small world (design only, after the week).

## Not done, say so
- E: is 92% full (35.8 GB free; AMBER). Scratch renders under E:\FightCamp\tmp: moss 11 GB, s390 6.6, s393 4.0, s392 3.5, s383 2.9, rokoko2 2.4. NOTHING deleted: ask him.
- Miro P0 frame: map entries updated in where_we_are.py but NOT redrawn on Miro this session (token budget). The frame resize and deleting old surplus cards need his yes.
- No Workflow or full test run; the nightly runs at 05:00. Export not rebuilt this session (TRAININGB1 and FIGHTDISPLAY3 landed after the S427 export): run `sh tools/export.sh` and refresh WHAT_TO_TRY.txt first thing if he wants to play them.
- BJJ "refinement art and visual effects" (his C274) still not briefed to Cursor: after the design reaches 7+.

## Traps
- A worktree command's cd changes the session's primary directory: use `git -C <path>` and absolute paths, `E:/` paths for review_add.py (an `/e/...` path is skipped).
- Qwen's dispatch: seat_dispatch refuses while live_runs.json says a run is "running"; mark landed runs there (S428 did for MOODHABIT1, FIGHTDISPLAY3, TRAININGB1).
- hidden_desktop renders print nothing on stdout: pass `--log-file <path>` to Godot before `--script`, and wrap the whole command in `godot_slot.py run --who claude --`.
- A critic's copy of a design page must be stripped of earlier scores and of the words "earlier draft"; docs/mockups/s428/*_for_critics.md are the clean copies.
- RingCamera.gd is exactly 500 lines; CornerBar.gd 492; SidePanel.gd 464; WeekBoard.gd 471.

SETTINGS: S428 ran on Sonnet 5.5 at default effort and spent heavily on critic subagents. Next session: Sonnet 5.5, high effort, Fast off, and decide with him the money for critics before spawning any (collecting, rendering and writing week v4 are cheap).

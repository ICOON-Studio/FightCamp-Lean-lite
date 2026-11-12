# S443 handover (written 2026-11-12 at the end of S442; S441's handover is in git history at 015c6dec)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S443`
and redraw Miro (a partial SVG with the frame line and the changed cards works; then `where_we_are_svg.py learn` / `trim`).

## USAGE: HE IS ANGRY ABOUT THE BURN (read this first)
His words at the end of S442: "how the fuck we drained 4% already in less thanan hour ? why we are spending so much so
fast ?" The week had reset at 16:00 and all models and Fable were both at 4 % within about an hour. The causes, in order:
1. S442 ran to 669k tokens of context. EVERY turn re-reads all of it: each helper notification, each board answer and
   each idle-guard bounce (dozens of them) cost a full pass over 650k tokens on Fable.
2. Helpers at 200k to 500k tokens each: after the reset alone, the bars designer twice (about 400k), four critics (about
   800k), two reviewers, one probe builder.
RULES FOR S443 (mine, until he says otherwise): `get_usage` first and after every helper batch; hand over at 300k, not
later; at most TWO helpers running; critics only at a real decision point, never a second round on the same shape; do
not end a turn just to report (each bounce is a paid turn): batch the work and report once; answer the idle guard with
one `idle_guard.py ok` when the wait is on him, not with a new turn each time.
MODEL (his ask: "propose a different model/effort to solve these problems ?"; my proposal, he did not object): design
work on Fable 5.2 at high effort, measure-first (no case goes into a design until a probe has played it through the real
bout); critics on Opus; measurement code on Opus high, never Qwen; rule modules on Qwen ALWAYS with a blind review
(all seven needed fixes in S442 and its probe was fake). Given his anger about cost: ASK HIM before any Fable-high
design run, with an estimate in tokens.

## HIS WORDS (S442, verbatim; each is acted on unless marked OPEN)
- "Carry on now"; "check comments on board" (C314 jab B: "still no power behind the shot it looks like a gymnastic extension
  move , not a punch"; C315 "same with jab b"; C316 PA mix: fixed, new clip on the board, unheard).
- Mocap packs (Q-S294-194): "i dont like any of their punches animations, their punches seem to be have to power behind
  them , what other options we have". Four options given (POWER1 first). OPEN: no pick. Do not buy the two packs.
- "can you also a UX expert to audit game and makeimprovements", "and HUD too if can do both", the Hades hover-label idea
  with the video, "add some effects on critical decisions buttons like slowly expand and shrink to draw players eys ?", the
  slide "Secret recipe for main menus" (memory feedback_menu_recipe_hades_ux_s442). All done; four layout picks OPEN.
- On animated numbers, the "visually engaging" table and the "Living Gym" text: asked "do you agree ?" / "what do you
  think ?"; answered in chat (the UX audit carries the rules that came out of it).
- "Yes, draw them" then "All three": built (below). "wait", later "Go on". "write the handover now".
- THE FIGHT BARS: "I am thinking of adding 2bars next to the fighter in the fight , one bar is switched on or off
  representing the pushing aggression against the cost shown on the tank (other bar) which drains or regens according to
  the tactic. Can you have this rated and deepened and branched with other aspects of the game"; "I want to see bars feeling
  similar to the motor style race, where you control the tires and the fuel, something like that inside our fight maybe.";
  "Need ideas to add more meters affected by like stamina to make it a bit more engaging for the player ?"
  (memory project_push_tank_race_bars_s442).

## DONE IN S442 (all on main, pushed)
- BUILT from his three approved drawings, in the build of 16:18 (Builds/FightCamp.exe, WHAT_TO_TRY current; the exe
  smoke-started headless, NOT played on screen): corner cards (scripts/ui/CornerSwapCards.gd, SwapLink.gd, from LineSwap),
  reaction bubbles over the fight (scripts/fight3d/ReactionBubbles.gd), the headline card before the result page
  (scripts/rules/Headline.gd, scripts/ui/modals/HeadlineCard.gd). Notes: ops/research/LOOP_BUILD_UI_S442.md,
  LOOP_BUILD_BUBBLES_S442.md. Real stills on the review board.
- UX audit (ops/research/UX_AUDIT_S442.md): 17 fixes, Pulse.gd (one breathing button a screen), Tally.gd (money rolls).
- RESULTDEFECTS1: 4 of 7 fixed + the damage tile's head; 3 measured, not changed (ops/research/RESULTDEFECTS1_RESULT.md).
  DEFECTS1 merged (one table of level words; the corner's face line).
- COLLECTED rule modules, none wired to a screen: LineSwap (PR 230), TraitLine (231), PlanPhase (R17PHASE1), LineGrade
  (R24GRADE1), FightLearn (from PR 235), MatPrice (237), ClubDeal (234), TellWorth (236). The last three came through a
  blind review with fixes (ops/research/*_REVIEW_S442.md). Their tests are on the daily list in tools/run_tests.sh.
- Result page: round 2 failed its logic check; rounds 3 and 4 are drawn from a REAL bout (tools/result_dump.gd seed 44,
  docs/mockups/s442/result/). Round 4 scored 6 and 6: THE LOOP IS STOPPED. His call on the shape is Q-S294-199.
- Measured: ops/research/FIRELEVEL2_ADAPT1_RESULT_S442.md (fire level on only with a first-season re-measure; the adapting
  opponent stays off). Sound: the crowd swells in under the announcer. Ziva's editor restarted. Miro P0 redrawn twice.
- Memory written: project_s442_ux_loop_builds, project_push_tank_race_bars_s442, feedback_menu_recipe_hades_ux_s442,
  feedback_usage_burn_s442.

## THE FIGHT BARS (his idea; NOT at 7+; parked on his answer to Q-S294-203)
ops/research/PUSHTANK_MAP_V2_S442.md + docs/mockups/s442/pushtank/fight_bars_v2.png: HANDS (Coast / Steady / Push) spends
WIND, FEET (Press / Hold / Move) spends LEGS and picks where it is fought, HEAD is the damage both protect; set in the
corner minute, a change mid-round costs a shout; rings under the feet. Critics on v2: the coach 7 and 6
(PUSHTANK_V2_CRITIC_B_S442.md), the systems designer 5 and 4 (PUSHTANK_V2_CRITIC_A_S442.md). What a v3 must answer, all
checked against the code by the critics: one habit wins without a read (Push round 1, Steady after, never touch FEET);
legs barely matter in 3 rounds (they end at 60-70); the head's "line at 60" is not a real line (count risk grows
steadily); every case is answered by ONE read (depth = two reads that disagree); a hurt fighter must never be told to
Push (a code gap makes Push lower the hurt chance); "Hold" reads as clinch (use "Centre"); amateur corners never see the
cards. NEXT: his answer (measure now / park / drop). If measure: a probe through real bouts FIRST (four arms: today,
HANDS only with Save's flat refill removed, HANDS + FEET + HEAD, at 3 and 6 rounds; the named habits as opponents),
then a v3 design from the measured numbers, then two fresh Opus critics, ONCE. It is OUTSIDE his agreed order (ask for a
fight, weight, turning pro, training scene): nothing is built without his go.

## ASK FOR A FIGHT (mechanic 1 of his order)
Map v2: ops/research/ASKFIGHT_MAP_S441.md (after Kalli 5/6 and John 6/6). Qwen's ASKPROBE1 was REJECTED by the blind
review (ops/research/ASKPROBE1_REVIEW_S442.md): its probe rolled its own dice. The reviewer's honest probe is
tools/ask_probe_honest.gd; its finding: scored one night at a time, a RECORD player waits in 59 of 60 (a typical amateur
wins 33-43 % even against the sheet name) and SAFE always takes the sheet name.
A HELPER WAS STILL RUNNING AT HANDOVER (it dies with the session): fixing scripts/rules/AskBout.gd + tests/ask_bout_test.gd
(eight defects from the review), and writing tools/ask_probe.gd as a TEN-WEEK SEASON measurement (waiting is not "no
fight": the sheet sends a bout anyway) + docs/ASKPROBE1_RESULT.md. CHECK `git status` FIRST: any of those files
uncommitted in the checkout is its unfinished work. Read what is there, finish it yourself or re-brief ONE helper, run
ask_bout_test and the probe, and only then decide whether the map's prices hold. Nothing is drawn before that.

## ON HIS BOARD, UNANSWERED
Q-S294-195 Cardio or Stamina as the one name (my pick: Cardio); 196 fight screen regroup; 197 hover labels for secondary
buttons; 198 Money page on one screen; 199 result page shape (my pick: summary + tabs; the coach critic's two musts go in
either way: the best fix is BOTH plan changes, 100 of 200, and "even the best plan makes it an even fight"); 200 was
answered in chat ("All three"); 201 the no-sparring rule (21 days after 148 of 200 bouts; proposal 0.8 in
ops/research/NOSPARRING_SCALE_S442.md; NOT changed); 202 delete 17 GB on E: (review/_removed 5.3 GB, tmp/moss 12 GB;
NOTHING deleted); 203 the fight bars (measure / park / drop). In chat, unanswered: the roster bars growing from zero on
every visit (old rule) or only when changed (new; my pick); the two club-week questions in R73DEAL1_REVIEW_S442.md.
Review board: block stills (the jab ends under the guard; the same on main: item BLOCKLOOK1), the PA mix round 3, the
three built features, the four UX proposals, result page round 4, the loop drawings.

## OTHER STATE
- Qwen queue: R29JUDGES1, R85NEWS1 (the dispatcher launches them; it waits while a windowed render runs on an AMBER PC,
  and E: at 87 % full keeps the PC on AMBER; Goose's three runs a day were used).
- The lead S439 session: POWER1 steps 3-6, filming. Collect against C314/C315; nothing is called fixed without his eye.
- Known layout defects waiting for his picks: the 3D corner card is 924 px tall and reaches the bottom bar; "Fix: Chases
  the stoppage" runs under "Leave it"; "Draw the" is cut on the fight bar; the Money page is taller than the screen
  (menu_money_test fails for that, as before S442).

## NEXT, IN ORDER
1. `git status`: the Ask for a fight helper's unfinished files; finish the season probe; decide on the map's prices.
2. His board answers; build what he picks (result page shape; UX proposals; the no-sparring scale).
3. The fight bars, only if he says measure: probe first, design after, with a token estimate agreed first.
4. POWER1 collect. 5. Wiring the collected modules where their screens exist (TraitLine on the fighter card, PlanPhase
and LineGrade in the Playbook, Towel in the corner minute). 6. Fire level on with a first-season re-measure.

## TRAPS (S442)
- A drawn data screen's sample must be a bout the game played (tools/result_dump.gd): the hand-written one broke the
  sim's rules in a dozen places. A drawing's logic check also found a fault in an already-collected rule.
- A critic loop flat for two rounds is stopped: ask him the SHAPE question; measure instead of drawing again.
- A seat's probe can roll its own dice and still print a pass line: a blind review before any merge.
- A JSON file rewritten with json.dumps re-indents the whole file: keep the file's indent.
- seat_queue.py takes brief paths relative to ops/ ("research/X.md"), run from ops/. The dispatcher refuses a brief whose
  OWNS names a file under ops/research (put a seat's result file under docs/).
- A Bash `cd` into a worktree moves the session's working directory: cd back. `du` over E:\FightCamp\wt is slow on that
  disk: read ops/AgentComms/pc_detail.json (`folders`) instead.
- The idle guard blocks ending a turn even while helpers run; `idle_guard.py ok` only for money / taste / scope questions.
  His "wait" outranks it.

SETTINGS: next session Opus 5.5 at high effort, Fast off (cheaper per turn than Fable; the first job is a probe and
his board answers). Fable high only for the bars design, and only after he agrees a token estimate.

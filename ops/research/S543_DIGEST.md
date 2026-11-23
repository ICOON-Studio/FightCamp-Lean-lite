# S543 digest (2026-11-23, 21:24-22:40, Fable)

## What changed in the game (on main; NOT yet exported - the watchdog was RED at the end)
- THE FIGHT WEEK SCREEN SHOWS THE TANK THE BOUT USES (6e60558e4). It used its own tiredness rule (1 a point over 50, cap
  25, no last-bout part); the bout uses 2 a point, cap 20, +8 for a bout inside 7 days. 16 of 24 cases differed, up to 13
  points. `FightWeekPlan.bout_tank` -> `BoutRules.tank_parts_for`; the win band on that screen follows. The unwired
  "Fatigue after the bell +6" line is gone. `tests/fight_week_tank_same_test.gd` (red first).
- THE FIGHT-WEEK LOAD CHOICE IS CUT (36a88b19b; owner Q-S294-324 "cut the fight week load choice"). The assistant sets
  the load; one line says which and why. The three load cards, their "best when" lines and the `fwstop` action are gone.
- `scripts/rules/ProStart.gd` + `tests/pro_start_test.gd`: turning pro v17's rules as a pure module (step 1 of the build).
- `tests/rank_show_ui_test.gd` follows the owner-approved result page; `BoutRead.gd` back to 500 lines.

## Findings
1. TELLS (TURNPROBE18, STOP at its first check; verified in `BoutRead._games`): a plan line written against an opponent's
   weapon or weakness adds a median 0.2-1.1 points over the coach's plan; only the fade answer pays (7-15, over its
   cap). A tell does not change how the opponent fights. -> `TELLPLAY_SCOPE_S543.md`, METHOD line, TELLPLAY1 running.
2. DEPTH PRICES (code-checked critic, six minutes): fight-week load DEPTH 4 PLAY 5, sponsorship or day job 3 / 4. Both
   probes had passed by construction (two tiredness levels as ten cells; six club cells that were two cells three
   times). FWLOAD2 on the game's own tank: the load is worth under 1 win in 100, Train through best in 0 of 18 -> cut.
3. COACHES v7 (the owner's design): FAIL 4 of 7, each failing bar by one cell; three named changes inside his answers ->
   COACHDEEP8 running. `BoutRead.chance` ignores the corner coach (the corner pick must wire it).
4. CARD GAME (the owner's play of round 8): the first screen cannot be read (codes, no deck, no opponent panel, a whole
   hand grey), and the position is one shared switch, so a man on his back is on his feet for free when the other
   stands and is punched in the same volley. -> `CARDREAL_SCOPE_S543.md`, METHOD line, John queued (SQ318).
5. FIGHT PICTURES: a blocked punch stops in the air (0.28-0.38 m from its target in every blocked picture); a landed
   short punch slides the puncher into the opponent (the limit is between root points). -> `TASK_PICSFIX1.md`.

## The owner's answers (verbatim where quoted)
- "Yes, interview me" -> `PUSH_KNOW_INTERVIEW_S543.md`, three rounds: the push switch is replaced by HIS corner commands
  (ten, two slots: one for attack or defence, one for positioning; live; the two bars as their cost; a switch or sliders;
  "the engine should understand and respond and display these decisions on the fight"). P3, P4 yes. P5: "depth can be
  judged and compared , i will play to judge the fun". Knowledge: K1-K3 yes; K4 a yes, b no. "d1-4 yes".
- Q-S294-323 "Yes, build v17 now" (turning pro). Q-S294-324 "cut the fight week load choice".
- Card game: "i do n ot understand where to base my card choice ... whatis my opponent doing, why i have no punch card ?
  how i see my deck ?"; "this is has not been given enough thought , how the boxer jabs when he is in the ground , its
  like very quickly drafted without any attention to how a a real fight is done."
- Fight pictures: "why fighters are entagled like that on the left and on the right the punch does not touch the
  opponent" -> "Yes, fix them now".

## Runs
Landed: DEPTHPRICE1CRIT (8db852cf2), TURNPRO18 (4d7082c8a, STOP), FWLOAD2 (148d2d66c, FAIL), COACHDEEP7 (2f78435ae, FAIL 4/7).
In flight at handover (console tabs of the S543 desktop session): TELLPLAY1 (c4), TURNPROBUILD17 (c5, branch
build/turnpro17, worktree E:/FightCamp/wt/TURNPROBUILD17), COACHDEEP8 (c6).
Briefed, not launched (watchdog RED, cap 3): PICSFIX1, CORNERCMD1.
Chat seats: SQ316 Kalli + SQ317 Dola (depth prices page, sent before the code check), SQ318 John (card real sequences).

## Lessons
- A design page I write from module comments carries wrong code claims: send it to a code-checked critic BEFORE the chat
  critics. A probe's "ten cells" must be checked for being the same cell.
- A screen's number and the bout's number can come from two rules: test that they are the same number.
- Closing a worker's tab the moment its result file appears can cut its last command: check the commit is complete first.

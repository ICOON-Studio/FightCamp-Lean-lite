# S545 digest (2026-11-24 about 01:50 to 03:30, Fable)

## What changed in the game (on main, exported; the S545 build)
- FIGHTS IS A WINDOW OF THE OFFICE COMPUTER (owner C498: "shouldnt this be inside the computer in the offece menu ?";
  9aa58d2fb): `Office.host` builds the desktop round the Fights list; the route stays `fights`; the dock app is named
  Fights; two bouts waiting to be picked lead the window; the road title wraps (it pushed the page 40 px past the
  screen); the office foot line sits on a dark strip (half of it could not be read, Mail too).
- NO POP-UP AFTER A DECISION (owner playing the S545 build: "this looks like AI slop" on the four-tile pop-up; "i clicked
  pick the first fight and the window doesnt go away"; "i select click the profile and this comes up . WTF happened to
  the playerprofile ?"; 108523632): `modals/ProNews.gd` is deleted. The profile's top card says what changed in plain
  was -> now words with the one pulsing next action (`WhatsNew.card`); the new bars carry NEW. The S544 pop-up's button
  navigated without closing it (a nav does not close a pop-up): `tests/test_jump_test.gd` now checks the click lands on
  Fights with nothing open.
- The Club page's tab reads Staff, not People (owner: "never seen People as description in a menu in a game , what
  happened to normal words like staff").
- C495 / C496 (his marks on the old pro call: too much text; "A simple You pay : 123456$ is enough ... use the fucking
  tooltip"): the S544 scene already answered them; the new pictures are on /review.

## Findings
1. CORNERCMD1 (095abdc73): FAIL bars 5, 6, 8 - and the core HOLDS: calling the right command at the right moment wins
   +9.7 (3 rounds) / +18.2 (6 rounds) more bouts in 100 than the plan alone, +10.3 / +13.3 over the best fixed pair; a
   wrong command held loses 22-39. Failed: Reset and Get out of there give wind back every exchange (checked:
   `Exchanges.gd:85` calm -3.0, `:70` long -0.5) so holding them is free rest (+14.6 / +23.9); the ring slider held is
   never right off Centre; the two boxers disagree on 2 commands of 4. -> CORNERCMD2 (four named changes, stop rule).
2. PLANWORTH1 (ac4cb322b): verdict (c), THE WRITTEN PLAN BARELY BEATS THE COACH'S: the best plan a player can write wins
   +1.7 in 100 over the coach's and +2.9 over no plan; the tape adds +1.2. The card promises +11.6 for the same plan
   (over-reads 4 to 7 times). One written line switches the coach's plan off (`BoutNight.gd:198-200`), not a trap today
   because the coach's plan is worth +1.2. Read beside finding 1: the depth of a fight is in the corner, live, not in
   the plan written before it. His S354 "make the fight plan fun to design" stands on a lever worth under 2 points.
3. BODYCROSS2 (98088087c): the body cross now meets him at 8.2-9.4 m/s with the elbow bent and goes 8-9 cm into him;
   the hit man folds and gives 19-25 cm. Why the old one read as a touch: the contact was the arm's furthest key; the
   film played it through `PunchAim`, which eases every glove onto its target at zero speed; the body target is a point
   5-7.5 cm in FRONT of the skin. The last two hold for every body punch in the 3D fight (found, not touched). The
   take is not wired into the 3D fight (no rule throws a body cross there).
4. Card model critics: Kalli real 6 / depth 5 / play 6 (nine turns of the walked bout fail; no knockdown, no posture,
   five turning points decided by a missing card), Dola 9 / 9 / 9. -> CARDROUND9B briefed. Arena's round 9 had stopped at
   00:31 on its tool-call limit with nothing pushed; restarted at 02:02, still not pushed at 03:05.
5. matchmaking_bots_test (red since the 11-23 nightly): the cause is DMGCLASS2 (e93158da7, `WorldBout.gd` PRO_FROM: pro
   bouts have no four-count bout limit). With the old limit restored in a worktree the test passes (smart 12.0, hard
   14.0; scouting -0.15 stoppages). The rule is right for pro boxing; reckless matchmaking is now punished too little.
   plan_templates_test is green on today's main.
6. John's four-arts memo: 4 of 41 sources opened (2 exact, 2 refused an automated read). Its audit waits.

## My misses
- The S545 export shipped the S544 pop-up bug to him again: my own render of the pro-pair jump SHOWED the pop-up over
  Fights and I took it for the jump's state instead of a bug. A picture with a pop-up over the wrong page is a defect
  until proven otherwise.
- I committed `questions.json` and `live_runs.json` re-indented (18,000 changed lines of noise).
- A `cd` in a Bash call moved the session folder once (memory S498 says not to).
- I left a parse error in `scripts/state/Data.gd` on the main checkout for 23 minutes (a comma inside a comment, in the
  Staff rename) while workers' probes ran there: my own four tests hung, and COACHDEEP9's cut run hung with it. An edit
  to a script every probe loads goes through the smallest test at once, before anything else - or in a worktree.

## Running at handover (console tabs of the S545 desktop session; Arena in the browser pane)
COACHDEEP9 (tab c2, since 02:21), CORNERCMD2 (tab c3, 03:05), KNOWBUILD1 (tab c4, 03:06, worktree
E:\FightCamp\wt\KNOWBUILD1, branch build/knowbuild1), Arena CARDROUND9. Finished tabs holding memory: BODYCROSS2 (c1),
and S544's CORNERCMD1 and PLANWORTH1 tabs. Temp worktree E:\FightCamp\wt\S545_NIGHTRED (branch s545/nightred, one
edited line, not committed): remove it.

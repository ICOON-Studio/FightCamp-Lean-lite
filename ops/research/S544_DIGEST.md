# S544 digest (2026-11-23 23:20 to 2026-11-24 about 02:00, Fable)

## What changed in the game (on main, exported twice; the second export holds everything below)
- TURNING PRO v17 MERGED (1b4862dbe, TURNPROBUILD17, owner "Yes, build v17 now"): one promoter, Not yet with patience,
  the rival gym's call, pro fights 1-6 as safe / risky pairs (`scripts/state/ProPair.gd`), confidence and hunger.
- THE FADE ANSWER ON THE CARDS (c2cead08e): a plan line "when the opponent tires" was added whole in the read's worth
  (+7 to +15 points shown; 60,000 real bouts paid +0.9). The tiring situation now walks the card chain at its fire
  share (`BoutRead._game_edge_of`, `_round_edges`). `tests/fade_read_test.gd`, red on the old code (15.1 and 20.1).
- THE OWNER PLAYED THE BUILD AND SENT FOUR NOTES; all four fixed (8d3ae3c1d):
  1. "this is still confusing and looks like spreadheet you need to use art" -> the call is a SCENE: `ProScene.gd` (the
     boxer in the signing office, the promoter's ticket), `modals/ProOffer.gd` rewritten as two choice cards with a
     painting and plain facts; details are hovers.
  2. "i click turn pro now , i expect to see what changed , bring up the players profile show me what is new" -> the
     click opens the profile with the pop-up `modals/ProNews.gd` (before -> after tiles from `WhatsNew.gd`) and NEW marks
     on the profile (`ProBars.mark`, while the route carries `new`).
  3. "wtf is this why half the screen isout of bounds ?" -> v17's page-wide TURNING PRO card is gone; confidence and
     hunger are two bars under loyalty (`ProBars.gd`), their height taken from the picture. `tools/jump_snapshot.gd`:
     renders any test jump (+ `then=<act>:<arg>`) and prints BOUNDS when a card is cut by the bottom of the screen
     (proved red on the old layout). A HEADLESS run gives wrong page sizes: use it on the hidden desktop with --log.
  4. "i click mail and i am not inside the computer in the office screen ?" -> the `mail` act opens the office
     computer's Mail window (`OfficeMail.gd`, `Office.open_mail`), from the top bar and the dock.
- FIGHT PICTURES (PICSFIX1, d935da31d, owner "Yes, fix them now"): a gate in the picture tool; both sets re-rendered;
  0 of 96 punch pictures over a bar (10 of 48 before). Gap: a blocked body punch ends on the forearm at chest height
  (no elbow-down block clip exists in the game).
- BOARD: four jump buttons (Pro: the call / safe or risky / rival gym calls / hunger gone): `TestJump` jumps `propair`,
  `prorival`, `prohunger`; `launch_targets.json`; `register_play_tasks.ps1` (run).
- Four over-long tooltips from S541/S543 fixed (office bills, nationals, club show hover as a card, fight-week load).

## Findings
1. TELLPLAY1: FAIL bar 1 (0 of 10 types). Making the opponent play a tell's situation more (x1.5, +10 points of share)
   moves a player's line 0.1-0.8 points in the ring. Rule A is not built. Two corrections to the worker's "why", read in
   code: a 58 coach reads ONE card (`CoachPlan.READ_AT` [50, 70]); the coach writes only when the player's plan is empty
   (`BoutNight.gd` l.197) - the probe's arm (coach + one line) may not exist in the game. Not known: what a WHOLE plan the
   player writes is worth today against the coach's -> PLANWORTH1 (running). The owner's S354 "make the fight plan fun to
   design" stands on that number. I drafted an owner page on the worker's "why" before checking it and deleted it.
2. COACHES v8: FAIL 4 of 7 (bars 1, 2, 3; v7 failed 1, 3, 5). The cheap local is best in 7 of 10; back-the-coach 8 of
   10; refuse-the-push 8 of 10. Bar 1 is a card priced against his own Q17; bar 2 is the probe's careful line punishing
   itself; bar 3 is the design -> `TASK_COACHDEEP9.md` with a STOP RULE (a moment that fails again is cut as a decision).
3. CARD GAME: John's memo (sources: three exact, two not opened) -> CARDAUDIT1 in 12 minutes: 83 rows, REAL 60, WRONG
   18, MISSING-LINK 5; 22 missing options (15 needed); the new model (each fighter's own position, eight legal pairs,
   getting up ends the volley) is 1.14 x today's size; a whole bout walked clean -> `CARDREAL_AUDIT.md`.
4. v17 by design: a strong boxer's "today" and "four weeks on" odds are the same (the promoter finds a harder man). The
   new Not yet card says so in one line ("Same odds in 4 weeks").
5. Expedition 33 for the 3D fight (owner's question): the staging (each exchange a short staged clip with a cut) fits and
   would sidestep our animation joins; a timed WINDOW fits the corner commands; player-timed dodges do not (the player is
   the corner). On the map for the 3D phase; nothing started (mechanics first).

## My misses this session
- I opened TURNPROBUILD17's five stills before merging and noted only a wording point. The owner then called the pop-up a
  spreadsheet and found the profile off the screen. A worker-built screen is checked against "a scene with art" and
  "nothing cut by the screen" before it is merged; `tools/jump_snapshot.gd` does the second.
- My first off-screen check was blind (it skipped scroll areas): I ran it on the old layout, saw it pass, and fixed it.

## Running at handover (console tabs of the S544 desktop session; Arena in the browser)
CORNERCMD1 (tab c3, owner "yes start the probe"), PLANWORTH1 (tab c4), Arena CARDROUND9 (chat 01a20a6d-3a1b-79dc-a475-
e858f591a0d9, branch arena/f591a0d9-fightcamp-lean-lite). Seat queue: SQ319 John (four more arts), SQ320 Dola and SQ321
Kalli (the card model). Briefed, not launched: COACHDEEP9.

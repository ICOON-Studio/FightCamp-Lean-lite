# S548 handover (written 2026-11-24, S547 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S547_DIGEST.md.

## METHOD lines - quote all of them in your first message
- A DECISION SCREEN IS A SCENE; AFTER THE CLICK THE PAGE ITSELF SHOWS WHAT CHANGED - NO POP-UP, NO ICON TILES (owner
  S544: "looks like spreadheet you need to use art"; S545: "this looks like AI slop", "the window doesnt go away").
  Patterns: `scripts/ui/ProScene.gd`, `modals/ProOffer.gd`, `WhatsNew.card`, `ProspectScene.gd`, `modals/Prospect.gd`.
- LITTLE TEXT (owner S545: "you do not need to spell everything out for the player"; "A simple You pay : 123456$ is
  enough , if more things are needed use the fucking tooltip"). A hover card: 10 words a sentence, 14 for a plain line
  (`Tip.gd`; `tooltip_standard_test` fails on a longer one).
- PLAIN MENU WORDS; THE PLAYER'S PLACE IS THE GYM (owner S545). Other boxers' clubs and "club show" keep the word.
  The gym's history window is Log; Records is for fighters and coaches (owner S546).
- EVERYTHING OFFICE-LIKE IS A WINDOW OF THE OFFICE COMPUTER (`Office.HOSTED`; a hosted window is 756 px tall).
- THE PLAYER BOOKS WHEN HIS BOXERS ARE READY (owner S546): never a line that tells him to wait.
- NOTHING CUT BY THE SCREEN: `tools/jump_snapshot.gd` on the hidden desktop with `--log=<file>`, through
  `godot_slot.py`; `then=<act>:<arg>` plays an act after the jump (`then=go:money:0` = Finance, `then=go_btn:` = the
  top bar's button).
- ORDER (owner S542): pending mechanics first, THEN 3D and menus. His own play notes on a screen are fixed at once.
- THE FIGHT'S DEPTH IS IN THE CORNER, LIVE: reading the moment +15 (3 rounds) to +22 (6 rounds) wins in 100
  (CORNERCMD2) - measured against a coach's call that is blind to the opponent (see CORNERBASE1 below). The best
  written plan +1.7 over the coach's (PLANWORTH1). No design round on the written plan before his answer to Q-328.
- MECHANICS NEED 8 (owner S534), probe first, then a code-checked critic, then the chat critics. A WORKER'S NUMBERS CAN
  BE RIGHT AND ITS WHY WRONG: open the code lines first. A DESIGN THAT KEEPS FAILING gets a stop rule or an interview.
- CARD GAME, REAL FIGHT FIRST. FIGHT ANIMATION: v2 only, no new correction layer; THE OWNER'S EYE IS THE RULER.
  AGENTS ONLY IN THE CONSOLE (`claude_cm.ps1` through `mcp__terminal__run_in_terminal`, at most 3). HIS GAME FIRST.
  Board questions 20 words max, options 5 words max, a text note 4 lines of 120 characters at most.
  Commit by pathspec (workers edit this same checkout); a script with an apostrophe goes in a file; write JSON the way
  the file was; `(cd ops && ...)` - a bare `cd` moves the session folder.

## FIRST: his answers (the board prints them at start; quote each)
- Q-328 "A written fight plan adds 2 wins in 100; live corner calls add 10 to 18. Shrink the plan screen?"
- Q-329 "Coach trial week is the wrong buy in 9 of 10 gyms. Cut it, show chemistry on the hire card?" After his
  answer: ONE clean coach map (v9 as cut) written from the code by Arena, with the table of every menu it appears on;
  then a code-checked critic, then Kalli and Dola. No v10 on numbers.
- Q-330 "Corner ring calls (Cut the ring off, Stay off the ropes) add 0 wins in two probes. Cut them?" My pick: cut
  both from the corner (the ring already pays in the plan's step lines).
- His notes on /review (the signing card stills, the body cross 3 sheets) and his play of the S547 build
  (WHAT_TO_TRY O to S).

## SECOND: collect what was running at the handover (see "Workers" at the foot for what landed in S547)
1. PLANREAD2 (Opus, tab c1 of the S547 session, launched 05:50) -> `docs/PLANREAD2_RESULT.md` on main (it commits
   its own paths). Check the cause sentence against the code lines, the held-out error, the before/after table.
2. STAFFCARDS1 (Opus, tab c2, launched 05:52) -> `E:\FightCamp\wt\STAFFCARDS1`, branch `build/staffcards1`,
   `docs/STAFFCARDS1_RESULT.md` there. Open its three stills beside `docs/mockups/s546/staff_cards.png`: cards, a
   face or a silhouette, four facts, one button, no scroll, NEW after a hire, nothing cut. Merge by diff:
   `git diff --binary main...build/staffcards1 > p.patch && git apply --3way p.patch`, resolve, its tests, export.
3. BODYREACT2 (Fable, tab c3, launched 06:02) -> `docs/BODYREACT2_RESULT.md` on main; films and the sheet on /review.
   Check on its own pictures: the hit boxer folds 10 deg or more on three pictures; head reactions unchanged (its
   control arm); `player2_test` green.
4. Arena CARDROUND9 (https://arena.ai/agent/01a20a6d-3a1b-79dc-a475-e858f591a0d9, built-in browser pane): out of usage
   on 11-24. Its branch is pushed (FightCamp-Lean-lite, arena/f591a0d9-fightcamp-lean-lite, e0e15a796): 61 tests green,
   play gate 4 of 6 (boxing 77.5 v jiu-jitsu 22.5; 21.0 decisions a bout against 22.5-45). When its limit resets:
   Keep working, "find the rule behind 77/23 by walking two bouts from each side; no balancing number". PR -> CI log,
   `ci_arena.py guard`, apply the diff, `lite_mirror.py push`, then a NEW chat on `TASK_CARDROUND9B.md`.

## THIRD: CORNERBASE1 (write the brief, launch an Opus worker)
CORNERCMD2 failed bar 8 because the baseline is weak, not because a command is too strong:
`BoutRules.auto_corner(stats)` (l.383) returns "long" or "body" from our boxer's stats alone. It never reads the
opponent (it says "Go to the body" against a man who loads up: the wrong call, `Exchanges.MODES.loadup.wrong`) and it
never rests a boxer at 0 wind. The same call is what a player who sims the bout gets (`BoutNight.gd` l.128,
`BoutRead.gd` l.216, `BalanceHarness`). The brief: (a) a coach's call that reads the opponent's game and rests a tired
boxer, built from the eight commands (no ring calls if Q-330 says cut); (b) the CORNERCMD2 probe again with that as the
baseline: the reader's edge over it is the honest worth of the live corner; (c) what it does to a simmed bout's
results (the balancing tests that use `auto_corner`). `## Feedback loops`: the coach's call feeds the read
(`BoutRead` l.216) and the sim. Then the code-checked critic on the eight commands, then Kalli and Dola.

## Then
- NIGHTREDS: `matchmaking_bots_test` (a probe makes reckless matchmaking cost again, or the margins are re-set with
  the reason written); `face_frame_test` (the offer page's opponent slot cuts `mh_boxer_13` 1 px at the chin:
  `OfferOpp/OppArt/Body`, 330x640); `move_tip_test` and `block_meet_test` are animation rulers (old player: say so in
  the test list or move them out as MOTIONRULERS1 did).
  The temp worktree `E:\FightCamp\wt\S545_NIGHTRED` is still there: ask him to allow its removal.
- KNOWBUILD2: the got-away boxer's return bout (`ProspectWire.got_away` rows are there for it).
- DEPTH1 (sponsorship as one budget across the boxers; the loan's timing). PROGBUILD1 rides on coaches.
- The offer page, the trial evening: the question cards borrow a man's 3D picture for a woman prospect (KNOWBUILD1
  generated no art): four small paintings from Ludo would fix it.

## Waiting on the owner
- Q-328, Q-329, Q-330; his eye on /review; his play of the S547 build.
- The finished worker tabs of earlier sessions hold memory: he closes them, or says yes to closing them.

## Model for S548
Opus, medium effort, Fast off, if only collections and the CORNERBASE1 brief remain; Fable if the staff cards come
back needing a design eye.

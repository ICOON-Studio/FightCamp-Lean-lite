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

## SECOND: collect what was running at the handover (tabs of the S547 session; STAFFCARDS1 already landed and is merged)
1. PLANREAD2 (Opus, tab c1 of the S547 session, launched 05:50) -> `docs/PLANREAD2_RESULT.md` on main (it commits
   its own paths). Check the cause sentence against the code lines, the held-out error, the before/after table.
2. CORNERBASE1 (Opus, tab c4, launched 06:33, 3-4 h) -> `docs/CORNERBASE1_RESULT.md` on main, the coach's table in
   `ops/research/DESIGN_CORNERBASE1.md` (committed before any run: 33e8fbb4b). Brief `TASK_CORNERBASE1.md`. The number
   for the owner: the reader minus FILE+SKILL 58 = the honest worth of the live corner. Check its control (280 bouts
   identical to CORNERCMD2) and that no coach arm peeks at the exchange before it is played. Then the code-checked
   critic on the eight commands, then Kalli and Dola. John's research on real corners: `CORNERREAL1_JOHN_JOHN.md`
   (seat queue SQ322; `start` prints it under SEAT ANSWERS).
3. BODYREACT2 (Fable, tab c3, launched 06:02) -> `docs/BODYREACT2_RESULT.md` on main; films and the sheet on /review.
   Check on its own pictures: the hit boxer folds 10 deg or more on three pictures; head reactions unchanged (its
   control arm); `player2_test` green.
4. Arena CARDROUND9 (https://arena.ai/agent/01a20a6d-3a1b-79dc-a475-e858f591a0d9, built-in browser pane): out of usage
   on 11-24. Its branch is pushed (FightCamp-Lean-lite, arena/f591a0d9-fightcamp-lean-lite, e0e15a796): 61 tests green,
   play gate 4 of 6 (boxing 77.5 v jiu-jitsu 22.5; 21.0 decisions a bout against 22.5-45). When its limit resets:
   Keep working, "find the rule behind 77/23 by walking two bouts from each side; no balancing number". PR -> CI log,
   `ci_arena.py guard`, apply the diff, `lite_mirror.py push`, then a NEW chat on `TASK_CARDROUND9B.md`.

## THIRD: launch MATCHBOTS2 (brief written, `ops/research/TASK_MATCHBOTS2.md`, Opus worker) when a tab frees
`matchmaking_bots_test` is red since pros can be stopped (the rule is right): the bot that SCOUTS is stopped more often
than the one that does not (0.91 v 0.77), because the tape only makes it braver (`SCOUTED_RISK`). If the player's screen
shows the opponent's punch, the bot prices it; if it does not, that is a gap in the read to bring to the owner.

## Then
- NIGHTREDS left after S547: `matchmaking_bots_test` (MATCHBOTS2 above); `move_tip_test` and `block_meet_test` are
  animation rulers of the old player (say so in the test list or move them out as MOTIONRULERS1 did). `face_frame_test`
  is green again (the offer page keeps the head box inside its slot: `OfferSides._keep_head`).
  The temp worktree `E:\FightCamp\wt\S545_NIGHTRED` is still there: ask him to allow its removal.
- STAFFCARDS1 is MERGED AND EXPORTED (fe3b9fcff; `scripts/ui/StaffDesk.gd`, `StaffDeskCard.gd`; stills on /review).
  If his eye wants changes: the card is `StaffDeskCard.build`, the rows `StaffDesk.page`. Its worktree
  `E:\FightCamp\wt\STAFFCARDS1` sits detached on main (I exported from it); the retire job takes it.
- EXPORT WHILE WORKERS EDIT THE MAIN CHECKOUT: export from a clean seeded worktree
  (`git -C <wt> checkout --detach main`, then `OUT=/e/FightCamp/Lean/Builds sh tools/export.sh` from it). The package is
  24 MB smaller that way: main's export packs untracked trial folders (assets/ui/style_b/_trial*, portraits_v1_refbleed,
  assets/anim/af_retarget, baked/ailive_trial) - move or ignore them.
- KNOWBUILD2: the got-away boxer's return bout (`ProspectWire.got_away` rows are there for it).
- DEPTH1 (sponsorship as one budget across the boxers; the loan's timing). PROGBUILD1 rides on coaches.
- The offer page, the trial evening: the question cards borrow a man's 3D picture for a woman prospect (KNOWBUILD1
  generated no art): four small paintings from Ludo would fix it.

## Waiting on the owner
- Q-328, Q-329, Q-330; his eye on /review (signing card, staff cards, body cross 3); his play of the S547 build
  (second export 06:31, WHAT_TO_TRY O to T).
- The finished worker tabs of earlier sessions hold memory: he closes them, or says yes to closing them.

## Model for S548
Fable, medium effort, Fast off: BODYREACT2's films need an eye and his notes on the staff cards and the signing card
are design work. Opus is enough if only the two probe collections remain.

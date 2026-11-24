# S547 handover (written 2026-11-24 about 04:20, end of S546 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S546_DIGEST.md.

## METHOD lines - quote all of them in your first message
- A DECISION SCREEN IS A SCENE; AFTER THE CLICK THE PAGE ITSELF SHOWS WHAT CHANGED - NO POP-UP, NO ICON TILES (owner
  S544: "looks like spreadheet you need to use art"; S545: "this looks like AI slop", "the window doesnt go away").
  Pattern: `scripts/ui/ProScene.gd`, `modals/ProOffer.gd`, `WhatsNew.card`, `ProBars.mark`.
- LITTLE TEXT (owner S545: "you do not need to spell everything out for the player"; "A simple You pay : 123456$ is
  enough , if more things are needed use the fucking tooltip").
- PLAIN MENU WORDS; THE PLAYER'S PLACE IS THE GYM (owner S545: "i do not understand whatis club and what is gym";
  "what happened to normal words like staff"). Other boxers' clubs and "club show" keep the word.
- EVERYTHING OFFICE-LIKE IS A WINDOW OF THE OFFICE COMPUTER: Mail, Fights, and since S546 Staff, Finance, Records
  (`Office.HOSTED`, `Office.host`; a hosted window is 756 px tall - taller leaves the screen with the guide strip up).
- THE PLAYER BOOKS WHEN HIS BOXERS ARE READY (owner S546, C503: "why you tell the player when the next offer is ? the
  player should be able to book a fight any time his fighters are ready"): never a line that tells him to wait.
- NOTHING CUT BY THE SCREEN: `tools/jump_snapshot.gd` on the hidden desktop with `--log=<file>`, through
  `godot_slot.py` (its BOUNDS lines go to the log, not to the console). `then=go:gym:1` works since S546.
- ORDER (owner S542): pending mechanics first, THEN 3D and menus. His own play notes on a screen are fixed at once.
- THE FIGHT'S DEPTH IS IN THE CORNER, LIVE: reading the moment +10 to +18 wins in 100 (CORNERCMD1); the best written
  plan +1.7 over the coach's (PLANWORTH1). No design round on the written plan before his answer to Q-328.
- MECHANICS NEED 8 (owner S534), probe first, then a code-checked critic, then the chat critics. A WORKER'S NUMBERS CAN
  BE RIGHT AND ITS WHY WRONG: open the code lines first. A DESIGN THAT KEEPS FAILING gets a stop rule or an interview.
- CARD GAME, REAL FIGHT FIRST. FIGHT ANIMATION: v2 only, no new correction layer; THE OWNER'S EYE IS THE RULER (a bar is
  read on the pictures he sees, not on a key between them). AGENTS ONLY IN THE CONSOLE (`claude_cm.ps1` through
  `mcp__terminal__run_in_terminal`, at most 3). HIS GAME FIRST. Board questions 20 words max, options 5 words max.
  Commit by pathspec (workers edit this same checkout: never sweep `tools/`); a script with an apostrophe goes in a
  file (the Bash tool breaks a heredoc on it); write JSON the way the file was.
- THE PC IS SHORT OF MEMORY beside three workers (RED at 97% in S546): tests with JOBS=1, one batch, never 14 at once.

## ADDED AFTER THE HANDOVER (owner, 04:25)
- BOARD QUESTIONS: 3-4 LINES, EVERYTHING HE SEES (owner: "your questions onthe board cannot exceed 3-4 lines , please
  neve3r use wall of text formeto waste 8 hours reading"). Two S546 questions carried a 37 KB result file under them.
  `ask` now refuses a text attachment over 4 lines of 120 characters; pictures are fine. The same in chat: short.
- Q-327 ANSWERED: "Top bar CONTINUE". His note was "wtf is the week preview button doing and showing ?": the button
  reads "CONTINUE / to Mon 12 Jan, week review". Make it plain what a click does and where it stops (two or three
  words on the button, the rest on hover), then show him the still.
- FIXED, NOT EXPORTED (he was playing): on Finance > Dues the pictures were drawn over the "Change dues?" pop-up
  (`Main._modal_layer.z_index`). Export first thing, once his game is closed.

- LOG, NOT RECORDS (owner, 04:40: "Name this \"Log\" for this screen ,Records goes for the fighters and coaches"): the
  gym's history window is Log (dock, window bar, tab). DONE, not exported. "Records" is now free for the fighters' and
  the coaches' own records (win-loss, bouts): use that word there, never for the gym's history.

## FIRST: his answers (the board prints them at start; quote each)
- Q-327 which screen has the "week preview" button. No label says it; my guess is the top bar's CONTINUE ("to Mon 12
  Jan, week review") or the week review it opens. Fix what he names, at once.
- Q-328 "A written fight plan adds 2 wins in 100; live corner calls add 10 to 18. Shrink the plan screen?" Do not
  propose a redesign before his answer.
- Q-329 "Coach trial week is the wrong buy in 9 of 10 gyms. Cut it, show chemistry on the hire card?" (his interview
  answer 7). After his answer: ONE clean coach map (v9 as cut: the hire with one wage rule, the raise, the style push,
  the course, the corner pick; the falling-out is the game's own rule) written from the code by Arena, with the table
  of every menu it appears on; then a code-checked critic, then Kalli and Dola. No v10 on numbers.
- His notes on the S546 stills on /review, and his play of the S546 build (WHAT_TO_TRY J to N).

## SECOND: collect
1. KNOWBUILD1 LANDED 04:09: `E:\FightCamp\wt\KNOWBUILD1`, branch `build/knowbuild1`, `docs/KNOWBUILD1_RESULT.md` there.
   Open its four stills and check: a scene, no pop-up, no icon tiles, little text, nothing cut, the click lands where the
   change lives. Merge by DIFF. S546 changed words in files it also edited (`scripts/ui/RosterActs.gd`,
   `scripts/ui/WhatsNew.gd`, perhaps `Sim.gd`): apply its hunks by hand there, keep "gym stipend" / "(Staff)". Its new
   signing text must say gym, not club. Then its tests + `know_reads_test`, export.
2. BODYCROSS3 (tab c1 of the S546 session, started 03:59, 2-3 h) -> `docs/BODYCROSS3_RESULT.md`, the sheet and films on
   /review. Check yourself, on the sheet's own pictures: a bent elbow in three pictures, the hit man bent in three.
3. CORNERCMD2 (tab of the S545 session, due about 05:15) -> `docs/CORNERCMD2_RESULT.md`. PASS -> a code-checked critic
   FIRST, then Kalli and Dola. FAIL -> its stop rule: the facts to him.
4. Arena CARDROUND9 (https://arena.ai/agent/01a20a6d-3a1b-79dc-a475-e858f591a0d9 in the built-in browser pane):
   continued 03:53 on the play gate (boxing 86% v jiu-jitsu 14%: find the rule, no balancing number). If it shows "Was
   this task successful?": Keep working, then a message in its box. PR -> CI log, `ci_arena.py guard`, apply the diff,
   `lite_mirror.py push`, then a NEW chat on `TASK_CARDROUND9B.md`.
5. The 05:00 full tests ran on S546's tree: read `ops/AgentComms/nightly/latest.txt`; the wording change touched 60
   files (about 75 tests were run by hand, all green) - any NEW red with "club" in its words is mine to fix.

## THIRD: build the staff screen as cards (his "this screen is terrible", owed since S545)
Spec: `docs/mockups/s546/staff_cards.png` (+ .html) - on /review for his eye; build it unless he says otherwise.
- A new `scripts/ui/StaffDesk.gd` (StaffCard.gd is at 493 lines): AT THE GYM and JOBS OPEN, cards about 320 x 300 with
  the face (PromoShot.picture) and the name over it, the job in plain words, at most four facts, one button; details
  (the five area bars, tactics, film checks) on hover (`Tip.explain`). No borrowed faces on open jobs: a silhouette.
- Data: `OfficeDesk.staff_sheet(c)` already has every row (you, coach or the two for hire, the four jobs, evening).
  Acts: `hire` <coach id>, `hirerole` / `letgorole` <id>. Keep the node names tests use where the thing survives
  (`PeoplePage`, `HeadCoachRow`, `Assistant_<id>`, `Hire_<id>`, `Role_<id>`, `BoxerLine`).
- It must fit the 756 px window with no scroll: then put `_fits` in `tests/coach_areas_test.gd` back to "no scroll".
- Members / reputation / dues tiles leave the staff screen only if they are shown elsewhere (Finance has members).
- Decide and do: the dock's Staff icon opens the cards (the sheet stays under Fighters), or keep the sheet first.
  Say which and why.

## Then
- Launch PLANREAD2 (`ops/research/TASK_PLANREAD2.md`, Opus worker) when a tab frees.
- Two confidences on one profile: the bar CONFIDENCE (54) and the MIND attribute "Confidence" (51). One name for two
  things: rename the attribute ("Self-belief") or start the bar from it at signing. Decide, do, tell him.
- NIGHTREDS: `matchmaking_bots_test` red since DMGCLASS2 took the four-count limit out of pro bouts (the rule is
  right): a probe makes reckless matchmaking cost again, or the margins are re-set with the reason written.
  The temp worktree `E:\FightCamp\wt\S545_NIGHTRED` is still there (`git worktree remove --force` was refused in S546;
  its one-line proof is saved in `E:\FightCamp\wt_salvage\S545_NIGHTRED`): ask him to allow it or remove it himself.
- One cut text on Finance: the Club show row ends in "..." inside the narrower window (LITTLE TEXT: shorten the line,
  the rest on hover).
- DEPTH1 (sponsorship as one budget across the boxers; the loan's timing). PROGBUILD1 rides on coaches.

## Waiting on the owner
- Q-327, Q-328, Q-329; his eye on /review; his play of the S546 build.
- The finished worker tabs of the S544 / S545 sessions hold memory (the PC went RED at 97%): he closes them, or says
  yes to closing them.

## Model for S547
Fable, medium effort, Fast off: the staff cards are design + build to his taste, and the body cross sheet needs an
eye. Opus is enough if only collections remain.

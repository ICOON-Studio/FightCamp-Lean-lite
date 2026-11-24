# S546 handover (written 2026-11-24 about 03:30, end of S545 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S545_DIGEST.md.

## METHOD lines - quote all of them in your first message
- A DECISION SCREEN IS A SCENE; AFTER THE CLICK THE PAGE ITSELF SHOWS WHAT CHANGED - NO POP-UP, NO ICON TILES (owner
  S544: "looks like spreadheet you need to use art"; S545 on the four-tile pop-up over the profile: "this looks like AI
  slop", "the window doesnt go away"). Pattern: `scripts/ui/ProScene.gd`, `modals/ProOffer.gd`, `WhatsNew.card` (the
  profile's top card: a title, one line, plain was -> now words, the one pulsing next action), `ProBars.mark`.
- LITTLE TEXT (owner S545: "you do not need to spell everything out for the player"; "A simple You pay : 123456$ is
  enough , if more things are needed use the fucking tooltip").
- PLAIN MENU WORDS (owner S545: "i do not understand whatis club and what is gym"; "never seen People as description in
  a menu in a game , what happened to normal words like staff").
- EVERYTHING OFFICE-LIKE LIVES IN THE OFFICE COMPUTER (owner: Mail S544, Fights S545 "shouldnt this be inside the
  computer in the offece menu ?"). Pattern: `Office.host` (the Fights area builds the desktop round its list).
- NOTHING CUT BY THE SCREEN: `tools/jump_snapshot.gd` on the hidden desktop with `--log`, through `godot_slot.py`. A
  PICTURE WITH A POP-UP OVER THE WRONG PAGE IS A BUG, not the jump's state (S545 miss).
- ORDER (owner S542): pending mechanics first, THEN 3D and menus. His own play notes on a screen are fixed at once.
- THE FIGHT'S DEPTH IS IN THE CORNER, LIVE (S545 measured): reading the moment pays +10 to +18 wins in 100
  (CORNERCMD1); the best written plan pays +1.7 over the coach's (PLANWORTH1). No design round on the written plan
  before he has heard these two numbers.
- MECHANICS NEED 8 (owner S534), probe first, then a code-checked critic, then the chat critics. A WORKER'S NUMBERS CAN
  BE RIGHT AND ITS WHY WRONG: open the code lines first. A DESIGN THAT KEEPS FAILING gets a stop rule or an interview.
- CARD GAME, REAL FIGHT FIRST. FIGHT ANIMATION: v2 only, no new correction layer. AGENTS ONLY IN THE CONSOLE
  (`claude_cm.ps1` through `mcp__terminal__run_in_terminal`, at most 3). HIS GAME FIRST. Board questions 20 words max.
  Commit by pathspec; never `cd` in a Bash call without coming back; write JSON the way the file was (no re-indent).

## FIRST: his two open play notes (he was playing the S545 build when the session ran out of room)
1. THE CLUB PAGE, verbatim: "i do not understand whatis club and what is gym, this screen is terrible , never seen
   People as description in a menu in a game , what happened to normal words like staff ." Done in S545: the tab reads
   Staff (tests were still running at handover: check the last commit's message). OWED:
   (a) one word for the player's place in every menu: the gym (the page header CLUB, the hub pin "Club office", the
       handbook's "Club"; `Data.AREAS`, `GymHub.gd`, `HandbookPanel.gd`; tests name some of these);
   (b) the three Club pages (Staff, Money, Records) as windows of the office computer, the way Fights is (the dock
       already has Staff, Finance, Records; the generic way is in `Shell.refresh`: host the area node inside
       `Office.host`'s box and skip the area head; watch page widths, 200 px narrower);
   (c) the staff screen itself ("terrible"): redo it as cards with a face, the role in plain words, at most four
       facts and one button each - after COACHDEEP9 lands (the card's content depends on it). Scope it, picture it,
       check it yourself against the METHOD lines before he sees it.
2. "wtf is the week preview button doing and showing ?" - NOT FOUND by name in `scripts/ui` (no label says "preview";
   candidates: the top bar CONTINUE "to Mon 12 Jan, week review", the week review pop-up, the training page's night
   bar `NightBar.gd` / `TrainingPreview`). Ask him which screen in one short line, or find it from his next screenshot.

## SECOND: collect (result files; the tabs belong to the S545 desktop session)
1. COACHDEEP9 (tab c2) -> `docs/COACHDEEP9_RESULT.md`. Its STOP RULE is yours to apply: a forced moment that fails bar 3
   again is cut as a player decision; no v10. NOTE: its cut run hung at 03:01 on a parse error I left in
   `scripts/state/Data.gd` from 02:52 to 03:15 (fixed, never committed). The owner said "Yes, stop it": the stuck Godot
   run was stopped at 03:25 and the worker re-ran it by itself (a 1-rep check, then the full cut run, about 32 minutes).
   CORNERCMD2's full run started at 03:15:20, after the fix.
2. CORNERCMD2 (tab c3) -> `docs/CORNERCMD2_RESULT.md`. PASS -> launch a code-checked critic FIRST, then Kalli and Dola.
   FAIL -> its stop rule: the facts to him, his design (the ring slider: "cut it as a held slider, keep the two ring
   calls as moment answers, or cut both").
3. KNOWBUILD1 (tab c4, worktree `E:\FightCamp\wt\KNOWBUILD1`, branch `build/knowbuild1`) -> `docs/KNOWBUILD1_RESULT.md`
   on the branch. Merge by diff ONLY after you open its four stills and check: a scene, no pop-up, no icon tiles, little
   text, nothing cut, the click lands where the change lives.
4. Arena CARDROUND9 (chat https://arena.ai/agent/01a20a6d-3a1b-79dc-a475-e858f591a0d9, the built-in browser pane;
   branch arena/f591a0d9-fightcamp-lean-lite not pushed at 03:05). If it stopped on its tool-call limit again: type
   "continue" in its box. When its PR relays: CI log, `ci_arena.py guard`, apply the diff, `lite_mirror.py push`, then
   a NEW Arena chat on `ops/research/TASK_CARDROUND9B.md`. Then play both arts by hand.
5. BODYCROSS2 landed (98088087c): films and stills on /review ("Body cross: reaches and hurts"). His eye closes it.
   Open follow-up, a scope call: every body punch in the 3D fight stops dead on a target 5-7.5 cm in front of the skin
   (`PunchAim`); that is the v2 player's finish, so it is a FIGHTPLAYER2 item, not a patch.

## THIRD: tell him the two numbers, then one design conversation (Fable)
In plain words: (1) a fight plan written before the bout is worth about 2 more wins in 100 than the coach's own; the
card shows about 12 (wrong by 4 to 7 times: a defect to fix in the read whatever he decides); (2) shouting the right
command at the right moment in the fight is worth 10 to 18. Ask ONE thing: whether the pre-fight plan stays a big
screen to design, or shrinks to the coach's plan plus one or two picks while the corner becomes the game. Do not
propose a redesign before his answer.

## Then, in his order (mechanics first)
- NIGHTREDS: `matchmaking_bots_test` is red because DMGCLASS2 took the four-count bout limit out of pro bouts
  (`WorldBout.gd` PRO_FROM); proven in a worktree. The rule is right; make reckless matchmaking cost again (what a
  stoppage loss does to a pro: weeks out, the place lost) by a probe, or re-set the test's margins with the reason
  written. `ops/research/TASK_NIGHTREDS1.md` holds the note. Remove the temp worktree `E:\FightCamp\wt\S545_NIGHTRED`
  (`git worktree remove --force`, then delete branch `s545/nightred`).
- DEPTH1 (sponsorship as one budget split across the boxers; the loan's timing). PROGBUILD1 rides on coaches.
- The read over-reads a written plan 4 to 7 times (PLANWORTH1): fix `BoutRead` the way the fade answer was fixed in
  S544 (walk the card chain at its fire share), with a test red first.
- Card game: John's four-arts memo waits for boxer against jiu-jitsu to pass its critics.

## Waiting on the owner
- His eye on /review: the turning pro call after his two marks; Fights inside the office computer; the body cross.
- His play of the S545 build (WHAT_TO_TRY leads with G and H).
- Finished worker tabs hold memory (BODYCROSS2 c1; S544's CORNERCMD1 and PLANWORTH1): he said "Yes, close them" for
  eight on 2026-11-24; ask again before closing others.

## Model for S546
Fable, medium effort, Fast off: the Club page work is design + build to his taste, and the plan-versus-corner
conversation needs it. Opus is enough if only collections remain.

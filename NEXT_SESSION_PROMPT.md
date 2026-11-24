# S551 handover (written 2026-11-24, S550 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S550_DIGEST.md.

## METHOD lines - quote all of them in your first message
- ## METHOD - CARD GAME: ONE ART AGAINST ITSELF FIRST (owner S549: "the real test should be a boxer vs boxer , donot
  mix classes untill all arts cards are ingame"). No work on the mixed boxing v jiu-jitsu game (`proto/cardgame/`).
- ## METHOD - CARD GAME: VERSION 3 IS RANGE, NO MORE PATCH ROUNDS ON VERSION 2 (S550: two code-checked critics, 5/6/6
  then 6/5/7, both put "no range" first). Plan and bars: `ops/research/CARDRANGE_SCOPE_S550.md`. Phase 0 is HIS PLAY of
  version 2 (phone: https://claude.ai/artifact/RVECDqN7dwM9NLGVqQjQxq ; PC: preview `boxcards`, port 8798): read his
  notes before writing version 3. Do not tune version 2's numbers (head bar, breather price, leads a round).
- A DECISION SCREEN IS A SCENE; AFTER THE CLICK THE PAGE ITSELF SHOWS WHAT CHANGED - NO POP-UP, NO ICON TILES; LITTLE
  TEXT; PLAIN MENU WORDS; OFFICE-LIKE PAGES ARE WINDOWS OF THE OFFICE COMPUTER; THE PLAYER BOOKS WHEN HIS BOXERS ARE
  READY (owner S544-S546).
- ORDER (owner S542): pending mechanics first, THEN 3D and menus.
- THE WRITTEN PLAN STAYS AND MUST MATTER (owner Q-328 "make it more impactful"; Q-333 S550 "Second probe"). Never
  propose shrinking the plan screen. PLANIMPACT1 and PLANIMPACT2: nothing passed (see FIRST 1).
- COACHES: NO TRIAL WEEK, CHEMISTRY ON THE HIRE CARD (Q-329); Q-334 S550 "Probe the changes" -> COACHMAP2, AFTER
  PLANIMPACT2. ONE RULE IS NOT SOLD TWICE (the plan and the coach both want to sharpen a corner command).
- THE CORNER HAS EIGHT COMMANDS AND NO RING SLOT (Q-330 "Cut both").
- MECHANICS NEED 8 (owner S534), probe first, then a code-checked critic, then the chat critics. MEASURE A CRITIC'S
  RULE BEFORE IT GOES ON. THE BOT MUST USE WHAT IS BUILT. A one-bout trial before every table.
- FIGHT ANIMATION: v2 only, no new correction layer; THE OWNER'S EYE IS THE RULER.
- HIS GAME FIRST: while ArcheAge is open, ONE worker and one Godot; check `Get-Process ArcheAgeChronicles` before any
  launch. AGENTS ONLY IN THE CONSOLE (`claude_cm.ps1` through `mcp__terminal__run_in_terminal`).
- Commit by pathspec; a script with an apostrophe goes in a file (Write tool); never append a `//` comment to a line
  from a script; a bare `cd` in Bash moves the session folder.

## FIRST: what is running or half done
1. PLANIMPACT2 LANDED at the very end of S550, NOT YET CHECKED: `docs/PLANIMPACT2_RESULT.md` - FAIL. Best plan
   beats a careless one by about 2 (bar 6); the rule adds half a win; "one plan fits every opponent because all six
   styles fight on the same four places"; "no rule of this kind can reach 6: the opponent styles must differ in where
   and how they fight (a ring change)". BEFORE telling him: open the code lines it names, check its table by hand
   (as `PLANIMPACT1_CHECK_S549.md` did), and note it ran on FIVE women, not the brief's ten types. Then ONE page for
   him: the plan stays small as the ring is today / a ring change that makes styles fight in different places (a new
   scope) - his call (scope). He was told only that it landed and failed.
2. COACHMAP2 - brief written, NOT launched (`ops/research/TASK_COACHMAP2.md`). PLANIMPACT2 has landed, so it may
   start when a worker slot is free (one worker while his game is open: BODYCROSS4 holds it).
3. BODYCROSS4 - RUNNING (Fable, console tab BODYCROSS4 of the S550 session, from 17:15, about 3-4 h). The animation
   item. Collect: films for his eye on /review; step 5 = the close body hook must read as a punch (his note C505).
4. MATCHBOTS2 - not running; probe hooks on disk, uncommitted (`tools/matchbots2_probe.gd`,
   `tests/matchmaking_bots_test.gd`); brief `ops/research/TASK_MATCHBOTS2.md`.
5. THE CARD GAME: his play of version 2, then `CARDRANGE_SCOPE_S550.md` phase 1 (paper) and 2 (greybox `rules3.mjs`).
   Engine notes: `proto/boxcards/README` does not exist - the header comments of `rules2.mjs`, `bot2.mjs`,
   `probe2.mjs` are the guide; `node --test proto/boxcards/boxcards2.test.mjs` (21) and `boxcards.test.mjs` (12);
   after any page change run `python proto/boxcards/build_phone.py` and publish `proto/boxcards/phone.html` to the
   SAME artifact (pass its url; this is a new conversation).
6. John SQ325 LANDED as S550 closed, NOT READ: `ops/research/CARDBOX1_JOHN_BRIEF_JOHN.md` (source-checked facts for
   the three real bouts). Check Arena's part 1 against it, and take any real three-round amateur numbers for the
   'to the judges' bar.
   Dola needs its debug port open for SQ324. Arena's lite PRs 64 and the version 2 one: their files are on main;
   the 30-minute relay closes them, or close them by hand.

## Then
- Build the FILE coach for simmed bouts (CORNERBASE1 verdict 2). KNOWBUILD2. DEPTH1. PROGBUILD1 rides on coaches.
- NO EXPORT SINCE S547 (no game file changed in S549 or S550; the trial evening's question pictures from S548 are not
  in a build). Export from a clean seeded worktree when his game is closed; WHAT_TO_TRY gets U.

## Waiting on the owner
- His play: boxer v boxer version 2 (the phone link above). He asked for the link at the end of S550.
- His eye on /review: body hook films (BODYREACT2), body cross 3, signing card, staff cards.
- His play: the S547 build (WHAT_TO_TRY O to T).

## Model for S551
Fable, medium effort, Fast off: version 3 of the card game is design work and two probe results need reading against
the code; Opus is enough if the session only collects PLANIMPACT2 and launches COACHMAP2.

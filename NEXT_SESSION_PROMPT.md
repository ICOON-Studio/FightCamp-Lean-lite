# S550 handover (written 2026-11-24, S549 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S549_DIGEST.md (and S548_DIGEST.md).

## METHOD lines - quote all of them in your first message
- ## METHOD - CARD GAME: ONE ART AGAINST ITSELF FIRST (owner S549, playing the page: "THE CARD GAME DOESNT MAKE SENSE.
  If the fight is MMA bjj fighter has no strikes ... BREAKDOWN A real mma fight and make it workwith card logic. the
  real test should be a boxer vs boxer , donot mix classes untill all arts cards are ingame"). NO work on the mixed
  boxing v jiu-jitsu game (no slice, balance or critic round; rounds 9 / 9b stay on main as they are). Boxer v boxer
  measured: 400 of 400 knockouts, the second man wins 69.5% (`node proto/cardgame/mirror.mjs`). Plan and phases:
  `ops/research/CARDBOX_SCOPE_S549.md`; phase 1 is Arena's paper `TASK_CARDBOX1.md` + John's facts (SQ325). The card
  lines further down this page that speak of slices 2-3 are history.
- A DECISION SCREEN IS A SCENE; AFTER THE CLICK THE PAGE ITSELF SHOWS WHAT CHANGED - NO POP-UP, NO ICON TILES; LITTLE
  TEXT; PLAIN MENU WORDS, THE PLAYER'S PLACE IS THE GYM; OFFICE-LIKE PAGES ARE WINDOWS OF THE OFFICE COMPUTER; THE PLAYER
  BOOKS WHEN HIS BOXERS ARE READY (owner S544-S546).
- ORDER (owner S542): pending mechanics first, THEN 3D and menus.
- THE WRITTEN PLAN STAYS AND MUST MATTER (owner S548, Q-328: "make it more impactful"). Never propose shrinking the plan
  screen. The live corner is worth about +10 wins in 100 over a coach who reads the file (CORNERBASE1); the best written
  plan +1.7 to +3.0. PLANIMPACT1 measures three levers; no plan design before its result.
- THE CORNER HAS EIGHT COMMANDS AND NO RING SLOT (owner S548, Q-330: "Cut both").
- COACHES: NO TRIAL WEEK, CHEMISTRY ON THE HIRE CARD (owner S548, Q-329: "Cut it, show chemistry"). The page to read is
  `ops/research/DESIGN_COACHMAP1.md` (DESIGN_COACHDEEP9 is history).
- MECHANICS NEED 8 (owner S534), probe first, then a code-checked critic, then the chat critics. A WORKER'S NUMBERS CAN
  BE RIGHT AND ITS WHY WRONG: open the code lines first.
- CARD GAME, REAL FIGHT FIRST - AND MEASURE A CRITIC'S RULE BEFORE IT GOES ON (S548: Kalli's "Keep your base" made
  boxing win 99.5%). THE BOT MUST USE WHAT IS BUILT: a legal move the bot never lays proves nothing.
- FIGHT ANIMATION: v2 only, no new correction layer; THE OWNER'S EYE IS THE RULER.
- HIS GAME FIRST (S537, again S548: "find why archeage is lagging"): while ArcheAge is open, ONE worker and one Godot
  at a time; check `Get-Process ArcheAgeChronicles` before any launch. AGENTS ONLY IN THE CONSOLE (`claude_cm.ps1`
  through `mcp__terminal__run_in_terminal`). The Stop hook refuses a turn end while a stage is open: keep own light work
  (briefs, maps, node) for the waits.
- Commit by pathspec (`git commit -- <files>`; `git add -A` and `.` are blocked); a script with an apostrophe goes in a
  file; a bare `cd` in Bash moves the session folder - go back to the repo root.

## FIRST: what is running or half done
1. THE CARD GAME, PHASE 2 (owner Q-332 "Yes, go"): write boxer v boxer ON PAPER, then a small greybox probe, THEN the
   critics (S534 order). Inputs: Arena's paper `proto/cardgame/CARDBOX1_BREAKDOWN.md` (collected, read: parts 1-2
   usable; BOTH its turn structures failed to play the real round because the defender sees the card and answers it;
   its pick is not taken as it stands - see S549_DIGEST "Arena's paper"), John's facts SQ325
   (`ops/research/CARDBOX1_JOHN_BRIEF_JOHN.md` when it lands: check Arena's part 1 against it), the measured mirror
   bout (`node proto/cardgame/mirror.mjs`: 400 of 400 knockouts, the second man wins 69.5%). Claude's direction is in
   the digest: keep the volley against ONE answer, add round scoring, the knockdown and count, body punches that lower
   his wind for the bout, the clinch answer, a feint with a shown effect, three rounds of three exchanges. Bars:
   CARDBOX_SCOPE_S549.md phase 3. A fresh small engine (`proto/boxcards/`), not a patch of engine.mjs.
2. PLANIMPACT1 (Opus, console tab of the S548 session; about 4 h from 14:05) -> `docs/PLANIMPACT1_RESULT.md` on main.
   Design page: `ops/research/DESIGN_PLANIMPACT1.md`. Raw: `E:/FightCamp/tmp/planimpact1/`. If the tab is gone and
   there is no result page, relaunch with the same prompt (it resumes from the jsonl files). Check: the control equals
   PLANWORTH1 bout for bout; a lever that passes bar 1 and fails bar 2 (the corner still pays) is a FAIL.
3. MATCHBOTS2 - NOT RUNNING. On disk, uncommitted: `tools/matchbots2_probe.gd`, probe hooks in
   `tests/matchmaking_bots_test.gd` (three vars, unset = the test as before), a worktree `E:/FightCamp/wt/mb2`
   (detached at 7d9057efe). Relaunch AFTER PLANIMPACT1 lands: brief `ops/research/TASK_MATCHBOTS2.md`.
4. COACH MAP: Kalli depth 5, play 5, general 6. Her three changes and the rest as in S548_DIGEST. The next step is ONE
   page for the owner (keep with the three changes and a probe, or cut back to today's two hire cards) - written
   AFTER PLANIMPACT1 (its lever 2 is the same idea as her change a).
5. BODYCROSS4 - brief written, NOT launched (`ops/research/TASK_BODYCROSS4.md`, Fable worker). It now has step 5: the
   close body hook does not read as a punch (his /review note C505). This is the session's animation item.

## The card game as it stands (history: nothing below is to be continued)
- Rounds 9 and 9b (slices 1-3) are on main, 90 of 90 tests, play gate 6 of 6: `docs/CARDROUND9B_RESULT.md`. STOPPED by
  the METHOD line above. The floor model is kept for the day the arts meet.
- The page: preview `cardgame` (port 8799, `proto/cardgame/serve.py`, no-store). He plays it live while it is edited:
  never leave the working tree half-built - build in one script, test, then let him reload.
- Arena is back (S549): its chat on `ICOON-Studio/FightCamp-Lean-lite` wrote the paper in about 25 minutes; the lite
  mirror carries `ops/research` too (it read CARDREF1 there), so everything in a brief is public.

## Collected in S548 (details in the digest)
PLANREAD2 (the card reads a plan as the ring pays it), CORNERBASE1 (the corner ~+10 v a coach who reads the file; a
simmed bout should get the FILE coach, +2.6 / +6.2, NOT BUILT - `BoutRead._call` must follow; the coach's rating buys
0 in a simmed bout), BODYREACT2 (a body hook bends the hit boxer; films on /review, his eye).
Small fixes: choreographer_test follows BODYREACT2; block_meet_test out of the 05:00 list (old player); the trial
evening's question pictures show the prospect's own body (NOT in an exported build yet).

## Then
- Build the FILE coach for simmed bouts (CORNERBASE1 verdict 2; keep her own call where she is Poor at the file's).
- KNOWBUILD2 (the got-away boxer's return bout). DEPTH1. PROGBUILD1 rides on coaches.
- NO EXPORT WAS MADE IN S548 (he was playing; the only game change is the question pictures). Export from a clean
  seeded worktree when his game is closed (`OUT=/e/FightCamp/Lean/Builds sh tools/export.sh`), WHAT_TO_TRY gets U.

## Waiting on the owner
- His eye on /review: body hook films (BODYREACT2), body cross 3, signing card, staff cards.
- His play: the S547 build (WHAT_TO_TRY O to T) and card round 9 / 9b.
- Dola needs its debug port open for SQ324.
- THE PC (S548): ArcheAge lagged because Windows' kernel pool had grown to 15.3 GB after 12.3 days up (plus my two
  workers at 97% RAM). He restarted: pool 0.8 GB. If it climbs again within days, find the driver (poolmon is not
  installed). Closing finished worker tabs each session keeps about 4 GB free.

## Model for S550
Fable, medium effort, Fast off: the boxer v boxer design on paper and its greybox probe are design work; Opus is enough
for collecting PLANIMPACT1 and the coaches page.

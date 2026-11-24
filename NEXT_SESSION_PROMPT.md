# S549 handover (written 2026-11-24, S548 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S548_DIGEST.md.

## METHOD lines - quote all of them in your first message
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
1. PLANIMPACT1 (Opus, console tab "PLANIMPACT1 (resumed)", tab c3 of the S548 session, relaunched 14:05 after the PC
   restart; about 4 h, one Godot at a time) -> `docs/PLANIMPACT1_RESULT.md` on main. Design page (committed before any
   run): `ops/research/DESIGN_PLANIMPACT1.md`. Raw: `E:/FightCamp/tmp/planimpact1/`. If the tab is gone and there is no
   result page, relaunch with the same prompt (it resumes from the jsonl files). Check: the control equals PLANWORTH1
   bout for bout; a lever that passes bar 1 and fails bar 2 (the corner still pays) is a FAIL.
2. MATCHBOTS2 - NOT RUNNING. Its first worker died with the PC restart at step 0-1. On disk, uncommitted:
   `tools/matchbots2_probe.gd` and probe hooks in `tests/matchmaking_bots_test.gd` (three vars, unset = the test as
   before), and a worktree `E:/FightCamp/wt/mb2` (detached at 7d9057efe, for the before arm). Relaunch AFTER PLANIMPACT1
   lands (one worker while he plays): brief `ops/research/TASK_MATCHBOTS2.md`, tell it what is on disk.
3. COACH MAP: Kalli answered - depth 5, play 5, general 6 (`ops/research/CRITIC_COACHMAP1_BRIEF_KALLI.md`); she could not
   open the code. Dola's copy (SQ324) did not send: the Dola app has no debug port open (9333). Her three changes that
   matter: (a) the corner coach gets a job BESIDE the live corner - tactics = how often the opponent's clue is right,
   the bond = how much of the player's call the boxer hears, the cutman = recovery; (b) a coach is the main coach of at
   most 2 boxers, so a clash on the hire card cannot be paired away; (c) re-run the hire with the chemistry word shown.
   (a) is the same idea as PLANIMPACT1's lever 2 (the plan sharpens the corner): read both results together before any
   v2. Coaches have now failed ten rounds: the next step is ONE page for the owner (keep with these three changes and a
   probe, or cut back to today's two hire cards), not an eleventh map.
4. BODYCROSS4 - brief written (`ops/research/TASK_BODYCROSS4.md`, Fable worker), NOT launched: the body cross thrown in
   the 3D fight. This is the session's animation item; launch it when the PC is free of his game or as the one worker.

## The card game (owner S548: "fix both yourself, dont wait for arena", "do 9b yourself too")
- ROUND 9 IS ON MAIN (4307c453a) with two fixes: the man who pulls guard off a step out lands on his back; the bot's
  jiu-jitsu man with no entry sits down. `ops/research/CARDROUND9_WALK_S548.md`.
- ROUND 9b SLICE 1 IS ON MAIN (406197a75, 104878fdf): Frame, the tie that must stand a turn, the knockdown, the
  referee's stoppage, the Up-kick with no card, "get up" before the stand-up, recover guard by where he was pinned,
  Keep your base against a PULL only for a man who threw no punch last turn (his "Weaker version, measured").
  OFF, built and tested: Keep your base against a SWEEP (99.5% boxing; 69.3% weaker) and the no-card hold escape.
  `docs/CARDROUND9B_RESULT.md`; paper = `ops/research/CARDREAL_AUDIT.md` section 9. `cd proto/cardgame && node --test`
  73 of 73; `node probe.mjs gate=play` 6 of 6 (26.8 decisions, boxing 43.0 / jiu-jitsu 57.0); `node stats9b.mjs
  [name=value]` = the 400-bout table. engine.mjs is at 495 of 500 lines: new rules go in floor.mjs / moves.mjs.
- NOT BUILT: slice 2 (C posture, D a punch from the guard gives up an arm, E standing in the guard + Hold the legs),
  slice 3 (F jiu-jitsu punches from on top, G the body-lock trip, I3-I5 the referee's rest), the Sprawl / Up-kick cards'
  stronger versions, section 9c's walked bout as a test, posture in the state words, Kalli's three measures.
- KNOWN: jiu-jitsu wins 179 of 222 on the points lead and 25 by tap (look at `N.lead` next, not moved); the bot never
  lays the no-card Up-kick in its own turn and never pays Keep your base against a pull.
- HIS PLAY of round 9 / 9b is owed ("Later"): preview `cardgame` in .claude/launch.json (port 8799).
- Arena: its mirror is refreshed (`python ops/Tools/lite_mirror.py --lean push`; without `--lean` it targets the old
  repo and fails). Its round-9 chat is superseded by main; a new chat only for a slice Claude does not take.

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

## Model for S549
Opus, medium effort, Fast off: collecting two probes and the coach decision page. Fable for the card slices 2-3 or
BODYCROSS4's films.

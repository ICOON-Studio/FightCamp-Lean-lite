# S552 handover (written 2026-11-25, S551 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S551_DIGEST.md.

## METHOD lines - quote all of them in your first message
- ## METHOD - THE FIGHT GAME IS RING SWITCHES (owner S551, his own idea: "what if put everything that the fighter can do in the
  fight as action toggable buttons like the jab,uppercut push,backoff,step in , guard low, guard up etc"; after one turn:
  "this can become a beautiful game i played 1 turn and i love it"). No decks, no timed presses. `proto/twohands/switch.html`
  (both men act at once) and `order.html` (the order you click is the order you throw; generated from switch.html by
  `proto/twohands/tools/make_order.py` - edit the base, rerun the generator). The deck engines (`proto/boxcards`), the laid
  defence, Two Hands' timed presses and `CARDRANGE_SCOPE_S550` are PARKED, not deleted. Timing may return later "if there are
  animations and the defence gets triggerred on its own ... and pllayer has to react". Plan and measures: the last sections of
  `ops/research/TWOHANDS_SCOPE_S551.md`.
- ## METHOD - THE FIGHT MUST BE SEEN (owner S551: "we need to work on the visuals of the fight so the player can understand the
  actions by seeing every card being executed by the fighters , 2d animations and when the fight goes to the ground we will
  use the grapplemap animations from any angle we want"; then "prepare handoff to start with the standing animations").
  FIRST WORK OF S552: `ops/research/TASK_RINGANIM1.md`. The ground (GrappleMap) comes after, and Ring Switches has no ground
  rules yet.
- HOW HE WORKS ON THIS GAME (S551, it worked): take HIS idea, build a playable toy within the hour with our own ring pictures
  and sounds, run a bot sanity check, hand it over, fix each note at once. Not a design page first. What a bar shows and what
  a card shows must agree; a greyed switch says why; say things in HIS punches ("blocks his jab and his cross").
- A PAGE HE PLAYS IN CHROME NEEDS A SERVER IN A TERMINAL TAB: `python proto/cardgame/serve.py 8797 twohands` through
  `mcp__terminal__run_in_terminal`, then curl the link. Preview-pane servers die with the pane ("they dont work on chrome").
- THE WRITTEN PLAN STAYS AND MUST MATTER; no third plan-RULE probe: the cap is that every opponent style fights in the same
  four places (PLANIMPACT2, checked). Q-335 "Yes, scope it" -> `STYLEPLACE_SCOPE_S551.md`, worker brief `TASK_STYLEPLACE1.md`.
- COACHES: COACHMAP2 FAILED (bars 1, 3, 4, 7b; `docs/COACHMAP2_RESULT.md`, commit fc207d8a1). MECHANICS NEED 8: a built
  mechanic that cannot reach 8 goes to him as "cut it or keep it" - never removed silently. Not yet asked.
- A DECISION SCREEN IS A SCENE; LITTLE TEXT; PLAIN MENU WORDS; THE PLAYER BOOKS WHEN HIS BOXERS ARE READY (S544-S546).
- ORDER (owner S542): pending mechanics first, THEN 3D and menus. (S551 he chose to spend the session on the fight toy.)
- FIGHT ANIMATION: v2 only, no new correction layer in scripts/fight3d; THE OWNER'S EYE IS THE RULER.
- HIS GAME FIRST: `Get-Process ArcheAgeChronicles` before any launch or render; one worker and one Godot while it is open.
  AGENTS ONLY IN THE CONSOLE (`claude_cm.ps1` through `mcp__terminal__run_in_terminal`).
- Commit by pathspec; a script with an apostrophe goes in a file; NEVER add a `//` comment to a line of one-line JS (it
  broke the page twice: S550, S551) - use `/* */`; a bare `cd` in Bash moves the session folder.

## FIRST: what is running or half done
1. RINGANIM1 - the animation item, NOT started: brief `ops/research/TASK_RINGANIM1.md` (frame runs for every action from
   our own 3D clips through the picture tools; red first; strips and a before / after film for his eye). Do step 0 and one
   jab strip before rendering the lot.
2. COACHMAP2 LANDED, NOT CHECKED, NOT ASKED: `docs/COACHMAP2_RESULT.md` FAIL. Open the code lines it names and its table by
   hand (as `PLANIMPACT2_CHECK_S551.md` did), then ONE board question, 20 words, an attachment of 4 lines: keep coaches as
   today's two hire cards, or cut. The worker tab's ghost prompt ("put the keep-or-cut coaches question...") is a
   suggestion of the app, not his words. Its tab is closed with the S551 session.
3. STYLEPLACE1 - briefed, NOT launched (`ops/research/TASK_STYLEPLACE1.md`): the Godot slot was held by COACHMAP2 and then
   the session went to the fight toy. Launch it in a console tab when his game is closed or as the one worker.
4. SEAT ANSWERS LANDED, NOT READ: `ops/research/TWOHANDS_DEFENCE_IDEAS_BRIEF_KALLI.md` and `_JOHN.md` (five no-timing
   defence mechanics each, asked BEFORE Ring Switches existed). Read them against Ring Switches: anything that would add
   to it (not replace it). Dola SQ324 and SQ327 wait for its app's debug port (his to open). Ludo: the question sits in a
   new Ask Ludo chat "Boxing Defense Mechanics"; no reply came in three minutes - read it from All Chats, do not ask again.
5. RING SWITCHES, NOT GREEN (measured S551, tools in `proto/twohands/tools/`): the Jabber is beaten every time in the
   ordered version (95% in the plain one) by a sensible bot; the Slugger loses 60% to one fixed setting; the bots are
   one-beat readers. His question to answer by play: keep the chosen order (`order.html`) or not (`switch.html`)? He has
   not said. No tests in the repo for either page's rules yet: the rules live inside the page script.
6. BODYCROSS4 collected (test green; films on /review for his eye). In the game-camera still the glove looks to land at
   chest height rather than the stomach (Claude's eye, not measured).
7. MATCHBOTS2 - not running; probe hooks on disk, uncommitted (`tools/matchbots2_probe.gd`, `tests/matchmaking_bots_test.gd`).

## Then
- GrappleMap ground player (any angle) once the standing runs are in; `proto/grapplemap` reads the map and draws stills.
- Other arts as more switch groups (legs, elbows, knees - his Ironbound slots), and the build layer (training decides
  which switches a boxer owns).
- The FILE coach for simmed bouts, KNOWBUILD2, DEPTH1, PROGBUILD1 (all wait behind the coach call).
- NO EXPORT SINCE S547. BODYCROSS4 changed game files (scripts/fight3d/v2, RoundScript): export from a clean seeded
  worktree when his game is closed; WHAT_TO_TRY gets U (the body cross is thrown in the 3D fight).

## Waiting on the owner
- His play: Ring Switches, both pages - keep the chosen order or not.
- His eye on /review: body cross 4 and body hook films, signing card, staff cards.
- Board Q-335 is answered ("Yes, scope it"); the coach keep-or-cut question is not yet on the board (FIRST 2).
- Dola's debug port. His own play of the S547 build (WHAT_TO_TRY O to T).

## Model for S552
Fable, medium effort, Fast off: the first work is animation (his S512 "use fable for animations") and needs pictures
judged by eye; Opus is enough for a session that only collects COACHMAP2 and launches STYLEPLACE1.

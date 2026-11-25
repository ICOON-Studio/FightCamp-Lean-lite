# S553 handover (written 2026-11-25, S552 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S552_DIGEST.md.

## METHOD lines - quote all of them in your first message
- ## METHOD - THE FIGHT GAME IS RING SWITCHES (owner S551, his own idea; after one turn: "this can become a beautiful game
  i played 1 turn and i love it"). No decks, no timed presses. `proto/twohands/switch.html` (both men act at once) and
  `order.html` (generated from it by `proto/twohands/tools/make_order.py` - edit the base, rerun the generator; the
  generator CUTS the text between "const c = covers(me, P)" and "function plan() {", so never put new code there).
- ## METHOD - THE FIGHT MUST BE SEEN (owner S551: "seeing every card being executed by the fighters , 2d animations and
  when the fight goes to the ground we will use the grapplemap animations from any angle we want"). S552 built the
  standing runs: 59 of 64 (`docs/RINGANIM1_RESULT.md`). FIRST WORK OF S553: `ops/research/TASK_HOLDTAKES1.md` - a hand
  held high or low has no picture, and that is the choice the game is about. The ground (GrappleMap) comes after.
- TRIPO / LUDO FOR ANIMATIONS (owner S552: "you can try tripo or ludo for animations if it speeds up things"): allowed;
  time-box it - a generated take must be on our bodies within the hour or the authored bake is used.
- HOW HE WORKS ON THIS GAME (S551): take HIS idea, build a playable toy within the hour, fix each note at once. What a
  bar shows and what a card shows must agree; say things in HIS punches ("blocks his jab and his cross").
- A PAGE HE PLAYS IN CHROME NEEDS A SERVER IN A TERMINAL TAB: `python proto/cardgame/serve.py 8797 twohands` through
  `mcp__terminal__run_in_terminal`, then curl the link (it was up all of S552: check before starting a second one).
- THE WRITTEN PLAN STAYS AND MUST MATTER; opponents that fight in different places: STYLEPLACE1 probe (running, below).
- COACHES: nine rounds, cannot reach 8. Board Q-336 asks keep the two hire cards or cut. Nothing is removed until he says.
- A DECISION SCREEN IS A SCENE; LITTLE TEXT; PLAIN MENU WORDS; THE PLAYER BOOKS WHEN HIS BOXERS ARE READY (S544-S546).
- ORDER (owner S542): pending mechanics first, THEN 3D and menus. (S551-S552: he chose the fight toy.)
- FIGHT ANIMATION: v2 only, no new correction layer in scripts/fight3d; THE OWNER'S EYE IS THE RULER.
- HIS GAME FIRST: `Get-Process ArcheAgeChronicles` before any launch or render. AGENTS ONLY IN THE CONSOLE
  (`claude_cm.ps1` through `mcp__terminal__run_in_terminal`).
- Commit by pathspec (`git add -- <paths>` then `git commit -F <file> -- <paths>`); a script or a commit message with an
  apostrophe goes in a FILE (a Bash heredoc broke on one again); never a `//` comment on a line of one-line JS; a bare
  `cd` in Bash moves the session folder (it did again: use `cd /e/FightCamp/Lean && ...` in the same command).

## FIRST: what is running or half done
1. STYLEPLACE1 (Opus, console tab c1 of the S552 session, launched 2026-11-25 00:55, 4-5 h): at the handover the
   control and bar 5 were done and the full arms were running. If the S552 window was closed its tab died: check
   `git log --oneline -- tools/styleplace1_probe.gd docs/STYLEPLACE1_RESULT.md` and `E:/FightCamp/tmp/styleplace1/`; if
   there is no result page, relaunch with the same brief (it commits as it goes). When it lands: check it against the
   code by hand (as `PLANIMPACT2_CHECK_S551.md`, `COACHMAP2_CHECK_S552.md`), then the board.
2. HOLDTAKES1 - the animation item, NOT started: `ops/research/TASK_HOLDTAKES1.md`. One pose first (lead hand low).
3. HIS ANSWERS TO READ: Q-336 (coaches keep or cut), and in chat "The guard bar almost never breaks as tuned. Should I
   make it matter?" (6 points, +1 a beat, -1 for a blocked big punch: two blocked big punches a beat for a whole round
   to break it). If yes: first guesses to try are no +1 in a beat it blocked a big punch, or 4 points; measure with
   `proto/twohands/tools/probe_switch_bots.js` before and after.
4. RINGANIM1 open ends (`docs/RINGANIM1_RESULT.md` NOT GREEN): an overhand take, a one-man shove, red's blocked body
   hook (6.1 cm against a 5 cm bar), the women's pair, inside punches whose guards overlap before the punch. His eye on
   the review board (stage S552: 3 films, 10 sheets) decides which matter.
5. Ring Switches itself, still NOT GREEN (S551): the Jabber too easy, one-beat bots, no tests for the rules, keep the
   chosen order (`order.html`) or not - his play decides.
6. Ideas that would ADD to Ring Switches (`TWOHANDS_IDEAS_VS_RINGSWITCHES_S552.md`): a landed jab keeps him out, the
   player's own read of his habit, the ring as a track you can see. None built; his call.
7. MATCHBOTS2 - not running; probe hooks on disk, uncommitted (`tools/matchbots2_probe.gd`,
   `tests/matchmaking_bots_test.gd`). The 05:00 reds left: matchmaking_bots, block_meet (the old player's rulers).

## Then
- GrappleMap ground player (any angle); other arts as more switch groups; the build layer (training decides which
  switches a boxer owns).
- NO EXPORT SINCE S547 (BODYCROSS4 changed game files; S552 changed none): export from a clean seeded worktree when his
  game is closed; WHAT_TO_TRY gets U (the body cross is thrown in the 3D fight).
- Behind the coach call: the FILE coach for simmed bouts, KNOWBUILD2, DEPTH1, PROGBUILD1.

## Waiting on the owner
- His eye: the review board, stage S552 (before / after films, one sheet a punch, the holds that read wrong).
- His play: Ring Switches with the frame runs, both pages.
- Board Q-336. The guard bar question. Dola's debug port. His play of the S547 build.

## Model for S553
Fable, medium effort, Fast off: the first work is authoring four guard poses judged by eye (his S512 "use fable for
animations"). Opus is enough for a session that only collects STYLEPLACE1.

# S426 handover: collect the animation subagent's work, R55 v3 to depth 7, Cursor's queue (written 2026-11-10, S425)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S426` and redraw the map (recipe: ops/Tools/where_we_are_svg.py docstring; the frame refuses to resize - harmless; a PARTIAL svg is enough: the frame, the panels and the cards, then `trim` / `learn` as the svg command prints).
Older handovers are in git (this file's history); S396 to S417 in ops/research/HANDOVERS_S349_S417.md.

## His two rulings in S425 (verbatim)
- "i expect all new mechanics to be wired and shown properly on the correct menus and be deep enough for a critics +7/10"
  -> in CLAUDE.md (Agent roles): a map reaches his board only at depth 7+ from two FRESH critics; every map has a menu
  table (menu, what appears, wired to); a build is done when each menu shows it in the .exe and a golden-path test walks it.
- "can you assign a subagent to fix the boxing/grappling animation issues and using fable 5.2 , i want to start seeing
  animations on the board and grappling fights that make sens and make understand what is the action happening and how to
  react as a player" -> ANIMFIX1, brief ops/research/TASK_ANIMFIX1.md.

## What S425 did
- R55 "who gets the pads": measured (tools/pads_for_two_probe.gd, 300 bouts a cell). The coach's hands = one week on a
  card. A plan answer she cannot do yet on fight night: 38.0 / 36.0 / 31.0 / 26.3% won against 40.0% (tie up, pivot out,
  Jab-Jab, step back); no plan 18.7%. Sharp over usable: 1 point. Map v1 -> critics depth 4, 4 -> v2
  (ops/research/R55_PADS_DESIGN_MAP.md, docs/mockups/s425/pads_rota_v2.png) -> fresh sim veteran: depth 4 again
  (pads_v2_critic_simvet.md); the fresh coach critic's review may have landed after this was written
  (pads_v2_critic_coach.md). NOT on his board.
- ANIMFIX1 launched (a Fable subagent INSIDE the S425 session; it dies if that session is cleared).
  Track A: worktree LEAN_LEGTREMBLE4, branch qwen/legtremble4 (Qwen round 4, 0edc96fe: 122 clips hips-locked,
  head_aim still 1 VOID; its "hold_root_xz never fires" cause is unproven: paths are prefixed before the check and main
  is green on the same guard). A short film of that branch: E:/FightCamp/tmp/s425_lt4/round.avi.
  Track B: worktree LEAN_GRAPPLEFIX1, branch claude/grapplefix1: a BJJ match the player can read.
- Kalli SQ32 (cutman v3) answered with a summary only; SQ35 asks her to paste the page.
- PR 164 closed (already on main). No game code changed on main: no new export, WHAT_TO_TRY unchanged.

## Running (yours)
- ANIMFIX1 (see above). KDFIX4 (Cursor, wt LEAN_KDFIX4, branch cursor/kdfix4). Chat seats: Kalli SQ35, John SQ31/33/34.
- Cursor queue after KDFIX4: DUESCARD1, FIGHTDISPLAY2, TRAININGB1. Qwen is free.

## Order for S426
1. Collect what ANIMFIX1 pushed (diff, the touched tests, LOOK at each film yourself), merge what is green, close PRs
   162, 163, 166 when their fix is in. If the subagent did not finish, relaunch it from its brief and worktrees.
2. KDFIX4: collect, film a knockdown, look, review board.
3. R55 v3. Both rounds of critics say the same: sharing one coach's pad hands is too small alone (one week on one
   card, the second coach pays for himself, a clash is self-made while nights can move). Direction: make it the coach's
   whole week (R73 coach-hours, also on his IN list): his evenings spent across pads per boxer, the club class
   ($350), sparring cover, film study with a boxer, the corner on show night; "sharp and signature pay on fight night"
   first so pad time matters all camp. Measure each use's worth before writing. Two FRESH critics, 7+ on depth.
4. Cutman v3 (Kalli SQ35) -> critics 7+ -> board. John SQ33 -> R37 map. John SQ34 -> dues sums, claude/duesband1 green.
5. R58 map (a fighter leaves): the promise "the pads are yours next camp" is R55's link into it.

## Traps
- `agent_comms.py ask --attach` resolves paths from ops/: pass absolute paths.
- `seat_queue.py add --brief` takes the path from ops/ (research/<file>.md).
- A chat seat's attached file never reaches us: ask for the page as text in the reply.
- A bare Godot start is blocked by the hook: `python ops/Tools/godot_slot.py run --who claude -- <godot command>`.
- `git diff --stat` across branches prints hundreds of .import warnings: add `2>/dev/null`.
- A python heredoc with triple quotes breaks in this shell: write the script to the scratchpad and run it.
- The Monitor on agent_events.py expires after 30 minutes without a notice you can count on: re-arm it, and check the
  worktree itself when an ETA has passed.
- Two critics at depth 4 twice means the mechanic is small, not the wording: change the mechanic.

SETTINGS: S425 ran on Fable 5.2. Weekly plan use 89% all models (Fable 16%), resets 11-12: propose Sonnet 5.5, high effort, Fast off, until the reset; the animation subagent stays on Fable as he asked.

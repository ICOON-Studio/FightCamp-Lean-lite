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

## After the first handover text (same session): the week design
- His third ruling: "maybe review combine old ideas to rise their depth to +7 and maybe come with new things ? can other
  free agents work on that , the focus needs to be for the player to have things to do during a week make him anticipate
  the changes and be more interactive with deicions/choices and rewarding for keep playing and progressing".
- Brief ops/research/WEEK_DEPTH_BRIEF_S425.md -> two designer pages (WEEK_DEPTH_SIMDESIGNER / COACHDESIGNER) -> joined
  v1 (ops/research/WEEK_DESIGN_V1_S425.md, docs/mockups/s425/week_v1.png) -> two fresh critics, depth 5 each
  (week_v1_critic_*.md) -> v2 being written by the lead designer subagent (WEEK_DESIGN_V2_S425.md, week_v2.png,
  week_v2_thursday.png), with his outside playbook proposal (ops/research/PLAYBOOK_GAMBIT_IDEA_S425.md).
- READBACK1 (Qwen) is on main: her corner waiting for your best plan line costs 7.0 points (41.3 -> 34.3), 5 to 6 in
  round 2; drop +0.7, swap 0.0. READBACK2 (Qwen, qwen/readback2) adds set-up and wait-cost as switched-off rules
  (scripts/rules/ReadBack.gd) and measures them.
- KDFIX4 landed (cursor/kdfix4, PR 169, ten tests reported green, NOT merged): ANIMFIX1 reruns the tests and films it.
  Cursor is on DUESCARD1 (cursor/duescard1). Digest: ops/research/S425_DIGEST.md.

## Order for S426
1. Week design v2: two FRESH critics (ops/research/WEEK_DESIGN_CRITIC_BRIEF_S425.md, point it at v2 and week_v2*.png),
   depth 7+ -> his board with the pictures; under 7, another round (resume the lead designer or start a new one from
   the v2 page and the reviews). Fold in Kalli's page (SQ36) when it lands. Close Q-S294-178 (his chat message answered
   it: combine the ideas).
2. READBACK2: collect by diff; its controls must reproduce 41.3 / 34.3 / 35.0 / 34.3 to the decimal; an arm within 2
   points of the plain plan and 3 above the waited arm keeps the full plan-reading part; no arm may beat the plain plan.
3. ANIMFIX1: collect qwen/legtremble4 (PR 168) and claude/grapplefix1 by diff, the touched tests, LOOK at each film
   yourself; merge KDFIX4 (PR 169) once its film is looked at; close PRs 162, 163, 166 when their fix is in. If the
   subagent did not finish, relaunch it from ops/research/TASK_ANIMFIX1.md and the worktrees.
4. DUESCARD1: collect, render Club > Money, compare with docs/mockups/s424/dues_painted_v4.png; then FIGHTDISPLAY2,
   TRAININGB1 on Cursor.
5. Cutman v3 (Kalli SQ35) -> critics 7+ -> board. John SQ33 -> R37 map. John SQ34 -> dues sums, claude/duesband1 green.
   R58 map (a fighter leaves).

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

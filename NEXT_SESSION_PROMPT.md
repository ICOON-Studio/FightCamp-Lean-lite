# S484 handover (written 2026-11-15 at the end of S483; S482's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S484`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310k. The Miro P0 redraw costs ~20k each time: do it
  once at start and once at the end, never more.
- Godot jobs through `python ops/Tools/godot_slot.py run --who s484 -- <cmd>`; `timeout` OUTSIDE godot_slot. Single tests
  as tools/run_tests.sh runs them (`--headless --audio-driver Dummy --fixed-fps 60`); a runner script for a test list was
  used in S483 (xargs -P 3, rc + SCRIPT ERROR check).
- Never `cd` into a worktree (S483 did once by accident); use `git -C <wt>`.
- Arena: pure modules only, it has no Godot - run its test yourself. Lite mirror `python ops/Tools/lite_mirror.py --lean push`.
- Qwen rerun: a landed run blocks seat_dispatch (worktree, local + remote branch, run record). Save the old commit to
  `<branch>-r1`, retire the worktree, delete both branches, mark the run failed, `seat_dispatch.py retry <ID>`, then `--act`.
- Goose: GOOSE_PER_DAY 3 (S483 used all three). Briefs say "never sleep to wait; foreground timeout".

## WHAT S483 DID (ops/research/S483_DIGEST.md)
- Mode tells wired: OppFile tape order weapon, mode, habits, mode, weakness; OFTEN/SOME/RARE on the chart's + Add an IF and
  the file column. plan_file_test fixed (S466 outside card).
- Club week build started: CHECKs note, owner questions Q-242..245 on the board, MORNINGS1 on Arena.
- STYLE2 timed out -> STYLE3 (lever count first). CLASH6 round 2 on Qwen. Kalli ladder v2 queued (SQ169).
- Coaches M1 (Dola) and Training K (built from Dola's spec) on the review board.

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen CLASH6 round 2 (qwen/clash6, wt E:/FightCamp/wt/LEAN_CLASH6): RUN the hidden film yourself before merging; merge bar
  in ops/research/TASK_CLASH6.md.
- Goose STYLE3 (#305, branch goose/issue-305): read the LEVER lines first; merge only StyleName EFFECTS numbers + probe + doc.
- Arena MORNINGS1 (chat https://arena.ai/agent/01a1de31-8b24-7169-bd21-dc521a2471c1, lite PR relays to an arena/* PR):
  `tests/coached_mornings_test.gd -> COACHED_MORNINGS PASS fails=0`, diff = the two OWNS files.
- Kalli SQ169 ladder v2 (seat queue).

## FIRST
1. Collect the four above as they land.
2. His board answers Q-242..245 -> CHECKs 4, 6, 7, 10 (ops/research/CLUBWEEK1_V9_CHECKS_S483.md) -> brief ClubDeal v9
   (pad turns) for a seat. Q-242 decides the turn unit.
3. TRAINGAME2: the game's real numbers into docs/mockups/s483/training_k.html, then two critics.
4. His look (chart, K, coaches M1) and his play of the fight week gate PLANFLOW1's rest and FIGHTWEEK3.

# S485 handover (written 2026-11-15 at the end of S484; S483's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S485`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310k. The Miro P0 redraw costs ~20k each time: do it
  once at start and once at the end, never more.
- Godot jobs through `python ops/Tools/godot_slot.py run --who s485 -- <cmd>`; `timeout` OUTSIDE godot_slot. Single tests
  as tools/run_tests.sh runs them (`--headless --audio-driver Dummy --fixed-fps 60`); a runner script for a test list was
  used in S483 (xargs -P 3, rc + SCRIPT ERROR check).
- Never `cd` into a worktree (S483 did once by accident); use `git -C <wt>`.
- Arena: pure modules only, it has no Godot - run its test yourself. Lite mirror `python ops/Tools/lite_mirror.py --lean push`.
- Qwen rerun: a landed run blocks seat_dispatch (worktree, local + remote branch, run record). Save the old commit to
  `<branch>-r1`, retire the worktree, delete both branches, mark the run failed, `seat_dispatch.py retry <ID>`, then `--act`.
- Goose: GOOSE_PER_DAY 3 (S483 used all three). Briefs say "never sleep to wait; foreground timeout".

## WHAT S484 DID (ops/research/S484_DIGEST.md)
- Collected MORNINGS1 (Arena), FOURMONEY1 (Qwen, new: four stipends = 9 weeks on today's cash), STYLE3 probe + lever table
  (Goose: 3 dead style levers; retune NOT merged) -> STYLE4 at Kalli.
- CLASH6 round 2 FAILED (kept on local qwen/clash6-r2). Two red rounds: audit, no round 3.
- TRAINGAME2: training K page with the game's real numbers (tools/training_k_numbers.gd); check hook 1.8 short Friday.

## IN FLIGHT (seat queue - collect, do not resend)
- SQ170 John + SQ171 Dola: ladder v2 critics (both 7+ depth = his board; else Kalli revises).
- SQ172 John + SQ173 Kalli: training K critics.
- SQ174 Kalli: STYLE4 - new levers for Slugger, Boxer-puncher, Counter-puncher (then a Qwen code brief + retune of all six at
  100 bouts a cell; gates in docs/STYLE3_RESULT.md).
- Qwen and Arena are free: give each a task in the first hour (Arena: a pure module; Qwen: STYLE4 code once Kalli lands).

## FIRST
1. Seat answers above; quote the scores.
2. His board answers Q-242..245 -> CHECKs 4, 6, 7, 10 (ops/research/CLUBWEEK1_V9_CHECKS_S483.md) -> ClubDeal v9 brief.
3. CLASH audit yourself (Opus if he picks it): which boxer's modifier stack runs first, what peer arms each GloveClear/ArmClash
   reads (layer_trace, clash_meter); rounds 1-2 on qwen/clash6-r1 / -r2; TASK_CLASH6.md has both results.
4. FOURSTART1 map: docs/FOURMONEY1_RESULT.md + classes + ticket cuts.
5. His look (chart, training K, coaches M1) and his play of the fight week gate PLANFLOW1's rest and FIGHTWEEK3.

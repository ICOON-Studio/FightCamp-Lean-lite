# S483 handover (written 2026-11-15 at the end of S482; S481's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S483`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310-330k (S482 ran to 453k: start earlier).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s483 -- <cmd>`; put `timeout` OUTSIDE godot_slot (inside, Git
  Bash finds Windows TIMEOUT.EXE). hidden_desktop takes `--log=<path>` and also goes through godot_slot.
- Tests run as tools/run_tests.sh does: `--headless --audio-driver Dummy --fixed-fps 60` (block_meet: 30).
- Never `cd` into a worktree; use `--path <wt>`. Never type the Godot terminal-build's file name in a Bash command.
- Arena: pure modules only; lite mirror `python ops/Tools/lite_mirror.py --lean push`.
- Qwen by hand: `python ops/Tools/seat_dispatch.py --task <ID> --seat qwen --act` (contract REGRESSION must name a test;
  a seat still marked "running" in live_runs.json blocks it - land the old run first).

## WHAT S482 DID (ops/research/S482_DIGEST.md)
- The Game plan is ONE chart page (PlanChart + PlanChartShapes + PlanAuto), golden path tests/plan_chart_test.gd; coach's
  starter now fireable; Your coach rewrites it / Start from last bout.
- Partner edge on its own key (bout.spar_edge, rounds 1-2), EDGE x2.5 from a paired probe. Women's 70 kg class.
- CLASH6 round 1 crashed the film -> round 2 brief. Seat prompt: windowed Godot only via hidden_desktop.

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen MODETELLS1 (branch qwen/modetells1, wt E:/FightCamp/wt/LEAN_MODETELLS1): merge bar = the two OWNS files only,
  `tests/mode_tells_test.gd -> MODE_TELLS PASS fails=0`, plan_chart_test green.
- Goose STYLE2 (#302, running since 05:27): PR or "could not open a PR" -> fetch goose/issue-302.
- Kalli SQ169 ladder v2; SQ168 training K spec. Dola SQ165 coaches M1 LANDED (ops/research/COACHFIT_M1_DRAW_S480_DOLA_DOLA.md): render it (tools/render_mockup.py) and put it on the review board.

## FIRST
1. Collect MODETELLS1, then wire it: the + Add an IF list and the file column show OFTEN / SOME / RARE (ModeTells.band) and
   the tape order (ModeTells.tape_order). Then relaunch Qwen on CLASH6 round 2; run its hidden film YOURSELF before merging.
2. His look at the chart (review board S482) and his play of the fight week gate the rest of PLANFLOW1 stage 1 and FIGHTWEEK3.
3. Q-241 (club week build) - act on his answer.
4. Seat answers as they land (ladder v2 -> two fresh critics via design_loop.py critic).

# S487 handover (written 2026-11-15 at the end of S486; S486's digest: ops/research/S486_DIGEST.md)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S487`.

## USAGE RULES (kept)
- Run `get_usage` first. Start the wrap-up at ~310k, hand over by 420k. Miro P0 redraw once at start, once at the end.
- Godot jobs through `python ops/Tools/godot_slot.py run --who s487 -- <cmd>`; `timeout` OUTSIDE godot_slot; single tests
  `--headless --audio-driver Dummy --fixed-fps 60`. There is no tools/check_scripts.py in Lean: the test run is the parse gate.
- Never `cd` into a worktree; use `git -C <wt>`.
- Arena: pure modules only, no Godot - run its test yourself. `python ops/Tools/lite_mirror.py --lean push` first. Prompt
  recipe: built-in pane, arena.ai/agent, wait ~12 s until the repo row reads FightCamp-Lean-lite / main, click (400,272),
  execCommand insertText, send at (661,377). A NEW task id never reuses an old TASK_<id>.md (check `ls ops/research`).
- seat_dispatch: briefs' OWNS / REGRESSION = plain existing paths (notes on the next line in parentheses); `BASE: <branch>`
  in the Contract starts the worktree from that branch.
- Goose: GOOSE_PER_DAY 3 (UTC day).

## IN FLIGHT (collect, do not resend)
- Qwen CLASH8 (qwen/clash8, wt E:/FightCamp/wt/LEAN_CLASH8, started 13:03, ETA ~14:05): read docs/CLASH8_RESULT.md
  (which layer undoes the clash), run its hidden film yourself (TASK_CLASH8.md film command, seed 4242 and 77). Merge
  qwen/clash7 + qwen/clash8 only with 08_jab and 09_jab at 0 frames > 0.02 m and seed 77 not worse. Then STYLE4 runs on
  Qwen by itself (dispatch queue).
- Arena LOYAL3 (https://arena.ai/agent/01a1dee9-a65e-7ba6-a0f8-c0e38c6372b8, a lite PR): run tests/loyal3_probe.gd; tune
  scripts/rules/Approach.gd constants until each answer is best in a band and none over 60%.
- Seat queue: SQ175 Kalli (ladder v3 -> two fresh critics), SQ176 Kalli (TRAINGAME2 v2 -> two fresh critics).

## FIRST
1. Collect CLASH8 and LOYAL3; seat answers.
2. APPROACHWIRE1 (Claude, R58 map sections 4 M2-M7, 7 and 8): a new scripts/state/ApproachWire.gd - Monday:
   Approach.due(view) per boxer -> f["approach"] {day, group, line, ends: day+7, talk:""}; news + red need on Home; the
   Overview card (five columns from Approach.answers, names only in the header); the talk (Approach.talk, once in 8 weeks);
   the acts: MATCH (second stipend locked 12 weeks), HALF (half state x0.925 both), MOVE (stipend moves, holder -8),
   PROMISE (GymSpend.book_show + Promises.make + the home bout), LET GO (Leaving.leave(c, fid, "approach")); unanswered on
   the end day -> Leaving.leave; the Overview "Let go" with Leaving.let_go_price's confirm; a golden-path test walking one
   approach to each answer. The rules exist: Approach.gd, Promises.gd, Leaving.gd, Loyalty hooks.
3. STEPVALUE1: piece 3 (ropes count) + StepEffect wired into LiveRound; the learn card reads StepValue.
4. Q-S294-246 answer -> FOURSTART1 start state.

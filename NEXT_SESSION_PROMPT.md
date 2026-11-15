# S489 handover (written 2026-11-15 at the end of S488; S488's digest: ops/research/S488_DIGEST.md)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S489`.

## USAGE RULES (kept)
- Run `get_usage` first. Start the wrap-up at ~310k, hand over by 420k. Miro P0 redraw once at start, once at the end.
- Godot jobs through `python ops/Tools/godot_slot.py run --who s489 -- <cmd>`; single tests
  `--headless --audio-driver Dummy --fixed-fps 60`. A Godot command inside a heredoc trips rule_guard: write the runner with
  the file tool (S488 used a repo-root .tmp_s488_tests.sh: `xargs -P 2`, grep FAIL|PASS|SCRIPT ERROR; delete it after).
- Never `cd` into a worktree; use `git -C <wt>`.
- Mutant checks: copy the file to /tmp, sed one mutant, run, restore from the copy (never `git checkout`).
- roadmap.json is UTF-8: open it with encoding='utf-8' in Python.

## IN FLIGHT (collect, do not resend)
- Qwen CLASH9 (glove clipping: why the clash push leaves the guard glove in) - the 30-min dispatch starts it (~15:10 S488).
- Qwen STYLE5 (ops/research/TASK_STYLE5.md) after CLASH9, then WHYGRADE1. Merge STYLE5 only when: the lever counts come
  from StyleLevers.COUNTS (grep the probe for printed constants), tests/style_levers_test.gd passes, every cell's control rate
  is 25-75%, and both gates hold. Add style_levers_test to tools/run_tests.sh on merge.
- Seat queue: SQ177 Dola + SQ178 John score ladder v3 (his board only at depth 7+ from both); SQ179 Dola + SQ180 Maria score
  TRAINGAME2 v2 (6+ depth and general both -> his board).

## FIRST
1. Collect what landed (above).
2. APPROACHUI3: the Week review loyalty row (moves by cause, a band crossed; map R58 s7) + a still of the approach screens
   (Roster flag, Pass price, Money held, People PROMISES OPEN, Rankings tag) on the hidden desktop (tools/hidden_desktop.py,
   layout_snapshot) - open them yourself.
3. STEPVALUE1: ropes count + StepEffect in LiveRound (LiveRound is at the 500-line edge: helpers go in a rules module), the
   learn card reads StepValue.
4. FOURSTART1 test club (his Q-246): three boxers in different classes + one BJJ fighter, picked on the create screen as a
   test start and usable by the tests; the normal start stays 0 fighters.
5. Arena: one pure module (`python ops/Tools/lite_mirror.py --lean push` first).

## Known reds (NIGHTLY1): fight_why (WHYGRADE1), plan_bots, block_meet B_A pro_left_hook control row.

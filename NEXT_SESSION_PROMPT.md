# S490 handover (written 2026-11-15 at the end of S489; S489's digest: ops/research/S489_DIGEST.md)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S490`.

## USAGE RULES (kept)
- Run `get_usage` first. Start the wrap-up at ~310k, hand over by 420k. Miro P0 redraw once at start, once at the end.
- Godot jobs through `python ops/Tools/godot_slot.py run --who s490 -- <cmd>`; single tests
  `--headless --audio-driver Dummy --fixed-fps 60`. A Godot command typed straight into Bash trips rule_guard: write a
  repo-root .tmp_s490_tests.sh runner with the file tool (S489's: xargs -P 2, log to /tmp, grep FAIL|SCRIPT ERROR + the last
  line) and run it through godot_slot; delete it after.
- Never `cd` into a worktree; use `git -C <wt>`. roadmap.json is UTF-8.
- Miro P0: the svg can carry data-deleted lines for surplus slots; deleting needs his OK (S489 left two in place).

## IN FLIGHT (collect, do not resend)
- Qwen STYLE5 (ops/research/TASK_STYLE5.md, worktree E:/FightCamp/wt/LEAN_STYLE5; edits StyleLevers, StyleName,
  LiveRound + tests/style_levers_test.gd + docs/STYLE5_RESULT.md). LiveRound.gd changed on main in S489 (round dict
  "ropes"): apply its DIFF. Merge only when the lever counts come from StyleLevers.COUNTS (grep for printed constants),
  style_levers_test passes, every control rate is 25-75%, both gates hold; add style_levers_test to tools/run_tests.sh.
- Then dispatch CLASH9 (glove clipping: why the clash push leaves the guard glove in; it never started) and WHYGRADE1.
- Seat queue: SQ179 Dola + SQ180 Maria score TRAINGAME2 v2 (6+ depth and general both -> his board).
- His board: Q-247 (season ladder v3). On yes: Kalli closes John's two holes (v3.1), then build after the fight week.

## FIRST
1. Collect what landed (above).
2. STEPVALUE1 lines: Result > The Why AGAINST YOU "On the ropes N times with no way off" (FightWhy reads each round's
   "ropes"), the corner card names a step; then the map's s9 probes before any DENY/OPEN/DRAIN size enters the fight.
3. LIVEROUNDSPLIT1: LiveRound.gd 488 -> under 470 (file_limits_test red): move helpers into a rules/state module.
4. Stills on the hidden desktop: the approach screens and the test club's menus (`-- jump=club4`) - open them yourself.
5. Arena: one pure module (`python ops/Tools/lite_mirror.py --lean push` first).

## Known reds (NIGHTLY1): fight_why (WHYGRADE1), plan_bots, block_meet B_A pro_left_hook control row; file_limits
(LiveRound.gd only).

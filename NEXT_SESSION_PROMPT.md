# S478 handover (written 2026-11-15 at the end of S477; S476's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S478`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310-330k (send Miro partials, not the whole frame).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s478 -- <cmd>`. hidden_desktop takes `--log=<path>` (with `=`).
- Tests run as tools/run_tests.sh does: `--headless --audio-driver Dummy --fixed-fps 60` (block_meet: 30).
- Never `cd` into a worktree (use `git -C` / `--path`).
- Arena: the Lean lite mirror is ICOON-Studio/FightCamp-Lean-lite (branch main) - `python ops/Tools/lite_mirror.py --lean push`
  after committing the brief; arena.ai/agent has that repo pre-selected; a short prompt naming the TASK file works.

## WHAT S477 DID
- Seat answers: WEIGHT1 r5 Maria 7/6 (play 6) PASS (first pass; Dola SQ149 still out). PLANFLOW1 v3 in (Kalli self 7/7/7) - it adds
  result-changing pieces (Main bet, Test it, GUESS, Lean on it), so two critics again before his board: John SQ151 + Maria SQ152.
  LADDER1: John's research in (ops/research/LADDER1_RESEARCH_JOHN_JOHN.md; code claims checked) -> map v1 brief to Kalli (SQ153,
  DESIGN_LADDER1_V1_WRITE_KALLI.md).
- STYLE1 (Arena, launched 00:56, chat https://arena.ai/agent/01a1dc46-8131-7b0e-af3a-6e1d928bcaec): the progression map's probe 12 -
  is each named style worth 1.5-4 wins in 100, does one dominate (ops/research/TASK_STYLE1.md). The six style effects were already
  wired (S459), so PROGBUILD1's "wire the style effects" was stale; title fixed.
- PICKSPREAD1's brief still said OPEN (collected S473): marked DONE, contract line fixed (start's CONTRACT DEFECT is gone).
- CLASH3 glove axis (Claude) is HELD on branch claude/clash3-glove-axis (64e278b6, pushed; NOT on main): GloveClear models
  the glove along the drawn axis (PunchReachMath.along). Films better (see below), hit_frame/hit_carry = main, own_gloves better,
  cam_line/glove_cut/guard_weave pass, BUT block_meet (fixed-fps 30) 1 -> 2: new 'ROW A_A fight pro_left_jab GY_FAIL(-0.083)'
  (bar -0.08, 3 mm). Fix that row (or show it is the catch weight reading a pushed guard glove) before merging.
- BLOCKCLIP1 (Qwen) landed BLOCKED (its own words): MEET_M 0.06 -> 0.075 and SURFACE_M 0.045 -> 0.075 (BlockCatch,
  BlockCatchPoint) cleared 09_cross (main 4.1 -> 1.3 cm) and block_meet 10 -> 1 at 60 fps, but 08_cross still 0.099 m (the
  catching glove does not move when the constants change: some other layer holds it). NOT merged; branch qwen/blockclip1 63f3deda
  pushed; docs/BLOCKCLIP1_RESULT.md there. Next: one trace session on 08_cross f27 (which modifier writes the catching glove
  last), then decide BLOCKCLIP1 + the glove axis together (both touch cross 09).

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen OWNGLOVE1 (launched 01:16 S477, ETA ~02:15 - BLOCKCLIP1 took ~55 min; ops/research/TASK_OWNGLOVE1.md, branch
  qwen/ownglove1, wt E:/FightCamp/wt/LEAN_OWNGLOVE1): tests/own_gloves_test.gd red on main (0.100 / 0.127 m). It starts from main
  (no glove-axis change). Merge bar in its brief; block_meet at fixed-fps 30 on main = 1 failure (CTRL_LANDED B_A RULER_FAIL).
- Arena STYLE1 (above). Collect: read the PR's CI log, `ci_arena.py guard <pr>`, the result doc against the brief's gates.
- Seat queue: SQ144 Kalli fight week map v9 (sparring partner screen replaces trips) - THE FIGHT WEEK BUILD WAITS ON IT; SQ146 Kalli
  club week v8; SQ147 Dola + SQ148 John coach fit v8; SQ149 Dola weight r5; SQ151 John + SQ152 Maria plan flowchart v3; SQ153 Kalli
  ladder map v1.

## FIRST
1. get_usage. Collect OWNGLOVE1 (Qwen) and STYLE1 (Arena).
2. v9 in -> two fresh critics (`design_loop.py critic AMATEURWEEK1_V9 <map> --seat dola|john`) -> 6/6 + depth 7 -> his board WITH the
   redrawn sparring-partner screen (names only in headers). Then Arena: the partner-to-opponent match score as a pure module from v9.
3. TRAINGAME2: Dola draws K (SQ154, answer -> ops/research/TRAINGAME_K_DRAW_S477_DOLA_DOLA.md); save its HTML to
   docs/mockups/s477/training_k/, render with tools/render_mockup.py, replace every "est." with the game's real number, then critics.
   Its lists are in (ops/research/TRAINGAME_CRITIC_S458_J_CLAUDE.md "To reach 10/10": count every
   gain to the bell, price the shared evening in wins for both fighters, Playbook cards on the evenings, twist + diet levers) - a big
   redraw, start it early in a session.

## CLASH3 S477 FILMS (same seeds, main v the glove-axis change; films are deterministic: Claude's main film = Qwen's baseline_77)
- seed 77: frames > 2 cm 8 -> 7; 09_cross 4.1 -> 2.7 cm; 03_lead_uppercut 2.8 -> 2.0 cm; 07_cross 4.6 -> 4.5 (below); 08_cross 9.9
  unchanged (BLOCKCLIP1's).
- seed 4242: 1 -> 2: NEW 02_cross f27 2.9 cm "0l glove x 1r glove (ranks 0 2) drift 0.070" - a BLOCKED cross whose catching glove
  moved 7 cm AFTER GloveClear (drift = BlockCatch's move): judge it with BLOCKCLIP1's films, not GloveClear.
- Films: scratchpad f77/f4242 (after), b77/b4242 (main) - may be gone.

## CLASH3 LEFT
- seed 77 07_cross f19: 4.5 cm "0l glove x 1r fore (ranks 0 1)" - on main too (4.6). Her guard glove (rank 0) inside the other's
  forearm going home (rank 1): by _clear_arms' rules she should take ALL of it (prank > rank -> own 1.0). Run it with GloveClear
  dbg_on (the `before/after` line per side) to see whether the pass sees the overlap at all (the peer's shown arm is a frame old
  + its delta; a fast return may outrun it) or PUSH_MAX_M (0.10 a pass) / the elbow-share `at` caps the move.

## NOTES
- Built and on main, unwired until the fight week switch: WeighGap, BoutSheet, FightWeek, FightWeekEvents, FilmTruth, FightWeekPick,
  RegionShows. FightWeekPick names a trip-free week; check it against v9 before wiring.
- Approved for AFTER the fight week: STEPVALUE1 (+ the ropes count), KNOWLEDGE1, TURNPRO1, R58, HOSTSHOW1, PUSHTANK.
- Ziva idle on purpose in S477: the animation files it would touch (BlockCatch, GloveClear) were being edited by Qwen and Claude.

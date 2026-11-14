# S477 handover (written 2026-11-15 at the end of S476; S475's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S477`.
Miro P0 redrawn at the end of S476 (partial update, no frame rect: works).

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310-330k (send Miro partials, not the whole frame).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s477 -- <cmd>`. hidden_desktop takes `--log=<path>` (with `=`).
- Tests run as tools/run_tests.sh does: `--headless --audio-driver Dummy --fixed-fps 60` (block_meet: 30).
- Never `cd` into a worktree (use `git -C` / `--path`).

## WHAT S476 DID
- KNEEFIX1 (Qwen) collected by diff (aae812d2): rear toes 45, band 20, guard_knee SOURCE = its own ruler's read of the take.
  Its MIN_GUARD_FRAMES 15 -> 8 was REFUSED: the count is the fidget draw (8/150/275 frames on one tree), so the test now watches
  1320 frames, bar 15 kept (fixed-fps 60: 68 / 21 frames). Close stills docs/kneefix1/knee_band_20_*.png on the review board.
- CLASH3 (Claude, GloveClear.gd): off a landing punch the guard arm opens outward only ACROSS the push (the old normalized sum
  cancelled it). hit_frame_film seed 4242: frames > 2 cm 5 -> 3, rear uppercut 6.5 -> 2.8 cm; seed 77: 10 -> 8. One new 4.1 cm
  frame on seed 77 cross 09 (OPEN_SIDE 0.5 tried: worse). hit_frame / hit_carry / block_meet / punch_range are red on main with
  the SAME fail sets (pre-existing; punch_range needs a window).
- LIVERRIBS1: decided - no plan-level aim (the aim is a live shout, reset each bout); the forecast stays. Left: play it in the exe.
- Design loop: club week v7 Dola 7/7, John 6/5, Maria 7/5 -> v8 to Kalli (SQ146); coach fit v8 -> Dola SQ147 + John SQ148;
  weight r5 -> Dola SQ149 + Maria SQ150; step value Maria 7/6 (pass; Dola SQ141 out). Tracker: ops/research/DESIGN_LOOP_S459.md.
- Arena FWTRIPS1 never opened a PR (nothing to close). PRs 291/293/294 closed (collected).

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen BLOCKCLIP1 (launched 00:18, ETA ~02:30; ops/research/TASK_BLOCKCLIP1.md, branch qwen/blockclip1): the catching glove sits
  9.9 cm inside a blocked cross (seed 77 shot 08_cross f27; GloveClear skips blocked punches by design, so BlockCatch MEET_M).
  Merge bar: 08_cross <= 0.02 m every frame, no NEW deep frame on any shot of seeds 77 + 4242, block_meet FAIL set not larger;
  open its f27 stills yourself, then his look.
- Qwen OWNGLOVE1 QUEUED (starts when BLOCKCLIP1 frees the seat, ETA ~05:00; ops/research/TASK_OWNGLOVE1.md): a boxer's own
  two gloves stack through each other in the plain guard - tests/own_gloves_test.gd red on main (0.100 / 0.127 m). Merge bar:
  that test green, OWN film lines down, CLASH lines no new frame, the 6 regression tests' FAIL sets not larger, guard stills.
- Seat queue: SQ144 Kalli fight week map v9 (sparring partner screen replaces trips); SQ145 John LADDER1; SQ143 Kalli plan
  flowchart v3; SQ141 Dola step value; SQ146-150 (above).

## HIS BOARD (answered S476)
- Q-S294-230 STEPVALUE1 (Dola 8/8, Maria 7/6): build after the fight week? On yes: section 10 build order of
  ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md - rule pieces 2-6 are Arena/Qwen pure modules.
- Q-S294-231 the ropes count (three step-backs in a round without a pivot = on the ropes): ANSWERED 'Yes'.

## FIRST
1. get_usage. Collect BLOCKCLIP1. 2. Seat answers: v9 -> two fresh critics (`design_loop.py critic AMATEURWEEK1_V9 <map> --seat dola|john`)
-> 6/6 + depth 7 -> his board WITH the redrawn sparring-partner screen (names only in headers). LADDER1 -> Kalli map -> critics to 9/10.
Plan flowchart v3 -> his board. 3. Arena: a pure module from v9 (partner-to-opponent match score) - `lite_mirror.py --lean push` first.
4. Collect OWNGLOVE1. CLASH3 left: cross 09 seed 77
(the clearance thinks it clear: its forearm-line glove model vs the drawn glove, which keeps the hand's rotation).

## NOTES
- Built and on main, unwired until the fight week switch: WeighGap, BoutSheet, FightWeek, FightWeekEvents, FilmTruth,
  FightWeekPick, RegionShows. FightWeekPick names a trip-free week; check it against v9 before wiring.
- Baseline films (scratchpad, may be gone): seed 4242 jabs=2 crosses=2 uppercuts=1; seed 77 jabs=3 crosses=3 uppercuts=2.

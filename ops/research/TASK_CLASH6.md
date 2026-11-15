# TASK CLASH6 - resolve the glove clash in two phases (all boxers update, then all resolve)

Status: OPEN (S481, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default. Start from origin/main at or after
the S481 commits.

## Why now
CLASH5 (ops/research/CLASH5_RESULT.md, Qwen S479-S481) found the root cause of the last clash frames (seed 4242: 08_jab f40
0.054 m, 09_jab f19 0.057 m): the modifier stacks run one boxer after the other, so the FIRST boxer's ArmClash /
GloveClear reads the peer's `shown_arms` from the PREVIOUS frame. When a glove jumps ~12 cm in one frame after a hit-stop
(clip time catching up + PunchReach settle + HitSnap), the first boxer pushes off a stale place in the wrong direction.
Twelve tunings failed (table in the result page). The fix is structural: two phases.

## What to do
1. Read how the two boxers' modifier stacks run in a frame (scripts/fight3d: GloveClear.gd 434 lines, ArmClash.gd, the rig
   that adds them, the fight scene that owns both rigs). Write down in docs/CLASH6_RESULT.md the order a frame runs today
   (which skeleton first, where shown_arms is written and read).
2. Make the cross-boxer clash resolve with BOTH boxers' current-frame arms: phase 1 = every boxer's layers up to (not
   including) the cross-boxer clash write their current arms; phase 2 = the clash between the two boxers resolves once, with
   both current, and writes each boxer's arm correction. Pick the way that works in Godot 4.7.2 and SAY WHY (e.g. the second
   skeleton's last modifier resolves the pair and applies the first boxer's correction - check on the film that a write to
   the first skeleton then still shows THIS frame, not the next; or a pair node driven from Skeleton3D.modification_processed
   or a process_priority after both rigs). The own-glove pass (OWN_ROUNDS = 2) and the S478 rise gate stay as they are.
3. Then: seed 4242 08_jab AND 09_jab have no CLASH frame deeper than 0.02 m from the hit on; no shot on seed 4242 or seed 77
   gains a CLASH frame it does not have on main; every OWN line stays 0.
4. Regression (headless, `--headless --audio-driver Dummy --fixed-fps 60`): tests/own_gloves_test.gd (green - must stay),
   guard_knee, guard_weave, glove_cut, cam_line (green), hit_frame (3 FAIL on main) and hit_carry (32 FAIL on main) - the FAIL
   set must not grow - and block_meet at `--fixed-fps 30` (1 FAIL on main: CTRL_LANDED B_A RULER_FAIL - same rule).
5. Stills: seed 4242 08_jab f40 and 09_jab f19, main and branch side by side, from the films (docs/clash6/, at most 4 PNGs,
   each < 1 MB). Do NOT commit the film folders.

Film command:
`python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=4242`
(and seed=77). Main today: 08_jab f40 0.054 m, 09_jab f19 0.057 m (seed 4242).

## Pass lines
RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: tools/hit_frame_film.gd seed=4242 -> 09_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: docs/CLASH6_RESULT.md -> phases=2 how=<one line> stills=<n>

## Contract
OWNS: scripts/fight3d/GloveClear.gd, scripts/fight3d/ArmClash.gd, scripts/fight3d/BoxerBuild.gd, scripts/fight3d/ClashPair.gd, docs/CLASH6_RESULT.md, docs/clash6/
(BoxerBuild.gd adds the stack, 223 lines; ClashPair.gd is a NEW helper if the pair resolve needs its own file; FightStage.gd
is 482 lines and NOT yours - if the order has to change there, stop and say so in the result page)
RED_TEST: tools/hit_frame_film.gd seed=4242 jabs=3 crosses=3 uppercuts=2 -> 08_jab and 09_jab CLASH frames deeper than 0.02 m: 0 (main: 1 each)
REGRESSION: tests/own_gloves_test.gd, tests/guard_knee_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd, tests/cam_line_test.gd, tests/hit_frame_test.gd, tests/hit_carry_test.gd, tests/block_meet_test.gd
VISUAL: yes - the f40 / f19 stills main v branch; Claude and the owner judge them
NOT YOURS: every other file (tools/clash_meter.gd, tools/hit_frame_film.gd and all tests stay as they are); never delete or
weaken a test. Every file stays under 500 lines (GloveClear.gd is 434: split a helper out if it grows).
Godot 4.7.2: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe` only (the plain exe, no terminal build). Never open
an image with an app.

## Prior research
ops/research/CLASH5_RESULT.md (root cause + 12 failed tunings); memory S465 (GloveClear), S468 (clash_meter, ArmClash order),
S470 (layer_trace first), S478 (rise gate, own pass order), S479 (CLASH5 brief).
## What would a human do?
Two boxers see each other at the same moment. Let both arms land where their own layers put them, then settle the contact once.
## Prefab check
None: our own animation layers.

## Round 1 result (S482, Claude) - FAIL: the film crashes; round 2 below
Qwen's branch qwen/clash6 (worktree commit 3ca1f325, never pushed) made ArmClash call GloveClear.clash_pair(), which
resolves BOTH boxers - it writes the PEER's skeleton (peer._clear_arms / peer._clear_own) from inside THIS skeleton's
modifier. Its red test was never run (the windowed film was started without hidden_desktop and killed by its timeout).
Claude ran it on the hidden desktop: Godot crashes with signal 11 on the first fight frames. GDScript backtrace:
PunchReachMath.solve:74 <- PunchReach.solve:464 <- GloveClear._clear_own:401 <- GloveClear.clash_pair:217 <-
ArmClash._process_modification:24. Full log: ops/research/CLASH6_R1_CRASH_LOG.txt.
ROUND 2 (same OWNS, same pass lines): a modifier writes ONLY its own skeleton. Keep phase 1 (each GloveClear publishes its
arms before the cross clash). For phase 2 find a write path Godot 4.7.2 allows - e.g. each boxer's ArmClash computes the pair
from both CURRENT published arms and applies only ITS OWN half of the correction (both see the same frame's data, so the two
halves agree), or say in the result page why that cannot work. RUN THE RED TEST through the brief's film line
(hidden_desktop) before you finish; a result with "PENDING" is not a result.

## Round 2 result (S484, Claude) - FAIL, no merge
Qwen commit 32ac0f42 (kept on local branch qwen/clash6-r2, never pushed): both boxers move ARM_SHARE 0.6 of the overlap
plus a clash_pair pass on each own skeleton. Its films (docs/clash6 in the worktree): seed 4242 08_jab 0.051 m f40 (main
0.054), 09_jab 0.062 m f19 (main 0.057); 01_rear_uppercut gains 2 frames (0.047), 04_lead_uppercut 1 (0.028); seed 77
08_jab 0.055 m. Bar is 0 frames > 0.02 m and no new frames - fails both. Two red rounds = audit, not round 3 (S224 rule):
next step is a Claude code audit of the GloveClear / ArmClash order across the two skeletons (which skeleton's modifier
stack runs first, what peer data each reads), before any further tuning brief.

## Audit (S484, Claude) - the root cause is the update ORDER, not the push
Read: GloveClear.clash_pass / _clear_arms (S468-S478), ArmClash.gd, clash_meter.worst, Qwen's two film logs (docs/clash6 in
the CLASH6 worktree), the Godot 4.7.2 Skeleton3D API (probe: modifier_callback_mode_process Physics|Idle|Manual, advance()).
1. The resolver is right only when the boxer drawn SECOND reads the other's arms fresh (own = 1.0: she takes all of what is
   left). At seed 4242 08_jab f40 BOTH boxers logged `late true`: each read the other's arms from the previous frame, and
   boxer 0's ArmClash moved her left glove 10.3 cm that frame into a place boxer 1 still saw empty -> 0.051 m.
2. Across the clash frames of both logs the late flags pair as (true,false), (false,false) and (true,true): the two stacks do
   NOT run once a frame in a fixed order. (false,false) = one stack ran twice in a frame.
3. Why: both skeletons run in Idle mode, and game code re-poses a boxer mid-frame with `ap.seek(t, true)` (HitImpact.gd:49 the
   hit-stop catch-up - exactly the frames after a hit where every failure sits; also MovePlayer 504/528, Clinch, IdleMatch,
   KnockdownCount). A forced pose dirties that skeleton, so its modifier pass happens at another moment than the other's.
4. So no share, pass count or extrapolation can fix it (13 tunings in CLASH5-6). Fix the order: TASK_CLASH7.

# TASK_SMOOTH3 - the clip-change joins, fixed from a code audit: dead blending, capture on the new pose, eased layers (Goose)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main. Discipline: boxing (demo).
Why: operator S316 "the animations look so much better here, but in the fight are nowhere near that smooth"; S347 he asked
again about smoothness. SMOOTH2 ran two rounds on bounds alone and stayed red (OURS 344/min, 168 at a clip change; bound
310/150). Rule: after two red rounds, a code audit before a third. Claude did the audit (S348). It found three defects, and
the first two contradict the file's own header. Fix THESE, in this order, measuring each.

## The audit (S348, main at 8eb312a) - read the code yourself, then fix
1. **Wrong carried velocity** - `scripts/fight3d/JoinSmoother.gd` `_capture()` + `_process_modification()`. The header says
   "Holden's dead blending", but the code is an offset decay. The offset's start velocity is the SOURCE pose's angular speed
   projected on the offset axis (`speed = w.dot(axis)`), and the hips' is the source velocity alone. An inertialized offset
   must start at (source velocity - target velocity), with the full vector, not one axis. Today, every new clip that starts
   moving (a footwork step, a punch out of a moving guard) gets a velocity jump equal to its own first-frame speed.
   FIX: real dead blending (Daniel Holden, "Dead Blending", 2023, theorangeduck.com). At a join, store the shown pose and its
   full velocity per bone (rotation + the hips' position). Each frame, extrapolate that source pose along its velocity, the
   velocity decaying with a half-life (rotation: integrate the angle |w| (1 - e^{-lt}) / l about w's axis). Show
   slerp(extrapolated source, the clip's current pose, w(t)) with w(t) = 1 - (1 + kt) e^{-kt} * envelope(t): k from the
   join's half-life, the existing quintic `_envelope` so w lands on 1 at the join's duration with zero slope. That is C1 at
   both ends, and the target's own velocity never needs to be known. Keep `join(half_life, duration)`, `carry()`, the
   per-join half-life/duration (strike vs back-to-guard, S305) and the `nojoin` control arm.
2. **Capture before the new pose lands** - `FightStage._start()` calls `js.join()` then `ap.play(clip, 0.0)`. When `_start`
   runs inside the AnimationPlayer's `animation_finished` signal (`FightStage._on_finished` -> `guard()` -> `_start`, every
   return to guard), the player has already applied this frame's pose. The modifier then captures against the OLD clip's
   last frame (a near-zero offset), and the new clip's first pose lands NEXT frame with nothing carrying it: an unsmoothed
   pop. `Footwork.gd:221` `stage._start(...)` may hit the same order (check where Footwork sits in the tree against the
   body's AnimationPlayer). FIX in JoinSmoother: `join()` records the AnimationPlayer and the clip. Capture only on the first
   frame where `ap.current_animation == clip` and the player has applied it (`current_animation_position` moved from where
   play/seek left it, or 2 frames passed). Until then keep showing the last seen pose's extrapolation. Prove it: count
   joins whose capture frame saw no pose change (`|new - shown| < 1e-4` on every bone) before and after - before must be > 0.
3. **Layers after the smoother switch per clip unsmoothed** - stack order (BoxerBuild.gd): JoinSmoother, TiredSag,
   GuardTuck, PunchReach, HitSnap, GloveClear, ElbowClear, FootPlant. Everything after JoinSmoother acts on the pose the join
   already smoothed, so a layer whose weight or target jumps at a clip change (GuardTuck only works on guard/fidget/step
   clips; PunchReach arms/disarms per punch; GloveClear pushes) is a kink. SMOOTH2's arms: `noglove` saves ~73/min,
   `noreach` ~57/min. FIX: each such layer eases its own weight in and out (critically damped, same half-life family as the
   joins), and a push is velocity-limited. Never by switching a layer off - they keep gloves out of heads and punches on
   the face. HitSnap stays sharp (operator S301: "the punches feel like they have no power").

## Measure (the red probe first, on main)
`$GODOT_EXE --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/smooth_probe.gd -- show3d`
Main prints `SMOOTH RAW baseline: ... kinks OURS ...: 377/min (696, 203 at a clip change)` (S334; re-read it on today's
main and quote it). Report the line after each fix (1, then 1+2, then 1+2+3) and the same line with `nojoin` as the control.
PASS (bounds): OURS <= 250/min AND "at a clip change" <= 110.

## Guard rails (must stay green)
- `tools/hit_gap_probe.gd -- secs=150 show3d`: `> 0.15 m: 0`, cut off no more than 14 of the punches thrown.
- `tools/inside_guard_probe.gd -- show3d`: glove deep in a head <= 4 frames.
- `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh`: 0 failures.

## Contract
OWNS: Lean/scripts/fight3d/JoinSmoother.gd, Lean/scripts/fight3d/GuardTuck.gd, Lean/scripts/fight3d/PunchReach.gd,
Lean/scripts/fight3d/GloveClear.gd, Lean/scripts/fight3d/FightStage.gd (only `_start()` and `_on_finished()`)
RED_TEST: tools/smooth_probe.gd -- show3d -> OURS <= 250/min AND at a clip change <= 110
REGRESSION: run_tests.sh (all), hit_gap_probe, inside_guard_probe
VISUAL: yes (fight-stills.yml stills + Claude watches a 20 s fight film on the GPU; the operator's OK closes it)
Every owned file stays under 500 lines. Commit only owned files (no generated .uid files).

## Evidence
Your PR runs `.github/workflows/fight-stills.yml`: stills plus every probe's numbers as a PR comment. Quote your own probe
lines in the PR body as `RESULT: <probe> -> <line>`.

## Prior research
Game `research/topics/playback_blend.md` "HOW SMOOTH IS SMOOTH (S119)" (pose AND velocity continuity, not long
cross-fades; into a strike 80-150 ms, back to the idle 200-300 ms); G147 (join times); TASK_SMOOTH2.md (rounds 1-2 and the
control-arm numbers); Bollo GDC 2018 "Inertialization" (Gears of War); Holden 2023 "Dead Blending".

## What would a human do?
An animation programmer debugging pops logs the pose per frame around each transition. Was the target pose there when the
blend started? Is the blend C1 at both ends? Then they switch each post-process layer off one at a time. That is the order
above.

## Prefab check
Godot 4.7's AnimationTree has no inertialization node; AnimationPlayer's crossfade is linear (the velocity jump this
replaces). No plugin does dead blending on a SkeletonModifier3D, so we keep our own 130-line modifier.

## The trap
A longer blend hides kinks and makes the punches late (the hit-gap guard rail). Fix the continuity, never the length.

## ROUND 3 (S352) - Claude collected round 2 (goose/issue-18 @ 0b88e17) on our GPU, `--fixed-fps 30`: NOT merged
Main fa863ae (= 193cec3 for the fight): `SMOOTH RAW baseline ... kinks OURS ...: 305/min (563, 122 at a clip change)`;
`HIT_GAP landed 25 in 150 s | glove to target at contact m: p50 0.008 p90 0.067 max 0.163 | > 0.15 m: 1 (4 %)`, cut off 11 of 36.
1. Your GloveClear did not apply: main replaced your round-1 speed limit with a soft knee (`SOFT_M`, collected in 5f94814).
   Your spring sits on code that is no longer there.
2. Your PunchReach alone (applied clean): `OURS 292/min (540, 117 at a clip change)` - 13 fewer kinks - but
   `HIT_GAP ... p50 0.170 p90 0.310 max 0.591 | > 0.15 m: 15 (60 %)`. The springs on the punch TARGET and the WRIST
   (TARGET_HALFLIFE, WRIST_HALFLIFE) make the glove trail its target: punches land 17 cm short. That is this brief's trap
   ("fix the continuity, never the length"). Also: `print("REACH JUMP ...")` every frame in game code, and `_smooth_target`
   is never reset in `arm()`, so a new punch starts from the LAST punch's target.
3. Where the kinks are (main, `SMOOTH RAW OURS by clip`): pro_left_hook 75, **pro_idle 75**, pro_body_shot 61,
   pro_left_jab_b 45. The idle has no punch reach, so 75 idle kinks come from another layer (GuardTuck, RangeBreath,
   Footwork/FootPlant, TiredSag, the head look, GloveClear). FIND IT FIRST: run smooth_probe once per layer switched off
   (use the modifiers' control-arm flags - `-- nosettle`, `-- noglove`, `-- noheads` exist; add a `-- no<layer>` flag where
   one is missing, read with OS.get_cmdline_user_args() like the others) and print `OURS` per arm. Fix the top source by
   continuity (blend from the previous frame's OUTPUT pose at the switch), never by delaying a target.
Branch from main fa863ae again; keep nothing of round 2. Bounds unchanged: OURS <= 250/min AND at a clip change <= 110;
hit_gap `> 0.15 m` no worse than main's 1 and cut off <= 14; inside_guard_probe glove deep in a head <= 4 frames.
PR body: one `RESULT:` line per arm (main, each layer off, your fix) + the hit_gap and inside_guard lines.

## ROUND 4 AUDIT (S355, Claude) - before any round 4 (three red Goose rounds)
Main 9092e67 (CLINCH2 in), hidden desktop, `--fixed-fps 30`: `SMOOTH RAW baseline: 55 clips sampled | kinks OURS: 351/min
(648, 143 at a clip change)`; by clip pro_idle 110, pro_left_hook 77, pro_body_shot 60, pro_left_jab_b 48, pro_left_hook_v2
37, clinch_vic 36, clinch_att 32 (the clinch clips are new since S352's 305/min). The per-layer arms were VOID: they ran
across Lean c24500d, whose weekly twist cards change the career path into fight night (two arms crashed on a weigh-in a
twist cost before the fight-week rule). Rerun every arm on ONE commit >= c24500d (layer flags change only the 3D view, so
one commit = one fight): plain + noguard noreach nosnap noglove nojoin nofeet nosettle noheads. The top source of the idle's
kinks goes into ROUND 4 for Ziva (wt/ZIVA_LEAN, branched from Lean main); fix by continuity, never by delaying a target.
Bounds unchanged.

## ROUND 4 (S356, Claude) - the audit is done: PunchReach first, then GloveClear (Ziva, wt/ZIVA_LEAN from Lean main ef7ff01)
All nine arms on ONE Lean commit (14bb6b7), hidden desktop, `--fixed-fps 30`, 90 s of round time each; logs in Lean
`docs/playtest/smooth3_audit/` (one `<arm>.log` each, `runner.txt` the times). `SMOOTH RAW baseline ... kinks OURS`:

| arm | OURS/min | at a clip change | pro_idle |
|---|---|---|---|
| plain | 353 | 137 | 107 |
| noreach (PunchReach off) | **259** | **90** | **59** |
| noglove (GloveClear off) | 271 | 111 | 68 |
| nosnap (HitSnap off) | 316 | 114 | 70 |
| noheads (GloveClear head lean off) | 331 | 138 | 96 |
| nosettle (PunchReach re-land off) | 347 | 132 | 111 |
| noguard (GuardTuck off) | 375 | 143 | 115 |
| nojoin (JoinSmoother off) | 608 | 221 | 147 - JoinSmoother is doing its job; keep it |
| nofeet | VOID - the fight view never loaded (smooth_probe.gd:59 `view` null with FootPlant off); not needed for this round |

THE TOP SOURCE IS PunchReach (94 of 353 a minute, 48 of the idle's 107, 47 of the 137 at a clip change). The audit's
reading of the code (Lean scripts/fight3d/PunchReach.gd, 222 lines): `disarm()` (line 61) starts a fade when the punch clip
changes before its reach is done (a hit, a corner, the next exchange) - the fade lasts FADE_S 0.12 s = under 4 frames at
30 fps, and it keeps pulling the hand toward the LIVE target callable (`_fades[hand]["target"]`) while the base pose under
it is already the idle. A 4-frame pull toward a moving point is the kink the probe counts, and it lands in pro_idle.
FIX BY CONTINUITY (the brief's rule - never by delaying or shortening a punch's own reach):
1. At disarm, capture the hand's last OUTPUT world position/basis (what the reach left on screen) and fade from THAT fixed
   pose toward the base pose - not from the live target.
2. Fade over at least 0.20 s (6 frames at 30 fps), eased (keep the smoothstep complement).
3. Leave `weight()` and the armed reach alone: HIT_GAP must not move.
Then GloveClear (second: 82 a minute, 39 of the idle) by the same rule if the bound is not met after PunchReach.
BOUNDS (unchanged): OURS <= 250/min AND at a clip change <= 110; hit_gap `> 0.15 m` no worse than main and cut off <= 14;
inside_guard_probe glove deep in a head <= 4 frames. Measure on ONE commit, plain + your fix, `--fixed-fps 30`.
PR/report: one `RESULT:` line per arm (main plain, your fix, your fix + noglove) + the hit_gap and inside_guard lines.

## ROUND 4 VERDICT (S358, Claude - read from Ziva's logs myself, wt/ZIVA_LEAN docs/playtest/smooth3_r4/, ziva/smooth3-r4 36f80cc)
NOT MERGED. `SMOOTH RAW baseline ... kinks OURS` per arm (main plain at S356 = 353/min, 137 at a clip change; noreach 259/90):

| arm (r4 code) | OURS/min | at a clip change | note |
|---|---|---|---|
| plain | - | - | VOID: the log has no RAW baseline line (S357 read 340/min) |
| noreachin | 332 | 104 | |
| noreachout | 359 | 140 | over 110 |
| noreach | 262 | 88 | = main's noreach 259: the r4 fade buys nothing |
| nolean, nofade | - | - | VOID: rc=124 (12 min timeout) |

hit_gap `> 0.15 m`: 3 of 26 (main 1) - WORSE. New defect: every run logs `Basis ... must be normalized in order to be casted to
a Quaternion` from PunchReach.gd:172 `_apply` - `Quaternion(g_hd.basis)` on a SCALED bone basis (the MetaHuman skeleton carries
scale), so the fade slerps between garbage rotations. The arms also show the bound is out of reach by PunchReach alone:
with PunchReach fully OFF it is still 259-262.

## ROUND 5 (S358, Ziva, wt/ZIVA_LEAN - stays on ziva/smooth3-r4 at 33de908: its Basis fix + the arm switches are kept; sent 08:40, Ziva Smart, effort Max)
0. AUDIT ARM FIRST, before any fix: `smooth_probe.gd -- noreach noglove show3d` on main. If OURS > 250 with BOTH layers off,
   stop and report the next layer (one more arm each: nosnap, noheads) - no fix round on a layer that cannot reach the bound.
1. PunchReach fade: quaternions from `basis.get_rotation_quaternion()` (and carry the scale back), never `Quaternion(basis)`.
   A log with the `must be normalized` ERROR is a FAIL.
2. Fade from the captured OUTPUT pose (r4's idea) eased >= 0.20 s; leave `weight()` and the armed reach alone.
3. GloveClear by the same continuity rule if the bound is not met after 1-2.
Every arm runs `--fixed-fps 30` with timeout 900 s on ONE commit; an arm with rc=124 or no `SMOOTH RAW baseline` line is VOID
and reruns - never reported. BOUNDS unchanged: OURS <= 250/min AND at a clip change <= 110; hit_gap `> 0.15 m` <= main's
(rerun main's hit_gap on the same commit and quote it); cut off <= 14; inside_guard glove deep in a head <= 4 frames.
Report: one `RESULT:` line per arm with the raw RAW-baseline line pasted under it - Claude checks each against the bound.
Round 4 close-out (Ziva 33de908 "Fix Basis->Quaternion orthonormalization"): the fix is right, but SMOOTH3_r4_result.md re-quoted
S357's 340 and main's 259 - none of its *_final logs has a RAW line (smooth_probe's _raw_baseline replays every clip after the
fight; Ziva's 300 s timeouts killed it). inside_guard after the fix: glove deep in a head 1 of 657 inside frames (PASS; it wrote 3).
hit_gap after the fix: > 0.15 m still 3 of 26.

## ROUND 5 VERDICT (S358, Claude - Ziva logs wt/ZIVA_LEAN docs/playtest/smooth3_r5/, each RAW line opened)
| arm | OURS/min | at a clip change | log |
|---|---|---|---|
| noreach + noglove (audit) | **228** | **86** | noreach_noglove.log - the bound IS reachable with both layers off |
| plain 33de908 | 357 | 140 | plain.log |
| GloveClear eased offset (cf3922e + dfe1790) | 359 | 141 | plain_glovefix.log - no gain |
hit_gap > 0.15 m: fix 2 / main 2 (8 %), cut off 10 / 10. inside_guard glove deep in a head: fix **7** of 657 / main 1 - FAIL (<= 4).
NOT MERGED. Five rounds of eased fades (Goose r1-r3, Ziva r4-r5) moved nothing: the kinks are not at layer transitions.

## ROUND 6 (S358, Ziva, queued 09:05) - DIAGNOSIS ONLY
Revert cf3922e/dfe1790 on the branch. smooth_probe.gd: per OURS kink, record PunchReach weight + phase (IN/HOLD/OUT/fade/none),
GloveClear push/head-lean, the reach TARGET's own second difference, HitSnap. One table: kinks by layer+phase and how many
have target 2nd diff > 0.02 m. Plain, 900 s, RAW line required. Only tools/smooth_probe.gd changes. Result:
docs/ziva/SMOOTH3_r6_diagnosis.md. Claude's working hypothesis to test: the armed reach copies the moving head's own jolts
(HitSnap knocks the target) into the glove - a target-side cause no fade can fix.

## ROUND 6 RESULT (S358, Claude - Ziva stalled twice at the probe edit, 09:11 and 10:47)
Ziva reverted cf3922e/dfe1790 (76269b5, 565ff1d) and then ended two turns without a tool call. Claude wrote the probe
instrumentation (ziva/smooth3-r4 69ced03, tools/smooth_probe.gd: every OURS kink by the layers on in its 3 frames, against
the point-frames with the same layer set) and ran plain: docs/playtest/smooth3_r6/plain.log
`SMOOTH RAW baseline ... OURS 341/min (631, 134 at a clip change)`.
`SMOOTH KINK BY LAYER: none 238/16325, G 118/832, G+L 69/501, S 47/867, RIN 34/95, ROUT 26/72, F 21/49, RHOLDOUT 17/50, L 15/798, RHOLD 12/48 ...`
`SMOOTH KINK TARGET: armed 119, target jolt > 0.02 m 32 | armed frames with a target jolt 83 of 389`
Reading: the reach kinks ~30 % of its frames (IN_S/OUT_S = 4-5 frames at 30 fps; a 4-frame smoothstep adds ~0.34 x the
correction as second difference); the fade ~40 % (it held an ABSOLUTE pose: velocity to zero in one frame); the glove push
~13 % (~200 kinks; 4 cm soft knee). Target jolts explain only 32 of 119. Diagnosis: docs/ziva/SMOOTH3_r6_diagnosis.md.

## ROUND 7 (S358, Claude, ziva/smooth3-r4 957298c)
- PunchReach IN_S 0.14 -> 0.24, OUT_S 0.16 -> 0.26 (ramp clamped to the clip start); `-- shortramp` = old.
- PunchReach fade eases the reach's OFFSET (output - base at the leave) over the live base pose; `-- absfade` = old hold.
- GloveClear SOFT_M 0.04 -> 0.10 (d + push never under CLEAR_M, so no deeper glove); `-- hardknee` = old.
Gates: smooth_probe plain (OURS <= 250/min, <= 110 at a change), inside_guard deep <= 4, hit_gap > 0.15 m no worse than main.
Logs: docs/playtest/smooth3_r7/{plain,inside_guard,hit_gap}.log.

## ROUND 7 VERDICT (S358) - NO GAIN, reverted on the branch (35a4d7d)
smooth3_r7/plain.log: OURS **342/min (632, 142 at a change)** vs r6 341 (631) - nothing moved. Layer rates: RIN 40/131 (31 %),
ROUT 28/80, F 22/73, G 105/1127 (9 %), G+L 90/864 - the longer ramps and the wider knee only spread the same kinks over more
frames. inside_guard deep 0 of 657 (main 1) - better; hit_gap > 0.15 m 3 of 26 (main 2) - worse.
Why the ramp theory failed: the reach output is base + w (target - base); its second difference carries -2 w' base', the
punch's own velocity times the ramp slope - a fast glove bent onto a fixed point at ANY ramp length (a real glove also stops
on a face). Seven rounds on this proxy moved nothing a viewer has been shown. NEXT: an A/B film for the operator (plain vs
noreach+noglove, same build, game camera, 45 s, tools/smooth_probe.gd `-- noraw secs=45`, ziva/smooth3-r4 7ab8131): if he
cannot see a difference, the 250 bound is retired and SMOOTH3 closes on the r4 PunchReach fade (C1-continuity) + Basis fix;
if he can, the next round removes the reach's position blend (arm the clip's own path and retime it to contact instead).

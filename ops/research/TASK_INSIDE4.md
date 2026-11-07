# TASK INSIDE4 - QWEN (qwen3-coder) - does a folded face still sink into the other boxer, measured in a played fight?

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (inside range of the live 3D fight).
START FROM Arena's round (INSIDE3, PR #71, branch arena/6e41a147-fightcamp-lean):
`git checkout origin/arena/6e41a147-fightcamp-lean -- scripts/fight3d/GloveClear.gd tests/head_torso_clear_test.gd`

## Contract
OWNS: tools/head_torso_probe.gd, scripts/fight3d/GloveClear.gd, tests/head_torso_clear_test.gd
RED_TEST: tests/head_torso_clear_test.gd -> HEAD_TORSO failures=0
REGRESSION: inside_beats_test, inside_exits_test, fight_polish_test, body_keep_test, foot_plant_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/fight3d_film.gd -- E:/FightCamp/tmp/inside4 short

## Why
S393 (ops/research/INSIDE_WORK_S393.md): two blind judges saw a boxer fold over a body shot with her face sunk in the other's
torso for ~0.5 s, in a PLAYED fight (film 0:53.6-54.0; control 1:10.1, 1:16.2). Two rounds tried to fix it with a standing test:
Goose (INSIDE2) and Arena (INSIDE3, PR #71: GloveClear._clear_torso). Claude ran Arena's test with the stage aimed at the inside
spell (hips 0.63 m apart, the fight's real inside gap): the folded head stays 0.54-0.62 m from the other's torso segment on every
gut-shot take, on main AND with _clear_torso - in a standing setup there is nothing to fix, so that test cannot judge the fix.
S393 also added fold room (HitSnap "how far she is folded right now", RingPlace gives her room), so the fault may be gone already.
Measure it where it happened: in played rounds.

## Do
1. Write tools/head_torso_probe.gd on the model of tools/body_react_probe.gd (three LIVE rounds of fight night through the
   tools/fight3d_play.gd flow, the bodies as SHOWN - tools/pose_tap.gd as the last modifier). Every frame, for each boxer: her
   head centre (GloveClear's own formula) to the OTHER boxer's torso segment Hips -> UpperChest, and the clip each one plays.
   Print a line per frame under 0.20 m (time, who, distance, both clips) and a summary:
   `HEAD_TORSO_PROBE frames=<n> under_0.20=<n> worst=<m> spells=<n spells under 0.20 lasting >= 0.2 s> GLOVECLEAR=<main|torso>`.
   Run it as body_react_probe.gd says (the never-shown desktop: `python tools/hidden_desktop.py run ...`, --fixed-fps 30,
   --audio-driver Dummy; never a window on screen).
2. Run it on main's GloveClear (`git show origin/main:scripts/fight3d/GloveClear.gd`) and on Arena's (_clear_torso), same seed.
   Write both summaries in the PR body.
3. If main shows spells under 0.20 m: keep _clear_torso, make it soft (the same SOFT_M knee as _clear_head, so it eases in, no
   pop) and respect the `heads` switch (`-- noheads` control arm); then make tests/head_torso_clear_test.gd reproduce a real
   overlap (place the pair as the probe found them at the worst frame: the hips gap and the two clips/times it printed) so the
   test FAILS on main and PASSES with the fix. If main shows NO spell under 0.20 m in three rounds: say so - the S393 fault is
   gone; do not change GloveClear.gd, and leave the test as Arena's plus the harness fix.
4. Keep every REGRESSION test green. Do not touch HitSnap.gd, BeatFire.gd, BeatClips.gd, FootPlant.gd, RingFeet.gd, Clinch.gd,
   the fight model (scripts/rules, scripts/state, scripts/world), ops/ or tools/run_tests.sh. Files under 500 lines.

## Result lines (PR body)
RESULT: HEAD_TORSO_PROBE main  frames=.. under_0.20=.. worst=.. spells=..
RESULT: HEAD_TORSO_PROBE torso frames=.. under_0.20=.. worst=.. spells=..
RESULT: tests/head_torso_clear_test.gd -> HEAD_TORSO failures=0 (and on main: failures=<n>)
RESULT: regression <pass/fail per test>

## Prior research
ops/research/INSIDE_WORK_S393.md; TASK_INSIDE2.md; TASK_INSIDE3.md; PR #71 comments; tools/body_react_probe.gd;
tools/inside_guard_probe.gd; GloveClear.gd S315/S316 notes.

## What would a human do?
Watch the real fight frame by frame where the judges saw it, count how often it happens, and fix it only if it still happens.

## Prefab check
No asset.

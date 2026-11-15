# TASK CLASH10 - clear the glove on the axis it is DRAWN on, re-read after each push, inside the clash pass (on main)

Status: OPEN (S493, Claude main: the CLASH7-9 audit). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## The audit (Claude read the three branches, S493)
- CLASH7 (qwen/clash7, in PR 313): SkelPump runs both boxers' modifier stacks in a fixed order. On that branch
  tests/hit_carry_test.gd reads 34 failures and tests/hit_frame_test.gd 5 (PR 313's dispatcher checks). NOT taken.
  This task starts from MAIN, without SkelPump.
- CLASH8 (docs/CLASH8_RESULT.md on qwen/clash8): no layer after ArmClash moves the gloves back. GloveClear clears a capsule
  along the FOREARM ((wrist - elbow)); the glove is DRAWN along Gloves._follow's axis (knuckle direction slerped 0.85 to the
  forearm, scripts/fight3d/Gloves.gd:104-117); tools/clash_meter.gd measures the drawn axis. Up to 6 cm apart at the end.
- CLASH9 (docs/CLASH9_RESULT.md on qwen/clash9): with the drawn axis used once, the push moves the wrist, the knuckle bone
  moves with it and the DRAWN AXIS TURNS - the glove lands in a new overlap (f12: before 0.128, wrist moved 0.106, after
  0.011; 09_jab f19 got worse, 0.057 -> 0.120). Diagnosis (c). Option 1 (iterate) is what this task builds, and it is NOT
  "a clamp layer after everything": it stays inside GloveClear.clash_pass, which already runs OWN_ROUNDS rounds.

## What to build (GloveClear.gd only, unless step 3 proves Gloves.gd must expose a helper)
1. Take CLASH9's `_glove_along(skel, ids, k)` helper (qwen/clash9, scripts/fight3d/GloveClear.gd: the same formula as
   Gloves._follow, reading the same bones; the knuckle bone index in `_arms`). Copy the helper and the index only - not the
   clash9_log instrumentation and not SkelPump.
2. In `_clear_arms` (the other boxer's arms, glove-on-glove only): build the capsule on the DRAWN axis, push, then
   RE-READ the drawn axis from the bones (the re-solve has moved the knuckle) and re-measure; repeat up to GLOVE_ITERS = 3
   (P) times per call while the drawn-axis depth > 0.005 m. PUSH_MAX_M per iteration stays 0.10.
3. Leave the forearm capsule for glove-on-forearm (unchanged) - only glove-on-glove uses the drawn axis.
4. A frame budget guard: count iterations; print nothing in a normal run.

## Measure (write docs/CLASH10_RESULT.md, short)
- tools/hit_frame_film.gd seed=4242: 08_jab and 09_jab "CLASH frames deeper than 0.02 m from the hit on" (main today: 1 each,
  0.054 / 0.057 m). Target 0 each.
- seed=77: not more CLASH frames than main.
- tools/clash_meter.gd on both clips: the worst depth, main vs yours.
- The mean iterations used per frame (from the guard's counter, printed by the film tool's summary only).

## Contract
BASE: main
OWNS: scripts/fight3d/GloveClear.gd, docs/CLASH10_RESULT.md (scripts/fight3d/Gloves.gd only if step 1 cannot read the
same bones from GloveClear - say which line and why)
RED_TEST: tools/hit_frame_film.gd seed=4242 -> 09_jab CLASH frames deeper than 0.02 m from the hit on: 0 (main reads 1, f19 0.057 m)
REGRESSION: tests/own_gloves_test.gd, tests/hit_carry_test.gd, tests/hit_frame_test.gd, tests/cam_line_test.gd
(one by one, `--headless --audio-driver Dummy --fixed-fps 60`; each must read on your branch what it reads on main)
VISUAL: yes - stills only through tools/still_framing.gd save_if_framed; Claude opens them, the owner closes it.
NOT YOURS: every other file. GloveClear.gd stays under 500 lines (434 today). Work on qwen/clash10, commit, push, never merge.

## Prior research
docs/CLASH8_RESULT.md and docs/CLASH9_RESULT.md (on their branches: `git show origin/qwen/clash9:docs/CLASH9_RESULT.md`);
ops/research/TASK_CLASH9.md; S478 (OWN_ROUNDS) and S465 (`-- ballclash`) notes in GloveClear.gd's comments.

## What would a human do?
An animator fixing gloves that sink into each other moves the glove by its own shape, looks again, and nudges once more if
the wrist turn pushed it back in - a couple of small corrections, not one big shove on the wrong outline.

## Prefab check
Godot's physics would need colliders on both skeletons' gloves and a solver step inside the modifier stack - more cost and
jitter than a capped 3-step capsule push. Our own code.

## The one trap
`var x := <an Array or Dictionary element>` is a Variant -> parse error; write `var v: Vector3 = arr[i]`. Never kill Godot by
image name; never `_console.exe`; nothing opens on screen.

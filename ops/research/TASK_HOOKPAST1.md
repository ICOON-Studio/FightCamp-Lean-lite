# TASK HOOKPAST1 - a ruler for the fling: after a landed punch, how far and how fast does the glove go past the head?

Status: OPEN (S506, Claude main). Discipline: boxing. Model: Qwen (qwen4-max), default.

## Why now
Fight motion week. Blind round r11, both critics' third change: "no upward arm flings after a punch; hooks stop at the
head". tests/hit_frame_test.gd reads 0.24-0.36 m of carry on a few hooks (pro_left_hook_ft, _hurt_ft, right_hook_hard),
but that test plays the clip's own hips, not the game's footwork. We need the number from the FILM (the game as shown).

## What to build
1. `scripts/rules/HookPast.gd` (new, pure static, ZERO preloads). `analyse(rows: Array) -> Dictionary` over shown.csv
   rows (Strings; columns `frame`, `who`, `clip`, `hold`, and `<Bone>_x/_y/_z` world metres for Head, LeftHand, RightHand,
   UpperChest).
2. A PUNCH RUN as in `scripts/rules/PunchEnd.gd` (copy PUNCH_WORDS / EXCLUDE_WORDS and its contact rule: the first frame
   of the run with `hold` > 0 and the punching hand at least CONTACT_REACH of its run's furthest reach - read PunchEnd for
   the exact rule; do not preload it). The punching hand = the hand that moves furthest from UpperChest in the run.
   Only runs WITH a contact frame count (landed or blocked).
3. Per run, from the contact frame to the end of the run (or 12 frames, whichever first), the punching hand's:
   `past_cm` = the largest distance from its contact position (cm); `up_cm` = the largest rise above its contact height
   (cm); `fling_mps` = the largest one-frame speed (m/s, 30 fps: cm per frame * 0.3); `fling_frame` = the frame (from
   contact) of that speed; `kind` (jab / cross / hook / uppercut / body from the clip name).
4. Summary: `runs`, `past_p50`, `past_p90`, `up_p90`, `fling_p50`, `fling_p90`, `flings` (runs with fling_mps > 6.0 after
   frame 2), and `by_kind` {n, past_p90, fling_p90, flings}. Also `worst`: the 5 runs with the biggest fling_mps
   (clip, who, start frame, fling_mps, past_cm, up_cm).
5. `tools/hook_past_probe.gd -- csv=<path>`: one line per worst run, then the last line exactly
   `HOOK_PAST runs=<n> past_p50=<a.a> past_p90=<b.b> up_p90=<c.c> fling_p50=<d.d> fling_p90=<e.e> flings=<k>`.
6. `tests/hook_past_test.gd`: fixtures built in code: a hook whose glove stops at contact and comes home at 3 m/s (no
   fling); a hook whose glove flies on 30 cm across and up at 10 m/s two frames after contact (a fling, up_cm > 10); a
   run without a hold frame (not counted); the left and right hand; an empty input. Print `HOOK_PAST_TEST failures=<n>`;
   quit(1) on failures.

## Contract
OWNS: scripts/rules/HookPast.gd, tests/hook_past_test.gd, tools/hook_past_probe.gd
RED_TEST: tests/hook_past_test.gd -> HOOK_PAST_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. One test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/hook_past_test.gd -> HOOK_PAST_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/s505b/shown.csv` and `E:/FightCamp/tmp/fightweek/s506a/shown.csv`.

## Prior research
`scripts/rules/PunchEnd.gd` (contact rule, runs), `scripts/rules/FreeHand.gd`, `scripts/rules/HeadEase.gd` (csv rows).
`ops/research/GDSCRIPT_TRAPS.md`.

## What would a human do?
A coach watches the hook land: the fist stops at the jaw and the arm comes back on the same line. If the fist sails on
past the head and up over it, he calls it a swing, not a hook.

## Prefab check
None: loops over csv rows like PunchEnd.

## The one trap
Both boxers are interleaved per frame - build runs per `who`. Csv values are Strings - `float()` each.

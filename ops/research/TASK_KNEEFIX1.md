# TASK KNEEFIX1 - rear knee: honest bar + the setting that meets it, with guard stills (change + stills)

Status: OPEN (S475, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
docs/KNEERULER1_RESULT.md: the plane ruler in tests/guard_knee_test.gd reads the RAW take (rig off) as rear +0.0171 / +0.0181,
lead -0.0113 / -0.0105 (b0 / b1) - only ~60% of the outside-the-game number +0.0291 the test uses as SOURCE. The valgus ruler
reads the raw take true. So the bar compares the game against a number its own ruler can never read. Calibrate SOURCE to the
ruler's read of the raw take, then use the setting the KNEESWEEP2 table already shows inside both bars:
REAR_YAW_DEG -45 + REAR_BAND_DEG 20 (KNEE_TURN 45): rear -0.0067 / +0.0020 (within 0.03 of +0.0176), valgus 19.4 / 19.6 (bar 20),
footwork 0 failures. CAUTION: scripts/fight3d/BoxerFootwork.gd line 60 says 45 was once rolled back to 32 because "the rear knee
caved" - so the stills decide, not the numbers.

## What to do
1. tests/guard_knee_test.gd: `const SOURCE := [-0.0109, 0.0176]` with a comment: "S475 KNEERULER1: the take as THIS ruler reads it
   (tools/knee_plane_probe.gd off=all, mean of b0/b1); tools/knee_plane_raw.py's -0.0065 / +0.0291 is the same take read outside
   the game". Keep MEAN_BAR and the 8 cm mutant check unchanged.
2. Run guard_knee_test on main settings FIRST and record it (expect red: b0 rear -0.0311).
3. scripts/fight3d/BoxerFootwork.gd REAR_YAW_DEG -32.0 -> -45.0 (comment: S475 KNEEFIX1, why); scripts/fight3d/BoxerFootworkRig.gd
   REAR_BAND_DEG 18.0 -> 20.0 (comment).
4. Run: tests/guard_knee_test.gd, tests/boxer_footwork_test.gd, tests/knee_track_test.gd, tests/foot_plant_test.gd,
   tests/ring_feet_test.gd, tests/human_feet_test.gd (all with `--fixed-fps 60` as tools/run_tests.sh does). All must pass.
5. Stills, game camera, BOTH settings (main and fixed), guard idle AND mid-jab, the two boxers head to feet - ONLY through the
   tools that already enforce framing: Godot/tools -> here `tools/fight3d_play.gd` (real flow) or `tools/fight3d_still.gd`
   (poses) run on the hidden desktop:
   `python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/fight3d_still.gd -- <out_dir>`
   Save to docs/kneefix1/ (main_*.png, fix_*.png), at most 8 PNGs, each under 1 MB. Never open an image with an app.
6. Write docs/KNEEFIX1_RESULT.md: the test lines before/after, the still list, one paragraph.

## Pass lines
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
RESULT: tests/boxer_footwork_test.gd -> BOXER_FOOTWORK failures=0
RESULT: docs/KNEEFIX1_RESULT.md -> stills=<n>

## Contract
OWNS: tests/guard_knee_test.gd, scripts/fight3d/BoxerFootwork.gd (REAR_YAW_DEG line only), scripts/fight3d/BoxerFootworkRig.gd (REAR_BAND_DEG line only), docs/KNEEFIX1_RESULT.md, docs/kneefix1/
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0 (red on main: b0 rear -0.0311 v the source)
REGRESSION: tests/boxer_footwork_test.gd, tests/knee_track_test.gd, tests/foot_plant_test.gd, tests/ring_feet_test.gd, tests/human_feet_test.gd
VISUAL: yes - guard + mid-jab stills on the game camera, both settings; Claude and the owner judge them
NOT YOURS: every other file; never delete or weaken a test (MEAN_BAR and the mutant check stay).
Godot 4.7.2 headless for tests: `<godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/<name>.gd`.

## Prior research
docs/KNEERULER1_RESULT.md, docs/KNEESWEEP1_RESULT.md, docs/KNEESWEEP2_RESULT.md (the table this picks from), memory S472/S473.
## What would a human do?
Measure the reference with the same tape you measure the copy with; then turn the back foot out to where the take has it and
look at the boxer before calling it done.
## Prefab check
None: our own rig setting.

# NIGHTLY1 - the boxing-path nightly reds that nobody owns (gloves hang, readable onset hang, asset manifest, flip-hangs)

Model: Codex (gpt-6-astra, medium) - or Cline/Qwen if that seat frees first. Worktree E:/FightCamp/wt/<seat>, branch
`<agent>/nightly1` from origin/master. Nothing opens on the operator's screen (file tool only; Godot windowed only via
`Tools\godot_hidden.ps1`). Run Godot at IDLE priority, one Godot process at a time, never the full suite.

## Why
The nightly (`AgentComms/nightly/latest.txt`, 2026-10-03 at 9c53c6a4: 510 tests, 20 fail) cannot go green, so a NEW red
is invisible the day it lands. S153 fixed 4; the S152 handover fixed front_door. These remain, red 3-4 nights, no owner:
| test | nightly line | demo path? |
|---|---|---|
| fighter_gloves_both_corners_test | hang (timeout); earlier 533 s then rc=127; `FightClipRetarget._load_fbx` prints "Reading less data than requested" on every corner via `build_silhouette_corrections` | YES (gloves on both boxers) |
| fight_readable_onset_test | hang (timeout) | YES (strikes readable in the room) |
| asset_manifest_test | reports its own failure, exits 0 (`ASSET MANIFEST packs=25 approved=20 candidate=3 placeholder=1 rejected=1 ... warnin...`), red since 10-01 | YES (what ships, licences) |
| fight_grapple_seam / fight_room_positions / fight_strike_speed / fight_stage_realism | flip hang <-> pass across nights (load timeouts) | partly |
NOT in this task (owned elsewhere or parked on purpose): fight_pair_live + fight_stage_presenter (parked by operator
2026-09-15), fighter_reachability_contract (KM3), fight_body_overlap / stage_technique_fidelity / ring_position (C223/Q213
line), MMA-only reds (plan_ai_corner, back_bands, footwork_economy - MMA update, off the demo path).

## Prior research
S153_DIGEST.md (the 4 fixed reds and the flip-hang note), S124_DIGEST.md "Nightly reds and tooling", S122_DIGEST.md (5
nightly reds), `Godot/tools/run_tests.py` l.224-238 (`SLOW_TEST_TIMEOUT_S` - the S132 precedent: a test that PASSES in
657 s was "hang" every night; the fix was a measured per-test timeout, not a blind raise), memory "An idle Godot tool is a
script error" (~0.15 core and no I/O = `_run` died on a SCRIPT ERROR; use `--log-file` and read it first).

## What would a human do?
Run each red alone with a log file, time it, read the first error line, and fix the cause - a bad file, a repeated load,
a script error - before touching any timeout.

## Prefab check
`run_tests.py` already has `SLOW_TEST_TIMEOUT_S` (per-test timeout). `FightStagePlayer` already caches corrections per
reference (`_corrections`, l.1995-2001); `FightClipRetarget.build_silhouette_corrections` (l.281) and `_load_fbx` (l.988)
have no cache - a static path->scene/bytes cache there is the obvious prefab-free fix IF repeated loads are the cost.

## Owned files
- `Godot/scripts/FightClipRetarget.gd` (only `_load_fbx` / `build_silhouette_corrections` region, l.281-300 and l.988-1006)
- `Godot/tools/run_tests.py` (`SLOW_TEST_TIMEOUT_S` only, l.224-226, with the measured time in the comment)
- `Godot/tests/fighter_gloves_both_corners_test.gd` (85), `Godot/tests/fight_readable_onset_test.gd` (199),
  `Godot/tests/asset_manifest_test.gd` (190) - fix a TEST only when the test is wrong; say why in the digest
- `Godot/assets/**/manifest*.json` / the asset manifest data the test reads - only to record a real asset honestly
- `research/NIGHTLY1_DIGEST.md`

## Spec, in order (one red at a time; each gets a before line and an after line)
1. For each red: run it alone (`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --log-file <abs>.log --script tests/<name>.gd`,
   timeout 1200 s), record wall time + rc + the FIRST error line. A hang at ~0.15 core = script error: read the log.
2. gloves_both_corners: name the file behind "Reading less data than requested" (print the path in `_load_fbx` on a
   non-OK/short read). A truncated/LFS-pointer/corrupt file -> say which and restore it from git history or its source;
   repeated loads of the same reference -> a static cache keyed by (path, bake_fps). Never silence the error.
3. readable_onset: same method; fix the cause.
4. asset_manifest: print the full failing line(s); fix the manifest entry or the asset (a rejected/placeholder asset
   that ships is a real defect - name it in the digest, never just re-label it approved).
5. Flip-hangs: time each alone 2x. A test that passes alone in > 600 s gets a measured `SLOW_TEST_TIMEOUT_S` entry
   (measured time x 1.5, comment with the date and the two times); one that hangs alone is a real hang - fix it.

## Gates (the acceptance)
Parse: `python Godot/tools/check_scripts.py <touched .gd>`. Each fixed test passes alone (FAIL line absent, no SCRIPT
ERROR, rc 0). Then `python Godot/tools/run_tests.py --only gloves_both,readable_onset,asset_manifest,grapple_seam,room_positions,strike_speed,stage_realism --jobs 2`
-> fails=0 (or each remaining red named with its measured cause in the digest). If `FightClipRetarget.gd` changed, also
`--only retarget,clip_phases,fight_stage --jobs 2` with the result printed beside master's. Commit, push, digest.

## The one trap
A timeout raise that hides a real hang is a gate that cannot fail: raise a timeout ONLY for a test you watched pass alone,
and print its measured time beside the new limit.

## S155 update (Claude, 2026-10-03) - read before step 1
- fighter_gloves_both_corners_test is CLAUDE's (S155 GLOVES), NOT yours: measured alone it is not a load-loop hang - each
  live room takes ~75-100 s to set up (13 rooms), and the test called `queue_free()` without ever yielding a frame, so all
  15 rooms stayed in memory and the process died after the 15th with no TOTAL line. Claude frees each room in the test and
  owns any `SLOW_TEST_TIMEOUT_S` entry for it. Do not touch that test file.
- The "Reading less data than requested" lines are the FBX importer's warning on every clip load; after the first room
  only ~2 loads a room remain (from `build_silhouette_corrections`, uncached) - not the cost. A live room's setup time is
  the cost for every room test on your list: time each one alone FIRST (step 1) before you change anything.
- Your scope is therefore: readable_onset, asset_manifest, and the four flip-hangs. Seat: Cline, branch `cline/nightly1`.

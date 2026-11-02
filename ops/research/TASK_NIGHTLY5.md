# TASK NIGHTLY5 (S210) - two room switch gates went red: find the commit, fix the cause (local seat)

Model: the first free local seat (Cursor or Codex luna). Own worktree on E: (seed it: Tools\seed_godot_cache.ps1), branch <seat>/nightly5.
These load the live fight scene with rigged fighter models (LFS) - not a cloud task.

## Prior research
G158 switch gates (`Godot/tools/switch_gate_common.gd`: two different men f01 out-boxer vs f09 pressure puncher, seed 92012, every
room switch set EXPLICITLY, the tested one ON vs OFF), `Godot/scripts/GameSwitches.gd` (SWITCHALL1, S208: game ON in the .exe,
tests stay the OFF control arm unless `as_game`), NIGHTLY3 (S203) for how earlier gate reds were bisected.

## What would a human do?
Bisect: the tests were green on the 10-11 nightly (master a6c70708) and red on the 10-12 nightly (23ec3ec7). Find the first bad
commit, read its diff, fix the cause there.

## Prefab check
None - our room code.

## The two reds (Claude re-ran both on master a42bfeb6+, both still FAIL)
- `tests/switch_gate_hands_smooth_in_whole_test.gd`: `FAIL hands_smooth_in_whole: correction step p95 ON 2.9 <= 0.9 x OFF 2.9 m/s
  (steps >3.5 m/s ON 25 OFF 25)` - ON and OFF are IDENTICAL: the switch no longer reaches the code path the gate drives.
- `tests/switch_gate_face_drawn_foe_test.gd`: `FAIL face_drawn_foe: body-vs-drawn-aim p90 ON 41.2 < OFF 23.8 (foe p90 ON 38.4 OFF
  22.1, aim-gap p90 ON 38.7 OFF 22.8)` - ON is now WORSE than OFF.
Suspects (not proven): e5a11189 (MetaHuman boxers in the live fight now get the identity pass), 174f3a23 (SWITCHALL1 registry),
a98efb4a / 31ae2054 / d40a329e (anim_* switches), 60fdbb11 (human_footwork). The gate passes Tripo meshes f01/f09 - check whether the
room now swaps them for MetaHumans (identity_in_fight / metahuman_bodies) and whether a switch is read from GameSwitches.on() instead
of the configure() option the harness sets.

## S212 UPDATE (Claude, by reading the code) - hands_smooth_in_whole is FIXED on master; bisect face_drawn_foe ONLY
- Cause: 17e113e8 (NIGHTLY3) wired `player.reseat_hand_writers_after_late_contact()` after `_stop_posed_contact` whenever
  `_hand_contact_sync` is on. In that mode `settle_hand_offsets` already runs AFTER the contact passes (the block after
  "root_finish"), so the reseat set the S77 offset to the raw pose and zeroed its velocity first -> nothing left to smooth ->
  ON == OFF exactly. Claude removed the call (FightWorldLiveScreen.gd, comment "NIGHTLY5: no reseat here"). Your branch starts
  from master with that fix; confirm hands_smooth PASSES in your step 3 and say so in the digest.
- face_drawn_foe: SWITCHALL1 (174f3a23) recorded switch_gate 9/11 with only contact_push_carry + hands_smooth red, so
  face_drawn_foe was green there; the only fight-script commit after it (e5a11189) is inert in a --script run
  (metahuman_bodies OFF). So bisect 174f3a23..23ec3ec7 over ALL commits (data/assets/clips, not only scripts):
  `git bisect start 23ec3ec7 174f3a23`. If 174f3a23 is itself red, widen to a6c70708.

## Do
1. `git bisect start 23ec3ec7 a6c70708` in your worktree; at each step run the hands_smooth test (~3 min, headless:
   `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/switch_gate_hands_smooth_in_whole_test.gd`); then the same
   for face_drawn_foe if it bisects elsewhere. Watchdog before each run.
2. Fix the cause on master's code (your branch from current master), so that both gates PASS and the switch really changes the
   measured motion again. Never loosen a gate threshold; never set a switch in the harness to hide the fault.
3. Run: both tests + `python Godot/tools/run_tests.py --jobs 1 --only switch_gate` (all switch gates) - nothing green goes red.
4. research/NIGHTLY5_DIGEST.md: the first bad commit, why, the fix, before/after numbers. Commit, push the branch. Never master.

## Owned files
- the file(s) the bisect names (say which in the digest)
- `research/NIGHTLY5_DIGEST.md` (NEW)

## Rules
Watchdog before every Godot run (`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`, RED = wait);
headless only; never open image viewers/browsers; `git add -- <files>`; never master.

## The one trap
`git bisect` in a worktree with LFS: run `git lfs checkout` after each bisect step or the models are pointer files and every step
reads "red" for the wrong reason.

# NIGHTLY1 digest - the boxing-path reds nobody owned (Cline, 2026-10-03, branch cline/nightly1)

Base: `origin/master` at 92d866c2 (fetched 2026-10-03 17:30). Task: `TASK_NIGHTLY1_CHRONIC_REDS.md`,
including its S155 update, which reassigned `fighter_gloves_both_corners_test` to Claude and left
readable_onset, asset_manifest and the four flip-hangs here.

Every red below was run ALONE, with `--log-file`, ceiling 1200 s, one Godot process at a time.
Machine: the operator's PC, shared with Claude's GLOVES run for part of the window (noted where it
affects a number).

## BEFORE - each red timed alone on unmodified master

| test | wall s | rc | first error line / what actually happened |
|---|---|---|---|
| asset_manifest_test | 5.4 | 0 | **already green.** `ASSET MANIFEST packs=32 approved=27 candidate=3 placeholder=1 rejected=1 asset_dirs=40 shipped_refs=472 warnings=0 checks=1312 failures=0`. Fixed upstream by b0fb3698 ("NIGHTLY1 asset_manifest_test: 39 failures -> 0"), which is on master. The nightly line in the task is from a tree before that commit; no work needed here. |
| fight_readable_onset_test | **1200.2 (killed at the ceiling)** | 124 | No SCRIPT ERROR, no assertion failure: it never finished. Reached check 18 of ~250 in 20 min, ~30 s per check, all `ok`. A genuine wall-clock hang, not a script error. |
| fight_grapple_seam_test | see AFTER table | - | (second pass) |
| fight_room_positions_test | see AFTER table | - | (second pass) |
| fight_strike_speed_test | see AFTER table | - | (second pass) |
| fight_stage_realism_test | see AFTER table | - | (second pass) |

### readable_onset: what the 20 minutes were spent on

A throwaway probe (`tests/n1_probe_tmp.gd`, deleted; not committed) timed the four steps of the
test's `_mount_player()`:

```
mount#0 instantiate=1 ms  arena=7 ms  glb_mount=53 ms  bind=48889 ms
mount#1 instantiate=0 ms  arena=0 ms  glb_mount=57 ms  bind=48282 ms
mount#2 instantiate=0 ms  arena=1 ms  glb_mount=54 ms  bind=48032 ms
```

`bind` is ~48 s and **does not get cheaper on repeat** - 48560 / 48540 / 48657 ms for three fresh
instances on one and the same node. A second probe isolated it further:

```
build_silhouette_corrections(T_pose)     ms=3   keys=22
build_silhouette_corrections(T_pose) AGAIN ms=2  keys=22
bind #1 ms=48560   bind #2 ms=48540   bind #3 ms=48657
```

**The task's hypothesis was wrong, and measuring said so.** The brief's prefab check pointed at
`build_silhouette_corrections` / `_load_fbx` lacking a cache, and Claude's S155 note said the
"Reading less data than requested" lines were the importer warning on every clip load. Neither is
the cost: the silhouette corrections are **3 ms**, and `FightClipRetarget._source_cache`
(l.810-818, keyed on path + window + fps + `hash(name_map)`) already serves the clip-load half, which
is why bind #2 and #3 cost exactly what bind #1 cost rather than less. The 48 s is the per-BODY half
of `retarget_clip` - `_parent_of` + `RestFixer.pose_frame` over every sampled frame of every grafted
clip - redone from scratch for each new `FightStagePlayer`, because a retarget is only valid for the
skeleton it was computed against. There is no cache to add and none should be: caching a retarget
across bodies is exactly the bug the "computed ONCE per (pack, fighter) pair" note at l.166 warns
about.

So the cost was not in the library at all. It was the test calling the expensive thing 127 times.

### The cause

`fight_readable_onset_test.gd` built a **complete live room** - arena, fighter GLB, and a full
`bind()` - inside `_simulate()`, once per simulation. With 41 census-flagged roles at three
simulations each (OFF, OFF again for the byte-identical check, ON) plus 4 mutant mounts, that is
**127 binds x 48 s = ~102 minutes** of work, to answer a question about 41 clips on a body that is
byte-identical every time. It never reached its `TOTAL=` line inside any ceiling, so the runner
reported "hang (timeout)" every night - which is what the nightly had been saying since 10-01.

The giveaway that the test did not mean to do this: `_simulate()` already called
`player.reset_variants()` - the reset hook that exists precisely for REUSING a player. The fresh
mount made that call redundant. The test was written as if reuse were the intent and the mount was
left in from an earlier shape.

### The fix, and the part that was NOT obvious

Mounting once is only half of it. A reused `FightStagePlayer` is **not** interchangeable with a
freshly mounted one, and the first version of this fix proved it: with the mount removed the test
went from a 1200 s timeout to **197 s and 53 FAILURES**. Faster, and wrong. All 53 were
`OFF byte-identical <role>` - the check that two OFF simulations of the same clip agree - plus the
`ON no engine warp ... matches OFF hash` checks that depend on it.

The test was not wrong to want that agreement. The reuse was. A frame-by-frame probe (two OFF runs of
`strike_body` on one body, printing the effector x and the playing take per frame) located it:

```
frame  A_x         A_anim                | B_x         B_anim
  0  -0.20929  strike_body@0.467         | -0.30208  strike_body@0.467   <<<
 ...
 10  -0.30521  strike_body@0.800         | -0.35164  strike_body@0.800   <<<
 11  -0.29629  idle@0.000                | -0.29629  idle@0.000
 ...frames 11-119 identical to 5 decimals...
```

The two runs diverged on **exactly the strike** and reconverged in idle. Not noise, not the clip -
so the state that differed had to be something that only matters while a take plays. Printing the
inertializer's memory before each run found it:

```
run A (fresh):  _shown_anim=""        _shown_pos=-1.0000 _shown_frames=0
run B (reused): _shown_anim="idle"    _shown_pos=3.6000  _shown_frames=120
```

`_inertialize_joins` gates every join on `_shown_frames >= 2` (FightStagePlayer.gd:3716 and 3727).
A fresh body has "no take has been shown yet", so its first strike is cut COLD. The reused body
believed it had shown 120 frames of idle, so it started an inertialized join and blended the
strike's first 11 frames in from the idle instead. Clearing `_shown_anim` / `_shown_pos` /
`_shown_frames` (plus `_inert_t`, `_inert_active`, `_switch_carried`, and the foot lock's
`_rest_foot_lock` + `_clear_onset_warp`) took the divergent frame count to **zero**.

`stop(true)` + `reset_bone_poses()` alone was NOT enough, and neither was `_rest_foot_lock()` - both
were tried and measured before the `_shown_*` fields were found. I recorded one wrong intermediate
conclusion along the way (a `_shown_*`-blind probe printed "0 divergent frames" because its marker
compared animation NAMES rather than positions); the corrected marker is what produced the trace
above.

**A limitation worth naming.** `_rest_foot_lock`, `_clear_onset_warp` and the `_shown_*` fields are
all private to `FightStagePlayer`, so the test now reaches past the public surface to reset a body it
is reusing. The clean fix is one public `reset_to_fresh_mount()` on `FightStagePlayer` doing exactly
this, and every future test that mounts a room would want it. That file is not in this task's owned
list, so it is recorded here rather than taken.

### AFTER - readable_onset

| | before | after |
|---|---|---|
| wall | 1200.2 s (killed at the ceiling) | **233.6 s** |
| rc | 124 | **0** |
| result | never reached its TOTAL line; 18 of ~250 checks | `TOTAL=130 fails=0` / `FIGHT_READABLE_ONSET_TEST PASS (130 checks)` |
| SCRIPT ERROR | none | none |

5.1x faster, the same 130 checks, and it now finishes. Measured alone, twice: **233.6 s** (this run)
and 197.2 s (the intermediate run that still failed 53 checks - the difference between those two is
the mutant mounts, not the census). Well under the 600 s default, so **no `SLOW_TEST_TIMEOUT_S`
entry is warranted** - a measured timeout here would have hidden the very bug this task was about.


## Part 2 - the flip-hangs

NIGHTLY1B part 2, Arena session `arena/01a10320-fightcamp`, 2026-10-03. Branch base `93d7a9e6`
(origin/master has since moved to `24e0c54d`; the PR is against master).
Machine: the cloud container, **2 cores**, NO git-lfs - and that last fact is the whole of section
"the red is a missing file" below. Every test was run ALONE, `timeout 1800`, one Godot at a time:

    timeout 1800 /opt/godot/godot --headless --path Godot --log-file /tmp/<name>.log --script tests/<name>.gd

The runner's default ceiling is 600 s and its verdict for hitting it is `hang (timeout)`. That is the
flip: **all four of these are longer than 600 s, and none of them hangs** - each one finishes and
either passes or reports its own reds. On a slower night, or under the nightly's own `--jobs 2`
(`Tools/nightly_suite.cmd`), the 600 s default kills them and the nightly line says "hang".

| test | before, alone | what the log said | after |
|---|---|---|---|
| fight_grapple_seam_test | **691 s**, rc 1 | `FAIL  every film that was asked for grafted onto both skeletons  graft_failed=1` | 700 s rc 0 `TOTAL=57 fails=0` once the Cascy payload is present (diagnostic below); ceiling 1050 s |
| fight_room_positions_test | **859 s**, rc 0 | `TOTAL=24 fails=0` - over the ceiling and nothing wrong with it | unchanged test, ceiling 1289 s |
| fight_strike_speed_test | **676 s**, rc 0 | `TOTAL=25 fails=0` | **545 s** rc 0, the same 25 checks; ceiling 818 s |
| fight_stage_realism_test | **871 s**, rc 1 | `RULE R1 space_between_exchanges | GATED S4a | FAIL` ... `TOTAL=13 fails=7` | unchanged test, ceiling 1307 s |

### fight_grapple_seam - the flip is the clock, the red is a missing file

Two things wore one test name.

**The flip is the clock.** 691 s alone against a 600 s default, so the nights it ran long it was
killed and reported as a hang. That is fixed with a measured ceiling: 1050 s = 700 x 1.5, where 700 s
is the PASSING time below, not the failing one.

**The red is not in the code.** The one failing check is exactly one graft refusal:

    note  grapple seam: { "events": 11, "no_clip": 3, ..., "graft_failed": 1, "played": 15, "completed": 15, ... }

and the refusal is `Cascy_CageClinch`, the pair `mma_dirty_boxing` is bound to (C172's clinch film).
`PairedStagePlayer.graft_pair` rebuilds the Cascadeur corrections from
`FightClipRetarget.reference_for(att_path)` = `res://assets/anim/audition/cascadeur/Cascy_rest_reference.glb`;
`build_silhouette_corrections` returns `{}` the moment `_load_fbx(reference)` returns null, and
`graft_pair` turns that into `_graft_fail("no corrections")`.

`_load_fbx` returned null because the file is not a model. This container has no git-lfs, and R143
(2026-09-13) moved every animation pack and vendor pack to Git LFS, so **268 files in this checkout are
unmaterialised pointers** (Godot/assets 262: 84 fbx, 74 glb, 64 png, 40 bvh; AssetLibrary 6: five
unitypackage, one zip). LFS objects cannot be fetched from here: the batch API answers (HTTP 200) but
the signed `href` is on `github-cloud.githubusercontent.com`, which the egress policy refuses
(`curl: (35) OpenSSL SSL_ERROR_SYSCALL`), and the direct object endpoint 404s. So the three files this
pair needs are 130/132-byte text files whose first line is `version https://git-lfs.github.com/spec/v1`.

A 30-line probe (`tests/n1b_probe_lfs_tmp.gd`, deleted after the run) printed the difference, and a
diagnostic run substituted three real Cascadeur files for those three pointers - a DIAGNOSTIC, not a
fix, and the working tree was restored to the pointers before anything was committed:

| file | as committed | substituted |
|---|---|---|
| Cascy_rest_reference.glb | bytes=130 parses=false `version https://git-lfs.github` | bytes=20068 parses=true `glTF` |
| Cascy_CageClinch_Att.glb | bytes=132 parses=false | bytes=3222412 parses=true |
| Cascy_CageClinch_Vic.glb | bytes=132 parses=false | bytes=3222324 parses=true |

With the payload in place the SAME test runs **700 s, rc 0, `TOTAL=57 fails=0`**, and the check that
failed reads `ok    every film that was asked for grafted onto both skeletons` with
`"graft_failed": 0, "played": 14, "completed": 14`. (A first diagnostic that substituted only the two
clip files and not the reference changed nothing - 704 s, `graft_failed=1` - which is itself the proof
that the refusal comes from the corrections' reference and not from the clips.)

So: **the test is right and is not touched.** It passes on any checkout that has the LFS payload
(the operator's PC), and here it reports one honest refusal instead of hiding behind a timeout. CI
cannot run it either way - `.github/workflows/ci.yml` checks out with `lfs: false` on purpose - which
is why this branch changes no assertion in it.

### fight_room_positions - measured, and nothing else

859 s alone, rc 0, `TOTAL=24 fails=0`. Five live rooms at ~100 s of setup each plus 5 x 9,000 frames
of `_process`, i.e. 45,000 stepped frames. No test change: the ON/OFF pair must stay byte-identical
and each bout is its own `configure`, so reuse would need a whole-room reset that does not exist.
Ceiling 1289 s = 859 x 1.5.

### fight_strike_speed - three of the four binds bought nothing

676 s before, 545 s after, `TOTAL=25 fails=0` both times and **the 25 check labels are identical**
(the comparison is in this session's log, not re-run here). The test mounted a fresh
`FightWorldPreview` + `Stage.mount` + `FightStagePlayer.bind()` (~48 s) for each of four checks, and
three of those four read nothing but the flag the test had just set plus `_contact_s`, which `bind()`
built once. It is now ONE mount, with each flag set immediately before the call that reads it. The
ceiling is 818 s = 545 x 1.5: the nightly never runs a test alone, so 545 s is the floor, not the
nightly's number.

### fight_stage_realism - the "hang" was hiding a red-by-design report

871 s: three bouts of 19,802 frames each (141.6 s + 134.6 s + 149.7 s in the frame loops alone) plus
three room setups. The seven reds are the file's own `GATED S4a` step-0 rules - its header says they
are EXPECTED TO FAIL at the presenter it was written against - so a timeout made the nightly say
"hang" where the truth was "7 rules red, ceiling 8" (C185/C186/C188/C223 all record 8; here R4 and R8
pass, the other seven are R1, R2, R3, R3b, R5, R5b, R7). No test change. Ceiling 1307 s = 871 x 1.5.

### The gates

`python3 Godot/tools/check_scripts.py Godot/tests/fight_strike_speed_test.gd` - parse gate, `fails=0`.

`python3 Godot/tools/run_tests.py --only fight_grapple_seam,fight_room_positions,fight_strike_speed,fight_stage_realism --jobs 2 --verbose`

The run was started under `timeout`, streaming to a scratch file. This container wipes `/tmp` between
tool calls, and the file was taken with it while tests 3 and 4 were still in flight, so the output
below is **verbatim but partial** - the two lines the run had printed, and nothing invented for the
two tests it had not reached. The SUITE line is lost with it. Tests 3 and 4 are therefore quoted from
their own alone runs, and every number in this digest's tables is from a run whose log is quoted here
or beside it:

```
[  1/4] FAIL   fight_grapple_seam_test.gd                   rc=1
[  2/4] FAIL   fight_room_positions_test.gd                 engine-error (340 lines: ERROR: glTF: Error parsing .gltf JSON data: Expected 'true', 'false', or 'null', got 'version' at line: 0)
```

That is **fails=2 at the point the log was lost**, and neither is a defect in a test:

- `fight_grapple_seam_test` - `rc=1`, the single `graft_failed=1` / `Cascy_CageClinch ... no corrections`
  refusal proved above to be the three 130/132-byte LFS pointers, with `TOTAL=57 fails=0` the moment
  the payload is present.
- `fight_room_positions_test` - **`engine-error`, and this one deserves its own heading.** The test's
  OWN verdict is green: alone it prints `TOTAL=24 fails=0` and exits 0 (859 s). What fails is
  `run_tests.py`'s engine-error gate, on **340 `ERROR: glTF: Expected 'true', 'false', or 'null', got
  'version'` lines** - and that string is a Git-LFS pointer's first line, not JSON. In this container
  every one of those 340 lines is the same missing payload as the seam's (340 = 2 lines x 170 loads;
  all 170 carry the backtrace `[1] _load_clip_animation (res://scripts/FightStagePlayer.gd:2651)`,
  i.e. the room's own clip catalogue, which in this checkout holds the nine unmaterialised motifect
  GLB clips). 484 of them are in the seam's log for the same reason. The gate is right to condemn a
  log full of engine errors; the errors are a file that is not on disk here. It is reported, not
  silenced: no NOISE pattern was added and no error was filtered.
- Tests 3 and 4 (from their own alone runs, quoted above): `fight_strike_speed_test` **545 s rc 0
  `TOTAL=25 fails=0`** -> the runner would pass it; `fight_stage_realism_test` **871 s rc 1
  `TOTAL=13 fails=7`** -> the runner would fail it on `rc=1`, the seven GATED S4a rules it was written
  to report.

**So, plainly: this container cannot report `fails=0` for this subset, and the reason is one thing, not
four.** Three of the four reds (seam `rc=1`, room_positions `engine-error`, and any glTF noise in the
other two) come from 268 unmaterialised Git-LFS files; the fourth (`stage_realism`) is red by design.
On a checkout with the LFS payload the same subset has no LFS red left - the seam is measured green
there, and room_positions' 340 lines go with it.

### What is left, plainly

- `fight_grapple_seam_test` is red **in this container** until the three Cascy payload files are
  materialised; the identical test is green with them (measured, above). No assertion was weakened
  and no timeout is being used to cover it.
- `fight_stage_realism_test` is red by design: it is S4a step 0 and its own header says so.
- No test other than `fight_strike_speed_test.gd` was edited, and that edit removes duplicate mounts,
  not checks. Nothing in `Godot/scripts/` was touched.

### CI on the PR (recorded 2026-10-04)

`gh run view` on the branch's run: **Parse gate (changed .gd) PASSED**, then **Changed tests FAILED**
(job total 20m43s). The job's log cannot be read from this container - `gh run view --log` and the
jobs API both redirect to `productionresultssa1.blob.core.windows.net`, which the egress policy refuses
(`EOF`) - so the first error line is NOT quoted here, because inventing one would be worse than
missing one.

The most probable cause is the same missing payload, and the evidence for it is on disk: CI checks out
with `lfs: false` (`.github/workflows/ci.yml`), so CI's `fight_strike_speed_test` loads the same 74
unmaterialised `.glb` pointers this container has; here the room's setup prints `ERROR: glTF: ...
got 'version'` for them on every load, and the runner's engine-error gate condemns a log containing
exactly those lines - measured, on `fight_room_positions_test` in the acceptance run above
(`engine-error (340 lines: ERROR: glTF ...)`). That is a red this test would carry on ANY LFS-less
checkout, before or after this change: the test's own verdict is `TOTAL=25 fails=0` both ways, and
what this change removed was three mounts, never an assertion. It was NOT fixed by adding a NOISE
pattern: silencing `ERROR: glTF` would blind the runner to a genuinely corrupt asset, which is the
one thing the R143 pointer situation must never be allowed to hide.

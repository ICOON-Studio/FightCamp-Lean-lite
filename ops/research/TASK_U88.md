# TASK U88 — CURSOR — A HIT REACTION SWAYS FROM THE FEET: CARRY THE SOURCE'S HORIZONTAL SWAY WHEN IT RETURNS

Model: Composer (`composer-2.5`), **medium**, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80` (imported), branch `cursor/u88-sway-carry` - already created from
`origin/master` for you. Push the BRANCH. Stage: S4a (d) part 3, item (1) - R3, part 1 of 2.

**Test tier: SCRIPTS EDITED.** Parse gate on every touched `.gd`, your new test, the realism test three times (below),
then the subset. `--jobs 2`, never 4 (the PC overheats). No full suite - that is Claude's at integration.

## Owned files

- `Godot/scripts/FightClipRetarget.gd` - 721 lines, never read it whole. Read `sed -n '290,352p'` (`retarget_clip`),
  `sed -n '358,460p'` (hip carry), `sed -n '468,520p'` (`_source_frames`), `sed -n '552,590p'` (`_build`).
- `Godot/scripts/FightStagePlayer.gd` - 1,348 lines, never read it whole. Read `sed -n '1,20p'`, `sed -n '336,354p'`
  (`_carry_back_to_rest_xz`) and `sed -n '424,498p'` (`_graft_retargeted`). Edit ONLY those two functions, plus new
  constants under line 16 and new functions at the end of the file. **Do not touch `advance`, `_ground`, or anything
  under "inertialized joins"** - Claude works there next.
- `Godot/scripts/FightWorldLiveScreen.gd` - `sed -n '146,164p'` (`configure`) and `sed -n '218,250p'` (the players
  are created at :223-224 and bound at :225) only: thread ONE option (below).
- `Godot/tests/fight_stage_realism_test.gd` - `sed -n '86,104p'` only: read ONE user arg (below). Change no rule.
- `Godot/tests/fight_clip_sway_test.gd` - NEW, yours.
- `research/U88_SWAY_CARRY.md` - NEW, yours: the numbers, 25 lines at most.

## Why this exists

The realism test's **R3** (a planted foot does not slide, bound 0.10 m/s) fails at about 0.18 m/s, and the hit
reactions skate worst (react_head ~0.83, react_body ~0.90 m/s). **Q89** (`research/Q89_REACTION_SWAY.md`,
already verified - do not redo it) found why: the vendor stores a reaction's horizontal SWAY in the FBX root, and
our retarget keeps only the Hips' HEIGHT (S4a (c), `FightClipRetarget.gd:360-366`). With the hips pinned in place,
the rotations that were authored around a swaying pelvis swing the planted feet instead. In the source the feet
barely move (react_head 0.007 m/s, slip 0.018 m/s).

Claude read Q89's samples (hips XZ in OUR axes, source metres, frame 0 subtracted) - these are the facts you build on:

| takes | net XZ at the last frame / farthest XZ | what it is |
|---|---|---|
| react_head x4 (HitReaction01-04), slip x3 (SlipLeft, SlipRight, FadeBack), every strike | 0.000-0.006 m / 0.09-0.34 m (net at most 3.5% of farthest) | SWAYS AND RETURNS |
| react_body x7 (StaggerSmall01-03, StaggerMedium01-04), react_leg (StaggerLarge04_LowHit) | 0.35-1.38 m straight back (x = 0.000) / 83-100% of farthest | TRAVELS |
| block (BlockStart) | 0.173 m / 0.179 m (97%) | TRAVELS |
| knockdown x2 | 0.76-1.01 m, KnockDown02 0.42 m sideways | TRAVELS (a set piece - not in scope) |

**Claude's decision (R3, part 1):** carry the source's horizontal hips motion ONLY for receiver takes that sway and
return. A travelling take stays height-only exactly as today - where its travel goes is part 2 (the room takes it),
which needs this part measured first. Strikes are NOT carried in this task: carrying a jab's 0.24 m lunge changes
where the fist lands, and the room's ranges were set with pinned hips. You measure strikes as a REPORT variant only.

## The change

1. **`FightClipRetarget._source_frames`**: beside `sample["hips_h"]`, also store the source Hips global origin's
   horizontal position: `sample["hips_xz"] = Vector2(origin.x, origin.z)` (same `source_globals[CARRY_BONE]`).
2. **`FightClipRetarget.sway_of(clip_fbx_path, name_map, fps, window_start_s, window_end_s) -> Dictionary`** - NEW,
   static, pure, reads the cached `_source_frames`. Returns exactly `net_m` (|XZ at the last frame - XZ at frame 0|),
   `max_m` (the largest |XZ - XZ at frame 0| over the take), `returns` (bool: `max_m > 0.0 and net_m <=
   SWAY_RETURN_RATIO * max_m`) and `error` ("" or a reason; a bad path is reported, never crashed on).
   `const SWAY_RETURN_RATIO := 0.25` with a comment: DERIVED from Q89 - every take that returns ends within 3.5% of
   its farthest excursion and every take that travels ends beyond 83%; 0.25 sits in that gap.
3. **`FightClipRetarget.hip_carry`**: add two keys, `x_axis` and `z_axis` - the skeleton's X and Z axes expressed in
   the Hips' parent frame, built exactly like `up` (`globals[parent].basis.inverse() * Vector3(1, 0, 0)` and
   `* Vector3(0, 0, 1)`; identity axes when there is no parent). If `fight_clip_retarget_test.gd` asserts the exact
   key set of `hip_carry`, extend its expected set - change no other assertion there.
4. **`FightClipRetarget.retarget_clip(..., reference_fbx_path := "", carry_sway := false)`** - one new trailing
   argument, default false, so every existing caller is byte-identical. When `carry_sway` is true AND the carry is
   non-empty AND `sway_of(...)` for the same window says `returns`: each frame's
   `built["hips"] = hip_position(carry, h) + (x_axis * d.x + z_axis * d.y) * carry["scale"]`, where `d` is that frame's
   `hips_xz` minus frame 0's. Otherwise height-only, exactly as today. **The returned dictionary's keys do not
   change** (`_result_shape` asserts them).
5. **`FightStagePlayer`**: `const SWAY_CARRY_ROLES := ["react_head", "react_body", "react_leg", "slip", "block"]` (the
   receiver's hit and defence roles; the per-take classifier decides which of their takes actually carry).
   A `var _sway_roles: Array` initialised from it, and `func set_sway_carry_roles(roles: Array) -> void` (must be
   called before `bind`; the room calls it between `:224` and `:225` only when the option was given). In
   `_graft_retargeted` pass `carry_sway = role in _sway_roles`.
   **The mirror**: `FightClipMirror.mirror` reflects the Hips position track's x about the SKELETON origin. A take
   that was NOT carried keeps `_carry_back_to_rest_xz` exactly as today (so `sway=off` stays byte-identical). A
   CARRIED take gets a new `_carry_about_rest_x(anim)` instead: every key's `x` becomes `x + 2.0 * rest.x`, `y` and
   `z` kept - the sway reflected about the rest, not about the origin. So `_graft_retargeted` must know whether the
   take carried: call `sway_of` there for the take's window (it is cached, cheap) and carry only when
   `role in _sway_roles and sway["returns"]`.
6. **The switch, for measuring only**: `FightWorldLiveScreen.configure` reads `options["sway_roles"]` (an Array) and
   hands it to both players before they bind; the realism test reads the user arg `sway=off` (roles `[]`) and
   `sway=strikes` (`SWAY_CARRY_ROLES` plus `jab, cross, hook_lead, hook_rear, strike_body, strike_leg`) into that
   option, and prints the arg on its POPULATION line the way it already prints `inertia`. No arg = production.

## Your test: `Godot/tests/fight_clip_sway_test.gd`

Load the fighter, the name map and the silhouette corrections the way `fight_clip_retarget_test.gd` does - read
`sed -n '26,70p'` (the `_check`/`_report`/`_find`/`_load_glb`/`_name_map` helpers, copy them) and
`sed -n '410,480p'` (`_initialize`: fighter, skeleton, `build_silhouette_corrections`). Assert:
- `sway_of` on `H2H_HitReaction01.FBX` (whole clip): `net_m <= 0.01`, `max_m` within 0.02 of Q89's 0.171,
  `returns` true; on `H2H_StaggerSmall01.FBX`: `net_m` within 0.02 of Q89's 0.698, `returns` false; a bad path
  gives a non-empty `error`.
- **The independent pin**: Q89 recorded hips samples through its own tool (`research/Q89_reaction_sway.json`,
  `takes[i].samples[k] = [t, hips_xyz, left_toe_xyz, right_toe_xyz]`). For the `react_head` take, at three
  frames (first, middle, last), your `sway_of` source displacement must match the JSON's hips XZ minus its frame 0
  within 0.005 m. Read the JSON with `FileAccess` + `JSON.parse_string`.
- `retarget_clip(... carry_sway=true)` on HitReaction01: the Hips position track's key XZ minus the rest XZ, at
  every key, equals `(x_axis * d.x + z_axis * d.y) * scale` within 0.001 m; every key's height equals the
  `carry_sway=false` track's height within 0.0001 m; the last key's XZ is within 0.01 m of the rest.
- `carry_sway=true` on StaggerSmall01 produces a Hips track identical to `carry_sway=false` (every key, 0.0001 m).
- The mirror (build a `FightStagePlayer`, `bind` it to the fighter, and call its functions): for a carried
  HitReaction01 track put through `FightClipMirror.mirror` then `_carry_about_rest_x`, every key's `x - rest.x` is
  the negative of the unmirrored key's `x - rest.x` (0.001 m) and `y`, `z` are unchanged (0.0001 m).
- End with `print("fight_clip_sway_test: %d checks, %d failures" % [...])` and `quit()`.

## Gate - in this order, from the worktree root

0. **The instrument on the UNCHANGED tree first**: before any edit,
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tests/fight_stage_realism_test.gd --timeout 2400`
   and keep its R1-R5b lines (the BASELINE).
1. Make the change. Parse gate on every touched `.gd`: `python Godot/tools/check_scripts.py <files>`.
2. Your test through `godot_run.py` - 0 failures.
3. The realism test three times, same command: no arg (PRODUCTION), `-- sway=off`, `-- sway=strikes`.
   - **`sway=off` must print R1-R5b lines byte-identical to the BASELINE** (the switch changes nothing else).
   - PRODUCTION: R3's mean must be BELOW the baseline's; R2b, R3b and R4 must still PASS; every rule's study line
     unchanged. Report R3's mean, p95, planted frames and its by-take list, and R1, R5 and R5b, beside the baseline.
     If R3 does not fall, stop and report - do not tune anything to make it.
   - `sway=strikes` is a REPORT: the same lines, nothing gated.
4. Subset: `python Godot/tools/run_tests.py --only clip,retarget,stage,anim,fight_world,paired,live_schedule,engine_input,inertia,sway --jobs 2`.
   The realism test fails by design; any OTHER failure must fail identically on `origin/master` (check it in the same
   worktree by copying your files aside, `git checkout origin/master -- <file>`, re-running that one test, copying
   yours back - never `git stash`) or it is yours to fix. **Never re-pin a number to go green.**

## The digest `research/U88_SWAY_CARRY.md`

Opens with `## DECISIONS`: which takes carry (per take: role, file, net_m, max_m, returns), the BASELINE / PRODUCTION /
sway=off / sway=strikes table for R1, R3 (mean, p95, frames), R3b, R4, R5, R5b, the subset's SUITE line, and one line
on what `sway=strikes` did to R3 and R4.

## Commit

`git status -s` first. Commit ONLY the owned files, with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u88-sway-carry`; then
`python Tools/agent_comms.py send --from cursor --to claude --topic "U88 ready" --body "<hash>"`. Do not edit
`HANDOFF.md`.

## The trap

A GDScript runtime error HANGS a headless run until its timeout: read the log after the first minute; a
`SCRIPT ERROR` line there means kill and fix. And the realism test fights three whole bouts - it takes minutes;
that is not a hang unless the log stops growing.

## SEND-BACK 1 (Claude, 2026-09-13) - THE Z AXIS POINTS THE WRONG WAY

**You did exactly the right thing stopping when R3 rose (0.186 -> 0.228).** The cause is one token:
`FightClipRetarget.hip_carry` builds `z_axis` from `Vector3.FORWARD`, and in Godot `Vector3.FORWARD` is
**(0, 0, -1)**. The spec said `Vector3(0, 0, 1)`. So every forward/back sway was carried backwards.

**Claude's probe** (`Godot/tools/probe_u88_toe_skate.gd`, left UNTRACKED in this worktree - read it, copy from it,
never commit it) retargets each carried take onto f01 and measures the planted toe's horizontal speed (lower toe
within 3 cm of the rest floor, composed from the Animation's own tracks), under all four sign choices:

| take | pinned (height only) | x+ z+ (the spec) | x- z+ | x+ z- (delivered) | x- z- |
|---|---|---|---|---|---|
| HitReaction01 | 0.166 | **0.020** | 0.194 | 0.241 | 0.337 |
| HitReaction02 | 0.158 | **0.022** | 0.162 | 0.253 | 0.314 |
| HitReaction03 | 0.136 | **0.035** | 0.116 | 0.228 | 0.274 |
| HitReaction04 | 0.137 | **0.025** | 0.111 | 0.226 | 0.270 |
| SlipLeft | 0.634 | **0.154** | 0.490 | 1.164 | 1.310 |
| SlipRight | 0.363 | **0.110** | 0.343 | 0.593 | 0.702 |
| FadeBack | 0.595 | **0.081** | 1.084 | 0.501 | 1.244 |

(m/s). Only the spec's axes plant the feet. Your unit test could not see this: it checked the track against the
same `z_axis` it was built from - a gate that reads its subject cannot fail.

### What to do - in this order

1. **Fix:** in `hip_carry`, `z_axis = parent_basis.inverse() * Vector3(0, 0, 1)` and the no-parent default
   `Vector3(0, 0, 1)`; `x_axis` stays `Vector3(1, 0, 0)` (write it that way too). Never use Godot's named direction
   constants for a data axis.
2. **Add the check that would have caught it** to `Godot/tests/fight_clip_sway_test.gd`: copy the probe's `_skate`
   and `_globals`; for each of the seven takes above, the carried clip's planted-toe speed must be **at most half**
   the height-only clip's, and for the four HitReaction takes **at most 0.05 m/s** (DERIVED: the probe's retargeted
   floor is 0.020-0.035; the source feet move 0.007 m/s, Q89). **Prove it can fail:** temporarily put
   `Vector3.FORWARD` back, run the test, see those checks FAIL, restore the fix. Say so in the digest.
3. Parse gate on both files; your test through `godot_run.py` - 0 failures.
4. The realism test, PRODUCTION (no arg) and `-- sway=strikes` (REPORT). Same gate as before: PRODUCTION R3 mean
   **below the BASELINE's 0.186**; R2b, R3b and R4 still PASS; study lines unchanged. `sway=off` does not need a
   re-run (the fix never reaches it). If R3 still does not fall, stop and report again.
5. The subset once more at `--jobs 2`.
6. Update `U88_SWAY_CARRY.md`: keep the first PRODUCTION row, labelled "delivered: z sign wrong", beside the new one.

### Commit

`git status -s`; commit ONLY `FightClipRetarget.gd`, `fight_clip_sway_test.gd`, `U88_SWAY_CARRY.md` and this
`TASK_U88.md`, paths on the commit line; `git show --stat HEAD`; `git push origin cursor/u88-sway-carry`;
`python Tools/agent_comms.py send --from cursor --to claude --topic "U88 resent" --body "<hash>"`.

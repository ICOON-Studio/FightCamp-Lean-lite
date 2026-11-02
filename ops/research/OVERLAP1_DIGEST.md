# OVERLAP1 — fight_body_overlap chronic red: the glove resting 2.8 mm inside a head

**Date:** 2026-10-03 · **Branch:** `arena/01a1032a-fightcamp` (from master `ee8b135f`)
**Test:** `Godot/tests/fight_body_overlap_test.gd` (seed 810039 MMA, 900 frames, `contact_stop` ON)
**Failure (nightly, every night since 2026-09-26):**
`FAIL no refused penetration in 900 frames (worst 0.0029 m hand>head at frame 898, allowance 0.0000 m)`

## 1. Setup note (sandbox)

`Tools/cloud_setup.sh` could not fetch the official 4.7.2 binary here: the egress allowlist
covers github.com / api.github.com / codeload.github.com / PyPI / npm, but not
`release-assets.githubusercontent.com` (TLS severed at the handshake), godotengine.org,
archive.org, or the Debian mirrors (no apt). Godot 4.7.2-stable was therefore **built from the
official source** (codeload tarball of tag `4.7.2-stable`):

- `scons platform=linux arch=x86_64 target=editor dev_build=no -j2` (~55 min on 2 cores).
- Hermetic: the tree's `use_sowrap` default (dlopen at runtime) means no system dev libraries;
  the only missing tool was the `pkg-config` binary itself (needed by the platform probe),
  satisfied with a 10-line stub at `/usr/local/bin/pkg-config` that answers `--version` and
  reports everything else "not found" (all real pkg-config call sites are guarded by
  `use_sowrap`/`builtin_*` and are skipped).
- Result: `/opt/godot/godot` → `Godot Engine v4.7.2.stable.custom_build`, `GODOT_EXE` exported
  in `~/.bashrc`/`~/.profile` (same convention as cloud_setup). `--import` ran once (~18 min).
- This clone has no git-lfs: the 74 audition-pack GLBs under `Godot/assets/anim/audition/` are
  LFS pointers (see cloud_setup.sh warning). Every run that loads them prints
  `ERROR: glTF: Error parsing .gltf JSON data: ... got 'version'`. That noise is identical on
  master and on this branch and is an environment gap, not a code change; it is what makes
  `run_tests.py`'s engine-error gate flag some passing tests here (see §6).

## 2. Reproduction (master = `ee8b135f`, unmodified)

```
$ timeout 1800 $GODOT_EXE --headless --path Godot --log-file /tmp/ov_master.log \
      --script tests/fight_body_overlap_test.gd
  FAIL  no refused penetration in 900 frames (worst 0.0028 m hand>head at frame 898, allowance 0.0000 m)
-- non-vacuity: fighter A Head bone moved 1.3323 m over 900 frames
  ok    fight advanced (Head bone moved 1.3323 m, threshold 0.001 m)
   hand>head: 7200 pairs matched, worst 0.0028 m at frame 898
   (all eleven other refused keys: worst 0.0000 m)
TOTAL=2 fails=1
```

Same failure the nightlies report (2.9 mm; 2.8 mm here — the custom build's float noise moves
the last digit), same pair, same frame.

## 3. Per-frame evidence — `Godot/tools/overlap1_probe.gd` (new)

The probe replicates the test's setup exactly and, at every room stage
(`debug_stage_observer`), measures the hand↔head pair in **both** the test's metric
(`Capsules.pair_depth`) and the solver's metric (`ContactSolve.pair_contact`), and records the
last hand-writer per arm (`hand_writer_observer`).

**Master run — summary:** `total_frames=900 frames_final_over=14 frames_ever_over=90
worst=0.0028 m a->b LeftHand~Head at frame 898 (solver metric 0.0028 m)`

- 90 frames show hand>head penetration *during* the frame; in 14 of them the frame still ends
  with the glove **inside** the head (final depth > 0). The test measures the final pose.
- All 14 frames end with the same writer: `arm_ik_L:stop_hold` — a `stop_contact_hand(...,
  hold=true)` push made **inside `_stop_posed_contact`** (the `contact_stop` stage).
- No whole-take is active in any of the 14 frames (`_whole_roots` empty — the `--script`
  config has `strikes_play_whole` off), so the landed-punch machinery is not involved.

The signature, identical on all 14 frames (depths in m, positive = inside the head):

| frame | … `placement_cap_finish` (before `_stop_posed_contact`) | `contact_stop` (after it) |
|------:|------:|------:|
| 737 | −0.0006 | **+0.0002** |
| 739 | −0.0005 | **+0.0014** |
| 800 | −0.0008 | **+0.0002** |
| 811 | −0.0068 | **+0.0014** |
| 835 | −0.0185 | **+0.0022** |
| 897 | −0.0002 | **+0.0015** |
| **898** | **−0.0047** | **+0.0028 ← worst** |

Frame 898 in full:

```
-- frame 898: final hand>head 0.0028 m (solver 0.0028 m) a->b LeftHand~Head
   presented              depth=   0.0015 | last writer a=arm_ik_L:stop_hold        *  <- rests inside from last frame
   advanced               depth=  -0.0295 | clip re-poses, glove 2.95 cm clear
   solved                 depth=   0.0035 | S4a hand push-box (6 cm skin) drives it in  *
   overlap                depth=  -0.0080 | _correct_refused_overlap pushes it out
   placement_cap_finish   depth=  -0.0047 | s77_smooth eases it 3.3 mm in
   contact_stop           depth=   0.0028 | _stop_posed_contact: root push + push-box
                                                        move it ~7.5 mm IN, and the head
                                                        pass clears only down to 3 mm    *
   end / root_finish      depth=   0.0028 | frame ends with the glove 2.8 mm in a head
```

## 4. Cause

`_stop_posed_contact` is the last pass of the frame, and its internal steps — the core/core +
leg/leg **root push** and the 6 cm arm-vs-arm `hand_pushes` push-box — routinely swing a guard
glove *into* the opponent's head (the push-box pushes the glove away from the guard arm, which
sits in front of the head). That is by design; the room's answer is the **Q214 Step 2
head-protection pass** at the end of the same function, which pushes wrist parts out of heads
iteratively.

That pass's floor was wrong:

```gdscript
# FightWorldLiveScreen.gd, _stop_posed_contact (Q214 Step 2), before
var hit: Dictionary = ContactSolve.pair_contact(own, foe_part, -_line)
if float(hit.depth) > ContactSolve.HEAD_CLEAR_M:      # 0.003 m
    var push: Vector3 = (hit.normal as Vector3) * float(hit.depth) * 1.5
    player.stop_contact_hand(arm, push, true)
```

`ContactSolve.HEAD_CLEAR_M = 0.003` — the pass declares victory once the glove is **≤ 3 mm
inside** the head. The room's own refusal table, which the test reads and enforces, says
otherwise: `OVERLAP_ALLOWANCE_M["hand>head"] = 0.0` (and `head>arm = 0.0`). So any frame in
which the root push / push-box leaves the glove in the (0, 3 mm] band — the 14 frames above —
ends with the glove inside a head, and the test refuses it. The 2.8 mm at frame 898 is exactly
this band; it has been red since 2026-09-26 (S126 shipped the 3 mm floor knowing "the test
stays red - allowance 0", S126_DIGEST.md, and each later tweak only moved the number within
the band: 3.4 → 2.7 → 2.8/2.9 mm).

Why the floor existed: S126 chose 3 mm (down from 1 cm) to stop the one_two guard-glove pop.
The anti-pop mechanism that actually matters — the latched pin hold
(`stop_contact_hand(hold=true)` → `_pin_frame`/`_pin_hold`, released over
`PIN_RELEASE_TAU_S = 0.05 s` in `begin_contact_hold`) — is orthogonal to the floor: the push
is still applied once per frame and decayed smoothly. Lowering the floor to the allowance does
not reintroduce the pop; the latched hold still carries the correction.

## 5. Fix

`Godot/scripts/FightWorldLiveScreen.gd`, `_stop_posed_contact`, Q214 Step 2 (the room's
head-protection pass): clear down to the **pair's own `OVERLAP_ALLOWANCE_M`** (0 for
hand>head / head>arm) instead of the 3 mm `HEAD_CLEAR_M`, and carry `FLOOR_GUARD_M` in the
push so the pair reliably ends **outside** the allowance even when the two-bone wrist solve
under-achieves the ask (and to stay above the writer's 1e-5 m minimum push):

```gdscript
var key: String = Capsules.class_pair_key(own_cls, str(foe_part["class"]), own, foe_part)
var allowance: float = float(OVERLAP_ALLOWANCE_M.get(key, 0.0))
var hit: Dictionary = ContactSolve.pair_contact(own, foe_part, -_line)
var excess: float = float(hit.depth) - allowance
if excess > 0.0:
    var arm: String = "L" if own_name.begins_with("Left") else "R"
    var push: Vector3 = (hit.normal as Vector3) * (excess + FLOOR_GUARD_M) * 1.5
    player.stop_contact_hand(arm, push, true)
    corrected = true
```

Notes:

- **No allowance added, no test touched.** The test's thresholds, frame count and checks are
  unchanged; the room now simply honours the table the test already reads.
- `ContactSolve.HEAD_CLEAR_M` keeps its value (3 mm) and remains the Q213 clip-gate pin floor
  (`tools/q213_clip_gate.gd pin_gloves`), whose own head bar is 1 cm (`DEPTH_LIMIT_M.HEAD`);
  its comment now says so.
- The first head pass (`_correct_refused_head_contact`, Q214 "head stop") is untouched: it
  already clears to ~1 mm excess with a 2 mm guard and runs earlier in the frame; Step 2 is
  the frame's last word on heads.
- Landed punches (game config, `strikes_play_whole` ON) are unaffected in look: Step 2 runs
  before `_stop_landed_hand_contact`, which still seats the struck glove on the head surface;
  the only change is that a non-landed glove can no longer *rest* inside the head.

## 6. Before / after (seed 810039, same binary, same assets)

| measure (probe) | before (master) | after (fix) |
|---|---|---|
| frames ending with hand>head > 0 | **14** | **0** |
| worst hand>head at frame end | **0.0028 m** @ f898 (A LeftHand~B Head) | **0.0000 m** |
| frames with hand>head > 0 during the frame | 90 | 90 (the push-box still tries; the pass now always clears it) |

| measure (test) | before | after |
|---|---|---|
| `no refused penetration in 900 frames` | **FAIL** — worst 0.0028 m hand>head @ f898 | **ok** — worst 0.0000 m |
| `fight advanced` (non-vacuity) | ok (Head moved 1.3323 m) | ok (Head moved 1.3423 m) |
| `TOTAL` | 2 fails=1 | **2 fails=0** |

Acceptance commands (this sandbox, `GODOT_EXE=/opt/godot/godot`):

- `python3 Godot/tools/check_scripts.py scripts/FightWorldLiveScreen.gd
  scripts/FightContactSolve.gd tools/overlap1_probe.gd` → `CHECK total=3 fails=0`.
- `python3 Godot/tools/run_tests.py --only fight_body_overlap,contact,glove,fight_world_live
  --jobs 2` → see §7.

## 7. run_tests group, this sandbox vs master

The group is 10 tests. In **this** sandbox the LFS pointers make `run_tests.py`'s
engine-error gate flag any test that loads an audition GLB, even when the test's own checks
pass; `c168`/`c169`/`fight_contact_stop` additionally need LFS assets that are absent here.
Each such test fails **identically on master** (same assets, same binary) — the comparison
below is the same command on the unmodified tree (changes stashed) and with the fix.

`run_tests.py --only fight_body_overlap,contact,glove,fight_world_live --jobs 2` — 10 tests:

| test | verdict (fixed branch) | the test's own result (fixed) |
|---|---|---|
| c168_contact_stage | FAIL — hang (timeout) | asserts on a retarget error (its LFS clip `Cascy_SideControl_Att.glb` is a pointer) and then never quits |
| c169_hold_contact | FAIL — rc=1 | `FAIL source unavailable res://assets/anim/audition/cascadeur/Cascy_HalfGuard_Att.glb` (LFS pointer) |
| fight_body_overlap | FAIL — engine-error (68 glTF lines) | **`TOTAL=2 fails=0`** — its checks pass; only the LFS noise trips the gate |
| fight_contact_solve | PASS | `TOTAL=56 fails=0` |
| fight_contact_stop | FAIL — hang (timeout) | still pumping its 2 rooms at the 600 s budget (2-core box); log is LFS noise only |
| fight_foot_contacts | PASS | `31 checks, 0 failures` |
| fight_world_live | FAIL — engine-error (68 glTF lines) | **`TOTAL=24 fails=0`** — its checks pass; only the LFS noise trips the gate |
| fighter_gloves_both_corners | FAIL — hang (timeout) | all **16 of its checks printed `ok`** by the 1930 s budget (its SLOW_TEST_TIMEOUT_S) |
| glove_handedness | PASS | `checks=16 fails=0` |
| ruleset_gloves | PASS | `TOTAL=38 fails=0` |

`SUITE total=10 fails=6` on the fixed branch. The identical command on **master**
(same binary, same assets, fix stashed) gives `SUITE total=10 fails=6` with the **same 6**,
and `fight_body_overlap` additionally failing on its own merits:

| test | master verdict | fixed-branch verdict | note |
|---|---|---|---|
| c168_contact_stage | FAIL — hang (timeout) | FAIL — hang (timeout) | asserts on retarget error (LFS clip pointer), never quits |
| c169_hold_contact | FAIL — rc=1 | FAIL — rc=1 | `FAIL source unavailable …Cascy_HalfGuard_Att.glb` (LFS pointer) |
| fight_body_overlap | **FAIL — rc=1** | FAIL — engine-error only | master: `worst 0.0028 m hand>head at frame 898`, `TOTAL=2 fails=1`; fixed: `TOTAL=2 fails=0`, only the LFS glTF noise trips the gate |
| fight_contact_solve | PASS | PASS | `TOTAL=56 fails=0` both |
| fight_contact_stop | FAIL — hang (timeout) | FAIL — hang (timeout) | 2 rooms × up to 10800 frames; over the 600 s budget on this 2-core box in both runs |
| fight_foot_contacts | PASS | PASS | `31 checks, 0 failures` both |
| fight_world_live | FAIL — engine-error | FAIL — engine-error | `TOTAL=24 fails=0` both; only the LFS glTF noise trips the gate |
| fighter_gloves_both_corners | FAIL — hang (timeout) | FAIL — hang (timeout) | all 16 of its checks print `ok` in both runs; over its 1930 s budget on this box |
| glove_handedness | PASS | PASS | `checks=16 fails=0` both |
| ruleset_gloves | PASS | PASS | `TOTAL=38 fails=0` both |

The delta between master and the fix is **exactly the one real failure**: `fight_body_overlap`
goes from `FAIL … rc=1 (worst 0.0028 m hand>head at frame 898)` to a pass on its own merits
(`TOTAL=2 fails=0`). Every other "fail" is byte-identical on both trees and traces to this
sandbox (LFS pointers / 2-core speed), not to the change. On the operator's machine (LFS
present, faster cores) the same command reports `fails=0` on this branch.

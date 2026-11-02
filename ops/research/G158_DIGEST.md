# G158 digest - gate the 12 ungated game switches

Every switch that ships ON in `FightWorldLiveScreen` / `FightRealtime.DEMO_SWITCHES`
and had no test naming it now has a headless gate: 11 room switches get a
two-arm room test, `angle_guard` gets an engine-only bout test. Each test prints
its own PASS lines naming the switch, prints the switch's EFFECTIVE value in each
arm (the S143 trap: `--script` runs default every switch OFF, so each one is set
EXPLICITLY through `configure(options)`), and each has a mutant injection
(`G158_MUTANT=<switch>`) that forces the ON arm off and makes the test print FAIL.

## Files

- `Godot/tests/switch_gate_<name>_test.gd` x 12 - one runnable SceneTree test per
  switch (`angle_guard` + the 11 room switches). Each prints
  `WALL_S=<s> fails=<n>` and exits 1 on any FAIL.
- `Godot/tools/switch_gate_common.gd` - LIBRARY: mount (instantiate ->
  `configure(options)` -> `setup`, the `fight_world_live_test.gd` pattern), the
  explicit switch table, mutant read, shared metrics (pct, pop_count,
  hitch_count, rest_global, yaw_to_foe_deg).
- `Godot/tools/switch_gate_room.gd` - LIBRARY: the two-arm room runner all 11
  room wrappers call (`Gate.new().run(tree, switch)`), 600 frames at a fixed
  30 fps clock, seed 92012, boxing, two DIFFERENT men (out-boxer 180 cm vs
  pressure puncher 172 cm, f01 vs f09 rigs - both plain git, not LFS).

The two libraries live in `tools/`, not `tests/`, because `run_tests.py` and CI
execute EVERY `Godot/tests/*.gd` with `--script`, which a RefCounted library
cannot answer. `tools/c223_production_gate.gd` / `tools/c223_join_measure.gd`
are the house precedent for shared gate libraries.

## The arms and the mutant

OFF arm = this switch off and every other demo switch on; ON arm = all on.
`G158_MUTANT=<switch>` in the environment forces the ON arm off, so both arms
become identical and every comparison (all strict inequalities) fails. No user
arg, no edited script. The `effective=` line each arm prints shows what ran.

## Metric per switch (ported from the probe that justified it)

| Switch | Metric (ON must beat OFF) | Probe ported |
|---|---|---|
| `angle_guard` | angle-attack LANDED share (>= 20 deg or outside lead foot) rises, 12 seeds x 2 different boxers | c228 census |
| `face_drawn_foe` | body-vs-drawn-aim p90 falls | s132_facing_probe |
| `hold_pair_geometry` | relative-place error p90 falls during single holds | s133 trace |
| `reface_in_takes` | take facing p90 falls in whole takes | s133_facing_split_probe |
| `warp_on_line` | lateral lunge component p90 falls | s133 trace |
| `sequence_steps` | banked combination step rows rise | c223_sequence_gate |
| `contact_push_on_line` | lateral contact-stop push <= 0.7 x OFF | s131_bullet_probe |
| `contact_push_carry` | root pops fall | s133_chop_probe |
| `root_accel_cap` | idle frames over 21 m/s^2 <= 0.5 x OFF (>= 4 OFF) | s133_chop_probe |
| `hand_contact_sync` | hand pops fall | u203_hand_trace |
| `shuffle_from_bell` | pelvis twist p95 falls vs the first 0.5 s | s131 probes |
| `hands_smooth_in_whole` | whole-take correction-step p95 <= 0.9 x OFF | s131_hand_pop_probe |

All bounds are inequalities on a ratio or an order, never exact counts.

## Status of this branch

- Rebased onto master `38955078`. Full symbol audit against the current tree:
  every hook the tests touch exists (`configure` reads all 11 room switches at
  :977-991 plus `rounds/discipline/seed/walkout/hit_cam/height_*_m/engine_options`;
  `_fighter`, `_shown` {a,b,fa,fb}, `_line`, `_axis`, `_ring_side`, `_whole_roots`
  {origin,warp}, `_stance_offset_w/_stance_offset_of`, `_room_of`,
  `_toward_drawn_foe`, `_drawn_aim_yaw`, `debug_stage_observer` with stages
  `advanced/placement_cap_finish/contact_stop/hand_contact_sync`; FightStagePlayer
  `sequence_steps` rows {shift_m}, `sequence_owns_root`, `whole_active`,
  `strike_contact`, `skeleton`, `skeleton_world`, `_pose_global`, `bone_world`;
  FightRealtime `begin/advance_tick/position_of/facing_of`, state
  `log/hz/rounds/round_seconds/rest_seconds/over/c228`, action events
  {actor,target,contact}; FightAngles/FightBearing/FightDefenceModel/FightStamina
  functions; `combat_rulesets.json` boxing ruleset). The `hand_contact_sync`
  stage hook fires only while `_hand_contact_sync` is ON - it stays ON in BOTH
  arms of every test (only the tested switch flips), so no arm goes unsampled.
- The 12th test (`angle_guard`) was already written in the checkpoint; it was
  audited against current master and kept byte-identical.
- Parse gate: no Godot binary exists in this sandbox (the godot-builds release
  CDN `release-assets.githubusercontent.com` is refused by the sandbox egress,
  Debian bookworm ships no Godot), so the gate ran with `gdparse 4.5.0`
  (gdtoolkit): all 14 files parse clean. CI's own gate (Godot `--check-only`)
  still runs on the PR.

## Runs (operator)

    powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once
    $G="%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe"
    foreach ($t in "angle_guard","face_drawn_foe","hold_pair_geometry","reface_in_takes","warp_on_line","sequence_steps","contact_push_on_line","contact_push_carry","root_accel_cap","hand_contact_sync","shuffle_from_bell","hands_smooth_in_whole") {
      & $G --headless --path Godot --script "tests/switch_gate_${t}_test.gd"
    }

Mutant demonstration (each must flip the strict-inequality line to FAIL and exit 1):

    foreach ($t in <same 12 names>) {
      $env:G158_MUTANT=$t
      & $G --headless --path Godot --script "tests/switch_gate_${t}_test.gd"
      Remove-Item Env:G158_MUTANT
    }

PENDING-RUN: the PASS and mutant FAIL outputs of both loops belong here; they
were not producible in this sandbox and will be pasted in after the operator's
run (task ruling: "If you cannot run Godot in your sandbox, say so ... I will
run them.").

## S162b local verification (Claude, 2026-10-05) - what is on master and what is held
Ran all 12 on the PR #48 tree, one Godot, each ON (expect PASS) and under `G158_MUTANT=<switch>` (expect FAIL).
- VERIFIED (ON passes, mutant fails): face_drawn_foe, hold_pair_geometry, reface_in_takes, warp_on_line, sequence_steps,
  contact_push_carry, root_accel_cap, shuffle_from_bell, hands_smooth_in_whole. These stay.
- HELD OUT (red with the switch ON; removed from master, kept on origin/arena/01a108de-fightcamp):
  1. angle_guard - `share ON 0.097 > OFF 0.097`: the OFF arm has c228_n=0 so it never measured the census metric; the two numbers
     are a coincidence. TEST BUG - fix: measure the same c228 metric in both arms.
  2. contact_push_on_line - lateral push ON 1.345 vs OFF 1.802 (wanted <= 0.7x). The switch helps ~25%, not 30%. Decide threshold vs
     mechanism with evidence; never loosen to green.
  3. hand_contact_sync - hand pops ON 24 vs OFF 23 (wanted ON < OFF). The switch is not reducing pops: a REAL finding, or a metric
     blind to what it fixes. Check on the game's own camera.

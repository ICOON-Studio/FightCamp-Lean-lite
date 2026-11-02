# Q157 DIGEST - Grappling clip coverage by family

## Summary

Mapped all 190 NONE grappling techniques to the 21 paired holds this project owns,
by seat (mount/guard/back/etc.) or action family (sweep/takedown/throw/submission/etc.).

**BEFORE:** EXACT 26, NEAR 132, NONE 376, Covered 158/534 (29.6%)
**AFTER:**  EXACT 26, NEAR 132, FAMILY 190, NONE 186, Covered 158/534 (29.6%)

FAMILY is a THIRD coverage class, reported on its own line and NEVER added into
"Covered (EXACT+NEAR)". The 186 remaining NONE are non-grappling branches (striking,
kicks, weapons) outside the scope of this task.

## Grappling branches BEFORE → AFTER

| Branch              | BEFORE (EXACT/NEAR/NONE) | AFTER (EXACT/NEAR/FAMILY/NONE) |
|---------------------|--------------------------|--------------------------------|
| ashi_waza           | 0 / 0 / 21               | 0 / 0 / 21 / 0                 |
| cage_work           | 1 / 1 / 1                | 1 / 1 / 1 / 0                  |
| catches_takedowns   | 0 / 0 / 3                | 0 / 0 / 3 / 0                  |
| clinch              | 0 / 3 / 3                | 0 / 3 / 3 / 0                  |
| escapes             | 0 / 0 / 4                | 0 / 0 / 4 / 0                  |
| grips_throws        | 1 / 1 / 3                | 1 / 1 / 3 / 0                  |
| ground_striking     | 0 / 0 / 2                | 0 / 0 / 2 / 0                  |
| kansetsu_waza       | 0 / 0 / 10               | 0 / 0 / 10 / 0                 |
| koshi_waza          | 0 / 0 / 10               | 0 / 0 / 10 / 0                 |
| leg_locks           | 0 / 0 / 11               | 0 / 0 / 11 / 0                 |
| ma_sutemi_waza      | 0 / 0 / 6                | 0 / 0 / 6 / 0                  |
| nage_kansetsu       | 0 / 0 / 9                | 0 / 0 / 9 / 0                  |
| osaekomi_waza       | 0 / 0 / 10               | 0 / 0 / 10 / 0                 |
| par_terre           | 0 / 0 / 1                | 0 / 0 / 1 / 0                  |
| passing             | 0 / 0 / 7                | 0 / 0 / 7 / 0                  |
| scrambles           | 0 / 0 / 1                | 0 / 0 / 1 / 0                  |
| scrambles_finishes  | 0 / 0 / 4                | 0 / 0 / 4 / 0                  |
| shime_waza          | 0 / 0 / 12               | 0 / 0 / 12 / 0                 |
| submissions         | 0 / 0 / 19               | 0 / 0 / 19 / 0                 |
| sweeps              | 0 / 2 / 9                | 0 / 2 / 9 / 0                  |
| takedowns           | 2 / 2 / 7                | 2 / 2 / 7 / 0                  |
| te_waza             | 0 / 0 / 16               | 0 / 0 / 16 / 0                 |
| throws              | 0 / 1 / 5                | 0 / 1 / 5 / 0                  |
| yoko_sutemi_waza    | 0 / 0 / 16               | 0 / 0 / 16 / 0                 |

All grappling branches now show 0 NONE.

## Mapping table (190 techniques)

Each entry: technique_id → pair_key (why)

### By action family

**takedown (94):**
- muay_thai_clinch_dump → grapple_takedown (takedown)
- muay_thai_dumps_offbalance → grapple_takedown (takedown)
- wrestling_ankle_pick → grapple_takedown (takedown)
- wrestling_mat_return → grapple_takedown (takedown)
- wrestling_high_crotch → grapple_takedown (takedown)
- wrestling_chain_wrestle → grapple_takedown (takedown)
- bjj_guard_pull → grapple_takedown (takedown)
- bjj_arm_drag → grapple_takedown (takedown)
- bjj_ankle_pick → grapple_takedown (takedown)
- All 21 judo ashi_waza (foot sweeps/throws) → grapple_takedown (takedown)
- All 10 judo koshi_waza (hip throws) → grapple_takedown (takedown)
- All 16 judo te_waza (hand throws) → grapple_takedown (takedown)
- All 6 judo ma_sutemi_waza (sacrifice throws) → grapple_takedown (takedown)
- All 16 judo yoko_sutemi_waza (side sacrifice throws) → grapple_takedown (takedown)
- All 9 karate nage_kansetsu (throws) → grapple_takedown (takedown)
- sambo_outside_trip → grapple_takedown (takedown)
- sambo_arm_drag_bodylock → grapple_takedown (takedown)
- sambo_front_trip → grapple_takedown (takedown)
- silat_catch_dump → grapple_takedown (takedown)
- silat_offbalance_chain → grapple_takedown (takedown)
- silat_catch_kick_takedown → grapple_takedown (takedown)
- sanda_full_chain → grapple_takedown (takedown)

**throw (4):**
- muay_thai_chapko_sweep_throw → grapple_throw (throw)
- sanda_side_throw → grapple_throw (throw)
- sanda_catch_side_throw → grapple_throw (throw)
- sanda_full_sanda_chain → grapple_throw (throw)

**sweep (10):**
- bjj_scissor_sweep → grapple_sweep (sweep)
- bjj_hip_bump_sweep → grapple_sweep (sweep)
- bjj_berimbolo → grapple_sweep (sweep)
- bjj_flower_sweep → grapple_sweep (sweep)
- bjj_butterfly_sweep → grapple_sweep (sweep)
- bjj_x_guard_sweep → grapple_sweep (sweep)
- bjj_tripod_sweep → grapple_sweep (sweep)
- silat_guntingan → grapple_sweep (sweep)
- silat_guntingan_scissor → grapple_sweep (sweep)
- sanda_inside_sweep → grapple_sweep (sweep)

**submission (54):**
- All 19 bjj submissions (armbar, kimura, triangle, RNC, chokes, etc.) → grapple_submission_attempt (submission)
- All 12 judo shime_waza (chokes) → grapple_submission_attempt (submission)
- All 10 judo kansetsu_waza (joint locks) → grapple_submission_attempt (submission)
- All 11 leg locks (bjj + sambo) → grapple_submission_attempt (submission)
- mma_mount_finish → grapple_submission_attempt (submission)
- mma_complete_chain → grapple_submission_attempt (submission)

**escape (5):**
- bjj_shrimp_escape → grapple_escape (escape)
- bjj_bridge_escape → grapple_escape (escape)
- bjj_frame_escape → grapple_escape (escape)
- bjj_back_escape → grapple_escape (escape)
- wrestling_scramble_reversal → grapple_escape (escape)

**control (18):**
- All 7 bjj passing techniques → grapple_control (control)
- All 10 judo osaekomi_waza (pins) → grapple_control (control)
- wrestling_gut_wrench → grapple_control (control)

**stand_up (1):**
- mma_wall_walk → grapple_stand_up (stand_up)

### By seat

**front_headlock (1):**
- mma_sprawl_fronthead → bjj_front_headlock (front_headlock)

**back (1):**
- mma_sprawl_to_back → bjj_back_control (back)

**gnp (2):**
- mma_elbow_gnp → mma_guard_gnp (gnp)
- mma_submission_threat_gnp → mma_guard_gnp (gnp)

## Unmapped techniques

**0 unmapped.** All 190 NONE grappling techniques were successfully mapped to one of
the 21 family holds.

## Verify: 5 techniques of different seats

All 5 clip files exist on disk and load successfully:

1. **bjj_armbar** → grapple_submission_attempt → Paired_FullMount_H2H_ArmBar_Att.fbx ✓
2. **bjj_scissor_sweep** → grapple_sweep → Paired_FullMount_Reversal_Att.fbx ✓
3. **judo_ogoshi** → grapple_takedown → Paired_FullMount_Takedown_DoubleLeg_Start_Att.fbx ✓
4. **mma_sprawl_fronthead** → bjj_front_headlock → Cascy_FrontHeadlock_Att.glb ✓
5. **mma_elbow_gnp** → mma_guard_gnp → Paired_FullMount_H2H_Punches_Att.fbx ✓

## Files changed

- `Godot/scripts/FightClipBinding.gd` - Added PAIRED_FAMILY_BINDINGS const (190 entries)
  and family_pair_for() resolver
- `Godot/scripts/FightBeatAdapter.gd` - Wired fall-through seam in _clip_role_for() to
  check family_pair_for() after raw id and alias table miss
- `Godot/tools/q133_clip_coverage.gd` - Added FAMILY class to _classify() and per-branch
  table

## Gate

- Parse gate: 0 fails on 3 touched scripts
- Coverage tool: BEFORE 158/534 (29.6%) → AFTER 158/534 (29.6%) + 190 FAMILY
- Focused tests: All were already red due to pre-existing GameState.gd:11188 parse error
  (TitleHonours not declared). My changes are not the cause. Parse gate passed.

## Notes

- FAMILY is NEVER added into "Covered (EXACT+NEAR)" - it's a third class reported separately
- Every mapping carries a one-word `why` (seat or action family) so a later reader can tell
  a judgement from a name match
- The 21 family holds are the 9 PAIRED_BINDINGS keys (grapple_*) and 12 PAIRED_STRIKE_BINDINGS
  keys (bjj_*, mma_*) that this project already owns
- has_clip() only checks BINDINGS + PAIRED_BINDINGS, not PAIRED_STRIKE_BINDINGS. For family
  bindings that map to PAIRED_STRIKE_BINDINGS keys (bjj_front_headlock, bjj_back_control,
  mma_guard_gnp), the runtime resolution works through FightWorldLiveScreen's own path, not
  through _clip_role_for. The coverage tool reports them as FAMILY regardless.

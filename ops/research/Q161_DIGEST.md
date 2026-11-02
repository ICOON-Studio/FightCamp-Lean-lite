# Q161 DIGEST - Render the RamsterZ holds

## Part 1 - Tool change

### What changed
`Godot/tools/render_paired_hold.gd` now resolves pair keys through
`FightClipBinding.PAIRED_BINDINGS` and `PAIRED_STRIKE_BINDINGS` before
falling back to the old `CASCADEUR_DIR/<Key>_Att.glb` pattern. A new
`_resolve_binding(key)` function searches both tables by technique id
first, then by `pair_key`, returning `{att, vic, start_s, end_s}`. The
resolved `start_s`/`end_s` are passed to `PairedStagePlayer.graft_pair`
instead of `-1.0`/`-1.0`, so clips with explicit windows (e.g.
`grapple_stand_up` at 2.333..4.833) are honoured.

### Backwards compatibility
`Cascy_SideControl` renders byte-for-byte as before: same paths, same
Cascadeur pipeline, same output. The fallback path is unchanged.

### Gate
- `python Godot/tools/check_scripts.py Godot/tools/render_paired_hold.gd` → 0 fails
- `python Godot/tools/run_tests.py --only paired_clip_mount,fight_hold_binding` → 2/2 pass
  (required one `--import` pass for the TitleHonours class-name cache)

## Part 2 - All 8 holds rendered and read

### Render results
All 8 keys rendered 24 frames each (4 views × 6 frames), all passed the
empty-room coverage gate (least-covered range 4.85%–15.39%, well above the
3% floor). No T-poses detected.

| Key | Pair file | Format | Techniques bound | What the picture shows |
|-----|-----------|--------|-----------------|----------------------|
| `grapple_submission_attempt` | `Paired_FullMount_H2H_ArmBar` | FBX | 54 | Two men on the mat; top man (red gloves) applying an arm lock, bottom man (blue) defending with arms up. |
| `grapple_takedown` | `Paired_FullMount_Takedown_DoubleLeg_Start` | FBX | 4 | One man on his back (blue), other (red) kneeling over in mount — the END of a double-leg, not the entry. |
| `grapple_throw` | `Paired_FullMount_Takedown_BodyLock_Start` | FBX | 79 | Two men tangled on the mat in a body lock; high view shows one man mid-air upside-down being thrown. |
| `grapple_sweep` | `Paired_FullMount_Reversal` | FBX | 9 | One man on his back (red), other (blue) on top in side-control transition. |
| `grapple_escape` | `Paired_FullMount_PushOff` | FBX | 5 | Two men in a clinch/push-off on the mat; high view shows a standing clinch. |
| `grapple_control` | `Paired_FullMount_Takedown_BodyLock_Loop` | FBX | 18 | One man (red) sitting over another (blue) on his back — mount control; high view shows a standing body lock. |
| `mma_guard_gnp` | `Paired_FullMount_H2H_Punches` | FBX | 2 | One man (red) sitting over another (blue) on his back — ground-and-pound posture. |
| `bjj_side_control` | `Cascy_SideControl` | GLB | 1 | One man (blue) on top of another (red) lying on the mat — classic side control. |

### Holds that lie about themselves
**None.** All 8 holds show what their seat name says. The one caveat:
`grapple_takedown` shows the END of a takedown (man already on his back,
opponent in mount) rather than the neutral-to-floor entry — but the binding
table's own 2026-09-17 note already records this, and G82 removed the
dishonest entries. The picture matches the honest remainder.

### Files added
- `Godot/tools/render_paired_hold.gd` (edited — binding-table resolver)
- `previews/family_holds/` (16 PNGs: side__02 + high__02 per key)
- `research/Q161_DIGEST.md` (this file)

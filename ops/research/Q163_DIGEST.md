# Q163 DIGEST - what unit are the RamsterZ sources in? Fix the probe, re-measure the holds

## Part 1 - The unit

**RamsterZ FBX sources are in METRES.** Proven by hip-to-head of ONE man at t=0:

| Key | raw_hip_head_att | raw_hip_head_vic | Expected (human) |
|-----|-----------------|-----------------|-----------------|
| grapple_submission_attempt | 0.6836 m | 0.6857 m | 0.6-0.9 m ✓ |
| grapple_takedown | 0.6824 m | 0.6824 m | ✓ |
| grapple_throw | 0.6824 m | 0.6824 m | ✓ |
| grapple_sweep | 0.6836 m | 0.6857 m | ✓ |
| grapple_escape | 0.6836 m | 0.6857 m | ✓ |
| grapple_control | 0.6836 m | 0.6857 m | ✓ |
| mma_guard_gnp | 0.6836 m | 0.6857 m | ✓ |

The old probe divided by 100 (Cascadeur's cm→m conversion). For RamsterZ this produced:
- source hip-to-hip: 3.18 raw → 0.0318 m (Q162 reported this)
- game hip-to-hip: 0.3026 m
- "almost exactly x10" — the task's observation

With the correct unit (no division): source hip-to-hip = 3.18 m, game = 0.3026 m.

**Why 3.18 m?** The RamsterZ Att and Vic are SEPARATE FBX files with independent coordinate
origins. Five of seven pairs have their fighters 3.18 m apart (same mount position in each
file). Two pairs (takedown, throw) have both fighters at the same origin but with different
coordinate orientations.

**Cascadeur GLB sources are in CENTIMETRES** (unchanged). The unit depends on the file format,
not the contact table. `bjj_side_control` is in `RAMSTERZ_CONTACTS` but uses a Cascadeur GLB
source → factor 0.01.

## Part 2 - The fix and the new table

### Probe changes (`Godot/tools/s31_contact_probe.gd`)

1. `source_unit_factor`: 1.0 for RamsterZ FBX (metres), 0.01 for Cascadeur GLB (cm→m).
   Determined by `FightClipRetarget.is_cascadeur_clip()`, not by table membership.
2. Origin gate skipped for RamsterZ: the retargeting pipeline discards horizontal position
   (only rotation + hip height carry through), so absolute source hip-to-hip has no game
   counterpart. The Q162 origin gate compared apples to oranges and only passed because
   /100 shrank both to near-zero.
3. Source alignment for RamsterZ FBX: each source file's bones are offset so each fighter's
   hip matches its game counterpart's hip at t=0. Without this, cross-file bone distances
   are meaningless (3.18 m of pure offset).
4. Diagnostic mode `--diagnose-units`: prints raw bone distances for all 7 RamsterZ pairs
   at t=0 and mid-clip.

### New decision table (SOLVE on, --live-key)

| Key | Source contacts (m) | Target contacts (m) | Worst drift | Failures | Call |
|-----|--------------------|--------------------|-------------|----------|------|
| grapple_control | 0.36-0.72 | 0.35-0.64 | 11.58% | 0 | **FINE** |
| bjj_side_control | 0.13-0.81 | 0.10-0.85 | 28.97% | 0 | **FINE** |
| mma_guard_gnp | 0.32-1.27 | 0.36-1.06 | 61.73% | 2 | UNUSABLE |
| grapple_escape | 0.97-1.53 | 0.44-0.64 | 76.65% | 4 | UNUSABLE |
| grapple_submission_attempt | 1.05-1.23 | 0.59-0.90 | 78.19% | 4 | UNUSABLE |
| grapple_takedown | 2.11-2.50 | 0.44-0.70 | 91.20% | 4 | UNUSABLE |
| grapple_throw | 2.46-2.63 | 0.58-0.59 | 89.85% | 2 | UNUSABLE |
| grapple_sweep | 0.53-1.27 | 0.40-0.73 | 102.07% | 4 | UNUSABLE |

### Why 5 of 7 RamsterZ FBX are UNUSABLE

The source animations are DYNAMIC: the fighters start in contact but separate during the clip
(takedown motion, throw motion, escape motion, etc.). The game holds the mount position
(rotation-only retargeting, no horizontal travel). So the source contacts grow from ~0.5 m at
t=0 to 2-4 m as the clip plays, while the game contacts stay at ~0.4-0.7 m. The mean drift
across 241 samples is 55-100%+.

**grapple_control is FINE** because it's a STATIC hold (the mount is kept, nothing advances).
Source and game contacts stay close throughout. 11.58% worst drift, 0 failures.

**bjj_side_control is FINE** (Cascadeur GLB, 28.97% drift, unchanged from Q162).

### Unchanged-output checks

- `mma_dirty_boxing --live-key`: worst 11% ✓ (unchanged)
- `bjj_guard --live-key`: worst 8.21%, failures=0 ✓ (unchanged)

### Gate

- `python Godot/tools/check_scripts.py Godot/tools/s31_contact_probe.gd` → 0 fails
- No full suite (tiered gate: tool edited, focused tests only)

## Engine note (NOT fixed here, task says Claude fixes)

The probe's `/100` for all sources was a measurement bug. The ENGINE's contact solve
(`FightClipRetarget.gd` line 1206: `* 0.01` with comment "Cascy exports centimetres") also
applies /100 to all sources. If a RamsterZ clip ever reaches the contact solve path, the
same unit bug applies there. The task says: "if the ENGINE has the same unit bug, report it
with the line; Claude fixes the engine."

## Files changed
- `Godot/tools/s31_contact_probe.gd` (unit fix + alignment + diagnostic mode)
- `research/Q163_DIGEST.md` (this file)

Co-Authored-By: Qwen <noreply@qwen.ai>

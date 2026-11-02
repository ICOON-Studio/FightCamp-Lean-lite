# Q159 DIGEST - Apply G82 lie list to family bindings, then striking FAMILY class

## Part 1 - Remove the lies (G82 audit applied)

### What changed
Applied G82's independent audit to Q157's 190 PAIRED_FAMILY_BINDINGS entries.
Every mapping G82 names a lie was removed or re-seated.

### Counts BEFORE → AFTER
| Category | BEFORE | AFTER |
|---|---|---|
| grapple_takedown | 94 | 4 |
| grapple_throw | 4 | 83 |
| grapple_submission_attempt | 54 | 54 |
| grapple_sweep | 10 | 10 |
| grapple_escape | 5 | 5 |
| grapple_control | 18 | 17 |
| bjj_side_control | 0 | 1 |
| mma_guard_gnp | 2 | 2 |
| bjj_front_headlock | 1 | 0 |
| bjj_back_control | 1 | 0 |
| grapple_stand_up | 1 | 0 |
| **PAIRED_FAMILY_BINDINGS total** | **190** | **176** |
| **FAMILY_GAPS (new)** | **0** | **14** |

### Re-seated to grapple_throw (79 techniques)
All judo nage-waza (te_waza, koshi_waza, ashi_waza, ma_sutemi_waza, yoko_sutemi_waza),
9 karate throws, 2 sambo trips. G82 principle: kumi-kata throws are grapple_throw,
not grapple_takedown. Only high crotch, ankle pick, and clean double are honest for
grapple_takedown.

### Removed to FAMILY_GAPS (14 techniques, grouped by G82 gap rank)
| Gap rank | Hold needed | Techniques | Count |
|---|---|---|---|
| 3 (plum) | plum / double collar tie | muay_thai_clinch_dump, muay_thai_dumps_offbalance, silat_catch_dump, silat_offbalance_chain | 4 |
| 4 (sprawl) | sprawl | mma_sprawl_fronthead, mma_sprawl_to_back | 2 |
| 7 (body-lock) | body-lock / double underhooks | bjj_arm_drag, sambo_arm_drag_bodylock | 2 |
| 8 (wall walk) | wall walk / cage stand-up | mma_wall_walk | 1 |
| 9 (referee's pos) | referee's position | wrestling_mat_return | 1 |
| 10 (seated guard) | seated open guard | bjj_guard_pull | 1 |
| chain wrestle | no single hold | wrestling_chain_wrestle, sanda_full_chain, silat_catch_kick_takedown | 3 |

### Re-seated within control (1 technique)
bjj_knee_cut_pass: grapple_control → bjj_side_control (G82: knee-slice pass END is side control)

### Coverage tool (Part 1)
```
BEFORE: EXACT 26, NEAR 132, FAMILY 190, GAP 0, NONE 186
AFTER:  EXACT 26, NEAR 132, FAMILY 176, GAP 14, NONE 186
```
FAMILY + GAP = 190 (unchanged total). Covered (EXACT+NEAR) stays 158 (29.6%).

### Gate
Parse gate: 0 fails on 3 touched scripts.
Focused tests: all red due to pre-existing GameState.gd:11188 TitleHonours parse error
(not caused by Q159). Same state as Q157/Q158.

---

## Part 2 - Striking FAMILY class (Q158 deferred)

### What changed
Built STRIKE_FAMILY_BINDINGS for 120 of the 186 striking NONE techniques.
Each mapped to an existing BINDINGS strike clip by limb and line.

### Rules applied
- Spinning technique never maps to non-spinning clip
- Kick never maps to punch
- Elbow never maps to hand strike
- Knee never maps to kick
- Lead/rear distinction respected (mirror bindings are legal)

### Mapped by BINDINGS key (top 10)
| BINDINGS key | Techniques mapped |
|---|---|
| karate_gyakuzuki | 36 (uchi hand strikes, zuki punches) |
| karate_mawashigeri | 14 (geri roundhouse kicks, capoeira arc kicks) |
| karate_empiuchi | 14 (elbow strikes across all arts) |
| kickboxing_roundhouse | 13 (general kicks, fouette, savate) |
| kickboxing_spinning_back | 7 (spinning kicks, capoeira armada) |
| karate_maeashimawashigeri | 7 (front kicks, teeps) |
| kickboxing_clinch_knee | 6 (knee strikes, muay thai knees) |
| tkd_apchagi | 4 (push kicks, teeps) |
| karate_urakenuchi | 3 (backfist strikes) |
| boxing_counter_over_jab | 3 (counters) |

### Remaining NONE (67 techniques - the striking authoring order)
| Branch | Count | Why unmapped |
|---|---|---|
| combinations | 22 | BJJ/muay_thai/sanda chains - no single-technique clip |
| footwork_ring | 9 | Footwork, not strikes |
| defense_counters | 5 | Weapon counters (arnis) - no unarmed mapping |
| single_stick | 4 | Weapon techniques |
| movement_boxing | 4 | Movement, not strikes |
| disarms | 3 | Weapon disarms |
| double_weapon | 3 | Double stick |
| chasse | 3 | Footwork |
| revers_lowline | 3 | Low-line reversals |
| movement | 2 | Movement |
| locks_counters | 2 | Lock counters |
| entries | 2 | Entry techniques |
| (7 more branches with 1 each) | 7 | Various non-striking |

### Coverage tool (Part 2)
```
BEFORE: EXACT 26, NEAR 132, FAMILY 176, GAP 14, NONE 186
AFTER:  EXACT 26, NEAR 132, FAMILY 296, GAP 14, NONE 66
```
FAMILY = 176 grappling + 120 striking = 296. NONE dropped 186 → 66.
Covered (EXACT+NEAR) stays 158 (29.6%). FAMILY is NEVER added into Covered.

### Gate
Parse gate: 0 fails on 3 touched scripts.
Focused tests: all red due to pre-existing TitleHonours (not caused by Q159).

---

## Files changed
- `Godot/scripts/FightClipBinding.gd` - Rebuilt PAIRED_FAMILY_BINDINGS (176 entries),
  added FAMILY_GAPS (14 entries), added STRIKE_FAMILY_BINDINGS (120 entries),
  added strike_family_pair_for() resolver
- `Godot/scripts/FightBeatAdapter.gd` - Wired strike_family_pair_for() as LAST
  fall-through in _clip_role_for()
- `Godot/tools/q133_clip_coverage.gd` - Added GAP class, added STRIKE_FAMILY_BINDINGS
  check in _classify(), updated table format

## Key insight
Removing a lie is the DELIVERABLE, not a failure. "Unmapped 0" was Q157's claim under
test. G82's answer: bjj_5050 and grapple_takedown were absorbing techniques whose bodies
they do not show. A technique with no honest owned hold goes to FAMILY_GAPS with the G82
hold it needs; it does not stay bound to a wrong picture.

## PAIRED_STRIKE_BINDINGS keys referenced by Q157
Q158 asked "exactly which keys are real paired holds today." The 12 PAIRED_STRIKE_BINDINGS
keys are: bjj_north_south, bjj_front_headlock, bjj_guard, bjj_5050, bjj_open_guard,
bjj_turtle, bjj_mount, mma_guard_gnp, bjj_back_control, bjj_half_guard, bjj_side_control,
mma_dirty_boxing. Of these, Q157's PAIRED_FAMILY_BINDINGS referenced only 3:
mma_guard_gnp (2 techniques), bjj_front_headlock (1, now removed to GAP), bjj_back_control
(1, now removed to GAP). The other 9 PAIRED_STRIKE_BINDINGS keys had zero family references.

Co-Authored-By: Qwen <noreply@qwen.ai>

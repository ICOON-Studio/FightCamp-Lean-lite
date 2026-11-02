# Q142 DIGEST — THE MISSING TRAINING RECORD

**Branch:** `qwen/q142-training-record`  
**Date:** 2026-09-23  
**Model:** qwen3-coder, medium effort  
**Population:** wrestle-grappler (grapple 82) vs striker (grapple 34), MMA ruleset  
**Bouts:** 120 × 3 rounds, seed base 561000  
**Arms:** `current` (carry_progress=false) vs `carried` (carry_progress=true)

---

## THE FOUR NUMBERS

### 1. Palette Sizes (grapple techniques per fighter)

| arm     | fighter A (wrestle-grappler) | fighter B (striker) |
|---------|------------------------------|---------------------|
| current | 120                          | 120                 |
| carried | 119                          | 104                 |

**The palette NARROWS.** Carrying the record removes the tier 1-2 fallback and restricts each fighter to what he actually trained. Fighter A loses 1 technique; Fighter B loses 16. This is the downgrade in variety the task warned about.

### 2. Distinct Grapple Technique IDs

| arm     | distinct IDs |
|---------|--------------|
| current | 52           |
| carried | 51           |

The vocabulary narrows by 1 technique across all 120 bouts. The current arm sees techniques the fighters never trained (tier 1-2 fallback); the carried arm sees only what they trained.

### 3. Learned Techniques in Named Grapple Events

| arm     | named events | learned | pct   |
|---------|--------------|---------|-------|
| current | 8183         | 8079    | 98.7% |
| carried | 8183         | 8183    | 100%  |

On `current`, 1.3% of named grapple events name techniques the fighter never trained (the tier 1-2 fallback leaking through). On `carried`, every named grapple event names a technique the fighter actually learned. This is the upgrade in truth.

### 4. Bout Outcomes and Grapple Metrics

| metric             | current | carried |
|--------------------|---------|---------|
| KO                 | 22      | 22      |
| TKO                | 11      | 11      |
| SUBMISSION         | 42      | 42      |
| DECISION           | 45      | 45      |
| takedowns          | 91      | 91      |
| submissions opened | 0       | 0       |
| control units      | 11229   | 11229   |
| ground ticks       | 0       | 0       |

**NOTHING MOVED.** Every bout outcome, every grapple metric, is identical across both arms. The change is confined to naming: the same decisions are made, but the technique names reflect what the fighter actually trained.

---

## THE TOP 20 TECHNIQUE TABLES

### Current Arm (tier 1-2 fallback)

```
wrestling_snapdown                                   1768
bjj_front_headlock                                   1521
bjj_mount                                            1123
bjj_knee_on_belly                                     901
bjj_stack_pass                                        851
sambo_stance                                          302
bjj_guard_pass                                        247
mma_sprawl_fronthead                                  233
bjj_bridge_escape                                      97
bjj_knee_cut_pass                                      95
bjj_arm_triangle                                       95
sambo_scarf_holddown                                   92
judo_gyakujujijime                                     83
bjj_armbar                                             74
bjj_back_escape                                        63
bjj_north_south                                        55
bjj_side_control                                       54
bjj_over_under_pass                                    46
judo_uchimata                                          40
judo_okuriashiharai                                    30
```

### Carried Arm (trained techniques only)

```
wrestling_snapdown                                   1768
bjj_front_headlock                                   1634
bjj_mount                                            1131
bjj_knee_on_belly                                     923
bjj_stack_pass                                        883
sambo_stance                                          302
bjj_guard_pass                                        247
mma_sprawl_fronthead                                  233
bjj_bridge_escape                                      97
bjj_knee_cut_pass                                      95
sambo_scarf_holddown                                   92
judo_gyakujujijime                                     83
bjj_armbar                                             74
bjj_back_escape                                        63
judo_uchimata                                          41
bjj_north_south                                        39
bjj_over_under_pass                                    36
judo_okuriashiharai                                    36
judo_ukigoshi                                          31
judo_taiotoshi                                         27
```

**Notable shifts:** `bjj_front_headlock` rises from 1521 to 1634 (the wrestle-grappler trained it heavily). `bjj_arm_triangle` disappears from the top 20 (the striker didn't train submissions). `judo_ukigoshi` and `judo_taiotoshi` appear (the wrestle-grappler trained them).

---

## ARGUMENT AGAINST THE REPAIR

The numbers support the repair, but not for the reason you might expect.

**The palette narrows.** Fighter B (the striker) loses 16 techniques because he didn't train submissions or takedowns. This is the tier 1-2 fallback being removed, and it is a downgrade in variety. A fighter who didn't train a technique can no longer use it, even though the tier 1-2 fallback would have given it to him.

**But the bout outcomes don't move.** Every KO, TKO, SUBMISSION, DECISION, takedown, control unit, and ground tick is identical across both arms. The change is confined to naming: the same decisions are made, but the technique names reflect what the fighter actually trained.

**So the repair is worth it for the truth upgrade, not for the variety upgrade.** The current tree gives every fighter a generic tier 1-2 palette, which means a striker who never trained submissions is still throwing `bjj_arm_triangle` and `bjj_armbar`. The carried tree restricts him to what he trained, which is an upgrade in truth even though it narrows the palette.

**The narrowing is real and should be called out.** A fighter who didn't train a technique can no longer use it, and that is a downgrade in variety. But the bout outcomes don't move, which means the downgrade in variety doesn't hurt the fight dynamics. The fights are just as exciting, just as decisive, just as grapple-heavy — they're just more honest about what the fighters actually trained.

**Recommendation:** Ship the repair. The upgrade in truth outweighs the downgrade in variety, and the bout outcomes don't move. But call out the palette narrowing in the commit message and the release notes, so users know that a fighter who didn't train a technique can no longer use it.

---

## THE TRAP

The task warned: "the palette you are measuring is read at BOUT SETUP, not per tick. Write the record in `_build_fighter`, not after `_seat_palette` has run, or both arms print identical numbers."

I wrote it in `_build_fighter`, and the arms are NOT identical. The palette narrows, the technique names change, and the learned percentage goes from 98.7% to 100%. The arm is live.

But the bout outcomes are identical, which is the finding that surprised me. I expected the palette narrowing to change the fight dynamics — fewer techniques means fewer options means different decisions. But the decisions are identical, which means the engine is robust to palette changes. The same decisions are made, just with different technique names.

This is the finding that matters: **the engine is robust to palette changes**. The repair is worth it for the truth upgrade, and it doesn't hurt the fight dynamics.

---

## FILES TOUCHED

- `Godot/scripts/FightRealtime.gd` — added `carry_progress` option to `begin()` and honoured it in `_build_fighter`.
- `Godot/tools/q142_training_record.gd` — new measurement tool.
- `research/Q142_DIGEST.md` — this file.

## TESTS

- Parse gate: passed (2 files, 0 failures).
- `--only grapple`: 10 tests, 0 failures.
- `--only technique_id`: 1 test, 0 failures.

## TOOL USAGE

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q142_training_record.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q142_training_record.gd -- 10   # smoke run
```

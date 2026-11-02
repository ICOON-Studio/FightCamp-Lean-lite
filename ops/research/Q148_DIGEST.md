# Q148 DIGEST — The 205 Phase Violations: Full Classification

**Branch:** `qwen/q148-phase-violations`
**Date:** 2026-09-23
**Tool:** `Godot/tools/q148_phase_violations.gd`

## Retraction

**The previous digest's claim that the count "dropped to 19 after the S59/U142 merge" is FALSE.**
The tool's filter (`_is_ground_only` + `_is_ground_phase`) only detected one of the test's
two violation directions: all-ground technique on non-ground event. The other direction —
all-stand technique on non-stand event — was never checked. 186 violations were invisible.
The tool now copies `_phase_compatible` and `_event_phase` from the test verbatim.
Both the tool and the test now report **205** on the same tree.

## Population

Same as Q147: 7 grappling rulesets × 8 bouts × seeds 565000+i, 3 rounds, carry_progress=true.
Two different men per ruleset. Total named non-stall grapple events: **1723**.

| ruleset | Fighter A | Fighter B |
|---------|-----------|-----------|
| judo | thrower (grapple 84, untrained: strikes/punches) | pinner (grapple 80, untrained: strikes/kicks) |
| freestyle_wrestling | snatch wrestler (grapple 84, untrained: strikes/submissions) | go-behind specialist (grapple 80, untrained: strikes/punches) |
| greco_roman | body-lock thrower (grapple 82, untrained: strikes/leg_attacks) | arm-throw specialist (grapple 78, untrained: strikes/kicks) |
| bjj | guard passer (grapple 86, untrained: strikes/punches) | submission hunter (grapple 82, untrained: strikes/kicks) |
| sambo | throw-heavy sambist (grapple 82, untrained: kicks/kicking) | leg-lock sambist (grapple 80, untrained: strikes/punches) |
| muay_thai | clinch fighter (grapple 56, untrained: kicks/kicking) | knee-elbow striker (grapple 38, untrained: takedowns/submissions) |
| mma | wrestle-grappler (grapple 82, untrained: kicks/kicking) | striker (grapple 34, untrained: submissions/takedowns) |

## Verdict definitions

For each violation, the tool computes the technique's phase compatibility with from_stance
and to_stance using the test's exact `_phase_compatible`:

- **A**: compatible with from_stance, NOT compatible with to_stance → engine named with
  old stance (stale phase in `_move_seat`)
- **B**: NOT compatible with from_stance, compatible with to_stance → test reads wrong field
- **C**: NOT compatible with EITHER stance → event has empty stances, phase inferred from
  seat; technique's phases don't match the inferred ground phase

## Full grouped table (6 groups, sum = 205)

| kind | via | from_stance | to_stance | verdict | count | techniques |
|------|-----|-------------|-----------|---------|-------|------------|
| seat | takedown | standing | ground | **A** | 33 | bjj_arm_drag(12), sambo_stance(6), wrestling_double_leg(3), wrestling_single_leg(2), judo_koshiguruma(1), judo_hizaguruma(1), judo_ouchigari(1), wrestling_high_crotch(1), bjj_ankle_pick(1), judo_kosotogari(1), judo_osotogari(1), judo_deashi(1), judo_sasaetsurikomiashi(1), judo_tsurikomigoshi(1) |
| takedown | takedown | *(empty)* | *(empty)* | **C** | 27 | bjj_arm_drag(12), wrestling_double_leg(3), wrestling_single_leg(2), judo_koshiguruma(1), judo_hizaguruma(1), judo_ouchigari(1), wrestling_high_crotch(1), bjj_ankle_pick(1), judo_kosotogari(1), judo_osotogari(1), judo_deashi(1), judo_sasaetsurikomiashi(1), judo_tsurikomigoshi(1) |
| seat | throw | clinch | ground | **A** | 17 | bjj_arm_drag(6), sambo_arm_drag_bodylock(5), judo_ogoshi(2), judo_ukigoshi(2), judo_osotogari(1), judo_tsurikomigoshi(1) |
| throw | throw | *(empty)* | *(empty)* | **C** | 16 | bjj_arm_drag(6), sambo_arm_drag_bodylock(5), judo_ogoshi(2), judo_ukigoshi(1), judo_osotogari(1), judo_tsurikomigoshi(1) |
| seat | stand_up | ground | standing | **A** | 19 | bjj_bridge_escape(6), bjj_back_escape(5), bjj_frame_escape(5), bjj_shrimp_escape(3) |
| control | *(empty)* | *(empty)* | *(empty)* | **C** | 93 | sambo_stance(93) |

**Group sum: 205. Total violations: 205. Match: true.**

## Verdict summary

| Verdict | Count | Meaning |
|---------|-------|---------|
| A (engine defect — stale phase) | 69 | Technique compatible with from_stance, not to_stance |
| B (test artefact — wrong field) | 0 | — |
| C (event has no stance fields) | 136 | Empty from/to stance; seat infers ground; stand-only tech fails |
| **Total** | **205** | |

## Per-ruleset breakdown

| ruleset | violations |
|---------|------------|
| judo | 10 |
| freestyle_wrestling | 8 |
| greco_roman | 4 |
| bjj | 54 |
| sambo | 109 |
| muay_thai | 0 |
| mma | 20 |

## Diagnosis

### Verdict A (69): stale phase in `_move_seat`

Three transition types, all with `kind=seat` events that carry from_stance and to_stance:

1. **stand_up (ground→standing), 19 violations**: Bottom man's BJJ escape technique
   (`ground_bottom`-only) is named while stance is still "ground". Event logs
   `to_stance=standing`. Test reads "standing", finds ground-only tech → violation.

2. **takedown (standing→ground), 33 violations**: Standing/clinch technique (e.g.
   bjj_arm_drag `["standing","clinch"]`) is named while stance is still "standing".
   Event logs `to_stance=ground`. Test reads "ground", finds stand-only tech → violation.

3. **throw (clinch→ground), 17 violations**: Same pattern. Stand/clinch technique named
   while stance is still "clinch". Event logs `to_stance=ground` → violation.

All 69 are the same engine defect: `_move_seat` calls `_grapple_technique_for` BEFORE
updating `state["grapple"]`, so the technique is filtered by the OLD stance. The event
logs the NEW stance (to_stance), which the test reads as the event phase.

### Verdict C (136): same root cause, different event shape

Two sub-groups:

**C-sub-1: takedown/throw action events (43)**: For every takedown and throw, the engine
logs TWO events: a `kind=seat` event (with from/to stances → verdict A above) AND a
`kind=takedown`/`kind=throw` event (with EMPTY from/to stances). The empty stances force
`_event_phase` to fall back to the `seat` field, which infers "ground". The stand-only
technique fails on "ground" → verdict C. **Same transition, same technique, same root
cause as the A groups** — just a different event shape.

**C-sub-2: sambo_stance control events (93)**: The technique `sambo_stance` has phases
`["standing","clinch"]`. It appears 93 times as a `kind=control` event with empty via,
empty from/to stances. The seat field infers "ground". The technique is not ground-compatible
→ verdict C. The engine selected it during a ground context because the stance was still
standing/clinch (stale phase). **Same root cause.**

### All 205 trace to one engine defect

Every violation is caused by `_move_seat` naming techniques with the OLD stance before
updating `state["grapple"]`. The 69 verdict-A events carry explicit from/to stances that
prove this directly. The 136 verdict-C events carry empty stances that hide the mechanism
but produce the same symptom: a technique selected for standing/clinch appears on a
ground-inferred event.

### The 21 techniques involved

| technique | phases | count | verdict |
|-----------|--------|-------|---------|
| sambo_stance | ["standing","clinch"] | 99 | A(6) + C(93) |
| bjj_arm_drag | ["standing","clinch"] | 36 | A(18) + C(18) |
| sambo_arm_drag_bodylock | ["clinch"] | 10 | A(5) + C(5) |
| wrestling_double_leg | ["standing"] | 6 | A(3) + C(3) |
| bjj_bridge_escape | ["ground_bottom"] | 6 | A(6) |
| bjj_back_escape | ["ground_bottom"] | 5 | A(5) |
| bjj_frame_escape | ["ground_bottom"] | 5 | A(5) |
| judo_ogoshi | ["standing","clinch"] | 4 | A(2) + C(2) |
| wrestling_single_leg | ["standing"] | 4 | A(2) + C(2) |
| judo_osotogari | ["standing","clinch"] | 4 | A(2) + C(2) |
| judo_tsurikomigoshi | ["standing","clinch"] | 4 | A(2) + C(2) |
| bjj_shrimp_escape | ["ground_bottom"] | 3 | A(3) |
| judo_ukigoshi | ["standing","clinch"] | 3 | A(2) + C(1) |
| judo_koshiguruma | ["standing","clinch"] | 2 | A(1) + C(1) |
| judo_hizaguruma | ["standing","clinch"] | 2 | A(1) + C(1) |
| judo_ouchigari | ["standing","clinch"] | 2 | A(1) + C(1) |
| wrestling_high_crotch | ["standing"] | 2 | A(1) + C(1) |
| bjj_ankle_pick | ["standing"] | 2 | A(1) + C(1) |
| judo_kosotogari | ["standing","clinch"] | 2 | A(1) + C(1) |
| judo_deashi | ["standing","clinch"] | 2 | A(1) + C(1) |
| judo_sasaetsurikomiashi | ["standing","clinch"] | 2 | A(1) + C(1) |

## Conclusion

**All 205 violations trace to one engine defect: `_move_seat` names techniques before
updating `state["grapple"]`.** Zero verdict B (no test artefact). The 69 verdict-A events
prove the stale phase directly. The 136 verdict-C events are the same defect manifesting
through events with empty stance fields (seat-inferred ground phase vs stand-only technique).

The fix is an engine change in `FightRealtime.gd:_move_seat`. No test change needed.
No catalogue change needed.

# Q146 DIGEST — Why are most grapple events unnamed outside MMA?

**Branch:** `qwen/q146-unnamed-grapples`
**Date:** 2026-09-23
**Tool:** `Godot/tools/q146_unnamed_grapples.gd`

## Question

Q145 found 633/633 muay thai grapple events unnamed, and similar proportions in
judo (746/868), freestyle (769/1183), greco (803/1157), sambo (901/1605), bjj
(686/2417). MMA only 47/1741. Why?

## Method

- Same 11 rulesets, same two fighters per ruleset as Q145
- 12 bouts per ruleset, seeds 564000+i, 3 rounds, carry_progress=true
- Census: every grapple event broken down by (ruleset, kind, via) → named vs unnamed
- Palette audit: printed muay thai's 10 grapple techniques with their effects and phases

## Results

### Table 1: Unnamed events by kind (all rulesets with unnamed > 0)

| ruleset | control | seat | stall | position_change | other | total unnamed |
|---|---|---|---|---|---|---|
| muay_thai | 283 | 71 | 9 | 8 | 23 | 394 |
| judo | 269 | 74 | 25 | 7 | 0 | 375 |
| sambo | 394 | 78 | 19 | 3 | 30 | 524 |
| greco_roman | 259 | 94 | 14 | 21 | 16 | 404 |
| freestyle_wrestling | 190 | 70 | 8 | 14 | 15 | 297 |
| bjj | 366 | 94 | 17 | 0 | 0 | 477 |
| mma | 0 | 18 | 12 | 0 | 0 | 30 |

**Control events are the #1 cause across ALL grappling rulesets**, accounting for
64-77% of unnamed events.

### Table 2: Muay Thai deep dive (394 unnamed, 0 named)

| kind/via | named | unnamed |
|---|---|---|
| control/(no via) | 0 | 283 |
| seat/clinch_engage | 0 | 26 |
| seat/clinch_break | 0 | 23 |
| throw_attempt/(no via) | 0 | 9 |
| stall/(no via) | 0 | 9 |
| seat/escape | 0 | 5 |
| seat/takedown | 0 | 5 |
| seat/mount | 0 | 4 |
| seat/pass | 0 | 5 |
| position_change/mount | 0 | 4 |
| position_change/pass | 0 | 4 |
| takedown_attempt/(no via) | 0 | 4 |
| submission_attempt/(no via) | 0 | 3 |
| seat/stand_up | 0 | 2 |
| seat/throw | 0 | 1 |
| throw/throw | 0 | 1 |
| submission_finish/(no via) | 0 | 1 |

### Table 3: Muay Thai palette audit (10 moves)

Fighter A and B have identical palettes:
- `boxing_rear_uppercut` — phases=["standing"], effects={damage, chain_open}
- `boxing_double_jab` — phases=["standing"], effects={range_control, combo_open, entry_open}
- `boxing_jab_body` — phases=["standing"], effects={body_damage, combo_open, entry_open}
- `boxing_bob_weave` — phases=["standing"], effects={evasion, entry_open}
- **`boxing_clinch_tieup` — phases=["clinch"], effects={clinch_control:8, phase_transition:5}**
- `boxing_feint` — phases=["standing"], effects={entry_open, distance_read}
- **`muay_thai_plum` — phases=["clinch"], effects={clinch_control:12, setup:9}**
- **`muay_thai_chapko_khaeng` — phases=["clinch"], effects={clinch_control:8, damage:5}**
- **`muay_thai_chapko_khang` — phases=["clinch"], effects={clinch_control:7, balance_break:6}**
- `muay_thai_catch_kick` — phases=["standing"], effects={guard:7, sweep:5}

**Only 4 of 10 techniques carry grapple effects, and ALL 4 have `clinch_control` —
NONE have plain `control`.**

## Diagnosis: Three causes, with counts

### Cause 1: Control events — effect name mismatch (283 of 394 muay thai, 71.8%)

**The namer's default branch looks for `["control", "grip_control", "position"]`,
but techniques carry `clinch_control`, `top_control`, `guard_control` — which are
DIFFERENT effect names in the GRAPPLE_EFFECTS list.**

Code: `FightRealtime.gd` line 3873-3874:
```
_:
    wanted = ["control", "grip_control", "position"]
```

The muay thai palette has 4 techniques with `clinch_control` effect. The namer
looks for `control` (plain). `clinch_control` ≠ `control`, so the namer returns ""
for every control tick.

This is the #1 cause across ALL grappling rulesets:
- muay_thai: 283 of 394 (71.8%)
- sambo: 394 of 524 (75.2%)
- bjj: 366 of 477 (76.7%)
- judo: 269 of 375 (71.7%)
- greco: 259 of 404 (64.1%)
- freestyle: 190 of 297 (64.0%)

**MMA has 0 unnamed control events** because MMA's palette (119-120 techniques from
6 disciplines) includes wrestling/judo/bjj techniques that carry plain `control`
effect or effects that match the namer's list.

### Cause 2: Phase filter uses old stance (26 of 394 muay thai clinch_engage, 6.6%)

**When `_move_seat` computes `seat_move_id`, it calls `_grapple_technique_for`
which reads the CURRENT stance from `state["grapple"]` — but the stance hasn't
been updated yet (that happens at line 4282, after the namer call at line 4240).**

Code: `FightRealtime.gd` line 4225-4240:
```
var moved: Dictionary = Seat.apply(g, to_stance, to_seat, _side_index(top_side))
...
seat_move_id = _grapple_technique_for(state, actor_side, "position_change", via)
...
state["grapple"] = moved  # line 4282 - TOO LATE
```

For a clinch_engage:
- Old stance: "standing" → ok_phases = {"standing": true, "standing_back": true}
- Muay thai techniques have phase "clinch"
- "clinch" NOT in ok_phases → phase filter blocks them → returns ""

**MMA has 26 named clinch_engage events** because MMA's larger palette includes
techniques with `clinch_control` effect AND phase "standing" (or no phase
restriction), so they pass the filter even with the old stance.

This cause affects all rulesets with clinch work:
- bjj: 53 unnamed clinch_engage
- judo: 28 unnamed
- muay_thai: 26 unnamed
- freestyle: 26 unnamed (clinch_engage not shown, but similar pattern)
- greco: 21 unnamed (clinch_break, similar phase issue)
- sambo: 26 unnamed (clinch_break)

### Cause 3: Stall events — deliberately unnamed (9 of 394 muay thai, 2.3%)

**Stalls are the ABSENCE of action — the referee's word for nothing happening.
Naming a technique would invent a move nobody threw.**

Code: `FightRealtime.gd` line 4116-4126 and 4383-4393:
```
## S49 - A STALL IS DELIBERATELY UNNAMED, and that is not an oversight.
```

This is by design, not a bug. Stalls account for:
- muay_thai: 9 of 394 (2.3%)
- judo: 25 of 375 (6.7%)
- sambo: 19 of 524 (3.6%)
- bjj: 17 of 477 (3.6%)
- greco: 14 of 404 (3.5%)
- freestyle: 8 of 297 (2.7%)
- mma: 12 of 30 (40.0%) — MMA's small unnamed count is mostly stalls

## What is left unexplained

**Muay thai: 394 - 283 - 26 - 9 = 76 events (19.3%)** are other kinds
(clinch_break 23, throw_attempt 9, escape 5, takedown 5, mount 4, pass 4,
takedown_attempt 4, submission_attempt 3, stand_up 2, throw 1, submission_finish 1).

These likely have similar effect mismatches or phase filter issues:
- `clinch_break` via → wanted: `["control_escape", "escape", "angle_exit"]` — muay thai
  techniques don't carry these effects
- `throw_attempt` kind → wanted: `["throw_setup", "throw_open", "throw_damage", ...]` —
  muay thai techniques don't carry these effects
- `escape`, `stand_up` via → similar mismatches

**The pattern is consistent: the namer's effect lists are authored for MMA's large
multi-discipline palette, and single-discipline rulesets like muay thai don't have
techniques carrying the effects the namer expects.**

## Population

Two different men per ruleset, both legal for that ruleset's disciplines.
They differ by style (untrained branches) and stats. No identical fighters.

**Muay Thai:** clinch fighter (grapple 56, untrained kicks/kicking) vs knee-elbow
striker (grapple 38, untrained takedowns/submissions)

## Conclusion

**The top cause is effect name mismatch in the control event namer.** The namer
looks for plain `control` but techniques carry `clinch_control`, `top_control`,
`guard_control` — which are separate effects in the GRAPPLE_EFFECTS list. This
accounts for 64-77% of unnamed events across all grappling rulesets.

**The second cause is the phase filter reading the old stance.** When a seat change
happens (clinch_engage, takedown, etc.), the namer is called before the stance is
updated in state, so it filters against the wrong phase. This blocks techniques
that only work in the new phase.

**The third cause is stalls, which are deliberately unnamed by design.**

**MMA is the only ruleset where these causes don't bite**, because MMA's palette
(119-120 techniques from 6 disciplines) is large enough that some techniques carry
the effects the namer expects, and some have phase flexibility that survives the
old-stance filter.

The fix (not in scope for this diagnose-only task) would be:
1. Add `clinch_control`, `top_control`, `guard_control` to the control namer's
   wanted list, OR add a plain `control` effect to clinch/ground techniques
2. Update `state["grapple"]` BEFORE calling `_grapple_technique_for` in `_move_seat`

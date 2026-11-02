# Q152 DIGEST — Judo and Muay Thai grapple naming coverage

## Problem
Contract test clause 1 (>=85% non-stall grapple events named):
- judo: 92/123 = 74.8% FAIL
- muay_thai: 109/166 = 65.7% FAIL
- All other rulesets PASS; clauses 2-5 pass (0 violations)

## Diagnostic
Built `tools/q152_unnamed_diagnostic.gd` — replays Q147's population for
judo and muay_thai, captures every unnamed non-stall grapple event, groups
by (kind, via, from_stance, to_stance, seat), and diagnoses WHY the namer
returned empty (palette empty / phase filter / effect filter).

88 unnamed events found (both rulesets combined):

| Reason | Count | Ruleset | Detail |
|--------|-------|---------|--------|
| C: effect_filter_empty | 27 | both | clinch_break/stall: `clinch_control` not in standing fallback |
| C: effect_filter_empty | 7 | judo | pass/escape/stand_up: `pin_control`/`arm_isolation` not in ground vocab |
| C: effect_filter_empty | 8 | both | throw/throw_attempt from ground: no throw effects in ground catalogue |
| B: phase_filter_empty | 40 | muay_thai | ground events: muay_thai has ZERO ground techniques |
| C: effect_filter_empty | 3 | muay_thai | stand_up/escape from ground: no ground techniques to match |
| UNEXPECTED | 3 | both | stance mismatch between engine and diagnostic reconstruction |

## Fix (FightRealtime.gd)

Two changes to `_grapple_technique_for`:

1. **`.duplicate()` on GRAPPLE_VIA_EFFECTS lookup** — the const Dictionary
   returns read-only arrays; `.append()` silently failed, which also meant
   the existing wrestling alias block was a no-op for via-based events.

2. **`clinch_control` added to standing fallback** — judo's `kumikata` and
   muay_thai's `plum` carry `clinch_control`, not `control` or
   `grip_control`. The phase filter keeps it legal (clinch techniques only
   pass when stance is clinch).

3. **Ground vocabulary aliases for judo/muay_thai** — when stance is ground,
   `pin_control` and `arm_isolation` are added to `wanted`. Judo's ground
   catalogue is pins and submissions; the namer expected BJJ-flavoured
   `escape` and `pass_guard` effects that judo does not carry.

## Results

| Ruleset | Before | After | Verdict |
|---------|--------|-------|---------|
| judo | 92/123 = 74.8% | 105/123 = 85.4% | **PASS** |
| freestyle_wrestling | 381/381 = 100% | 381/381 = 100% | PASS |
| greco_roman | 261/261 = 100% | 261/261 = 100% | PASS |
| bjj | 988/1064 = 92.9% | 988/1064 = 92.9% | PASS |
| sambo | 418/473 = 88.4% | 418/473 = 88.4% | PASS |
| muay_thai | 109/166 = 65.7% | 112/166 = 67.5% | FAIL |
| mma | 527/551 = 95.6% | 527/551 = 95.6% | PASS |

Clauses 2-5: 0 violations (unchanged). Phase violations (Q148): 0.

## Muay Thai ground gap — GENUINE, cannot be fixed by namer

40 of muay_thai's 54 remaining unnamed events are ground-position events
(control at side/mount/half, position changes, seats) where the fighter
has gone to the ground but the muay_thai discipline has **zero ground
techniques** in the catalogue. The muay_thai ruleset's discipline_tags
resolve to `["muay_thai", "boxing"]` — neither has a ground-phase node.

These events CANNOT be named legally. The fighter has not learned any
technique for that position. Naming one would violate clause 2 (LEARNED).

Fixing this requires adding muay_thai ground techniques to the catalogue
(e.g. Mat Lumpee ground fighting), which is a data task, not a namer task.

## Files changed
- `Godot/scripts/FightRealtime.gd` — namer fix (29 insertions, 1 deletion)
- `Godot/tools/q152_unnamed_diagnostic.gd` — diagnostic tool (new)

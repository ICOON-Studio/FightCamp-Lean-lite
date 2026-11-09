# TASK KNOW1 - QWEN (qwen3-coder) - Knowledge.gd: what the player can see of a boxer, and the range never lies

Status: OPEN (S416, Claude main). Discipline: boxing. Model: qwen3-coder. Approved by the operator: Q-S294-139, design ops/research/KNOWLEDGE_S411.md. Step 1 of its build order. Nothing reads this module yet: no screen and no game path changes.

## Contract
OWNS: scripts/rules/Knowledge.gd, tests/knowledge_test.gd
RED_TEST: tests/fighter_model_test.gd -> FIGHTER_MODEL failures=0
REGRESSION: fighter_model_test
VISUAL: no

## Prior research
ops/research/KNOWLEDGE_S411.md (read all of it: "What you can see", "Knowledge goes stale", "Rules that keep it fair"). scripts/rules/Attrs.gd (the attribute keys). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach who has watched someone for a week says "somewhere between 50 and 70". After a year the coach says "about 62". The coach's guess can be off, but the real number is always inside what the coach said.

## Prefab check
None: this is a small pure rule.

## The job
scripts/rules/Knowledge.gd, pure static, preloading only Attrs.gd. All starting numbers are constants at the top, each marked `# G` (game value). No he or she anywhere.

A boxer's knowledge is a plain Dictionary, saved with the career:
`{"seed": int, "seen_all": bool, "body": float, "skills": float, "fire_spar": float, "fire_bout": float}`. The last four are exposure.

- `GROUPS`: body = strength, explosiveness, speed, stamina, recovery, flexibility. skills = accuracy, timing, defence, footwork, inside, fight_iq. fire = durability, composure, heart.
- `fresh(seed) -> Dictionary`: nothing seen yet. `all_seen() -> Dictionary`: seen_all true, for old saves and boxers already at the club.
- `group_of(attr) -> String`: "" for anything not in GROUPS.
- `width(k, group) -> float`: half the range in attribute points. Day one: body 8.0, skills 12.0, fire 25.0. Formula: `floor + (start - floor) / (1.0 + exposure / HALF)`, with floor 0.5 and HALF 12.0 for body and skills. A seen_all boxer returns 0.0.
- Fire uses both exposures: `fire_bout` counts in full, `fire_spar` counts only up to the exposure that halves fire's width, so sparring alone can never bring fire below half way (the design's "sparring only half way").
- `expose(k, group, amount, kind)` adds exposure and returns nothing. Kind is "session", "test", "spar" or "bout". Group fire takes only "spar" (to fire_spar) and "bout" (to fire_bout). Negative amounts do nothing.
- `range_of(k, attr, truth, hype := 0.0) -> Dictionary` `{lo, hi, centre, width}`. The offset per boxer and attribute comes from `hash([seed, attr])`, is fixed, and lies in -0.6..0.6. Hype (0..1) lifts it by up to 0.3, never past 0.9. `centre = truth + offset * width`, `lo = truth + (offset - 1) * width`, `hi = truth + (offset + 1) * width`, both clamped to 0..100 afterwards. An attribute outside GROUPS has width 0 (always exact).
- `stale(k, why)`: why "knockout", "layoff" or "step_up" cuts fire_spar and fire_bout to 60%, and "ageing" to 85%. Body and skills do not go stale. A seen_all boxer is unchanged.

tests/knowledge_test.gd prints `KNOWLEDGE failures=<n>`. Run these over at least 2,000 random cases from seeded RNGs, on real attribute keys:
1. The truth is inside lo..hi at every exposure, hype, and truth from 0 to 100.
2. More exposure never widens a range, and the new range lies inside the old one when the truth has not changed. Check this with hype fixed.
3. Fire: fire_spar alone, however large, leaves fire's width at or above half of its day-one width. A bout goes below it.
4. A body session does not change skills or fire width.
5. stale widens fire and leaves body and skills alone; the truth is still inside afterwards.
6. Same seed and attribute give the same offset across calls; two different seeds differ somewhere.
7. all_seen gives width 0 and lo = hi = truth.
8. Hype 1.0 puts the centre above the truth (when the truth is below 90) by no more than 0.9 x width.
9. A control that must be able to fail: compute a range with the offset forced to 1.5 inside the test and check that the truth falls outside it.

## Rules
No file over 500 lines. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script tests/knowledge_test.gd`. On a cloud runner, run Godot as CI does. Change nothing else.

## The one trap
GDScript's `hash()` of an Array is stable inside one run but is not promised across engine versions, and it can be negative. Reduce it with `absi(h) % 10001` before scaling. A saved range must come out the same after a load, so store only the seed and exposures, never a computed offset.

## Result lines (PR body)
RESULT: tests/fighter_model_test.gd -> FIGHTER_MODEL failures=0
RESULT: tests/knowledge_test.gd -> KNOWLEDGE failures=0

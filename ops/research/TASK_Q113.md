# TASK Q113 — QWEN — THE JAB IS AUTHORED PRIMARY AND ARRIVES LAST: WHERE THE ROLE INTENT IS LOST

**Agent:** Qwen · **Model:** `qwen3-coder`, medium · `--yolo`, stdin, from worktree `FightCamp-Q81`
**Assigned:** 2026-09-20 by Claude. **Follows your own Q112**, which measured the problem.

---

## THE FINDING YOU ALREADY MADE, AND WHY IT IS NOT A WEIGHTS PROBLEM

Q113 exists because of your Q112 census: **the engine's pooled share of landed distance head strikes
in a POWER role is 73.8%, against an anchor that implies about 26%.** Roughly 3x too many power
shots, and far too few jabs.

The obvious cause would be that the plans ask for power. **They do not.** `boxing_out_boxer` in
`Godot/assets/data/fight_plans.json` authors this:

```json
"role_priority": { "setup": "PRIMARY", "counter": "PRIMARY", "damage": "SECONDARY" }
```

and `FightPlans.gd:29` maps those words to numbers:

```gdscript
const FIT_WEIGHTS := {"PRIMARY": 3.0, "SECONDARY": 1.0, "OPPORTUNISTIC": 0.5, "AVOID": -2.0}
```

**So the authored intent is already 3:1 in FAVOUR of setup over damage, and the delivered result is
roughly 3:1 the other way.** Something between the plan and the draw is losing it.

**THIS IS THE SAME SHAPE AS THE D3 TARGET SPLIT**, where delivered head/body/legs is 51.2/42.9/5.9
against an authored 60/28/12 — delivery differing from authoring, with the weights innocent. Do not
"fix" this by raising a number until the census moves. **Find where the intent is dropped.**

## THE QUESTION, IN ONE PARAGRAPH

`FightMoves.select` (`FightMoves.gd:494`) reads its role weights from `weights.get("roles", {})` and
multiplies each candidate by `role_weights.get(role, 1.0)` — **defaulting to 1.0 when the role is not
in the dictionary.** Trace, with evidence at each hop, what `weights["roles"]` actually contains at
the moment a standing distance strike is chosen in a real bout. Does it carry the plan's
`role_priority` at all? Is it empty, so that every role silently scores 1.0 and the authored 3:1
never happens? Does something upstream build it from a different source? **Print the real dictionary
from a real bout — do not read the code and conclude.**

## WHAT TO DELIVER

1. **THE TRACE.** Where `weights["roles"]` is built, every hop from `fight_plans.json` to `select`,
   and the literal dictionary observed at a real standing strike, for at least three plans with
   DIFFERENT `role_priority` blocks (`boxing_out_boxer` has setup PRIMARY; pick two others that
   differ, including one that makes damage PRIMARY, so a difference can show).
2. **THE VERDICT**, in one sentence: is the authored role priority reaching the draw, and if not, at
   which hop is it lost?
3. **THE FIX, BEHIND A SWITCH THAT DEFAULTS TO OFF.** Name it plainly (e.g.
   `ROLE_PRIORITY_FROM_PLAN`). **Do not change shipped behaviour.** Claude flips the default at
   integration after measuring the pace, the D3 split and the knockdown anchors together, because
   this change moves all of them at once.
4. **THE CENSUS, BEFORE AND AFTER**, re-run with your own Q112 tool: the power-role share with the
   switch off and with it on, per discipline and pooled, **with the denominator printed beside every
   share**.

## THE CATALOGUE QUESTION YOUR OWN CENSUS OPENED, AND IT MAY CAP THE FIX

Q112 found that **MMA has no standalone jab technique** — `mma_jab_levelchange` is a grapple entry,
not a strike. **So for MMA, "throw more jabs" may have nothing to throw.** Report, per ruleset, how
many distinct `setup`-role STRIKING techniques are actually available to a fighter with no
`technique_progress` record. If a ruleset has none or nearly none, the role weighting cannot fix it
and that is a CONTENT gap, not a calibration one — say so, and do not invent techniques. **Naming
that ceiling is worth as much as the fix.**

## POPULATION — AND THIS IS A HARD RULE

Never two identical fighters: not the same `stats`, not the same known techniques, not the same
frame, not the same plan. **Check the key name is `stats`** — `"attributes"` silently yields an
EMPTY stat block and has broken three separate measurements. A fighter with no `technique_progress`
record is handed his ruleset's whole tier 1-2 palette. Every fighter must be **legal for the ruleset
he fights under**: differentiate by style and attributes INSIDE the ruleset, never by removing
techniques the ruleset legally permits. **Your output must NAME its population and its catalogue.**
Reuse Q112's population so the two censuses are directly comparable, and say that you did.

## OWNED FILES

- `Godot/tools/q112_role_census.gd` — yours, extend it rather than writing a second census.
- `Godot/scripts/FightMoves.gd` (1,419 lines) — `select` at `:494`, `STRIKE_ROLES` `:92`,
  `POWER_ROLES` `:99`, `is_significant` `:611`. **Read `sed -n 'A,Bp'` windows, never whole.**
- `Godot/scripts/FightPlans.gd` (374 lines) — small enough to read whole. `FIT_WEIGHTS` `:29`.
- `Godot/assets/data/fight_plans.json` — data; read the plans you name.
- `research/Q113_ROLE_INTENT.md` — your digest.
- `research/Q113_check.py` — your gate. **Write it FIRST** and make the work satisfy it.

**NOT YOURS:** `FightRealtime.gd` (Claude is editing it this session — do not touch it),
`HANDOFF.md`, any shipped default, and the technique catalogue.

## GATE

```
python Godot/tools/check_scripts.py <each touched .gd>
python Godot/tools/run_tests.py --only moves
python Godot/tools/run_tests.py --only plan
python research/Q113_check.py     # must exit 0
```

**Ceilings, and they are CEILINGS — if you land lower, say so and push.** `--only moves` and
`--only plan` at their current counts or better. **Never the full suite**: Claude runs it at
integration, and a second concurrent Godot gives both of us false failures.

## THE TRAP SPECIFIC TO THIS TASK

**`role_weights.get(role, 1.0)` DEFAULTS TO 1.0.** An empty `roles` dictionary and a perfectly
balanced one produce byte-identical behaviour, so "the weights look fine" is not evidence and
neither is a passing test. **Distinguish them by printing the dictionary itself**, and prove your
trace by making the plan's authored priority demonstrably change a draw — if you cannot make a
DIFFERENT plan produce a DIFFERENT observed `weights["roles"]`, you have found the bug rather than
failed to find it. Say which.

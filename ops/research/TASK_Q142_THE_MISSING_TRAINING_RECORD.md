# TASK_Q142 — WHAT BREAKS IF THE FIGHTER REMEMBERS WHAT HE TRAINED?

**Model: `qwen3-coder`, medium effort, `--yolo` (NEVER `auto` — auto leaves you
with no shell tool at all).** Worktree `FightCamp-Q114`, cut a FRESH branch off
`origin/master` named `qwen/q142-training-record`.

**Read this file and nothing else.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore the
repo to "get oriented". Every fact you need is below.

---

## THE DEFECT, AND IT IS ALREADY PROVEN

`Godot/scripts/FightRealtime.gd` has a function `_build_fighter` (near line
1135) that turns an athlete record into the live fighter dictionary the engine
uses all bout. **It copies `stats` and it does NOT copy `technique_progress`.**

So `state["a"]` and `state["b"]` carry a stat block and **no training record at
all**. Three call sites work around this with `fighter.get("athlete", fighter)`
— and because there is no `"athlete"` key either, that fallback resolves to the
**built fighter**, which has no record either. The lookup silently returns `{}`.

This was found on 2026-09-23 by the S58 ground-graph sweep, where it made a
chooser's trained-skill term score `0.000` on every edge of 542 decisions
without ever raising anything, because zero is a legal score.

**One consequence is already known and it is the interesting one.**
`FightMoves.grapple_arsenal(athlete, ruleset_id)` narrows a fighter's palette by
`technique_progress` where it exists, and **falls back to the whole tier 1–2
palette where it does not** (see `FightMoves.gd` around line 737: with no
`technique_progress` a man gets tier 1 and 2 only — 13 moves). That fallback is
firing for **every fighter in every bout**, because the record never arrives.

So today, a man's named grapple techniques come from a generic tier 1–2 palette
rather than from what he actually trained.

---

## WHAT I WANT, AND IT IS A MEASUREMENT, NOT A FIX

**Do NOT ship the repair. Measure what the repair would do.**

Build a tool `Godot/tools/q142_training_record.gd` that runs **two arms** over
the same bouts on the same seeds and reports the difference:

- **arm `current`** — the tree exactly as it is.
- **arm `carried`** — `_build_fighter` also writes
  `"technique_progress": athlete.get("technique_progress", {})`.

Put the arm behind an option on `FightRealtime.begin` named
`carry_progress` (default **false**), exactly as `ground_arm` already works a
few lines below it — read it in `begin`, store it on the state dictionary, and
have `_build_fighter` honour it. **`false` must be byte-identical to the
shipped tree** and your tool must show that rather than assert it.

### THE FOUR NUMBERS I WANT BACK

1. **How many distinct grapple technique ids appear in the log, per arm**, and
   the full name→count table for each. This is the headline: does carrying the
   record widen the vocabulary or narrow it?
2. **How many named grapple events name a technique the fighter has actually
   LEARNED**, per arm, as a count and a percentage of named grapple events. On
   `current` this may well be low or accidental; say what it is.
3. **Does anything else move?** Bout methods (KO / TKO / SUBMISSION /
   DECISION), takedowns landed, submissions opened, control units, and ground
   ticks per seat. Report every one of these per arm even where it did not
   move — **a row that did not move is a result**, and it is the row that says
   the change is confined to naming.
4. **The two fighters' palettes, printed once at the top**: how many grapple
   techniques each man's arsenal holds on each arm. If carrying the record
   makes a man's palette *smaller*, say so loudly — that is the tier 1–2
   fallback being removed, and it may be a downgrade in variety even though it
   is an upgrade in truth.

### POPULATION — READ THIS TWICE, IT HAS COST THIS PROJECT FOUR TIMES

**NEVER TEST IDENTICAL FIGHTERS.** Use
`Godot/tools/measure_ruleset_sweep.gd`'s `style_fighter("mma", 0, "a")` and
`style_fighter("mma", 1, "b")` — a wrestle-grappler (grapple 82) against a
striker (grapple 34), two different men, both legal to grapple under MMA.
**Print both stat blocks and REFUSE TO RUN (`fails=1`) if they are identical.**
Name the population and the catalogue path in your own output: a fixture is not
a finding, and a later reader must be able to tell one from the other.

Use **120 bouts, 3 rounds, seed base 561000, ruleset `mma`** so your numbers sit
beside S58's. Take a `-- <n>` command-line argument for a smaller smoke run.

Note the key spelling trap: it is **`"stats"`**, not `"attributes"`. Three
shipped bugs have turned on that, and the wrong name silently yields two
fighters on empty defaults — which is the identical-fighters rule broken
without anyone seeing it.

---

## OWNED FILES

- `Godot/tools/q142_training_record.gd` — **new**, yours.
- `Godot/scripts/FightRealtime.gd` — **edit ONLY** `begin` (to read
  `carry_progress` and store it) and `_build_fighter` (to honour it). Touch
  nothing else in that file.
- `research/Q142_DIGEST.md` — **new**, yours. Your findings, with the
  tables.

`FightRealtime.gd` is **4,700+ lines — NEVER open it whole.** Read
`sed -n '790,830p'` for `begin`'s option block (the `ground_arm` option there is
your pattern — copy its shape), and `sed -n '1135,1200p'` for `_build_fighter`.
Those two windows are all you need.

## TEST TIER — A SCRIPT IS EDITED, SO THIS IS THE MIDDLE TIER

Parse gate FIRST on every touched `.gd`. **A parse error HANGS a headless test
for 600 s instead of failing it**, so never skip it:

```
python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tools/q142_training_record.gd
```

Then your own tool, then these two subsets and **NOTHING MORE**:

```
python Godot/tools/run_tests.py --only grapple
python Godot/tools/run_tests.py --only technique_id
```

**DO NOT RUN THE FULL SUITE.** It is 356 tests, about twenty minutes, and it is
the integrator's job once at the end — not yours.

**Gate as a CEILING, never an exact count:** `--only grapple` must read
`fails=0` **or better**, and `--only technique_id` the same. If you land
something better than asked, say so and push it — do not withhold a better
result because a number did not match.

**The exit code alone is NOT a pass.** A GDScript runtime error leaves rc=0, so
a test whose module was clobbered prints twenty `SCRIPT ERROR` lines and then
prints `0 failure(s)` and exits 0. Read the output, not the code. Godot's
`N RID allocations ... were leaked at exit` and `N resources still in use at
exit` are teardown chatter on any run that touches a scene — they are NOT
failures and the runner already filters them.

---

## GDSCRIPT TRAPS THAT COST A FIX CYCLE EVERY TIME

- `var x := <call>` fails when the call returns Variant (a `.size()` or
  `.get()` on an untyped value, a static on a `load()`ed script). Write the
  type: `var n: int = ...`.
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if` / `for` blocks.
- `%` inside a format string must be `%%`.

---

## THE ONE TRAP SPECIFIC TO THIS TASK

**The palette you are measuring is read at BOUT SETUP, not per tick.**
`_seat_palette` builds `fighter["arsenal"]` once from the athlete record. If you
write `technique_progress` onto the built fighter *after* that has run, every
number you print will be identical on both arms and you will conclude, wrongly,
that carrying the record changes nothing. **Write it in `_build_fighter`, and
prove the arm is live by printing the two palettes' SIZES before you print
anything else.** An arm that cannot move is not a control — it is a bug wearing
a control's name.

---

## WHEN YOU ARE DONE

Commit, push `qwen/q142-training-record`, write `Q142_DIGEST.md`, and send one
line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic Q142 --body "<one line, NAME THE BRANCH>"
```

**Do NOT edit `HANDOFF.md`** — I write your block.

**ARGUE AGAINST THE REPAIR IF THE NUMBERS SUPPORT IT.** If carrying the record
makes the game worse — a thinner palette, a duller fight, a moved method
distribution — say so plainly and recommend against it. A measurement that
refuses its own premise is worth more here than one that confirms it, and this
project has shipped four of those on purpose.

# TASK Q44 — QWEN — THE FIGHT IN THE ONLY UNITS ANYBODY PUBLISHES

Model: Qwen CLI, **medium** effort. Owner: qwen.

**Tier: A NEW FILE IN `Godot/tools/` ONLY. NO `.gd` IN `scripts/` IS EDITED, AND
NO TEST FILE IS ADDED.** Parse gate on your one new file, then run it. **DO NOT
RUN THE SUITE.** A harness in `tools/` costs the suite nothing and cannot break
another test. R101 added two of these and paid nothing for them.

## Why this exists

R102 is rewriting the exchange, and **G54 has just told us the only published
quantity we may grade it against.** Read `research/G54_WHAT_IS_DEFENCE.md`
sections 1, 2 and 7 — and nothing else in that file.

The headline you need: **no official system records a defensive action.** UFC
Stats and CompuBox both collapse block, slip, parry and miss into one "did not
land". Our engine emits six contact words, which is FINER than anything
published. So the engine can only be graded on the coarse number, and that
number has a specific denominator that we have never once computed.

`Godot/tools/measure_r101.gd` reports **accuracy = 57.1%**. Nobody has converted
that into the units a commission actually publishes, and the conversion is not
a rename — **the denominators are different per sport.**

## What to build

**`Godot/tools/measure_r102.gd`** — a new `extends SceneTree` harness, modelled
directly on `Godot/tools/measure_r101.gd`. Copy its `_initialize`, `_ruleset`
and `_fighters` shape; you are writing a new set of counters, not a new
framework.

**READ `measure_r101.gd:30-45` FIRST.** It carries the trap that cost that
harness its first run: a bare `{"id": "boxing"}` gets a DEFAULT scoring profile
and boxing then spends 14% of its impacts on the ground. **Load
`res://assets/data/combat_rulesets.json`, exactly as R101 does.** A finding about
the harness is not a finding about the engine.

### PART 1 — the published numbers, with their denominators named

Per ruleset (`boxing`, `mma`, `kickboxing`, `muay_thai`), 40 bouts, report:

1. **`LANDED`** = impacts whose contact word is `clean` or `glancing`.
   **`absorbed` is NOT landed** — G54 §1: "a punch that hits the guard is a
   miss if the operator does not call it landed". `blocked`, `slipped` and
   `missed` are obviously not landed.
2. **MMA-style `Str. Def.`** = 1 − (landed ÷ **significant attempts**).
   The engine already counts `significant_throws`. **The denominator is
   SIGNIFICANT attempts, not all attempts.** Report the two counts as well as
   the ratio, so the denominator is visible in the output and not just in the
   arithmetic.
3. **Boxing-style connect %** = landed ÷ **total impacts built** (every throw
   that got as far as a contact word). **This denominator is TOTAL, not
   significant.** Report both counts.
4. **`SApM`** — significant attempts absorbed per minute, per fighter. G54 says
   to pair it with `Str. Def.` so a low-volume artefact does not look elite:
   elite is often under 2.5, and 4+ is a beating. Report it; do not judge it.
5. **The full contact-word mix**, six shares that sum to 1.0, per ruleset.

**Print the denominator in the same line as every percentage.** This is a
standing rule in this project and R101's finding 1 is what it cost when it was
broken.

### PART 2 — THE TWO SWEEPS, AND THEY ARE THE POINT OF THE TASK

R102 splits one roll into two channels: **a miss is the attacker's inability, a
dodge is the defender's ability.** The trap the stage is most likely to fall
into is that the two end up reading the same inputs and emitting the same word,
so the split lives in the comments and not in the numbers.

**The test is blunt, and it is yours to build the instrument for.** On the `mma`
ruleset, 10 bouts per level:

- **SWEEP A — the attacker.** Hold fighter A's `defense` at 50 and sweep his
  **`technique`** from 20 to 90 in steps of 10 (8 levels). Report the full
  six-word contact mix of the blows **A THROWS** at each level.
- **SWEEP B — the defender.** Hold fighter A's `technique` at 50 and sweep
  fighter B's **`defense`** from 20 to 90 in steps of 10 (8 levels). Report the
  full six-word contact mix of the blows **A THROWS** at each level.

Both sweeps must report the mix of the SAME population — the blows A throws at
B — so the two columns are directly comparable.

**Report, for each sweep, which words move and by how much (floor level vs
ceiling level, in percentage points).** Do not interpret. Do not say whether the
stage passed. Print the table.

### PART 3 — the range-fit before-picture

R102 channel 1 gives a fighter distance judgement. Today he can only ever throw
a technique whose `range_band` already contains the band he is standing in —
`FightMoves.live_set` filters on exactly that — so a technique thrown outside
its band **occurs zero times, by construction.**

Report, per ruleset, the distribution of **`FightMoves.scaled_distance`** (the
gap in the thrower's own arm lengths, `separation / arm_length_m`) at the moment
each impact is built: median, P10, P25, P75, P90, and the share of built impacts
in each of the three standing bands.

**Why:** J21 §1.1 (Hristovski 2006) says boxers spend time at **D ≈ 1.2**,
the jab-reach edge, because that is where the opponent's diversity is minimised.
We now compute D. **Nobody has ever looked at where our fighters actually
stand.** Report the number; do not compare it to Hristovski and do not judge it.

## Owned files

- `Godot/tools/measure_r102.gd` — NEW, yours alone.
- `research/Q44_THE_PUBLISHED_UNITS.md` — your deliverable, the tables.

**DO NOT EDIT** `FightRealtime.gd`, `FightMoves.gd`, `FightIntent.gd`,
`ImpactModel.gd`, anything in `Godot/tests/`, or `HANDOFF.md`. Claude is editing
the first two RIGHT NOW in a parallel session. If you touch them you will lose
the work, yours or his.

## Anchors — read these windows and nothing else

- `Godot/tools/measure_r101.gd` — read whole, it is ~270 lines. Your model.
- `Godot/scripts/FightRealtime.gd:1403-1600` — `_run_impact`. The contact ladder
  is at `:1473`, the defence roll at `:1578`. `state["significant_throws"]`,
  `state["impacts_built"]`, `state["named_throws"]` and
  `state["unnamed_throws"]` are the counters that already exist.
  **`FightRealtime.gd` is 2,376 lines — never open it whole.**
- `Godot/scripts/FightMoves.gd:211-235` — `arm_length_m`, `scaled_distance`,
  `band_for`.
- `research/G54_WHAT_IS_DEFENCE.md` — **sections 1, 2 and 7 only.**

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/measure_r102.gd
```

then run it:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_r102.gd
```

**NO SUITE RUN.** You are adding a tool, not a test.

## Report

`git add -- Godot/tools/measure_r102.gd research/Q44_THE_PUBLISHED_UNITS.md`,
commit, push `master`, then **one line** with
`python Tools/agent_comms.py send --from qwen --to claude --subject Q44-done`.
Put the four `Str. Def.` figures and the two sweep deltas in that line. **Do not
edit `HANDOFF.md`** — Claude writes your block.

## The trap specific to this task

**The measured-at SHA is part of the result.** Claude is changing the engine in
parallel, so a number without a commit hash beside it is worthless in two hours.
Run `git rev-parse HEAD` before you measure and print it at the top of your
output, exactly as Q40 did (`measured-at=69d80b641695`). If you rebase
mid-measurement, re-run — do not stitch two halves together.

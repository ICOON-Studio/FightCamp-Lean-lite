# TASK Q45 — QWEN — WHICH TECHNIQUES ACTUALLY GET SHOWN

Model: Qwen CLI, **medium** effort. Owner: qwen.

**Tier: A NEW FILE IN `Godot/tools/` ONLY. No `.gd` in `scripts/`, no test.**
Parse gate on your one new file, then run it. **DO NOT RUN THE SUITE.**

## Why this exists — an operator correction, and it is a denominator error

M19 concluded that with **272 catalogue nodes** and a purchase list of ~13–14
clips, the overwhelming majority of thrown techniques will have no animation
clip, and that this is correct rather than something you fix by buying more.

**The operator challenged that and was right.** The 272 is the WRONG
DENOMINATOR. R97 measured that the presenter drops **92.6% of impacts** — 896
built, 66 shown, per bout. **You never need a clip for a throw that is never
rendered.** The question is not "how many of 272 nodes have a clip", it is:

> **Of the throws that actually reach a SHOWN BEAT, what fraction have a clip —
> and which techniques would the next clip cover?**

That is a measurable quantity and nobody has measured it. This project has a
standing rule that a share is only meaningful against the right denominator, and
R101's finding 1 exists because that rule was broken once already.

## What to build

**`Godot/tools/measure_shown_techniques.gd`** — a new `extends SceneTree`
harness. Model it on `Godot/tools/measure_r102.gd` and
`Godot/tools/measure_r101.gd`; you are writing counters, not a framework.

**READ `measure_r101.gd:30-45` FIRST** — the trap that cost that harness its
first run: load `res://assets/data/combat_rulesets.json`, never a bare
`{"id": "boxing"}`.

Per ruleset (`boxing`, `mma`, `kickboxing`, `muay_thai`), 40 bouts:

### PART 1 — the two denominators, side by side

1. **THROWN**: every built impact, counted by `technique_id`. This is the
   denominator M19 used.
2. **SHOWN**: only the impacts that survive into a beat. Drive the fight through
   **`FightBeatAdapter`** (`begin` / `is_fight_over` / `advance_beat`) exactly as
   a screen does, and count `technique_id` on the impacts the beats actually
   carry. This is the denominator that decides a purchase list.

Report both counts and **both shares**, with the denominator named in the same
line as every percentage.

### PART 2 — the purchase curve, and it is the deliverable

Rank techniques by SHOWN count, descending. Then report the **cumulative
coverage curve**: with the top 1 technique clipped, what share of shown throws
is covered? Top 3? Top 5? Top 10? Top 14? Top 20? Top 30?

**That curve is the answer to "how many clips should we buy".** Print it per
ruleset and once for all four pooled.

Also report the **count of DISTINCT techniques that are ever shown at all**, per
ruleset. If a ruleset only ever shows 40 distinct techniques, the 272 was never
the relevant number and this task says so with a figure.

### PART 3 — the unnamed share

R101 left this open: **muay thai leaves 19.4% of impacts UNNAMED** (its clinch
and ground impacts fall back and carry no technique). Report the unnamed share
of SHOWN beats per ruleset. **An unnamed throw can never have a clip**, so it
belongs in the coverage arithmetic as its own row, not hidden in the tail.

## Owned files

- `Godot/tools/measure_shown_techniques.gd` — NEW, yours alone.
- `research/Q45_WHAT_GETS_SHOWN.md` — the tables and the curve.

**DO NOT EDIT** anything in `Godot/scripts/`, anything in `Godot/tests/`, or
`HANDOFF.md`.

## Anchors — read these and nothing else

- `Godot/tools/measure_r102.gd` — read whole, your model.
- `Godot/scripts/FightBeatAdapter.gd` — `begin`, `is_fight_over`,
  `advance_beat`, `state_view`. **This is the seam that does the dropping**; the
  92.6% is its doing, and driving the fight any other way measures the wrong
  thing.
- `Godot/scripts/FightRealtime.gd:1490-1560` — where `technique_id` and
  `technique_name` are stamped onto an impact, and where `unnamed_throws` is
  counted. **The file is 2,376 lines — never open it whole.**
- `research/R101_DIGEST.md` — findings 3, 4 and 5 only (muay thai's
  palette and its unnamed share).

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/measure_shown_techniques.gd
```

then run it. **NO SUITE RUN.**

## Report

Commit, push `master`, one line via
`python Tools/agent_comms.py send --from qwen --to claude --subject Q45-done`
carrying the cumulative curve at top-5 and top-14 for each ruleset. Do not edit
`HANDOFF.md`.

## The trap specific to this task

**Do not measure the drop yourself.** It is tempting to take every built impact
and apply a 92.6% filter, or to sample one impact per beat window. The drop is
`FightBeatAdapter`'s own rule over a 280-tick window and it is NOT uniform —
which technique survives is exactly what you are measuring. **Drive the adapter
and count what comes out of it.** A filter you write yourself would measure your
filter.

And print `git rev-parse HEAD` at the top of your output. R102 has just moved
every seeded fight; a number with no commit hash beside it is worthless.

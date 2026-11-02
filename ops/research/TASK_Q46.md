# TASK Q46 — QWEN — THE RECEIVER'S DEMAND, WHICH NOBODY HAS COUNTED

Model: Qwen CLI, **medium** effort. Owner: qwen.

**Tier: ONE NEW FILE IN `Godot/tools/` ONLY. No `.gd` in `scripts/`, no test.**
Parse gate your one new file, then run it. **DO NOT RUN THE SUITE.**

## Why this exists — Q45 measured one side of the exchange

Q45 (yours, landed `8a7c1aa`) answered the purchase question for the THROWER:
the engine reaches **21 distinct named techniques**, not M19's 272, and **14
clips cover 90.3% of all shown throws pooled**. That is the right answer to the
question it asked.

**It counted the man throwing. Nobody has counted the man being hit.**

R103 just landed the presenter seam, and its gate printed the number that makes
this a task: over three seeded boxing bouts, **148 action beats**, the receiver's
region reaction was asked for **143 times** — and we own **zero** reaction clips,
so it was refused 143 times. M19's whole no-clip answer is *a reaction on the
receiver*, and the receiver is the half of the purchase list that has never been
measured.

So:

> **Of the beats that reach a SHOWN beat, how often is each RECEIVER role asked
> for — and what would the next reaction clip cover?**

## What to build

**`Godot/tools/measure_receiver_demand.gd`** — a new `extends SceneTree`
harness. Model it on your own `Godot/tools/measure_shown_techniques.gd`; you are
writing counters, not a framework, and you already wrote the loop that drives
`FightBeatAdapter` the way a screen does.

**THE TRAP THAT COST `measure_r101.gd` ITS FIRST RUN, and you already cleared it
once in Q45: a ruleset is NOT `{"id": "boxing"}`.** Load
`res://assets/data/combat_rulesets.json` and pass the real dict. A bare id dict
has an EMPTY discipline map, which in R102 silently zeroed every defensive
outcome in a full fight and read like a finding. Reuse your Q45 loader.

Per ruleset (`boxing`, `mma`, `kickboxing`, `muay_thai`), 40 bouts, driving
**`FightBeatAdapter`** (`begin` / `is_fight_over` / `advance_beat`) exactly as a
screen does — **shown beats are the denominator, not built impacts.**

### PART 1 — the six receiver roles, counted

`FightStageDirector.role_for_react(region, contact)` is the authority and you
call it rather than reimplementing it. **Contact is checked FIRST and region
second, and that ordering is the G42 guarantee** — an unrecognised contact word
can never reach the region table. The roles it can return:

`react_head` · `react_body` · `react_leg` · `block` · `slip` · `idle`

plus `knockdown`, which the presenter substitutes for the react role when the
beat carries `knockdown`. Count all seven, per ruleset, as a count AND as a
share — **and name the denominator in the same line as every percentage.**

Also report the **contact-word distribution** (`clean`/`glancing`/`absorbed`/
`blocked`/`slipped`/`missed`) on shown beats, because that is what decides the
split between a reaction, a block and a slip. R102's finding was that muay thai
slips 11.1% and blocks 1.6% while boxing does the reverse; **confirm or refute
that on SHOWN beats**, which is a different denominator from the one R102 used
and may well disagree.

### PART 2 — the combined purchase curve, and it is the deliverable

Q45 ranked thrower techniques. Now pool BOTH sides into one ranked list of
**presentable clip slots** — each thrower technique that reaches a shown beat,
plus each receiver role — ordered by how many shown beats it would cover, and
print the cumulative curve at top 3 / 5 / 10 / 14 / 20 / 30.

**That single curve is the purchase list.** Q45's 14-clips-for-90.3% figure
covered throwers only; a beat needs BOTH bodies to read right, so the honest
curve is the pooled one and it is what the operator should be shown.

State explicitly **how many of the top 10 slots we already own.** We own exactly
three, and they are `jab`, `cross` and `hook_lead` (plus three mirrors of them)
— `Godot/scripts/FightClipBinding.gd` is the register, read it, do not guess.

### PART 3 — the one-clip question

If exactly ONE clip could be added, which slot covers the most shown beats?
Answer it with a number, per ruleset and pooled. R103's boxing fixture suggests
a head reaction; **do not assume that generalises to four rulesets** — muay thai
kicks legs and boxing cannot.

## Owned files

- `Godot/tools/measure_receiver_demand.gd` — NEW, yours alone.
- `research/Q46_THE_RECEIVERS_DEMAND.md` — the tables and the pooled curve.

**DO NOT EDIT** anything in `Godot/scripts/`, anything in `Godot/tests/`, or
`HANDOFF.md`.

## Anchors — read these and nothing else

- `Godot/tools/measure_shown_techniques.gd` — your own Q45 harness. Read whole.
- `Godot/scripts/FightStageDirector.gd:106-145` — `role_for_strike` and
  `role_for_react`. Call them; do not re-derive the mapping.
- `Godot/scripts/FightClipBinding.gd` — read whole, 165 lines. What we own.
- `Godot/scripts/FightBeatAdapter.gd` — `begin`, `is_fight_over`,
  `advance_beat`. **This is the seam that does the dropping.**
- `research/Q45_WHAT_GETS_SHOWN.md` — your own findings; the thrower half.

`Godot/scripts/FightRealtime.gd` is 2,376 lines and you should not need it.
`Godot/scripts/GameState.gd` is ~13,000 lines — **never open it whole**, and this
task does not touch it.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/measure_receiver_demand.gd
```

then run it headless. **NO SUITE RUN** — a new `tools/` harness cannot break a
test, and the suite costs twenty minutes.

## Report

Commit (explicit paths only, never `audio_exports/`), push `master`, one line via
`python Tools/agent_comms.py send --from qwen --to claude --subject Q46-done`
carrying the pooled curve at top-10 and the answer to PART 3. Do not edit
`HANDOFF.md`. Check `git status -s` before staging — another agent's WIP may be
pre-staged.

## The trap specific to this task

**A SHARE IS ONLY MEANINGFUL AGAINST THE RIGHT DENOMINATOR, and this task has
three different ones in play**: built impacts, shown beats, and *shown beats that
carry a reaction at all*. A `missed` blow returns `idle` — nobody reacts to a
punch that never arrived — so "react_head is 40%" means something completely
different against shown beats than against landed ones. **Pick shown beats as
the primary denominator, say so on every line, and where a second denominator is
genuinely more useful print BOTH rather than switching silently.** M19 broke this
rule once and the operator caught it.

Second: print `git rev-parse HEAD` at the top of your output. R103 has just
changed what the presenter does; a number with no commit beside it is worthless.

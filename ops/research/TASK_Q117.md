# TASK_Q117 — QWEN — WHAT ATTRIBUTES DOES A FIGHTER ACTUALLY HAVE, AND DOES ANYONE READ THEM?

**Agent:** Qwen · **Model:** qwen3-coder · **Effort:** medium · **Fast:** off
**Launch:** from worktree `FightCamp-Q81`:
`Set-Location <wt>; Get-Content <this file> -Raw | qwen.cmd --yolo -m qwen3-coder`
(PowerShell reports exit 1 on its yolo warning — read the `.out` file, never the rc.)
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

**Test tier — RESEARCH, no `.gd` edited: NO GATE AT ALL.** Not the parse gate, not a test.
`git status -s` before staging is the whole check. Your gate is your own check script.

---

## WHY THIS EXISTS

The operator has chosen the **fighter profile / attribute screen** as the next stage. That
screen's whole job is to show a fighter as a SHAPE — strengths, weaknesses, a character — and
three things have to be known before a single control is drawn. None of them are known today.

The operator also built a BJJ match simulator (`perchance.org/z1eu8lywkp`) whose attribute
vocabulary is **finer than ours**, and it is the reason this stage exists:

> Sweeps, Passing, Guard, Top Pressure, Scrambles, Sub Defense, Submissions,
> Back Attacks, Leg Locks, Takedowns, Flexibility, Composure, Heart, Technique

## THE THREE QUESTIONS

### 1. THE CENSUS — what attributes exist?

Every fighter attribute the game actually stores. Start from `Godot/scripts/AthleteStatModel.gd`
and follow what it names; `GameState.gd` is **~13,000 lines, NEVER open it whole** — find the
attribute block with `grep -n` and read `sed -n 'A,Bp'` windows only.

For each attribute report: its **exact key name**, where it is defined (`file:line`), its range
if one is enforced, and its default.

**NAME THE KEY EXACTLY.** This project has been burned three separate times by `"attributes"`
silently yielding an empty stat block where the real key was `"stats"`. A census that gets the
key name wrong is worse than no census.

### 2. THE DEAD-ATTRIBUTE CHECK — does the engine read them?

**An attribute nobody reads is decoration, and putting it on a screen is a lie to the player.**

For every attribute from step 1, grep the engine for reads of it — `FightRealtime`,
`FightIntent`, `FightMoves`, `FightFootwork`, `BalanceState`, `AthleteDevelopment`, and
anything else that turns up. Classify each one:

- **LIVE** — read during a fight or during training/progression. Name the `file:line`.
- **DECORATIVE** — stored, displayed maybe, read by nothing.
- **WRITE-ONLY** — set somewhere and never read anywhere.

Report the counts and the full table. **The decorative and write-only lists are the valuable
half of this task** — they are what the screen must not pretend are meaningful.

### 3. THE SATURATION CHECK — do our fighters have weaknesses?

**This is the one that decides whether the screen can work at all.** The operator found the bug
in their own BJJ simulator: stats saturate with rank. Blue belts were healthy (lowest 63–68),
brown crowded the ceiling, and a black belt came out with **six stats at 99**. A fighter with no
weakness makes every match meaningless — the same failure as testing identical fighters, and for
the same reason: the result then measures the fixture rather than the engine. **If our generated
fighters saturate the same way, a profile screen shows fourteen full bars and says nothing.**

So MEASURE OURS. Generate a population of fighters through whatever the game's own generation
path is (find it; do not hand-write stat blocks — a hand-written block measures your hand), and
for each attribute report across the population:

- p10 / p50 / p90 and min / max
- **how many fighters have NO attribute below 60** — the "no weakness" count
- **how many have more than two attributes above 90**
- the correlation between attribute value and whatever rank/experience field exists

**Name your population in the output**: how many fighters, generated how, at what rank spread,
with what seed. A measurement that does not name its population cannot be told from a fixture.

**Use at least 200 fighters** and say if the generator cannot produce that many.

## WHAT NOT TO DO

- **Do not propose a new attribute vocabulary.** That is the operator's call and Claude's to
  design. You are measuring what IS, and the gap against the BJJ list is a TABLE, not a
  recommendation.
- **Do not edit any `.gd`.** Not one.
- **Do not fix saturation if you find it.** Report it with numbers. A fix here without the
  screen designed around it is a change nobody asked for.

## OWNED FILES

- `research/Q117_THE_ATTRIBUTE_CENSUS.md` (new, the digest)
- `research/Q117_census.py` (new)
- `research/Q117_check.py` (new, the gate)
- `research/Q117_population.json` (new, the measured numbers)

## THE GATE

`python research/Q117_check.py` **must exit 0**, and it must RECOMPUTE rather than read
`Q117_population.json` and agree with it. A gate that learns its answer from the thing it is
gating cannot fail. It must independently:

- re-derive the attribute key list from the source and assert the count against a **literal
  pinned in the check script**;
- assert every attribute in the digest's LIVE list has a real `file:line` read that still
  exists;
- re-generate the population and assert the "no weakness" count against a pinned literal;
- assert a degenerate case: a population of size 0 reports "no fighters" rather than dividing
  by zero.

## THE ONE TRAP

**A grep for an attribute name will match its own definition and its own display string.** A
key that appears only in `AthleteStatModel.gd` and in a label somewhere is DECORATIVE, and a
naive grep will call it LIVE because it found three hits. **Exclude the defining file and any
pure-UI file from the read count, and say in the digest which files you excluded.** Getting
this wrong inverts the whole answer.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push, then one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic q117-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. Unstage `AgentComms/messages` before any commit that is not the mail.

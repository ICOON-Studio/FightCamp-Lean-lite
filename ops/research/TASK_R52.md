# TASK R52 — THE YEARS, SOURCED: J10 REPLACES THE AUTHORED CURVE (Claude)

**Status: COMPLETE (2026-09-07).** See `research/R52_DIGEST.md`. First task of THE YEARS ARE SHOWN.
Do this BEFORE R53, so the screens quote sourced windows.

Model: Opus, effort high, Fast off. One session.

## Why this exists

`Aging.gd` shipped on 2026-09-07 with every constant AUTHORED and graded
UNKNOWN in its own header, because J10 had not landed. **J10 landed the same
day** (`research/J10_THE_YEARS.md`, 503 lines). Its own instruction is
to replace those numbers wholesale rather than nudge them, and to keep every
row's grade visible so the game never quotes a guess as a fact.

**Operator decision, 2026-09-07: SPLIT BY SEX, with the argument defaulted.**
J10's D6 is *do not average the sexes* — women are OLDER than men in amateur
boxing (26.3 vs 24.8) and YOUNGER in judo (24.9 vs 25.4) and taekwondo (23.8
vs 25.1). One window per discipline would knowingly get those wrong.

## Owned files

- `Godot/scripts/Aging.gd` (213 lines — read it whole, it is small)
- `Godot/tests/aging_test.gd` (~330 lines — read it whole)

**Do not touch:** `WorldPopulation.gd`, `GameState.gd` (R51b's pass is
correct and does not change), any `*Panel.gd`.

**`Aging.gd` now has TWO live callers.** C34 landed 2026-09-07 (`b44347d`):
`WorldPopulation.advance_world()` applies the same birthday and year step to
the whole world and retires world athletes at pressure 70. The defaulted
`sex` argument is what keeps that file compiling untouched. Threading the
world's own `athlete_sex()` through those calls is **C35's second item, not
yours** - do not open `WorldPopulation.gd`.

## The contract after this task

```gdscript
static func peak_window(discipline: String, sex := "") -> Dictionary   # {"from", "to", "grade"}
static func band_for(age: int, discipline: String, sex := "") -> String
static func grade_for(discipline: String, sex := "") -> String         # NEW
static func year_step(athlete: Dictionary, new_age: int) -> Dictionary # unchanged signature, reads sex off the athlete
static func retirement_pressure(athlete: Dictionary, career_week: int) -> int  # unchanged signature
static func birth_week_for(athlete_id: String) -> int                  # unchanged
static func has_birthday(athlete_id: String, career_week: int) -> bool # unchanged
```

**`sex` MUST default**, so every existing call site in `GameState.gd` and in
C34's landed `WorldPopulation.gd` keeps compiling untouched. An empty
`sex` means "the window this discipline is known for", which is the male or
mixed row. Use `WorldPopulation.athlete_sex()`'s own vocabulary for the
values; do not invent a second spelling.

## What to lift from J10 (§1.1, §3 Q1)

- Windows are **inclusive integer ages** and **6–8 years wide**. J10: a
  2-year spike is not supported by any source.
- **Split pro from amateur** (D2). The game books professionals — carry the
  PRO window where one exists and keep the Olympic/amateur figure in a
  comment, never as the live number.
- **`brazilian_jiu_jitsu` is currently wrong**: shipped 27–35, J10 has male
  IBJJF adult black belt at **23–29** (medalist mean 26.9, first title ~23),
  graded UNVERIFIED_SECONDARY. Female: **UNKNOWN**.
- Every row carries a grade: DIRECT / INHERITED / UNVERIFIED_SECONDARY /
  UNKNOWN, and `grade_for()` returns it so a screen can be honest later.
- **A row J10 could not source stays UNKNOWN** and falls back to the shared
  window — muay thai, kickboxing, sambo, karate combat, women's pro boxing,
  women's MMA as its own curve. Do NOT quietly fill them.
- `BAND_STEPS` stays AUTHORED and marked UNKNOWN. J10 §2.1: there is no
  source anywhere for yearly integer stat deltas in any combat sport. Only
  the DIRECTION is defensible, which is what the current table already
  encodes. **Do not "improve" these numbers and do not label them sourced.**
- `retirement_pressure` may be re-shaped to J10's flag sketch (§Q4: age≥35,
  age≥38, KO/TKO streak, ARP/NSAC inactivity, medical hold, licence denied)
  but **the weights stay UNKNOWN and the function stays 0..100**. J10 states
  plainly that no sourced weights exist and that money / family / title-lost
  / one-bad-night have no rates and must not be scored.

## Second item: KILL THE SECOND AGE TABLE (operator decision 2026-09-07)

R51 established that there is ONE age curve and that a wrong number should be
wrong in exactly one place. **That rule is already broken, and it was broken
before R51 shipped.**

`FightCamp.injury_chance()` (`Godot/scripts/FightCamp.gd:152`) carries its own
age table:

```gdscript
var age := int(athlete.get("age", 25))
if age >= 33:
    chance *= float(rules.get("age_33_mult", 1.4))
elif age >= 30:
    chance *= float(rules.get("age_30_mult", 1.2))
```

with `age_30_mult: 1.2` and `age_33_mult: 1.4` in
`assets/data/fight_camp.json:210-211`. Those thresholds know nothing about
the fighter's discipline or sex: a 30-year-old BJJ competitor is INSIDE their
peak window and a 30-year-old taekwondo fighter is two years past it, and
this treats them identically.

Fix it here, because you are already in the one file that should own it:

- Add a fragility multiplier to `Aging.gd` keyed to the BAND and the years
  past the window — not to a bare age — and call it from
  `FightCamp.injury_chance()`.
- **Keep the shape of the current numbers.** A fighter at the same distance
  past their window should land near the 1.2 / 1.4 the camp already applies;
  this is a consolidation, not a rebalance. Say in the digest which
  disciplines actually move and by how much.
- The multiplier is AUTHORED and UNKNOWN like the rest. J10 sourced no
  age-by-injury rate; §2 #10 says the post-35 KO spike is real in the record
  but its mechanism is not isolated.
- `age_30_mult` / `age_33_mult` leave `fight_camp.json`, or stay as the
  fallback the module uses when `Aging.gd` cannot answer. Your call — say
  which in the digest.

**Extra owned files for this item:** `Godot/scripts/FightCamp.gd`,
`Godot/assets/data/fight_camp.json`, `Godot/tests/fight_camp_test.gd`. This
is a behaviour change on camp injury rolls: run the camp tests, and expect to
retune a fixture rather than assuming the test is wrong.

**This is the ONLY second-table fix in scope.** Recovery and the contract
price are R54's, and `BodyReadiness` and `Retention` are not yours here.

## Settled

- The file header keeps its "every number is authored" warning but is
  rewritten: it now says which rows are evidence and which are still a
  shape. A reader must be able to tell them apart without opening J10.
- **`AGING_RETIRE_PRESSURE_LINE` (62) lives in `GameState.gd` and is R51b's,
  not this task's.** If a re-shaped pressure changes its meaning, retune the
  line and its test in the same pass and say so in the digest.
- No screen, no new token, no new caller. This task changes numbers and one
  argument, nothing else.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/Aging.gd Godot/scripts/FightCamp.gd Godot/tests/aging_test.gd
```

## Tests

```
--script tests/aging_test.gd
```

Then `fight_camp_test.gd` (the second item changes it),
`world_generations_test.gd` (C34's, and now a real dependent) and
`fighter_requests_test.gd`. Then the full suite ONCE in the background.

## Done

Commit and push `master`, write `research/R52_DIGEST.md` (short),
convert this block in `HANDOFF.md` to COMPLETE, regenerate `TASKS.md`, and
**tell Codex the same day** with `agent_comms.py send`: the argument is
defaulted, C34 does not have to change, but passing the athlete's sex
through will make the world's windows right.

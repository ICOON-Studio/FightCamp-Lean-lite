# TASK R54 — THE YEARS COST SOMETHING: THE PRICE AND THE BATTERY (Claude)

**Status: COMPLETE (2026-09-07). Digest: `research/R54_DIGEST.md`.**
Re-scoped 2026-09-07 after J12, U2 and the operator's per-body-part decision. Runs after R52 (the one curve) and R53 (the
screens). Its blockers have all landed.

Model: Opus, effort high, Fast off. One session.

## READ THIS FIRST: the scope changed, and one half of it was cancelled

The first draft of this task asked for `Aging.recovery_scale()` — a whole-body
age multiplier on healing. **That is cancelled.** The operator's standing
decision of 2026-09-07 (HANDOFF, "Recovery and healing get a real per-body-part
system") rules that healing will be modelled per BODY REGION, realistically, in
a future stage with its own research pass, and that R54 must therefore:

> ship the DIRECT commission evidence (extra clearance at the age and mileage
> thresholds, never longer hold days — J12 D3/D9) and the price half, and leave
> the healing clocks alone.

So: **do not touch `_apply_recovery` (`BodyReadiness.gd:372`),
`forecast_weeks_to_training` (`:341`), or `body_readiness_rules.json`'s
`recovery` block.** A whole-body multiplier would be the wrong shape twice over
— unsourced (J12 D1) and about to be replaced by the per-region system.

## Why the two halves that remain exist (verified 2026-09-07)

- **`Retention.market_salary()` has no age term** (`Retention.gd:56`):
  `MARKET_BASE + rating * MARKET_PER_RATING + fame / MARKET_FAME_DIVISOR`. A
  41-year-old and a 23-year-old with the same rating cost the same and are
  worth the same to a rival gym. The market has no idea one has three years
  left and the other has fifteen.
- **Nothing in the game knows a commission would demand extra tests.** J12
  found real, DIRECT rulebook triggers and the game encodes none of them.

## The evidence, quoted, so it is not re-derived

**J12 D3 — extra clearance, not a longer hold.** "Encode ARP/NSAC/NYSAC/
Colorado *clearance batteries* as flags at 35 / 38 / 40 / 45. Do **not**
lengthen `medical_hold_until_week` by age. Rules add tests. They do not add
days to the KO/TKO ladder."

**J12 D5 — years and mileage are both real and not interchangeable.** "NSAC
treats 38, 425 rounds, and 36 months inactive as *separate* comprehensive-
contestant triggers."

**J12 D9** — concussion hold days are NOT age-scaled in any commission
rulebook. **J12 D1** — weeks-to-heal by age is UNKNOWN as a rate.

**J10 §2 #16** rules the PRICE unsourceable: no sport-wide wage tables, no
purse-by-age. The market age factor is AUTHORED and graded UNKNOWN, in the
header, in J1's vocabulary. Do not dress it up.

## U2 governs how both of these are allowed to READ (Cursor, landed 11c1470)

`research/U2_WHAT_THE_YEARS_COST.md`. The rulings that bind you:

- **Q3/Q4: the price prints as ORDINARY MONEY.** The dollar figure the player
  acts on, in normal money ink, on every surface that already shows pay. **No
  age `why`, anywhere** — not on `squad_row`, not on the contract pane, not in
  negotiation. Not "veteran rate", not "years", not "past peak value". The
  grade lives in data for builders and audits only.
- **AUTHORED is a fifth kind** in K25's honest-number table: it prints the
  operational figure with **no player-facing mark** and no candour line. No
  asterisk, no "estimate" chip, no MUTED cast on a purse — U2 rejects all three
  by name.
- **Q5, where age cost must NOT appear:** news and attention headlines; the
  fight card, weigh-in and bout sheet; the FORMER/OFFICE list; wear chrome; and
  **medical hold / suspension copy stays age-blind** (J12: holds are not
  lengthened by age — do not imply that they are).

The battery flag is an OPERATIONAL fact — a test the commission requires before
this fighter is licensed for this bout — and it is worded that way. It is not a
hold, it blocks nothing, and no copy on it names age.

## Owned files

- `Godot/scripts/Aging.gd` — the two new statics below. **The numbers live on
  the one curve; consumers never author them.** 398 lines, read it whole once.
- `Godot/scripts/Retention.gd` — `market_salary` (`:56`). 149 lines, read whole.
- `Godot/scripts/GameState.gd` — **13,279 lines, never open it whole.**
  `get_fighter_flags` only, at `:11335`.
- `Godot/scripts/ProfileRevampPanel.gd` — **2,592 lines, never open it whole.**
  ONE case in `_alerts()` (`:233`). See the trap below.
- `Godot/scripts/UIKit.gd` — `FLAG_LABELS` only (one entry; it is a const dict,
  not a factory and not a token).
- Tests: `Godot/tests/retention_test.gd`, `aging_test.gd`,
  `profile_revamp_test.gd`.

**Do not touch:** `BodyReadiness.gd`, `body_readiness_rules.json`,
`FightCamp.gd` (R52 already did it), `WorldPopulation.gd`, `OfficeHubPanel.gd`
(Codex owns it on C37 this same cycle).

## The two new curve functions

```gdscript
## 1.0 = today's price. AUTHORED, UNKNOWN (J10 §2 #16).
static func market_age_scale(athlete: Dictionary) -> float
## J12 D3/D5's DIRECT triggers, as flags. Never a hold, never a rate.
static func commission_battery(athlete: Dictionary, career_week: int) -> Dictionary
```

The price scale is keyed to the BAND and the distance from the peak window
rather than to a bare age threshold, like everything else in that file. The
battery is the **exception and must stay one**: its whole point is that the
commissions publish literal ages. Quote 35 / 38 / 40 / 45 as the rulebook ages
they are, name the commission that publishes each in the comment, and grade the
TRIGGER `DIRECT` while any weight on it stays authored — the pattern
`retirement_pressure` already uses for NSAC's 38.

`commission_battery` returns at least `{"required": bool, "triggers": Array,
"grade": String}`, where each trigger names itself (`"age_38"`,
`"inactive_36_months"`) and carries the commission that publishes it.

## THE ROUNDS TRIGGER IS NOT YOURS — it is G12's seam

NSAC's third trigger is **425 rounds**, and nothing in this codebase computes a
fighter's career rounds. That number is being built as a pure module this same
cycle: **G12 (Grok), `Godot/scripts/Mileage.gd`**. Do NOT author a second
mileage figure here — one number in one place is the entire point of
`Aging.gd`.

Ship the AGE triggers (35/38/40/45) and the INACTIVITY trigger (36 months —
`last_bout_week` is already on the athlete and `Aging.PRESSURE_LONG_IDLE_WEEKS`
is already exactly 156). Leave a named seam for the rounds trigger and say in
the digest that it turns on when G12 lands. If G12 has already landed when you
start, consume `Mileage.summarize()` and turn it on in the same session.

## THE TRAP: an unknown flag id is silently dropped

`ProfileRevampPanel._alerts()` (`:233`) is a `match` over seven flag ids **with
no default branch**. A new flag out of `get_fighter_flags()` that has no case
here does not degrade to a smaller alert — it vanishes. The flag will look
correct in a GameState test and show nothing on the screen.
`UIKit.FLAG_LABELS` is the same shape for the GYM hub's chip column. Add the
case AND the label, and assert in `profile_revamp_test.gd` that a fighter over
a battery trigger actually gets a visible alert.

## Settled

- **The price falls with the years left, and it never goes negative.** Floor it.
  A 40-year-old former champion is cheaper than they were, not free.
  `market_salary` feeds the raise ask, the poach offer and the loyalty score —
  check all three still behave.
- **Fame resists age.** A veteran with a real name is not a bargain because of
  the calendar; the fame term should blunt the age discount rather than be
  swamped by it. That is a design position, not a sourced one — say so.
- **The battery is a test, never a block.** It must not set a medical hold, must
  not fail a competition clearance, and must not add a day to anything.
- **No fight outcome may change by accident.** These touch money and a flag, not
  the ring: no RNG stream may shift.
- Old saves need no migration: every new factor is derived, nothing is written
  to the athlete.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/Aging.gd Godot/scripts/Retention.gd Godot/scripts/GameState.gd Godot/scripts/ProfileRevampPanel.gd Godot/scripts/UIKit.gd
```

## Tests

```
--script tests/retention_test.gd
--script tests/aging_test.gd
--script tests/profile_revamp_test.gd
```

Then `fighter_requests_test.gd`, the GYM hub test that draws the flag column,
and `body_readiness_test.gd` — that last one proving the healing clocks did NOT
move. Then the full suite ONCE in the background before the commit.

## Done

Commit and push `master`, write `research/R54_DIGEST.md` (short), convert
this block in `HANDOFF.md` to COMPLETE, regenerate `TASKS.md`. The digest must
state, in one line each: how much less a fighter five years past their window
costs, which commission ages are encoded, and that the healing clocks were
deliberately left alone and why.

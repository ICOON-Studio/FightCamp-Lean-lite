# R48 — THE HOLD: A BODY THAT CANNOT BE BOOKED (Claude, 2026-09-07)

Builds Maria **M6** (drawn 2026-09-06) — the last unbuilt art pack. Screen
work plus four pure accessors; no `GameState.gd`, no `UIKit.gd`, no `.tscn`,
no `assets/data/` edit.

## What changed

**The hold and the injury are two facts again.** `ProfileRevampPanel` collapsed
them in four places — the hero chip, the identity strip, the tab badge and the
BODY LAB banner all ran `hold_week > week or status == "injured"`. A fighter
under a hold read INJURED; a fighter the cage refused read FIT. `_read()` now
takes `held`, `hold_until`, `hold_weeks_left`, `hold_reason`, `injured` and
`clearance_state` once, apart, and every surface spends that.

**The badge family (M6's primary deliverable).** One pill, three severities,
drawn from tokens: **HELD** a solid `BAD` plate, **NOT CLEARED** an `AMBER`
outline, **CLEARED** a `GOOD` outline. It is in the hero, in the collapsed
identity strip (where the roster reads it at 30px) and at the head of BODY LAB.
`INJURED` is a separate quiet chip beside it and is never folded in. **`GO` is
not borrowed for cleared** — `GO` is CONTINUE (M5).

**The regions band where the engine bands.** The lab sheet chipped HURT below
30 and SORE below 60; the engine bands at **80 / 60**, so a region at 62 was
chipped SOUND while it was blocking training. Every cell now asks
`BodyReadiness.readiness_band()` and carries the **cage's own tick** on the bar
plus a `CAGE nn` caption — M6's design case, `head_neck` 84, is green to train,
short of the cage's 90, and now says so.

**The refusal stack is ordered and typed.** One format string with
`region` / `value` / `required` was applied to all five refusals, so
`medical_hold_active`, `fatigue_above_competition_limit` and `athlete_injured`
printed `·  0, NEEDS 0`. M6's order now holds — hold → cage regions → fatigue →
training regions → status — and each row prints its own numbers. A body nothing
refuses says so in `DIM` instead of showing an empty column.

**The countdown is `BAD` while it counts and `LINK` the week it lifts.** It was
`AMBER` throughout, which M6 reserves for recoverable gaps. No gold.

**Honest empties.** A hold with no recorded reason prints an em-dash. The
screen invents no diagnosis, and there is still no competition forecast —
`forecast_weeks_to_training()` is the only one the engine has.

## Engine

`BodyReadiness.gd` gains four pure static accessors — `training_threshold()`,
`amber_threshold()`, `competition_threshold(region)`,
`competition_fatigue_max()` — so the panel neither re-parses
`body_readiness_rules.json` nor hardcodes 90 / 85 / 80. No behaviour change.

## Token ruling, settled here

M6 names a **CONDITION** token (`#3DB8D4`) that does not exist. M6 offers
`LINK` as its own alternative and `LINK` is what this uses: **`UITokens.gd` is
not edited** (R47's precedent — add what is needed, then refuse). `GOOD` /
`AMBER` / `BAD` stay the medical family and are never mapped onto CHAMPION /
INTERIM / VACANT.

## Not done, deliberately

- **The roster glance (board `m6_04`)** is `ManagementOverview`, a different
  surface. Left for whoever builds that screen; the badge is already the one
  instrument it needs.
- No diagnosis, injury name, anatomy chart, doctor or clinic (J3 D6).

## Verification

Parse gate 3/3. `profile_revamp_test` **75 checks, 0 failures** (was 62 — the
M6 states are installed the way the engine writes them, asserted, then cleared).
`body_readiness_test` and `body_readiness_integration_test` green. Full suite
148/148 (C32's corner test is the 148th).

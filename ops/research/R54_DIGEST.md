# R54 DIGEST — THE PRICE AND THE BATTERY

**Claude, 2026-09-07.** Ships the two halves that survived the re-scope: the
market's age factor and J12's DIRECT commission clearance batteries. The
recovery half stayed cancelled.

## What landed

- **`Aging.market_age_scale(athlete)`** — 1.0 before and inside the window,
  falling 6% per year past it and flooring at 0.55. AUTHORED, UNKNOWN, and it
  will stay that way (J10 §2 #16: no sport publishes wage-by-age). Keyed to
  the distance past the athlete's OWN window, so two 30-year-olds in different
  sports are not priced alike.
- **`Retention.market_salary`** now scales the base and the rating by that
  factor and adds the fame draw WHOLE. **A rating-50 fighter five years past
  their window costs $945 a week against $1,350 inside it — 30% less.** With
  400 fame that gap narrows to 28%: fame resists the calendar. Floors at $50 —
  a 40-year-old former champion is cheaper than they were, not free. The raise
  ask, the poach offer and the loyalty pay ratio all follow it down, tested.
- **`Aging.commission_battery(athlete, career_week, fight_rows)`** — the ages
  the commissions publish, as flags: **35 (ARP older fighter, cardiac screen),
  38 (NSAC Comprehensive Contestant), 40 (NYSAC high-risk; ARP neuro imaging),
  45 (Colorado comeback tests)**, plus NSAC's two independent non-age triggers,
  36 months idle and **425 career rounds**. G12 landed first, so the rounds
  trigger is ON and reads `Mileage.summarize()` — the count is never re-made
  here. Triggers grade DIRECT; no weight hangs on them.
- **Surfaces.** One new flag id `commission_battery` out of
  `GameState.get_fighter_flags`, level `info`, last in the list. The
  `ProfileRevampPanel._alerts()` case AND the `UIKit.FLAG_LABELS` entry were
  added together — that `match` has no default branch, so a flag with no case
  vanishes instead of degrading. The copy reads "EXTRA CLEARANCE REQUIRED ·
  NSAC, NYSAC": the commission and the panel, never the age (U2 Q5).

## The healing clocks were deliberately left alone

`BodyReadiness._apply_recovery`, `forecast_weeks_to_training` and the
`recovery` block of `body_readiness_rules.json` are untouched, and
`body_readiness_test.gd` passes unchanged. Two reasons, both standing: J12 D1
grades weeks-to-heal-by-age UNKNOWN as a rate and J12 D9 finds no commission
that lengthens a concussion hold by age; and the operator's 2026-09-07 decision
puts real per-body-region healing in its own future stage. A whole-body age
multiplier would have been unsourced and about to be replaced.

## Gates

Parse gate 8/8. Focused: `aging_test` 118 checks 0 failures, `retention_test`,
`profile_revamp_test`, `fighter_requests_test`, `gym_hub_test`,
`gym_hub_panel_test` and `body_readiness_test` all 0 failures. Full suite green
before the commit. No RNG stream moved: this touches money and one flag.
Old saves need no migration — every new figure is derived, nothing is written
to the athlete.

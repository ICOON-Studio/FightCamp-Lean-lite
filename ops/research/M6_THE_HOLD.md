# M6 — THE HOLD: A BODY THAT CANNOT BE BOOKED

Maria Art Director · 2026-09-06 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Dresses the medical hold and body-clearance state that already lives in
`BodyReadiness` — the most consequential thing that happens to a fighter
**between bouts**. Extends Cage Desk / M4–M5 chrome. Gym desk, not fight-night.

## Call: a state a body is in — not an error

A hold currently reads as a grey error string. It is a **time gate**
(`medical_hold_until_week` / `weeks_remaining`) that region recovery cannot
waive. Art dresses that state, the train-vs-cage gap, and the typed refusals.

## Engine-true (invent nothing)

**Six regions:** `head_neck`, `torso_core`, `left_arm`, `right_arm`, `left_leg`,
`right_leg`.

**Training bands** (`readiness_band`): green `>= 80`, amber `>= 60`, red below.

**Two clearances that disagree on purpose:**

| Gate | Rule |
| --- | --- |
| `evaluate_training_clearance()` | Every region green (`>= 80`). All-or-nothing. Rest/recovery stay available while blocked. |
| `evaluate_competition_clearance()` | Per region: `head_neck` 90, `torso_core` 85, limbs 80. Fatigue `<= 85`. Plus the hold. |

**Design object:** `head_neck` 84 = green to train, under cage 90. Board `m6_02`
proves this case.

**Five typed refusals:**

1. `medical_hold_active` — `{until_week, weeks_remaining, reason}`
2. `region_below_competition_threshold` — `{region, value, required}`
3. `fatigue_above_competition_limit` — `{value, required_max}`
4. `region_below_training_threshold` — `{region, value, required}`
5. `athlete_injured` — status flag, no numbers

**Hold source:** `fight_profiles.*.medical_hold_weeks` (decision 1 / stoppage 4+;
stoppage_loss profile carries 8). Surface = **until week N / N weeks remaining**.
No calendar of exam dates, no "cleared by" step, no doctor names.

**Forecast:** `forecast_weeks_to_training()` only. **No competition forecast.**

## Token map (Cage Desk boards ↔ UITokens)

| Role | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Ground | `#0B1220` | `GROUND` / `TRACK` | Cage desk |
| Panel | `#162033` | `PANEL` / `PANEL_LO` | Cards |
| Panel edge | `#24324A` | `LINE` / `LINE_SOFT` | 1–2px |
| Text | `#E8EEF8` | `TEXT` | Primary |
| Muted | `#8B97AD` | `MUTED` / `TEXT_2` | Labels |
| Dim | `#5C6A82` | `DIM` | Empties why-copy |
| **Hold / HELD** | `#E24B4B` | **`BAD`** | Time gate — doctor-stop second home |
| **Not cleared** | `#E89A3C` | **`AMBER`** | Recoverable competition gap, no hold |
| **Cleared / green band** | `#4FC46A` | **`GOOD`** | Semantic readiness — **not GO** |
| Cage tick / lift warmth | `#3DB8D4` | `LINK` / CONDITION | Dual-threshold mark + week-zero warmth |
| CONTINUE | `#2ECC71` | `GO` | **Unused in this pack** |
| Verdict gold | `#E8B84A` | `GOLD` | **Unused — spent on M5 verdict word** |

### Hold = BAD (not amber) — written reason

M5 reserved `BAD` for the doctor stop. A medical hold is that stop's natural
**second home**: it is a hard booking refuse that green regions cannot waive.
Amber stays for recoverable gaps (train-only / not-cleared / band amber).
**Do not use both colours on the hold badge.** Hold chrome = BAD only.

### Cleared ≠ GO

`GO` is CONTINUE only (M5). Cleared-to-fight uses semantic `GOOD`. Borrowing
`GO` green would silently teach the player that clearance is a button.

### Hold-lift warmth = CONDITION / LINK — no gold

Gold ×1 is spent on the M5 verdict word; this pack takes none. Week-zero
warmth is **CONDITION** (`#3DB8D4`): Cage Desk already uses cool for instrument
"available / in range" cues. A hold lifting is calendar availability, not a
victory and not a CONTINUE press. Warmth appears only when
`weeks_remaining → 0`; countdown chrome stays BAD until then.

## Badge family (primary deliverable)

One pill shape, three severities, readable at roster-row ~28px:

| Badge | Fill | Meaning |
| --- | --- | --- |
| **HELD** | Solid BAD | `medical_hold_active` |
| **NOT CLEARED** | Outline AMBER | Competition refuse, no hold |
| **CLEARED** | Outline GOOD | `evaluate_competition_clearance` clear |

Injured status stays a **separate** quiet chip — do not collapse with HELD
(`ProfileRevampPanel:614` currently collapses; badge family is what separates).

## Refusal stack order

When several fire: **hold first** → competition region misses (one row each) →
fatigue → (train surfaces only) training misses → injured as quiet status.
Each row keeps its numbers. Not a wall of grey.

## Honest empties

| Case | Visual |
| --- | --- |
| No fight history, full green | CLEARED + DIM "no bouts yet" — never BAD for absence |
| Legacy `medical_hold_reason = ""` | HELD + countdown; reason slot = DIM em-dash / omit — never invent diagnosis |

Empty ≠ error (same rule as M5 R1-KO empty scorecard).

## What this does NOT do

- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No runtime bitmap import of these boards.
- No diagnoses, injury names, anatomy charts, doctor characters, named
  practitioners.
- No competition forecast.
- No gold. No GO borrow for cleared.
- No fight-night / scorecard / judge surface.

## Boards → `DesignLibrary/screens/medical/`

| File | Content |
| --- | --- |
| `m6_01_hold_badge_family.png` | Held / Not cleared / Cleared · roster-row small |
| `m6_02_body_dual_threshold.png` | Six regions · dual ticks · head_neck 84 proof |
| `m6_03_refusal_stack.png` | Five reasons + stacked order |
| `m6_04_roster_glance.png` | 10 athletes: 3 held · 2 train-only · 5 ready |
| `m6_05_hold_lifts.png` | Countdown + week-zero CONDITION warmth |
| `m6_06_empties_unknowns.png` | Green no history · hold empty reason |
| `m6_07_anti_pattern.png` | Rejected medical-chart look labeled REJECTED |
| `m6_08_composed.png` | Optional gym-desk compose |

All boards 1920×1080. Code-drawable from UITokens + BodyReadiness reads.

## Engine anchors

- `BodyReadiness.gd:34-43` — hold fields + migration
- `BodyReadiness.gd:70-77` — `readiness_band()`
- `BodyReadiness.gd:99-117` — training clearance
- `BodyReadiness.gd:118-145` — competition clearance + five refusals
- `BodyReadiness.gd:316` — `forecast_weeks_to_training()`
- `body_readiness_rules.json` — regions, thresholds, `medical_hold_weeks`
- `ManagementOverview.gd` / `ProfileRevampPanel.gd` — current grey-string surfaces
- `M5_SCORECARD_THREE_JUDGES.md` — gold / GO / BAD continuity
- J3 D6 — clearance, not day-count clinic picture

## Staging

- `_maria_delivery/M6_THE_HOLD.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M6.md`
- `research/M6_THE_HOLD.md`
- `research/CLAUDE_LAND_NOTE_M6.md`

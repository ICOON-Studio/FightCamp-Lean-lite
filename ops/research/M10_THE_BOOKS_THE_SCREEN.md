# M10 — THE BOOKS, THE SCREEN

Maria Art Director · 2026-09-07 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Composes the money **screen** M8's grammar never drew: one gym-office desk at
**1920×1080**, **two wallets that are never totaled**, dressed from
`get_gym_ledger_read()` and `get_athlete_purse_read()`. Depends on M8 token
map, C27 labelled lines, C28 per-bout purse, R44 membership inflow.

## Call

M8 gave the chips. This pack gives the desk. The gym's week and the fighter's
purse sit side by side. They meet only at the desk. Do not draw a combined
total.

## M8 tokens held — do not reopen

| Role | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Evidenced | `#E8EEF8` | **`TEXT`** | Cited / standing engine figure |
| Invented | `#7FB6EE` | **`LINK`** | AUTHORED chip · membership + sponsorship |
| Absent | `#8B97AD` | **`MUTED`** | Present $0 / empty by refusal |
| Falling balance / runway | `#5C6A82` | **`DIM`** | Quiet drama — not alarm |
| Shell tint | `#2F6FB0` | **`GYM_DEFAULT`** | Header / gym panel edge |
| Candour accent | `#7FB6EE` | **`LINK`** | Same as invented |

**SELECT does not exist** in `UITokens.gd` (verified this pack). Do not cite
`SELECT` as a verified constant. Shell chrome uses **GYM_DEFAULT**; candour
uses **LINK**.

GOLD (M5 verdict), SODIUM (M7 champion), BAD (M6 hold), AMBER (recoverable
warn), GO/GOOD — **unused on money**.

## New token call: falling runway = DIM

`runway_weeks` is a countdown to a gym that cannot pay itself. `-1` means it
is **not falling**.

**Decision: falling runway wears DIM.** Written reason:

1. **BAD is M6 medical hold.** A falling balance is not an injury. Reusing BAD
   collapses two truths (M8 already refused BAD for negative cash).
2. **AMBER is a recoverable warning.** The brief asks for drama **without
   being a warning**. AMBER on "6 weeks" would teach the player to treat cash
   as an alert. Refused.
3. **DIM is the M8 falling-balance contract** (TEXT → MUTED → DIM). Compose
   with it; do not re-litigate.
4. Drama = the number getting quieter and the countdown getting shorter — not
   a siren, not a bankruptcy plate, not a loan offer.
5. `-1` is a separate quiet state (MUTED/TEXT): not a timer, not "∞", not GO.

Careful AMBER was considered and refused in board `m10_02_runway.png`.

## What the screen shows

### Gym week (`get_gym_ledger_read`)

- **Cash now** — evidenced (named context: starter float **$25,000**).
- **Inflows** — each with source chip:
  - **Membership** — `membership_count × membership_weekly_rate`, both
    authored → **INVENTED / AUTHORED / LINK**. Count is **frozen** (J8 N2/N3).
    No trend, no growth chart, no sparkline.
  - **Sponsorship** — tiers **250 / 400 / 650 / 1000** → AUTHORED / LINK.
- **Outflows** — payroll, upkeep as evidenced standing rates (no invented $).
- **`net_weekly`** — centre of the gym book. Negative reads **DIM**.

### Runway

- `runway_weeks` countdown when falling → **DIM**.
- `-1` → not falling → MUTED/TEXT.
- 26-week context named only: **$25,000 → -$5,342**. No projection curve.

### Fighter purse (`get_athlete_purse_read` · C28)

- Per-bout rows, **newest first**.
- Gross · weight fine (if any) · **logistics** · manager share · landed.
- **Logistics copy (J6 A1):** fighter's own uncovered travel and accommodation
  — not a commission, tax, or gym cut.
- Manager share that was never collectible → **present $0** with ABSENT chip
  (never a missing row).

### Two wallets

Separate books. No hero total across them. R43 moved the purse to the fighter.

### Honest empties

No bouts · no sponsor · pre-key rows → **ABSENT = MUTED**. Skeleton stays
worth reading. Empty ≠ error.

## Boards → `DesignLibrary/screens/books/` (alongside `m8_*`)

| File | Content |
| --- | --- |
| `m10_01_gym_week.png` | Cash · membership (frozen AUTHORED) · sponsorship · outflows · net_weekly centre |
| `m10_02_runway.png` | runway_weeks · -1 · DIM argument · AMBER/BAD rejects |
| `m10_03_fighter_purse.png` | C28 rows newest first · $0 refusal · logistics J6 words |
| `m10_04_two_wallets_composed.png` | **THE screen** · desk compose · never totaled |
| `m10_05_empties.png` | No bouts · no sponsor · pre-key · ABSENT MUTED |
| `m10_06_rejects.png` | No curves · no gym_cut · no bankruptcy · no member trend · no SELECT-as-verified · no one-wallet total |

All boards **1920×1080**. Code-drawable from `UITokens.gd` + ledger/purse reads.

## Named dollars only

- Starter / runway context: **$25,000**, **-$5,342**, **26 weeks**
- Sponsorship tiers: **250 / 400 / 650 / 1000**
- Membership shown as the authored formula `count × rate` — no invented product
- No invented purse quotes on boards (structure labels)

## What this does NOT do

- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No runtime bitmap import of these boards.
- No reopening M8 EVIDENCED / INVENTED / ABSENT / falling=DIM.
- No projection curve, member trend, gym_cut, bankruptcy, SELECT-as-verified.
- No rail placement ruling.
- Facility is a **gym**, never a "camp".

## Engine anchors

- M8 — number-state grammar (compose, do not reopen)
- R43 — athlete wallet; runway $25,000 → -$5,342 / 26 weeks
- R44 — membership_count × membership_weekly_rate authored inflow; frozen count
- C27 — labelled ledger lines with source ∈ {evidenced, invented, absent}
- C28 — per-bout purse rows; $0 refusal present
- J6 A1 — logistics = fighter's own travel/accommodation
- J8 N2/N3 / N19/N20 — frozen count; no churn/seasonality
- J4 E1–E3 / J5 G10 — no gym_cut
- M6 — BAD = hold only
- `UITokens.gd` — TEXT / LINK / MUTED / DIM / GYM_DEFAULT verified; **no SELECT**

## Staging

- `_maria_delivery/M10_THE_BOOKS_THE_SCREEN.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M10.md`
- `research/M10_THE_BOOKS_THE_SCREEN.md`
- `research/CLAUDE_LAND_NOTE_M10.md`

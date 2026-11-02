# M8 — THE BOOKS: TWO WALLETS, AND A NUMBER THE GAME MADE UP

Maria Art Director · 2026-09-06 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Dresses the money screen R43 and J5 made true: athlete wallet owns the purse;
gym bout-delta is usually zero; the desk lives on an authored sponsorship
cheque and refuses to invent dues/corner fees. Extends Cage Desk / M5–M7 chrome.
Gym office desk — never a "camp".

## Call: three things the money screen has never said

*This is yours* (athlete wallet). *This is the gym's* (ledger, often $0 from a
bout). *This number is not real* (sponsorship — present, spendable, labelled).

## Engine-true (invent nothing beyond named figures)

**Two wallets (R43):** bout purse / win bonus / performance / gate share land in
the athlete wallet. Gym delta from a bout is **zero** unless a filed manager
share clears three gates.

**Three gates (manager share):** contract on file · combatant approval · manager
licence in the event state. Any failure → gym $0, fighter paid in full.

**Sponsorship (J5 G16 / `Sponsorship.gd:13`):** tiers **250 / 400 / 650 / 1000**
(+ small roll). No source. Stays **and gets labelled** — invented state.

**Absent by refusal:** membership dues, corner fees. Present rows at **$0**,
not missing rows.

**Runway (R43):** starter float **$25,000** · **26 weeks** · ends **-$5,342**.
Nothing in the game reacts to negative cash. No bankruptcy system.

**weekly_projection fix:** current office read is `-(upkeep + payroll)` with no
inflow term. Honest form includes the authored sponsorship cheque; net still
negative.

**Named dollars only on boards:** sponsorship tiers, $25,000, -$5,342. No
invented purse quotes.

## Token map (Cage Desk boards ↔ UITokens)

Verified against `Godot/scripts/UITokens.gd` (R9 kit) + Cage Desk style guide +
M5/M6/M7 spend.

| Role | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Ground | `#0B1220` | `GROUND` / `TRACK` | Cage desk |
| Panel | `#162033` | `PANEL` / `PANEL_LO` | Cards |
| Panel edge | `#24324A` | `LINE` / `LINE_SOFT` | 1–2px |
| Text | `#E8EEF8` | `TEXT` | Primary |
| Muted | `#8B97AD` | `MUTED` / `TEXT_2` | Labels |
| Dim | `#5C6A82` | `DIM` | Empties · falling quiet |
| **Evidenced** | `#E8EEF8` | **`TEXT`** | Real cited figure |
| **Invented** | `#7FB6EE` | **`LINK`** | AUTHORED chip · candour |
| **Absent** | `#8B97AD` | **`MUTED`** | Present $0 by refusal |
| Falling balance | `#5C6A82` | **`DIM`** | Approach/cross zero — not alarm |
| Verdict gold | `#E8B84A` | `GOLD` | **Unused — M5 verdict word** |
| Champion metal | `#F2C14E` | SODIUM (Cage Desk) | **Unused — M7 champion** |
| Hold | `#E24B4B` | `BAD` | **Unused — M6 medical hold** |
| CONTINUE | `#2ECC71` | `GO` | **Unused** |
| Semantic ready | `#4FC46A` | `GOOD` | **Unused** — money ≠ readiness |
| Recoverable warn | `#E89A3C` | `AMBER` | **Unused** — invented ≠ warn |

`TEXT`, `LINK`, `MUTED`, `DIM`, `GOLD`, `BAD`, `GOOD`, `AMBER`, `GO`, `PANEL`
are first-class `UITokens.gd` constants. SODIUM remains Cage Desk conceptual
(M7 spend) — verified not borrowed for cash.

### Evidenced = TEXT — written reason

Evidenced money is ordinary desk truth with a citation behind it. It does not
need a semantic colour. **TEXT** is the default value colour; an EVIDENCED chip
(outline, left bar) marks provenance without special chrome. Money is not
GOLD (M5 verdict) and not SODIUM (M7 belt).

### Invented = LINK — written reason

Sponsorship is authored by the game, spendable, and must read as **candour** —
not a bug badge, not a debug overlay, not an error. **LINK** (`#7fb6ee`) is
UITokens' cool instrument accent (Cage Desk CONDITION family). An AUTHORED
chip + LINK amount + optional dashed hairline says "the desk is honest about
authorship" without spending BAD (M6 hold), AMBER (recoverable warn), GOLD, or
SODIUM. Survives at ledger-row size beside evidenced and absent.

### Absent = MUTED — written reason

Same empty≠error rule as M5 R1-KO empty scorecard, M6 empties, and M7 vacant.
A **missing** dues row teaches "gyms have no members." A **present** row at
**$0 by refusal** is the truth. MUTED amount + ABSENT chip. Never BAD for
absence.

### Falling balance = DIM — written reason

Negative cash is not an injury. **BAD is M6's medical hold** and must not dress
a falling balance. Treatment: progressive quiet TEXT → MUTED → DIM, hairline at
$0, no red fill, no game-over plate, no bankruptcy banner. The desk stays open.

## Number-state chip family (primary deliverable)

One pill shape, three fills, readable at ledger-row ~28–36 px and legible in
hero cards on board 01.

| Mark | Fill | Meaning |
| --- | --- | --- |
| **EVIDENCED** | TEXT outline + left bar | Real figure with citation |
| **AUTHORED** | LINK outline + dashed hairline | Game-authored, spendable, honest |
| **ABSENT** | MUTED outline + left bar | Present $0 by refusal |

All three must sit in one table without turning the screen into a footnote wall.

## Boards → `DesignLibrary/screens/books/`

| File | Content |
| --- | --- |
| `m8_01_number_states.png` | HARD: evidenced / invented / absent at row size + rejects |
| `m8_02_two_wallets_settlement.png` | Athlete credited · gym bout delta $0 · not failed payment |
| `m8_03_gym_week.png` | Payroll+upkeep out · authored sponsorship in · absent lines · negative net · weekly_projection fix |
| `m8_04_runway.png` | $25k → -$5342 / 26 wks · cross zero quietly · no bankruptcy |
| `m8_05_athlete_wallet_vs_career.png` | Wallet now vs career earnings · not typos |
| `m8_06_manager_share_refused.png` | Three gates fail · gym $0 · fighter paid · rule working |
| `m8_07_honest_empty.png` | New gym ledger still worth looking at |
| `m8_08_composed.png` | Optional gym-office compose |

All boards 1920×1080. Code-drawable from UITokens + wallet / ledger reads.

## What this does NOT do

- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No runtime bitmap import of these boards.
- No GOLD on money. No SODIUM on cash. No BAD on negative balance.
- No bankruptcy / game-over / red alarm for runway.
- No invented dollar figures beyond sponsorship tiers, $25,000, -$5,342.
- Facility is a **gym**, never a "camp".

## Engine anchors

- R43 — athlete wallet; gym bout delta; runway $25,000 → -$5,342 / 26 weeks
- J5 G16 — sponsorship stays and is labelled; dues/corner refused
- `Sponsorship.gd:13` — tiers 250 / 400 / 650 / 1000
- Manager-share three gates (contract · approval · licence)
- `weekly_projection` — restore inflow term (authored sponsorship)
- `M5_SCORECARD_THREE_JUDGES.md` — GOLD / GO continuity
- `M6_THE_HOLD.md` — BAD = hold only
- `M7_THE_BELT.md` — SODIUM = champion only
- `STYLE_GUIDE_CAGE_DESK.md` — desk grammar
- `UITokens.gd` — TEXT / LINK / MUTED / DIM verified

## Staging

- `_maria_delivery/M8_THE_BOOKS.zip`
- `_maria_delivery/CLAUDE_LAND_NOTE_M8.md`
- `research/M8_THE_BOOKS.md`
- `research/CLAUDE_LAND_NOTE_M8.md`

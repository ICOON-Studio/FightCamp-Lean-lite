# K20 DIGEST — THE BOOKING, HOW IT READS (Kalli)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.
No HANDOFF.md edits from this study.

## A) Pick + rejects

**PICK: SCHEDULE owns THE BOARD; AGREEMENT is a set-piece over it.**
THE BOARD = ShellChrome SCHEDULE mode/tab **OFFERS** — graded list from `get_booking_board` / C19. Weekly desk work next to dated cards; not a new rail item (rail full; booking sits with calendar work).
THE AGREEMENT = set-piece (K7/set-piece spirit, full-bleed document chrome) opened from a board row — negotiation focus, walk-away stakes.

- **REJECT 1: New BOOKING rail.** Lost: rail clarity. Gained nothing P4P doesn't already do in-calendar.
- **REJECT 2: Board dissolved into month cards only.** Lost: glanceable grades across tiers in one list.
- **REJECT 3: Agreement as another SCHEDULE tab.** Negotiation needs isolation; counters/walk-away must feel like a deal, not a tab flip.
- **REJECT 4: Agreement as the only surface (legacy).** Lost: grades never seen at a glance — the C18 gap stays open.

Verdict vocabulary **KEEP C19 five words** (FightCamp voice, not letter grades):
`TAKE IT` · `WORTH IT` · `RISKY` · `TRAP` · `LOCKED`
K19 already killed letter-grade soup; do not use A/B/C or P4P's `FIGHT HYPE C-`.
Max **3 reason chips** on a board row (API may send 4; UI caps at 3 + "+1"). Tones: good / warn / bad / flat. Weight/sex never appear as reason chips (rules, not advice).

Gate projection **BOTH**: board row compact `GATE ~$N` from `gate_estimate`; agreement clause row shows estimate + what N gate points take. Seeing it **does** change the clause — player chooses a % of a visible number.

Agreement metaphor **KEEP "document", kit-dressed**: title **BOUT AGREEMENT**, paper/panel rhythm, slate pairs for money rows. Drop legacy second "plan" page from negotiation UI — fight plan picker stays **after** accept. Reject pure spreadsheet / chat-thread metaphors.

Counter / walk-away: **round pips** from `evaluate_proposal` round (1/4 · 2/4 · 3/4 · FINAL; `MAX_ROUNDS := 4`). Counter = one strip: `PROMOTER COUNTER` + money delta + optional one-line reason (`counter_reason`). Walk-away = BAD semantic end + short line; gold never on walk-away.

## B) Priority order (BOARD glance)

1. Verdict chip
2. Opponent + tier
3. Package money
4. ≤3 reason chips
5. Gate estimate
6. Weeks out / blocked

## C) Gold ×1 per board

| Board | Gold |
|---|---|
| **BOARD** | TAKE IT row primary **OPEN** |
| **AGREEMENT** | **PROPOSE** (one primary; ACCEPT AS OFFERED is slate) |
| **STATES** | **REOPEN** on countered (loudest recoverable) |
| **SEAM** | **OPEN AGREEMENT** from highlighted offer |

Green = CONTINUE only (shell way-out). Walk-away never gold. Pair blocks = slate.

## D) KEEP vs REPLACE

**KEEP**
- FightContract money + clause instruments (`gate_for`, `clause_cost`, `clause_summary`, gate points / title / rematch / weight-miss)
- Promoter counter / walk-away logic (`evaluate_proposal`, `counter_reason`, rounds, ceiling)
- SCHEDULE as calendar home (MY MONTH · THE CARDS · + OFFERS tab)
- Silhouette rows (never portraits)

**REPLACE**
- FightContractScreen private palette → UIKit / ShellChrome + set-piece kit
- Ungraded offer list → graded `get_booking_board` rows
- Agreement-as-only-entry without board grades
- Letter grades / P4P hype letters

## E) Kit gaps

Reuse first: ShellChrome (K10 SCHEDULE), K7 set-piece frame, slate `pair`, silhouette row language, CONTINUE green.

| Instrument | Need |
|---|---|
| `booking_offer_row` | Verdict + opponent/tier + package + ≤3 reasons + gate + weeks/blocked + action |
| `verdict_chip` | TAKE IT / WORTH IT / RISKY / TRAP / LOCKED dresses |
| `reason_chip` | Tone good/warn/bad/flat; UI max 3 + "+1" |
| `gate_estimate_pair` | Compact `GATE ~$N` on row; clause companion "N pts ≈ $X" |
| `counter_strip` | PROMOTER COUNTER + delta + one-line reason |
| `nego_round_pips` | 1/4 · 2/4 · 3/4 · FINAL from evaluate_proposal.round |
| `agreement_clause_row` | Clause name + gate projection + toggle/state |
| `walk_away_stamp` | BAD semantic stamp; never gold |

## F) Reads relied on

| Read / fact | Use |
|---|---|
| `get_booking_board` (TASK_C19) | Board payload: verdict, reasons≤4, gate_estimate, weeks_out, blocked |
| `get_fight_offers` / `FIGHT_TIERS` | Tier money: local 600/400, regional 1400/1000, featured 3200/2400 |
| `FightContract.GATE_BY_TIER` / `gate_for` | Gate bases 15k / 40k / 120k; board + clause projection |
| `FightContract.evaluate_proposal` / `counter_reason` / `MAX_ROUNDS` | Round pips, counter strip, walk-away lines |
| `opening_terms` / logistics consts | Travel $450 · accommodation $300 covered at open |
| C18 digest | Why grades exist (P4P grades; we priced terms only) |
| K19 digest | No letter-grade soup; kit gold / green / silhouette rules |

**Missing / name for build:** C19 may still be in flight — board UI binds to the TASK_C19 dictionary shape. Sample opponent names are placeholders for offer rows; money/gate figures are from FIGHT_TIERS / GATE_BY_TIER only. Athlete sample: Kian Sterling (prior studies).

## G) Boards (1920×1080)

1. **BOARD** (`board-offers`) — SCHEDULE · OFFERS graded list; gold OPEN on TAKE IT
2. **AGREEMENT** (`board-agreement`) — document set-piece; slates + clauses + counter strip; gold PROPOSE
3. **STATES** (`board-states`) — locked / short notice / countered / walked away / grudge / title; gold REOPEN
4. **SEAM** (`board-seam`) — board under, agreement over; gold OPEN AGREEMENT

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = CONTINUE only; pair = slate; facility is GYM; ♀ ≠ ♂; silhouettes; invent no money beyond FIGHT_TIERS / FightContract consts; ShellChrome for BOARD/STATES/SEAM; document chrome for AGREEMENT inside 1920×1080.

## Files

- `BOOKING_K20.html`
- `BOOKING_K20_board.png` / `_agreement.png` / `_states.png` / `_seam.png`
- `K20_DIGEST.md` (this file)

## Blockers

C19 (`get_booking_board`) in flight OK — UI rules against TASK_C19 shape. Study unblocked. Build (R33) needs the kit instruments above + OFFERS tab on ScheduleHub; agreement stays a set-piece scene/overlay, not a tab. Parent owns HANDOFF. This study did not edit `.gd` / `.tscn` / `HANDOFF.md`.

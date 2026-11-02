# G64 — THE FIGHT-NIGHT HUD AT FM MATCH-DAY DENSITY

**Agent:** Grok, Expert mode, 2026-09-22. **Delivered in chat; landed by Claude.**
Grok has no checkout — it read the repo through its GitHub connector to reconcile
G63, M13 and the region names before writing, which is why the region keys below
are the engine's own.

**Three lines, as asked:**

- **HUD chrome: 80 px top + 320 px bottom = 400 / 1080. Centre 680 px is bodies only.**
- **Keep at all costs:** six region rows with a tabular number, both corners.
- **Least sure:** skip-arm time. BCM's 90 s is documented for a 3D toy, not a
  manager watching a card.

## THE CONFLICT WITH U127, RESOLVED IN THE SPEC AND WORTH READING FIRST

U127 shipped `UIKit.stat_row` at **30 px**, from M22 and G63 agreeing. G64 uses
**24 px** on this surface only, and gives the arithmetic rather than a preference:

> 6×30 = 180, plus name + health + HR + ticker + dock = 334, which blows the 320
> bottom band. 24 px still clears SIZE_MIN 12.

So the two do not disagree — the profile contract stands at 30 px and the HUD
declares a tighter pitch with a costed reason. **The two tasks were assigned in
parallel and were told not to publish conflicting row heights; they did not.**

---

Screen is management, not a fighter. Verbs are corner-side. No combat inputs.
Type scale stays G63 C.7 / G: 12 / 14 / 18 / 28. Spacing base 8. Tabular
integers. No colour in this spec (M22 owns it).

## 1. THE FRAME

| Band | y | h | Contents |
|---|---|---|---|
| Top | 0 | 80 | Clock/round cluster only. Nothing in the left/right 360 px of this band. |
| Centre | 80 | 680 | Bout picture only. No panels, no bars, no buttons. |
| Bottom | 760 | 320 | Left stack (A) · decision cluster · right stack (B) · ticker on the last 28 px. |

Bottom third of 1080 is 360 px. This spec uses 320 px so the lower legs stay
readable — a NEW cut of F.1's "bottom third", not a restatement. Inset 16 px each
edge; side stacks 220×276, top-aligned at y=776.

DOCUMENTED: F.1 (G63); Undisputed live HUD keeps figures clear of the nameplate
(R85R). INFERENCE: 680 px centre is enough for two head-to-toe bodies at broadcast
Camera-1 (M13 §1).

## 2. THE TWO REGION PANELS

One panel per corner. Six engine regions, same order both sides:
**HEAD · TORSO · L ARM · R ARM · L LEG · R LEG**
(`head_neck torso_core left_arm right_arm left_leg right_leg` — FightHudRead / U3.)

**Do not mirror the row.** Both panels read `label | bar 55% | number`
left-to-right. Identity is dock side + nameplate, not flipped columns. Do not swap
L/R arm labels by corner.

| Item | Value |
|---|---|
| Panel | 220 × 164 |
| A dock | x=16, y=872 |
| B dock | x=1684, y=872 |
| Header | 20 px, label BODY, no second number |
| Row pitch | 24 px (six rows = 144) |
| Label | 52 px left, 12 px type |
| Bar | 112 px = 55% of 204 px inner row |
| Number | 40 px right, tabular integer 0–100, 14 px type |
| Number shown | yes, always, including 0 and 100 |

Cuts/swell do not get six extra rows: one 16×220 pip strip under the nameplate
(4 cut pips + 4 swell pips), empty slots still drawn. DOCUMENTED R85R corner card;
NEW placement (live, not only between-round).

## 3. THE CLOCK AND ROUND

| Item | Value |
|---|---|
| Plate | 240 × 64, top-centre: x=840, y=8 |
| Time | 28 px type, 48 px tall, M:SS, tabular, counts down |
| Round | 14 px under the time, `R 4 / 12` |
| Score | 18 px, same plate, `36–36` (consensus running total, FightHudRead.score) |
| Rest | time string becomes `REST 0:47`; round line unchanged |
| Over | time string becomes `END`; plate stays |

Also in the cluster, under the plate: pocket/stance chip 96×20 at x=912, y=76 —
POCKET / RANGE / CLINCH / GROUND + seat, on-change only. KD count replaces the
time for the count (1…10) at 28 px; the subject is the count, not a punch cam
(M13 §3.1).

**Nothing else in the top 80 px.** No date, cash, advance, belt.

## 4. THE TWO RESOURCE INSTRUMENTS

**F.2 changes on this screen: two INSTRUMENTS, not two bars.**

| Instrument | Form | Box |
|---|---|---|
| Health / damage | 1 bar + number | 220 × 16. Bar 164×10, number 40×16 tabular 0–100 |
| Gas | heart-rate integer + 20 px ring | 220 × 24. Numeral 3 digits, 18 px type. **No bar.** |

Stack, top → bottom from y=776: nameplate 220×24 (surname 18 px, record 12 px) ·
health 16 · HR 24 · trauma pips 16 · region panel 164. **Stack total 244 px.**

Why F.2 changes: R85R documented Undisputed as one health bar + one BPM integer,
not two tanks; M13 refuses a stamina bar here. Two bars fight; bar + number does
not. Engine stamina still maps to BPM in FightHudRead.

## 5. THE DECISION CLUSTER

Five controls, one row, centred at y=776, total width 160+16+4×(88+8) = **560 px**,
x=680.

| # | Verb | Size | Role |
|---|---|---|---|
| 1 | CORNER | 160 × 44 | **Primary.** Plan / shout. One fat control (G63 A.2). |
| 2 | PACE | 88 × 36 | Intensity; cycles the existing mid-fight pace set. |
| 3 | SPEED | 88 × 36 | 0.5 / 1 / 1.5 / 2 / 2.5×; prints the multiplier on the button. |
| 4 | SKIP | 88 × 36 | Walkout/intro always armed; live round armed after 90 s; rest always. |
| 5 | TOWEL | 88 × 36 | ASK STOPPAGE. **Not primary.** Costs the fight (G44). |

Between rounds: same five slots, SKIP becomes NEXT, CORNER stays primary.
Printed keybinds under the row, 12 px / 16 px tall: `[C] [P] [F] [S] [T]` (G63 A.5).

## 6. THE TICKER

| Item | Value |
|---|---|
| Box | x=16, y=1052, 1888 × 28 |
| Lines | 1 visible |
| Type | 12 px, tabular fields, no sentence |
| Line | `R4 2:14 · STERLING · LAND · HEAD · 12` |
| Hold | 2.4 s if queue = 1; 1.2 s if queue > 1 |
| Overflow | scroll 80 px/s then drop. Queue cap 8, drop oldest |

A line is an event token, not commentary. Legal verbs: LAND MISS KD CUT SWELL WARN
BREAK DOWN WAVE. Region only when the engine named one. Between rounds the ticker
clears and does not run — volume belongs in the post-round table (M13 / G45 refuse
a live drop-count).

## 7. THE POST-FIGHT TABLE

Overlay centred on the 680 px picture band; live stacks stay up.

| Item | Value |
|---|---|
| Frame | 840 × 520, x=540, y=120 |
| Columns | 4 — STAT 280 · A 160 · B 160 · Δ 160 |
| Header | 28 px |
| Row pitch | **30 px** (the profile contract — this table is read, not glanced) |
| Data rows | 12 |

Rows in order: Thrown · Landed · Accuracy % · Head landed · Torso landed · Arms
landed (L+R) · Legs landed · KD · Cuts (pips) · Swell (pips) · Score (consensus) ·
Method + time (`UD / SD / KO / TKO / SUB · R4 2:14`).

Under the 12: J1–J3 this-bout pairs, 3×30 px, **ordinal only** (`J1 115–113`) — no
official names on this screen. Winner stripe on the larger cell.
12×30 + 28 header + 16 pad + 90 judge strip = **494 px, fits 520.**

## 8. WHAT IS CUT — named omissions

| Cut | Why |
|---|---|
| Second resource bar (stamina tank) | F.2 changed; HR is the gas |
| M13 HN/TC letter chips | Replaced by numbered 24 px rows; chips have no density contract |
| Anatomy / silhouette / wound map | U3 refusal 1; M13 refusal 11; F.3 |
| Live drop-count ("12 more that minute") | G45 / M13. Ticker carries the event, table the volume |
| Judge names, belt metal, cash/date bar | Wrong surface (M5 / M7 / G63 A) |
| Mini-map, formation card, XI strip | FM pieces with no fight analogue |
| Per-punch toast, combo counter, input glyphs | Management screen; 3D confirms the HUD |
| World-space HP | K19 |
| Undisputed's extra face-trauma rows | 10+6 will not fit 320 px |
| Commentary sentences | One ticker line of fields |
| XP / career speech on the result | F.7, table only |
| Skip-from-0:00 in a live round | BCM 90 s kept so the bout is watched |

## The vertical count, which is what makes this a costed spec

Bottom stack per corner: name 24 · health 16 · HR 24 · pips 16 · region header 20 ·
region rows 6×24=144 → **stack 244**. Ticker 28. Decision row 44 (shared). Top
clock plate 64 (shared).

All HUD-owned vertical slots: 244 + 28 + 44 + 64 = **380 px of unique bands**. The
320 bottom band holds the 244 stack + 28 ticker and leaves 48 px, of which 44 is
the decision row sitting **between** the stacks, not under them. **It fits.**

> If a later skin adds padding > 8 px inside the stack, cut the region header first
> (20 → 0), **not** the number column.

## Labels, rolled up

- **DOCUMENTED:** F.1–F.7, A.2, A.5, C.7; Undisputed clock+round plate, health bar,
  BPM integer, 6-row DAMAGE card, skip (R85R); BCM 90 s / 0.5–2.5× (G63 F.4); FM
  ticker as a density tile (F.5); WBM two-column punch table (F.7).
- **INFERENCE:** 680 px clear centre; 220 px panel from Undisputed's ~180 plus our
  number column; 24 px HUD pitch derived from the 320 px budget.
- **NEW:** 80/680/320 frame; unmirrored 24 px six-row contract; F.2 as bar+BPM;
  560×44 five-verb dock; ticker field grammar; 12×4 post-fight table; pip strip on
  the live stack.

G63 rules not restated here still stand. **The only rule this screen changes is
F.2's "two stacked bars" → bar + heart rate.**

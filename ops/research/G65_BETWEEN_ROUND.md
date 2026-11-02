# G65 — THE BETWEEN-ROUND SURFACE, AT G64 DENSITY

**Agent:** Grok, Expert mode, 2026-09-22. No checkout. Cites G64 by section; only
REST deltas. 32 sources. Landed by Claude in S47 — Grok has no checkout and never
edits `HANDOFF.md`.

**Read + act: 30 s. Lock at REST 0:10. Bell at 0:00.**
**Keep at all costs:** the six unmirrored 24 px region rows, still live on this
surface — the card does not replace them.
**Least sure:** whether a high `FightStoppageRead.severity` should steal the
recommended slot. Geometry stays; words are K72.

Screen is management. No combat inputs. Type 12/14/18/28. Spacing base 8. No
colour (M22 / M23). Labels: DOCUMENTED / INFERENCE / NEW.

## 1. WHAT STAYS, WHAT CHANGES

Frame is G64 §1. Not re-derived.

| Band | y | h | REST |
|---|---|---|---|
| Top | 0 | 80 | Stays. Plate string only (G64 §3). |
| Centre | 80 | 680 | Bodies stay. Two REST-only overlays sit here. No live chrome. |
| Bottom | 760 | 320 | Stacks stay. Dock labels change. Ticker dark. |

**Persist unchanged** (G64 §2 / §4 / §5 sizes):

- Side stacks 220×244 at y=776: nameplate · health 16 · HR 24 · pips 16 · BODY
  header 20 · six rows at 24 px. A x=16, B x=1684. Unmirrored label | bar 55% |
  number.
- Decision dock 560×44 at x=680, y=776. Five slots, same widths. Keybinds
  `[C] [P] [F] [S] [T]` stay (G64 §5).
- TOWEL 88×36. PACE 88×36. SPEED 88×36.
- Top plate 240×64 at x=840, y=8.

**Re-lay-out** (label / copy only):

- SKIP → **NEXT** (G64 §5). Same 88×36, same slot. Armed the whole rest.
- Plate time → **REST M:SS** (G64 §3). Round line and running score stay on the
  plate.
- Stance/pocket chip at y=76: **off**. It is on-change only (G64 §3); REST is not
  a stance change. NEW.

**Appear only here:** the round-just-scored card (§2); the corner tray (§3) — the
CORNER control's open state; the seconds-out mark on the plate at 0:10 (§4, §6).

Already specified dark: ticker 1888×28 at y=1052. G64 §6 — it clears and does not
run. Do not light it.

DOCUMENTED: G64 §1–§6. INFERENCE: centre overlays do not steal the 320 band, so
U127 / M23 stay un-collided. NEW: two centre overlays, chip off.

## 2. THE ROUND-JUST-SCORED CARD

Manager reads this before the tray.

| Item | Value |
|---|---|
| Frame | 560 × 236, x=680, y=112 |
| Width | Same as the dock. Aligns on the dock's x. |
| Columns | 4 — STAT 200 · A 120 · B 120 · Δ 120. G64 §7 contract reused. |
| Header | 28 px. Title `R n` (the round that just ended). |
| Row pitch | 30 px (G64 §7: this table is read, not glanced) |
| Data rows | 6 |
| Type | Label 12 · numbers 14 tabular |

A subset of G64 §7's twelve. Fight-total and terminal rows die here.

| Keep (this-round values) | Drop |
|---|---|
| Thrown | Arms landed (pips + region rows cover site) |
| Landed | Legs landed (same) |
| Accuracy % | Cuts (pip strip) |
| Head landed | Swell (pip strip) |
| KD | Method + time (fight not over) |
| Score this round (10–9 / 10–8 / 10–10) | Running total (already on the plate, G64 §3) |

Δ is A−B this round, signed, tabular. **Zero is written `0`, never blank** (G63 G).

`6×30 + 28 header + 16 pad + 12 title rule = 236`. Fits. The card sits in the top
of the 680 band so the lower picture (stools, bodies) stays readable.

**Not K71.** K71 is post-fight causation. This card is volume + this-round score
only.

DOCUMENTED: column contract G64 §7; WBM two-column punch table (G63 F.7).
INFERENCE: six rows is the most a manager reads before choosing. NEW: 560×236
this-round subset.

## 3. THE CORNER INSTRUCTION

Primary verb. The **open state of CORNER**, not a second dock.

Pattern: **one recommended + four alternates.** Not a scrolling list. G63 A.2 —
one fat control.

| Slot | Size | Where |
|---|---|---|
| Recommended | 560 × 44 | x=680, y=356 — same pitch as the live CORNER button |
| 4 alternates | 128 × 36 each | One row at y=408. Gutter 8. `128×4 + 8×3 = 536`, inset 12 |
| Confirm line | 560 × 20 | y=452, 12 px type. Prints the bound key and the lock rule |

Tray height `44+8+36+8+20 = 116`. Card + gap 8 + tray = **360 px**. Occupies
y=112–472 of the 680 band. The lower 268 px of picture stays clear.

**How chosen.** Focus lands on recommended. `[C]` or click accepts it. Alternates
are one hit each (1–4 or click). Re-pick allowed until 0:10. The last accepted id
is what the next round runs.

**Count: 5 options.** Matches the five-verb dock. A sixth option is a cut (§7).

**Character budget at 14 px, no wrap** (container only; sentences are K72 / K71):

| Face | Inner px | Budget |
|---|---|---|
| Recommended line | 560 − 32 pad = 528. 14 px UI sans advance ≈ 8 px | **66 characters, hard 60** so K72's 60-char lines sit. One line. A second 14 px line is allowed on this slot only, also 60. |
| Alternate chip | 128 − 16 = 112 → | **14 characters.** Token only (HOLD / BODY / JAB / CLINCH / PRESS). No sentence. |

Do not specify the words. K72 fills both lines and the five tokens. If a K72
sentence exceeds 60, it ellipsises; **the box does not grow.**

When `FightStoppageRead.severity` is high the recommended slot still measures
560×44. It does not move the towel. K72's danger sentence goes in this box. NEW
placement; words not ours.

DOCUMENTED: BCM one instruction, last selected is what starts the next round;
changeable between rounds. G64 §5 CORNER primary. INFERENCE: five options is the
30 s cap. NEW: recommended + 4 chips, 60 / 14 char budgets.

## 4. THE REST CLOCK

G64 §3 already: time string becomes `REST 0:47`; round line unchanged; score
stays on the plate.

| Field | REST rule |
|---|---|
| Time | `REST M:SS`, 28 px, counts down from 1:00. |
| Round | **Unchanged through the rest.** After R4 ends the plate still reads `R 4 / 12`. It ticks to `R 5 / 12` on the next bell, not at 1:00. The scored card header already names the round that ended. |
| Score | Running consensus stays (36–36). This-round 10–9 lives on the card, not the plate. |
| 0:10 | Plate appends a 12 px `OUT` on the round line. Tray locks (§6). |
| 0:00 | Plate flips to live `3:00` (or ruleset length) and `R n+1 / N`. Tray tears down. NEXT is no longer a verb. |

KD-count takeover (G64 §3) cannot fire during REST. Pocket chip off (§1).

DOCUMENTED: G64 §3; real rest 60 s, "seconds out" at 10 s (commission rules).
INFERENCE: keep the just-finished round on the plate so card header and plate
agree. NEW: OUT mark; round index advances on the bell.

## 5. THE TOWEL

**Stays 88 × 36**, same slot, same sibling, never primary.

Reason: G64 §5 and G44 already priced it as ASK STOPPAGE that costs the fight.
REST is when the decision is real; that is a **state** change (K72 danger copy,
M23 region state), not a geometry change. Growing it would invert the dock: five
siblings become four + a hero stop button, and the manager stops reading regions.

Armed the whole rest, including after 0:10. Confirm is **two hits** (`[T]` then
`[T]`, or hold 0.8 s) so a lock-tick cannot throw it. Size unchanged.

DOCUMENTED: G64 §5. INFERENCE: two-hit confirm is the rest-period cost of keeping
88×36. NEW: none on size.

## 6. THE TIMING

Real rest is 60 s. **The manager does not get 60.**

| t | What |
|---|---|
| 1:00 | Card + tray up. Recommended selected. Regions already current. |
| 1:00 → 0:10 | Read and pick. Re-pick allowed. NEXT skips the remainder. TOWEL armed. |
| 0:10 | Seconds out. Tray locks on the last accepted id. Card stays. TOWEL still armed. NEXT still armed. |
| 0:00 | Bell. Tray down. Live G64 dock. |

**Useful window: 50 s. Design target to finish choosing: 30 s.**

Count: 6+6 region rows glance ~4 s; 6 scored rows ~8 s; 1+4 instructions ~8 s;
towel consider ~2 s; decide ~8 s. ≈30 s. **If it does not fit, cut an alternate or
a scored row, not a region row.**

**Default if nothing is chosen: HOLD** — last accepted plan and current PACE ride
through. No new sentence. The recommended slot may display a K72 line; if the
manager never accepts it, HOLD is what starts.

What the comps do:

| Game | Between-break default | Label |
|---|---|---|
| Football Manager | Tactics persist if unchanged. Half-time team talk can be skipped; assistant can take it; Continue starts the half. No forced new instruction. | DOCUMENTED (FM24 manual) |
| Boxing Club Manager | One corner interaction per round. The last selected instruction is what the fighter goes with when the round begins. Changeable between rounds. | DOCUMENTED (BCM 0.886.5 / 2022 corner-interaction notes) |
| Boxing Manager (Android) | Same one-instruction latch. | DOCUMENTED |
| NBA 2K (basketball analogue) | Play / timeout settings persist; auto-timeout is a setting, default automatic — not a forced new play-call. Weak analogue. | DOCUMENTED (coach settings) |

**We take BCM's latch + FM's persist. Not 2K's auto-timeout: that would pick for
the manager.**

NEXT at any time commits the current id (HOLD if none) and skips the rest of the
countdown.

DOCUMENTED: table above; 60 s rest + 10 s out. NEW: 0:10 lock; HOLD as the named
default.

## 7. WHAT IS CUT

| Cut | Why |
|---|---|
| Full G64 §7 12-row table | Terminal + site rows are post-fight or already on the stack. Six is the 30 s budget. |
| K71 causation card | Wrong moment. The fight has not ended. |
| Live ticker | G64 §6. Volume is the card. |
| >5 instruction options | Will not be read. BCM ships ~4 named interactions. |
| Instruction sentences on alternate chips | 14-char token only. Sentences live on the 60-char recommended line. |
| Growing the towel | §5. |
| Stance / pocket chip | Off during REST. |
| Second resource bar, anatomy map, world-space HP, judge names, cash/date, commentary, XP speech | G64 §8 still. |
| Per-region "press to ice / recover" | Combat input. Forbidden. |
| Auto-picking K72's recommended line | Would steal the default. HOLD is the default. |
| Updating the plate's round index at 1:00 | Conflicts with the card header. The bell does it. |
| Opening CORNER as a full-screen modal | Would hide the six rows this surface exists to act on. |

**Vertical count (REST-only add).** G64 unique bands still 380 px. REST adds, in
the already-empty 680 centre: card 236 + gap 8 + tray 116 = **360 px**. Bottom 320
and top 80 untouched. It fits. **Region rows are not traded.**

If a later skin pads the tray over 8, cut alternate chips from 4 → 3, **not** a
scored row, **not** a region row.

## Labels, rolled up

- **DOCUMENTED:** G64 §1–§8; G63 A.2 / F.4 / F.7 / G; BCM last-selected latch; FM
  persist + skippable half-time talk; 60 s rest / 10 s out.
- **INFERENCE:** 30 s read; six scored rows; five options; round index on the
  bell; two-hit towel.
- **NEW:** 560×236 this-round subset; recommended 560×44 + four 128×36 chips;
  60 / 14 char budgets; OUT at 0:10; HOLD default; pocket chip off.

G64 rules not restated still stand. This surface changes G64 §5's three-line REST
note into a card, a tray, a lock, and a default. Nothing else.

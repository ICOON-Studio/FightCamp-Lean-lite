# G66 — THE POST-FIGHT SURFACE, AT G64 DENSITY

**Agent:** Grok (grok.com, Expert mode). **Landed by Claude, S48, 2026-09-22.**
**Sources:** 75. **Worked:** 2m 23s.
Delivered in chat and transcribed here unedited; Grok has no checkout.

Third of Grok's own three: G64 (live fight-night HUD), G65 (between-round
surface), G66 (post-fight). G64 section 7 costed a 12x4 post-fight table and
never placed the screen around it. This places it.

---

## The three lines asked for

**90 s before he hits CONTINUE.** Keep: the six region rows, now with
this-fight delta. Least sure: whether K71 still wants method/time inside the
box when the result block already owns them.

Screen is management. No combat inputs. No rematch-by-reflex. 1920x1080. Type
12/14/18/28. Spacing base 8. No colour (M22 / M23). Labels: DOCUMENTED /
INFERENCE / NEW.

---

## 1. THE FRAME

80/680/320 survives as rails. **This is a different page sitting on those rails,
not the live HUD with an overlay.**

| Band | y | h | Post-fight |
|---|---|---|---|
| Top | 0 | 80 | Result statement only. Clock plate gone. |
| Centre | 80 | 680 | Documents. No live chrome. Picture is not the subject. |
| Bottom | 760 | 320 | Stacks persist. Dock verbs change. Ticker dark. |

**Dies at the final bell** (G64 §3 / §5 / §6): clock string, REST string, OUT,
KD-count takeover; pocket/stance chip; CORNER / PACE / SPEED / SKIP·NEXT /
TOWEL; ticker (already dark per G64 §6 / G65 §1); live 24 px glance pitch; G65
scored card and corner tray.

**Persists:** band rails (G64 §1); side stacks at A x=16 / B x=1684, y=776 —
nameplate · health · HR slot · pips · BODY header · six unmirrored rows
(G64 §2 / §4, geometry in §5); type scale, base 8, unmirrored
`label | bar | number`; G64 §7 column contract and twelve-row list; J1–J3
ordinal strip under the table (G64 §7).

DOCUMENTED: G64 §1–§7; G65 §1. INFERENCE: killing the five live verbs frees the
dock without moving the stacks. NEW: centre is paper, not bodies.

## 2. THE RESULT STATEMENT

A **two-line block, not one line**. First thing read. G64 never placed the winner.

| Item | Value |
|---|---|
| Frame | **840 x 64, x=540, y=8** |
| Width | Same spine as the table (G64 §7, 840). Replaces the 240x64 plate (G64 §3). |
| Line 1 | `WINNER def. LOSER` — 28 px, h=36, tabular surnames |
| Line 2 | `METHOD · R n M:SS` — 18 px, h=24. Method tokens as G64 §7: UD / SD / KO / TKO / SUB (+ RTD / DQ / NC if the engine already emits them). |
| Draw | `D. SURNAME vs D. SURNAME · DRAW · R n M:SS` on line 1; method line still carries time. |
| NC | Line 1 names both; line 2 starts `NC`. |

One 28 px line cannot hold two surnames plus method at this type (INFERENCE
from G64 §3's 240 plate). Block sits in the top 80 so the table is never the
first read.

DOCUMENTED: method tokens G64 §7. NEW: 840x64 two-line result. Winner is not a
table row.

## 3. WHERE THE 12 x 4 TABLE GOES

Column contract and row list not re-derived — per G64 section 7.

| Item | Value |
|---|---|
| Frame | **840 x 404, x=540, y=252** |
| Columns | STAT 280 · A 160 · B 160 · Δ 160 |
| Header | 28 px |
| Row pitch | 30 px (G64 §7: read, not glanced) |
| Data rows | 12 |
| Type | Label 12 · numbers 14 tabular |
| Visible at 1080p | **All twelve. No scroll. No cut.** |

`12*30 + 28 header + 16 pad = 404`. Fits.

Judge strip stays under the twelve, per G64 §7: 840 x 90 at x=540, y=656. J1
115–113 ordinal only. Ends y=746. 14 px air to the 760 rail.

G64 §7's overlay origin (y=120, h=520) moves down because the result block and
the causation box take y=8–244. Rows and columns do not change.

**Zero is written `0`, never blank** (G63 G / G65 §2).

DOCUMENTED: G64 §7. NEW: y=252 placement under the causation box.

## 4. THE CAUSATION CARD'S BOX

Sentences are K71. This is the container only. Same discipline as G65 section 3:
the box does not grow; the text ellipsises.

| Item | Value |
|---|---|
| Frame | **840 x 148, x=540, y=96** |
| Width | Same spine as result + table |
| Header | 16 px tall, 12 px type, label `CAUSE`. No sentence. |
| Line slots | **5, fixed** |
| Line pitch | 22 px |
| Type | 14 px |
| Pad | 16 / 16 |
| Count | `16 + 16 header + 5*22 + 16 = 148` |

**Character budget at 14 px, no wrap.** Same advance as G65 §3 (~8 px / cap).

| Face | Inner | Budget |
|---|---|---|
| Bullet line | 840 − 48 pad/rule = 792 theoretical; measure locked to 576 | **72 characters hard.** One line. No second line on a slot. |

5 slots cover K71's 3–5 bullets. Unused slots stay empty — box height does not
shrink. When the bout went the distance, the decision-score line takes slot 5;
it does not add a sixth row.

Winner / method / round / time are not redrawn here — they live in §2. If K71's
skeleton still emits those two lines, they are dropped at layout, not given
extra slots. High-severity stoppage does not grow the box (same rule as G65 §3
vs the towel).

DOCUMENTED: G65 §3 box-does-not-grow; K70/K71 3–5 bullets + score line on a
decision. INFERENCE: 72 > G65's 60 because a cause line is longer than a corner
command. NEW: 840x148, five fixed slots, 72-char cap.

## 5. THE BODY, AFTER

They appear. Both corners. Unmirrored. **This is the keep.**

| Item | Live (G64 §2) | After |
|---|---|---|
| Pitch | 24 px | **30 px** (read contract, G64 §7 / U127 profile) |
| Panel | 220 x 164 | **220 x 200** (header 20 + 6x30) |
| A / B dock | x=16 / 1684, y=872 | **y=776** — the whole stack lifts with the live stack origin, not the old region-only origin |
| Row | label 52 · bar 112 · number 40 | same columns |
| Number | 0–100 | **0–100 and this-fight Δ**, tabular, signed. `0` written. |

Stack, top → bottom from y=776: nameplate 24 · health 16 · HR 24 · pips 16 ·
BODY 20 · rows 180 → **280**. Ends y=1056. Ticker gone, so the 28 px it owned is
the slack. Fits the 320.

**What they show that live did not: this-fight Δ on every region.** Pips stay as
final cut/swell. Bar is the final 0–100, not a live pulse.

Hold / clearance colour is M23. This spec only reserves the existing 40 px
number cell for `nn + Δ`. No extra token column. No ice. No tap-to-treat. HR
slot persists so the stack does not jump; it shows the final reading and is not
a new instrument.

DOCUMENTED: G64 §2 / §4; 30 px read (G64 §7). INFERENCE: 280 fits 320 once the
ticker dies. NEW: Δ in the number cell; 30 px on this surface only.

## 6. THE VERBS

He talks, arranges, decides. He does not fight. Dock rail persists (G64 §5 /
G65 §1): x=680, y=776.

| # | Verb | Size | Role |
|---|---|---|---|
| 1 | **CONTINUE** | 160 x 44 | Primary. Leave to the card / office. Same fat slot CORNER used. |
| 2 | A | 88 x 36 | Open fighter A's profile. Body + contract live there. |
| 3 | B | 88 x 36 | Open fighter B's profile. |
| 4 | CARD | 88 x 36 | Rest of tonight's card. Dead on a one-bout session. |

Keybinds under the row, 12 px / 16 px: `[C] [A] [B] [N]`. `[C]` is CONTINUE now.
Fifth live slot (TOWEL) is empty — **not** a fifth verb. CONTINUE is armed on
entry, no confirm: the fight is already over.

DOCUMENTED: G64 §5 five-slot rail; G63 A.2 one fat primary. INFERENCE: profile
is the next-week act; booking and camp are other screens. NEW: CONTINUE / A / B
/ CARD; towel slot retired.

## 7. WHAT IS CUT

| Cut | Why |
|---|---|
| G64 §7 overlay at y=120 | Result + causation must precede the table. |
| Method/time inside the causation box | §2 owns them. Extra slots would steal a bullet. |
| Sixth causation line | Box is 148. K71's max is five bullets; score line reuses slot 5. |
| Scroll on the twelve | All twelve fit at 30 px. A cut of a listed row is a different task. |
| Live 24 px region pitch | This surface is read. |
| Ticker | G64 §6 / G65 §1. Volume is the table. |
| CORNER / PACE / SPEED / SKIP / TOWEL | Fight is over. |
| Rematch | Reflex combat. Forbidden. Next booking is Office / booking. |
| CAMP / TRAIN / ICE / tap-region | Wrong screen. Combat-shaped. |
| Press / talk / XP / career speech | G64 §8 still. Profile and office own speech. |
| Growing CONTINUE into a hero | Would hide A/B. The keep is the body, not the exit. |
| Second resource bar, anatomy map, world-space HP, judge names, cash/date, commentary | G64 §8 / G65 §7 still. |
| Opening PROFILE as a modal over this page | Would hide the Δ rows this surface exists to show. A/B leave. |

**Vertical count.** Top 80 = result 64 + inset. Centre: causation 148 + gap 8 +
table 404 + judges 90 = **650 of 680**. Bottom: stack 280 in 320; dock 44 sits
between the stacks on the same y=776 rail as live, not under them. It fits.
Region rows are not traded.

If a later skin pads the causation box over 8, **cut the CAUSE header first
(16 → 0), not a table row, not a region row.**

## Labels, rolled up

- **DOCUMENTED:** G64 §1–§8; G65 §1–§3 / §7; G63 A.2 / G; K70/K71 3–5 bullets +
  decision score line.
- **INFERENCE:** 90 s dwell; 72-char cause line; 280-px stack once the ticker
  dies; method/time not duplicated.
- **NEW:** 840x64 result block; 840x148 / 5x72 causation box; table at y=252;
  30 px regions with Δ; CONTINUE / A / B / CARD.

G64 / G65 rules not restated still stand. This surface places the screen G64 §7
left hanging: a result, a fixed cause box, the twelve rows in full, and the body
with a number the live HUD could not spend time on.

---

## Claude's integration note

**Every arithmetic claim in it checks.** `12*30 + 28 + 16 = 404`;
`16 + 16 + 5*22 + 16 = 148`; centre `148 + 8 + 404 + 90 = 650` inside 680;
stack `24+16+24+16+20+180 = 280` inside 320. Nothing was taken on trust.

**The one open question is Grok's own and it is a real one:** whether K71's
causation card still wants method and time inside its box now that §2 owns them.
G66 drops them at layout. K71 is on disk (`_kalli_delivery/K71_CAUSATION_CARD.md`)
and the two were written without sight of each other, which is why the question
exists — it is the same blind split that made G65 and K72 agree on 60
characters. Settle it when K71 lands, in K71's favour or G66's, but settle it
once rather than letting both ship.

# K22 — THE RANGE, HOW IT READS (Kalli)

Study only. No `.gd` / `.tscn`. Deliverable: this file under `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent. No HANDOFF.md edits.
Bebas / Plex kit. ONE-gold from R31/K19 still holds — the range ladder is never gold.
Green = CONTINUE only. Silhouettes. Invent no new sim behaviour. Do not redesign the fight surface; add one reading.

---

**Claude acts on this:** Range reads as a compact five-pip **RANGE LADDER** (OUT · LONG · MID · POCKET · CLINCH), frame-pinned on the fight surface beside/under the condition rails — never world-space, never a big bar, never a positional diagram (iso stage already owns spectacle). Active pip carries **whose fight** via `range_owner` surname chip ("RUIZ'S FIGHT"), not a number. Fight log gets real band-aware lines (replace soft FightRange.describe drafts). Tale of the tape keeps REACH numbers on booking; fight-week/tape adds one MEANING line (who wants which band / who travels). Fight report: per-round dominant band + whole-bout where it was fought. Stage B corner vocabulary: three range calls beside existing emphasis — STAY LONG · GET INSIDE · TIE HIM UP — do not replace PRESS-family emphasis.

---

## 1. The one indicator

**PICK: compact horizontal `range_ladder`** — five pips labeled OUT / LONG / MID / POCKET / CLINCH.

- **Lives:** fight night / ring stage **screen-space**, near the condition rails or above the exchange log header. Small. Secondary to HP / stamina / clock / log.
- **On band change mid-round:** active pip moves + brief flash (slate / amber — **NOT gold**). Contested hold with no move: soft pulse on the current pip.
- **REJECT:** full-width range bar (steals gold attention / duplicates rails).
- **REJECT:** two-headed positional diagram (competes with iso stage).
- **REJECT:** no indicator (hidden multiplier stays rumour).
- **REJECT:** world-space billboard (K19 killed those).

Gold ×1 stays on the issued corner call / PRESS. Ladder never gold.

## 2. Who owns it

**PICK: owner chip on the active pip** from `fight_state.range_owner`.

- Glance line: **"{SURNAME}'S FIGHT"** (or first name if the surname is not unique in the bout).
- Owner empty / both prefer the same band: neutral **"AT RANGE"** — no surname.
- Contested (`range_event.contested`) without a clear winner: keep the band pip, **drop the surname** until the next contest settles.
- Never show control scores or rolls.

## 3. The words

FightRange.describe today ("out of range", "at long range", "in punching range", "in the pocket", "in the clinch") is too soft. Replace in log voice with band + action lines. Entry-toll lines fire when `entered_range` / `range_event.entered`. Names below are placeholders (Ruiz / Cole / Park) — invent no stats.

### Example log lines

1. LONG jab: "Cole keeps it LONG — jab finds the tip of the nose."
2. LONG teep: "Park spears a teep at LONG; Ruiz can't walk through it."
3. MID cross: "They're in MID — Ruiz lands the cross clean."
4. POCKET hooks: "Pocket work — both men trading short hooks."
5. CLINCH knees: "Clinch — Park digs a knee; ref watching."
6. OUT stall: "Out of range. Neither man will close."
7. Owner hold: "Ruiz is fighting Ruiz's fight — MID, and he won't give it back."
8. Forced away: "Cole's stuck at LONG in someone else's fight."
9. Entry toll: "Ruiz has to travel — walks onto the jab coming in."
10. Entry toll hard: "Crossing LONG to get inside; Park makes him pay the toll."
11. Band move: "Range collapses — MID to POCKET on Ruiz's terms."
12. Band push out: "Teep resets it LONG; pocket dissolves."
13. Combination travel: "The combo walks them in — LONG to MID without asking."
14. Clinch break: "Break — back to MID, gloves up."
15. Ground: "On the mat — range off." (engine does not consult band on ground — skip band language)

### Vocabulary table

| Band   | Preferred log phrase   |
|--------|------------------------|
| OUT    | out of range           |
| LONG   | at LONG                |
| MID    | in MID                 |
| POCKET | pocket / in the pocket |
| CLINCH | clinch / in the clinch |

## 4. Before the bout

**PICK: split.**

- **Booking / offer surfaces:** KEEP numeric **REACH** only (already on tape at ScheduleHubPanel).
- **Fight-week / Tale of the Tape card:** ADD one meaning line from preferred bands — e.g. "Cole wants it LONG (+8cm reach). Ruiz has to travel."
- **REJECT** putting the essay on the booking board (grades already crowded).
- **REJECT** omitting meaning entirely.

## 5. After the bout

**PICK: both layers.**

- **Per-round:** round summary line — "Round N fought mostly in {BAND}" (dominant band that round). Explains weird scorecards.
- **Whole-bout:** fight report one line — "Fought at {BAND}" / "Range belonged to {name}".
- **Engine gap if missing:** need per-round aggregation of `range_band` / `range_owner` across exchanges for the post-fight card. Name it; do not invent the aggregation in code. See Engine gaps below.

## 6. Corner call vocabulary (stage B — words only, no pixels)

Three calls, corner voice. They sit **beside** existing emphasis (PRESS / listen-dock family from K19) — they do **not** replace them.

1. **STAY LONG** — hold / reset outward; for the longer man or anyone winning at distance.
2. **GET INSIDE** — close and cross; accepts entry toll; for the shorter man or pressure plans.
3. **TIE HIM UP** — force CLINCH / smother; wrestling-maul plans.

**HOLD MID** is not offered. MID is the default; coaching it is noise. Ship the three.

These are range instructions, not technique picks. Listen-roll ack dresses from K19 still apply when stage B lands.

## Engine gaps

**Already have:** `range_band`, `range_owner`, `range_event` `{from, winner, mover, entered, contested}`, per-action `range_band` / `entered_range` / `range_moved_to`, `preferred_band`, FightRange.describe (replace in log voice).

**May need for report:** per-round dominant band + owner tallies for the post-fight card. Say so; stop.

C21 catalog authoring is orthogonal (accuracy, not a read blocker).

## Kit / constraints

- Do not redesign the fight surface; add one reading (`range_ladder` + owner chip).
- Gold ×1 still on the issued corner call / PRESS — ladder never gold; band-change flash is slate/amber.
- Green = CONTINUE only.
- Silhouettes; invent no new sim behaviour.
- Study unblocked. Parent owns HANDOFF. This study did not edit `.gd` / `.tscn` / `HANDOFF.md`.
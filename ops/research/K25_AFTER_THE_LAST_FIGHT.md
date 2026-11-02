# K25 — AFTER THE LAST FIGHT, AND THE HONEST NUMBER (Kalli)

Study only. No `.gd` / `.tscn` / `HANDOFF.md`. Deliverable: this file.
No new rail item, no new factory, no new token.
K24 · M11 · R51b · J10 / R52 grades · CornerRulesRead honesty pattern.

---

**Claude acts on this:** After a granted retirement the fighter leaves the roster but not the gym's memory. A smallest **FORMER** list lives under **OFFICE** (existing destination), fed by `get_retirements()`; each row opens the retired fighter's profile where K24 / G9 epilogue is read. Path to that profile = FORMER row. Honest-number grammar: the player sees doubt only where a figure would mislead a decision — MUTED / DIM ink + one short `why` line (CornerRulesRead spirit, M11 ink weight); UNKNOWN peaks are withheld as an em-dash; never asterisk wallpaper, never BAD, never a new token.

---

## Q1 — Where a finished career lives once the fighter is gone

**Question.** K24 put the epilogue on the retired profile. Where does the gym keep them, and how does anyone open that profile once they are off the roster?

**Options considered**
- A) Save-only (`get_retirements()` drawn nowhere) — profile unreachable.
- B) New RETIRED / HISTORY rail or hub.
- C) **FORMER under OFFICE.**
- D) Former filter on the GYM active squad.

**Ruling: C.**

- `get_retirements()` is a real surface fact, not only a save key.
- Destination: **OFFICE** (K12 — gym identity / staff / paper). Not GYM (GYM is who trains tomorrow; `UIKit.squad_row` stays active roster only).
- **Path:** FORMER row → `ProfileRevampPanel` retired state (epilogue). Secondary deep-link from retirement news/attention is optional wiring, not required if FORMER exists.
- **Smallest history:** optional OFFICE count ("3 former") + list rows: name · `retired_age` · `retired_week` (career-week label) · at most one belt note if they held while here. Tap opens profile.
- Refuse a trophy cabinet, highlight reel, or belt museum.

**Why.** Without a path, K24's epilogue ruling is dead. OFFICE is the gym looking at itself; a new rail violates K10; stuffing former names into GYM confuses who can still fight.

```
OFFICE
  ...staff / paper...
  FORMER  (3)
    Alex Ruiz   retired 34 · wk 412
    Sam Cole    retired 31 · wk 390
```

---

## Q2 — The honest number

**Question.** R52 / J10 grades and CornerRulesRead can say "we do not know this." What does the player see?

**Options considered**
- A) Developer-only grades — UI prints confident numbers anyway.
- B) Asterisks / marks on every soft figure.
- C) **Selective player-facing doubt with existing ink.**

**Ruling: C.**

| Kind | Player surface |
| --- | --- |
| DIRECT / INHERITED | Print normally. No mark. |
| UNVERIFIED_SECONDARY | MUTED figure; optional one-line `why` on detail surfaces (profile epilogue, corner read) — never on `squad_row`. |
| UNKNOWN peak / window | **Withhold** — em-dash / "—". Do not print a guessed year. |
| invented / absent (corner rules) | Keep CornerRulesRead pattern: slot + absent/invented + `why`. Do not silently fill. |
| Age missing on save | Muted dash on HERO (K24). Never fabricate an age. |

**Carrier (no new token).** M11 ink weight: MUTED / DIM for the soft figure or dash; one short detail/`why` in MUTED or LINK candour. Age that is known stays clean ink weight.

**NEVER**
- Asterisk wallpaper teaching distrust of DIRECT numbers
- BAD / AMBER chrome for "unknown"
- GOLD for honesty
- Inventing a precise peak to fill a hole
- Putting grades on every squad glance

**Why.** Honesty that misleads less than a quiet lie is worth showing; honesty that paints every number as suspect is worse than the lie. Withhold what you cannot stand behind; candour-line what you must show soft.

---

## Rejects

- New rail / hub / factory / token
- Unreachable epilogue (save-only retirements)
- Trophy-cabinet FORMER
- Former fighters on GYM active `squad_row`
- Modal / popup history browser
- DECLINING / WASHED / PAST PEAK labels (K24)
- Asterisk fields; BAD for unknown; confident UNKNOWN peaks
- Re-deriving M11 art or J10 sources

---

## Build notes (Claude)

1. OFFICE: FORMER list from `get_retirements()` → open retired profile.
2. Profile retired state already owns epilogue read (K24 / G9 / M11).
3. Honest-number pass: wire grade_for / CornerRulesRead `why` into existing detail lines; withhold UNKNOWN peaks; no new UIKit factory if `caps` / MUTED / pair / slate suffice — if a dedicated mark is tempting, refuse and use ink + why instead.
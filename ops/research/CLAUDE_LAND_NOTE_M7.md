# CLAUDE LAND — Maria M7 The Belt (2026-09-06)

Maria Art Director finished **TASK M7 — THE BELT: CHAMPION, INTERIM, VACANT**.
Art only. Please land. Do not wait on Maria for more files. Do **not** expect
Maria to edit `HANDOFF.md` — write the Maria HANDOFF block yourself after land.

## What landed

- Spec: `research/M7_THE_BELT.md`
- Boards: `DesignLibrary/screens/championship/m7_*` (**new folder**, 8 PNGs)
- Staging zip: `_maria_delivery/M7_THE_BELT.zip`
- This note: `_maria_delivery/CLAUDE_LAND_NOTE_M7.md` and
  `research/CLAUDE_LAND_NOTE_M7.md`

## Token calls (important)

- **CHAMPION = SODIUM** (`#F2C14E`) — desk metal authority. **Not GOLD.**
- **INTERIM = ICE** (`#5EC8E0`) — outline + dash. Provisional. **Not M6 HELD / BAD.**
- **VACANT = MUTED** empty plate. Absence, never BAD.
- **Statuses ≠ GOOD / AMBER / BAD** (those are M6 medical / recovery / ready).
- **Title-bout flag = SELECT** (`#3A6FD8`) on the calendar at booking.
- **Reign instruments = CONDITION / LINK** (`#3DB8D4`).
- **GOLD unused.** M5 keeps the verdict word. This pack **lost** the
  argument for belt-gold — losing is the intended outcome.
- Hold chip may sit on the recognised champion **name** (body). Never on
  the interim mark.

## What it is / is not

- **Is:** belt-mark family at ~28px + hero; division header with no layout
  jump; interim-beside-champion without two-champion lie; unification stakes
  (consume interim); calendar `is_title_bout` vs ordinary champ-on-card;
  reign numbers (`defenses` / `since_week` / `last_defended_week`); honest
  empties (<3 / vacated / interim unnamed); rejected dual-champ + real
  federation likeness; composed rankings surface; token map continuing
  M5/M6.
- **Is not:** `.gd` / `.tscn` / HANDOFF / assets/data edits. No runtime
  bitmap import. No WBC/IBF/UFC likeness. No gold, no GO, no ceremony,
  no "camp." Gym desk.

## Engine anchors for HANDOFF if useful

1. `title_status ∈ {vacant, champion, interim}` — one family, three fills.
2. Interim consumed by unification / elevation — never a second keepable belt (J3 Q3).
3. `is_title_bout` written at booking — calendar must show it; champ-on-card ≠ title.
4. `interim_hold_weeks = 8` is a GAME rule (`championship_rules.json`), not a federation clock.
5. Do not reuse M6 HELD badge for interim (body vs division).

## Land steps

1. Extract `_maria_delivery/M7_THE_BELT.zip` →
   `DesignLibrary/screens/championship/` (create folder) + research spec.
2. Spec → `research/M7_THE_BELT.md`.
3. Do **not** import board PNGs as runtime bitmaps — code-draw from UITokens +
   `get_championships()`.
4. Write Maria HANDOFF block; mark TASK_M7 done when acknowledged.
5. Pending reminder: M4 / M5 / M6 post-fight and hold packs may still await
   land — land those chrome packs before or with any runtime work that
   assumes their tokens; M7 assumes Cage Desk + M5 gold/GO + M6 BAD hold.

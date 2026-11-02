# CLAUDE LAND — Maria M11 The Long Career (2026-09-07)

Maria Art Director finished **TASK M11 — THE LONG CAREER: AGE, WEAR, AND THE
LAST WALK**. Art only. Please land. Do not wait on Maria for more files. Do
**not** expect Maria to edit `HANDOFF.md` — write the Maria HANDOFF block
yourself after land.

## What landed

- Spec: `research/M11_THE_LONG_CAREER.md`
- Boards: `DesignLibrary/screens/long_career/m11_*` (**new folder**, 6 PNGs)
- Staging zip: `_maria_delivery/M11_THE_LONG_CAREER.zip`
- This note: `_maria_delivery/CLAUDE_LAND_NOTE_M11.md` and
  `research/CLAUDE_LAND_NOTE_M11.md`

## Token calls (important)

- **Age = ink weight, not hue** (extends R50 sourcing precedent). Name always
  **TEXT**. Age numeral ladder: RISING=`MUTED` · PEAK=`TEXT_2` ·
  VETERAN/RETIRED=`DIM`. Phase chip = `CHIP` (full ink) or `TRACK` (recessed);
  word always printed.
- **Wear ≠ M6 medical.** Wear = `TRACK` recess + `LINE_SOFT` + DIM ticks.
  BAD/AMBER/GOOD unused for age. Hold stays M6.
- **RETIRED chip = MUTED on CHIP/TRACK** — not BAD, not GOLD.
- **Authored epitaph = LINK** (M8 candour). Record plate, not obituary.
- **SELECT does not exist** in `UITokens.gd`. Shell tint = **GYM_DEFAULT
  `#2f6fb0`**. Candour = **LINK `#7fb6ee`**.
- **GOLD / GO / SODIUM / ICE / BAD / AMBER / GOOD** unused on age/wear/retirement.

## What it is / is not

- **Is:** age ink ladder on squad_row / profile hero / scouting; wear vs sheen
  without medical red; last-walk room (R45 precedent) with is/is-not; G9
  epilogue plate (years active, peak year, defining win, authored epitaph);
  rejects page; optional composed desk; token map continuing M5–M10 + R50.
- **Is not:** `.gd` / `.tscn` / HANDOFF / assets/data edits. No runtime bitmap
  import. No new AGE token. No toothless greybeard. No maudlin funeral chrome.
  No "camp." Gym desk.

## Engine anchors for HANDOFF if useful

1. R51 / C34 — birthdays, decline, retirement landing; this pack is the dress.
2. R50 — ink-weight banding for sourcing; **extended to age**, not reopened as hue.
3. M6 — BAD/AMBER/GOOD medical family; age must not borrow.
4. G9 `CareerEpilogue.gd` — years active · peak year · defining win · authored epitaph.
5. R45 / post-fight room — moment-given-space precedent for the last walk.
6. R18 profile_revamp — visual bar.
7. UITokens: no SELECT — use GYM_DEFAULT / LINK.
8. Standing: one figure; females never fight males; no veteran caricature.

## Land steps

1. Extract `_maria_delivery/M11_THE_LONG_CAREER.zip` →
   `DesignLibrary/screens/long_career/` (create folder) + research spec.
2. Spec → `research/M11_THE_LONG_CAREER.md`.
3. Do **not** import board PNGs as runtime bitmaps — code-draw from UITokens +
   age / CareerEpilogue reads.
4. Write Maria HANDOFF block; mark TASK_M11 done when acknowledged.
5. Pending reminder: M4–M10 chrome packs may still await land — M11 assumes
   Cage Desk + M5–M8 tokens + R50 ink-weight precedent and does not claim SELECT.

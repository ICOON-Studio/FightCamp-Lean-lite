# M11 — THE LONG CAREER: AGE, WEAR, AND THE LAST WALK

Maria Art Director · 2026-09-07 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

Dresses the visual problems THE YEARS creates once fighters get birthdays,
decline past a peak, and retire (R51, C34). Extends Cage Desk / M4–M10 chrome.
Gym desk, not fight-night. **Age is none of** M6 medical, M5 verdict, M7 belt,
or M8 money — and this pack says what it is instead.

## Call: ink weight, not hue

R50 banded sourcing quality by **ink weight rather than hue**, because every
hue in this game already means something else (GOLD = verdict, SODIUM/ICE =
belt, GOOD/AMBER/BAD = medical). Age is none of those.

**Decision: age reads as ink weight on the age numeral and phase chip — never
as a new hue, never as medical red.**

Written reason:

1. **Every hue is spoken for.** A new AGE colour would collide or invent a
   token this pack is forbidden from assuming.
2. **M6 owns BAD/AMBER/GOOD.** Age is not a hold; wear is not HELD. Borrowing
   medical red collapses two truths the kit spent M6 separating.
3. **R50 already proved the grammar.** Sourced → `CHIP` at full ink;
   unsourced → recessed on `TRACK`; word always printed. Career phase chips
   reuse that recess language (`RISING`/`PEAK` on `CHIP`, `VETERAN`/`RETIRED`
   on `TRACK`).
4. **Name stays TEXT.** Greying the veteran's name is caricature by type.
   Only the **age numeral** steps the ladder. The fighter is not quieter; the
   years are.
5. **No new token.** Kit already has `MUTED` / `TEXT_2` / `DIM` / `CHIP` /
   `TRACK`. A separate AGE token would need an explicit cost case; this pack
   does not need it.

### Age ink ladder (career phase → age-numeral colour)

| Phase | Age numeral | UITokens | Phase chip |
| --- | --- | --- | --- |
| RISING (prospect) | `#8B97AD` | **`MUTED`** | `CHIP` + full ink word |
| PEAK | `#C9D1E0` | **`TEXT_2`** | `CHIP` + full ink word |
| VETERAN (past peak) | `#5C6A82` | **`DIM`** | `TRACK` recessed + MUTED word |
| RETIRED | `#5C6A82` or omit | **`DIM`** | `TRACK` / quiet RETIRED chip |

Name, record, and defining facts stay **`TEXT`**. Age never leads the row.

## Token map (Cage Desk boards ↔ UITokens)

| Role | Board hex | UITokens | Notes |
| --- | --- | --- | --- |
| Ground | `#0B1220` | `GROUND` / `TRACK` | Cage desk |
| Panel | `#162033` | `PANEL` / `PANEL_LO` | Cards / rows |
| Panel edge | `#24324A` | `LINE` / `LINE_SOFT` | 1–2px |
| Text / name / record | `#E8EEF8` | **`TEXT`** | Fighter identity — never dimmed for age |
| Peak-window age | `#C9D1E0` | **`TEXT_2`** | Present, not hero |
| Rising age / labels | `#8B97AD` | **`MUTED`** | Biodata |
| Veteran / retired age | `#5C6A82` | **`DIM`** | Years quieter |
| Full-ink phase chip | `#333D52` | **`CHIP`** | R50 full-ink plate |
| Recessed phase / wear under | `#0A101A` / `#111621` | **`TRACK`** | R50 recess |
| Avatar fill | `#3B4557` | **`AVATAR`** | Sheen and wear share fill |
| Avatar ring quiet | `#2B3447` | **`RING`** | Retired quiet ring |
| Shell tint | `#2F6FB0` | **`GYM_DEFAULT`** | Header / row hairline — **SELECT does not exist** |
| Authored epitaph cue | `#7FB6EE` | **`LINK`** | M8 candour — authored line only |
| Hold / injury | `#E24B4B` | **`BAD`** | **UNUSED — M6 only** |
| Recoverable medical | `#E89A3C` / `#4FC46A` | **`AMBER` / `GOOD`** | **UNUSED for age** |
| Verdict / CONTINUE / belt | — | `GOLD` / `GO` / `SODIUM` / `ICE` | **UNUSED** |

**SELECT does not exist** in `UITokens.gd` (verified this pack). Shell chrome
uses **GYM_DEFAULT**; candour / authored epitaph uses **LINK**.

## 1. How age READS (squad_row / profile hero / scouting)

One grammar on every surface that already lists a fighter:

- **`UIKit.squad_row`:** left gym hairline (`GYM_DEFAULT`) unchanged; avatar;
  **name = TEXT**; **AGE label = DIM** + **numeral = ladder**; phase chip
  CHIP/TRACK; **record = TEXT** on the trailing edge.
- **Profile hero (R18 bar):** age sits in the header biodata slot — never in
  pair-block colour, never as a status pill that looks like HELD/CLEARED.
  One figure once. Visual bar = `DesignLibrary/screens/profile_revamp/`.
- **Scouting row:** identical age ink. No scout-only "old" shorthand. No
  greybeard mark.

Prospect (21) and veteran (36) share the **same row geometry**. Only ink
weight of the numeral and chip recess differ.

## 2. Wear versus sheen

| | Sheen | Wear |
| --- | --- | --- |
| Who | Prospect / peak | Years taken, still bookable |
| Ring | Crisp `LINE` + light halo | `LINE_SOFT` thin edge |
| Under | None / `PANEL_HI` presence | **`TRACK` recess** (R50 recess language) |
| Marks | None | DIM micro-ticks = history, **not wounds** |
| Colour | No medical hue | **No BAD / AMBER** |
| Beside medical | May sit beside CLEARED | Never becomes HELD |

**Wear ≠ injury.** If the body is on hold → M6 HELD (`BAD`). If the body has
years → wear (`DIM`/`TRACK`). Never both chromes on the same fact.

## 3. The last walk (retirement moment)

**Precedent:** R45 / post-fight room — a moment given space, not a banner.

**On it:**

- Name · final record · years active
- Quiet **RETIRED** chip (`MUTED` word on `CHIP`/`TRACK`) — not BAD, not GOLD
- One figure once · empty air
- Optional peak year as a fact
- Exit to desk — no GO celebration

**Emphatically NOT on it:**

- Tears, flowers, greybeard portrait
- Funeral black / mourning frame / BAD chrome
- GOLD eulogy (GOLD = M5 verdict)
- Injury montage / medical hold dress
- Maudlin "end of an era" copy

Not maudlin = desk-quiet, short plate, empty room. The hours the player spent
are acknowledged by **not shouting**.

## 4. Finished career (G9 `CareerEpilogue.gd`)

Presentation = **record plate**, not obituary.

| Field | Dress |
| --- | --- |
| Years active | Labelled · full TEXT number |
| Peak year | Labelled · one calendar fact |
| Defining win | One bout line — not a highlight reel |
| Authored epitaph | Quote on TRACK with **LINK** edge (M8 authored candour) |

Record = labelled fields + one authored line. Obituary = mourning chrome,
life-story scroll, greybeard art, BAD frame. This pack ships the plate.
Player may keep or skip the epitaph; art does not force funeral prose.

## 5. Refusals (stops re-proposal)

1. **Toothless greybeard** — caricature veteran; forbidden.
2. **Medical-red for age** — BAD/AMBER/GOOD stay M6.
3. **New hue without case** — no AGE token in this pack.
4. **SELECT-as-age** — SELECT does not exist; use GYM_DEFAULT / LINK.
5. **Grey the name** — name stays TEXT; only age numeral dims.
6. **GOLD eulogy / GO celebration** — wrong token homes.
7. **Maudlin last walk** — no tears/flowers/era banners.
8. **Obituary layout** — epilogue is a plate.
9. **Female vs male bout art** — standing rule.
10. **Wear = scar-red overlay** — wear is recess/edge, not anatomy.

## Standing constraints (held)

- No new token · no new UIKit factory.
- Lucide / flag-icons / licensed only · code-drawable · no ripped art.
- One figure once per hero screen · pair blocks never in header colour.
- Visual bar = R18 profile.
- Females never fight males · veterans are not caricatures.
- No `.gd` / `.tscn` / `HANDOFF.md` / `Godot/assets/data/` edits.
- No runtime bitmap import of these boards.

## Boards → `DesignLibrary/screens/long_career/`

| File | Content |
| --- | --- |
| `m11_01_age_in_row.png` | Prospect vs veteran same row · ladder · profile hero · scouting |
| `m11_02_wear_vs_sheen.png` | Sheen vs wear · M6 boundary |
| `m11_03_last_walk.png` | Retirement room · is / is not |
| `m11_04_finished_career.png` | G9 plate · epitaph LINK · record not obituary |
| `m11_05_rejects.png` | Named refusals |
| `m11_06_composed.png` | Optional desk compose |

## Delivery

- Spec: `research/M11_THE_LONG_CAREER.md`
- Boards: `DesignLibrary/screens/long_career/m11_*`
- Staging: `_maria_delivery/M11_THE_LONG_CAREER.zip`
- Land note: `_maria_delivery/CLAUDE_LAND_NOTE_M11.md` + `research/CLAUDE_LAND_NOTE_M11.md`

Operator relay, as M2–M10. Claude writes the HANDOFF block when the pack lands.

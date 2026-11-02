# HUD2 style sheet (no top bar) · FightCamp · art direction only

Sources: `previews/ui_s184/A_top_bar.html` (A, untracked file on Beast's master checkout), with B and C in the same folder (same CSS), cross-checked against `Godot/scripts/UITokens.gd` and the `A_*` constants in `Godot/scripts/ShellChrome.gd`. Master 99a268f8. All on-screen strings are EXAMPLE copy (Kalli owns words).

## 1. Palette (1920×1080)
| Role | Hex | Status |
|---|---|---|
| plate (text plates, cards) | `#17120e` at 91% (`#17120ee8`) | existing in A (`.card`). The Godot equivalent is `A_PLATE` rgba(26,19,14,.90) |
| plate-hi (button well, chip) | `#2a2218` | existing in A (`.chip`) |
| edge, brass hairline / solid | `#c9a24a88` / `#c9a24a` | existing in A. **Godot `A_BRASS` = `#c9a15a`**, which is a near-twin. Pick one |
| lit, ink | `#f3d489` | existing in A (`.ib.on`). Godot `A_BRASS_HI` = `#ecd29a` |
| lit, fill / underline | `#1f6f66` / `#7fd0cf` | fill is existing in A (crest badge). The underline is existing in ShellChrome (active bar). Godot `A_TEAL` = `#1f5a5c` |
| warning / count badge | `#e0a526` | existing in A (`.dot`). ShellChrome's badge is `#e8b930` |
| money up / good | `#4ec06a` | existing in A (meter) |
| money down: text / bar | `#f2766f` / `#d9503a` | text is existing in UITokens (`BAD_TEXT`). Bar is existing in A (strain) |
| text / text-2 / muted | `#efe6d6` / `#d9cdb8` / `#b9ac95` | existing in A |
| ink on gold | `#1b1611` | existing in A |
| primary action (gold) / go | `#f0c233` / `#2e9d52` | gold is existing in UITokens (`GOLD`). Go is existing in A (`.go`) |
| **paused frame** | `#e5433a` | existing in UITokens (`BAD`). **New to the HUD** |
| tooltip ground | `#0d0a07` | existing in A (`.tip`) |
| A: walnut button | `#7a5232 → #4a2f1b → #3a2414` | **new** |
| B: dark glass | `#0d0a07` at 78% (`c7`) + blur 14px | **new** alpha of an existing hex |
| C: chalkboard / frame / chalk | `#24342e` / `#6b4528` / `#f4f1e8` | **new** |
| C: corner-card paper / corner red / money-down on paper | `#f4efe3` / `#c7372f` / `#b3261e` | all **new** in code. `#c7372f` is the poster red from M34 B, used in research only |
| C: kit blue | `#2a5f9e` | **new** |

## 2. Type
- **Family:** Inter (in game: InterVariable, Inter 4.1, per the UITokens S80 note). Every number uses `tnum`. A_top_bar.html used Segoe UI, but that was the mock only. Display font: Bebas Neue (in the repo) for A and C card titles and the date.
- **Floor:** 12px (UITokens `SIZE_MIN`). Nothing is smaller, including the 'coming' tag.

| Use | px / weight |
|---|---|
| Cash (hero number) | Inter 26/700 tnum (A uses Bebas 38, see §8) |
| Date | Inter 17/700 (A and C use Bebas 24) |
| Secondary numbers (fame, members, stats) | 18/700 · 14/700 |
| Meter / progress numbers | 13–14/600–700 tnum |
| Labels (caps) | 12/600, +0.10–0.14em |
| Card title strip | 13/700 caps +0.10em (B). Bebas 20–22 (A, C) |
| Card headline | 20/600 lit |
| Button text | 12/700 caps +0.08em |
| Tooltip | title 15/600 lit · body 14/400 text · meta 12/400 muted (exact A `.tip` spec) |
| Badge | 12/700 tnum, ink |

## 3. Plates
- **All directions:** outer keyline `0 0 0 1px #0d0a07cc` plus shadow `0 8px 24px #0009`, and `backdrop-filter: blur(8px)` (B: 14px, saturate 1.2). Text plates are at least 90% opaque, and text never sits directly on the floor. Together these keep plates readable over a bright, busy floor.
- **A:** chamfer 8px (big buttons 10px), brass border 1.5px (cash cluster 2px).
- **B:** radius 3px, no border, 4px teal accent bar on the left (cards, cash) or top (date).
- **C:** paper sheets radius 2–3px, rotated ±0.6°, tape strips `#e9dfc0cc`. Board has a 10px walnut frame and inset shadow `0 0 40px #0008`.
- **Greyed / coming:** the plate stays opaque. The content goes greyscale at 42%, plus the 'coming' tag.

## 4. Icons
- Lucide SVGs from `Godot/assets/icons/lucide/` only (93 files; header `lucide-static v0.468.0`). Stroke 2 (viewBox units), round caps and joins.
- **Always line, never filled.** The lit state is a teal plate, `#f3d489` ink and a 3px `#7fd0cf` underline. The underline is the shape cue.
- **Grid:** 24 for small dock buttons and rows · 32 for big dock buttons and MAIL · 48 for panel hero and empty states only. Inline in text: 16 and 20 (A's 18 and 22 snap to these).
- **Tooltips:** title = label. The line starts with a verb and doesn't repeat the label.

## 5. Badges, meters, progress
- **Count badge:** 20px pill (min-width 20), `#e0a526`, ink 12/700, 2px `#0d0a07` ring, offset −6px top-right. Always a number, never a bare dot. MAIL uses a cream badge.
- **Meter:** 6px track `#000a` with a 1px `#ffffff12` inset, radius 3. Icon (16) on the left, number on the right. The fighter's STAMINA and STRAIN bars are 8px.
- **Progress:** 6px bar, with an `n/N` number in the title strip. The Done bar is 30px, shown at 55% until n = N, then turns go-green with a check.
- **Trend:** the `trending-up` / `trending-down` arrow plus a signed number plus colour, so colour never carries the state alone.
- **Coming tag:** 12/600 lowercase, `#0d0a07` pill, 1px muted border, sitting on the bottom edge of the slot.

## 6. Paused frame (no pulse)
- 4px inset solid `#e5433a` around the screen, static.
- Pause tab at top centre: 30px tall, `#e5433a`, radius 0 0 8 8, white 13/700 caps "PAUSED", pause icon and a "Space" keycap.
- Speed bar: pause is lit (plate-hi, 3px red underline) and the first of 4 step pips is red.
- It appears and clears with one fade of 160ms or less. No loop, no pulse, no glow.

## 7. Layout constants (1080p)
- Margin 16.
- Top-left: crest, then the fighter (A, C).
- Top centre: chips at y 44, pause tab at y 0.
- Top-right: resource cluster, 420 wide.
- Right edge: objective stack, x 1544–1904, y 156 to ≤ 720.
- Bottom-left: dock, ≤ 920 wide, ≤ 120 tall.
- Bottom-right: clock cluster.
- The floor's centre (roughly x 560–1360, y 200–860) stays clear.

## 8. NOT VERIFIED
- Whether Bebas Neue has tabular figures. If the cash jitters, use Inter 700 tnum.
- Godot parity for the backdrop blur (Godot needs a BackBufferCopy or blur shader).
- Which brass is canonical (`#c9a24a` or `#c9a15a`).

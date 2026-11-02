# M33: Icons and type for FightCamp menus (S78 → S79)

Maria (art direction) · 2026-09-25 · Godot 4.7.2 · 1920×1080 · ART ONLY: no .gd/.tscn/HANDOFF edits, no commits, no pushes.
Repo read: `Guru-Meditation/FightCamp` master. Code and fonts were read at **f5a7e14**. Master moved to **db5cd6c** (17:29 Nicosia time, UTC+3) during the task. That commit adds the S78 preview PNGs (including the tutorial screenshot used here), and `Glossary.gd` is unchanged there.
Tags: [S: source] = measured or quoted · [P: proxy from X] · [J: judgement, reason]. Words belong to Kalli: every invented or changed string is marked **EXAMPLE**. Always "the gym", never "camp". The Glossary term "Fight camp" means the preparation weeks, not the building, so it is Kalli's call.

---

## 0. Decisions (read this first)

| # | Decision | Why, in one line |
|---|---|---|
| D1 | **Icon set: Lucide 1.48.0 (ISC)**, one set only. | Native 24 px grid with a live `stroke-width="2"`, round caps and joins. That is the M32 spec exactly [S: SVG source]. Phosphor ships filled outlines on a 256 grid, so its stroke cannot be tuned [S: phosphor-icons/core assets]. |
| D2 | **Text face: Inter 4.1, `InterVariable.ttf` (roman only, 859 KB, OFL 1.1)**. It replaces Work Sans for all player text. | Larger x-height (0.546 vs 0.500 em [S: fontTools]). M32 budgets were measured in Inter. It has ✓, Greek and Cyrillic, and an `opsz` axis. It follows the operator's standing rule that "fonts must always be clearly readable" [S: UITokens.gd comment]. |
| D3 | **tnum: YES**, in both Inter and Work Sans, checked at glyph level. | Inter's `tnum` maps digits to 1328/2048-unit tabular glyphs, and Work Sans's maps to 604/1000 `.tf` glyphs [S: GSUB + hmtx]. |
| D4 | **Godot can drive it**: `FontVariation.variation_opentype` (`wght`, `opsz`) plus `FontVariation.opentype_features` (`tnum`, `case`), one FontVariation per role. | [S: Godot 4.7 docs, class_fontvariation + gui_using_fonts]. Not yet run in a 4.7.2 build: **NOT VERIFIED** in-engine. |
| D5 | **Display face stays display-only**: at least 44 px, once per screen, caps. **Flag:** the file `BebasNeue-Regular.ttf` is actually **Oswald Bold 4.103** [S: name table + fonts/SOURCE.md]. | Never ship a font file named after a different face. Rename it or state it plainly in the credits (S79/Claude). M32's line "Bebas has capitals only" was wrong, because Oswald has lowercase. |
| D6 | **No monospace for players.** IBM Plex Mono stays for dev/debug only. | M32 rule. Live offenders are CoachMarks (count line and buttons) and `UIKit.caps()` [S: code]. |
| D7 | **Tooltip AFTER**: PANEL surface with a 12 % rim, lifted shadow, Inter 18/600 name in sentence case, 15/450 body, MUTED "Now:" (not gold), and a NOT LINKED block made of glyph + word. | See §4. It keeps every live string and marks casing changes EXAMPLE. |
| D8 | **Two amendments to M32.** (a) Handbook plate glyphs are **TEXT**, not gym-hi: gym-hi on a 22 % tint is 2.74:1 and fails the 3:1 non-text rule [S: contrast calc]. (b) A lifted tooltip uses **PANEL**, not PANEL_HI, because BAD_TEXT on PANEL_HI is 3.75:1 and fails. | Measured in `render_m33.py` (contrast log). |
| D9 | **Tooltip delay 500 ms, not M32's 400 ms**, with a 100 ms fade-in. | The code uses J52's 500 ms (`TipLayer.SHOW_DELAY 0.5`) [S]. M32's 400 was a [J] and is withdrawn. |

---

## 1. Icon set choice: Lucide vs Phosphor

| | Lucide 1.48.0 | Phosphor (core) |
|---|---|---|
| Licence | ISC, plus MIT for the Feather-derived icons [S: LICENSE] | MIT [S: repo] |
| Grid / stroke | 24 × 24, `stroke-width="2"`, `stroke-linecap="round"`, `stroke-linejoin="round"`, `fill="none"` [S: every SVG in icons/] | 256 × 256, pre-expanded fills. "regular" ≈ 1.5 px at 24 px [S: assets/regular/*.svg] |
| Weights | One style. The stroke can be changed per render. | 6 weights (thin → fill, duotone) |
| Count | 1,854 SVG files in the 1.48.0 release zip [S] | ~1,500 × 6 |
| Sport glyphs | No glove. Has `hand-fist`, `dumbbell`, `biceps-flexed`, `whistle`, `weight` | Has `boxing-glove` [S: assets/regular/boxing-glove.svg] |

**Choice: Lucide.** M32 asks for a 2 px stroke with round caps on a 24 grid. Lucide *is* that spec, and the stroke stays live, so S79 can keep the optical stroke at exactly 2 px at 20 px by setting `stroke-width = 48 / size` (20 px → 2.4). Phosphor would force a 1.5 px look or a heavier "bold" weight. What we lose is the boxing glove. Fight Night uses `hand-fist` instead, and M32 already sends sport objects (gloves, belts, rings) to the illustrated game-icons.net family, not to the UI line set.

**Set checks:** every glyph name below exists as `icons/<name>.svg` in lucide-icons-1.48.0.zip (released 2026-09-24, sha256 e27a6b58…) [S]. The files in `icons/` are the unmodified release SVGs.

### 1.1 Rail (8 items): 20 px glyph, 2 px optical stroke

| Rail label (live NAV_ITEMS) | Lucide glyph | Metaphor | Honest note |
|---|---|---|---|
| The day | `sunrise` | the day starts here | **Weak-ish.** Players may expect a house for "home". `house` exists, but this rail is about a day, not a place [J]. |
| Gym | `dumbbell` | the building's kit | Strong. Shared with the Handbook "Gym". |
| Staff | `whistle` | coaches | OK for coaches. It does **not** cover medical or support staff [J]. |
| Training | `biceps-flexed` | getting stronger | **Weak.** It reads as strength only (skills are not strength), and it sits in Lucide's emoji-flavoured group. Shared with the Handbook "Training". |
| Schedule | `calendar-days` | dated card | Strong. |
| Scouting | `binoculars` | looking at opponents | Strong. |
| Rankings | `podium` | placing | Strong. |
| Office | `briefcase` | business, money, contracts | OK. |

States (rail):
- **Default:** glyph and label TEXT_2 #c9d1e0, 18/500 label [S: M32 7.2].
- **Hover:** CONTROL_HI row fill, glyph and label TEXT, 100 ms in / 150 ms out [S: M32 motion].
- **Active:** glyph and label TEXT, a 30 % gym-tint row fill, and a **3 px gym-hi bar** on the left. **Not gold**: live ShellChrome uses a GOLD bar, which contradicts M32's "one gold per board" and leaves gold for Continue/lead [S: ShellChrome.gd; J].
- **Disabled:** glyph and label DIM #6d7688, plus `lock` at 18 px and the word "Locked" (EXAMPLE) in MUTED. Never shown by dimming alone.

### 1.2 Handbook areas (10): 40 px glyph on a 56 px plate, or 20 px in lists and the tooltip header

| Area (Glossary `area`) | Lucide glyph | Shared with rail? | Honest note |
|---|---|---|---|
| Gym | `dumbbell` | **Yes** (rail Gym) | Deliberate: same concept, same glyph. |
| Roster | `users` | no | Generic but clear. |
| Training | `biceps-flexed` | **Yes** (rail Training) | Same weakness as the rail. |
| Condition | `heart-pulse` | no | Good for body and health. **Naming clash for Kalli:** the area "Condition" is the fighter's body, but the term `condition` means *equipment wear* (area Gym) [S: Glossary.gd]. |
| Matchmaking | `handshake` | no | Good (deal agreed). |
| Fight Week | `hourglass` | no | **Weak.** It reads as "waiting" or "loading" [J]. `calendar-clock` is the fallback. |
| Weigh-in | `weight` | no | **Weak-ish.** It is a kettle-style weight, not a scale. Lucide `scale` is the scales of justice, which would clash with Rules [J]. |
| Fight Night | `hand-fist` | no | OK. No glove exists in Lucide. |
| Money | `banknote` | no | Strong. |
| Rules | `gavel` | no | OK. It reads as court or authority, which fits sanctioning. |

States (Handbook tiles):
- **Plate:** 56 px, gym tint at 22 %, glyph **TEXT** #f3f5fa. This amends M32, where gym-hi on the tint gives 2.74:1 and fails 3:1 [S: contrast log].
- **Hover:** plate fill 30 %, 150 ms.
- **Selected:** plate fill 30 %, a 2 px gym-hi ring, and TEXT for the label.
- **Empty or locked area:** glyph DIM, plus `lock` 18 px and the word "Locked" (EXAMPLE).

### 1.3 State pills: glyph + colour + word, never hue only

Geometry: 28 px tall, radius 14, 16 px glyph with a 2 px optical stroke (`stroke-width` 3). That is a [J] deviation below the 18–22 row range, because the pill is itself a 28 px object. The word uses the label style 15/600, +1 px tracking, caps. The pill is a tinted fill (the semantic colour at 16 %) with a 45 % outline. **The word is always TEXT** (≥ 8.5:1). Using the semantic colour as word colour would give 4.0–4.45:1 and fail [S: contrast log].

| Word (EXAMPLE unless noted) | Lucide glyph | Colour token (glyph / tint) | Glyph contrast on PANEL | Note |
|---|---|---|---|---|
| NEEDS YOU | `circle-alert` | AMBER #f0a020 | ≥ 3:1 ok | Feather-derived (alias `alert-circle`), MIT notice applies |
| BOOKED | `calendar-check` | LINK #7fb6ee | ok | Not GOOD: GOOD, AMBER and BAD are kept for health and weight [J] |
| INJURED | `bandage` | glyph BAD_TEXT #f2766f, tint BAD #e5433a | ok | **Weak at 16 px**: can read as a battery or ticket [J]. Test on players. |
| SUSPENDED | `ban` | AMBER | ok | A time-boxed rule block, not harm [J] |
| ON WEIGHT | `circle-check` | GOOD #4fc46a | ok | alias `check-circle-2` |
| OFF WEIGHT | `triangle-alert` | AMBER | ok | Feather-derived (alias `alert-triangle`) |
| NOT LINKED (word from code [S: TipLayer.gd]) | `unlink` | **BAD_TEXT** glyph and word; outline only, BAD at 75 %, no fill | 4.57:1 on PANEL (text AA) | On PANEL_HI, BAD_TEXT is 3.75:1 and fails. There the **word turns TEXT** and the glyph stays BAD_TEXT. |

All pill glyph contrasts are ≥ 3.44:1 against their pill fill [S: render_m33.py contrast log]. The contact sheet (`M33_icon_sheet.png`) shows every glyph at 20 and 40 px on PANEL, labelled with the exact Lucide name, plus the 56 px plate and all seven pills.

### 1.4 Godot notes for the icons
- Lucide SVGs use `stroke="currentColor"`. **Replace it with `#ffffff` before import** and tint with `modulate`/`self_modulate`. How ThorVG resolves `currentColor` is **NOT VERIFIED**. White plus modulate is the safe path [J].
- Import each glyph at its display size (SVG import scale = size / 24, with 2× for the hi-dpi path). To keep a 2 px optical stroke, pre-bake `stroke-width = 48 / size` per size bucket (20 px → 2.4, 16 px → 3, 40 px → 1.2 looks thin, so use 2 for plates [J]). Round-cap rendering in ThorVG is **NOT VERIFIED** in 4.7.2.
- One line set only. Never mix Lucide with Phosphor, Material or game-icons in UI chrome. game-icons.net stays for illustrated sport objects (M32).

### 1.5 Lucide licence (full text, `icons/LICENSE-lucide.txt`, verbatim from lucide-icons/lucide@1.48.0)

```
ISC License

Copyright (c) 2026 Lucide Icons and Contributors

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

---

The following Lucide icons are derived from the Feather project:

airplay, alert-circle, alert-octagon, alert-triangle, aperture, arrow-down-circle, arrow-down-left, arrow-down-right, arrow-down, arrow-left-circle, arrow-left, arrow-right-circle, arrow-right, arrow-up-circle, arrow-up-left, arrow-up-right, arrow-up, at-sign, calendar, cast, check, chevron-down, chevron-left, chevron-right, chevron-up, chevrons-down, chevrons-left, chevrons-right, chevrons-up, circle, clipboard, clock, code, columns, command, compass, corner-down-left, corner-down-right, corner-left-down, corner-left-up, corner-right-down, corner-right-up, corner-up-left, corner-up-right, crosshair, database, divide-circle, divide-square, dollar-sign, download, external-link, feather, frown, hash, headphones, help-circle, info, italic, key, layout, life-buoy, link-2, link, loader, lock, log-in, log-out, maximize, meh, minimize, minimize-2, minus-circle, minus-square, minus, monitor, moon, more-horizontal, more-vertical, move, music, navigation-2, navigation, octagon, pause-circle, percent, plus-circle, plus-square, plus, power, radio, rss, search, server, share, shopping-bag, sidebar, smartphone, smile, square, table-2, tablet, target, terminal, trash-2, trash, triangle, tv, type, upload, x-circle, x-octagon, x-square, x, zoom-in, zoom-out

The MIT License (MIT) (for the icons listed above)

Copyright (c) 2013-present Cole Bemis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
Of our 24 glyphs, `circle-alert` (alert-circle), `triangle-alert` (alert-triangle) and `lock` appear in the Feather list, so the MIT notice must be kept alongside the ISC one in the credits.

---

## 2. Type spec

### 2.1 What the repo ships (verified at f5a7e14, `Godot/assets/fonts/`)

| File | Bytes | What it really is |
|---|---|---|
| `BebasNeue-Regular.ttf` | 108,496 | **Oswald Bold**, Version 4.103, usWeightClass 700, has lowercase, cmap 737 [S: name/OS2]. SOURCE.md: "Display: Oswald Bold (bundled at BebasNeue-Regular.ttf so every existing preload path picks up a wider modern face without a 10-file rename)". |
| `IBMPlexMono-Regular.ttf` | 135,580 | IBM Plex Mono Regular |
| `IBMPlexMono-Medium.ttf` | 136,704 | IBM Plex Mono Medium |
| `WorkSans-Variable.ttf` | 361,072 (353 KB) | Work Sans v2.012, variable `wght` |
| `SOURCE.md` + a `.import` for each font | | "All from Google Fonts, SIL OFL 1.1" |

**No Inter** [S]. That confirms S78's finding. The brief's list also missed that Plex ships as two weights. Work Sans is used only by TipLayer and CoachMarks [S: grep of code].

### 2.2 Inter vs Work Sans: measured with fontTools

| | Work Sans Variable (in repo) | Inter Variable 4.1 (candidate) |
|---|---|---|
| File / size | `WorkSans-Variable.ttf` 353 KB | `InterVariable.ttf` 879,708 B = **859 KB**. Roman only; skip `InterVariable-Italic.ttf` (889 KB). Static weights in `extras/ttf/` are ~400–420 KB each. |
| Version / licence | 2.012 · OFL 1.1 | "Version 4.001;git-9221beed3" (release tag v4.1) · OFL 1.1 (`_src/Inter-LICENSE.txt`) |
| Axes | `wght` 100–900, default 400, 9 named instances | `opsz` 14–32, `wght` 100–900 |
| UPM | 1000 | 2048 |
| x-height / cap | **0.500** / 0.660 em | **0.546** / 0.728 em |
| Body height (d top → p bottom) | 0.940 em | 0.932 em |
| `tnum` | **yes**: digits → `.tf`, 604 units (proportional 0 = 622, 1 = 390) | **yes**: 1328/2048 each (proportional 0 = 1292, 1 = 833) |
| `lnum` | yes (it has `onum` too; the default is proportional lining) | no. Lining is the default, so it is not needed. |
| `case` | yes (parens, hyphen) | yes |
| `zero` | yes (`zero.zero`) | yes (slashed) |
| Stylistic sets | ss01–ss06 (unnamed) | ss01–ss08, cv01–cv14 (named, e.g. ss01 "Open digits", ss02/ss04 "Disambiguation", cv05 "l with tail", cv08 "I with serif") |
| Other GSUB | aalt c2sc calt ccmp cswh dlig dnom frac hist liga locl nalt numr ordn ornm pnum rvrn salt sinf smcp subs sups swsh titl | aalt calt ccmp dlig dnom frac locl numr ordn pnum salt sinf subs sups |
| GPOS | cpsp kern mark mkmk | cpsp kern mark mkmk |
| £ € – · | yes | yes |
| ✓ U+2713 | **NO** | yes |
| ▲ U+25B2 | yes | yes |
| Greek / Cyrillic | **no** | yes (useful for the Cyprus market) |
| cmap | 754 | 2,852 |

At 15 px, Work Sans's x-height is 7.5 px and Inter's is 8.2 px. **Work Sans 15 has the x-height of Inter 13.7** [S: calc]. That settles the readability case.

### 2.3 Width audit (px at the role size; `_src/width_audit.txt`, `width_audit.py`)

| Role · sample | Work Sans | Inter | WS/Inter | Live today: Plex 12 caps | Plex at the same size |
|---|---|---|---|---|---|
| label 15/600 +1 px · "NOT LINKED" | 99.8 | 99.4 | 1.005 | 72.0 | 90.0 |
| label · "TODAY'S LEAD · FIGHT" | 183.4 | 185.5 | 0.988 | 144.0 | 180.0 |
| meta 15/450 · definition sentence | 394.3 | 377.3 | 1.045 | 388.8 | 486.0 |
| body 18/400 · why sentence | 455.0 | 429.7 | 1.059 | 352.8 | 529.2 |
| row 18/500 · "Nicosia Boxing Club" | 173.5 | 169.2 | 1.025 | 136.8 | 205.2 |
| group title 22/600 · "Floor space" | 125.6 | 120.5 | 1.042 | 79.2 | 145.2 |
| screen title 30/650 · "Name the gym" | 213.3 | 200.8 | 1.062 | 86.4 [P: Plex 12 caps; the live title is actually the Oswald display face] | 216.0 |
| hero 44/650 tnum · "$24,180" | 172.7 | 182.0 | 0.949 | n/a | 184.8 |
| digits 18 tnum · "0123456789" | 108.7 | 116.4 | 0.934 | 72.0 | 108.0 |
| rail 18/500 · all 8 labels | 593.0 | 565.4 | 1.049 | 482.3 | 723.7 |

Takeaways:
- (1) Work Sans is 2.5–6 % **wider** than Inter in mixed case, but its tabular digits are 6.6 % **narrower**.
- (2) Moving from the live Plex 12 caps to Inter at M32 sizes costs **about the same width for meta**, and **about 1.2–1.5× for body, rows, titles and the rail**. S79 must re-check every fixed-width container: rail width, stat units (202 px captions), offer cards.
- (3) Plex at the same px is 15–20 % wider than either proportional face, so dropping mono is where the room comes from.

### 2.4 Godot 4.7.2 capability (docs, not yet a build test)

- `FontVariation.variation_opentype` (Dictionary) sets variable axes by tag, e.g. `{TextServerManager.get_primary_interface().name_to_tag("wght"): 600}`. `FontVariation.opentype_features` (Dictionary) is "A set of OpenType feature tags" [S: docs.godotengine.org/en/4.7/classes/class_fontvariation.html]. `spacing_glyph` adds tracking in px [S: same page].
- Features can also be set per font file through Advanced Import Settings → Metadata Overrides → OpenType Features. The docs' own example is Inter's slashed zero. "Godot has full support for variable fonts" [S: docs.godotengine.org/en/4.7/tutorials/ui/gui_using_fonts.html].
- In RichTextLabel, `[font otf="tnum=1"]…[/font]` sets features inline [S: docs.godotengine.org/en/4.7/tutorials/ui/bbcode_in_richtextlabel.html].
- **NOT VERIFIED:** whether Godot sets `opsz` automatically from the font size. Assume it does not and set it per FontVariation. `tnum` rendering in an actual 4.7.2 export was not tested.

### 2.5 Roles (Inter Variable; M32 §7.2 sizes; one FontVariation each)

| Role | px | `wght` | `opsz` | `opentype_features` | spacing_glyph | Line height | Case |
|---|---|---|---|---|---|---|---|
| Label / eyebrow | 15 | 600 | 15 | `case=1, tnum=1` | +1 px (do **not** also turn on `cpsp`) | 1.2 | CAPS, ≤ 24 chars |
| Meta | 15 | 450 | 15 | `tnum=1` | 0 | 1.4 | sentence |
| Body prose | 18 | 400 (500 for emphasis) | 18 | none (proportional figures read better in running text [J]) | 0 | 1.4 | sentence |
| Row / button | 18 | 500–600 | 18 | `tnum=1` | 0 | 1.3 | sentence |
| Group title | 22 | 600 | 22 | none | 0 | 1.2 | sentence |
| Screen title | 30 | 650 | 30 | none | 0 | 1.2 | sentence |
| Hero figure | 44 | 650 | 32 (axis max) | `tnum=1` | 0 | 1.1 | n/a |
| Display (Oswald file) | ≥ 44 | fixed Bold | n/a | none | 0 | 1.0 | CAPS, once per screen |

`zero` stays off. Inter's `ss02`/`ss04` (disambiguation) and `cv08` (I with serif) are candidates if players confuse Il1 in names or stats, but they are **not adopted** and have not been tested with players. The Work Sans fallback, if the operator rejects the +859 KB, uses the same table with Work Sans `wght` values (no opsz). Budgets then shrink by about 5 % (§2.3).

### 2.6 Why Inter over Work Sans (and the case against)
- **For Inter:**
  - The x-height is 9 % larger at equal px.
  - M32 budgets and mocks were measured in Inter.
  - It has ✓, Greek and Cyrillic.
  - `opsz` tightens the titles.
  - Its named stylistic sets can fix Il1 if needed.
- **For Work Sans:**
  - It is already shipped and licensed, and 506 KB smaller.
  - It has more character (it is less "SaaS").
  - Its tabular digits are narrower.
- **Verdict:** readability is the operator's standing rule, so Inter. Work Sans can be dropped once nothing references it (S79's call).

---

## 3. Contact sheet and specimen
- `M33_icon_sheet.png` shows all 24 glyphs at 20 and 40 px on PANEL, with the exact names, plates and pills.
- `M33_type_specimen.png` shows Work Sans and Inter side by side at every M32 role and px, with tnum on/off and the metrics table.

---

## 4. Tooltip (S78 tutorial step 4 "gym", FLOOR SPACE)

### 4.1 The live one: the real preview plus the code
- **Preview:** `previews/s78_tutorial/05_tut_04_gym.png`. This file was **not** in the repo at f5a7e14. It arrived in **db5cd6c** and was downloaded with a verified blob hash of 03319fa, 1920×1080 [S]. The BEFORE on the board is an untouched crop of it.
- **Measured rect** (1 px LINE border): x 483–822, y 433–559 → **340 × 127** [S: pixel scan]. Fill `(20, 26, 37)` = #141a25, about the code's `#141a26f5` [S].
- **TipLayer.gd** (autoload, CanvasLayer 110) [S]:
  - `MAX_WIDTH 340`, `OFFSET (18, 22)`, `SHOW_DELAY 0.5`, `RESHOW 0.1`, `HIDE_GRACE 0.5`
  - StyleBoxFlat bg `#141a26f5`, 1 px border `T.LINE #4a5a78`, radius 8, shadow black 45 % size 10, margins L12 R12 T9 B10
  - RichTextLabel with Work Sans 15, bold = FontVariation `wght 650`, default colour TEXT_2
  - NOT LINKED: `"[color=%s][b]NOT LINKED[/b]: %s[/color]"` in BAD_TEXT
  - Ctrl pins, Esc closes
- **Glossary.gd `tip_bbcode`** [S]:
  - `"[b]%s[/b]" % name.to_upper()`, then `short`, then `"[color=#f0c233]Now:[/color] %s"`, then `"[color=#94a1b8]Why:[/color] %s"`
  - Contract: short ≤ 15 words, why ≤ 12 words
- **Strings on screen:** "FLOOR SPACE" / "Grid cells on the gym floor; every station takes some." / "Now: 36/40" / "Why: No free space, no new equipment until you expand." [S: preview + Glossary `floor_space`]. This tip has **no NOT LINKED line**: `unlinked` comes only from `UICensus.unlinked_reason` or explicit `UIKit.tip(..., {"unlinked": …})`. The NOT LINKED variant on the board uses OfficeHubPanel's real call: text "This line reads $0.", unlinked "no game system feeds this line yet" [S]. No screenshot of that variant exists, so its BEFORE is a **reconstruction from code**.
- **Observations from the preview:**
  - The `[b]` name renders at regular weight, not the 650 bold. The cause is **NOT VERIFIED**: possibly `bold_font` is not applied through a theme override.
  - Three golds show at once: OPEN GYM, the coach card (edge and "COACH · 4 / 19 · NEW CAREER"), and "Now:". The coach card uses Plex Mono.

### 4.2 AFTER (M33): what changed and why
| # | Change | From → to | Tag |
|---|---|---|---|
| 1 | Surface | #141a26 at 96 % (darker than the ground, reads as sunk) → PANEL #2a3347 + 12 % white rim + lifted shadow (16 blur, 40 %, +5 y) | [S: M32 lit tokens] · PANEL not PANEL_HI [S: BAD_TEXT 3.75:1 on PANEL_HI] |
| 2 | Header | "FLOOR SPACE" upper, 15 → **"Floor space"** 18/600 TEXT, sentence case (EXAMPLE casing; the data is already sentence case, and only `to_upper()` makes it caps) + Lucide `dumbbell` 20 px MUTED (the Gym area) + the area "Gym" right-aligned 15/450 MUTED (Glossary data, no new words) | 11.58:1 |
| 3 | Definition | Work Sans 15/400 → Inter 15/450 TEXT_2, verbatim, 2 lines max at 328 px | 8.23:1 |
| 4 | Now | gold `#f0c233` "Now:" → MUTED 15/600 label, value 15/600 TEXT **tnum** "36/40", plus a 96 px meter (36/40 in gym-hi on TRACK) | gold is kept for Continue/lead [S: M32]; the meter is a [J] addition with no words |
| 5 | Why | hard-coded `#94a1b8` (old MUTED) → token MUTED #a3afc4 15/600, hanging indent | 5.70:1 |
| 6 | Position | Drawn at the live force_show() spot (483, 433), so the mock hides the old tip and invents no pixels behind it. **Recommendation:** tutorial tips go 8 px under the unit, left-aligned to it. Width fixed at 360 (was 340 max). | [J] |
| 7 | NOT LINKED | whole line BAD_TEXT, bold word + lower-case reason (hue + weight only) → hairline, Lucide `unlink` 18 px + "NOT LINKED" label 15/600 +1 px caps BAD_TEXT (4.57:1), reason in TEXT_2, sentence case "No game system feeds this line yet." (**EXAMPLE casing**; the words stay the census's) | glyph + word, never hue only |

Timing: show after **500 ms** (J52, the live value), fade in 100 ms, out 100 ms. There is no pulse.

### 4.3 Text budgets (AFTER, 360 px card, 328 px text column)
| Slot | Budget | Tag |
|---|---|---|
| Name | ≤ 24 chars, 1 line next to the glyph and area | [J: 18/600 at about 11 px/char, with 60 px kept for the area] |
| Definition | ≤ 15 words, ≤ 2 lines (≈ 90 chars) | [S: Glossary contract] + [J: 2 lines] |
| Why | ≤ 12 words, ≤ 2 lines in the 282 px indent | [S: Glossary contract] |
| Now value | ≤ 16 chars | [S: TipLayer `_sibling_value` limit] |
| NOT LINKED reason | ≤ 48 chars, 1 line | [J] |

**Audit** (`glossary_budget_audit.py`, output in `_src/glossary_budget_audit.txt`): all **46** Glossary terms at db5cd6c fit. Line counts (definition, why): (1, 2) × 10 · (2, 1) × 7 · (2, 2) × 29. **Zero over budget.** The tallest term tip is 182 px [S: measured with Inter 15/450].

Files: `M33_tooltip_before_after.png` (real crop BEFORE vs AFTER in context, then 2× of both tooltips and of the NOT LINKED variant) and `M33_tooltip_after_annotated.png` (7 numbered callouts matching §4.2).

---

## 5. Never list: additions
1. Never hard-code a colour hex inside bbcode (`#f0c233`, `#94a1b8`). Use tokens, so a token change reaches every tip.
2. Never make "Now:" (or any label) gold. Gold is one per board: Continue or the lead.
3. Never put BAD_TEXT on PANEL_HI (3.75:1). Use TEXT for the word and keep BAD_TEXT only on the glyph.
4. Never put a tinted glyph on a gym-tinted plate. Plate glyphs are TEXT.
5. Never mix Lucide with another icon set in UI chrome.
6. Never ship a font file named after a different face (`BebasNeue-Regular.ttf` = Oswald).
7. Never `to_upper()` a Handbook name for display. Caps are for eyebrows ≤ 24 chars only.
8. Never show a state by colour alone. Every pill is glyph + word.
9. Never use a monospace face in player-facing text (the coach card count and buttons, `UIKit.caps`).

## 6. Self-attack
- **Inter is the default "SaaS" face.** The game can end up looking like a dashboard. Mitigation: the display face, the hero figures and illustrated surfaces carry the personality. The risk is real, and Work Sans would have been more distinctive.
- **M33 overrides M32 twice** (plate glyph colour, lifted tooltip fill). Both come from measured contrast failures, but they mean M32's mocks are slightly wrong on those two points.
- **Weak metaphors:** sunrise, biceps-flexed, hourglass, weight and bandage at 16 px. Whistle leaves out medical staff. None of these has been tested with players.
- **Using Lucide means no boxing glove.** A fight game without a glove icon in its UI chrome is a deliberate trade, and it may feel odd.
- **The meter in the tooltip is an addition.** Kalli or Claude may see it as noise. It carries no words and can be dropped.
- **The AFTER keeps the live position** so the mock stays honest. The recommended anchoring is not visualised.
- **Earlier in this task I had assumed the preview PNG was missing.** It was added by db5cd6c mid-task. The BEFORE is now the real image, but the code facts are from f5a7e14; only Glossary.gd was re-checked at db5cd6c.
- **Pillow is not Godot.** Rasterisation, hinting and `opsz` behaviour will differ in-engine.

## 7. Sources
- Repo `Guru-Meditation/FightCamp` @f5a7e14:
  - `Godot/assets/fonts/*` and `SOURCE.md`
  - `Godot/scripts/TipLayer.gd`, `Glossary.gd` (re-read @db5cd6c), `CoachMarks.gd`, `UIKit.gd`, `UITokens.gd`, `ShellChrome.gd`, `OfficeHubPanel.gd`
  - The preview `previews/s78_tutorial/05_tut_04_gym.png` @db5cd6c (blob 03319fa)
- Lucide 1.48.0 release zip (2026-09-24) and `LICENSE` from lucide-icons/lucide@1.48.0 · https://lucide.dev
- Phosphor: github.com/phosphor-icons/core (assets/regular, MIT)
- Inter 4.1: github.com/rsms/inter/releases (Inter-4.1.zip, sha256 9883fdd4…, `InterVariable.ttf`, LICENSE.txt OFL 1.1)
- Godot 4.7 docs:
  - https://docs.godotengine.org/en/4.7/classes/class_fontvariation.html
  - https://docs.godotengine.org/en/4.7/tutorials/ui/gui_using_fonts.html
  - https://docs.godotengine.org/en/4.7/tutorials/ui/bbcode_in_richtextlabel.html
- WCAG 2.2 contrast (1.4.3 text 4.5:1, 1.4.11 non-text 3:1)
- M32: `/workspace/fightcamp-m32/M32_MENU_ART_DIRECTION.md`

## 8. Honesty flags
| # | Flag | Status |
|---|---|---|
| H1 | `BebasNeue-Regular.ttf` is Oswald Bold. M32's "caps-only Bebas" claim and M32's BEFORE boards (system Bebas) were wrong about the live face. | VERIFIED (name table + SOURCE.md) |
| H2 | The preview PNG was absent at f5a7e14 and present at db5cd6c. BEFORE = the real crop. The NOT LINKED BEFORE = a reconstruction from code. | VERIFIED |
| H3 | Godot `opentype_features` / `variation_opentype` are documented but not run in a 4.7.2 build. Whether `opsz` follows size automatically is unknown. | NOT VERIFIED in engine |
| H4 | ThorVG handling of `currentColor` and round caps at small sizes | NOT VERIFIED |
| H5 | The live `[b]` tooltip name renders regular weight in the preview. The cause is unknown. | OBSERVED, cause NOT VERIFIED |
| H6 | Weak metaphors (sunrise, biceps-flexed, hourglass, weight, bandage at 16 px, whistle) | [J], untested with players |
| H7 | Pill words other than NOT LINKED, "Locked", and the sentence-case NOT LINKED reason | EXAMPLE (Kalli owns the words) |
| H8 | The 16 px pill glyph deviates from the M32 18–22 row range | [J] deviation |
| H9 | Code facts at f5a7e14. Only Glossary.gd was re-read at db5cd6c; master moved during the task. | PARTIAL |
| H10 | Greek/Cyrillic name rendering in Inter was not checked against real Cyprus name data | NOT VERIFIED |
| H11 | Inter adds 859 KB to the build and needs one OFL entry in the credits | VERIFIED size |
| H12 | Renders are Pillow with raqm shaping, not Godot. Widths are ±1 px. | [P: Pillow for Godot TextServer] |

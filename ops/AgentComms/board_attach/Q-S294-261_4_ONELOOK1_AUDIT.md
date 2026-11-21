# ONELOOK1 audit - one look across every screen (S496, 2026-11-16)

Operator, 2026-11-16: "the lightining on some the stills on the board are darker than others. Everymenu i loook is designed
differently we need a proper UI consistent through scenes that meake sens. Also the colour pallette should be in effect".

How measured: `tools/onelook_stills.gd` on the TEST CLUB (TestJump club4: 3 boxers + 1 BJJ, every menu populated), one
still per page at 1920x1080 on the hidden desktop, Text size Medium (and Largest for the after set). Per still it prints
the mean brightness (0-255, Rec.709 luma) and a census of what the page is built from. Stills: `E:/FightCamp/tmp/onelook1/`.

## 1. Before: what each page is made of

Columns: **L** mean brightness 0-255 · **hand** boxes drawn by hand (a style override, not the kit) · **off** words/fills in
a colour that is not one of the palette's 19 (unique colours) · **sizes** how many type sizes, smallest-largest px ·
**fonts** in order of use · **kit** most-used kit pieces.

| Page | L | hand | off (unique) | sizes | fonts | kit |
|---|---|---|---|---|---|---|
| 00_title | 132 | 7 | 17 (3) | 5: 18-138 | Barlow-Bold, Barlow-SemiBold, Marker |  |
| 01_home | 83 | 33 | 41 (10) | 10: 16-32 | Barlow-Regular, SemiBold, Bold, Kalam-Bold, Marker | Card 4, Link 4, Btn 3, GhostDark 3 |
| 02_fighters_roster | 44 | 25 | 14 (5) | 10: 16-46 | Barlow-Bold, Regular, SemiBold, Marker | Btn 4, GhostDark 3, Rail 2, Tab 2 |
| 03_fighters_find | 47 | 0 | 5 (3) | 8: 16-46 | Barlow, Marker | Card 6, Btn 3, GhostDark 3, ChipGreen 2 |
| 04_fights | 41 | 0 | 4 (3) | 8: 16-52 | Barlow, Marker | Card 7, Link 4, GhostDark 3, Btn 2 |
| 05_gym_people | 46 | 26 | 5 (3) | 7: 16-48 | Barlow, Marker | Btn 4, GhostDark 3, Card 2, Rail 2 |
| 06_gym_records | 41 | 0 | 4 (3) | 7: 16-52 | Barlow, Marker | Tab 15, Chip 7, GhostDark 3, TabOn 3 |
| 07_money | 53 | 38 | 9 (4) | 10: **11**-32 | Barlow, **Kalam** (hand), Marker | Btn 14, Go 5, GhostDark 3, Choice 2 |
| 08_office | 45 | **88** | 4 (3) | 9: 16-40 | Barlow, Marker | GhostDark 3, Rail 2, Go 1, TopBar 1 |
| 09_world_news | 32 | 0 | 4 (3) | 6: 16-52 | Barlow, Marker | GhostDark 3, Card 2, Rail 2, Tab 2 |
| 10_world_rankings | 48 | 24 | 4 (3) | 7: 16-52 | Barlow, Marker | Link 35, Btn 3, GhostDark 3, Rail 2 |
| 11_world_championships | 47 | 0 | 4 (3) | 7: 16-52 | Barlow, Marker | Card 11, GhostDark 3, Rail 2, Tab 2 |
| 20_lucy_overview | 42 | 20 | 25 (7) | **14**: 16-58 | Barlow, Marker | Card 10, Btn 6, GhostDark 3, Tab 3 |
| 20_lucy_training | 53 | 19 | 20 (5) | 12: 16-40 | Barlow, Marker | Btn 16, Chip 5, GhostDark 3, Tab 3 |
| 20_lucy_history | 36 | 5 | 4 (3) | 7: 16-36 | Barlow, Marker | GhostDark 3, Tab 3, Rail 2, Card 1 |
| 20_lucy_fightprep | 69 | 4 | 15 (6) | 8: 16-36 | Barlow, **Kalam**, Marker | Card 9, Btn 5, GhostDark 3, Tab 3 (+ a yellow paper sticky) |
| 21_lucy_playbook_0 moves | 38 | 0 | 4 (3) | 7: 16-36 | Barlow, Marker | Choice 30, Tab 6, GhostDark 3 |
| 21_lucy_playbook_1 plans | **109** | 4 | 35 (9) | 6: 16-36 | Barlow, Marker | Pill 15, BtnQuiet 8, Tab 6 (cream paper cards) |
| 21_lucy_playbook_2 combos | 70 | 11 | **46** (9) | 10: 16-36 | Barlow, Marker | Btn 24, Tab 6 (white paper cards) |
| 21_lucy_playbook_3 escapes | 36 | 0 | 4 (3) | 7: 16-36 | Barlow, Marker | Choice 7, Tab 6, GhostDark 3 |
| 22_kira / 22_josh overview | 41 | 19 | 25 (8) | 14: 16-60 | Barlow, Marker | Card 10, Btn 6 |
| 23_kira / 23_josh training | 54 | 19 | 20 (5) | 12: 16-40 | Barlow, Marker | Btn 16, Chip 5 |
| 24_ana_mat (BJJ) | 51 | 10 | 14 (9) | 7: 16-52 | Barlow, Marker | Btn 8, Card 6, BtnSolid 2 |

In the code before the change: **~690 loose colours** in 109 screen scripts (`tests/palette_baseline.json`), **227
hand-made boxes** (`StyleBoxFlat.new()` / `UI.box(...)`) in 148 files, and **four looks living side by side**: the
approved wood-and-slate kit (WoodKit), the old cream-paper look still inside the theme (UI.gd: Board, Polaroid, the
yellow Stickies, drop-downs, pickers, text boxes - all cream), the white coach's whiteboard with navy marker
(WhiteboardKit), and the warm plaster kit (WarmKit, Money only).

## 2. Why some stills are darker: four exposures of the wall

Every career page draws the painted gym photo behind it (`MenuFx.set_wall`), but not at one brightness:

| Page | Picture | Exposure (multiplier) | Where |
|---|---|---|---|
| most pages | gym_backdrop.jpg (mean 46) | 0.68 | MenuFx.WALL_DIM |
| a fighter's Overview | gym_backdrop.jpg | **0.30** | DarkOverview.dim_wall (Palette.WALL_DARK) |
| the bout page | versus_backdrop.jpg (mean 44) | **1.00** | MenuFx.set_wall gave any other picture full white |
| the office | gym_main.jpg (mean 88) under a desk panel | 0.22 | Office.gd |

On top of the wall, two pages were bright for another reason: Playbook Plans (109) and Combos (70) and Fight prep (69)
are built on cream/white paper cards and a yellow sticky - the old paper look the theme still carried.

## 3. What was changed (branch `onelook1`, worktree E:/FightCamp/wt/LEAN_ONELOOK1 - not merged before his OK)

1. **One wall, one exposure.** `Palette.WALL_EXPOSURE` (0.68, the approved S412 value) for every career page; the
   Overview's 0.30 and the bout page's 1.00 are gone (the bout page keeps its red-and-blue picture - it is as bright a
   picture as the gym, 44 vs 46). The office keeps its desk.
2. **One house kit: `scripts/ui/HouseKit.gd`** (new, split out of UI.gd - UI.gd 499 -> 309 lines). Cards, boards, tins,
   modals = the framed slate; buttons = the wooden pieces; and every flat piece on Palette tokens only: a note is a
   dark tile with a coloured left edge (no more yellow paper sticky), a picture mount is a dark card (no white
   polaroid), drop-downs, pickers and text boxes are dark plates with chalk words and the tan edge for "you are on it",
   chips are see-through dark tags with their colour on the left edge. Fonts by job, written down in the kit: brush
   (Permanent Marker) for page titles 28 px+, Barlow for everything else, Kalam only for the coach's handwriting.
3. **UI.gd's old paper names now point at tokens** (a cream card = the slate, a tan plate = dark wood); the page-wide
   ink pass already turns paper ink to chalk on dark, so words follow.
4. **The coach's whiteboard is a slate** (WhiteboardKit: chalk on a wood-framed slate, red chalk for risk).
5. **Every loose colour in the menus and the fight HUD on the palette** (`tools/palette_sweep.py`: nearest token by
   hue first, then strength, then lightness - a grey stays a grey, a blue stays the blue; see-through amounts kept;
   a white used as a tint becomes `Palette.FULL`, no tint). Named tables moved INTO Palette instead of being recoloured:
   the BJJ belts (real belt colours), the light-plate inks (words on a tan tab). Qwen's ONELOOK2 (PR 327, the fight
   HUD bars) is folded in; its 8 leftovers went onto existing tokens (liver flash = bad fill to bad words; the three
   shout washes = the good / gold / bad word colours; the call line = bad words).
6. **Guard:** `tests/palette_guard_test.gd` baseline rewritten (see 4); the 3D scene files (ring, ropes, lights,
   referee, corner crew, face cuts) are exempt as depiction, not menu chrome.

## 4. After: the numbers (same tool, same test club)

**The brightness band.** Every career page now sits on the same wall at the same exposure (0.68). Whole-screen mean
brightness of the career pages (title and the 3D gym home left out - they are pictures, not pages):

| | Medium text | Largest text (his setting) |
|---|---|---|
| before | 32 - 109 (median 46) | 35 - 130 (median 48) |
| after | **32 - 54** (median 45) | **35 - 59** (median 48) |

What still moves a page inside 32-54 is how much of the wall its cards cover (World news, mostly wall: 32; Money and
Training, mostly cards: 53-54) - not a different light. Biggest moves: Playbook Plans 109 -> 42, Combos 70 -> 44, Fight
prep 69 -> 50, the fighter Overviews 41 -> 45 (their wall was at 0.30).

**Off-palette words and fills** (the census, Medium): 14 of 23 career pages at 0 (was 0 of 23). What remains: the
Overview's attribute band colours drawn lighter (18), the Training tab (16, left for Training K), the light-plate inks on
the tan tabs (named in Palette), the BJJ belts (named in Palette).

**Code:** loose colours 690 -> 73 in the guard; of the 73, 61 are in the Training tab files (Training K) and FightStage
(fight motion week), 12 are icon masks / a 3D light. UI.gd 499 -> 309 lines. Tests touched by the change: 48 run, all
pass except camp_cards_test and gauges_test, which already fail on main's nightly (same lines).

**Text fit at Largest:** 1 overflow ("Step out" on Playbook Plans, 88 px in a 76 px button) - the same one as before.

Stills: `E:/FightCamp/tmp/onelook1/{before,after}_t1|t3/` (25 pages each), side-by-side sheets
`ONELOOK1_before_after_text1_*.jpg` / `_text3_*.jpg`, the fight HUD `fight_compare.jpg` (fight3d_play seed 7).

## 5. What is left (not in this pass)

- **The Training tab / Training K and WeekCards.gd** - the main session is rebuilding them (Training K v6c, his Q-259
  yes); they are untouched here and restyled with the kit once they land. WeekCards' attribute tile colours stay there.
- FightStage.gd (fight motion week, not to be touched): 8 colours.
- SVG icon masks (white strokes tinted at draw time: Icons, KitIcon, ReactionBubbles) and one 3D ambient light
  (VersusLive) are counted by the guard but are not screen colours.
- Hand-made boxes: their COLOURS are on the palette now, but 227 boxes are still drawn per page instead of named kit
  pieces. Worst: the Office (88 on one page), Money (38), Home (33). Next pass: one Grok Dev task per page, moving each
  box onto a named HouseKit piece (Card / Tile / Note / Chip), worst first.
- Type sizes: the Overview uses 14 sizes. (Money's 11 px is the number inside a 16 px dot on the cash chart, a marker.)
  Next pass: a type scale in HouseKit (16 / 19 / 24 / 32 / 52) and a guard like the palette's.

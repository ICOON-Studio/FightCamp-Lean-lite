# Gym palette (S490)

Operator: "do we have a colour pallete ? i see some menus lookdifferent than others".

Short answer: there is one on paper (`scripts/ui/UI.gd`, about 30 colours, plus 4 chalk inks in `WoodKit.gd`). But 136 of the
314 menu and HUD scripts write their own colours: about 280 other values in 11 look families (see `INVENTORY.md`).
That is why some menus look different.

This proposal picks **one palette of 19 colours from the main gym screen**, plus 3 named shade rules (operator S430: "i want the main
gym screen as designed unchanged so the whole design should match"). Wood, slate, planks, buttons and the backdrop stay the
game's own textures. Source still: `docs/playtest/S480/layout/05_gym_staff_real.png`.

Files here (open the PNGs in this order):
- `problem.png` - **the problem**: eight real screens from the game today, each tagged with the colour family that paints it, and the
  same job drawn in 7 to 22 colours.
- `palette.png` - **the palette**: every colour, its job, its hex, its contrast, a strip of the gym screen it came from, the
  colour-blind check and the near-neighbour check.
- `match.png` - **do they match now?**: the real gym screen beside the recoloured Overview and Training, half size, readable.
- `before_after.png` - each drifting screen as it is today beside its redraw, with what changed.
- `overview_after.*`, `training_after.*` - the two redraws at full 1920x1080. `look.css` holds the palette as tokens.
- `INVENTORY.md`, `inventory.html/png` - the colour census this is built on.

No game code was changed.

## The palette

Contrast is the WCAG ratio. Words need 4.5:1; bars, edges and icons need 3:1. "Card" is the slate (2), "tile" is a box inside a card
(3). Every ratio is quoted against the surface the thing really sits on.

| # | Job | Hex | Picked from on the gym screen | Contrast |
|---|-----|-----|-------------------------------|----------|
| 1 | Page / top bar / sunk slot | `#1a1512` | the top bar | text 14.1, muted 7.1; also every empty bar track and pip slot |
| 2 | Card background (slate) | `#242728` | slate inside the "Sam Carter" card | text 11.8, muted 5.9 |
| 3 | Tile / row inside a card | `#353635` | the "$450 wage a week" tiles | text 9.5, muted 4.8 |
| 4 | Hover card / message | `#2b241d` | the bottom message "Lucy signed..." | text 12.0, muted 6.0 |
| 5 | Wood frame | `#4c362a` | the card frames (the texture's base) | edge only; on screen the frame is the texture |
| 6 | Line | `#4c4b45` | tile edges, the old bar track | decoration only; the rim of a track, never the track |
| 7 | Text | `#eee2ce` | coach names, row words, "+58% gain" | see 1-4 |
| 8 | Muted text | `#b1a084` | "Versus no coach", "wage a week" | card 5.9, tile 4.8 |
| 9 | Header / money | `#e6bd55` | the cash "$17,200" | card 8.4, tile 6.8 |
| 10 | Accent / your side (blue) | `#6fa0e6` | the club name "Anvil Street Gym" (`#6d9fe6`, +1% to pass on a tile) | card 5.6, tile 4.5 |
| 11 | Good / gained, words | `#2cb56f` | the gym's green words "+$350 evening classes", "+30% moves", "+88% gain", "Best at", "Easier weight cuts" (all `#239058`), lightened | card 5.7, tile 4.6 (the gym's `#239058`: tile **3.0**, card 3.7) |
| 12 | Bad / lost, words | `#ff7a66` | the red words "-$100", "-$740 net a week" (`#df4639`), lightened | card 5.9, tile 4.8 (the gym's `#df4639`: tile **2.9**, card 3.6) |
| 13 | Main action button | `#991d1c` | the red "Hire" (`red.png`, mean `#8f1d1c`) | text on it 6.4 |
| 14 | Needs you / warning | `#cf9245` | the NEEDS YOU button (`#cd8e3f`, +1%) | dark text on it 6.8; as words: card 5.6, tile 4.5 |
| 15 | Second button | `#442f24` | the dark wood "Hire" buttons (`plank.png`) | text on it 9.8 |
| 16 | Chosen / selected | `#c8a585` | the "People" tab (`tab_on.png`, mean `#c7a085`) | dark text on it 7.9; as an edge: card 6.6, tile 5.3 |
| 17 | Good bar / fill | `#239058` | the coach "Best at" bars | card 3.7; against its Page track 4.5 |
| 18 | Bad bar / fill | `#df4639` | the red of "-$740" | card 3.6; against its Page track 4.4 |
| 19 | Elite (purple) | `#b08eea` | not on the gym screen: made at the blue's brightness | card 5.7, tile 4.6 |

### Jobs that look alike, told apart

- **Bad (12, 18)** = something was lost or hurts: a loss, a cost, damage, the Weak band. Always with a &#9660; or a - sign.
- **Needs you / warning (14)** = something waits on you or a limit is close: a fighter approached by another club, an answer by
  Monday, tiredness near 80, NEEDS YOU. Always with &#9888;. Nothing is lost yet; acting now prevents the loss. (There is no
  separate "Alert" colour: an alert is a warning.)
- **Main action (13)** = the one button a card wants pressed (Hire, Sign, Book, CONTINUE). A button, never a label or a chip.
- **Chosen / selected (16)** = what you are on. A tab or option is tan wood (`tab_on.png`); a chosen card, day, boxer or panel gets a
  3 px tan edge **and** a &#10003; corner tick. Gold (9) is never selection; Accent (10) is your side and your edits (&#9998;), never
  selection.
- **Header (9)** = words and numbers only: card titles, money, the 0-100 ring. Never a fill.

### Attribute bands

The same values, low to high, everywhere (attributes, move tiers, body bands):

| Band | Colour | Pips lit | On a card / tile / with its outline | Move tier on the same step |
|------|--------|----------|-------------------------------------|----------------------------|
| Weak | 18 `#df4639` | 1 | 3.6 / 2.9 / 4.4 | (none; Unlearned = 0 pips) |
| Fair | 14 `#cf9245` | 2 | 5.6 / 4.5 / 6.8 | Raw |
| Solid | 10 `#6fa0e6` | 3 | 5.6 / 4.5 / 6.8 | Usable (today green) |
| Strong | 17 `#239058` | 4 | 3.7 / 3.0 / 4.5 | Sharp (today blue) |
| Elite | 19 `#b08eea` | 5 | 5.7 / 4.6 / 6.8 | Signature |

Every lit pip has a 1 px Page outline, so Weak and Strong read 4.4 and 4.5:1 wherever they sit (on a tile alone they would be 2.9
and 3.0). An empty pip slot is sunk Page with a Line rim, like a bar track.

### Bars and their tracks

The gym's bars sit on a `#4c4b45` track. Its cream bars are fine there, but its green "Best at" bar is **2.2:1** against that track,
and a red bar would be **2.1:1** (bars need 3). In the palette a track is **Page (1), sunk, with a 1 px Line rim**: good fill to
track 4.5, bad 4.4, accent 6.8. The track itself is 1.2:1 against the card, which is fine for decoration: what must read is where the
fill ends, and every bar also carries its number.

### Shade rules and textures (why 19 is the whole list)

`look.css` and `Palette.gd` write only the 19 hex values. Everything else is one of these:

| Kind | Rule | In Godot | Used for |
|---|---|---|---|
| Shadow | Page at 60% alpha | `Color(PAGE, 0.6)` | drop shadows under frames, bars, buttons |
| Dim | Page at 50% alpha over the backdrop | `Color(PAGE, 0.5)` (the game keeps `MenuFx.WALL_DIM`, moved into Palette as a named multiplier) | the gym photo behind every page |
| Sunk | token blended 40% toward Page | `x.lerp(PAGE, 0.4)` | the hatched "0 to +2" stripe (`#4d6891` from Accent), pressed states |
| Textures | WoodKit's own pieces, never a colour | `panel.png`, `bar.png`, `plank.png`, `tab.png`, `tab_on.png`, `red.png`, `gym_backdrop.jpg` | wood frame, brass corners, slate, top bar, every button |
| Button states | WoodKit's existing multipliers | hover x1.18, pressed x0.78, disabled alpha 0.42 | named constants in Palette.gd |

The first version's `look.css` drew wood with about 20 raw values (`#6a4a36`, `#4f372a`, `#e2c6a7`, `#ad2a25`...). Those are gone: the
redraws now use the real textures, so the planks, rivets, bevels and brass come from the art, as they do in the game.

### Colour-blind safety

Red and green read as the same olive for deuteranopes and protanopes, and the good and bad words are the same grey (L* 66 and 67). So
colour never carries the meaning alone:
- a gain always has a &#9650; or a + sign, a loss a &#9660; or a - sign, a warning a &#9888;, a chosen thing a &#10003; corner;
- a band always shows 1 to 5 lit pips (Strong and Weak differ by count, not only hue);
- the number itself is in Text (7), so it reads the same for everyone.

### Near neighbours: gold, amber, tan

The first version had five yellow-orange jobs (header gold, needs-you amber, the Fair band, chosen tan, and a gold selection edge).
Selection left gold, so three remain. Measured: gold L* 78, amber 65, tan 70 in grey; gold to amber is 14.6 apart for a deuteranope
(19.6 normal), amber to tan only 4.9 L* apart in grey but 27.8 apart in colour. None of them is ever told by colour alone: gold is
only ever words, numbers and the ring; amber always comes with &#9888; or 2 pips; tan always comes with the tan wood texture or a
3 px edge and a &#10003;. `palette.png` shows the three in normal sight, in grey and as a deuteranope sees them.

### Four spots on the gym screen below the bar (your call)

The gym screen stays as it is unless you say otherwise. Measured on it today, on the surface each sits on:
- green words "+$350 evening classes" on their tile: **3.0:1**; red words "-$100", "-$740" on their tiles: **2.9:1** (words need 4.5).
  "Best at", "+30% moves", "Easier weight cuts" on the card: 3.7:1;
- white words on the amber NEEDS YOU button: **2.7:1**;
- the green "Best at" bar against its `#4c4b45` track: **2.2:1** (bars need 3).

The palette lightens the words (11, 12), puts dark text on amber (14) and sinks bar tracks to Page. The gym's own bars keep their
colours.

## What each look family changes

| Family (INVENTORY.md) | Files | Today | In the palette |
|---|---|---|---|
| A. Cream paper constants | UI.gd and every UI.X user | paper inks named for the S332 whiteboard; GOLD is blue `#27589e` | names say the job (ACCENT, HEADER, GOOD...), values from the table; WoodKit's run-time ink swap goes away |
| B. Wood and slate chalk | WoodKit, FirstWeekStrip, Halo, PlanChart, GamePlan, DuesBoards... | 4 inks, each file picks its own good/bad | no visible change to the base; good/bad/warn/gold come from the palette |
| C. Fight broadcast brown-gold | TV.gd + 34 importers (result tabs, aftermath tiles, corner swap cards, body tips, headline card) | its own green `#6cc27a`, red `#e0503c`, gold `#e9b84a` | menus take the palette; TV.gd keeps only what draws over the 3D fight, built from the same 19 |
| D. Dark Overview | DarkOverview, ApproachCard, Tally, TapeVersus | own bands, yellow headers `#ffd54a`, a red offer title | bands + pips from the table, headers gold, the offer is a warning (amber, &#9888;) |
| E. Whiteboard navy marker | Tips, WhiteboardKit, WeekStrip, WeekCards, MatchupCards, DrillCard | navy ink `#1f2a44` on paper | hover cards become 4 with Text; the whiteboard leftovers move to slate |
| F. Warm paper cards | RosterCards, HomeNeeds, DuesWire, Interview, FightPoster | near-UI paper and inks, never equal | slate cards; the fight poster and the interview polaroid may keep paper as artwork |
| G. Office desktop navy | Office.gd | 27 colours of its own, no UI colour constants, cool blue-black | page, card, tile, text: the one screen with no brown becomes the gym |
| H. BJJ charcoal and yellow | MatMap, MatTree, MatGlyph, GrapplerPage, MatPlayer | neutral charcoal, yellow `#ffd54a` | slate and gold; "your move" = accent, "opponent" = bad |
| I. Navy glass | GymHub, GymEquip, HomeCorners, TitleScreen | navy see-through plates | page colour at the same transparency |
| J. 3D fight HUD | ScoreBug, RoundBoard, CornerBar, HudRegroup, Broadcast... | 4 reds and 5 blues for the corners | red corner = 18, blue corner = 10, one each |
| K. Iso gym map | IsoGym.gd | room-map colours | may stay (a map, not a menu) |
| L. 3D materials | RingSet, FightStage, ArtStyle... | material tints | not part of the menu palette, left alone |

The Training screen (`docs/mockups/s483/training_k.png`) is a design, not built yet, drawn in its own navy simulator look. Whatever
builds it takes the palette; the redraw shows the same layout in the gym's look, with the wood frame drawn at 60% because the screen
is dense (WoodKit would need a half-size pack of the same piece from `tools/wood_kit_pack.py`). Two taste calls in it: the seven
session-type ring colours and the four phase-chip colours are dropped (the label names the type), and the coach slices show the
chosen boxer in tan, the others in slate with their face, instead of a colour per boxer.

## Order to move the screens (worst first)

1. Make the one palette file (below). UI.gd and WoodKit.gd point at it, so every file already on UI.X follows at once.
2. Office.gd - the one screen with nothing warm (27 own colours, no UI colour constants).
3. TV.gd importers that are menus: ResultTabs, AftermathTiles, MatchStats, CornerSwapCards, SwapLink, HeadlineCard, BodyTip,
   BodyFigure, RecoverCards, CallButtons.
4. DarkOverview, ApproachCard, Tally, TapeVersus - the fighter Overview (bands disagree with AttrBoard, the offer is red).
5. Tips.gd and the whiteboard leftovers (WeekStrip, WeekCards, MatchupCards, DrillCard) - the hover card players see most.
6. RosterCards, HomeNeeds, DuesWire, Interview.
7. BJJ screens: MatMap, MatTree, MatGlyph, GrapplerPage, MatPlayer.
8. Fight HUD overlays (J), then the navy glass plates (I).
9. ComboStrip / MoveBook / MoveTip move tiers (green and blue swap to the band order).

## The rule proposed

Every screen colour comes from one file, `scripts/ui/Palette.gd`: the 19 colours, the 3 shade rules (as functions), the button-state
and wall multipliers, the band table and the move-tier table, all named by job. No other menu or HUD script writes a colour value;
wood, slate and buttons stay WoodKit textures.

A test enforces it: `tests/palette_guard_test.gd` reads every `.gd` under `scripts/ui` and `scripts/fight3d` (3D material files in
family L exempt, and Palette.gd itself) and counts raw colours (`Color("#...")`, `Color(r, g, b)`, `Color.html(...)`, hex strings). It
fails when a file has more raw colours than its line in a baseline list, or when a new file has any. The baseline starts at today's
counts and only goes down as screens move, so the work can be done one screen at a time and no new raw colour gets in.

## Review round

A fresh reviewer scored the first version 7/10. What was changed for each point:

Must fix:
- **Wrong source for the good-words colour.** Fixed. "+58% gain" is cream `#eee2ce` (now listed under Text, row 7). Row 11 now names
  the gym's real green words ("+$350 evening classes", "+30% moves", "+88% gain", "Best at", "Easier weight cuts", `#239058`); the
  swatch strip on `palette.png` now shows "+88% gain" and the "+$350 evening classes" tile; the "below the bar" text is rewritten.
- **"Below the bar" contrast understated.** Fixed. The README and the sheet now quote the tile values where the words sit:
  green 3.0:1 and red 2.9:1 (3.7 and 3.6 are the card values, kept only for "Best at" and the card words).
- **"Selected" had two values.** Fixed by drawing selection in tan only: row 16 is now "Chosen / selected", a tab is tan wood, a
  chosen card, day or panel gets a 3 px tan edge plus a &#10003; tick. The gold edges in the Training redraw (Kwame, Friday, YOURS 70,
  the Friday-evening panel, Kwame's coach slices) are now tan. Accent no longer claims "selected row".
- **Warning and bad mixed on the Overview.** Fixed. The offer title is amber with &#9888; and APPROACHED is an amber chip with dark
  text; WEEK REVIEW is a plain wooden button. "Jobs that look alike, told apart" defines Bad vs Needs you vs Main action (no
  separate Alert colour).
- **About 20 raw hex in look.css.** Fixed. The wood, planks, bevels, brass studs and page gradient are now the game's own textures
  (`panel.png`, `bar.png`, `plank.png`, `tab.png`, `tab_on.png`, `red.png`, `gym_backdrop.jpg`); the only remaining non-token values
  are the 3 named shade rules (`color-mix` of a token, the same as Godot `Color(PAGE, a)` and `lerp(PAGE, 0.4)`). `look.css`,
  `overview_after.html` and `training_after.html` hold no other hex.
- **Bar contrast against its own track.** Fixed. Reported (the gym's green bar on `#4c4b45` is 2.2:1) and the palette's track is
  now sunk Page: good 4.5, bad 4.4. Weak and Strong pips get a 1 px Page outline: 4.4 and 4.5 on any surface.

To 10:
- **"Do they match now?" in one look.** Added `match.png`: the real gym screen beside the two recoloured screens at half size, each
  readable. Added `problem.png`: eight real screens (gym, Office, Overview, result page, headline card, between rounds, interview,
  the Training design), each tagged with its family (G navy, D dark Overview, C TV brown-gold, J fight HUD, F warm paper), plus a
  "same job, different colour" strip.
- **Real wood frame and photo backdrop.** Done: every redraw uses WoodKit's `panel.png` (52 px brass corners, planked frame,
  scratched slate), `bar.png` for the top bar, the wooden button pieces, and `gym_backdrop.jpg` dimmed behind, as the game does.
- **Shrink the yellow-orange family.** Five became three (selection left gold), checked in grey and as a deuteranope on
  `palette.png`, and selection has its non-colour cue (3 px edge + &#10003; corner).

Not done in this round: the gym screen itself is unchanged (its four spots below the bar are listed for your call), and no game code
was touched.

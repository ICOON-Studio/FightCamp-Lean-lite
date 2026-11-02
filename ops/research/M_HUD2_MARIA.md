bot  Maria Art Director
    3f79879d-48e0-4c2a-817f-acc56ee34d0e

[send-message t32s313] The research and mocks for M32 are underway now. The "before" mocks will be built from the real screen code and live tokens wherever I can find them. If a screen has no screenshot, I'll label its "before" as a reconstruction.

When it's done, you'll get the full memo text here with both mock images, and the same files will be on Beast for Claude.
[send-message t32s314] M32, The Menu Look, has shipped. The art direction guide and before/after boards for the gym creation screen and THE DAY are staged on Beast in `_maria_delivery\` and `research\`. I also messaged Claude with the paths and what to use for the S78 build (message id `cb4f7751f92a`).

The research says big studios get menus to look finished by writing a rule set first and then cutting against it. Our menus look like placeholders for four reasons I found in the code:
1. Every string is either upper-cased monospace or Bebas Neue, which only has capitals.
2. Labels are about 8 px tall, well under the Xbox accessibility minimum of 18 px.
3. Every panel has the same weight and a coloured header bar.
4. Developer sentences are shown to players, like "…780 MS" and "GOLD IS ILLEGAL UNTIL IT HAS ONE".

The fix builds on what we already have instead of replacing it:
• **Colour:** keep the blue-grey. The only colour changes are for contrast. Continue text becomes dark on the green (8.1:1, up from 2.3:1), and the rail's active item uses the gym colour so gold is only the one main action.
• **Type:** Inter for all text, in sentence case, with numbers that line up in columns. Bebas appears at most once per screen, at 44 px or larger. Monospace is gone from anything players read.
• **Panels:** three levels plus one highlighted hero card per screen. No header bars, and corners go from 3 px to 8 px.
• **Density:** at most one hero and three groups per screen. Every number gets a label, unit or comparison. An empty area becomes one line with one action, never a dark slot.
• **Imagery:** silhouette portraits instead of initials, one line-icon set, and top-down drawings of equipment.

A few things need checking or a decision:
• The "before" sides are rebuilt from the live code at commit `2662c01`, not screenshots.
• I found a bug in the code that I haven't seen on screen yet. The top bar's day strip is 60 px wider than its layout assumes, so the Continue unit probably covers part of Saturday and Sunday. Claude should check this on a running build.
• It's not confirmed that Godot 4.7.2 can line up numbers in columns in Inter.
• The Hearthstone talk is from GDC 2015, not 2014 as the brief said.
• I found no Overwatch menu talk and no first-party EA FC case study, so the evidence uses Diablo IV and UFC 5 instead.
• All the text on the "after" boards is example text; the final words are Kalli's.
• The biggest risk is that this looks like office software rather than a boxing game. Football Manager 26 got exactly that criticism. So please judge the "after" boards on feel, not just clarity.
• The weakest point is the portrait plan, because 30 identical silhouettes would be their own kind of placeholder.

The full guide text follows below.
[send-message t32s315] **M32_MENU_ART_DIRECTION.md, part 1 of 2 (sections 0–6)**

# M32: The menu look. How Blizzard, EA and Sega make menus feel finished

Maria (art direction) · 2026-09-25 · FightCamp (Godot 4.7.2, 1920×1080) · ART ONLY. No .gd/.tscn edits. Copy belongs to Kalli: every string in this file and on the boards is **EXAMPLE** unless it is quoted from code.

**Number tags.** Every number in this file carries one of these tags:
- **[S: link]** SOURCED. Taken from a public source or from repo code at HEAD `2662c01`. "(computed)" means I worked it out from a sourced formula or asset, e.g. a WCAG contrast ratio or glyph metrics measured from the shipped font files.
- **[P: from X]** PROXY. Carried over from a comparable source, which is named.
- **[J: reason]** JUDGEMENT. Maria's call, with a one-line reason.

Repo shorthand: `UT` = Godot/scripts/UITokens.gd, `UK` = UIKit.gd, `SC` = ShellChrome.gd, `DFP` = DayFeedPanel.gd, `CFP` = CreationFlowPanel.gd, `CC` = CreationChrome.gd, all under https://github.com/Guru-Meditation/FightCamp/tree/master/Godot/scripts

## 0. The short answer (read this if nothing else)

The big studios don't get a "perfect" menu from talent alone. They follow a **written rule set** and then run a **subtraction pass** against it. Our menus look like placeholders for four measurable reasons found in the live code:

1. **All text is in caps, and most of it is in a monospace font.** `UIKit.caps()` upper-cases every string and sets it in IBM Plex Mono 12 px. `display()` sets everything else in Bebas Neue, which only has capital letters [S: UK]. So no line of text in the game is set in ordinary sentence case.
2. **The text is below the accessibility floor.** A 12 px caps label has a body height of about 8.4 px [S: computed from IBMPlexMono-Medium cap-height 0.698 em]. Xbox's accessibility guideline asks for at least **18 px body height at 1080p on PC** [S: https://learn.microsoft.com/en-us/gaming/accessibility/Xbox-accessibility-guidelines/101].
3. **Every panel has the same weight and a coloured header bar.** The kit's own comment calls `header_bar` "the single most repeated surface … most of why the screens read as a wireframe" [S: UK header_bar comment]. The elevation ladder already exists (`SUNK…HERO`) but screens don't spend it unevenly [S: UT].
4. **Developer sentences are shown to players.** Examples on screen today: "GOLD OPENS THE GYM · THE SHELL LOCKS ON THE OTHER SIDE · 780 MS" and "A GYM NEEDS A NAME · GOLD IS ILLEGAL UNTIL IT HAS ONE" [S: CC STEP_FRAMES; CFP frame_for_chrome].

The fix is a **delta** on our current world, not a new one. Keep the lit blue-grey ground, the gym-colour ladder, gold for the single primary action and green for Continue only. Change four things: the type system (Inter for text, sentence case), the surfaces (3 levels plus 1 hero, no header bars), density (1 hero plus up to 3 groups), and imagery (silhouette portraits and line icons instead of initials and dark slots).

## 1. What a human AD would do (process)

| Step | What the studios actually do | Source |
|---|---|---|
| **1. Seed / pillar** | Hearthstone started from one "seed", a physical magic box. Every screen was judged against it, and the team rejected flat design because the game had to feel tactile and valuable. EA UFC 5 had the pillar "Beautiful Violence", and the interface designer's job was to "distil this aesthetic into practical UI applications". | Sakamoto, GDC **2015** (the brief said 2014) [S: https://archive.org/details/GDC2015Sakamoto]. UFC 5 style guide by Sherman Tam [S: https://www.shermantam.com/projects/ufc-5-style-guide] |
| **2. Style guide before screens** | UFC 5 wrote its style guide in pre-production: buttons, widgets, type, icons and colour came before feature screens. FM26 set three principles (Efficiency, Familiarity, Predictability) and fixed "unreadable font sizes" and colour contrast as an explicit goal. | [S: shermantam.com] [S: https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface] |
| **3. Pipeline with gates** | Creative Assembly runs a **9-phase** UI pipeline for Total War: brief, prototype, test, implement, with documentation throughout. Small tasks such as a set of 48×48 icons skip the full pipeline. | Tokmakchiev [S: https://www.youtube.com/watch?v=MSoW-8xkaQs] |
| **4. Overview then detail** | FM26: "Overview screens provide you with key general information early and often, with more detailed information available when you explore". Tiles open into Cards. NN/g: generally no more than **2** disclosure levels. | [S: FM26] [S: https://www.nngroup.com/articles/progressive-disclosure/] |
| **5. Wireframe, 2D, then 3D polish** | Hearthstone kept wireframes "back of the napkin" and iterated with 2D art; 3D came in only once requirements were right. A third of the early team worked on UI. | [S: Sakamoto transcript] |
| **6. Icon and state clarity** | Diablo IV found painterly icons read badly small, switched to model-based icons, toned down background saturation and **added a border cue for rarity** so colour doesn't carry it alone. | Del Priore, Feb 2020 [S: https://news.blizzard.com/en-us/article/23308274/diablo-iv-quarterly-updatefebruary-2020] |
| **7. Sound as hierarchy** | Firaxis (Civ VII) sorted UI sounds by frequency and importance. Frequent sounds are short and simple; the confirm sound is a short punchy hit. They reworked **80+** notification sounds across **20** categories. | [S: https://www.asoundeffect.com/civilization-vii-game-audio/] |
| **8. Playtest and act** | CA's Troy End Turn button went through player testing; notifications moved into a to-do list and the hourglass became a "next" arrow. | [S: gamedeveloper.com Troy deep dive] |
| **9. Hear the backlash** | SI admitted the FM26 UI "wasn't well received by everyone … loss of immersion". Their next priority is immersion. | [S: https://www.footballmanager.com/news/return-international-management-and-review-fm26] |

**FightCamp version of the process** [J: sized to a two-agent art/words team plus Claude building]:
1. Seed: **"a working boxing gym at 6 a.m.": chalk, tape, worn leather, one bright light over the ring**. Blue-grey steel stays; gold is the championship metal; the gym colour is the club's own paint.
2. Style guide (section 7), then freeze it for S78.
3. Hierarchy pass on each screen: name the ONE hero, cut to 3 groups or fewer, move the rest into tooltips or second panels.
4. Density budget check (7.9), run as a checklist by Claude before any screen lands.
5. Iconography and portrait pass (section 5).
6. Motion and sound pass (section 6).
7. Playtest: 5 operator sessions on the new-career flow and THE DAY, timed on "find the thing that needs me" [P: NN/g 5-user heuristic].

## 2. Q1: Hierarchy and density

- **Focal elements per screen: 1 hero**, holding the only gold action. DayFeedPanel already states "GOLD IS ONE PER BOARD" [S: DFP]; the problem is everything around it is drawn at the same weight.
- **Secondary groups: 3 or fewer** [J: 1+3 fits the 1494×846 content area at 18 px body without scrolling; the THE DAY mock proves it].
- **Visible rows per group: 7 or fewer**, then "View all" [J; FM tiles show about 5, P: not measured].
- **Prose per panel: 2 lines or fewer** at 18 px [J].
- **Moves to tooltips or second panels:** formulas, histories, the 7-day calendar ("Today only; the week is SCHEDULE" [S: DFP]), per-stat breakdowns, anything a first-week player never uses. At most **2** disclosure levels [S: NN/g].
- **How FM keeps dense data readable:** overview first, detail on click; one nav bar with **6** categories; up to **12** bookmarks on high-res screens; readable sizes and contrast as explicit goals [S: FM26 pages]. The backlash shows a productivity-tool look without immersion gets punished.

## 3. Q2: Typography

- **Typefaces: 2** [J]. **Text: Inter** (OFL, has `tnum` [S: https://rsms.me/inter/]). **Display: Bebas Neue** (already shipped), 1 use per screen at 44 px or larger.
- **IBM Plex Mono leaves text.** Monospace widens words, slows reading and makes caps look like a terminal [J: that's the placeholder look]. Aligned numbers come from **tabular figures** in the proportional face [S: MDN font-variant-numeric]. In Godot: OpenType `tnum` on a FontVariation [J: not verified in 4.7.2].
- **Uppercase:** NN/g finds caps help glanceable 1–2-word labels but hurt titles and sentences [S: https://www.nngroup.com/articles/glanceable-fonts/]. Rule: **caps only for eyebrows of 24 characters or fewer, tracked +1 px** [J]. Everything else is sentence case.
- **Sizes: 6 steps, at most 5 per screen.** Floor **15 px** Inter (about 14 px body height [S: computed, Inter 0.932 em]). Body **18 px**. Full XAG PC compliance needs about 20 px body [S: computed], so add a **text-size option of 100 / 115 / 130 %** [J].
- **Live floor for comparison:** SIZE_LABEL 12, SIZE_BODY 13 [S: UT], about 8.4 px body height for the caps actually drawn [S: computed].

## 4. Q3: Colour and surfaces

- **Elevation on dark ground uses light, not shadow** (our tokens already say so [S: UT]). Use **3 levels plus 1 hero** instead of 5 tiers [J]:
  - **Sunk** = TRACK `#111621`: inputs, bar tracks, the floor board.
  - **Resting** = PANEL `#2a3347` + 1 px white rim at 7 % + soft shadow: ordinary cards.
  - **Lifted** = PANEL_HI `#34405a` + 12 % rim: commit card, hover, popovers.
  - **Hero** = gradient from the gym colour darkened 38 % to PANEL, gym-tinted rim at 35 %. **One per screen.**
  - **No coloured header bars.** Group titles become 22 px text on the card.
- **Accents:** gym colour marks selection and navigation. **Gold = the one primary action + the belt only.** Green = Continue only [S: UT].
- **Contrast fixes** (WCAG formula, AA 4.5:1 [S: W3C]):
  - MUTED `#94a1b8` is 4.84:1 on PANEL but 3.97:1 on PANEL_HI. **Lifted to `#a3afc4`**: 5.7:1 and 4.68:1.
  - DIM `#6d7688` on PANEL is 2.76:1. **DIM is disabled-only.**
  - White on GO `#22c55e` is 2.28:1. **Continue text becomes INK `#1b1207`: 8.11:1.**
  - BAD `#e5433a` as text is 3.12:1. **Add BAD_TEXT `#f2766f` = 4.57:1**; BAD stays for fills and glyphs.
- **State colouring, never hue-only** (WCAG 1.4.1; Diablo IV border cue):

| State | Fill | 2nd channel | Example |
|---|---|---|---|
| Good | GOOD `#4fc46a` | ✓ glyph + word | "✓ Good as new" |
| Warning | AMBER `#f0a020` | ▲ glyph + number | "▲ Worn · 72%" |
| Bad / blocking | BAD_TEXT / BAD | lock or flame glyph + word | "🔒 Blocks Continue", "Heating" |
| Locked | DIM text | lock glyph + hatch | n/a |
| New | gym-tint dot | "New" in caps | n/a |
| Needs you | AMBER pill | number in the pill | rail badge "1", "2" |

## 5. Q4: Imagery on a small-studio budget

| Asset | Recommendation | Cost | Licence |
|---|---|---|---|
| **Fighter portraits** | **Silhouette discs now** (gym-tinted for ours, slate for others). **Later**: procedural 2D portraits from 6–10 layered parts [J], or an offline 3D bust render from the existing fighter rig (`CCFighterSkin.gd`) at 256² [J]. | Silhouette ~0 [J]. Procedural 1–2 art weeks [J]. | Own art |
| **UI icons** | **Lucide** (ISC) or **Phosphor** (MIT). Pick ONE; 2 px stroke at 24 px [J]. | 0 | Keep licence text in credits |
| **Sport icons** | **game-icons.net**, **CC BY 3.0**, credit required [S: game-icons.net/faq]. Re-stroke to 2 px or use only at 40 px and up [J]. | 0 + credits | CC BY 3.0 |
| **Equipment drawings** | Top-down floor-plan drawings, readable at 80 px cells [J]. | ~1 art week for 20 items [J] | Own art |
| **Backgrounds** | Hero cards get one faint ropes motif (3–6 % white). No photos behind data [J]. | 0 | Own art |
| **Generated art** | Concept exploration and backgrounds only; final portraits and icons must be owned or clearly licensed [J]. | varies | NOT COMPUTED |

Reference library: **Game UI Database** [S: https://www.gameuidatabase.com/].

## 6. Q5: Motion and sound

Yardsticks: Material 3 duration tokens [S: M3 Motion.md] and the NN/g **0.1 s** "instant" limit [S: NN/g].

| Event | Timing | Curve | Tag |
|---|---|---|---|
| Hover in | **100 ms** | standard `cubic-bezier(0.2,0,0,1)` | [S: M3 Short2] |
| Hover out | **150 ms** | standard | [S: M3 Short3] |
| Press / release | **50 / 100 ms**, scale 0.98 | linear / standard | [S: M3; scale J] |
| Selection change | **160 ms** indicator slide | emphasized decelerate `0.05,0.7,0.1,1` | [S: M3 easing; 160 J] |
| Panel open | **200 ms**, 24 px slide + opacity on the panel only | emphasized decelerate | [S: M3 Short4] |
| Screen change | **240 ms**, content slides from 32 px; shell stays still | emphasized decelerate | [J] |
| Tooltip | **400 ms** delay, **100 ms** in | standard | [J] |
| Number change | count-up **≤ 300 ms**, only on change | standard | [S: M3 Medium2 ceiling] |
| Continue, day advance | **240 ms** | emphasized | [J] |
| Pulse / throb | **never** | none | standing law |

Sound [J unless tagged; structure from Firaxis's frequency × importance matrix]:
- **Hover: silent.**
- **Click: one soft tactile tick, ≤ 60 ms**, leather or tape foley.
- **Confirm (gold): one short hit, ≤ 250 ms**, glove-on-pad thump plus a small high layer.
- **Continue: a distinct bell tick**, the only sound of its kind.
- **Notifications: one sound per category** (fight, money, medical, rivalry, title), ≤ 6 categories, never looped.
- UI bus about **6 dB** under music peaks as a starting value [J: NOT COMPUTED].
[send-message t32s316] **M32_MENU_ART_DIRECTION.md, part 2 of 2 (sections 7–12)**

## 7. FightCamp style guide proposal

### 7.1 Palette: deltas on live UITokens
We keep the **lit blue-grey family** (GROUND `#1c2230`) and do **not** move to the M22 near-black set (`#0B0E14`) [J: every approved board since R9 sits on GROUND; MUTED on GROUND is already 6.09:1].

| Role | Token | Hex | Change |
|---|---|---|---|
| Ground | GROUND | `#1c2230` | keep; AFTER adds a 0–6 % vertical darkening + one soft cool light [J] |
| Sunk | TRACK | `#111621` | keep, also for inputs (live used PANEL_LO) |
| Resting | PANEL | `#2a3347` | keep + white rim at **7 %** [J] |
| Lifted | PANEL_HI | `#34405a` | keep + rim at **12 %** [J] |
| Hero | gym ladder `deep` to PANEL | derived | new usage |
| Text | TEXT / TEXT_2 | `#f3f5fa` / `#c9d1e0` | keep |
| Muted | MUTED | `#94a1b8` becomes **`#a3afc4`** | contrast delta |
| Disabled | DIM | `#6d7688` | **disabled only** |
| Link | LINK | `#7fb6ee` | keep (5.91:1) |
| Primary action | GOLD / GOLD_HI | `#f0c233` / `#f7d65a` | keep, **1 per board** |
| Continue | GO | `#22c55e` | keep fill, **text becomes INK** |
| Selection / nav | GYM_DEFAULT ladder | `#2f6fb0` | rail active = 30 % tint + 3 px bar in gym `hi` (was gold) |
| Semantic | GOOD / AMBER / BAD | `#4fc46a` / `#f0a020` / `#e5433a` | keep for fills; **+ BAD_TEXT `#f2766f`** |
| Belt | SODIUM / ICE | `#f2c14e` / `#5ec8e0` | untouched (M7 law) |

### 7.2 Type scale (Inter unless noted; at most 5 steps per screen)
| Step | Size / weight | Use | Case |
|---|---|---|---|
| Label | **15 / 600, +1 px tracking** | eyebrows, pills | CAPS, ≤ 24 chars |
| Meta | **15 / 450** | secondary lines, units, timestamps | sentence |
| Body / row | **18 / 400–600** | body, rows, buttons (16–20 for buttons) | sentence |
| Group title | **22 / 600** | card titles | sentence |
| Screen title | **30 / 650** | page titles, hero headline | sentence |
| Hero figure | **44 / 650, `tnum`** | the one big number | n/a |
| Display (Bebas) | **≥ 44**, max 1 per screen | fight night, result, gym name | caps by font |

Sizes are [J: about ×1.2 from 18 px], except the 15 px floor [P: from XAG + 115 % option] and `tnum` on every number [S: MDN]. Line height 1.4× body, 1.2× titles [J].

### 7.3 Spacing grid (8 pt, existing SPACE tokens)
- Base **8**, half-step **4** [S: UT].
- Card padding **24–32**; gap between cards **24**; inside a group **16**; row pitch **64–76** for portrait rows, **56** for plain rows [J: live 44 px ROW_HEIGHT is too tight at 18 px].
- Radius **8** cards, **10–12** hero and shell, **6–8** controls, pills h/2 [J: live 3 px reads as boxes].
- Content-area margins **0**; creation flow keeps its **100** px margin [S: CFP].

### 7.4 Panel styles
Sunk, Resting, Lifted, Hero as in section 4. One hero per screen. Lifted only for one commit card or transient UI. Everything else Resting. **No header bars. No borders darker than the fill.**

### 7.5 Iconography
- One line set (Lucide or Phosphor): **24 px grid, 2 px stroke, round caps**; 18–22 px in rows, 20 px in the rail [J].
- Icon plates: **36–44 px** rounded square, gym tint at 20–22 %, icon in gym `hi` [J].
- Every rail item gets an icon; group titles may have one; buttons only for direction (→) [J].
- game-icons.net only for sport objects, ≥ 40 px, with credits.

### 7.6 Motion
**100 / 150 / 160 / 200 / 240 ms**, no pulse, no full-screen fade.

### 7.7 Text budgets (Kalli writes the words)
| Slot | Budget |
|---|---|
| Eyebrow (caps) | ≤ **24** chars, ≤ 3 words |
| Button | ≤ **16** chars, verb first, sentence case |
| Row title | ≤ **40** chars |
| Row meta | ≤ **56** chars |
| Hero headline | ≤ **60** chars, ≤ 2 lines |
| Hero body | ≤ **110** chars, ≤ 2 lines |
| Screen caption / foot cue | **none**, key hints only |
| Numbers | never bare (7.10) |
All [J].

### 7.8 Casing
Sentence case everywhere except eyebrows ≤ 24 characters and proper nouns. Rail names in sentence case ("The day", "Schedule"). If Kalli wants "THE DAY" as a brand mark, it appears once, as an eyebrow.

### 7.9 Density budget per screen
- **1 hero + ≤ 3 groups**; ≤ **7** rows per group; ≤ **1 gold**, ≤ **1 green**; ≤ **2** typefaces; ≤ **5** sizes; ≤ **2** accent hues besides semantic ones [J].
- Claude's pass/fail checklist: count heroes, groups, golds, sizes, caps strings over 24 characters, bare numbers, empty panels.

### 7.10 Number-with-context rule
Every number shows a label ("6–1 Record"), a unit ("$420 / week"), a comparison ("6 of 12" + bar) or a delta ("up 12 this week"), otherwise it goes in a tooltip. Money is `$24,180` with no space (live `"$ %s"` has one [S: SC]). Records use an en dash. All numbers use `tnum`.

### 7.11 Empty-slot rule
No dark rectangle stands for "nothing". An empty state is **1 line + 1 action** ("Nothing else is dated today. · Open schedule ›"). Free grid space is **one dashed region with a count** ("6 free spaces · Build after opening"), never N black cells [J; live `quiet_empty_state` is close but caps, DIM and has no action].

## 8. Screen notes for the two mocks
BEFOREs are **reconstructions from live code at `2662c01`, not screenshots**. Names, equipment, cash and news are EXAMPLE.

**8.1 Gym creation (step 3 of country, city, gym).** BEFORE: brand bar 96 / step band 46 / foot 46; "NAME THE GYM" in Bebas 34; caps mono caption; name field 620×52; three 230×72 figure units; starter floor at 96 px cells with dark tiles for empty cells; four roster rows with **initials**; gold "OPEN GYM" 280×62 at x 1620; foot cue "…780 MS"; BACK at x 1020, mid-bar [S: UK/CFP/CC].
AFTER: the hero card holds the name. The single gold "Open gym →" sits on a lifted commit card that restates what will be written. Step strip moves to the centre of the brand bar (✓ Country, ✓ City, 3 Gym). Numbers get context: "$25,000 · ≈ 13 months of upkeep" [S: computed 25,000 / (420 × 52 / 12) = 13.7]; "6 of 12" gets a 12-segment bar; "$420 / week" shows its split. The floor becomes a top-down drawing with one dashed "6 free spaces" region; each equipment state is glyph + word. Foot shows key hints only. First day reads "Monday 5 January 2026".

**8.2 THE DAY.** BEFORE: rail 370×900 with Bebas caps nav, gold active bar, red badges; top bar with caps breadcrumb, `$ 24,180` gold chip, bell, 7-day strip, white-on-green Continue; an 88 px "hero" strip, 3 ticker rows, TODAY and MUST ANSWER frames with blue header bars, and a mostly **empty dark MUST ANSWER column** [S: SC/DFP].
- **Computed defect, verify in build:** the day strip is placed as if **320** px wide but draws **7×55−5 = 380** px, so Continue covers the last **46** px (part of SAT/SUN).
AFTER: same shell rectangles. Rail gets icons, sentence case, gym-tint active state and amber pills. Top bar shows labelled numbers, a day strip with markers that differ by **shape** (● event, ◆ fight), and Continue in INK on green. **Hero** is the lead story with portrait, 4 labelled facts and the only gold. **Needs you** merges attention and asks, each with a glyph + word pill. **Today** ends in a one-line empty state with a route. **On the wire** has 3 items + "All news". So 1 hero + 3 groups.

## 9. Never list
1. Never show a developer sentence to the player.
2. Never set sentences or titles in caps, and never set player text in monospace.
3. Never leave a number bare.
4. Never draw an empty dark rectangle for "nothing".
5. Never show state by hue only.
6. Never more than 1 gold or 1 green per board; never a gold nav highlight.
7. Never coloured header bars on cards.
8. Never pulse or throb; never fade the whole screen.
9. Never initials where a person should be.
10. Never mix icon sets; never ship a CC BY icon without credits.
11. Never below the 15 px floor; never DIM for readable text.
12. Never "camp", always the gym. Blood only at doctor/stoppage.

## 10. Self-attack
- **It moves toward a productivity-tool look, and FM26 was punished for exactly that** ("loss of immersion"). Sentence-case Inter on blue-grey cards is closer to a dashboard than the current fight-poster look. Mitigations: Bebas kept for moments, the hero carries the gym colour and a ropes motif, and the 6 a.m. gym seed steers materials. Judge the AFTER boards on feel, not only clarity.
- **Cost:** every screen that calls `UIKit.caps()` or `display()` changes, and widths sized to Plex/Bebas metrics will break (e.g. `chip` = 20 + 7.6 px per character). It's a **kit pass + per-screen width audit**, not a token change [J].
- **18 px body lowers density** by about 25 % of rows against 13–14 px [J].
- **Weakest point:** the portrait plan. Identical silhouettes are their own placeholder look, and the 1–2 week procedural estimate has nothing behind it.

## 11. Sources
1. Sakamoto, Hearthstone UI, GDC 2015: https://archive.org/details/GDC2015Sakamoto
2. Steph Chow, GDC 2018: https://www.gamedeveloper.com/design/video-designing-great-ui-that-helps-immerse-players-in-your-game
3. Diablo IV Quarterly Update, Feb 2020: https://news.blizzard.com/en-us/article/23308274/diablo-iv-quarterly-updatefebruary-2020
4. FM26 reimagined UI: https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface
5. Mastering the FM26 UI: https://www.footballmanager.com/the-dugout/mastering-fm26-ui
6. FM26 review: https://www.footballmanager.com/news/return-international-management-and-review-fm26
7. Pingle Studio FM26 case: https://pinglestudio.com/cases/football-manager-26/
8. Tokmakchiev, Making UI for Total War: https://www.youtube.com/watch?v=MSoW-8xkaQs
9. Troy End Turn deep dive: https://www.gamedeveloper.com/production/deep-dive-evolving-the-ux-ui-of-i-a-total-war-saga-troy-i-using-player-feedback
10. Wojs, Art of Total War: Three Kingdoms, GDC 2020: https://www.gamedeveloper.com/art/attend-gdc-for-an-inside-look-at-the-art-design-of-i-total-war-three-kingdoms-i-
11. Sherman Tam, UFC 5 Style Guide: https://www.shermantam.com/projects/ufc-5-style-guide
12. Civ VII UI sound: https://www.asoundeffect.com/civilization-vii-game-audio/
13. Material 3 motion: https://m3.material.io/styles/motion/easing-and-duration/tokens-specs
14. NN/g response times: https://www.nngroup.com/articles/response-times-3-important-limits/
15. NN/g glanceable fonts: https://www.nngroup.com/articles/glanceable-fonts/
16. NN/g progressive disclosure: https://www.nngroup.com/articles/progressive-disclosure/
17. Xbox Accessibility Guideline 101: https://learn.microsoft.com/en-us/gaming/accessibility/Xbox-accessibility-guidelines/101
18. WCAG 2.2: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html
19. MDN tabular-nums: https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-numeric · Inter: https://rsms.me/inter/
20. game-icons.net: https://game-icons.net/faq.html
21. Lucide: https://lucide.dev/license · Phosphor: https://github.com/phosphor-icons/phosphor-icons/
22. Game UI Database: https://www.gameuidatabase.com/
23. Repo code at `2662c01`

## 12. Honesty flags
| Claim | Status |
|---|---|
| Live fonts, `caps()`, size/radius/row tokens | SOURCED (code) |
| Font body/cap-height ratios, all contrast ratios | SOURCED (computed) |
| Day strip overlap of 46 px | computed from code, **NOT VERIFIED on a running build** |
| XAG 18 px PC body height; M3 durations; FM26 facts | SOURCED |
| Hearthstone talk year | **2015**, the brief said 2014 |
| Overwatch menu talk | NOT FOUND, Hearthstone + Diablo IV used |
| EA FC career-mode case study | NOT FOUND, UFC 5 used |
| FM24 specifics | NOT COMPUTED, FM26 used |
| Type scale, radii, row pitch, budgets, density limits | JUDGEMENT |
| Sound lengths, 6 dB offset | JUDGEMENT / NOT COMPUTED |
| Portrait and illustration costs | JUDGEMENT, weakest point |
| Godot `tnum` via FontVariation | NOT VERIFIED |
| BEFORE boards | reconstructed from code, not screenshots |
| All AFTER strings | EXAMPLE, words are Kalli's |
[send-message t32s317] M33 (icons, type and the tooltip restyle) is shipped. It's staged in `_maria_delivery/M33/`, and the research copy is in `research/`. Claude has the land note by mailbox (message id `96b7a8547687`).

**Icons.** I chose Lucide 1.48.0, which is ISC-licensed. Its icons are line drawings on a 24 px grid with a 2 px stroke you can adjust, which matches M32 exactly. The main cost is that there's no boxing glove, so Fight Night uses `hand-fist`. All 24 glyph names are checked against the release, and the SVGs plus the licence text are in the pack. Some icons may not read well to players and haven't been tested: `sunrise` for The day, `biceps-flexed` for Training, `hourglass` for Fight Week, `weight` for Weigh-in, and `bandage` at 16 px. Also, `whistle` for Staff only covers coaches, not medical staff.

**Type.** Inter 4.1 replaces Work Sans. It adds one file, `InterVariable.ttf` (859 KB, OFL). Its lowercase letters are 9% taller at the same size, it has the ✓ glyph (Work Sans doesn't), and it covers Greek. Both fonts support aligned numbers (`tnum`); I checked this glyph by glyph. According to the Godot 4.7 docs, one font variation per text role can set both the weight and the number feature, but that hasn't been tried in a real build yet.

**Tooltip.** The "before" is an untouched crop of the real `05_tut_04_gym.png`. The "after" puts the tooltip on a lighter panel and writes the name in sentence case with the Gym icon. "Now:" is no longer gold, and it gets a small meter with no words. NOT LINKED gets an icon plus the word, so it isn't shown by colour alone. All 46 Handbook terms fit the new text limits.

Three things I found that you should know:
• **The display font is misnamed.** The repo file `BebasNeue-Regular.ttf` is actually Oswald Bold. That also means M32 was wrong to say the display face has only capitals. I've told Claude to rename the file or credit it plainly.
• **Two small corrections to M32, both because text failed contrast checks.** Icons on Handbook tiles are white instead of gym-tinted, and a raised tooltip uses the standard panel colour, because red text on the lighter panel measures only 3.75:1.
• **Tooltip delay stays at 500 ms**, which is what the code already uses, instead of the 400 ms I suggested in M32.

The full doc is below.
[send-message t32s318] **M33_ICONS_AND_TYPE.md, part 1 of 2 (decisions and icons)**

Maria (art direction) · 2026-09-25 · Godot 4.7.2 · 1920×1080 · ART ONLY. I read the code and fonts at commit `f5a7e14`. Master moved to `db5cd6c` during the task; that commit added the S78 previews, and `Glossary.gd` hasn't changed. Kalli owns the words, so any string I invented or changed is marked EXAMPLE.

## 0. Decisions
| # | Decision | Why |
|---|---|---|
| D1 | **Lucide 1.48.0 (ISC)**, one set only | Native 24 grid, live `stroke-width="2"`, round caps and joins, which is exactly the M32 spec. Phosphor ships filled outlines on a 256 grid, so its stroke can't be tuned. |
| D2 | **Inter 4.1, `InterVariable.ttf` (roman only, 859 KB, OFL 1.1)** for all player text | Taller lowercase (x-height 0.546 vs 0.500 em). M32's text limits were measured in Inter. It has ✓, Greek, Cyrillic and an optical-size axis. |
| D3 | **tnum: YES** in both Inter and Work Sans | Checked in the font's substitution tables and glyph widths. |
| D4 | **Godot:** `FontVariation.variation_opentype` sets weight and optical size; `opentype_features` sets `tnum` and `case`. One FontVariation per role. | Godot 4.7 docs. NOT VERIFIED in a 4.7.2 build. |
| D5 | **Display face is for display only**: 44 px or larger, once per screen. **Flag:** `BebasNeue-Regular.ttf` is actually **Oswald Bold 4.103**. | Name table plus `fonts/SOURCE.md`. Rename it or credit it plainly. |
| D6 | **No monospace for players.** Plex Mono is for dev/debug only. | Live offenders: the CoachMarks count and buttons, and `UIKit.caps()`. |
| D7 | **Tooltip "after"**: PANEL + 12% rim, Inter 18/600 name in sentence case, 15/450 body, "Now:" in MUTED (not gold), NOT LINKED as glyph + word | §4 |
| D8 | **M32 amendments**: Handbook plate glyphs are TEXT (gym-hi on the tint is 2.74:1). A raised tooltip uses PANEL, not PANEL_HI (BAD_TEXT on PANEL_HI is 3.75:1). | Measured contrast |
| D9 | **Tooltip delay 500 ms**, fade-in 100 ms | The code already uses J52's `SHOW_DELAY 0.5`. M32's 400 ms is withdrawn. |

## 1. Icons: Lucide vs Phosphor
Lucide: ISC (plus MIT for the Feather-derived icons), 24×24, 2 px stroke with round caps, 1,854 icons, no glove but has `hand-fist`, `dumbbell`, `biceps-flexed`, `whistle` and `weight`. Phosphor: MIT, 256 grid of pre-expanded fills that look about 1.5 px thick at 24 px, 6 weights, and it does have `boxing-glove`.
**I chose Lucide.** The stroke stays adjustable (`stroke-width = 48 / size` keeps it looking 2 px thick). The glove is the trade-off; sport objects already go to the illustrated game-icons family under M32. Every name exists in `lucide-icons-1.48.0.zip` (released 2026-09-24).

### 1.1 Rail (20 px)
| Rail | Glyph | Note |
|---|---|---|
| The day | `sunrise` | Somewhat weak; `house` is the alternative. |
| Gym | `dumbbell` | Strong; also used for the Handbook's Gym. |
| Staff | `whistle` | Covers coaches only, not medical staff. |
| Training | `biceps-flexed` | **Weak**: it reads as strength only. |
| Schedule | `calendar-days` | Strong. |
| Scouting | `binoculars` | Strong. |
| Rankings | `podium` | Strong. |
| Office | `briefcase` | OK. |
States: default is TEXT_2 with an 18/500 label. Hover is a CONTROL_HI fill (100 ms in, 150 ms out). Active is TEXT on a 30% gym-tint fill with a 3 px gym-hi bar, **not gold**. Disabled is DIM plus `lock` and the word "Locked" (EXAMPLE).

### 1.2 Handbook (40 px on a 56 px plate; 20 px in lists)
Gym `dumbbell` (same as the rail) · Roster `users` · Training `biceps-flexed` (same as the rail, weak) · Condition `heart-pulse` · Matchmaking `handshake` · Fight Week `hourglass` (weak, reads as loading; `calendar-clock` is the fallback) · Weigh-in `weight` (somewhat weak; `scale` is the scales of justice) · Fight Night `hand-fist` · Money `banknote` · Rules `gavel`.
**A naming clash for Kalli:** the Handbook area "Condition" is the fighter's body, but the Glossary term `condition` means equipment wear.
Plate: 22% gym tint with the glyph in TEXT. Hover raises the fill to 30%. Selected adds a 2 px gym-hi ring. Locked shows DIM plus `lock` and "Locked".

### 1.3 State pills (28 px tall, 16 px glyph, word always in TEXT, 15/600 caps)
| Word (EXAMPLE) | Glyph | Colour |
|---|---|---|
| NEEDS YOU | `circle-alert` | AMBER |
| BOOKED | `calendar-check` | LINK |
| INJURED | `bandage` | BAD_TEXT glyph on a BAD tint (weak at 16 px) |
| SUSPENDED | `ban` | AMBER |
| ON WEIGHT | `circle-check` | GOOD |
| OFF WEIGHT | `triangle-alert` | AMBER |
| NOT LINKED (word from the code) | `unlink` | BAD_TEXT glyph and word, outline only, 4.57:1 on PANEL. On PANEL_HI the word switches to TEXT. |
The 16 px glyph is below M32's 18–22 px range; that's a judgement call because the pill is only 28 px tall. Every glyph measures at least 3.44:1 against its pill fill.

### 1.4 Godot import
Replace `currentColor` with `#ffffff` and tint with modulate. Import scale is size/24. Pre-bake the stroke width per size bucket (2.4 at 20 px, 3 at 16 px, 2 on plates). How ThorVG handles `currentColor` and round caps is NOT VERIFIED.

### 1.5 Licence
The ISC text plus the Feather MIT notice (Cole Bemis) are verbatim in `icons/LICENSE-lucide.txt`. We need the MIT notice because `circle-alert`, `triangle-alert` and `lock` come from Feather.
[send-message t32s319] **M33_ICONS_AND_TYPE.md, part 2 of 2 (type, tooltip, never list, flags)**

## 2. Type
**Shipped fonts at `f5a7e14`:** `BebasNeue-Regular.ttf`, which is really Oswald Bold 4.103 with lowercase; IBM Plex Mono Regular and Medium; and `WorkSans-Variable.ttf` 2.012 (353 KB), used only by TipLayer and CoachMarks. There's no Inter.

| | Work Sans | Inter 4.1 |
|---|---|---|
| Axes | weight 100–900 | optical size 14–32, weight 100–900 |
| x-height / cap height | 0.500 / 0.660 em | 0.546 / 0.728 em |
| `tnum` | yes (604/1000 per digit) | yes (1328/2048 per digit) |
| `case` / `zero` | yes / yes | yes / yes (slashed) |
| Stylistic sets | ss01–06, unnamed | ss01–08 and cv01–14, named |
| ✓ | **no** | yes |
| Greek/Cyrillic | no | yes |
At 15 px, Work Sans has the same x-height as Inter at 13.7 px.

**Width check:** Work Sans is 2.5–6% wider than Inter in mixed case, but its tabular digits are 6.6% narrower. Moving from the live Plex 12 caps to Inter at M32 sizes costs about the same width for meta text, and 1.2–1.5× for body text, rows, titles and the rail. S79 needs to re-check fixed-width containers. Plex at the same size is 15–20% wider than either face.

**Godot 4.7 docs:** `variation_opentype` sets axes, `opentype_features` sets features, and `spacing_glyph` adds tracking. Features can also be set in the import metadata, or inline with `[font otf="tnum=1"]`. Whether optical size follows font size automatically is NOT VERIFIED; set it per role.

**Roles (Inter Variable)**
| Role | px | wght | opsz | features | tracking | line height | case |
|---|---|---|---|---|---|---|---|
| Label | 15 | 600 | 15 | case, tnum | +1 | 1.2 | caps, ≤ 24 characters |
| Meta | 15 | 450 | 15 | tnum | 0 | 1.4 | sentence |
| Body | 18 | 400 (500 for emphasis) | 18 | none | 0 | 1.4 | sentence |
| Row / button | 18 | 500–600 | 18 | tnum | 0 | 1.3 | sentence |
| Group title | 22 | 600 | 22 | none | 0 | 1.2 | sentence |
| Screen title | 30 | 650 | 30 | none | 0 | 1.2 | sentence |
| Hero figure | 44 | 650 | 32 | tnum | 0 | 1.1 | none |
| Display (Oswald file) | 44 or more | Bold | none | none | 0 | 1.0 | caps, once per screen |
**Verdict:** Inter, because readability is the operator's standing rule. Work Sans's case: it's already shipped, it's 506 KB smaller and it has more character. If the extra 859 KB is rejected, the fallback is the same table in Work Sans with text limits about 5% tighter.

## 4. Tooltip (S78 step 4, FLOOR SPACE)
**Live tooltip:** 340×127 px at (483, 433), #141a25 fill with a 1 px LINE border. TipLayer: max width 340, delay 0.5 s, Work Sans 15, bold at weight 650, 8 px corners. `tip_bbcode` writes the name with `to_upper()`, a gold "Now:" (`#f0c233`) and "Why:" in the old MUTED `#94a1b8`. This tip has no NOT LINKED line. The NOT LINKED variant uses OfficeHubPanel's real strings, and its "before" is rebuilt from code because no screenshot exists. **Observed:** the bold name renders at regular weight (cause unknown), and three golds are visible at once.

**Changes:**
1. PANEL with a 12% rim and a raised shadow.
2. Name "Floor space" at 18/600 in sentence case (EXAMPLE casing), with `dumbbell` and "Gym" in MUTED.
3. Definition kept word for word, Inter 15/450, TEXT_2.
4. "Now:" in MUTED instead of gold, value "36/40" with tabular numbers, plus a 96 px meter.
5. "Why:" uses the MUTED token.
6. Position unchanged; width 360. I recommend placing it 8 px under the unit.
7. NOT LINKED gets a hairline divider, `unlink`, and the label in BAD_TEXT caps, with the reason in TEXT_2, sentence case, EXAMPLE casing.
Timing: 500 ms delay, 100 ms fade in and out, no pulse.

**Text limits:** name ≤ 24 characters · definition ≤ 15 words and ≤ 2 lines · why ≤ 12 words and ≤ 2 lines · Now value ≤ 16 characters · NOT LINKED reason ≤ 48 characters. **All 46 Glossary terms fit**; the tallest tip is 182 px.

## 5. Never list additions
1. No colour hex values hard-coded in bbcode; use tokens.
2. No gold labels; gold appears once per board.
3. No BAD_TEXT on PANEL_HI.
4. No tinted glyph on a gym-tinted plate.
5. No mixing Lucide with another icon set in the UI chrome.
6. No font file named after a different face.
7. No `to_upper()` on Handbook names.
8. No state shown by colour alone.
9. No monospace in player text.

## 6. Self-attack
- Inter is the default dashboard face. Work Sans would have looked more distinctive.
- M33 overrides M32 twice.
- Several icons may read badly and are untested with players.
- There's no glove in the UI chrome.
- The tooltip meter is an addition and can be dropped.
- The mock keeps the live position, so the anchoring I recommend isn't shown.
- Pillow is not Godot, so expect widths to differ by about 1 px.

## 8. Honesty flags
- **VERIFIED:** the display file is Oswald, not Bebas. M32 was wrong about the live face.
- **VERIFIED:** the tooltip "before" is the real preview crop from `db5cd6c`. The NOT LINKED "before" is rebuilt from code.
- **NOT VERIFIED:** the font features and axes in a real Godot build; ThorVG handling of `currentColor` and round caps; Greek and Cyrillic names.
- **Observed, cause unknown:** the bold name renders at regular weight.
- **Judgement calls:** the weak icons, and the 16 px pill glyph.
- **EXAMPLE:** the pill words, "Locked", and the casing of the NOT LINKED reason.
- **PARTIAL:** code facts are from `f5a7e14`; only `Glossary.gd` was re-read at `db5cd6c`.
- **VERIFIED:** Inter adds 859 KB and one OFL credits entry.
[send-message t32s320] M34 The Pitch Look is shipped. It has four front-end directions, each with a title screen and a hub at 1920×1080, plus the 5-beat fight-night storyboard, a transition spec and the survey of buyable assets. It's staged in `_maria_delivery/M34/` and `research/m34/`, and Claude has the land note (mailbox id `c2b224dc115b`).

**You need to pick one direction before Claude builds anything.**
• **A Brass & leather** is my pick and the closest to Hollywood Animal. The gym picture is itself the hub, with clickable spots and a tutorial tip on it. It uses brass chamfered frames, a brass date plate with Continue, and cast-style fighter cards.
• **B Fight poster** uses cream paper, halftone portraits and a ticket-stub date bar. It's the most distinctive, but the hardest to keep readable on busy data screens.
• **C Arena night** is the fallback and the closest to Motorsport Manager: frosted glass panels over a blurred gym. It's easy to build, but it's also the look most other games have.
• **D Six A.M.** is the current M32 colours with illustrations added. It's the cheapest, and the closest to the look you already called flat.

**Stills or animation:** a high-res still for each screen, plus a few cheap live layers. Those are slow parallax, dust, one light shaft, and the crowd on fight night. No frame-by-frame animation. Video would only be an optional intro later.

**Fight night** is announcement, weigh-in faceoff, walkout, ring intro, then bell. Every beat puts "how hard it was to get here" on screen: 19 months, 6 weeks of fight camp, a 6.0 kg cut, 212 rounds, 11–2. All of those numbers are EXAMPLE.

**Transitions:** your Hollywood Animal fades are in, but only for the big moments. There's a 360 ms brass wipe for title to hub and hub to fight night, and a 400 ms dissolve or light-bloom between fight-night beats, all skippable. Everything else stays on 160–240 ms slides. The bell is a hard cut. The button shine sweeps once on hover and never loops. This changes the M32 rule, and it's marked as an amendment.

**Buying:** no GUI pack on any store matches this look, and that includes everything in Unity's 2D GUI section. We should draw our own frames and buttons. The top buys are:
1. A Blender boxing-gym scene ($24.99) to render title and hub backgrounds from. Its licence needs checking for commercial use.
2. The Marpa MMA Arena we already own, for the fight venue.
3. Free OFL display fonts.
4. Nexelume ($9.99) for fight-night lower thirds.
5. A Layer Lab kit, only as a 9-slice example.

No store item covers portraits. They need a commission, or AI art where we record the tool and its terms.

Three honest limits:
• The mocks reuse the repo's existing AI images. Nobody recorded which tool made them or on what terms, so they can't ship as they are.
• The walkout, crowd and bell are rough stand-ins drawn in code, because I couldn't generate new art during the build. Judge beats 3 and 5 on layout only. I can generate real illustrations for them next if you want.
• J54's menu structure landed at 18:40, after the hubs were drawn, so the hubs still use today's 8 rail items. Checking them against J54 is a small follow-up.

The full doc is in the thread below.
[send-message t32s321] **M34_PITCH_PRESENTATION.md, part 1 of 2 (decisions, references, stills vs animation, directions)**

## 0. Decisions
- **D1: Stills plus a thin live layer.** Each screen gets one high-res still plus 1–3 cheap layers: parallax (at most 12 px), dust, one light shaft, and the crowd on fight night. Video is reserved for an optional 20–30 s intro.
- **D2: Four directions** in the Motorsport Manager / Hollywood Animal family: A Brass & leather, B Fight poster, C Arena night, and D Six A.M. (M32 illustrated).
- **D3:** My favourite is A and the fallback is C. D is the cheapest. B is the boldest and the costliest to keep consistent.
- **D4:** The hub uses today's 8 rail items, because J54 hadn't landed when the mocks were made.
- **D5:** Fight-night hype is 5 beats, and every beat shows "how hard it was" on screen.
- **D6: M32 amendment.** Cinematic dissolves and wipes of 360–400 ms are allowed only at boot to title, title to hub, hub to fight night, and between beats. Everywhere else stays on 160–240 ms slides.
- **D7:** The shine is one diagonal sheen of about 600 ms on hover or focus. It never loops, and nothing pulses.
- **D8:** No store GUI pack matches the look. Buy for backgrounds, reuse the arena we own, and draw our own frames and buttons as 9-slice PNGs.
- **D9:** No one recorded the source of the repo portraits, so the portraits need a clean source before anything ships.

## 1. Reference board (12 frames I actually fetched; the URLs are in the files)
- **Hollywood Animal, studio lot hub:** the place is the menu, and this is the core model for A. Its cast cards and brass date plate ("18 JAN 1929" with pause, play and fast buttons) are where A's frames and date bar come from. The night-lot version shows one picture graded two ways.
- **Motorsport Manager, HQ:** dense data over a 3D garage. It opens with an FMV intro (`AttractIntro.bk2`).
- **UFC 5:** the main menu is a left-hand list over a fighter. The career hub has a "Fight Week" screen, which is the same arc as ours.
- **Creed: Rise to Glory:** a title card reading "5 MONTHS BEFORE…" and a "35-25-3, 22 wins by knockout" intro. That's direct precedent for the "how hard it was" beat.
- **FIFA 20:** a hero figure plus the logo on the title screen, and tiles for mode select.
- **Undisputed and WWE 2K24:** cinematic walkouts and entrances. Mood reference only.
- **Football Manager 26:** the right structure, but the flat panels you complained about.
- **Punch Club 2:** the map is the menu, which is the same idea as the gym hotspots.
- **Fight Night Champion:** text sources only. It boots cold into a knockdown and uses an ESPN-style ticker.
What the board shows: the games that look buyable put a place or a person behind the UI and keep one hero per screen.

## 2. Stills vs animation for each screen
- **Logo:** a still, then a 400 ms dissolve to the title.
- **Title:** a high-res still split into 2 parallax layers, up to 40 dust motes and one static light shaft.
- **Hub:** a still gym with dust only. Hotspots react on hover.
- **Other hub tabs:** the same still, reframed or blurred.
- **Fight-night beats:** a still for each beat. The weigh-in gets a single 120 ms camera flash, the walkout gets dust and a 2% push-in, the ring intro gets crowd parallax, and the bell gets one ring expansion.
Frame-by-frame 2D would cost far more and look cheap when underfunded. We can render stills from the arena we own and the Blender gym.

## 3. Directions
All four show the same EXAMPLE save (Harbour Street Boxing Club, Mon 12 Oct 2026, $24,180, 4 fighters, Vance vs Ardanza in 12 days). Every one fixes your complaints. There's one hero per screen, text is in sentence case, there's no monospace, portraits replace initials, there are no empty slots, and every number has a unit or a comparison. State is always shown as icon plus word.

**A Brass & leather (favourite).**
- **Colours:** ground `#15100c`, panel `#2a2019`, brass `#c9a15a` and `#ecd29a`, text `#f6eddc`, gold `#f0c233` with ink text, green `#4fc46a`, teal gym tint.
- **Type:** Inter, with Big Shoulders Display as the proposed display face.
- **Hub:** the gym picture with pins for The ring, Office, Staff room and Weights, a tip reading "Tip 1 of 4", HA-style cast cards, and a brass date plate that ends in a green Continue.
- **Cons:** it's busy, brass over a photo needs careful contrast checks, the pins sit on a fixed gym picture, and it uses the display face twice on the hub.
- **Cost:** medium.

**B Fight poster.**
- **Colours:** paper `#efe6d2`, ink `#17130f`, red `#c7372f`.
- **Type:** Anton as the display face.
- **Build:** paper sheets pinned over a dark gym, trading cards, and a ticket-stub date bar.
- **Cons:** it reads like a boxing history game, its red clashes with the BAD red, and long lists go flat.
- **Cost:** medium-high.

**C Arena night.**
- **Colours:** ground `#0d1420`, 80% glass with blur, cyan `#39b6dc`.
- **Type:** Barlow Condensed as the display face.
- **Build:** a tile row on the title, a full-width header strip, a next-fight hero, and a weight-cut chart.
- **Cons:** the least distinctive, the blur costs GPU, and without good art it slides back to grey panels.
- **Cost:** low-medium.

**D Six A.M.**
- **Build:** the exact M32 tokens with the Oswald display file, the M32 THE DAY layout, and illustrated backgrounds.
- **Cons:** it's an improvement, not a pitch.
- **Cost:** low.
[send-message t32s322] **M34_PITCH_PRESENTATION.md, part 2 of 2 (storyboard, transitions, assets, never list, flags)**

## 4. Fight-night storyboard (Direction A styling, all numbers EXAMPLE, no blood)
1. **Announcement ("The fight is made, 6 weeks out"):** Vance vs Ardanza, 11–2 vs 14–1 (#6), welterweight, 10 rounds, co-main event, Dockside Hall, Sat 24 Oct. It shows "The road here" as a timeline, the lines "19 months · 13 fights · 2 losses" and "Weight today 72.4 kg · limit 66.7", and a gold "Start fight camp" button.
2. **Weigh-in faceoff:** 66.4 kg and 66.6 kg, both marked ✓ Made weight. Six week tiles run from Base to Taper, and week 4 shows ⚠ rib bruise. It also shows "72.4 to 66.4 kg · 6.0 kg cut · 212 rounds sparred".
3. **Walkout:** tunnel, hooded fighter, cornermen, and a lower third reading "Walking out · Red corner". "On the line tonight" shows the #5 regional ranking, the $6,500 purse, the $1,300 bonus and 212 tickets sold.
4. **Ring intro:** the tale of the tape, including fight camp (6 vs 8 weeks) and weigh-in rows.
5. **Bell:** ROUND 1, with the line "Six weeks. 6.0 kg. Nineteen months. Now it's three minutes." Space skips.
The weigh-in faces front, because we have no profile art yet. The walkout, crowd and bell are procedural stand-ins.

## 5. Transitions
| Change | Type | Duration and easing |
|---|---|---|
| Boot to logo | cut | 0 |
| Logo to title | cross-dissolve (amendment) | 400 ms ease-in-out |
| Title to hub | brass wipe, menu slides out 24 px (amendment) | 360 ms, emphasized decelerate |
| Hub tab to tab | content slides 32 px, the shell stays still | 240 in / 160 out |
| Card or drawer | slides in from the right, 48 px | 200 ms decelerate |
| Selection | highlight moves | 160 ms |
| Hover | 2 px lift and tint | 100 / 150 ms |
| Sheen | one sweep, no repeat | ~600 ms |
| Hub to fight night | brass wipe (amendment) | 360 ms |
| Beats 1 to 3 | dissolve (amendment, skippable) | 400 ms |
| Beat 3 to 4 | light bloom, brightness capped (amendment) | 400 ms |
| Beat 4 to 5 | cut on the bell | 0 |
| Bell to fight | hard cut plus one ring | 240 ms |
| Back | reverse slide | 240 ms |
| Skip | jump with a slide | 160 ms |
"Reduce motion" turns every 360/400 ms moment into a 160 ms cut and removes the parallax and dust.

## 6. Buyable assets (pages read today)
- **ArtStation MMA/Boxing Gym Vol.1:** $24.99 is the personal licence. Commercial use costs $49.99, and it's a 3D UE5 pack, not UI. This corrects the first pass.
- **ArtStation Boxing Gym Blender scene:** $24.99, Standard licence (commercial use NOT VERIFIED), 83 objects, volumetric light. Strong fit for backgrounds.
- **GraphicRiver Ultimate Boxing:** $13, and a paid game needs the Extended licence (price NOT VERIFIED). Cartoony. Poor fit.
- **itch.io:** mostly pixel art. Super Fight is $3.15 with no licence stated. Nexelume Sports Broadcast is $9.99, commercial use allowed, AI-made. Medium fit for lower thirds.
- **Layer Lab GUI Pro Minimal Dark:** $49 on sale at Layer Store, $70 on GameDev Market, $69.99 on Unity (Single Entity). Casual look.
- **Unity 2D GUI:** Heat shows as Single Entity, not the Extension Asset the brief said, but it's a code system and is rejected anyway. Dark UI Kit is an Extension Asset. OBSIDIAN, Dark Realm and the others are Single Entity with a casual, fantasy or mobile look. **None fits.**
- **Humble:** nothing relevant today.
- **Fonts:** OFL faces at $0. Paid foundries weren't checked.
- **Owned:** Marpa MMA Arena is a strong fit for the venue. Poly Ronin gym props are a render source. SlimUI is rejected.
**Top 5:** the Blender gym for backgrounds, the Marpa arena for the venue, OFL display fonts, Nexelume for lower thirds, and Layer Lab only as a 9-slice reference. Portraits need a commission or AI art with recorded terms.

## 7. Never list additions
- No looping sheen and no pulse.
- No fades outside the amendment rows.
- No number without a unit or comparison.
- No initials in place of portraits, and no empty slots.
- No real fighters, promotions, venues or brands. Also, repaint the "MAY 2024" calendar in the office art.
- Never ship a picture whose source isn't recorded.
- Never ship Unity Extension or code assets.
- It's "the gym", never "camp".
- No blood before doctor/stoppage.

## 8. Self-attack
- The mocks depend on repo portraits nobody can vouch for.
- A is the most fragile.
- The walkout and bell are procedural.
- The transition timings are my taste, not measured from the references.
- B might be the one you remember.
- Four directions may be too many (A vs C would be the quick choice).
- Players need a skip and a short version after they've seen it a few times.
- The real cost is 5–7 finished illustrations.

## 10. Honesty flags
- No new AI art was generated.
- No one recorded the source or terms of the repo images.
- J54 landed after the mocks were made.
- 28 of the icons are new Lucide icons that still need review.
- The display faces are proposals. The repo's `BebasNeue-Regular.ttf` is actually Oswald.
- Every word I wrote is EXAMPLE, for Kalli.
- Nothing was committed or pushed, and no code was touched.
[user t33u] # TASK M35 - MARIA - WHERE EVERY PICTURE CAME FROM, AND WHAT REPLACES THE ONES WE CANNOT SHIP (art direction)

Model: Maria Art Director. Owner: maria. Assigned S79, 2026-09-25. Art/research only - no .gd/.tscn, no commits.



## Why

Your M34 flagged it: "the repo AI portraits and gym/office art have no recorded generator/terms - they need clean

replacements before shipping", and "never ship a picture whose source isn't recorded". The operator will pick one of

your four directions (A brass, B poster, C arena, D six a.m.); whichever he picks, the portraits and scene art have to

be clean. This task makes that list and the replacement spec, so S80's art spend is aimed.



## What would a human do?

An art director at a small studio keeps an asset ledger: every image, where it came from, who made it, under which

licence, and whether it can ship. Before a pitch build they clear the ledger - anything unknown is replaced, not

argued about. They then write one prompt/brief sheet so every replacement matches the chosen look.



## Do

1. Ledger: every image under `Godot/assets/` that a player can see (portraits, gym/office/city art, key art, icons,

   textures on menus). Columns: path, what it is, where it came from if known (git log of the file, a README, a

   generator note), licence, SHIP / REPLACE / UNKNOWN. Count each class.

2. For REPLACE and UNKNOWN: a replacement brief per image family (fighter portraits, coaches, gym interiors, office,

   city backdrops, title key art), written so it works for ANY of A-D with a one-line per-direction delta. Include

   the generator settings you would use (Higgsfield gpt_image is what we have: 0.25 credits an image) and how many

   images each family needs.

3. The five images that matter most for the first 10 minutes of play (title, HOME, fighter card, weigh-in, fight

   night) - ranked, with why.



## Deliverable

`M35_ART_PROVENANCE_AND_REPLACEMENTS.md` + `CLAUDE_LAND_NOTE_M35.md`. Mark every guessed source UNKNOWN - never fill a

source you did not see.
[send-message t33s324] I'm on M35. First I'll build the ledger from the repo itself: every image a player can see under `Godot/assets/`, with its git history and any README or generator notes next to it. If I didn't see a source written down, it goes in as UNKNOWN. After that I'll write the replacement briefs for each image family and rank the five images that matter most in the first ten minutes.
[send-message t33s325] I've started the M35 ledger. I'm reading every player-visible image under `Godot/assets/`: its git history, any notes stored inside the file, and any README or licence files beside it. That tells me what can ship, what we have to replace, and what's still unknown. After that I'll write replacement briefs that work for all four directions, with the Higgsfield settings, image counts and credit totals for each family. It ends with the five images that matter most in the first ten minutes. When it's done I'll stage it for Claude and post the results here.
[user t34u] Please answer the M40 task above now, in one message (the three screenshots are attached above).
[send-message t34s327] **M40 The week review.** The hero is NET, because it's the only number on the board that can flip the mood of the week. The three short rows are IN against BILLS, the fighter gains, and the NEXT WEEK hooks. The one thing to look forward to is the middle hook, which sits right above the green button. All sizes are px at 1920×1080. Every string below is EXAMPLE, because Kalli owns the words. Type is Inter with tabular numbers, and the display face appears once, on the NET number.

1. **Backdrop and card.** *Replaces the flat `#3c3c3c` page.*
   - **Backdrop:** the HOME gym render, full bleed at 1920×1080, blurred 10 px, with a `#2a2019` overlay at 40% so it stays bright and warm.
   - **Card:** 1440×840 at x240, y70. Fill `#2a2019`, radius 12, a 2 px brass border `#f0c233` at 60%, and a soft shadow 0/12/32 at 45% black.
   - **Padding:** 40 px inside, so the content area is 1360 wide. The 24 px gap above the button leaves the bottom margin at 56.
   - **Header:** 76 px tall with a 1 px divider in `#362a20`. It holds Lucide `calendar-days` at 32 px in gold, then "Week 4 in review" at 30/700 in `#f6eddc`. On the right is a date pill in `#362a20` with 18 px `#b5a68c` text, "Mon 26 Jan".

2. **Monthly bill strip.** *Replaces the grey one-line text.*
   - **Size and position:** 1360×56 at card x40, y160. Fill is amber `#f0a020` at 16% with a 4 px solid amber bar on the left edge. Lucide `calendar-clock` at 28 px in amber.
   - **Billed week:** the text is 20 px `#f6eddc` ("Monthly bill paid this week"). On the right are two chips, `users` "Wages $3,200" and `wrench` "Upkeep $1,468", each 18 px on `#362a20`.
   - **Other weeks:** four 14 px pips, filled up to this week, and a "Bill due in 3 weeks" label. The pips use fill against outline, not hue, to show how close the bill is.
   - **Tooltips:** hover the chips for the full breakdown, so it needs no sentences.

3. **NET hero.** *Replaces the small red or white NET number.*
   - **Plate:** 640×280 at card x40, y232. Fill `#362a20`, with a 14% tint of good or bad on the left half, and a 2 px border in good or bad.
   - **Icon and word:** `trending-down` or `trending-up` at 56 px, then "NET" at 20/700 caps in `#b5a68c`. A chip reads "Loss week" or "Profit week" at 18 px, with an icon, so state never relies on colour alone.
   - **The number:** 96 px display face, with a sign and tabular figures. Loss is "−$3,852" in `#f2766f` (the lighter text red, for contrast on brown), and the plate border uses `#e5433a`. Profit is "+$1,240" in `#4fc46a`.
   - **Underneath:** `wallet` and "Balance $21,148" at 22 px in `#f6eddc`, then a delta chip "vs last week +$1,100" at 18 px, with `chevron-up` or `chevron-down`.
   - **Sparkline:** four bars (last four weeks), each 36 px wide, bottom-right of the plate. Bars above zero are `#4fc46a`, those below are `#e5433a`, and this week's bar has a 2 px gold outline.

4. **IN and BILLS tiles.** *Replaces the two white-number columns.*
   - **Tiles:** two tiles of 696×120 at card x944, y232 (IN) and y392 (BILLS), each in `#2a2019` with a `#362a20` 1 px border. Between them, a "−" glyph at 32 px in `#b5a68c`. Between the NET plate and the tiles, an "=" glyph in the 24 px gap.
   - **Content:** `arrow-down-to-line` (IN) or `receipt` (BILLS) at 32 px, the label at 18 px in `#b5a68c`, and the amount at 56/700 in `#f6eddc`.
   - **Scale bar:** a 10 px bar along the bottom, both drawn to the same scale (the longer figure fills the tile). IN is `#4fc46a`, BILLS is `#e5433a`. A loss week then shows at a glance that the red bar is longer than the green one.
   - **Tooltips:** hover shows the sources.

5. **Fighter block.** *Replaces the dense "STAT 31.1 -> 31.4" text.*
   - **Position:** 1360×200 at card x40, y528.
   - **Header row:** 36 px with `users` at 24 px gold and "Your fighters" at 22/700. On the right, the results chip from item 7.
   - **Per fighter:** one row of 130 px. A 88 px portrait circle with a 3 px gold ring, then the name at 26/700 in `#f6eddc`, and a programme chip (`dumbbell` plus the programme name) at 18 px.
   - **Stats:** up to three stat blocks per fighter, 380×64 each with 20 px gaps, picked by biggest gain. A "+2 more" chip with a tooltip covers any extras. With more than two fighters, the list scrolls inside the card, and only the best fighter shows by default.

6. **How a gain is drawn.** *Replaces the text pair with arrows.*
   - **Stat block:** stat icon at 24 px (`flame` Power, `zap` Speed, `shield` Defence, `wind` Stamina, and so on) with the label at 18 px in `#b5a68c`. Then "31.1 → 31.4" at 18 px, tabular.
   - **Bar:** 280×14 on a `#362a20` track. It shows the 5-point band that holds the value (here 30–35), so a 0.3 gain is about 17 px, not an invisible 3. The old part is `#b5a68c`. The gain segment is `#4fc46a` with a minimum width of 12 px and a bright 3 px cap, and diagonal stripes at 45° so it reads without colour. The band's end value (35) sits at the right of the bar in 14 px `#b5a68c`.
   - **Pill:** to the right, 64×28, fill `#4fc46a`, text "+0.3" at 18/700 in INK `#1b1207`, with `chevrons-up` at 16 px. Zero gain shows a muted "0.0" pill with `minus`, with no bar fill.
   - **Best gain:** the largest gain in the row gets a gold 2 px outline on its block and a `sparkles` icon at 20 px.
   - **Band crossed:** if a stat crosses a band, the bar refills in the next band and the pill adds `arrow-up-to-line`, in gold. That moment is the loudest thing on the board.

7. **Results chip.** *Replaces the "29 RESULTS AROUND THE WORLD" line and the greyed "no bouts" sentence.*
   - **Chip:** 260×36 at the right of the fighters header, fill `#362a20`, `globe` at 22 px, text "29 results" at 18 px in `#f6eddc`. A tooltip lists them.
   - **If your gym fought:** a second chip, `swords` plus W or L with the score, gold border on a win. If it didn't, show nothing at all, and drop the "no bouts" sentence.

8. **NEXT WEEK hooks.** *Replaces the two hourglass lines.*
   - **Strip:** 1360×136 at card x40, y744, in `#362a20` with a 12 px radius. The label "Next week" sits at 20/700 gold with `arrow-right` at 24 px, top left.
   - **Three hook cards:** 420×76 each, 20 px gaps, in `#2a2019` with a 1 px `#362a20` border. Each has an icon in a 56 px circle on the left, a line at 20 px in `#f6eddc`, and a sub-line at 16 px in `#b5a68c`. Icons: `hourglass` (offer expiring, amber), `swords` (fight), `user-plus` (new scouting). Tooltips carry the detail.
   - **Eye pull:** the most urgent hook always sits in the middle, directly above the button. It gets a 2 px gold border and an amber countdown chip with `timer` ("1 week"). The hooks to its left and right are the other two. If there are fewer than three, the middle one stays and the others collapse.

9. **The green button and the path to it.** *Replaces the wide grey-page pill.*
   - **Button:** 560×80, centred at x680, y934. Fill `#4fc46a`, radius 40, text INK `#1b1207` at 26/700, and `chevron-right` at 28 px on the right. The label is Kalli's. Gold is not used here, because gold is reserved for the main action on HOME, and this green is the Continue colour.
   - **Path:** a 2 px gold line, 24 px long, runs from the middle hook straight down to the button, so the eye falls from the urgent hook onto the button. Space or Enter both press it.
   - **Hover and focus:** the button lifts 2 px and gets a gold 2 px focus ring.

10. **Reveal order and rules.** *Replaces everything appearing at once.*
    - **Sequence, 1.4 s total:** card slides in at 240 ms, then NET counts up over 500 ms, then the IN and BILLS bars fill over 300 ms, then each gain bar fills over 400 ms, staggered by 120 ms. The hooks fade up over 200 ms, last. Any key or click jumps to the final state. A second visit to the same board shows the final state straight away.
    - **No pulse and no loop.** Everything happens once. Reduce-motion shows the final state.
    - **Never colour alone.** Every good or bad state carries a sign, an icon or a word. Every icon has a tooltip.
    - **Bright and alive.** The blurred gym stays visible around the card, and no surface goes darker than `#2a2019`.
    - **No logos or brand names.** All portraits are the fighters' own.
[user t35u] # NEW TASK - start fresh, ignore earlier tasks in this thread.

# M41 - Maria: the scene tree as pictures - which rooms, what each shows (2.5D art direction)

Model: the bot's own (design/research agent, no code). Owner: Claude collects it the session it lands.
Nothing opens on the operator's screen. Read files with your file tool only.

## Owned files
- `research/M41_SCENE_TREE_ART_REVIEW.md`
- `previews/m41/`

## Deliver `research/M41_SCENE_TREE_ART_REVIEW.md` + concept images in `previews/m41/`
1. Review the current scenes as PICTURES: which rooms earn a painted scene, which should merge or become a panel.
2. YOUR scene tree as art: per room, the painted shot (camera, what is in frame, where the click objects sit so each one
   READS as its job - a calendar that looks like a calendar, a hiring noticeboard that looks like hiring).
3. THE TRAINING FLOOR in 2.5D (operator: "the fighter training with the coach"): one concept image - your fighter at a
   station (heavy bag / pads / ring), the coach beside him, the stations as click objects. Say what moves in its living loop.
4. Keep the HOME look (painted, bright, alive - "gym art is bright and alive").
Acceptance: a concept image for the training floor + a one-line art brief for every room in your tree.

## Prior research
`research/SCENE_TREE_REVIEW_INPUT.md` (the map + the operator's words - read it whole first),
`research/TRAINING_LOOP_DESIGN.md` (the training floor loop, G112 real gyms + 13 sim games),
`research/FLOW_PASS2_ROUTE_WORDS.md` (every route and its words), `research/S148_SCHEDULE_TUTORIAL_DESIGN.md`
(schedule + tutorial, approved), `research/topics/gym_rooms_art.md` (rooms and art). Cite, do not redo.

## What would a human do?
A UX lead walks the map as a new player with one question per room - "what is this room FOR?" - deletes every second door
to the same screen, and gives each object a job only that room has.

## Prefab check
None to build - this is a review. Name any shipped game whose room/hub navigation you would copy, with the screen.


---
# THE INPUT FILE (SCENE_TREE_REVIEW_INPUT.md), in full

# Scene tree review - the shared input for K85 (Kalli), M41 (Maria), J61 (John)

Operator 2026-10-03 (S150): "i also want other agents to provide their own scene-tree aspect and review the current one".
The page he reviewed: `Godot/docs/scene_tree/scene_tree.html` (pictures of every scene + what each click opens; built by
`Tools/scene_tree_page.py` from the game code). The same map as text is below - you do not need the HTML.

## The operator's comments on the current tree (verbatim)
1. On the Office "Fight calendar -> Schedule": "this exists also in the staff room it is very confusing"
2. On the Locker room "Fight-week board -> Schedule": "here it is again"
3. On the training floor: "in this scene i want to be able to select the move i want to train , be able to preview it in
   animation , why we have training floor with no options to train"
4. Follow-up: "this needs also to be displayed in 2.5d the fighter training with the coach etc"

## Claude's reading (a starting point - challenge it)
- Duplicates: Schedule opens from 3 places (Office calendar, Locker fight-week board, FIGHTS area); Staff from 5 (three
  objects in the Staff room alone, the Mat room coach, FINANCE area). Proposed rule: every object in a room does ONE
  different job; every screen has ONE home room; the left rail is the always-there shortcut.
- The training floor is only a hallway of doors. The engine already trains a chosen move per fighter
  (GameState.assign_technique_training, today buried in the fighter profile's Skills page). Proposal TRAIN1: click a
  station (heavy bag, pads, ring, speed bag) -> pick the fighter -> the moves that station trains, each with an animated
  preview -> TRAIN THIS; the floor painted 2.5D with the fighter working the station beside his coach (living loop).
- Rooms go 2.5D (operator S147): painted stills with click pins like HOME; the fight stays 3D. The office v2 preview is
  done (painted still + 10 s living ring clip in the window).

## The map as it is today (generated from Tools/scene_tree_page.py, which reads the game code)

Left rail (always on screen): HOME -> HOME [SCENE], FIGHTERS -> FIGHTERS area [SCENE], FIGHTS -> FIGHTS area [SCENE], FINANCE -> FINANCE area [SCENE]

### HOME (painted picture)
- Office pin -> Office [SCENE]
- Staff room pin -> Staff room [SCENE]
- The ring pin -> Training
- Gym floor pin -> The training floor [SCENE]

### FIGHTERS area (painted picture)
- Roster -> Roster & floor
- Training -> Training
- The floor -> The training floor [SCENE]
- Scouting -> Scouting

### FIGHTS area (painted picture)
- Schedule -> Schedule
- Rankings -> Rankings
- Offers -> Fight offers

### FINANCE area (painted picture)
- The books -> Finances (the books)
- Office -> Office desk
- Staff -> Staff
- Contracts -> Contracts

### The training floor (3D room today, becomes painted 2.5D)
- Door: front desk / street -> Front desk (lobby) [SCENE]
- Door: office -> Office [SCENE]
- Door: locker room (tier 2+) -> Locker room [SCENE]
- Door: mat room (tier 3+) -> Mat room (classes) [SCENE]
- Door: staff room (tier 4) -> Staff room [SCENE]
- Door: physio (tier 4) -> Physio [SCENE]
- Spar card: watch -> Spar night

### Front desk (lobby) (3D room today, becomes painted 2.5D)
- Out to the city -> FIGHTS area [SCENE]
- Back to the floor -> The training floor [SCENE]

### Office (3D room today, becomes painted 2.5D)
- The books -> Finances (the books)
- The phone -> Promotions (phone)
- Contracts cabinet -> Contracts
- Fight calendar -> Schedule
- Photo wall -> Former fighters
- Back to the floor -> The training floor [SCENE]

### Locker room (3D room today, becomes painted 2.5D)
- The scale -> Weight class
- Fight-week board -> Schedule
- A fighter's locker -> Fighter profile
- Back to the floor -> The training floor [SCENE]

### Mat room (classes) (3D room today, becomes painted 2.5D)
- Dues board -> FINANCE area [SCENE]
- The coach -> Staff
- Back to the floor -> The training floor [SCENE]

### Staff room (3D room today, becomes painted 2.5D)
- Staff board -> Staff
- Hiring noticeboard -> Staff
- A coach -> Staff
- Back to the floor -> The training floor [SCENE]

### Physio (3D room today, becomes painted 2.5D)
- A fighter's body chart -> Fighter profile - body
- Back to the floor -> The training floor [SCENE]

### Film room (3D room today, becomes painted 2.5D)
- Footage screen -> Fighter profile - camp
- Tendencies board -> Fighter profile - camp
- His record (folders) -> Scouting
- Game plan (laptop) -> Fighter profile - camp
- Other files -> Scouting
- Back to the floor -> The training floor [SCENE]

## Constraints that are settled (do not reopen)
- Rooms go 2.5D: painted picture + pins, living loops where cheap (S147, D-ledger). The fight stays 3D.
- The facility is a "gym"; "fight camp" means only the pre-bout preparation.
- Icons with tooltips over text labels (operator 09-30 / 10-01).
- Demo is a boxing career (2026-10-06): sign -> train -> book -> fight -> money -> up the ladder (regional -> national 5 net
  wins -> international 7 more, D32).


Reply with the full deliverable in this chat (markdown; attach images if you make them).
[send-message t35s329] Starting M41. I'm painting the training-floor concept first, then I'll write the room-by-room review and my scene tree.
[send-message t35s330] **M41 The scene tree as pictures.** Twelve scenes become six painted ones. The training floor becomes the hero scene, with the fighter and his coach at a station.

**The cut.** Keep HOME, Training floor, Office, Locker room, Staff room and Film room (late game). The Locker room takes in the Physio as a corner.
- **Deleted as scenes:** the three area pictures (FIGHTERS, FIGHTS, FINANCE), the Front desk, the Mat room and the Physio. The left-rail icons open the screen directly. The front desk's two jobs become two pins on HOME. The mat room's dues board becomes a mat corner on the floor.
- **The rule:** HOME is the only place with doors. The floor has stations, not doors. Every screen has one home object, and the left rail is the only allowed second route.
- **Result:** click objects go from 49 to about 31. Schedule has one home, the Office wall calendar, and the Staff screen has one, the hiring noticeboard.
- **Flag for the operator:** deleting the area pictures is the cut he may resist. The fallback is a small panel with 3 or 4 icon buttons per area, never a painted scene.

**One-line brief per room.** Pins are 64 px circles with a Lucide icon and a tooltip.
- **HOME:** the gym from the street end, one pin per door. The pins are Training floor `dumbbell`, Office `briefcase`, Staff room `users`, Locker room `shirt`, a ladder board `trophy` (Rankings) and a sign-up desk `user-plus` (Scouting).
- **Training floor:** your fighter and his coach at a station, four more stations around, no doors.
- **Office:** the manager's desk and wall. The books are a green ledger (Finances). The phone has pink message slips (Promotions). The filing cabinet has ribboned drawers (Contracts). A wall calendar with a circled day and a glove sticker opens Schedule. Gold frames are the photo wall (Former fighters).
- **Locker room:** a physician's scale (Weight class), a row of name-tagged lockers (each opens that fighter), and a physio corner with a massage table and body chart (the body page). The fight-week board is deleted, because the scale screen already shows the weigh-in countdown.
- **Staff room:** a plain room with a cork noticeboard of pinned cards (Hire tab) and seated coaches. Clicking a coach opens that person's card, not the Staff screen. The staff board is deleted.
- **Film room (later):** one projector screen for footage and tendencies, a laptop for the game plan, and a folder stack for his record and the other files.

**The Training floor** (concept image attached; AI mock art, fictional people, no terms recorded, so it can't ship). It shows the pair on the pads in the middle, the heavy bag left, the ring behind, a speed bag and a rope station on the right. For the final painting, the heavy bag should be brown leather, not black, and the ring canvas should be the M38 green.
- **Five stations**, each a click object with a gold outline on hover (static, no pulse):
  - heavy bag at (430, 560) with `hand-fist`;
  - focus pads at (960, 600) with `target`;
  - speed bag at (1640, 500) with `zap`;
  - the ring at (1380, 430) with `swords`;
  - rope and bench at (1760, 760) with `footprints`.
- **Picker:** a 520 px drawer slides in from the right over the scene. Fighter chips sit across the top. Below are the moves that station trains, each with a 240×240 looping preview of the fighter's 3D model throwing it. One gold TRAIN THIS button at the bottom assigns the move through the existing technique assignment. That answers "why a training floor with no options to train".
- **Living loop:** a 6 s clip of the fighter on the pads with the coach shifting the mitts (the one big clip), a gentle heavy-bag sway, a fast speed-bag bounce, a slow dust and light shaft, a tiny skipper far right and two sparring figures in the ring. A fighter you assign walks to his station in 1.2 s. About 5 small clips in all, and reduce-motion shows the still.
- **Station groupings** (which moves each station trains) are my example, not the real technique list.

**Navigation to copy:** Hollywood Animal's studio lot, with one building per department and one door per job. I'm citing the M34 reference board for it, not a fresh look at the screen.

**Order for the demo:**
1. Training floor still and picker.
2. Re-lay the HOME pins and remove the floor doors.
3. Remove the Schedule door from the Locker room board.
4. Merge the Physio and Mat room.
5. Delete the area scenes. Film room waits until after the demo.

**Still open:**
- I did not open the four prior-research files, so nothing is checked against them.
- The Lucide icon names are from memory and unchecked against the shipped set.
- The map gates the Staff room at tier 4, but hiring is needed early. I recommend opening it from tier 1.
- It is not verified whether the Promotions phone and the Fight offers screen do the same job.

The full document is staged in the repo as `research/M41_SCENE_TREE_ART_REVIEW.md`, with the image in `previews/m41/`. Claude will get a ping when that's done.
[send-message t35s331] The M41 pack is now in the repo on Beast, and Claude has been pinged (mailbox id `2b5188b92368`). The review is at `research\M41_SCENE_TREE_ART_REVIEW.md` and the concept image is in `previews\m41\`. A copy and a land note are in `_maria_delivery\`. Nothing was committed or pushed, and no code or `HANDOFF.md` was touched.

The ping tells Claude to acknowledge and hold, because the pack is art direction only. A file named `TASK_M41_SCENE_TREE_ART_REVIEW.md` was already in that folder, and I left it as it was.
[user t36u] NEW TASK M42 (fresh chat, 2026-10-05). git fetch origin && git rebase origin/master, then read research/TASK_M42_HUB_MOCKUPS.md in full and deliver exactly its Acceptance. Answer first, no process narrative. The brief and Option B are both inside the file. Here is the file verbatim:

# TASK M42 - THE CANDIDATE CARD AND THE FOUR HUBS, MOCKED THE WAY THE PROS SHIP THEM (Maria, art direction)

Model: any. Owner: Maria (gbot, NEW chat). Pictures + a short spec, never code. Output: `research/M42_HUB_MOCKUPS.md` + images
under `research/previews/m42/` (PNG, 1920x1080, our M32 palette and M33 type).

## Why (operator, 2026-10-05, on the exported .exe)
On the coach candidate panel: "does that look like a AAA-management game panel?" - it does not: four raw-number boxes in meaningless
colours, no portrait, no scale, no verdict, a "gap" block that repeats itself in jargon, the guide card covering the panel's buttons.
He asked that each menu and hub be designed by copying a similar game's exact logic.

## Prior research (read first)
Your `M32_MENU_ART_DIRECTION.md`, `M33_ICONS_AND_TYPE.md`, `M34_PITCH_PRESENTATION.md`, `M40_THE_WEEK_REVIEW_LOOK.md` (the one screen
the operator liked - keep that quality bar), `M41` (your scene-tree pictures). `PROFILE_IA_THREE_VERSIONS.md` (seven shared rules).
John transcribes the reference screens field by field in `J62_HUB_REFERENCE_LOGIC.md`; Kalli audits the gaps in
`K86_SCREEN_GAP_AUDIT.md`. Use them when they land; until then mock from Football Manager 24 and Motorsport Manager as you know them
and say so.

## The shipped screens you are replacing
`previews/s165_exe_walk/14_candidate.png` (fighter candidate), the operator's coach candidate frame (teaching 59 / tactics
50 / rating 55 / weeks 29 tiles), `21_home_signed.png` and `31_home_booked.png` (HOME), `25_offers.png` (FIGHTS offers),
`s165_story_beside/20_my_gym_next_up.png` (SCHEDULE), the FINANCE screen (`Godot/scripts/MoneyHubPanel.gd` if you need the fields).

## What would a human do?
A AAA UI artist takes the reference's LOGIC (what is shown, in what order, how a number is explained) and dresses it in the house
style, never the reverse. One mock per screen at game size, then a redline: every text's exact words, size, colour token, every
tooltip's words, where the primary button sits, what the empty state says.

## The job (in this order; ship each as it is done)
1. THE CANDIDATE - coach, and THE CANDIDATE - fighter: identity strip (portrait, name, flag, age, role/division), attributes on a stated
   scale with band colours AND band words, one verdict sentence, the ask in plain words, "what changes in your gym" (one line), one
   primary button, one quiet button. The guide card must have a home that never covers it.
2. HOME with one booked fighter (keep the 3D gym and the pins; fix the right column's hierarchy and the fighter row).
3. FIGHTS - OFFERS (an offer row the way a boxing manager shows it: opponent card, purse, date, venue, the match-up sentence, accept).
4. FINANCE overview (balance, weekly net, next bill, the sentence about your situation).

## Prefab check
Our own UIKit components (`Godot/scripts/UIKit.gd`: pair, plate, button, filter_strip, tip) - design with what exists where it fits;
name any new component once.

## Acceptance
Mocks at 1920x1080 for the five screens + `M42_HUB_MOCKUPS.md` with the redlines (every label's words, tooltip texts, colour tokens).
Answer first, no process narrative.

## OPTION B - "the gym is the menu" (operator, 2026-10-05, 18:40, verbatim: "remove the menus and use the 3d engine maybe for everything ? put a timeline bar on top to progress continuously and pose in menus or something like that")
Answer this alongside the hub work, as a second direction: no rail; the 3D gym (we have it, with room pins and the ring) IS the home;
you click a room, a person or the ring and a panel opens OVER the 3D view; a TIMELINE BAR across the top runs time continuously
(day ticks, with pause / 1x / 3x) and PAUSES whenever a panel is open; dated things (weigh-in, fight night, bills, offers expiring)
sit on the bar ahead of the playhead. References to transcribe for this option: Two Point Hospital (clock + speed + the building as the
menu), Planet Coaster / Prison Architect (click an object, panel over the world, time controls), Motorsport Manager (the race-day
timeline), Football Manager's continue-until-the-next-event vs a real-time clock. Say what each one does when a decision is due
(does time stop? a card? a flashing pin?) and what a boxing-gym manager loses or gains by going continuous: the one-decision-a-day
rhythm, the week review, the fight camp count-down. Give one page per option: A (rail + hubs, repaired) and B (gym-as-menu +
timeline), with the same first hour walked through both, so the operator can choose on paper (DESIGN_ON_PAPER_S159 rule).
[send-message t36s333] Five hub mocks at 1920×1080 plus Option A/B on paper. Reading the brief and the prior packs now.
[send-message t36s334] Beast is offline, so I'm building the five mocks and the Option A/B pages on my computer from the M32–M41 packs, then staging when Beast reconnects.
[send-message t36s335] Brief and priors are in. Building the five 1920×1080 mocks and the Option A/B pages now.
[send-message t36s336] Mocks and the Option A/B pages are rendering now. I'll send the five boards and the redline when they're ready.
[send-message t36s337] **Recommend Option A** (rail + hubs, repaired). Ship these five boards now; keep Option B as a later “live gym” pitch — continuous time fights the week review and the fight-camp countdown.

Five 1920×1080 mocks + redlines in `M42_HUB_MOCKUPS.md` (3,671 words). Logic from FM24 / Motorsport Manager knowledge — J62/K86 not landed (NOT VERIFIED). All strings EXAMPLE.

Beast is offline, so nothing is in `research/` yet and Claude is not pinged. Pack is ready on my computer at `/workspace/fightcamp-m42/` — say when Beast is back and I’ll stage + mailbox.
[send-message t36s338] 
[send-message t36s339] **Option B board** (gym-as-menu + timeline): hard-pause when a panel opens; dated chips on the bar; flashing pin on the room that needs you.

**A vs B in one line:** A keeps Continue → week → week review and a `Fight in 3 weeks` hero; B gains place-feel and loses the week as a unit.

Full redlines, tooltips, colour tokens, first-hour walkthroughs for both, and the cut list are in the MD below. New components named once: `candidate_card`, `band_bar`, `guide_dock`, `offer_row`, `timeline_bar`.
[send-message t36s340] Pick A or B on paper when you have a minute. I’ll stage to Beast and ping Claude the moment Beast is back.
[user t37u] The operator ruled on NAV1 today: "go" - Option B (the gym is the menu + timeline bar, hard pause on every decision, the week review and every dated gate). Your A recommendation is noted; it becomes acceptance for TIMELINE1. Please paste your FULL file here as plain markdown in the chat (Beast is still unreachable from your box) - every section, no summary - so Claude can land it. Include the timeline_bar, candidate_card and offer_row redlines + tooltips + colour tokens.
[send-message t37s342] NAV1 noted: Option B is the go. My A recommendation stands as TIMELINE1 acceptance. Full `M42_HUB_MOCKUPS.md` below for Claude to land.
[send-message t37s343] # M42 Hub mockups

*Maria, art direction. Pictures + redlines. No code. All player-facing strings are EXAMPLE (Kalli owns words). Always "the gym", never "camp" for the building. A fight camp is the pre-bout prep only. J62 / K86 have NOT landed — mocks follow Football Manager 24 and Motorsport Manager logic from knowledge; marked NOT VERIFIED against those transcripts.*

**NAV1 addendum (operator 2026-10-05):** go Option B (gym is the menu + timeline bar, hard pause on every decision, the week review and every dated gate). The Option A recommendation in §0 / §7 becomes acceptance criteria for **TIMELINE1** (what the timeline must still protect: week unit, week review, fight-camp countdown).

## 0. Answer first

Shipped five 1920×1080 hub mocks (coach candidate, fighter candidate, HOME booked, FIGHTS offers, FINANCE) plus one optional Option B board (gym-as-menu + timeline), all under `previews/`, dressed in the M32 palette and M33 type at the M40 quality bar. Every attribute is a labelled bar on a stated 0–100 scale with a band word; every card has one GOLD primary, one quiet secondary, and a tip dock that never covers the buttons. **Recommend Option A now** (rail + hubs, repaired): the week unit, the week review, and the fight-camp countdown need a discrete week, which Option B's continuous clock fights. Keep Option B as a pitched "live gym" mode for later, not the Early Access spine. [J]

---

## 1. Reference logic used

**Sources:** Football Manager 24 (staff / player shortlist panels, offer inbox, finances overview) and Motorsport Manager (race-weekend timeline, staff hire card, HQ as place) — from Maria's own knowledge. **J62_HUB_REFERENCE_LOGIC.md and K86_SCREEN_GAP_AUDIT.md have NOT landed.** Treat every field order below as a design proposal, not a verified transcript. NOT VERIFIED.

**What was copied as LOGIC (never as look):**

| Reference | Logic borrowed | Where it lands |
|---|---|---|
| FM24 staff / player shortlist | Identity strip → attributes on a stated scale with labels → one verdict / recommendation → wage ask → confirm / reject | Candidate coach + fighter |
| FM24 transfer / offer inbox | Filter strip → opponent identity → financial terms → date / venue → match-up sentence → Accept / Decline | FIGHTS — Offers |
| FM24 finances | Balance hero → weekly net with sign → next obligation → situation sentence → period bars | FINANCE |
| Motorsport Manager HQ | Building as place; click a room, a panel opens | HOME gym floor + Option B |
| Motorsport Manager race-day timeline | Dated chips ahead of a playhead; time controls | Option B only |
| M40 week review (operator-liked) | Hierarchy: one hero, then obligations, then list; brass warmth only where it fits the M32 shell | HOME right column, FINANCE heroes |

**What was NOT copied:** any FM / MM colour, type, icon, or layout pixel. House style is M32 lit blue-grey + M33 Inter + Lucide-named line icons drawn in Pillow.

---

## 2. Redlines per screen

Colour tokens used everywhere: `GROUND #1c2230`, `PANEL #2a3347`, `PANEL_HI #34405a`, `TRACK #111621`, `TEXT #f3f5fa`, `TEXT_2 #c9d1e0`, `MUTED #a3afc4`, `DIM #6d7688` (disabled only), `INK #1b1207`, `GOLD #f0c233` (one primary per board), `GO #22c55e` (Continue only, text INK), `GYM #2f6fb0`, `GOOD #4fc46a`, `AMBER #f0a020`, `BAD #e5433a`, `BAD_TEXT #f2766f`, `LINK #7fb6ee`. Type: Inter Variable — Label 15/600 CAPS ≤24ch tracked, Meta 15/450, Body 18/400, Group 22/600, Screen 30/650, Hero 44/650 + tnum. Sentence case except eyebrows.

### 2.1 Candidate — coach (`m42_candidate_coach.png`)

**Shell:** left rail 72px (Staff active), top bar 64px (gym name, week, cash labelled, Continue GO).

**Modal** 1000×820, centred over dimmed gym. Level-2 surface, r=14.

| Region | Words (EXAMPLE) | Size / weight | Token | Notes |
|---|---|---|---|---|
| Eyebrow | `COACH CANDIDATE` | Label 15/600 CAPS | MUTED | ≤24ch |
| Name | `Elena Vos` | Screen 30/650 | TEXT | |
| Flag | `CY` + tiny flag rect | Meta 14/600 | TEXT_2 | |
| Age / role | `Age 44 · Head coach` | Meta 15/450 | MUTED / TEXT_2 | |
| Availability | `29 weeks available` | Meta 15/450 | MUTED | right-aligned |
| Scale legend | `ATTRIBUTES · 0–100` + Poor / Average / Good / Strong / Elite | Label + 13/500 | band colours | stated scale, always |
| Attr rows | `Teaching 59 Good` · `Tactics 50 Average` · `Rating 55 Good` | Meta label + 18/650 number + 15/600 word | band colour on fill + word | never bare coloured boxes |
| Verdict eyebrow | `VERDICT` | Label | MUTED | |
| Verdict body | `Solid teacher for a regional gym; tactics will need a film partner.` | Body 18 | TEXT | one sentence |
| Ask label | `The ask` | Meta | MUTED | |
| Ask value | `$1,800 / week` | Group 22/600 | GOLD | unit always |
| Changes label | `What changes in your gym` | Meta | MUTED | |
| Changes body | `Adds a teaching focus on the training floor; wages +$1,800 / week.` | Body | TEXT_2 | one line |
| Primary | `Hire Elena` | 18/600 | INK on GOLD | bottom-right |
| Secondary | `Not now` | 17/600 | TEXT_2, PANEL_HI outline | left of primary |
| Tip dock | `TIP` / `Bars show band and number. Hire only if wages fit the week.` | Label + Meta | GOLD icon, TEXT_2 | bottom-left of modal; never over buttons |

**Tooltips (EXAMPLE):**
- Teaching bar: `Teaching · 0–100 · Good band starts at 55.`
- Hire Elena: `Confirm hire. Wages start this Monday.`
- Not now: `Close. Candidate stays on the shortlist for 2 weeks.`

**Empty state (no candidates):** modal replaced by a plate — `No coaches waiting.` / `Open Staff → Scout when a shortlist lands.` Primary becomes `Open Staff` (quiet).

**Guide home:** `guide_dock` component, docked bottom-left of the modal, never floating over the action row.

### 2.2 Candidate — fighter (`m42_candidate_fighter.png`)

Same shell and modal chrome as coach. Roster rail active.

| Region | Words (EXAMPLE) | Notes |
|---|---|---|
| Eyebrow | `FIGHTER CANDIDATE` | |
| Name / meta | `Kit Navarro` · `Age 19 · Light-welter` · `Amateur · Level 2` | |
| Attrs | `Power 62 Good` · `Speed 71 Strong` · `Chin 48 Average` · `Stamina 66 Good` | same `band_bar` |
| Verdict | `Fast hands, green chin — a craft programme first.` | |
| Ask | `$420 / week dues` | GOLD |
| Changes | `Opens a locker; dues +$420 / week; first fight bookable.` | |
| Primary / secondary | `Sign Kit` / `Pass` | |
| Tip | `Bars show band and number. Sign only if dues fit the week.` | |

**Tooltips (EXAMPLE):** `Sign Kit` → `Confirm signing. Dues start this Monday.` · `Chin` → `Chin · 0–100 · Average band is 40–54.`

### 2.3 HOME — one booked fighter (`m42_home_booked.png`)

**Shell:** Home rail active. Centre = stylized gym floor (warm light, RING gold outline, 6 pin discs: Train / Office / Locker / Staff / Ladder / Scout). Right column hierarchy is the fix.

| Block | Order | Words (EXAMPLE) | Type | Token |
|---|---|---|---|---|
| NEXT UP hero | 1 | eyebrow `NEXT UP` · `Kit Navarro` · `Fight in 3 weeks` · gold pill `Booked` · `vs Soren Haldane` · `Harbour Arena · Sat 15 Feb` · countdown `21 days` | Group / Body / Meta / 22 tnum | surface level 3 (gym wash); pill INK on GOLD |
| Obligations | 2 | eyebrow `OBLIGATIONS` · three chips: `Lease Due Fri $2,400` · `Wages Due Mon $3,200` · `Bills Due Wed $480` | Meta + 18/650 | surface level 1; icons building / users / clipboard |
| Your fighters | 3 | eyebrow `YOUR FIGHTERS` · meta `1 booked · 1 on roster` · row Kit + `Booked` pill · empty slot `Scout a second fighter` / `Empty locker — open scouting` | Body / Meta | level 2 row; empty = outline only |
| Floor tip | — | `Click a pin to open that room` | Meta | LINK info icon |

**Tooltips (EXAMPLE):**
- Booked pill: `Fight booked. Opens the fight-camp countdown on Schedule.`
- Lease chip: `Lease due Friday · $2,400.`
- Scout pin: `Open scouting. Find a second fighter.`
- Continue: `Advance one week. Bills and calls land on Monday.`

**Empty state (no booked fight):** NEXT UP becomes `No fight booked` / `Open Fights to take an offer.` Primary quiet button `Open Fights`.

### 2.4 FIGHTS — Offers (`m42_fights_offers.png`)

**Shell:** Fights rail active. Title `Fight offers` (Screen 30/650). Meta `3 open · sorted by date`.

**Filter strip** (`filter_strip`): `All` (active, GYM fill) / `Regional` / `Title` — pill height 36, 16/600.

**Offer row** (`offer_row`) — one per card, 168px tall:

| Field | Words (EXAMPLE) | Type | Token |
|---|---|---|---|
| Opponent | silhouette + `Soren Haldane` | Group 22/600 | TEXT |
| Record / div | `12–2 · Light-welter · Regional` | 18/650 + Meta | TEXT_2 / MUTED |
| Match-up | `Even on paper — his pressure vs your reach.` | Body | TEXT_2 |
| Purse eyebrow | `PURSE` | Label | MUTED |
| Purse | `$8,400` | 26/650 | GOLD |
| Date / venue | `Sat 15 Feb` · `Harbour Arena` + map-pin | Meta | TEXT_2 / MUTED |
| Primary | `Accept` | 18/600 | INK on GOLD, top-right of row |
| Secondary | `Decline` | 16/600 | quiet, under Accept |

Featured (first) row uses surface level 2; others level 1. Same pattern for Marco Vellin and Ilya Petrov (see mock).

**Tooltips (EXAMPLE):** `Accept` → `Book this fight. Opens the fight-camp countdown.` · `Decline` → `Remove offer. Promoter may not return this card.` · filter `Title` → `Show title fights only.`

**Empty state:** `No offers waiting.` / `Promoters call when a fighter is sharp and free.` Quiet `Open Roster`.

### 2.5 FINANCE overview (`m42_finance.png`)

**Shell:** Finance rail active. Title `Finance`. Meta `Week 4 · cash on hand`.

| Block | Words (EXAMPLE) | Type | Token |
|---|---|---|---|
| Balance hero | eyebrow `BALANCE` · `$24,180` · pill `Cash on hand` | Hero 44/650 tnum | surface level 3 |
| Weekly net | eyebrow `WEEKLY NET` · `−$312` + trending-down · pill `Loss week` | Hero | BAD_TEXT; glyph + word (never hue alone) |
| Next bill | eyebrow `NEXT BILL` · `Wages due Mon` · `$3,200` · `Lease chip still on the calendar` | Group + 28/650 | AMBER value |
| Situation | `Two profitable weeks would clear the lease chip.` | Body | TEXT on sunk plate; LINK info icon |
| Last four weeks | `W1 +$840` · `W2 −$210` · `W3 +$420` · `W4 −$312` | 16/650 tnum | GOOD / BAD_TEXT bars around a zero line |
| This week | `Dues in +$420` · `Purse (none) $0` · `Wages −$3,200` · `Lease −$2,400` · `Bills −$480` | Body + 18/650 | sign + colour + icon each row |

M40 brass warmth was considered and **cut** here in favour of M32 shell consistency; hierarchy (NET hero, IN vs BILLS, next hooks) is what was borrowed. [J]

**Tooltips (EXAMPLE):** `Loss week` → `Outgoings beat income this week by $312.` · `Wages due Mon` → `Staff and fighter wages clear every Monday.`

**Empty / first week:** bars show a single `W1` with `No history yet`; situation becomes `Your first week sets the baseline.`

### 2.6 Option B board (`m42_option_b_timeline.png`) — optional

No left rail. Timeline bar 72px across the top: Pause (active) / 1× / 3×, date, track with playhead, dated chips (`Wages`, `Weigh-in`, `Fight night`, `Offer ends`), cash right. Full-bleed gym floor. Office pin flashing gold. Decision panel over the 3D view with gold edge, `Time paused` pill, Vale offer, Sign / Decline, tip dock. Footer legend: `Option B · gym is the menu · timeline across top`.

**Decision-due rule (picked):** time **stops** and a **card opens** over the gym; the triggering pin flashes gold until the card is resolved. No silent auto-resolve. [J]
[send-message t37s344] ## 3. New components (named once)

| Component | What it is | Used on |
|---|---|---|
| `candidate_card` | Modal: identity strip + band attrs + verdict + ask + changes + primary/secondary | Coach, Fighter |
| `band_bar` | Label · track 0–100 · fill in band colour · number · band word | Candidate cards |
| `guide_dock` | Tip plate docked bottom-left of a modal; never covers actions | Candidates, Option B |
| `offer_row` | Opponent card · purse · date · venue · match-up · Accept / Decline | FIGHTS offers |
| `next_up_hero` | Level-3 right-column hero: portrait, countdown, Booked pill | HOME |
| `obligation_chip` | Icon + label + due date + amount | HOME |
| `timeline_bar` | Speed controls + playhead + dated chips + cash | Option B |
| `gym_floor_stage` | Warm-lit floor, RING, pin discs | HOME, Option B |

---

## 4. UIKit reuse

Existing (`Godot/scripts/UIKit.gd`) — design with what exists:

| UIKit | How M42 uses it |
|---|---|
| `pair` | Ask label/value, obligation label/amount, finance row label/amount |
| `plate` | Verdict sunk plate, situation sentence, tip dock body |
| `button` | Primary GOLD, quiet outline, Continue GO — map to existing kinds |
| `filter_strip` | FIGHTS All / Regional / Title |
| `tip` | Becomes the visual content inside `guide_dock` (new home, same words) |

New components above are **named once** for engineering; they compose UIKit primitives where they fit. No `.gd` in this pack.

---

## 5. OPTION A — rail + hubs, repaired (one page)

**Spine:** left rail stays. Each hub is a screen. Time advances in **weeks** via Continue (GO). Story cards and bills land on Monday. Fight-camp countdown is a visible week chip on NEXT UP and Schedule.

**First hour, minute by minute (Chapter 1 — The Keys):**

| Min | What the player sees (Option A) |
|---|---|
| 0–2 | Title → New Career (3 screens: division, gym name, Story on/off) |
| 2–5 | HOME loads. NEXT UP empty. Tip: `Sign your first boxer.` Office pin pulses once. |
| 5–12 | Scout from Roster / Scout pin → fighter `candidate_card` (Kit). Sign. |
| 12–18 | Training floor via Train pin / rail. Pick a station for Kit. |
| 18–22 | Staff → coach `candidate_card` (Elena or Rafi). Hire or pass. |
| 22–28 | FIGHTS → Offers (or a first amateur card). Accept one. NEXT UP becomes the hero. |
| 28–35 | Continue ×2. Week review (M40). Lease chip appears on Obligations. |
| 35–48 | Fight night from Schedule / Continue. Ring, corner, scorebug, result. |
| 48–55 | Result → HOME. Clipping on the Wall (story). NEXT UP clears or shows rematch hook. |
| 55–60 | Chapter card. Demo ends on `Someone left a card at the front door.` |

**What A keeps:** one-decision-a-day rhythm, M40 week review, fight-camp countdown in weeks, rail as a map of verbs, guide tips that have a fixed home.

**What A costs:** the gym floor is a stage behind hubs, not the menu itself; some players will still feel "menu-y". [J]

---

## 6. OPTION B — gym-as-menu + timeline (one page)

**Spine:** no left rail. The 3D gym **is** Home. Click a room, a person, or the ring → a panel opens **over** the 3D view. A **timeline bar** across the top runs time continuously (Pause / 1× / 3×) and **pauses whenever any panel is open**. Dated chips sit on the bar ahead of the playhead: weigh-in, fight night, bills, offers expiring.

**Reference behaviours (from knowledge — NOT VERIFIED against transcripts):**

| Game | When a decision is due |
|---|---|
| Two Point Hospital | Clock runs; a flashing queue / alert icon appears; opening the panel does not always hard-pause unless you pause. |
| Planet Coaster / Prison Architect | Click object → panel over world; time keeps running unless the player pauses — urgency is soft. |
| Motorsport Manager (race day) | Timeline chips; session phases pause for setup decisions; race itself runs with limited intervention. |
| Football Manager | No real-time clock — **continue-until-next-event**. Interruptions are cards between continues, not a live playhead. |

**FightCamp Option B pick:** hard-pause + card (Motorsport session decision × FM card). A flashing pin marks the room. Time does not crawl behind a half-read offer. [J]

**What a boxing-gym manager gains:**
- The gym feels like a place, not a spreadsheet with a wallpaper.
- Dated chips make fight night, weigh-in and bills *visible ahead of the playhead*.
- Panels-over-world matches how the operator asked to "pose in menus".

**What a boxing-gym manager loses:**
- **One-decision-a-day rhythm** dissolves into continuous time; the player can overspeed past a lease chip.
- **Week review (M40)** has no natural home — a week is no longer a unit unless we fake week boundaries on the bar.
- **Fight-camp countdown** (3 weeks out) becomes a distance on a scrubber, easier to miss than a NEXT UP hero with `21 days`.
- Teaching / guide cards compete with a live clock; pause discipline becomes a skill.

**First hour, same walkthrough (Option B):**

| Min | What the player sees (Option B) |
|---|---|
| 0–2 | Title → New Career. Drops into the gym with timeline on Pause. |
| 2–5 | Locker pin flashes. Tip dock: `Sign your first boxer.` Open locker → scout list panel. |
| 5–12 | Fighter candidate panel over gym. Sign Kit. Pin stops flashing. |
| 12–18 | Click Train pin → training panel. Assign Kit. Close panel. |
| 18–22 | Staff pin flashes (coach card). Hire or pass. |
| 22–28 | Ring pin / Fights chip on timeline → offers panel. Accept. `Fight night` chip appears ~21 days ahead. |
| 28–35 | Set speed 1×. Playhead moves. `Wages` chip arrives → auto-pause + wages panel. Resolve. |
| 35–48 | Playhead hits `Fight night` → hard pause, walkout panel, then fight. |
| 48–55 | Aftermath panel over gym. Wall updates. |
| 55–60 | Chapter card. Same demo hook. |

---

## 7. Same first hour — A vs B

| Beat | Option A (rail + hubs) | Option B (gym + timeline) |
|---|---|---|
| Sign first fighter | Roster / Scout rail → candidate modal | Flashing Locker pin → panel over gym |
| Hire coach | Staff rail → candidate modal | Flashing Staff pin → panel over gym |
| Book first fight | Fights hub → offer_row Accept | Timeline chip or Ring pin → offers panel |
| Feel time pass | Continue (week) | Playhead + speed; Pause on panels |
| See the lease | Obligations on HOME; week review | `Wages` / bill chips on the bar |
| Fight-camp countdown | NEXT UP `Fight in 3 weeks` + `21 days` | Distance to `Fight night` chip |
| Guide / tip home | `guide_dock` on modal; handbook pages | Same dock; must not fight the clock |
| Demo end | Chapter card on HOME | Chapter card over gym, timeline paused |

**Recommendation [J]:** Ship **Option A** for Early Access. It protects the M40 week-review quality bar, the one-decision-a-day teaching loop, and the fight-camp countdown the operator already understands. Build Option B as a design pitch / later "Live Gym" mode once the hubs are repaired and the week loop is loved. Do not rip the rail out before the candidate card and HOME hierarchy ship.

---

## 8. Cut list / open flags

**Cut first if scope slips:**
1. Option B board (keep the page in this MD; drop the PNG from the land if needed).
2. Featured vs normal offer_row elevation (one surface level is enough).
3. Four-week finance bars (keep Balance / Net / Next bill / situation sentence).

**Open flags:**
- J62 / K86 not landed — re-check field order when John / Kalli ship. NOT VERIFIED.
- Fighter vs coach candidate share one `candidate_card` layout; confirm with engineering that one scene + data swap is enough.
- HOME gym floor is a **stylized stand-in**; final art uses the real 3D gym (M41 tree). Pins must match live room names.
- Continue GO stays the only green button; never reuse GO for Accept.
- Story Wall / chapter card not mocked here (see STORY1_MARIA / M34) — HOME only shows the hook line in NEXT UP empty state.
- MMA hooks: offer filters gain `MMA` later; band_bar and candidate_card stay sport-agnostic.

---

## 9. Self-attack

- **These are still panels.** A player who hates management UIs will still see a modal. Option B is the honest answer to that hate, and we are recommending A — that is a tradeoff, not a dodge. [J]
- **Band words can lie.** "Good" at 55 and "Good" at 69 feel different; if playtests confuse them, split Good into two bands or show the numeric range in the tooltip only — do not add more colours. [J]
- **HOME right column is dense.** Obligations + fighters under NEXT UP may still feel like a stack on small laptops; if so, collapse Obligations to a single `3 due this week` chip that opens a plate. [J]
- **Reference logic is from memory.** When J62 lands, any field John transcribed that we missed should win over this pack. NOT VERIFIED.
- **Silhouette portraits are honest placeholders.** Shipping them as final would look cheap next to a 3D fighter; they are the M33 rule until photo / render portraits exist.
- **Option B hard-pause may feel stop-start** in a long week with many chips; if we ever build it, cap to one auto-pause per day and queue the rest. [J]

---

*Pack paths (Beast staging targets): `research/M42_HUB_MOCKUPS.md`, `research/previews/m42/*.png`. Renderer: `render_m42.py` (Pillow, 2× supersample, LANCZOS). No `.gd` / `.tscn` / git commits in this pack.*

---

### Component redline extract (for TIMELINE1 / Claude land)

**Colour tokens (all screens):** `GROUND #1c2230` · `PANEL #2a3347` · `PANEL_HI #34405a` · `TRACK #111621` · `TEXT #f3f5fa` · `TEXT_2 #c9d1e0` · `MUTED #a3afc4` · `DIM #6d7688` (disabled only) · `INK #1b1207` · `GOLD #f0c233` (one primary per board) · `GO #22c55e` (Continue only, text INK) · `GYM #2f6fb0` · `GOOD #4fc46a` · `AMBER #f0a020` · `BAD #e5433a` · `BAD_TEXT #f2766f` · `LINK #7fb6ee`.

**`band_bar` bands (0–100):** Poor 0–39 `BAD_TEXT` · Average 40–54 `MUTED` · Good 55–69 `GOOD` · Strong 70–84 `LINK` · Elite 85–100 `GOLD`. Always: label + fill + number + band word (never hue alone).

**`candidate_card` tooltips (EXAMPLE):** Teaching `Teaching · 0–100 · Good band starts at 55.` · Hire `Confirm hire. Wages start this Monday.` · Not now `Close. Candidate stays on the shortlist for 2 weeks.` · Sign Kit `Confirm signing. Dues start this Monday.` · Chin `Chin · 0–100 · Average band is 40–54.`

**`offer_row` tooltips (EXAMPLE):** Accept `Book this fight. Opens the fight-camp countdown.` · Decline `Remove offer. Promoter may not return this card.` · Title filter `Show title fights only.`

**`timeline_bar` (Option B / NAV1 go):** height 72px · Pause / 1× / 3× · date · track + playhead · dated chips ahead (`Wages`, `Weigh-in`, `Fight night`, `Offer ends`) · cash right. **Hard pause on every decision** (panel open, week review, every dated gate). Triggering pin flashes GOLD until resolved. No silent auto-resolve.

**TIMELINE1 acceptance (from my A recommendation):** the timeline must still protect (1) a discrete week unit, (2) the M40 week review as a gate, (3) a fight-camp countdown readable as weeks/`21 days`, not only as scrubber distance.
[user t38u] # TASK M43 - Art reference: ONE real photo per zone of a working boxing gym (pictures + redlines only, never code)

You are Maria, the art director. Reply in this chat with ONE document (links + one line per photo on what to copy).

## Context
FightCamp is a boxing gym management game (Godot 4, 3D). The operator REJECTED our 3D gym floor (2026-10-08, verbatim): "What you
designed it doesn't look like a gym at all. I see a board in the middle, a chair. You have a bathtub in the gym floor [...] Do gym floor
have bathtubs? The whole design is very bad." We are redesigning it from real gyms. The new floor holds ONLY training: ring, bag line,
speed bags, mirror wall + skipping/shadow-boxing strip, a small cardio corner (treadmill, air bike), a small weights corner, a stretch
corner (mats, foam rollers - no tubs, no tables), the coach's office with a window onto the floor, the entrance from the street.

## Prior research
M30 (floor composed for the old 2D kit), M41/M42 (hub mocks) - none used photos of REAL working boxing gyms per zone. That is the gap.

## What would a human do?
Pull up photos of real gyms (Gleason's, Kronk, Wild Card, Repton, Peacock, an English ABC club, a Japanese club gym, a modern city
boxing club) and pick, for each zone, the photo that shows best how it really looks: materials, colours, what hangs where, the clutter.

## The deliverable
For each zone: ring | bag line | speed bag wall | mirror wall + skipping strip | cardio corner | weights corner | stretch corner |
coach's office window onto the floor | entrance / reception from the street | the walls (posters, timer, racks, benches) | the floor:
- the photo URL (any source - for reference only, nothing ships),
- one line: what to copy (material, colour, height, count, clutter),
- one line: what our current floor gets wrong against it (our stills: grey carpet, 2 bags on thin ropes, a speed bag that reads as a
  side table, a ring on a tall black box with 3 ropes, rugs, a TV cabinet, a fridge, a bathtub).
Finish with a 6-colour palette for the new floor (hex) and 5 props we must add for a "lived-in" look. Max 120 lines. Title "M43 - Gym zones from real gyms".
[send-message t38s346] I'm on M43: finding one real gym photo for each zone, with the link checked, before I write it up.
[send-message t38s347] I'm pulling and checking real photos now, mostly from Gleason's, Kronk, Wild Card, Repton, ABC clubs and Japanese club gyms. When they're in I'll send the full M43 document in one go: 11 zones, the palette, and the props. Any zone I can't find a real photo for will be marked NOT FOUND rather than filled with a guess.
[send-message t38s348] # M43 - Gym zones from real gyms

Reference only, nothing ships. Every link below was opened and the photo checked. Sizes marked "est." are judged by eye from the photo, not measured. Hex values are sampled from the photos, so lighting shifts them.

## 1. Ring
- Photo: [Gleason's ring corner (Business Insider)](https://i.insider.com/5a0e0875f914c359018b471d?width=1200&format=jpeg)
- Copy: 4 red ropes, blue canvas (#3e67a1), white padded turnbuckle covers, apron at about bench height (est. 0.9–1.0 m), on an open frame with rope lacing under the apron, with steps, a bench and mats right against it.
- We get wrong: our ring sits on a tall solid black box with 3 ropes. Real rings have 4 ropes, a visible frame or skirt, and stand low enough to lean on.
- Alt: [GOPANDA, Tokyo](https://gopanda.jp/?p=2610), a floor-level Japanese club ring with black canvas, 4 white ropes and a steel overhead frame.

## 2. Bag line
- Photo: [Gleason's heavy bags (Business Insider)](https://i.insider.com/5a0e0876f914c352018b4714?width=1200&format=jpeg)
- Copy: 6 mixed-brand bags (black, red, one cracked teardrop) on heavy chains from a steel ceiling rail. Bags est. 1.2–1.5 m long, hanging 0.4–0.6 m off the floor, est. 1.5–2 m apart.
- We get wrong: 2 bags on thin ropes read as a prop, not a line. We need 5–6 bags on chains and a rail, with worn and mismatched leather.

## 3. Speed bag wall
- Photo: [Gleason's speed bags (Business Insider)](https://i.insider.com/5a0e0876f914c346018b4702?width=1200&format=jpeg)
- Copy: 2 stations side by side. Each is a round natural-wood board (#bc8243, est. 60 cm) on a black steel wall bracket at head height, with a red bag, and the wall under it plastered with photos and stickers.
- We get wrong: our speed bag reads as a side table. A real one is a round board bolted to the wall at head height, with the bag hanging below it, and never a free-standing object.

## 4. Mirror wall + skipping strip
- Photo: [Gleason's mirror and skipping (Business Insider)](https://i.insider.com/5a0e0875f914c356018b471f?width=1200&format=jpeg)
- Copy: a mirror from floor to about 2.2 m (est.) between black columns, a clear strip of bare painted concrete in front for skipping and shadowboxing, banners overhead, and angle pads bolted to the columns.
- We get wrong: we have no mirror and no open strip. Our rugs and furniture fill the space where a fighter would skip.

## 5. Cardio corner
- Photo: [Gleason's treadmills (Business Insider)](https://i.insider.com/5a0e0875f914c357018b470f?width=1200&format=jpeg)
- Copy: 5 grey commercial treadmills in a tight row facing a big steel-framed window, with a radiator under it, a red wall and fight banners above.
- We get wrong: we have no cardio at all. Air bike: NOT FOUND in a boxing gym photo. A spin bike on teal mats is the nearest ([SolidBox, Yokohama](https://www.tokky7.com/entry-2021-8-27/)).

## 6. Weights corner
- Photo: [Gleason's weights (Business Insider)](https://i.insider.com/5a0e08753dbef4ae078b68fe?width=1200&format=jpeg)
- Copy: a 2-tier rack of about 30 rusty cast-iron dumbbells, plate trees, a pull-up/dip station, a wooden plyo box and black rubber tiles. It's small and crammed.
- We get wrong: we have no weights. Keep it as a cramped corner, not a shiny fitness floor.
- Alt: [Kronk, Detroit "Emanuel's Corner" (Commons)](https://commons.wikimedia.org/wiki/File:Emanuel%27s_Corner_%E2%80%94_KRONK_Gym,_Brewster-Wheeler_Recreation_Center,_Detroit.jpg): a half rack and flat bench on speckled rubber, with yellow and red walls.

## 7. Stretch corner
- Photo: NOT FOUND as a dedicated mat-and-roller zone. The nearest is [GOPANDA, Tokyo](https://gopanda.jp/wp-content/uploads/2024/06/240521_HKPN_02_edit-2048x1363.jpg), left side.
- Copy: a white ladder shelf with about 4 smooth foam rollers and 2 grid rollers, storage cubes, and rubber floor. The Gleason's ring photo (zone 1) adds a blue mat on a padded bench.
- We get wrong: our bathtub and tables have no place here. The whole corner is mats on rubber and a shelf of rollers.

## 8. Coach's office window onto the floor
- Photo: NOT FOUND. The nearest is [Gleason's owner's office (Business Insider)](https://i.insider.com/5a0e0876f914c31f008b475a?width=1200&format=jpeg).
- Copy: a wall of about 70 framed photos, 3 title belts, black wire shelving, and a long wooden desk with Everlast banners on the front. Our window onto the floor is our own design choice and NOT VERIFIED from a photo.
- We get wrong: our TV cabinet and fridge read as a living room. The office should look like a cluttered desk behind glass.

## 9. Entrance / reception from the street
- Photo: [Gleason's, 130 Water St (Commons)](https://commons.wikimedia.org/wiki/File:Gleason%27s_Gym,_130_Water_Street,_Brooklyn_NY.jpg)
- Copy: a warehouse front with a black blade sign, about 7 concrete steps up to a green door, and fight posters in the windows. Inside: red walls, a grey desk and kit on mannequins ([Gleason's reception](https://i.insider.com/5a0e08763dbef471018b6912?width=1200&format=jpeg)).
- We get wrong: we have no threshold, so the floor starts with no sense of having walked in off the street.
- Alt: [Peacock Gym, Canning Town (Commons)](https://commons.wikimedia.org/wiki/File:Peacock_Gym.jpg): brick, big blue letters, a blue awning and a memorial statue.

## 10. The walls
- Photo: [Repton notices (Ben Pipe)](https://blog.benpipe.com/wp-content/uploads/2015/07/dsc7230.jpg), plus the [Repton round timer](https://blog.benpipe.com/wp-content/uploads/2015/07/dsc7222.jpg)
- Copy: fight bills, a handwritten routine sheet, a "no food" notice, an orange glazed-brick dado (#d98039) with cream tile above, a Lonsdale round timer with a red REST sector, and an [overflowing glove locker (Gleason's)](https://i.insider.com/5a0e0875f914c350018b471e?width=1200&format=jpeg).
- We get wrong: our walls are bare. Real walls are covered edge to edge with posters, photos and sheets, with a timer you can read from the ring.

## 11. The floor
- Photo: [Moss Side Fire Station ABC, Manchester (Commons)](https://commons.wikimedia.org/wiki/File:Moss_Side_Fire_Station_Boxing_Club_(7735835586).jpg)
- Copy: a dark matte painted floor with old yellow and white court lines. Other real floors: Gleason's warm-grey painted concrete (#aaa490) and black rubber tiles under the weights.
- We get wrong: we have grey carpet and rugs. No gym has carpet. The floor should be painted concrete or rubber, scuffed and lined, with rubber only under weights and stretch.

## Palette for the new floor (all sampled from the photos above)
1. #ae1106 for the walls (Gleason's red paint)
2. #3e67a1 for the ring canvas and mats (Gleason's)
3. #aaa490 for the painted concrete floor (Gleason's)
4. #161719 for steel, columns and bags (Gleason's)
5. #bc8243 for wood: speed-bag boards, benches, plyo box (Gleason's)
6. #d98039 for the brick dado and poster warmth (Repton)
- Bright and alive comes from strong overhead light on these colours, not from neon. Every zone stays readable by shape and position as well as colour.

## 5 props for a lived-in look
1. Gloves piled and hanging: an open locker, a bench and the ring apron (Gleason's, Moss Side).
2. Framed fight photos and posters covering every wall above dado height (Gleason's, Repton, Kronk).
3. Handwritten routine and notice sheets taped up near the bags (Repton).
4. Water bottles at ring corners and on benches (Gleason's, Repton, Moss Side).
5. A long bench with folded blue mats under it (Gleason's, [Coachella Valley Boxing Club (Guardian)](https://www.theguardian.com/artanddesign/gallery/2026/aug/04/lee-espinoza-darren-vargas-california-boxing-club-in-pictures)).
- Remove: the rugs, TV cabinet, fridge, bathtub and side tables. None of them appear in any real gym photo above.

Sources: the Business Insider Gleason's tour (2017), Wikimedia Commons (stated CC licences), Ben Pipe Photography (Repton, 2015), GOPANDA, BOXING ONE, The Guardian. Local copies are in /workspace/fightcamp-m43/refs/.
[send-message t38s349] That's 80 lines. Every link is a real photo I checked, but three things have no real photo yet: a dedicated stretch corner, a coach's office window onto the floor, and an air bike. I've marked those NOT FOUND rather than fill them with guesses. The file is saved on my computer, but it isn't on Beast and Claude hasn't been told yet, because I still can't reach Beast. I'll do both as soon as it's back, same as M42.
[user t39u] # TASK_M_HUD2 - Maria (art direction): the look of a HUD with no top bar

You are the ART DIRECTOR on FightCamp, a boxing-gym management sim (Godot 4, a bright 3D club seen from above, warm
walnut/brass/teal palette today). Shell-less: answer in this chat.

## Why (operator S185, verbatim)
"i am thinking of removing the top bar and use a ui something like in the picture , can you assign few agents(not your
subagents) to propose some variations that will show features in the game and future ones"

The picture is Two Point Museum (reference, NOT an asset: `E:/FightCamp/wt/UI_REF/two_point_museum_hud.webp`, view it with
your FILE tool only, never copy it into the repo). Its HUD grammar, zone by zone:
- NO top bar. The world fills the screen edge to edge.
- TOP CENTRE: small floating chips - star rating progress ("0/2" + star), a level shield ("11").
- TOP RIGHT: one resource cluster - cash ($117,010 with a red trend arrow), a second currency (Kudosh 1,420), and under it
  two thin meters with an icon each (museum rating 66 %, visitor happiness 89 %) and a visitor count (65).
- RIGHT EDGE: a stack of collapsible OBJECTIVE cards (title strip with a crown/icon, checkboxes, progress bars "0/2",
  a "Done" bar), one card per goal set, each with its own small icon.
- BOTTOM LEFT: a DOCK of 4 big square yellow buttons (build items / build room / decorate / hire staff), then smaller
  grouped buttons with a count badge and a flyout arrow (expeditions "3", briefcase, view/eye), and two tiny system icons
  (building, menu) at the far left.
- BOTTOM RIGHT: a date plate ("15 OCT Y 9"), a 4-step speed bar and play / pause / fast buttons; a big yellow MAIL button
  beside it.
- A thin red frame around the screen + a pause tab top centre when the game is paused.

## Our game today (what must find a home)
Current top bar (`Godot/scripts/ShellChrome.gd` BAR_ITEMS, S184): gym crest + name, icons Home / Fighters (roster count
badge) / Training / Scouting / Staff | Fights (bookable-offer badge) / Rankings | Finance, back arrow, handbook (i),
date plate "Mon 5 Jan 2026 Wk 1" + CONTINUE "to Tue", cash "$25,000" (roster line in its tooltip), notices bell, settings.
In the 3D club (`docs/previews/s185_bout_walk/22_deadend.png` shows it with today's bar): fighter panel top-left (name,
"08:00 MORNING - PADS", STAMINA bar, STRAIN bar, mood word FRESH, move-card line), day goals (2 rows with icons and
checks: "Stamina above 30 at the bell", "Jab usable by Friday"), the day card right ("MONDAY, WEEK 1 - A quiet week",
STEP IN / SKIP THE DAY), the GUIDE card bottom right ("Set his training", OPEN TRAINING / SKIP THIS STEP), the action
ring on a clicked fighter/station/coach (6 buttons), hover labels, the 2:00 real-time day with Space = pause.

Other live systems that need a door: fight offers / booking / the schedule (MY GYM, LADDER, MY MONTH, THE CARDS, OFFERS,
THE CORNER), fight week + weigh-in + fight night + result, fight camp, sponsors (3 offers on the desk), story inbox
(phone) and the Wall (Chapter 1 "Keys", Anvil Street), reputation / fame, hype push, walk-ins + interviews at reception,
coach hire, members + dues (mat room), rooms (office, locker, mat room, staff room, physio, film room, lobby),
week review, rankings, finances/contracts/objectives/weight class.

Future (must have a reserved, believable slot - show it greyed or "coming" where it makes sense):
- EQUIPMENT DOCK (D37/D38, queued FLOOR-PLAY): place / move / repair / buy stations on the floor, Two Point style.
- Several fighters at once (roster > 1, a fighter strip / portraits), several coaches.
- v1 stand-up rulesets: boxing, kickboxing, Muay Thai (a ruleset/discipline filter); first major update MMA + grappling
  (BJJ, wrestling, clinch); women's divisions.
- Gym rating / star tier + gym level (the museum's star + shield equivalent), gym expansion (new rooms as expansions of
  the one gym scene - operator S172 "keep other scenes as expansion of the gym scene").
- Per-body-part recovery / injuries (physio), live limb damage, the corner between rounds.
- Chapter objectives (the campaign's goal cards, like the museum's objective stack), achievements.
- Game speed (pause / 1x / 2x / 3x) instead of only CONTINUE; mail = notices + story phone in one button.

## Rules every variant follows
- No top bar. Icons over words, every icon carries a tooltip (operator S184 + GLOSSARY "Icon with tooltip"); a tooltip
  starts with a verb and does not repeat its label.
- The gym is the menu (D37): pages open as panels over the 3D club, the dock never covers the floor's centre.
- 1920x1080, our palette (dark walnut plates, brass/gold edges, teal for the lit item, cream text - see
  `previews/ui_s184/A_top_bar.html` for tokens) unless your variant argues for a change.
- A variant SHOWS every current item above and at least 5 future ones, and writes, in a side legend or a notes file,
  where each item went (zone + icon + tooltip line).

## Prior research
`python Tools/prior_research.py hud dock "top bar" "two point"` -> G104 (operator reference menus), M42 (hub mockups), J54 (menu architecture, 11 management games), J61 (scene
trees of shipped management games, Two Point Hospital), M34 (pitch look), S184 mocks `docs/previews/ui_s184/A|B|C`
(operator picked A; B = top bar + bottom dock). Read J61's Two Point section before drawing.

## What would a human do?
A UI artist would lay the reference beside our real game still, list every control, sort them into the reference's
zones, and draw 2-4 thumbnails that differ in ONE big idea each (where the money lives, where the fighter lives, how
objectives show) - not four recolours of one layout.

## Prefab check
No new asset: Lucide icons already in the repo (`Godot/assets/icons/lucide/` or `Godot/scripts/LucideIcons.gd` - use the
SVGs), the S184 HTML mock pattern, our own still as the background.


## Your deliverable (in this chat)
1. A style sheet for the new HUD: palette (hex, with the role of each: plate, edge, lit, warning, money up/down, text),
   type (families + sizes for numbers / labels / tooltips), plate shapes (corner radius or chamfer, border, shadow), icon
   style (stroke weight, filled vs line, size grid 24/32/48), badge + meter + progress-bar specs, the paused-frame look.
2. Three mood directions in one paragraph each (e.g. "fight-poster brass", "clean broadcast", "gym chalkboard"), each
   naming how the dock, the resource cluster and the objective cards look - judged by: readable over a busy bright 3D
   floor at 1080p, and still FightCamp (boxing), not a museum.
3. If you can make images: one 16:9 concept per direction of the bottom-left dock + top-right resource cluster over a
   blurred gym floor. If you cannot, give one image prompt per direction instead.
[send-message t39s351] I'm on M_HUD2. I'll start by reading the S184 palette tokens and the Two Point notes, then write the HUD style sheet and the three moods, and make one concept image per mood.
[send-message t39s352] Work on M_HUD2 has started. I'm building the three concepts over a blurred copy of our real game still, using the Lucide icons already in the repo and the S184 tokens. Each mood changes one big thing: brass fight poster, clean broadcast, or chalkboard corner. I can't open the Two Point Museum picture on E: from here, so I'm working from your zone-by-zone description of it. You'll get the style sheet, the three moods, the images and the placement table together.

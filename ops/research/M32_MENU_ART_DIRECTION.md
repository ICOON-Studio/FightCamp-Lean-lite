# M32: The menu look. How Blizzard, EA and Sega make menus feel finished

Maria (art direction) · 2026-09-25 · FightCamp (Godot 4.7.2, 1920×1080) · ART ONLY. No .gd/.tscn edits. Copy belongs to Kalli: every string in this file and on the boards is **EXAMPLE** unless it is quoted from code.

**Number tags.** Every number in this file carries one of these tags:
- **[S: link]** SOURCED. Taken from a public source or from repo code at HEAD `2662c01`. "(computed)" means I worked it out from a sourced formula or asset, e.g. a WCAG contrast ratio or glyph metrics measured from the shipped font files.
- **[P: from X]** PROXY. Carried over from a comparable source, which is named.
- **[J: reason]** JUDGEMENT. Maria's call, with a one-line reason.

Repo shorthand: `UT` = Godot/scripts/UITokens.gd, `UK` = UIKit.gd, `SC` = ShellChrome.gd, `DFP` = DayFeedPanel.gd, `CFP` = CreationFlowPanel.gd, `CC` = CreationChrome.gd, all under https://github.com/Guru-Meditation/FightCamp/tree/master/Godot/scripts

---

## 0. The short answer (read this if nothing else)

The big studios don't get a "perfect" menu from talent alone. They follow a **written rule set** and then run a **subtraction pass** against it. Our menus look like placeholders for four measurable reasons found in the live code:

1. **All text is in caps, and most of it is in a monospace font.** `UIKit.caps()` upper-cases every string and sets it in IBM Plex Mono 12 px. `display()` sets everything else in Bebas Neue, which only has capital letters [S: UK]. So no line of text in the game is set in ordinary sentence case.
2. **The text is below the accessibility floor.** A 12 px caps label has a body height of about 8.4 px [S: computed from IBMPlexMono-Medium cap-height 0.698 em]. Xbox's accessibility guideline asks for at least **18 px body height at 1080p on PC** [S: https://learn.microsoft.com/en-us/gaming/accessibility/Xbox-accessibility-guidelines/101].
3. **Every panel has the same weight and a coloured header bar.** The kit's own comment calls `header_bar` "the single most repeated surface … most of why the screens read as a wireframe" [S: UK header_bar comment]. The elevation ladder already exists (`SUNK…HERO`) but screens don't spend it unevenly [S: UT].
4. **Developer sentences are shown to players.** Examples on screen today: "GOLD OPENS THE GYM · THE SHELL LOCKS ON THE OTHER SIDE · 780 MS" and "A GYM NEEDS A NAME · GOLD IS ILLEGAL UNTIL IT HAS ONE" [S: CC STEP_FRAMES; CFP frame_for_chrome].

The fix is a **delta** on our current world, not a new one. Keep the lit blue-grey ground, the gym-colour ladder, gold for the single primary action and green for Continue only. Change four things: the type system (Inter for text, sentence case), the surfaces (3 levels plus 1 hero, no header bars), density (1 hero plus up to 3 groups), and imagery (silhouette portraits and line icons instead of initials and dark slots).

---

## 1. What a human AD would do (process)

This is how the three reference houses run it, compressed into steps we can copy:

| Step | What the studios actually do | Source |
|---|---|---|
| **1. Seed / pillar** | Hearthstone started from one "seed", a physical magic box. Every screen was judged against it, and the team rejected flat design because the game had to feel tactile and valuable. EA UFC 5 had the pillar "Beautiful Violence", and the interface designer's job was to "distil this aesthetic into practical UI applications". | Sakamoto, *Hearthstone: How to Create an Immersive User Interface*, GDC **2015** (the brief said 2014; the talk is 2015) [S: https://archive.org/details/GDC2015Sakamoto; https://www.gamedeveloper.com/design/video-designing-an-immersive-user-interface-for-i-hearthstone-i-]. UFC 5 style guide by Sherman Tam [S: https://www.shermantam.com/projects/ufc-5-style-guide] |
| **2. Style guide before screens** | UFC 5 wrote its style guide in pre-production: buttons, widgets, type, icons and colour came before feature screens. FM26 set three principles (Efficiency, Familiarity, Predictability) and fixed "unreadable font sizes" and colour contrast as an explicit goal. | [S: shermantam.com/projects/ufc-5-style-guide] [S: https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface] |
| **3. Pipeline with gates** | Creative Assembly runs a **9-phase** UI pipeline for Total War: brief → prototype → test → implement, with documentation throughout. Small tasks such as a set of 48×48 icons skip the full pipeline. | Tokmakchiev, *Making UI for Total War* (CA × BAFTA) [S: https://www.youtube.com/watch?v=MSoW-8xkaQs] |
| **4. Hierarchy / overview-then-detail** | FM26: "Overview screens provide you with key general information early and often, with more detailed information available when you explore". Tiles are snapshots and open into Cards. NN/g: progressive disclosure, generally no more than **2** disclosure levels. | [S: FM26 page above] [S: https://www.nngroup.com/articles/progressive-disclosure/] |
| **5. Wireframe → 2D → 3D polish** | Hearthstone kept wireframes "back of the napkin" and iterated UI design with 2D art. 3D came in only once the requirements were right. A third of the early team worked on UI. | [S: Sakamoto talk transcript, YouTube axkPXCNjOh8] |
| **6. Icon and state clarity** | Diablo IV found painterly item icons read badly at small size and switched to icons based on the 3D models. They toned down the saturation of icon backgrounds and **added a secondary cue (border decoration) for rarity** so that rarity is not carried by colour alone. | Angela Del Priore, D4 Quarterly Update, Feb 2020 [S: https://news.blizzard.com/en-us/article/23308274/diablo-iv-quarterly-updatefebruary-2020] |
| **7. Sound as a hierarchy, not decoration** | Firaxis (Civ VII) sorted UI sounds by how often each is triggered and how vital it is to play. Frequent sounds are short and low in complexity; the confirm ("Hero") sound is a short punchy hit. They reworked **80+** notification sounds across **20** categories. | [S: https://www.asoundeffect.com/civilization-vii-game-audio/] |
| **8. Playtest and act** | CA's Troy End Turn button went through player testing. The notifications were moved into a to-do list and the hourglass icon became a "next" arrow. "Always test your assumptions." | [S: https://www.gamedeveloper.com/production/deep-dive-evolving-the-ux-ui-of-i-a-total-war-saga-troy-i-using-player-feedback] |
| **9. Hear the backlash** | After launch, SI admitted the FM26 UI "wasn't well received by everyone … loss of immersion". Their next priority is immersion. | [S: https://www.footballmanager.com/news/return-international-management-and-review-fm26] |

**FightCamp version of the process** [J: this sizes the work to a two-agent art/words team plus Claude building]:
1. Seed: **"a working boxing gym at 6 a.m.": chalk, tape, worn leather, one bright light over the ring**. Blue-grey steel stays; gold is the championship metal; the gym colour is the club's own paint.
2. Style guide (section 7 below), then freeze it for S78.
3. Hierarchy pass on each screen: name the ONE hero, cut to 3 groups or fewer, and move the rest into tooltips or second panels.
4. Density budget check (section 7.9), run as a checklist by Claude before any screen lands.
5. Iconography and portrait pass (section 5).
6. Motion and sound pass (section 6).
7. Playtest: 5 operator sessions on the new-career flow and THE DAY, timed on "find the thing that needs me" [P: NN/g 5-user heuristic, not re-fetched this pass].

---

## 2. Q1: Hierarchy and density

- **Focal elements per screen: 1 hero.** It gets the only gold action on the board. The live DayFeedPanel already writes this rule ("GOLD IS ONE PER BOARD") [S: DFP header]; the problem is that everything around the gold is drawn at the same weight. FM26 builds a home screen out of tiles and puts one action panel forward [S: FM26 page].
- **Secondary groups: 3 or fewer** [J: 1+3 is what fits the 1494×846 content area at 18 px body text without scrolling; the M32 THE DAY mock proves it].
- **Visible rows per group: 7 or fewer**, then "View all" [J: keeps a group scannable in one eye movement; FM's own tiles show about 5 [P: FM26 Portal screenshots, not measured]].
- **Prose per panel: 2 lines or fewer** at 18 px [J: anything longer is a Card or tooltip, per FM26's tile→card split].
- **What moves to tooltips or second panels:** formulas, histories, all 7 days of the calendar (already ruled out of THE DAY: "Today only; the week is SCHEDULE" [S: DFP]), per-stat breakdowns, and anything a first-week player never uses. NN/g: at most **2** disclosure levels [S: nngroup progressive-disclosure].
- **How FM keeps dense data readable:** (a) overview first, detail on click (tile → card) [S: FM26]; (b) one navigation bar with **6** consolidated categories [S: https://www.footballmanager.com/the-dugout/mastering-fm26-ui]; (c) up to **12** bookmarks on high-res screens [S: same]; (d) readable font sizes and defined contrast as explicit goals [S: FM26]. The FM26 backlash also shows the other side of the lesson: a productivity-tool look without immersion was punished [S: FM review page].

## 3. Q2: Typography

- **Typefaces: 2** [J: one text face and one display face is what every reference uses; 3 or more reads as a template kit]. **Text face: Inter** (OFL, has a `tnum` tabular-figures feature [S: https://rsms.me/inter/]). **Display face: Bebas Neue** (already shipped [S: UT]), limited to 1 use per screen at 44 px or larger: hero numbers on fight night, the gym name on the result card.
- **IBM Plex Mono leaves text.** Monospace is rare in AAA menus because every glyph takes the same width. That widens words, slows reading and makes caps text look like a terminal [J: that is exactly the placeholder look the operator named]. What designers really want from mono is **aligned numbers**, and **tabular figures** give that in the proportional face: `font-variant-numeric: tabular-nums` [S: https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-numeric]. In Godot this is the OpenType feature `tnum` on a FontVariation [J: implementation note for Claude, not verified in 4.7.2 this pass].
- **Uppercase:** NN/g finds caps help **glanceable 1–2-word** labels but hurt titles, sentences and paragraphs [S: https://www.nngroup.com/articles/glanceable-fonts/]. Rule: **caps only for eyebrow labels of 24 characters or fewer, tracked +1 px** [J: 24 fits "TODAY'S LEAD · FIGHT"-length eyebrows, which is the 1–3-word glance NN/g describes]. Everything else is sentence case: buttons ("Open gym"), rail items ("The day"), titles, body.
- **Sizes: 6 steps, no more than 5 used on any one screen** (section 7.2). Floor: **15 px** Inter for labels and meta. That gives a body height of about 14 px [S: computed, Inter 'd'→'p' extent 0.932 em] against XAG's 18 px [S: XAG 101]. Body text is **18 px** (≈16.8 px body height). Full XAG PC compliance needs about **20 px** body text [S: computed 18/0.932 = 19.3], so we add a **text-size option of 100 / 115 / 130 %** [J: 115 % gives a 20.7 px body and meets XAG without making the default layout sparse].
- **Current live floor for comparison:** SIZE_LABEL 12, SIZE_BODY 13 [S: UT]. That is a body height of about 11.3 px for mixed-case Plex, and about 8.4 px for the caps the kit actually draws [S: computed].

## 4. Q3: Colour and surfaces

- **Elevation on dark ground is done with light, not shadow.** Our tokens already say so ("a surface rises by getting LIGHTER") [S: UT elevation comment]. Keep the mechanism, but use **3 levels plus 1 hero** instead of 5 tiers [J: 5 tiers invite screens to use all 5 evenly, which is the flat look]:
  - **Sunk** = TRACK `#111621`: inputs, bar tracks, the floor board.
  - **Resting** = PANEL `#2a3347` + a 1 px white rim at 7 % alpha + a soft shadow: all ordinary cards.
  - **Lifted** = PANEL_HI `#34405a` + 12 % rim: the commit card, hover, popovers.
  - **Hero** = a horizontal gradient from the gym colour darkened 38 % to PANEL, with a gym-tinted rim at 35 %. **One per screen.**
  - **No coloured header bars.** Group titles become 22 px text on the card [J: header bars are the most repeated flat surface in the game, per the kit's own comment].
- **Accent use (unchanged roles, tightened):** the gym colour marks selection and navigation (the rail's active item moves from a gold bar to the gym tint). **Gold = the one primary action + the belt only.** Green `GO` = Continue only [S: UT comments "GO: Continue and nothing else"].
- **Contrast fixes** (all computed with the WCAG formula; AA text threshold **4.5:1** [S: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html]):
  - MUTED `#94a1b8` on PANEL = **4.84:1** (passes), on PANEL_HI = **3.97:1** (fails). → **MUTED lifted to `#a3afc4`**: **5.7:1** on PANEL, **4.68:1** on PANEL_HI [S: computed].
  - DIM `#6d7688` on PANEL = **2.76:1**, on GROUND_2 = **3.06:1** [S: computed]. The live creation foot cue and floor captions use DIM for readable text [S: CC, UK starter_take]. → DIM is **disabled-only**.
  - White on GO `#22c55e` = **2.28:1** (fails even large-text 3:1) [S: computed; the live "go" button uses white text, S: UK button()]. → Continue text becomes **INK `#1b1207` on GO = 8.11:1** [S: computed].
  - BAD `#e5433a` as text on PANEL = **3.12:1** → add **BAD_TEXT `#f2766f` = 4.57:1** for text; BAD stays for fills and glyphs [S: computed].
- **State colouring, never hue-only** (standing law; WCAG 1.4.1 Use of Color [S: https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html]; Diablo IV added a border cue to rarity for the same reason [S: D4 update]):

| State | Fill | 2nd channel (required) | Example on boards |
|---|---|---|---|
| Good | GOOD `#4fc46a` glyph | ✓ glyph + word | "✓ Good as new" |
| Warning | AMBER `#f0a020` | ▲ glyph + number | "▲ Worn · 72%" |
| Bad / blocking | BAD_TEXT / BAD fill | lock or flame glyph + word | "🔒 Blocks Continue", "Heating" |
| Locked | DIM text, no fill | lock glyph + hatch | (not on boards) |
| New | gym-tint dot | the word "New", ≤ 24 characters, caps | (not on boards) |
| Needs you | AMBER pill | the number inside the pill | rail badge "1", "2" |

## 5. Q4: Imagery on a small-studio budget

| Asset class | Recommendation | Cost | Licence |
|---|---|---|---|
| **Fighter portraits** | **Silhouette discs now**: head-and-shoulders shape in a disc, gym-tinted for ours, slate for other gyms (as drawn on the boards). **Later**: procedural 2D portraits layered from 6–10 parts (face shape, hair, brows, nose, skin tone ramp, scars) [J: a layered part system is the cheapest route to 1,000+ distinct faces and matches the silhouette frame]. Or a **3D bust render** from the existing CC fighter rig (`CCFighterSkin.gd` exists [S: repo tree]) rendered offline to 256² [J: reuses art we already own]. | Silhouette: ~0 [J]. Procedural: 1–2 art weeks [J]. | Own art |
| **UI icons** | **Lucide** (ISC) or **Phosphor** (MIT) for system icons (rail, bell, calendar, pin, clock) [S: https://lucide.dev/license; https://github.com/phosphor-icons/phosphor-icons/]. Pick ONE set and keep the stroke at 2 px at 24 px [J: mixing sets is the first thing that reads as cheap]. | 0 | ISC / MIT: keep the licence text in the credits file |
| **Sport/equipment icons** | **game-icons.net** for boxing glove, heavy bag, ring and so on: **CC BY 3.0**, credit required, "accessible from a menu" is fine [S: https://game-icons.net/faq.html; licence link https://creativecommons.org/licenses/by/3.0/]. Their fill style is heavier than Lucide, so re-stroke to 2 px or use them only at 40 px and above as illustrations [J]. | 0 + credits screen | CC BY 3.0 |
| **Equipment illustrations** | Top-down floor-plan drawings (ring with ropes, bag from above, bench), as on the creation board. These are cheaper than isometric and read at 80 px cells [J: one style for the gym floor and the store]. | ~1 art week for 20 items [J] | Own art |
| **Backgrounds** | Hero cards get one faint motif (ring ropes at 3–6 % white) and nothing else. No photos behind data [J: photos behind text fail contrast unpredictably]. | 0 | Own art |
| **Generated art** | Allowed for **concept exploration and backgrounds only**. Final portraits and icons must be art we own or have clearly licensed [J: generated likenesses of real fighters and unclear licensing are the risk]. | varies | Check the tool's terms per asset. NOT COMPUTED this pass |

Reference library for any screen: **Game UI Database** [S: https://www.gameuidatabase.com/]. Search "management", "career mode", "roster".

## 6. Q5: Motion and sound

Timings (Material 3 duration tokens as the external yardstick [S: https://github.com/material-components/material-components-android/blob/master/docs/theming/Motion.md]; the NN/g **0.1 s** limit for "instant" [S: https://www.nngroup.com/articles/response-times-3-important-limits/]):

| Event | Timing | Curve | Tag |
|---|---|---|---|
| Hover in (fill + rim lift) | **100 ms** | standard `cubic-bezier(0.2,0,0,1)` | [S: M3 Short2 = 100 ms; standard easing] |
| Hover out | **150 ms** | standard | [S: M3 Short3] |
| Press down / release | **50 ms / 100 ms**; scale 0.98 | linear / standard | [S: M3 Short1/Short2; scale J: a visible dip without looking bouncy] |
| Selection change (tab, rail item, card select) | **160 ms** slide of the indicator | emphasized decelerate `0.05,0.7,0.1,1` | [S: M3 easing; 160 ms: J, inside our 160–240 law] |
| Panel / card open (tile → card) | **200 ms** slide 24 px + opacity on the panel only | emphasized decelerate | [S: M3 Short4 = 200 ms] |
| Screen change (rail navigation) | **240 ms** content slide from 32 px; the shell stays still | emphasized decelerate | [J: top of our 160–240 law; the whole screen is never faded, per standing law] |
| Tooltip show delay / fade | **400 ms** delay, **100 ms** in | standard | [J: long enough that sweeping the mouse over a table doesn't flash tooltips] |
| Number change (cash, stat) | count-up **≤ 300 ms**, only when the value changes | standard | [S: M3 Medium2 = 300 ms as the ceiling] |
| Continue → day advance | **240 ms** | emphasized | [J: same as a screen change; no special effect] |
| Continuous pulse / throb | **never** | none | [standing law M23–M25] |

Sound [J throughout unless tagged; the structure follows Firaxis's frequency × importance matrix, S: asoundeffect Civ VII]:
- **Hover: silent** (mouse-heavy management game; hover fires hundreds of times an hour).
- **Click: 1 shared soft tactile tick, ≤ 60 ms**, leather or tape foley to match the seed.
- **Confirm (gold action): 1 short "hero" hit, ≤ 250 ms**: a low glove-on-pad thump plus a small high layer, as Firaxis did for their confirm sound [S: same article, method; ms is J].
- **Continue: a distinct bell tick**, the only sound of its kind.
- **Notifications: 1 sound per category** (fight, money, medical, rivalry, title), ≤ 6 categories, never looped.
- Shared mix rule: the UI bus sits about **6 dB** under music peaks as a starting value [J: NOT COMPUTED against our mix; the audio pass sets the real figure].

---

## 7. FightCamp style guide proposal (M32)

### 7.1 Palette: deltas on live UITokens, not a new world

We keep the **UITokens "lit blue-grey" family** (GROUND `#1c2230`). We do **not** move to the M22_* near-black family (`M22_GROUND #0B0E14`) [S: UT]. [J: the live game and every approved board since R9 sit on GROUND; changing it now would invalidate every approved screen for no readability gain. MUTED on GROUND is already 6.09:1.]

| Role | Token (live) | Hex | Change |
|---|---|---|---|
| Ground | GROUND | `#1c2230` | keep; AFTER boards add a 0→6 % vertical darkening + one soft cool light (JUDGEMENT: gives depth, costs one TextureRect) |
| Sunk | TRACK | `#111621` | keep, and use for inputs as well (live used PANEL_LO) |
| Resting | PANEL | `#2a3347` | keep + rim `#FFFFFF` at **7 %** [J] |
| Lifted | PANEL_HI | `#34405a` | keep + rim at **12 %** [J] |
| Hero | gym ladder `deep`→PANEL | derived | new usage |
| Text | TEXT / TEXT_2 | `#f3f5fa` / `#c9d1e0` | keep |
| Muted | MUTED | `#94a1b8` → **`#a3afc4`** | **delta** (contrast, section 4) |
| Disabled | DIM | `#6d7688` | **disabled only** |
| Link | LINK | `#7fb6ee` | keep (5.91:1 on PANEL [S: computed]) |
| Primary action | GOLD / GOLD_HI | `#f0c233` / `#f7d65a` | keep, **1 per board** |
| Continue | GO | `#22c55e` | keep fill, **text → INK** |
| Selection / nav | GYM_DEFAULT ladder | `#2f6fb0` | rail active = 30 % tint + 3 px bar in gym `hi` (was GOLD bar) |
| Semantic | GOOD / AMBER / BAD | `#4fc46a` / `#f0a020` / `#e5433a` | keep for fills; **+ BAD_TEXT `#f2766f`** |
| Belt | SODIUM / ICE | `#f2c14e` / `#5ec8e0` | untouched (M7 law) |

### 7.2 Type scale (px at 1920×1080, Inter unless noted; at most 5 steps per screen)

| Step | Size / weight | Use | Case |
|---|---|---|---|
| Label | **15 / 600, +1 px tracking** | eyebrows, pill text | CAPS, ≤ 24 characters |
| Meta | **15 / 450** | secondary lines, units, timestamps | sentence |
| Body / row | **18 / 400–600** | body, list rows, buttons (16–20 allowed for buttons) | sentence |
| Group title | **22 / 600** | card titles | sentence |
| Screen title | **30 / 650** | page titles, hero headline | sentence |
| Hero figure | **44 / 650, `tnum`** | the one big number | n/a |
| Display (Bebas) | **≥ 44**, max 1 per screen | fight night, result, gym name moments | CAPS by font |

All sizes are [J: a scale of roughly ×1.2 from an 18 px body, snapped to even numbers where it fits], except the 15 px floor [P: from XAG 18 px body height (Inter 15 px ≈ 14 px body) plus the 115 % text option] and tabular figures on every number [S: MDN tnum]. Line height is 1.4× for body text and 1.2× for titles [J].

### 7.3 Spacing grid (8 pt, on the existing SPACE tokens)

- Base **8** with half-step **4** (= SPACE_BASE / SPACE_HALF) [S: UT].
- Card padding **24–32** (SPACE_LG / SPACE_XL); gap between cards **24** (SPACE_LG); gap inside a group **16** (SPACE_MD); row pitch **64–76** for portrait rows and **56** for plain rows [J: 44 px ROW_HEIGHT [S: UT] is too tight once body text is 18 px].
- Radius: **8** for cards, **10–12** for hero and the shell, **6–8** for controls, **pill = h/2** [J: live RADIUS **3** [S: UT] reads as "boxes"; 8 reads as "cards"].
- Screen margins inside the content area: **0** (the shell already frames it). The creation flow keeps its **100** px margin [S: CFP MARGIN].

### 7.4 Panel styles (3 levels + hero)

Sunk · Resting · Lifted · Hero, as defined in section 4. **Rules:** one hero per screen. Lifted is for 1 commit card or transient UI only. Everything else is Resting. **No header bars. No borders darker than the fill** (the rim is always lighter, as the live `rim_color` already does [S: UT]).

### 7.5 Iconography rules

- One line set (Lucide or Phosphor): **24 px grid, 2 px stroke, round caps**. Draw at 18–22 px in rows and 20 px in the rail [J].
- Icon plates: a **36–44 px** rounded square in gym tint at 20–22 % alpha, holding the icon in gym `hi` [J].
- Every rail item gets an icon. Every group title may have one. Buttons have an icon only when it's a direction (→) [J].
- game-icons.net only for sport objects, at ≥ 40 px, with credits [S: licence].

### 7.6 Motion timings

Section 6 table: **100 / 150 / 160 / 200 / 240 ms**, no pulse, no full-screen fade.

### 7.7 Text budgets (Kalli writes the words; these are the containers)

| Slot | Budget | Tag |
|---|---|---|
| Eyebrow (caps) | ≤ **24** characters, ≤ 3 words | [J, from NN/g glance range 1–2 words + a separator] |
| Button | ≤ **16** characters, verb first, sentence case | [J: 280 px gold button at 20 px holds ~22; 16 leaves room for →] |
| Row title | ≤ **40** characters | [J: fits 1 line in a 498 px column at 19 px] |
| Row meta | ≤ **56** characters | [J: fits 1 line in the 972 px column at 15 px] |
| Hero headline | ≤ **60** characters, ≤ 2 lines | [J] |
| Hero body | ≤ **110** characters, ≤ 2 lines | [J] |
| Screen caption / foot cue | **none**. Key hints only | [J: dev captions are the #1 placeholder tell] |
| Numbers | never bare: **label or unit or delta**, or it goes to the tooltip | rule 7.10 |

### 7.8 Casing rules

Sentence case for everything except eyebrows ≤ 24 characters and proper nouns. Screen names in the rail are sentence case ("The day", "Schedule"). Kalli may rule otherwise on names; if Kalli wants "THE DAY" as a brand mark, it appears once, as an eyebrow.

### 7.9 Density budget per screen

- **1 hero + ≤ 3 secondary groups**; ≤ **7** rows per group; ≤ **1 gold**, ≤ **1 green** (the shell's); ≤ **2** typefaces; ≤ **5** type sizes; ≤ **2** accent hues visible besides semantic colours [all J: this is what the two mocks fit into, and each limit removes a specific live failure].
- Checklist for Claude (pass/fail per screen): count heroes, groups, golds, sizes, caps strings > 24 characters, bare numbers, empty panels.

### 7.10 Number-with-context rule

Every number shows **one** of: a label ("6–1 Record"), a unit ("$420 / week"), a comparison ("6 of 12" + bar), or a delta ("up 12 this week"). If none fits, the number goes into a tooltip. Money uses `$24,180` (no space after $; the live `"$ %s"` has one [S: SC _build_top]). Records use an en dash (6–1). All numbers use `tnum`.

### 7.11 Empty-slot rule

No dark rectangle may stand for "nothing". An empty state is **1 line + 1 action** ("Nothing else is dated today. · Open schedule ›"), and panels size to their content. Free space on a grid is **one dashed region with a count** ("6 free spaces · Build after opening"), never N black cells [J; the live `quiet_empty_state` is close but uppercase, DIM, and has no action, S: UK].

---

## 8. Screen notes for the two mocks

Files: `M32_mock_gym_creation_before_after.png`, `M32_mock_the_day_before_after.png` (3840×1208 boards, 1920×1080 per side). Clean AFTERs: `*_after.png`. Callouts 1–6: `*_after_annotated.png`. BEFOREs are **reconstructions from live code at `2662c01`, not screenshots**: geometry, fonts and strings come from CFP/CC/UK and SC/DFP/UIKitShell. Fighter names, equipment, cash and news items are EXAMPLE.

### 8.1 Gym creation (step 3 of the country → city → gym flow)

**BEFORE (from code):** brand bar 96 / step band 46 / foot 46 [S: UK CREATION_BRAND/STEPS/FOOT]. Head "NAME THE GYM" (Bebas 34). Caption in caps mono. Name field 620×52 at (100, 242). Three figure units 230×72. Starter floor at 96 px cells with **dark TRACK tiles for empty cells** [S: UK floor_grid]. Four roster rows showing **initials** in discs [S: UK _creation_silhouette]. Readout + gold "OPEN GYM" 280×62 at x 1620 [S: CFP ACTION_X]. Foot cue "…780 MS". BACK sits at x 1020, mid-bar [S: CC `max(size.x-900, 470)`].

**AFTER:** the hero card holds the name (focal element). The single gold "Open gym →" sits on a lifted commit card that restates what will be written. The step strip moves to the centre of the brand bar (✓ Country — ✓ City — 3 Gym). The trail becomes a quiet breadcrumb. Numbers get context: "$25,000 · ≈ 13 months of upkeep" [S: computed 25,000 / (420 × 52 / 12) = 13.7]. "6 of 12" gets a 12-segment bar. "$420 / week" shows its split. The floor becomes a top-down drawing with one dashed "6 free spaces" region, and each equipment state is glyph + word. The foot shows key hints only. The first day reads "Monday 5 January 2026" [S: SC epoch; creation opens week 1 day 0, J].

### 8.2 THE DAY (home)

**BEFORE (from code):** rail 16,122 370×900. Bebas caps nav with a gold active bar and red count badges. Top bar with caps breadcrumb, `$ 24,180` gold chip, bell, 7-day strip, and continue unit (white on green) [S: SC]. Attention strip, briefing hero **88 px tall** (the "hero" is a strip), 3 ticker rows, TODAY and MUST ANSWER frames with gym-blue header bars, and a mostly **empty dark MUST ANSWER column** [S: DFP geometry].
- **Computed defect, verify in build:** the day strip is placed assuming it is **320** px wide. It actually draws **7×55−5 = 380** px, so the Continue unit (added after it) covers the last **46** px, i.e. part of SAT/SUN [S: computed from SC `_build_top` + UK `day_strip`]. The BEFORE board draws it that way.

**AFTER:** same shell rectangles. The rail gets icons, sentence case, gym-tint active state and amber count pills. The top bar shows labelled numbers (cash + monthly upkeep delta; fighters + booked), a 7-day strip whose event markers differ by **shape** (● event, ◆ fight), and Continue in INK on green (8.11:1). Page title row at y ≈ 164 above the 210 content anchor. **Hero** = the lead story with portrait, 4 labelled facts, and the only gold. **Needs you** merges attention + asks, each with a state pill (glyph + word). **Today** lists dated items and ends in a one-line empty state with a route. **On the wire** has 3 sentence-case items + "All news". So: 1 hero + 3 groups.

---

## 9. Never list

1. Never show a developer sentence to the player (ms timings, "GOLD IS ILLEGAL", function names, "NOT THE WEEK").
2. Never set sentences or titles in caps, and never set text in monospace. Mono is for code, not for players.
3. Never let a bare number stand without a label, unit, comparison or delta.
4. Never draw an empty dark rectangle for "nothing".
5. Never show state with hue only (standing law).
6. Never use more than 1 gold or more than 1 green on a board, and never colour a nav highlight gold.
7. Never put coloured header bars on cards.
8. Never pulse or throb, and never fade the whole screen (standing law).
9. Never use initials where a person should be. Use a silhouette until portraits exist.
10. Never mix icon sets, and never ship a CC BY icon without a credits entry.
11. Never go below the 15 px text floor, and never use DIM for readable text.
12. Never call the facility "camp"; it is the gym (standing law). Blood appears only at doctor/stoppage (standing law).

## 10. Self-attack

**Strongest case that this guide is wrong or too costly:**
- **It moves toward a productivity-tool look, and FM26 was punished for exactly that.** SI's own review says the new UI brought a "loss of immersion" [S: FM review]. Sentence-case Inter on blue-grey cards is closer to a SaaS dashboard than the current Bebas/mono "fight-poster" look. The risk: FightCamp gains readability and loses its boxing flavour. **Mitigation built in:** Bebas is kept for moments, the hero surface carries the gym colour and a ropes motif, and the seed ("a gym at 6 a.m.") steers materials. It is still a real risk, and the operator should judge the AFTER boards on *feel*, not only on clarity.
- **Cost:** the change touches every screen that calls `UIKit.caps()` or `display()`. That is hundreds of call sites, and a font-only swap would break every width that was sized to Plex/Bebas metrics (e.g. `chip` width = 20 + 7.6 px per character [S: UK chip]). The honest estimate is not "a token change". It is a **kit pass + a width audit per screen** [J].
- **The 18 px body text lowers density.** Power users of management sims tolerate small text (FM players run skins at small sizes). An 18 px body at 1080p cuts rows per screen by about 25 % against a 13–14 px body [J: 44 → 56 px row pitch].

**Weakest point, named unprompted:** the **portrait plan**. Silhouettes are honest but identical, so 30 fighters with the same head is its own placeholder look. The procedural-portrait estimate ("1–2 art weeks") is a JUDGEMENT with nothing behind it, and it's the item most likely to slip. Until it ships, the rows depend on name + weight class + record to tell people apart.

---

## 11. Sources

1. Sakamoto, *Hearthstone: How to Create an Immersive User Interface*, GDC 2015: https://archive.org/details/GDC2015Sakamoto · https://www.youtube.com/watch?v=axkPXCNjOh8 · https://www.gamedeveloper.com/design/video-designing-an-immersive-user-interface-for-i-hearthstone-i-
2. Steph Chow, *Immersing a Creative World into a Usable UI*, GDC 2018 (general game-UI talk; studio affiliation not verified this pass): https://www.gamedeveloper.com/design/video-designing-great-ui-that-helps-immerse-players-in-your-game
3. Diablo IV Quarterly Update, Feb 2020 (Angela Del Priore, UI): https://news.blizzard.com/en-us/article/23308274/diablo-iv-quarterly-updatefebruary-2020
4. FM26 reimagined UI: https://www.footballmanager.com/fm26/features/fm26s-reimagined-user-interface
5. Mastering the FM26 UI: https://www.footballmanager.com/the-dugout/mastering-fm26-ui
6. FM26 review / International Management: https://www.footballmanager.com/news/return-international-management-and-review-fm26
7. Pingle Studio FM26 case (C++ core + Unity UI + Figma): https://pinglestudio.com/cases/football-manager-26/
8. Tokmakchiev, *Making UI for Total War: a UI design pipeline*: https://www.youtube.com/watch?v=MSoW-8xkaQs
9. Troy End Turn deep dive: https://www.gamedeveloper.com/production/deep-dive-evolving-the-ux-ui-of-i-a-total-war-saga-troy-i-using-player-feedback
10. Wojs, *The Art of Total War: Three Kingdoms*, GDC 2020 preview: https://www.gamedeveloper.com/art/attend-gdc-for-an-inside-look-at-the-art-design-of-i-total-war-three-kingdoms-i-
11. Sherman Tam, UFC 5 and UFC 5 Style Guide (EA): https://www.shermantam.com/projects/ufc-5 · https://www.shermantam.com/projects/ufc-5-style-guide
12. Firaxis, Civ VII UI sound (A Sound Effect): https://www.asoundeffect.com/civilization-vii-game-audio/
13. Material 3 motion tokens: https://github.com/material-components/material-components-android/blob/master/docs/theming/Motion.md · https://m3.material.io/styles/motion/easing-and-duration/tokens-specs
14. NN/g, response-time limits: https://www.nngroup.com/articles/response-times-3-important-limits/
15. NN/g, glanceable typography / caps: https://www.nngroup.com/articles/glanceable-fonts/
16. NN/g, progressive disclosure: https://www.nngroup.com/articles/progressive-disclosure/
17. Xbox Accessibility Guideline 101 (text size): https://learn.microsoft.com/en-us/gaming/accessibility/Xbox-accessibility-guidelines/101
18. WCAG 2.2 contrast minimum / use of colour: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html · https://www.w3.org/WAI/WCAG22/Understanding/use-of-color.html
19. MDN font-variant-numeric (tabular-nums): https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-numeric · Inter: https://rsms.me/inter/
20. game-icons.net FAQ / CC BY 3.0: https://game-icons.net/faq.html · https://creativecommons.org/licenses/by/3.0/
21. Lucide licence (ISC): https://lucide.dev/license · Phosphor (MIT): https://github.com/phosphor-icons/phosphor-icons/
22. Game UI Database: https://www.gameuidatabase.com/
23. Repo code at `2662c01`: UITokens.gd, UIKit.gd, UIKitShell.gd, ShellChrome.gd, DayFeedScreen.gd, DayFeedPanel.gd, CreationFlowPanel.gd, CreationChrome.gd (Guru-Meditation/FightCamp)

## 12. Honesty flags

| Claim / number | Status | Note |
|---|---|---|
| Live fonts are Bebas Neue + IBM Plex Mono; `caps()` upper-cases | SOURCED | UT, UK |
| SIZE_LABEL 12 / SIZE_BODY 13; RADIUS 3; ROW_HEIGHT 44; SPACE tokens | SOURCED | UT |
| Body/cap-height ratios (Inter 0.932/0.728; Plex 0.94/0.698; Bebas 0.70) | SOURCED (computed) | measured from the shipped TTFs with Pillow |
| All contrast ratios (4.84, 3.97, 2.76, 2.28, 8.11, 5.7, 4.68, 4.57…) | SOURCED (computed) | WCAG relative-luminance formula on token hex |
| Day strip / Continue overlap of 46 px | SOURCED (computed) from code | **NOT VERIFIED on a running build**: check a screenshot |
| XAG 18 px PC / 26 px console body height | SOURCED | XAG 101 |
| M3 durations 50–1000 ms, easing curves | SOURCED | M3 Motion.md |
| FM26 principles, tile/card, 6 nav categories, 12 bookmarks, backlash | SOURCED | footballmanager.com pages |
| Hearthstone talk year | SOURCED: **2015** | the brief said 2014 |
| Overwatch-specific menu talk | NOT FOUND | search surfaced only the Overwatch social-systems / Statescript talks and a general GDC 2018 immersive-UI talk (Chow); no dedicated Overwatch menu-UI talk located, so Blizzard evidence here is Hearthstone + Diablo IV |
| EA FC career-mode UI case study | NOT FOUND (first-party) | UFC 5 used instead (Sherman Tam portfolio) |
| FM24 dense-data specifics | NOT COMPUTED | this pass used FM26 sources; FM24 skin metrics not measured |
| Type scale, radii, row pitch, text budgets, density limits | JUDGEMENT | reasons given inline |
| Sound lengths and the 6 dB mix offset | JUDGEMENT / NOT COMPUTED | needs an audio pass against the real mix |
| Portrait / illustration cost estimates | JUDGEMENT | weakest point (section 10) |
| Godot `tnum` via FontVariation in 4.7.2 | NOT VERIFIED | Claude to confirm |
| BEFORE boards | reconstruction from code | not screenshots; the geometry follows the code, the data is EXAMPLE |
| All AFTER strings | EXAMPLE | words are Kalli's |

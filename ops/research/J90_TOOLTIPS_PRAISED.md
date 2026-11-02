# J90 - Tooltips players praise, and how FightCamp beats them
Researched S359 2026-11-02 by a Claude subagent for the J90 brief

Brief: `TASK_J90_TOOLTIPS_PRAISED.md` (questions 1-6). The operator's words on the whiteboard magnet tooltip (Godot's
see-through grey box): "unreadable", then "see how the best games make tooltips, what they were praised for and do better
than those". This file covers how great tooltips LOOK and BEHAVE. WHAT goes in a tooltip versus on screen, the glossary,
the tutorial and the first round of show delays are in `J52_TOOLTIPS_AND_TUTORIAL.md` sections 2, 5 and 6a and are not
repeated here.

Source tags: **READ** = I opened the page myself. **SUMMARY** = known only from a search-engine summary of the page (the
page refused the fetch or I did not open it). **CODE** = read from source code or official engine docs. **JUDGEMENT** = my
decision, built on the cited evidence. **NOT FOUND** = searched, no source found. No number in this file is invented: a
number without a source is marked JUDGEMENT.

---

## 0. Headline

1. **The games praised for tooltips are the ones where a tooltip is a small reference card you can look into.** Crusader
   Kings 3, Victoria 3, Europa Universalis V and Old World all get praise for **nested tooltips**: a highlighted term inside
   a tooltip opens its own tooltip. Factorio and Slay the Spire put the second card **beside** the first, not inside it.
2. **The most common complaint is about behaviour, not looks.** The tooltip vanishes when you move toward it, the lock is
   slow or invisible, the delay setting does nothing, and the box covers what you were reading (the cursor sits on its
   corner). The second most common is a wall of text (Diablo IV 2023, WoW 2024).
3. **The best recent example shows deltas before you commit.** Civilization VII's settlement tooltips (Update 1.2.5) show
   before and after values, with green and red up and down arrows.
4. **Godot's built-in tooltip cannot do the praised behaviour.** It is a mouse-passthrough popup that closes when the
   mouse enters it (engine source, section 6). Tier 1 can stay on the built-in tooltip once themed. Tiers 2 and 3 need
   our own layer of tooltip cards.
5. **FightCamp's edge is the board itself.** An **index card pinned by a magnet** is opaque, readable (navy on off-white is
   14.0:1) and familiar. The magnet doubles as the visible lock indicator. A keyword opens a **sticky note** beside the
   card. Deltas are written in marker with their consequence. See section 5.

---

## 1. Which games are praised, and for what exactly

| Game | What was praised (or criticised) | Evidence (date) | Tag |
|---|---|---|---|
| **Crusader Kings 3** (2020) | **Nested tooltips** on highlighted Game Concepts. GamingOnLinux: "tooltips inside tooltips inside tool…you get the idea". The mechanic: "hold the mouse there and it will then stick for you to highlight another inside it". The reviewer calls it "a really fantastic system" and adds "The amount of information you can get at a glance is pretty amazing". PC Gamer's review jokes that even the tooltips have tooltips, and another PC Gamer piece calls them "generally clear and concise". The Shacknews preview called tooltips the first and perhaps most important accessibility feature. Attack of the Fanboy: the screen was "covered in these nesting doll tooltips" for the first hours. | GamingOnLinux, Liam Squires-Hand, 5 Oct 2020 (READ). PC Gamer review and preview, Shacknews, AotF (SUMMARY, 2020) | READ + SUMMARY |
| CK3 lock modes | **Timer Lock** (default): the tooltip locks after a wait, then you can move onto it. **Action Lock**: middle mouse locks and unlocks. **Mouse Tendency**: locks at once and stays until the cursor moves clearly away. Players lowered the timer from about 1.5 s to 0.7 s: "Changed my life" (J52 S17, S18). | Search summaries of the Paradox forum and the Vic3 diary (SUMMARY). Forum pages returned 500 or a browser check when fetched | SUMMARY |
| **Victoria 3** (2022) | The same nested system. PCGamesN: "basically like having the game's official wiki sitting right alongside your mouse pointer". Dev Diary #29 (UX): nesting avoids "a single humongous tooltip". Tooltips show **predicted effects** before you act, such as the weekly balance change from switching a production method, with a nested breakdown. All three lock modes are offered. | PCGamesN, Ian Boudreau, 14 Jan 2022 (READ). Vic3 Dev Diary #29 (SUMMARY, 2022) | READ + SUMMARY |
| **Europa Universalis V** (2025) | Digital Chumps called the nested tooltip redesign "especially brilliant", because it uses on-demand windows you see by hovering instead of clicking from term to term. The Sixth Axis credits nested tooltips, search and the encyclopaedia, but says they only "mostly" ease the learning curve. ACOUP: some economy tooltips take "a minute" before the icons make sense. | Digital Chumps (SUMMARY, 403 on fetch). The Sixth Axis, 31 Oct 2025 (SUMMARY). ACOUP, 31 Oct 2025 (SUMMARY) | SUMMARY |
| **Old World** (Mohawk, 2021) | Players and critics praise its "cascading tooltips": "so well done in Old World that it was an easier onboarding then the last couple Civs". The GOG store page sells nested tooltips as a quality-of-life feature. A Cultured Vultures review says they are no stand-in for a structured tutorial, and its encyclopaedia was called incomplete. The lock key was NOT FOUND. | Russell Troxel review, 11 Jul 2021 (SUMMARY). Cultured Vultures (SUMMARY). GOG page (SUMMARY). Quarter to Three forum: "fantastic tooltips which made the game a breeze to learn" (SUMMARY) | SUMMARY |
| **Slay the Spire** (2019) | A Goonhammer review calls the UI a low-key strength: keywords are "always accompanied by a concise, accurate definition". The design pattern: keyword definitions appear as **separate small boxes beside the hovered card**, not inside it. A Lemmy user called the UI "unambiguous and responsive" (one opinion). | Goonhammer (SUMMARY; the fetch returned nothing). Beside-card placement is from BaseMod's keyword-tooltip renderer changelog (SUMMARY) and general knowledge of the game; no review describes it, so treat it as UNCONFIRMED | SUMMARY |
| **Slay the Spire 2** (EA 5 Mar 2026) | **Built in Godot.** Mega Crit left Unity during the 2023 fee row. Its tooltip praise is NOT FOUND yet. A mod (BetterSpire2) moves its own tooltip out of "the game's tooltip container" into its own CanvasLayer. That suggests StS2 runs its own tooltip layer, as section 6 recommends (weak evidence). | PC Gamer, Game Developer, gamefromscratch on the engine switch (SUMMARY). BetterSpire2 on GitHub (SUMMARY) | SUMMARY |
| **Factorio** (FFF #318, 2019) | The recipe tooltip had been "kind of a Frankenstein's monster" of recipe and item data. Fix: "An additional item tooltip will be shown for every product, as a separate tooltip". An item tooltip "look[s] the same regardless" of where it appears. Properties are grouped into named categories, with no pointless headings like "Inserter". The tooltips were kept "as compact as possible". In game they are slightly transparent, with blur and shadow. One forum reply called them "gorgeous"; others found them crowded. FFF #266 (2018) set the goal: better structure, more useful information. | Factorio Friday Facts #318, Twinsen and Rseding, 25 Oct 2019 (READ). FFF #266, Oct 2018 (SUMMARY). Forum replies (SUMMARY) | READ |
| **Into the Breach** (2018) | Its interface tops WhatCulture's list of the best video game interfaces. Justin Ma: "we would sacrifice cool ideas for the sake of clarity every time". On weapon tooltips, a small looping animation of the effect works better than text: "showing that little animation of them moving is a thousand times more effective". The map shows who attacks what, and in which order, before you commit. | Game Developer, quoting the RPS interview of 5 Mar 2018 (READ; the RPS page refused the fetch). WhatCulture list (SUMMARY, date not checked) | READ |
| **Path of Exile** | **Progressive disclosure by key.** Hold Alt for "Advanced Mod Descriptions" (tiers and ranges): an option from patch 3.1.2, later always on. Ctrl compares with equipped gear, rebindable. Complaint: Alt also changes what currency does, so the two collide. | PoE forum threads, 2022-2023 (SUMMARY) | SUMMARY |
| **Diablo III / IV** | The Diablo wiki credits Blizzard with putting "a lot of time and effort" into D3's text boxes. D4, 3 Apr 2023: a player called the item tooltip "like a text wall". His fix was to group affixes with category icons, give numbers a different colour from the words, push tertiary information to the bottom in smaller grey text, and widen the box. Replies were split: "Excellent formatting job" versus "less readable", and one warned that italics hurt low-vision players. Patch 1.047 reworked stat comparisons where one stat appears several times on an item. | Blizzard D4 forum thread, 3-8 Apr 2023 (READ). Patch 1.047 (SUMMARY). Diablo wiki (SUMMARY) | READ + SUMMARY |
| **Last Epoch** | Alt, Ctrl and Ctrl+Alt layers show affix ranges and auto-compare. Patch 1.0.7 moved the ranges to Ctrl+Alt by accident and players complained. Lesson: modifier-key layers must be stable and shown on screen. | Last Epoch forum, 2024 (SUMMARY) | SUMMARY |
| **Civilization VI** | No praise found. Players complained there was no breakdown of where yields come from, and mods (Better Report Screen, 2018) added the tooltips. | CivFanatics threads (SUMMARY) | SUMMARY |
| **Civilization VII** (2025) | Launched with "missing or unhelpful" tooltips; Firaxis promised fixes (Update 1.1.0, 4 Mar 2025). The Update 1.2.5 dev post overhauled building tooltips for "clarity and readability", with consistent formatting, bullets and role **Tags**. **Placement preview:** hovering a tile shows yield changes, with an optional expanded **before/after view with deltas**, adjacency arrows, and **green/red up/down arrows**. Losses (maintenance, overbuilding) are now shown. Green numbers mark the best tiles, and the post adds this "isn't a recommendation". | Firaxis "From the Devs: Developing your Settlements", Tom Shaw (READ; page undated, "coming soon with Update 1.2.5"). CGMagazine on 1.1.0 (SUMMARY) | READ |
| **Two Point Hospital / Museum** | Hospital: hovering the money display shows income, expenses and profit (guide, 1 Sep 2018). PC Gamer called the interface "typical of Two Point's largely excellent UI". Museum: Kotaku says the menus, UI and controls are "wonderfully designed and extremely easy to use". Geek Culture says pop-up icons "may be confusing". Windows Central calls the UI "a step backward". A forum player asks for an "information density" setting. **No source praises its tooltips specifically: NOT FOUND.** | Magic Game World, 1 Sep 2018 (READ). Reviews and the forum (SUMMARY, 2025) | READ + SUMMARY |
| **Football Manager** | FM24 has a 5-step "Tooltip Speed" setting (J52 S30). FM26 launch complaints: "almost no tooltips", and no "i" hover for attributes (J52 S27, S32). No praise found. | J52 | from J52 |
| **Balatro** (2024) | TechRadar's verdict lists "Impeccable UI design". Mult values sit in a red box inside the description, so the number reads at a glance. Hovering a card or joker shows its description in a pop-up box. One player found that cards packed together made it hard to tell what was scoring. A dedicated tooltip review was NOT FOUND, and keyword side boxes were NOT CONFIRMED by a source. | TechRadar (SUMMARY). Insider Gaming on the red mult box (SUMMARY). itch.io and Q23 comments (SUMMARY) | SUMMARY |
| **RimWorld** | Hovering a target with a shooter selected explains the hit chance factor by factor. Mods add more breakdowns. **No review praising the tooltips: NOT FOUND.** | RimWorld wiki, Manipulation page (SUMMARY) | SUMMARY |
| **Hades / Hades II** | **No tooltip praise found.** A Kyotofu review names readability as the game's critical problem. Hades II players asked which god a duo boon belongs to, and whether a boon replaces or adds. A mod ("Improved Boon Info UI") exists to reduce ambiguity. | OpenCritic or Kyotofu, Steam threads, Thunderstore (SUMMARY) | SUMMARY |
| **Frostpunk 2** (2024) | **Criticised.** GamesRadar: tutorial tooltips have "blindspots". Thumb Culture: "clunky and crowded". The PS5 review: text too small. Players asked for better contrast. Hover plus T opens a topic window (J52). | GamesRadar, Thumb Culture, GameWatcher, Steam (SUMMARY, 2024) | SUMMARY |
| **Anno 1800** (2019) | The UI was praised in general: PC Gamer headline "clean, easy to use interface"; Gamereactor "well-crafted and smart UI". Tooltip specifics come only from players (production time on hover). **No tooltip-specific praise found.** | PC Gamer, Gamereactor (SUMMARY). Steam threads (SUMMARY) | SUMMARY |
| Pillars of Eternity II / Tyranny | Glossary terms are **linked automatically** in dialogue ("words which have an entry in the Cyclopedia are linked automatically"). PC Gamer review: tooltips give "useful bits of context when you need them". Nesting NOT FOUND. | PC Gamer; Obsidian modding forum (SUMMARY) | SUMMARY |
| AI War 2 | A release titled "Tooltips For Your Tooltips" (v0.513) responded to "too much text" in its info display. | Arcen forums (SUMMARY, date not checked) | SUMMARY |
| Paradox games in general | A WinCustomize poster: "excellent tooltips which pop up almost everywhere in the user interface" (HoI, EU, Victoria). Quarter to Three: long, data-rich tooltips are preferred in strategy games. | Forums (SUMMARY, old threads) | SUMMARY |

**The pattern behind the praise (JUDGEMENT from the table):**
- **Depth on demand.** CK3, Vic3, EU5 and Old World all nest. The praise words are "wiki beside the pointer", "at a glance"
  and "easier onboarding".
- **One card per thing, same look everywhere.** Factorio's separate item tooltip and Slay the Spire's keyword boxes
  follow this.
- **Show the outcome before committing.** Civ VII deltas, Vic3 predicted effects and Into the Breach's attack preview all
  do this.
- **Compact and grouped**, never a column of same-size text: Factorio, and the D4 redesign thread.
- No praised game is praised for **looks alone**. Every praise line is about getting information quickly.

---

## 2. Patterns table

Game-specific millisecond values are almost never published. Where a game value is missing, the engine or standard value
is given and marked.

| Pattern | What the best do | Numbers found | Sources |
|---|---|---|---|
| **Show delay** | CK3 has a delay slider, but players say it "does nothing" and tooltips appear instantly (J52). FM has 5 speed steps (J52). | **Game ms: NOT FOUND for every game in section 1.** Godot `gui/timers/tooltip_delay_sec` default **0.5 s** (CODE). FightCamp Lean currently sets **0.25 s** (`project.godot` line 24). Windows 500 ms. MDC 500 ms. NN/g 300-500 ms (J52). Flutter Material tooltip: wait time 0 ms by default on hover. | Godot ProjectSettings docs (CODE). J52 S1-S9. Flutter Tooltip API (SUMMARY) |
| **Re-show between neighbours** | Moving from one hot spot to the next shows the next tooltip at once. | Windows reshow **100 ms** (J52 S4). Game values NOT FOUND. | J52 |
| **Animation** | Fade, sometimes with a small slide. | **Game ms: NOT FOUND.** Material spec as implemented in Flutter: **fade in 150 ms, fade out 75 ms**, radius 4, fully opaque when shown. Flutter's old values were 200 ms and radius 2. | Flutter commit eca9364 (SUMMARY) |
| **Hide** | Hide after the cursor has been out for a while, never on a 1-pixel wobble (CK2 complaint). | NN/g: hide after more than 0.5 s out. MDC hide 600 ms (J52). Godot: the tooltip stays while the cursor moves inside the control if the text is unchanged; the delay timer restarts only after a move of more than 5 px (CODE). | J52 S5, S9. Godot viewport.cpp (CODE) |
| **Anchored vs follow-cursor** | Paradox and Old World anchor near the cursor where the hover began; the card does not chase the mouse. Slay the Spire anchors keyword boxes to the card. Civ VII's placement preview goes in a **fixed left panel**, not at the cursor. | Godot built-in: cursor position + `display/mouse_cursor/tooltip_position_offset`, default **(10, 10)** (CODE). The arrow cursor then covers the top-left corner, the exact CK3 complaint ("covered by the gigantic mouse", J52 S22). | Godot ProjectSettings and viewport.cpp (CODE). Civ VII dev post (READ) |
| **Max width** | Factorio: "as compact as possible". D4 thread: widen it instead of stacking a long column. | **px at 1080p: NOT FOUND for every game.** JUDGEMENT for FightCamp: 400 px (about 37-40 Kalam characters per line at 19 px). | FFF #318 (READ). D4 forum (READ) |
| **Structure** | Title, then an unnamed root block of what this thing is, then named groups, then state. Tertiary information at the bottom in smaller grey text (D4 thread). Civ VII adds role Tags, bullets and consistent formatting. | n/a | FFF #318 (READ). Civ VII (READ). D4 forum (READ) |
| **Inline icons and numbers** | Icons sit beside the number. D4 players asked for numbers in a different colour from words. Balatro puts mult in a red box. | n/a | D4 forum (READ). Balatro (SUMMARY) |
| **Colour coding** | Highlighted concept terms (Paradox: blue or underlined concepts, J52 S14). Good green, bad red, with **arrows as well as colour** (Civ VII). Keywords recoloured (D4 thread). | n/a | Civ VII (READ). D4 forum (READ). J52 S14 |
| **Nested keyword tooltips + lock** | CK3, Vic3 and EU5: hover a concept inside a tooltip to open its own. Locks: timer (default; about 1.5 s per a player, lowered to 0.7 s), action (middle mouse) or mouse tendency. Tooltips Pro (Godot): hold **Shift** to pin. Depth: Ardeljan suggests "two or three levels"; NN/g says more than 2 levels has low usability (J52 S10). | Lock 1.5 s and 0.7 s (J52 S17, S18, players). Official CK3 default: NOT FOUND. | Ardeljan, 7 Sep 2020 (READ). Tooltips Pro forum post (READ). J52 |
| **Side-by-side cards instead of nesting** | Factorio shows one extra tooltip per product beside the recipe tooltip. Slay the Spire shows keyword boxes beside the card. | n/a | FFF #318 (READ). StS (SUMMARY, unconfirmed) |
| **Comparisons and deltas** | Civ VII shows before/after values with green/red up/down arrows, losses included. Vic3 shows the predicted weekly balance change. PoE and Last Epoch use Ctrl to compare with what is equipped. D4 patch 1.047 condensed repeated stats into one value for comparison. | n/a | Civ VII (READ). Vic3 DD29 (SUMMARY). PoE and LE forums (SUMMARY) |
| **Keyboard hint chips** | PoE: Alt for advanced, Ctrl to compare. Frostpunk 2: hover + T. Tooltips Pro: Shift pins. Last Epoch's silent remap angered players. **A shown hint chip inside the tooltip: NOT FOUND in a praised game.** | n/a | Section 1 rows |
| **Pointer / arrow** | NN/g: use arrows when several elements are close together. Games mostly do without an arrow. | n/a | NN/g "Tooltip Guidelines", 27 Jan 2019 (READ) |
| **Edge flipping** | Godot's built-in tooltip flips to the opposite side of the cursor and otherwise "hugs the border" (embedded windows only, CODE). Tooltips Pro has Overflow Modes. Complaints: text runs past the bottom with no scroll (No Rest for the Wicked forum) or off the right edge (itch). | Godot: flip, then clamp (CODE) | viewport.cpp (CODE). Forums (SUMMARY) |
| **Hoverable / dismissible / persistent** | WCAG 1.4.13: content shown on hover must stay while the pointer moves onto it ("the pointer can be moved over the additional content without the additional content disappearing"), must be dismissible without moving the pointer (Esc), and must persist until the trigger is removed. | n/a | W3C Understanding 1.4.13 (READ) |
| **Moving toward the tooltip** | The menu-aim triangle (Amazon, Ben Kamens 2013): while the pointer moves inside the triangle from its position to the submenu's near corners, keep the submenu. Timing-only hysteresis is the weaker fix. | n/a | MIT Technology Review, 9 Mar 2013, and others on Kamens (SUMMARY) |

---

## 3. What players complain about

| Complaint | Evidence | Source |
|---|---|---|
| **Vanishes when you move toward it** | CK3: "the tooltip box disappears as soon as I try to move the cursor onto the nested tooltip" (20 Apr 2021). "Half the time I can't get my mouse to the item" (5 Sep 2020). Ardeljan: slipping slightly off the element closes the tooltip, which is "frustrating". | J52 S18, S21. Ardeljan, 2020 (READ) |
| **Lock too slow / invisible** | CK3 players lowered the 1.5 s lock to 0.7 s: "Changed my life". The CK3 tutorial step that needs a nested hover blocked players (2020, 2021). No source says CK3 shows a lock-progress cue: NOT FOUND. | J52 S17, S18, S20 |
| **Locked chain dies when crossing another hot spot** | CK3: locked tooltips close when the path crosses the map. | J52 S19 |
| **Delay setting ignored / too instant** | CK3: "tooltips always appear instantly" (2020). "the first slider does nothing" (2020). "no delay ... it is annoying" (2023). | J52 S16, S23, S24 |
| **Covers what you read** | CK3: the top-left corner "covered by the gigantic mouse" (2020). itch reviewer: text too small and the cursor covers part of it. WoW: "so much text I can't find what I am hoving over" (19 Jan 2024). | J52 S22. itch.io post (SUMMARY). Blizzard WoW forum (READ) |
| **Wall of text** | D4 item tooltip "like a text wall" (3 Apr 2023). AI War 2 shipped a release against "too much text". Factorio's crowded-tooltip replies (2019). | D4 forum (READ). Arcen (SUMMARY). FFF forum (SUMMARY) |
| **Flicker** | CK2: the tooltip disappears and reappears with a one-pixel mouse move; "tooltips flashing on and off" while reading stats (high-DPI mouse suspected). | Paradox forum, "should my tooltips be super sensitive to mouse movement" (SUMMARY) |
| **Off screen / no scroll** | Item descriptions run past the bottom of the screen with no scroll (No Rest for the Wicked). Text runs off the right edge on small displays (itch). | Forums (SUMMARY) |
| **Missing where needed / partial coverage** | Civ VII launch: tooltips "missing or unhelpful" (Feb 2025). FM26: "almost no tooltips" (J52). Punch Club 2: unlabelled icons (J52). | Civ VII coverage (SUMMARY). J52 |
| **Colour-only or unclear icons** | D4 accessibility reply: italics and colour-only coding hurt low-vision and colour-blind players. Punch Club 2: "Does the red and orange explosion looking symbol mean damage?" | D4 forum (READ). J52 S41 |
| **Wrong text** | BG3 spell tooltips bugged "for months". Frostpunk 2 patch notes keep fixing tooltip text. | Yahoo/PCGamesN on BG3 (SUMMARY). J52 S49 |
| **Silent remap of tooltip keys** | Last Epoch 1.0.7 moved ranges from Alt to Ctrl+Alt without telling anyone. | LE forum (SUMMARY) |
| **See-through / low contrast** | NN/g: "Light-grey text on white is hard to read". Frostpunk 2 players asked for better contrast. The operator, S359: "unreadable" (Godot's see-through grey box on the light board). | NN/g (READ). FP2 Steam (SUMMARY) |

---

## 4. Accessibility

| Item | Standard | FightCamp check |
|---|---|---|
| **Text size** | Xbox XAG 101: minimum default text **18 px on PC, 26 px on console/TV at 1080p**, measured as **body height** ("the pixel distance from the lowest descender to the highest ascender"). Players should be able to scale text. IGDA GASIG: 32 px at 1080p, 46 px for timed text, mainly for when size is not configurable (TV oriented). | Tooltip text **never below 18 px**. Body 19 px; the 16 px small size is **not used in tooltips** (a 16 px font has a body height under 18 px). Add a text-scale option of 100 / 125 / 150 % that applies to tooltips. (JUDGEMENT on XAG 101.) |
| **4K** | XAG 102 lists large-text sizes per resolution; at 4K the PC large threshold is 72 px. | Lean runs `window/stretch/mode="canvas_items"` with a 1920x1080 base, so a 4K screen scales tooltips by exactly 2x. **No separate 4K spec is needed.** Check that the font is not rasterised at 1x: Godot draws fonts at the scaled size with canvas_items stretch. |
| **Contrast** | XAG 102: **4.5:1** for standard text, **3:1** for large text (PC large = 36 px at 1080p), and **7:1 for every UI element in a high-contrast mode**. Measure against the weakest part of a non-solid background. Let players put a solid background behind text. WCAG uses the same 4.5:1 and 3:1. | Every tooltip is **opaque** (alpha 1.0). The ratios below were computed with the WCAG formula. |
| **Delay setting** | CK3 and FM expose a delay or speed. CK3 players complain when the setting does not apply (J52). | Setting "Tooltip speed: Instant 0 / Fast 150 / **Normal 300** / Slow 600 ms / Off", applied by one code path to every tier. Also "Card lock: Hover 700 ms / Key only". |
| **Hoverable, dismissible, persistent** | WCAG 1.4.13 (READ). | Tier 2 and 3 cards are hoverable (section 6 corridor). **Esc** closes the whole chain. A card stays while its trigger or the card itself is hovered. |
| **Keyboard / controller** | NN/g: support keyboard hover (focus held on an element). | A focused control shows its tooltip after the same delay. **Shift pins**, **Esc closes**, **Tab** moves between the keywords on a pinned card. |
| **Not colour alone** | D4 accessibility reply (READ). Civ VII uses arrows plus colour (READ). | Every delta carries a sign and an arrow glyph (▲ +9 / ▼ -4) as well as colour. |
| **Font legibility** | The gameaccessibilityguidelines.com entry "Use an easily readable default font size", and Game Developer's "Legible font still one of the biggest accessibility issues" (SUMMARY). | Kalam is a handwriting face. Keep it for words, but use the body font Barlow (already in `UI.gd` as "body") for **numbers**, so digits align and read cleanly. Add an option "Plain font on cards" that swaps Kalam for Barlow. (JUDGEMENT) |

**Contrast ratios** (WCAG relative luminance; computed with a script in the session scratchpad):

| Text colour | on board #f4f2ec | on index card #fffdf6 | on sticky note #fbe7a1 | on ink #1f2a44 |
|---|---|---|---|---|
| Navy ink #1f2a44 | 12.74 PASS | **14.01 PASS** | 11.57 PASS | - |
| White #ffffff | 1.12 fail | 1.02 fail | 1.23 fail | **14.26 PASS** |
| Red marker #c8312a | 4.77 PASS | **5.25 PASS** | **4.34 FAIL** | 2.67 fail |
| Dark red #a8261f | 6.33 PASS | 6.97 PASS | **5.76 PASS** | 2.01 fail |
| Amber UI #d97a00 | **2.79 FAIL** | **3.06 FAIL** | 2.53 FAIL | 4.57 PASS |
| Amber ink #8f5100 | 5.61 PASS | **6.17 PASS** | 5.10 PASS | 2.27 fail |
| Green UI #23935d | 3.47 FAIL | 3.82 FAIL | 3.16 FAIL | 3.67 fail |
| Green ink #1c6e43 | 5.58 PASS | **6.14 PASS** | 5.07 PASS | 2.28 fail |
| Pencil #6b7280 | 4.32 FAIL | 4.75 PASS | 3.92 FAIL | 2.95 fail |
| Muted #5e6773 | 5.12 PASS | **5.63 PASS** | 4.65 PASS | 2.49 fail |

Consequences: **the house amber (#d97a00) and green (#23935d / #3f8f5a) cannot be text colours on the board.** Use them
for fills, bars and magnet dots; write the words in amber ink #8f5100 and green ink #1c6e43. Red marker #c8312a is fine
on the board and on the card, but on a sticky note use dark red #a8261f. Pencil grey is too light for small text on the
board; use Muted #5e6773.

---

## 5. DO BETTER - how FightCamp beats the best of them

1. **An index card pinned by a magnet, not a floating box.**
   - What: the tier 2 tooltip is an opaque off-white index card (#fffdf6) with a navy title, a thin red rule under the
     title (like a real index card), a soft drop shadow, and a round magnet at its top edge. It sits on the board: lighter
     than the board, so it lifts off it, with 14.0:1 contrast.
   - Why: the operator called the see-through grey box "unreadable". NN/g says light grey on white is hard to read. XAG
     102 asks for a solid background behind text. Even Factorio's praised tooltips are see-through with a blur, and nothing
     we found praises transparency. The card also fits the coach's-board look instead of fighting it.
   - Beats: every game in section 1, whose tooltips are generic dark panels.

2. **The magnet is the lock, and you can see it fill.**
   - What: when the card appears, a ring around its magnet fills in marker ink over 700 ms. Full means the card is locked:
     the magnet turns solid red with a small "snap" (scale 1.15 to 1.0 over 90 ms). Shift or middle click locks it at once.
     Moving onto the card locks it too.
   - Why: CK3's timer lock is the praised mechanic and the top complaint at the same time. It is slow (about 1.5 s, which
     players cut to 0.7 s) and gives no cue (no lock-progress cue found). A tutorial step even blocked players who could
     not work out how to lock. WCAG 1.4.13 says content you hover must be hoverable.
   - Beats: CK3, Vic3 and EU5, whose lock you cannot see.

3. **A keyword opens its own sticky note beside the card, never on top of it, and stops at two levels.**
   - What: game terms on a card (Strain, Sharpness, Focus, Stamina) are written in bold navy with a red marker underline.
     Hovering one puts a yellow sticky note (the existing `WhiteboardKit.sticky()` colours) on the card's free side,
     top-aligned with the keyword's line. A term on the sticky note links to its **Handbook page**, not to a third note.
   - Why: nesting is the most praised pattern ("wiki beside your mouse"). Factorio and Slay the Spire show that a second
     card beside the first stays readable, where a stack hides the first. Ardeljan suggests 2-3 levels; NN/g calls more
     than 2 levels low usability; J52 already capped depth at 2. Different paper (card versus sticky note) tells you at a
     glance which level you are on. No game in the list uses a material change for that.
   - Beats: Paradox's look-alike stacked boxes.

4. **Every number carries its consequence, and a preview shows the delta before you commit.**
   - What: a stat row reads "Strain 72 ▲ +9 -> 81" plus one line of what it means: "Thursday sparring now risks a cut".
     While hovering a change (moving a magnet, picking a card), the card shows **before -> after** in coloured marker:
     green ink up when good, dark red down when bad, amber ink for "watch it". The good/bad meaning comes from the stat,
     not from the sign: more Strain is bad.
   - Why: Civ VII's after-launch fix added exactly this (before/after, deltas, green/red arrows, losses shown). Vic3 shows
     predicted effects. Into the Breach is praised for always showing what will happen next turn. The Eurogamer editor
     wanted the number behind a word (J52). Lean already writes one such line ("By fight night X -> Y", `WeekBoard.gd`
     line 360) as plain text.
   - Beats: Civ VII on two points. The consequence is said in words, and colour follows meaning, not the sign.

5. **It never covers what you are looking at.**
   - What: tier 2 and 3 cards are **anchored to the hovered control**, not to the cursor. They open on the side of the
     board with the most free space, 10 px away, and never over the control or the cursor. On the week grid, a magnet in
     the right half gets its card on the left.
   - Why: CK3's "gigantic mouse" complaint. WoW's "can't find what I am hovering over". NN/g: "Don't Block Related
     Content". Godot's default (cursor + 10 px) puts the arrow on the card's top-left corner. Civ VII moved its preview to a
     fixed side panel for the same reason.

6. **Short by contract, with deeper detail behind Shift.**
   - What: a card has a title, at most 4 stat rows, 1 consequence line and 1 hint line, with at most 40 words of body
     (J52 6a), at a fixed width of 240-400 px. "Why" detail sits behind **Shift**, which also pins the card, so nothing is
     lost.
   - Why: D4's "text wall", AI War's "too much text", Factorio's crowded replies. PoE's Alt layer is praised as
     progressive disclosure, and Last Epoch shows that hidden key layers must be visible.

7. **The keys are written on the card.**
   - What: the footer hint line shows small key chips in marker: `[Shift] pin   [Click] open   [Esc] close`. The chip for
     an action you cannot take is greyed out.
   - Why: CK3 players did not discover the lock (the tutorial blocker). Last Epoch's silent remap angered players. No game
     in section 1 was found to show its tooltip keys inside the tooltip (NOT FOUND), so this is an open lead.

8. **No flicker, instant sweep, a speed setting that works.**
   - What: after the first card, moving to a neighbouring magnet within 400 ms shows its card with **no delay** and no fade.
     The 5 px move tolerance stops 1-pixel flicker. One setting drives every tier.
   - Why: CK2 flicker. The Windows 100 ms reshow (J52). CK3's speed slider that "does nothing".

Optional later (JUDGEMENT, not for the first build): for **moves and combos**, the card can show a 2-second chalk
diagram of the punch path, Into the Breach style ("a thousand times more effective" than text). Wait until moves get a
board card.

---

## 6. Godot 4 build spec

### 6a. Which Godot mechanism, and why

| Tier | Mechanism | Why |
|---|---|---|
| T1 plain label | Built-in `tooltip_text`, themed through the project Theme types **`TooltipPanel`** (stylebox "panel") and **`TooltipLabel`** (font, font_size, font_color). For text that wraps, override **`Control._make_custom_tooltip(for_text)`** to return the shared `Tips.plain(for_text)`. | Zero cost per control, and the engine handles delay, flip and Esc. Hundreds of `tooltip_text` lines already exist (for example `WeekBoard.gd` 222-520 and `WhiteboardKit.gd` 110, 131). |
| T2 rich card, T3 sticky note | **A custom layer.** Autoload `Tips` (new `scripts/ui/Tips.gd`) owns a `CanvasLayer` at layer 100. A control registers with `Tips.card(control, builder: Callable)`. `Tips` listens to the control's `mouse_entered` / `mouse_exited` / `focus_entered` signals and runs its own timers. | The engine's tooltip **cannot be hovered, locked or nested** (CODE, viewport.cpp `_gui_show_tooltip_at`): the popup gets `FLAG_MOUSE_PASSTHROUGH = true` and `FLAG_NO_FOCUS = true`, the default label tooltip **connects `mouse_entered` to `_gui_cancel_tooltip`**, any mouse button press cancels it, and the popup is `queue_free`d on every hide. The praised behaviour (sections 2-3) needs a hoverable, persistent card, which a custom layer gives. |

### 6b. Project settings

| Setting | Value | Why |
|---|---|---|
| `gui/timers/tooltip_delay_sec` | **0.30** (Lean has 0.25) | Inside NN/g 300-500 ms. The operator's tree already runs fast at 0.25, and CK3 players call instant tooltips annoying. **Supersedes J52 6a's 500 ms default** for this whiteboard UI. The setting value (section 4) writes this property at runtime, and `Tips` reads the same value. |
| `display/mouse_cursor/tooltip_position_offset` | **(16, 26)** (default (10, 10)) | Moves the T1 label's top-left corner clear of a standard arrow cursor at 1080p (JUDGEMENT; the cursor size is not measured). This is the CK3 "gigantic mouse" fix. |
| Theme | The `TooltipPanel` and `TooltipLabel` overrides must live in the theme every screen uses (`UI.theme()` at the root, or `gui/theme/custom`). | A subtree with its own Theme falls back to Godot's default see-through tooltip, which is what the operator saw (TRAP). |

### 6c. The three tiers

Colours come from `WhiteboardKit.gd` and `UI.gd`, with the two new text inks from section 4.

| Property | **T1 tape label** | **T2 index card** | **T3 sticky note** |
|---|---|---|---|
| Use | Top-bar icons, buttons, simple magnets: one fact or one verb line | Whiteboard magnets (sessions, phases), fighter stats, gym items, any number worth explaining, change previews | Game terms inside a T2 card: Stamina, Strain, Sharpness, Focus, and so on |
| Look | A strip of navy tape | Off-white card, red rule under the title, magnet on top | Yellow sticky note (existing `sticky()` colours) |
| Background | Ink #1f2a44, alpha 1.0 | #fffdf6, alpha 1.0 | #fbe7a1, alpha 1.0 |
| Border | none | 1 px #d8d4cb (the magnet edge colour) | 1 px #e2c770 |
| Radius | 3 px | 4 px | 2 px |
| Shadow | (0,0,0,0.30), size 6, offset (0,2) (as S359 `UI.gd` line 198) | (0,0,0,0.22), size 6, offset (2,4) | (0,0,0,0.22), size 5, offset (2,4) |
| Padding (h / v) | 12 / 6 | 18 / 14 (plus 10 top for the magnet) | 16 / 12 |
| Width | auto, max **360** px (wraps) | min **240**, max **400** px | min 220, max **320** px |
| Title | none | Permanent Marker **22 px**, ink. A 2 px red #c8312a rule 4 px below it, at 100% width | Permanent Marker **20 px**, ink |
| Body | Barlow (UI "body") **19 px**, white (14.26:1) | Kalam **19 px**, ink (14.0:1). Line spacing +2 px | Kalam **19 px**, ink (11.6:1) |
| Numbers | n/a | Barlow SemiBold **19 px**, right-aligned in a value column, tabular | Barlow SemiBold 19 px |
| Deltas | n/a | Good: green ink #1c6e43 (6.1:1) "▲ +9". Bad: dark red #a8261f (7.0:1) "▼ -4". Watch: amber ink #8f5100 (6.2:1). Always a sign plus an arrow. | Same, but red is **#a8261f only** (#c8312a fails at 4.34:1) |
| Consequence line | n/a | Kalam 19 px ink, starts with "Means:" | "Why:" line (J52 template) |
| Keywords | n/a | Kalam Bold 19 px ink, with a 2 px **dashed red** #c8312a underline 3 px under the baseline. The hover target is the word plus 4 px. | Link to the Handbook only (no further notes) |
| Footer hint | n/a | Barlow **18 px**, Muted #5e6773 (5.6:1). Key chips: 1 px ink border, radius 3, padding 6/1, caps. Separated by a 1 px #e2ded4 line, 8 px above. | Barlow 18 px Muted: `[Click] Handbook` |
| Lock indicator | n/a | **Magnet**: 16 px circle centred on the top edge, half above the card. Outline 2 px ink. The fill ring draws clockwise as an arc while the lock timer runs. Locked = solid red #c8312a with a white 4 px glint. | Small red pin dot in the top-left corner (the note is locked with its parent) |
| Content limit | 75 characters, starts with a verb (J52) | Title of 3 words or fewer, up to 4 stat rows, 1 Means line, 1 hint line, 40 words of body or fewer | Term, a definition of 15 words or fewer, "Now: value -> band", "Why:" (J52 6a) |
| Show delay | 300 ms (setting) | 300 ms (setting) | 250 ms of hover on the keyword. Only from a T2 card that is hoverable (pointer on it) or locked. |
| Re-show sweep | Engine behaviour | 0 ms and no fade, if another T2 card closed less than 400 ms ago | 0 ms between keywords on the same card |
| Fade in | Engine (instant) | **120 ms** alpha 0 to 1, plus a 6 px slide from the anchor side, ease-out (Material 150 ms rounded down for a snappier board) | 100 ms alpha plus a 4 px slide |
| Fade out | Engine | **80 ms** (Material 75 ms) | 80 ms |
| Lock | n/a | Locks when (a) the pointer enters the card, (b) the magnet fill finishes **700 ms after show** (setting: off = key only), or (c) **Shift** or **middle click** pins it at once. | Locks with its parent |
| Close | Engine (leave, click, Esc) | Not locked: 150 ms after the pointer leaves the trigger and is not in the corridor. Locked: 300 ms after the pointer leaves the whole chain (trigger + card + note). Pinned (Shift / middle click): stays until **Esc**, a click outside, or pinning another card. | Closes with its parent, or 300 ms after leaving the note while the parent stays locked |

### 6d. Placement and edge flipping (T2 / T3)

```
place(card_size, anchor_rect, screen_rect, avoid_rects):
  margin = 16; gap = 10
  # T2 sides in order: the side with the most free space first, then its opposite, then below, then above.
  sides = sort([RIGHT, LEFT], by free width beside anchor, descending) + [BELOW, ABOVE]
  for side in sides:
    r = rect beside anchor_rect on `side`, `gap` px away
        (RIGHT/LEFT: top-aligned with anchor top; BELOW/ABOVE: left-aligned with anchor left)
    r = shift r along the side's free axis to fit inside screen_rect.grow(-margin)
    if r inside screen_rect.grow(-margin) and not r.intersects(anchor_rect.grow(4))
       and not any(r.intersects(a) for a in avoid_rects):
      return r
  # nothing fits: clamp inside the screen, then push off the anchor on the axis with more room
  r = clamp(r, screen_rect.grow(-margin)); if r.intersects(anchor_rect): move it off along that axis
  return r
```
- T2: `anchor_rect` = the hovered control's global rect. `avoid_rects` = none, or the "focus" region a screen
  declares (for example the week row being edited).
- T3: `anchor_rect` = the parent card's rect. The first side tried is **the side away from the original control**, so the
  chain grows outward. `avoid_rects` = [the keyword's line rect], so the note never hides the word you hovered.
- T1: the engine's cursor placement with the offset from 6b. Godot already flips to the opposite side and then clamps
  (CODE).
- Never place a card under the cursor: T2 and T3 positions are computed once, at show time, and do not follow the mouse.

### 6e. Hover corridor (the "vanishes when I move toward it" fix)

- When the pointer leaves the trigger, record `p0`. While the card is not locked, keep it open if, at each mouse motion,
  the pointer is inside the triangle (`p0`, the card's two near corners) **and** is moving toward the card, for at most
  **400 ms** (Kamens menu-aim). Otherwise close after 150 ms.
- Bridge the 10 px gap with an invisible `Control` (mouse_filter STOP) between the trigger and the card while the card is
  open.
- While a chain is locked, other triggers do not open their card until the pointer has rested on them for **300 ms**. This
  fixes the CK3 complaint about a locked chain dying when the path crosses another hot spot.

### 6f. States

`HIDDEN -> PENDING (delay timer) -> SHOWN (fade in, lock ring filling) -> LOCKED (magnet solid) -> PINNED (key) -> CLOSING
(grace / fade out) -> HIDDEN`. Esc from any state closes the whole chain. A click on the trigger fires its action and
closes the card (the engine does the same for T1).

### 6g. Where each tier goes

| Place | Tier | Card content (example) |
|---|---|---|
| Top bar icons (money, date, members) | T1, or T2 when a breakdown exists | Money: T2 with income / costs / net rows (Two Point's praised money hover) |
| Whiteboard magnets (session blocks) | T2 | Title "Pads - evening". Rows: Sharpness ▲ +3, Strain ▲ +6 (dark red). Means: "Thursday is her hardest day". Hint: [Shift] pin [Drag] move |
| Change preview (dragging a magnet, choosing a twist card) | T2 in preview mode | Before -> after per stat, Means line, nothing committed |
| Fighter stats and body places | T2 + T3 keywords | "Strain 72 ▲ +9 -> 81"; hover "Strain" opens a sticky note with its definition |
| BUILD tiles / gym items (when present) | T2 | Price, footprint, what it trains, members it holds |
| Fight HUD (dark TV look, `BodyTip.gd`) | Out of scope | It keeps the TV theme. Only borrow the anchoring and opacity rules (its 0.86 alpha glass should become 1.0 if the operator finds it hard to read). |

### 6h. Traps (each one costs a fix cycle)

1. **The built-in tooltip is passthrough and self-cancelling** (CODE). Never try to build T2 or T3 on
   `_make_custom_tooltip`: you cannot move onto it, and a click kills it.
2. **`_make_custom_tooltip` returns are freed on every hide** (Control docs): build a new node each call. It must be
   `visible = true` when returned, and the popup **shrinks to minimum size**. A Label with `autowrap_mode` set has a
   minimum width near 0, so the tooltip collapses to a column one word wide. Set `custom_minimum_size.x =
   min(font.get_string_size(text, ..., size).x + padding, 360)` before returning.
3. **The default `TooltipLabel` has no autowrap**, and a theme cannot turn it on. Long `tooltip_text` makes one very wide
   line. That is why T1 routes wrapping text through `Tips.plain()`.
4. **The tooltip is re-created when `_get_tooltip(pos)` returns different text** (viewport compares the text while the
   mouse moves). For per-cell tooltips inside one control, return distinct strings, or the tooltip will not refresh.
5. **Godot's default offset (10, 10)** puts the cursor on the label's corner: set it in 6b.
6. **Edge flipping only runs for embedded popups** (`is_embedded()` or no `FEATURE_SELF_FITTING_WINDOWS`). Keep
   `display/window/subwindows/embed_subwindows` at its default (true; Lean does not change it) or flipping is left to the
   OS.
7. **Theme fallback:** a control under a different Theme gets Godot's default see-through tooltip, the S359 defect (6b).
8. **mouse_filter on the custom layer:** the card root needs `MOUSE_FILTER_STOP` (it must receive hover). Decorative
   children use `IGNORE`, keyword spans `STOP`. The CanvasLayer (layer 100) must sit above modals, or a modal's card
   draws behind it.
9. **RichTextLabel keywords:** write `[url=kw:strain]Strain[/url]`, set `meta_underlined = false`, and draw the dashed
   underline yourself. Use `meta_hover_started` / `meta_hover_ended`. The signal gives no rect for the span, so anchor T3
   to the mouse's line (y rounded to the line height) and to the parent card's edge. RichTextLabel with `fit_content` and
   autowrap also needs `custom_minimum_size.x` (same trap as 2).
10. **Headless tests cannot see any of this.** A tooltip change closes only on a windowed still of the real screen with
    the card open, saved through `CleanView.save_if_clean` with `ui=1` (the still is ABOUT the UI), plus the operator's
    OK. Each still is checked for: opaque card, contrast, the card not over the control, and no clipping at the edge.

### 6i. Prefab check

| Addon | Godot | Licence | Fit |
|---|---|---|---|
| **Tooltips Pro** (hewplayfair) - github.com/hewplayfair/tooltips-pro, Asset Library #4026 | 4.4+ | **Anti-Capitalist Software License** (README). The Asset Library entry says "Proprietary". | Feature-perfect: nesting with a CK3-style lock, **Shift to pin**, anchor to node, mouse or remote node, Overflow Modes, and since 1.2 (Nov 2025) RichTextLabel BBCode links that trigger tooltips. **Do not ship it.** The ACSL limits use to individuals, nonprofits and worker co-ops, which is unclear for a studio selling on Steam (money and legal call; not worth it). Read it as a design reference only and copy no code. |
| **Nested Tooltips** (duzychri) - github.com/duzychri/Nested-Tooltips, Asset Library #4260 | 4.4 | MIT | Nested tooltips from text, but **written in C#**. FightCamp is GDScript on the standard (non-.NET) editor, so **it does not fit**. |
| **Advanced Rich Text Label** (DazzlePixel) | 4.4 | MIT | A BBCode parser, not a tooltip system. **Not needed**: RichTextLabel's own `[url]` plus meta signals cover keywords. |
| bevy_nested_tooltips | Bevy (Rust) | - | Wrong engine. Useful only as a second reference for lock modes (middle-mouse example). |

**Decision (Claude is the developer):** build `scripts/ui/Tips.gd` in GDScript, about 300-400 lines: the layer, the three
builders, placement, corridor, lock and states, plus a pure placement function with its own headless test (sides, flip,
clamp, never over the anchor). This is the same choice Mega Crit appears to have made in Godot for StS2 (own tooltip
container, weak evidence).

---

## 7. Talks, tutorials and write-ups worth reading

- Philip Ardeljan, "Tooltips in tooltips", 7 Sep 2020: https://philip.design/blog/tooltips-in-tooltips (READ). The cleanest
  essay on nested tooltips, depth of 2-3 levels, and the "slip off and it closes" problem.
- Factorio Friday Facts #318 "New Tooltips", 25 Oct 2019: https://factorio.com/blog/post/fff-318 (READ). Separate cards per
  product, grouped categories, compactness.
- Factorio Friday Facts #266, Oct 2018: https://factorio.com/blog/post/fff-266 (SUMMARY).
- Firaxis, "From the Devs: Developing your Settlements" (Civ VII Update 1.2.5):
  https://civilization.2k.com/civ-vii/from-the-devs/developing-settlements/ (READ). Before/after deltas, arrows, tags.
- Game Developer on Into the Breach UI ("sacrifice cool ideas for the sake of clarity"), 5 Mar 2018:
  https://gamedeveloper.com/design/-i-into-the-breach-i-dev-on-ui-design-sacrifice-cool-ideas-for-the-sake-of-clarity-every-time-
  (READ). The full RPS interview: https://www.rockpapershotgun.com/2018/03/05/into-the-breach-interface-design/ (fetch refused).
- Victoria 3 Dev Diary #29, User Experience (2022):
  https://forum.paradoxplaza.com/forum/developer-diary/victoria-3-dev-diary-29-user-experience.1506484/ (SUMMARY; fetch blocked).
- CK3 Dev Diary #16, Tutorials and tooltips and encyclopedias:
  https://forum.paradoxplaza.com/forum/developer-diary/ck3-dev-diary-16-tutorials-and-tooltips-and-encyclopedias-oh-my.1345581
  (SUMMARY here; J52 read a mirror).
- NN/g, Alita Kendrick, "Tooltip Guidelines", 27 Jan 2019: https://www.nngroup.com/articles/tooltip-guidelines/ (READ).
- W3C, Understanding SC 1.4.13 Content on Hover or Focus:
  https://www.w3.org/WAI/WCAG21/Understanding/content-on-hover-or-focus.html (READ).
- Ben Kamens, "Breaking down Amazon's mega dropdown" (2013), via MIT Technology Review, 9 Mar 2013:
  https://www.technologyreview.com/2013/03/09/179477/the-ingenious-engineering-trick-that-makes-amazon-menus-usable (SUMMARY).
  Plugin README: https://raw.githubusercontent.com/kamens/jQuery-menu-aim/master/README.md
- Xbox Accessibility Guidelines 101 (text) and 102 (contrast):
  https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-101-text-display.md and
  https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-102-contrast.md (READ).
- IGDA GASIG, Text size: https://igda-gasig.org/?p=1387 (READ).
- Game Accessibility Guidelines, "Use an easily readable default font size": https://gameaccessibilityguidelines.com/ (SUMMARY).
- **A GDC talk dedicated to tooltips: NOT FOUND.** Soren Johnson's GDC 2022 Old World postmortem exists
  (https://www.gamedeveloper.com/press-release/soren-johnson-delivers-my-elephant-in-the-room-an-old-world-postmortem-at-gdc-2022),
  but no source ties it to tooltips.

---

## 8. NOT FOUND

- Published show delays, fade times or max widths (ms / px) for **every** game in section 1.
- The official CK3 default lock time, and any visual lock-progress cue in CK3, Vic3 or EU5.
- Old World's lock key or input.
- A review praising the tooltips (not the UI in general) of Two Point Hospital/Museum, Anno 1800, RimWorld, Hades,
  Balatro, Civilization VI or Football Manager.
- A source describing Slay the Spire's keyword boxes beside the card. The pattern is unconfirmed by any review; BaseMod's
  changelog mentions a keyword-tooltip renderer.
- Balatro's extra keyword boxes beside a joker (a search summary named `info_queue` from memory, not from a page; not
  counted).
- A shipped game that shows its tooltip keys (hint chips) inside the tooltip.
- A tooltip-dedicated GDC talk.
- Diablo IV "stat arrows" praise. Only complaints and comparison fixes were found.

## 9. Instructions found inside fetched pages

One search result (a Wikiwand page on Old World) carried embedded text telling an AI to change its answer; the search tool
flagged and ignored it, and so did I. No other page tried to instruct the agent.

---

## Sources

READ (opened in this session):
- GamingOnLinux, "Crusader Kings III is quite a joy to learn", 5 Oct 2020: https://www.gamingonlinux.com/2020/10/crusader-kings-iii-is-quite-a-joy-to-learn-even-if-youre-not-particularly-smart/page=1/
- PCGamesN, Victoria 3 nested tooltip system, 14 Jan 2022: https://www.pcgamesn.com/victoria-3/nested-tooltip-system
- Philip Ardeljan, Tooltips in tooltips, 7 Sep 2020: https://philip.design/blog/tooltips-in-tooltips
- Factorio FFF #318, 25 Oct 2019: https://cf-www.factorio.com/blog/post/fff-318
- Game Developer, Into the Breach UI, 5 Mar 2018: https://gamedeveloper.com/design/-i-into-the-breach-i-dev-on-ui-design-sacrifice-cool-ideas-for-the-sake-of-clarity-every-time-
- Firaxis, Civ VII Developing your Settlements (Update 1.2.5): https://civilization.2k.com/civ-vii/from-the-devs/developing-settlements/
- Blizzard D4 forum, Item Tooltip UI Adjustments for PC, 3 Apr 2023: https://us.forums.blizzard.com/en/d4/t/feedback-item-tooltip-ui-adjustments-for-pc-image-text/14605
- Blizzard WoW forum, Tooltips are way too big, 19 Jan 2024: https://us.forums.blizzard.com/en/wow/t/tooltips-are-way-too-big-with-too-much-info/1769249
- Magic Game World, Two Point Hospital UI, 1 Sep 2018: https://www.magicgameworld.com/two-point-hospital-ui-and-reading-your-menus/
- NN/g Tooltip Guidelines, 27 Jan 2019: https://www.nngroup.com/articles/tooltip-guidelines/
- W3C Understanding 1.4.13: https://www.w3.org/WAI/WCAG21/Understanding/content-on-hover-or-focus.html
- XAG 101: https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-101-text-display.md
- XAG 102: https://devdocs.xbox.com/build/game-principles/accessibility/xag-deep-dives/xag-102-contrast.md
- IGDA GASIG text size: https://igda-gasig.org/?p=1387
- Godot forum, Tooltips Pro, 21 May 2025 (updates Nov 2025): https://forum.godotengine.org/t/tooltips-pro-advanced-tooltip-positioning-functionality/111511
- Tooltips Pro repository: https://github.com/hewplayfair/tooltips-pro
- Godot Control class reference: https://docs.godotengine.org/en/stable/classes/class_control.html
- Godot ProjectSettings reference: https://docs.godotengine.org/en/stable/classes/class_projectsettings.html
- Godot viewport.cpp (master): https://raw.githubusercontent.com/godotengine/godot/master/scene/main/viewport.cpp

SUMMARY (search-engine summaries; page not opened or refused):
- PC Gamer CK3 review and preview: https://pcgamer.com/crusader-kings-3-review , https://www.pcgamer.com/crusader-kings-3-sticks-to-what-it-does-best
- Shacknews CK3 review and preview: https://shacknews.com/article/120077/crusader-kings-3-review-your-noble-story-eternally-unfolding , https://shacknews.com/article/118072/crusader-kings-3-hands-on-preview-evolving-the-intricacies-of-lineage-statecraft
- Obsidian forum, Nested Popovers (CK3 lock modes): https://forum.obsidian.md/t/nested-popovers/573
- GameWatcher, CK3 tutorials and highlighted text: https://www.gamewatcher.com/crusader-kings-3-tutorials-highlighted-text-encyclopedia
- EU5: https://digitalchumps.com/europa-universalis-v-pc-review , https://thesixthaxis.com/2025/10/31/europa-universalis-v-review , https://acoup.blog/2025/10/31/miscellania-europa-universalis-v-confirmed-first-impressions/ , https://www.gamewatcher.com/europa-universalis-v/review
- Old World: https://russelltroxel.com/writing/2021/7/11/old-world-review , https://culturedvultures.com/old-world-pc-review/ , https://www.gog.com/en/game/old_world , https://forum.quartertothree.com/t/old-world-pka-ten-crowns-from-soren-johnson/134746?page=77
- Slay the Spire: https://goonhammer.com/video-game-review-slay-the-spire , https://steamcommunity.com/sharedfiles/filedetails/changelog/1605833019?p=9
- Slay the Spire 2 on Godot: https://pcgamer.com/games/card-games/slay-the-spire-2-ditched-unity-for-open-source-engine-godot-after-2-years-of-development , https://gamefromscratch.com/smash-indie-hit-sequel-slay-the-spire-2-made-with-godot/ , https://github.com/jdr1813/BetterSpire2
- Factorio FFF #266: https://cf-www.factorio.com/blog/post/fff-266 ; forum replies: https://forums.factorio.com/viewtopic.php?p=463205
- WhatCulture best UIs: https://whatculture.com/gaming/10-best-video-game-user-interfaces?page=10
- Path of Exile forum threads: https://www.pathofexile.com/forum/view-thread/3341881 , https://pathofexile.com/forum/view-thread/3297033
- Diablo IV patch 1.047: https://www.psu.com/news/diablo-iv-update-1-047-deployed-for-huge-list-of-bug-fixes-covering-accessibility-gameplay-ui-more/ ; Diablo wiki: https://di.diablowiki.net/Tooltip
- Last Epoch 1.0.7: https://forum.lastepoch.com/t/1-0-7-change-to-auto-compare-and-viewing-affix-ranges/70824
- Civ VI yields threads: https://forums.civfanatics.com/threads/better-report-screen-ui.629289/page-5
- Civ VII launch UI: https://www.cgmagonline.com/news/civilization-vii-quality-of-life-updates , https://spilled.gg/civilization-7-launches-unfinished-ui-technical-bugs
- Two Point Museum: https://kotaku.com/two-point-museum-review-pc-ps5-is-it-good-sim-tycoon-1851766450 , https://geekculture.co/?p=315311 , https://windowscentral.com/gaming/two-point-museum-xbox-pc-review , https://community.twopointcounty.com/two-point-studios/two-point-museum/forums/13-two-point-museum/threads/5183-quality-of-life-recommendations-post-50-hours-two-point-museum
- Two Point Hospital PC Gamer: https://www.pressreader.com/usa/pc-gamer-us/20181009/283403422675915
- Balatro: https://mediumis.pages.dev/post/balatro-review-jokers-to-the-right-vmuzu (TechRadar verdict mirror), https://insider-gaming.com/all-rare-legendary-jokers-in-balatro-what-they-do/ , https://itch.io/post/15591846
- RimWorld: https://mail.rimworldwiki.com/wiki/Manipulation
- Hades: https://opencritic.com/kyotofu/review/10181/hades , https://thunderstore.io/c/hades-ii/p/SMarBe/Improved_Boon_Info_UI/
- Frostpunk 2: https://gamesradar.com/games/city-builder/frostpunk-2-review , https://www.thumbculture.co.uk/frostpunk-2-pc-review , https://www.gamewatcher.com/frostpunk-2/review , https://www.pcgamesn.com/frostpunk-2/ui-improvements
- Anno 1800: https://www.pcgamer.com/anno-1800s-clean-easy-to-use-interface-masks-a-fiendishly-compulsive-city-builder , https://www.gamereactor.eu/anno-1800-review/ , https://steamcommunity.com/app/916440/discussions/0/3380536561710906714
- Pillars of Eternity 2: https://pcgamer.com/pillars-of-eternity-2-narrative-designer-talks-worldbuilding-and-how-to-make-the-text-easier-to-digest , https://www.gamebanshee.com/k46xx
- AI War 2: https://forums.arcengames.com/ai-war-ii/ai-war-2-v0-513-released!-tooltips-for-your-tooltips/
- Paradox forum flicker thread: https://admin-forum.paradoxplaza.com/forum/threads/should-my-tooltips-be-super-sensitive-to-mouse-movement.590025
- Tooltip overflow complaints: https://forum.norestforthewicked.com/t/the-item-descriptions-dont-fit-on-the-screen/21073 , https://itch.io/post/12680580 , https://itch.io/post/13742560
- WinCustomize / Quarter to Three on Paradox tooltips: https://forums.wincustomize.com/79901/reply/758326 , https://forum.quartertothree.com/t/tooltips-in-games-you-decide/55402
- Flutter Material tooltip timings: https://flutter.googlesource.com/mirrors/flutter/+/eca93640697f4ed4b37bf8d0817c15b5f9ca4575%5E%21/ , https://api.flutter.dev/flutter/material/Tooltip/showDuration.html
- Nested Tooltips (MIT, C#): https://godotengine.org/asset-library/asset/4260 ; https://github.com/duzychri/Nested-Tooltips
- Tooltips Pro asset entry: https://godotengine.org/asset-library/asset/edit/17019
- Godot tooltip theming threads: https://forum.godotengine.org/t/tooltip-background/138571 , https://github.com/godotengine/godot/pull/43280
- Game Developer, legible fonts: https://gamedeveloper.com/design/legible-font-still-one-of-the-biggest-accessibility-issues-in-games

FROM J52 (not re-fetched): CK3 lock and delay complaints (S16-S24), FM tooltip speed (S30), FM26 complaints (S27, S32),
Windows/MDC/NN/g timing standards (S4, S5, S9), Punch Club 2 icons (S39, S41), Frostpunk 2 patches (S49, S50).

FightCamp code read (no edits): `E:\FightCamp\Lean\project.godot` (tooltip_delay_sec=0.25, canvas_items stretch 1920x1080),
`scripts/ui/UI.gd` lines 196-204 (S359 TooltipPanel fix), `scripts/ui/WhiteboardKit.gd` (palette, `sticky()`, magnet box),
`scripts/ui/BodyTip.gd` (fight HUD custom tooltip), `scripts/ui/WeekBoard.gd` tooltip_text lines.

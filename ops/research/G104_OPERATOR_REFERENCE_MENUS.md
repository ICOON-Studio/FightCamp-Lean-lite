# G104 — Operator reference menus (research only)

Collected S80 2026-09-25 from https://grok.com/c/49531153-d561-4df2-9768-b391dc5ee73e (Grok's reply saved verbatim below; inline source chips flattened to text).

---

Owner: grok · Date: 2026-09-25 · Scope: menus only. No FightCamp implementation.

Method: inventory title / hub / time / feedback / reviews, then extract shared taste vs Motorsport Manager + Hollywood Animal, then adopt / improve / avoid for Direction A (brass & leather, dim gym, warm light).

Tagging: SOURCED = named page with date. PROXY = inferred from screenshots, trailers, HUD guides, store copy, not first-hand play. JUDGEMENT = synthesis for FightCamp.

Operator list (verbatim, 2026-09-25): Company of Heroes 2; Mad Games / Mad Television Tycoon; Deep Rock Galactic: Survivor; Big Ambitions; Corsair Cove; NBA 2K26; Master of Command — beside Motorsport Manager and Hollywood Animal.

## 0. What a UI lead does first

Inventory each game's title, hub, list, card, clock, modal, transition, hover/press, how new items arrive. Name the technique. Read dated praise/hate. Then copy / improve / avoid. That is this memo.

## 1. Company of Heroes 2 (Relic / SEGA, 2013)

1. Title + hub — PROXY. Title: still / looping Eastern Front plate — soldier or beach assault, desaturated grey-brown, serif / stencil type, gold or off-white labels. Hub is a flat "Home" stack: Campaign / Multiplayer / Army / Profile. Not a 3D place. MobyGames labels shots "Main menu" / "Main title". (Mobygames)
2. Time — SOURCED. No week clock. Real-time battle. Pause exists; the week does not. Campaign is mission select, not a calendar. (Web.archive)
3. Transitions / hover / sound — PROXY. Hard cuts and brief fades. Hover = highlight + tooltip. Click = military click. In-game: unit portrait, "Bridge" command strip, resource panel, global unit row. Relic sold this as "clean, concise" (official UI post, 2013-01-08). (Gamingbolt)
4. Praise / hate (menus specifically)
- Hate, in-game UI (2013): GamesRadar — bottom third + top fifth eat ~50% of the screen; "information overload." 2013-04 review archive. (Web.archive)
- Hate, GUI layout (2013-04-11): Reddit "The Problem with CoH2's GUI" — tiny resources, wasted bottom chrome, VP score hard to read. Praise for unit badges. (Reddit)
- Hate, later Relic menus (2023–2025): players call CoH3 / refreshed Relic front-ends "programmer art," "early-2000s flash," drab greyscale. That complaint is aimed at the house style after CoH2 more than 2013 CoH2 itself. (Reddit +1)

Technique name: Battlefield chrome — high-density RTS HUD, still-image title, list hub.

## 2. Mad Games Tycoon 2 (Eggcode, 2021)

1. Title + hub — SOURCED / PROXY. Title: simple stacked buttons on a studio-ish plate (New / Sandbox / Continue / Load / Multiplayer / Options). UI scale slider in options. Hub is the isometric office floor itself — rooms are the menu. Top bar: weekly charts, reputation, trending genres, staff happiness, messages. Right: released games. Bottom: company mark, country, finance, fans. CG117 UI overview, 2024-05-13. (YouTube)
2. Time — PROXY. Continuous tycoon clock. Pause + speed steps. "Week" is the chart tick and salary cycle, not a booked calendar. Development is a multi-page wizard (name / genre / theme → engine → sliders). Steam guide, updated 2026-04-13. (Steamcommunity)
3. Transitions / hover / sound — PROXY. Room click → action bubbles. Hover tooltips (players asked for "?" copy). ESC pause overlay. Soft office clicks. F6 / window icon toggles overlay chrome — easy to lose. Steam thread 2024-11-22. (Steamcommunity)
4. Praise / hate — Praise: depth, GUI scale, sandbox sliders. Hate: busy HUD; work lives in rooms, so you walk/click three places to start one task; overlay can vanish and look like a soft-lock. Japanese Steam reviews: more busywork than MGT1. (Do not confuse with 2016 "Game Tycoon 2", a different title with worse UI reviews.) (Steamcommunity)

Technique name: Building-as-menu + dense top ticker.

## 3. Mad Television Tycoon (Eggcode, EA 2026-04-09)

1. Title + hub — SOURCED. Same house as MGT2. Start menu: New / Load / delete saves / random name+logo for channels. Hub = station building + rooms (elevator hours as tooltips). Broadcast schedule is the hero screen. Store + patch notes 2026. (Store.steampowered +1)
2. Time — SOURCED. Day clock + broadcast grid (the week). Space pause; patch fixed "pause at day start sets wrong speed" (2026-07 notes). Schedule tooltip has a time bar (broke when UI scale changed — they patched it). (Steamcommunity)
3. Transitions / hover / sound — SOURCED. Room doors animate. Right-click-twice-to-close on schedule was a bug. Transparent inactive penalties on the right. Messages on the left. (Steamcommunity)
4. Praise / hate — Thin critic record (EA). Dev themselves flag "UI improvements" as a full-version pillar. Capsule reads loud red/yellow on blue sky — not Direction A. Steam Analyzer 2026-07-27. (Steamanalyser)

Technique name: Schedule board as the week machine. Closest analogue to a fight card.

## 4. Deep Rock Galactic: Survivor (Funday / Ghost Ship, EA 2024-02-14, 1.0 2025-09-17)

1. Title + hub — PROXY. Title: Hoxxes / dwarf / gold-and-rust DRG palette, bold industrial type. Hub is not parent-game Space Rig 3D. It is a between-dive menu stack: class, biome, difficulty, permanent Upgrades. Parent DRG's Space Rig is the taste reference players bring (walkable hangar, terminals). TrueAchievements / DRG wiki. (Trueachievements +1)
2. Time — SOURCED. No calendar. Dive time = top-center progress bar with swarm / supply-drop ticks. Meta time is "next dive." TechRaptor HUD, 2024-02-14; Night Wings HUD video 2024-03-03. (Techraptor +1)
3. Transitions / hover / sound — PROXY. Dive load → drop. Level-up = modal card pick. Fail/win → results → Upgrade shop. Hover tooltips. UI called "clean" in HUD explainers. Parent franchise: hold-H hides HUD.
4. Praise / hate — Reviews crown the loop, not the menus (PC Gamer 2025-09-17). Menus are quiet, readable, slightly generic survivor-like. Players praise clarity of the in-dive HUD, not front-end theatre. (Pcgamer)

Technique name: Mission-select terminal + run results + meta shop. Hub is a locker, not an office.

## 5. Big Ambitions (Hovgaard, EA → 1.x)

1. Title + hub — SOURCED. Title rebuilt ~2022: Continue / Story / Sandbox / Load (saves per character) / Options / News panel / Workshop blueprints. Hub is walkable NYC + HQ desks — first-person place, not a 2D home. Steam news 2022-05-06 "New main menu"; CG117 menu + HUD videos 2024-02. (Store.steampowered +1)
2. Time — SOURCED. HUD clock: weekday + time + pause/play. Options slider = game speed (dev confirm 2023-07-08). Skip-hour exists in later builds / mods. Employee week = schedule grid (drag days, copy/paste, autofill). Steam 2025-05-12. (Steamcommunity +1)
3. Transitions / hover / sound — SOURCED. Item overlays hidden until hover; broken/low-stock icons stay up (2022). BizPhone / BizMan / map / EconoView as slide-overs. Interior designer is a mode, not a page.
4. Praise / hate — Praise: living city as hub; speed control; later schedule tools. Hate: early schedule UI confusing; "visit the firm" chores (now toggleable); overlay hunt. EA 0.9 (2025-09-30) added Blueprint Creator because running across town was hated. (Store.steampowered)

Technique name: Lived-in 3D city + clock strip + phone overlay.

## 6. Corsair Cove (Limbic / Hooded Horse, 2026-07-31)

1. Title + hub — SOURCED. Title: sung 1694 ballad, pirate-paradise art (The Wand Report 2026-07-28). Hub = Island View — the cove is the menu. Top-left quests/deeds; top: Codex, gear, resources, overviews, island/world toggle, coin, time settings. Steam beginner guide 2026-09-22; GamesHorizon HUD 2026-07-31. (Steamcommunity +1)
2. Time — SOURCED. Pause + multiple speeds on the top bar. Production is continuous; quests gate the week.
3. Transitions / hover / sound — SOURCED. Click building → colour-coded supply paths. Unobtrusive "stopped producing" toasts. HUD hide for screenshots. Theme on the title praised. Gamereactor 2026-08-14. (Gamereactor)
4. Praise / hate — Praise: "UI is excellent" for routes and alerts; production numbers readable (Wand Report; NGOHQ 2026-08-01). Hate: HUD dumps every icon on first boot; late-game vertical city = pick-fail / Excel-dense; same-type building browse is clumsy; naval combat collapses to menus/cards. Destructoid / Cyberludus 2026. (Destructoid +1)

Technique name: World-as-HUD city builder with colour-coded logistics and a speed clock.

## 7. NBA 2K26 — MyCAREER / MyGM (Visual Concepts, 2025-09)

1. Title + hub — SOURCED. Boot: cinematic cover (SGA) → mode mosaic (MyCAREER, MyTEAM, MyNBA/MyGM, PlayNow, The W). MyCAREER: story "Out of Bounds" then The City — walkable neighborhood, locations packed closer than 2K25 (NoypiGeeks 2025-09-19). MyGM: MyGM Building — walkable office: staff, practice gym, shoot-in-a-suit, tasks. "Bigger and more energetic." 2K Courtside Report 2025-08-21. (Store.steampowered +1)
2. Time — SOURCED. MyCAREER = season + story beats. MyGM / MyNBA = calendar + sim speeds ("Faster sims" from community ask). Offseason Scenarios = scripted week of conversations. GM Legacy menu tracks the career. (Tech.yahoo)
3. Transitions / hover / sound — PROXY / SOURCED. Broadcast stingers, GOAT-moment flash UI "lasts a second" (GamingTrend 2025-09-06). MyTEAM card view went from flip-card to tabbed list — some hate it (Gaming Nexus). HUD is user-tunable. Menus described as "slick" and also "taped-on shop chrome." (Gamingtrend +1)
4. Praise / hate — Praise: MyCAREER story + City traversal cut downtime; MyGM Building as a place; adjustable HUD. Hate: mode mosaic is a mall; MyTEAM/MyCAREER shop UI feels mobile P2W (Wallbang 2025-09-12); MyGM scenarios "forced," RPG perks bolted on (IGN 2025-09-05); MyNBA "menu-heavy text adventure with a walk-around wrapper" (ZTGD 2025-10-14). (Wallbangnetwork +2)

Technique name: Walkable branded building over a calendar sim — plus a store that must not be copied.

## 8. Master of Command (Armchair History Interactive, 2025-10-27)

1. Title + hub — SOURCED. Title: painted 18th-c. plate, nation select with coloured strength text. Two hubs: campaign map (2D theatres, towns, encounters) and Camp (tents grow as divisions unlock; inventory + units). Dev Log #7 (2025-03) / #10 (2025-09-28). (YouTube +1)
2. Time — SOURCED. Campaign is real-time with pause (was turn-based in concept, changed). Battles real-time; pause / half-speed exist but the GUI is built so you need them less. Tally-Ho Corner 2025-11-07. (Tallyhocorner)
3. Transitions / hover / sound — SOURCED. Battle commands in three colour groups (blue move / red fire / purple special). Officer abilities in a dropdown. Empty panels darkened so the eye stays on units. "+" purchase control expands on hover. Tooltips on stats. Dynamic music. Dev Log #7. (Games-manuals)
4. Praise / hate — Praise: "struggling to think of a wargame GUI that displays as much useful information as attractively, logically, and legibly" (Tally-Ho, 2025-11). Camp grayscale pass is a textbook contrast fix. (Tallyhocorner) Hate: selected unit not always obvious; overlapping healthbars; some players misread hills. Not a front-end font revolt.

Technique name: Illustrated camp + colour-coded command grammar + pauseable map.

## Reference poles (operator already likes)

Motorsport Manager (Playsport, 2016) — SOURCED. Title / series select → HQ as a place you build. Home tabs: mail, cars, staff, finance, calendar. Race weekend is the sacred time object (practice / quali / race) with pause + 1/2/3 speed (keys 1–2–3, space). Dark paddock chrome, data panels, dilemmas as mail. HQ screen is the one players linger on. PC Gamer 2016-09-30; manual structure. (Pcgamer)

Hollywood Animal (Weappy, EA 2025-04-10) — SOURCED. Art-deco gold on muted earth. Lot is the hub. Menus "crisp… early 20th-century art deco swagger" (Indie Games Substack 2025-02-19). Golden accents praised (KeenGamer 2025-04-23). Time = production weeks + distribution calendar. Hate (menus): popup storms (10–20 trait toasts); slow forced animations on negotiations; no reliable Esc-close; gift flows take 2–3 windows; QoL mods exist to skip anims. Steam 2025-11-29; Reddit 2025-04-13. (Indiegames.substack +2)

## 5. What the eight share with MM + HA

(JUDGEMENT, operator taste stated plainly)

He is not picking "pretty menus." He is picking management as a job you inhabit.

Shared spine:
- A place, not a dashboard. MM HQ, HA lot, BA city/HQ, Corsair island, 2K MyGM Building, MoC camp, MGT/MTT offices. CoH2 is the odd one (list + battle chrome) — he likely wants its gravitas / material grit, not its Home stack.
- Time is a tool. Pause + speeds (MM, BA, Corsair, MoC, MTT). Or a board that is the week (MTT schedule, MM race weekend, HA distribution weeks, 2K calendar). DRG:S is the exception (run clock, not career clock).
- People and assets as cards inside a workplace. Drivers, dwarves, pirates, GMs, regiments, shows — framed, not spreadsheet-first (2K MyTEAM tabs are the failure mode).
- Material language over flat grey. Leather/brass/paper/gold leaf/rust/wood. HA deco gold and MoC ink-and-wash are the closest to Direction A. CoH drab and 2K shop neon are the poles to reject.
- Density with a job. He tolerates information if it feels like a pit wall, a broadcast desk, a camp table. He does not tolerate density that feels like a store or a flash site.
- Notifications that earn the click. HA's popup pile and Corsair's day-one icon dump are the documented failure of this taste.

Plain sentence: he wants a dim professional room you return to, a clock you drive, and objects that look handled — not a tile menu and not a toast storm.

## 6. Adopt / improve / avoid — FightCamp Direction A

| # | Technique | Verdict | Why (fits brass / leather / dim gym / warm light) |
|---|---|---|---|
| 1 | 3D gym / office as the hub (HA lot, MM HQ, MyGM Building, BA HQ, MoC camp) | ADOPT | Direction A is a place. Title can be a still of that room under practicals, not a mosaic. |
| 2 | Week object you can point at (MTT grid, MM race weekend, HA release weeks, 2K calendar) | ADOPT | Fight week / camp week as a board on the wall, not a hidden sim. |
| 3 | Pause + 2–3 speeds on a persistent clock strip (MM, BA, Corsair, MoC) | ADOPT | Management games without a visible clock feel like apps. |
| 4 | Colour-coded action grammar (MoC blue/red/purple) | ADOPT | Warm brass for confirm, oxblood for fight/cut, muted olive for admin — readable in low light. |
| 5 | Cards in material frames (paper, leather, brass corners) | ADOPT | HA deco + MoC illustrated stats. Athlete / booking / purse as objects on a desk. |
| 6 | Hover reveals; broken-state icon stays (BA 2022 overlay rule) | ADOPT | Dim UI stays quiet until the hand asks. Injury / unpaid / unsigned stay visible. |
| 7 | Darken empty panels so the subject wins (MoC camp grayscale pass) | ADOPT | Direction A lighting: pool on the fighter, not on chrome. |
| 8 | Walkable hub plus a jump list / phone (BA BizMan, 2K City shortcuts) | IMPROVE | Place first, but never force a cross-town walk to open a contract. |
| 9 | Results stinger that lasts ~1s then yields data (2K GOAT flash) | IMPROVE | One warm flash after a fight, then the tape. No 8-second locked anim (HA hate). |
| 10 | Meta shop between sessions (DRG:S upgrades) | IMPROVE | Fine as a locker-room board. Fatal if it becomes 2K VC storefront. |
| 11 | Logistics colour paths (Corsair) | IMPROVE | Reuse for fighter flow: gym → medical → press → cage. One overlay, toggle off. |
| 12 | RTS-style bottom "Bridge" eating 30–50% of frame (CoH2) | AVOID | Gym view dies. Dock chrome thin; let the room read. |
| 13 | Greyscale flash Home + inconsistent hit targets (Relic front-ends) | AVOID | Players said "programmer art." Direction A cannot look unfinished. |
| 14 | Popup / trait toast storms (HA) | AVOID | Batch into one ledger. Esc always closes. Never lock input during tween. |
| 15 | Day-one icon dump (Corsair boot HUD) | AVOID | Reveal tools with the job. First gym visit should feel like lights-up, not Excel. |
| 16 | Mobile shop mosaic / tabbed paywall chrome (2K MyTEAM) | AVOID | Kills brass-and-leather. Featured cosmetics do not live on the home plate. |

10–16 is 16 rows; keep 1–12 as the working set if the table must stay tight. 13–16 are the explicit avoid list the reviews paid for.

## Source index (URL + date)

- CoH2 UI official writeup — gamingbolt.com, 2013-01-08
- CoH2 UI critique — GamesRadar archive review, 2013
- CoH2 GUI thread — reddit.com/r/CompanyOfHeroes, 2013-04-11
- Relic menu hate — reddit.com/r/CompanyOfHeroes, 2025-12-12 and 2025-01-26
- MGT2 UI video — youtube.com/watch?v=fbPMom5yDlk, 2024-05-13
- MGT2 guide — steamcommunity.com/sharedfiles/filedetails/?id=2646360175, 2026-04-13
- MTT store — store.steampowered.com/app/3565020, EA 2026-04-09
- MTT patches — steamcommunity.com/app/3565020/announcements, 2026
- DRG:S HUD — techraptor.net, 2024-02-14; PC Gamer review 2025-09-17
- Big Ambitions menu/HUD — youtube CG117, 2024-02-26/27; Steam news 2022-05-06, 2025-09-30
- Corsair HUD — steam guide 2026-09-22; Wand Report 2026-07-28; PC Gamer 2026-07-28
- NBA 2K26 MyGM — Steam Courtside Report 2025-08-21; IGN 2025-09-05; GamingTrend 2025-09-06
- Master of Command — Dev Log #7 2025-03-08; Tally-Ho Corner 2025-11-07
- Hollywood Animal — KeenGamer 2025-04-23; Substack 2025-02-19; Steam menu thread 2025-11-29
- Motorsport Manager — PC Gamer 2016-09-30; Playsport manual structure

Confidence: title/hub/time = medium-high (PROXY where unplayed). Review sentiment on menus is thin for MTT and DRG:S; thick for CoH, HA, 2K, Corsair, MoC, BA.

140 sources

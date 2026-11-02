<!-- Collected S178 2026-10-08 via gbot thread; raw chat reply, not yet verified -->
# J64 - Click a thing, see its actions

Task: J64. Research only, no game code. How do famous games link actions to things on screen, and should clicking the FightCamp fighter let you call any available coach?
Date: 2026-10-08 (Asia/Nicosia)
Owner: John Research
Tags legend: **[S#]** = SOURCED (url and post date in Sources, all accessed 2026-10-08) · **[J]** = JUDGEMENT · **NOT FOUND** = searched for but not verified

## 0. Answer first

- **Yes, click the fighter and call a coach is a good idea [J].** Shipped games already do this: Planet Zoo's animal panel has "Call Keeper" and "Call Vet" [S19], Prison Architect's "Guard Response" calls the nearest guards to a spot you click [S14], and a Big Ambitions player asked for exactly this flow in 2024 [S26].
- **Do it better than they did [J]:** list every coach by name, and grey out the ones who can't come with a reason and the time they're free ("busy until 14:00"). Don't just do "call nearest". RimWorld already works this way: disabled entries show reasons like "no path", "cannot reach" and "Reserved by {pawn}" [S3][S4].
- **Recommended model: a target-first "action ring" [J].** Click any thing and time hard-pauses (matches the 2026-10-05 ruling). Up to 6 icons appear around the thing. Hover shows a tooltip, blocked actions are greyed with a reason, and Esc or right-click cancels and resumes time.
- **Add one actor-first shortcut [J]:** with the fighter selected, right-click a station to train there. RimWorld, Prison Architect and Game Dev Story all use this pattern [S1][S15][S27]. JWE players hated the extra "Add Task" click [S23].
- **Mistakes other games made:** menu bloat (Sims 4 "hundreds of social options") [S13], refusing an action without saying why (Planet Zoo "ZERO feedback") [S21], and things you couldn't tell were clickable (Big Ambitions "Clicking on my employees does nothing") [S26]. A 6-action cap, reasons on every greyed action and a hover outline deal with all three [J].
- **Prefab:** Radial Menu Control (MIT, Godot 4.3+, submenus, mouse/keyboard/gamepad) is the best ready-made ring [S29][S30]. The coach list can use Godot's built-in PopupMenu or Control nodes [S36][J].
- **Gap:** for most of these games I couldn't find whether time pauses while a menu is open. The Sims 4 does not pause by itself; a 2025 mod exists only to add that [S12][J].

## Q1a. Selection model (actor first, target first, or both)

| Game | Model |
|---|---|
| The Sims 4 | Actor first: the selected Sim gets the plumbob, then you click a Sim or object to get its pie menu [S10] |
| RimWorld | Both. Actor first: select a pawn, right-click a target to get the float menu [S1]. Target first: select anything and its commands ("gizmos") appear bottom-left [S5][S6] |
| Prison Architect | Mostly actor first: left-click or drag-select staff, right-click the destination [S14][S15]. Plus a target-first tool: Guard Response calls the nearest guards to a clicked spot [S14] |
| Two Point Hospital / Campus | Target first: click a staff member and the Staff Inspector panel opens. "Pick Up" carries them to a task [S16][S17] |
| Planet Zoo | Target first: click an animal and the info panel opens with "Call Keeper" and "Call Vet" [S19] |
| Jurassic World Evolution 2 | Actor first: select a team, then "Add Task", then pick the target. Seen in the JWE3 official guide and JWE1 player posts [S22][S23]. JWE2's own docs NOT FOUND |
| Chef: A Restaurant Tycoon Game | Target first, mostly information: "click on in-game entities to learn more" (patch of 2019-04-02) [S24] |
| Big Ambitions | Target first: click an employee and "you have options to manage them" (developer, 2024-10-23) [S26] |
| Game Dev Story (Kairosoft, JP PC ed.) | Both: left-click a developer, then right-click a desk. Left-clicking a dev table opens its menu [S27] |
| Football Manager (shouts) | Target first, not on a map: Shouts button, pick a shout, then whole team or tick "Individuals" [S28] |

## Q1b. What appears on click, and max actions

| Game | What appears | Max actions |
|---|---|---|
| The Sims 4 | A radial pie around the target, with categories and a "More Choices..." overflow (EA forum thread title) [S12b][S13] | No cap found. "Hundreds" of social options are possible [S13]. The action queue holds 6 [S10] |
| RimWorld | A float menu as a list at the cursor [S1], with icons on entries since 1.6 [S2]. The gizmo grid sits bottom-left [S5] | No cap found. A popular mod adds search to menus with 15+ options [S8] |
| Prison Architect | Right-click a destination and staff simply go; no menu [S14] | NOT FOUND |
| Two Point Hospital | A side panel (Staff Inspector) with Info/Mood/Stats/Log tabs and a footer of icon buttons: Pick Up, Fire, Promote, Train, Open Message, Vaccinate, Take a Break/Return to Work, Pay Review, Jobs, Staff Customisation [S16]. TPC's inspector has 5 tabs [S17] | 10 footer slots [S16] |
| Planet Zoo | An info panel with tabs. The Overview tab holds Call Keeper, Call Vet, Request Quarantine and Move [S19]. Staff panels have Training and Employment tabs [S20] | 4 actions on the animal Overview tab [S19] |
| JWE2 | The team panel with "Add Task", then a task choice [S22] | NOT FOUND |
| Chef | An Info Panel with stats and current activity [S24] | NOT FOUND |
| Big Ambitions | "Options to manage them" [S26]. Layout NOT FOUND | NOT FOUND |
| Game Dev Story | A list menu on the dev table: Original Game / Sequel / Game based on Manga / Cancel [S27] | 4 [S27] |
| Football Manager | A shout list from the touchline tablet, with an "Individuals" option per shout [S28] | 8 shouts [S28] |

## Q1c. Unavailable actions: hidden, or greyed with a reason?

| Game | Behaviour |
|---|---|
| The Sims 4 | The engine supports both: greyed with a hover tooltip, or fully hidden (modding API docs) [S11]. If nothing is available, no pie appears at all [S10] |
| RimWorld | **Greyed with a reason.** Verified English strings include "no path", "cannot reach", "Cannot go here: No path", "Reserved by {pawn}", "Will never do {work}" and "{pawn} is incapable of violence" [S3][S4]. Version 1.6: "Disabled float menu entries are now more verbose" [S2]. Gizmos are also disabled with a reason (e.g. Draft when incapacitated) [S7] |
| Prison Architect | NOT FOUND |
| Two Point Hospital | **Hidden when not relevant:** "Vaccinate: Only appears when an Epidemic is active". Promote and Train are described as showing when the staff member has enough XP [S16]; what happens before that (greyed or hidden): NOT FOUND |
| Planet Zoo | No reason given. A player wrote that there is no feedback on why an action fails ("it just flashes red") [S21] |
| JWE2 | NOT FOUND |
| Chef | NOT FOUND for menus. A patch added "proper feedback when trying to unpause the game that is blocked by an important alert" [S24] |
| Big Ambitions | NOT FOUND |
| Game Dev Story | NOT FOUND |
| Football Manager | A cooldown of about 10 minutes between shouts, and team shouts are blocked for 10-15 minutes after individual ones [S28]. Greyed or hidden: NOT FOUND |

## Q1d. Hover before click

| Game | Hover behaviour |
|---|---|
| The Sims 4 | Hovering a greyed interaction shows its reason [S11]. World cursor: NOT FOUND |
| RimWorld | Cell info shows when you hover a tile [S5]. Gizmo descriptions show as tooltips [S7]. Since 1.6, hovering an "attack" gizmo shows range indicators [S2] |
| Prison Architect | NOT FOUND |
| Two Point Hospital | Tooltips on stats, happiness, energy and traits inside the inspector [S16]. Hover in the world: NOT FOUND |
| Planet Zoo | NOT FOUND. A player asked for reason tooltips like "not deep enough" [S21] |
| JWE2 | NOT FOUND |
| Chef | Tooltips on ingredients and recipes [S24]. Hover in the world: NOT FOUND |
| Big Ambitions | Hovering an employee, or their chair, table or computer, shows their name (developer, 2024-10-23) [S26] |
| Game Dev Story | NOT FOUND |
| Football Manager | NOT FOUND |

## Q1e. Does time stop while the menu is open?

| Game | Pause behaviour |
|---|---|
| The Sims 4 | Not by default [J]: a 2025 mod exists only to pause on the pie menu and then restore the previous speed [S12]. The wiki says Live mode pauses for dialogs that need input (tagged TS2) [S10] |
| RimWorld | NOT FOUND officially. Space toggles pause [S1]. A mod "customises max cursor distance from active float menus" [S9], which suggests the menu closes when the cursor moves away [J] |
| Prison Architect | NOT FOUND |
| Two Point Hospital | NOT FOUND |
| Planet Zoo | NOT FOUND |
| JWE2 | NOT FOUND. A JWE1 player in 2018 asked for "A WAY TO PAUSE TIME" [S23] |
| Chef | Important alerts block unpausing (a forced pause) [S24]. Info panel: NOT FOUND |
| Big Ambitions | NOT FOUND |
| Game Dev Story | NOT FOUND |
| Football Manager | NOT FOUND (I couldn't open a page confirming it) |

## Q1f. Left vs right click, shortcuts, cancel

| Game | Controls |
|---|---|
| The Sims 4 | Click a target to get the pie [S10]. Cancel a queued action by clicking its queue icon [S10]. Esc: NOT FOUND |
| RimWorld | Left-click selects, right-click opens the float menu, Shift+right-click queues orders, Shift+left adds to the selection, R drafts, Esc "Closes any open dialogue", Space pauses [S1][S6] |
| Prison Architect | Left-click or drag selects, right-click sends staff to a destination. G toggles Guard Response and right-click turns it off [S14][S15] |
| Two Point Hospital | An X button closes the inspector, arrows cycle through staff, and clicking the selfie follows the person [S16]. Keys: NOT FOUND |
| Planet Zoo | Shift adds to the selection (player reply) [S21]. Rest NOT FOUND |
| JWE2 | NOT FOUND. A JWE1 player says only a few hotkeys exist (Ranger = R, ACU = T) [S23] |
| Chef | NOT FOUND |
| Big Ambitions | NOT FOUND |
| Game Dev Story | Left-click a developer, right-click a desk. "Cancel" is an item in the menu. M opens the main menu [S27] |
| Football Manager | Undo a shout with Tactics & subs, then Cancel changes, within about a second [S28] |

## Q2. Most praised vs most criticised

| Game | Verdict | Quote (verbatim) | Source | Date |
|---|---|---|---|---|
| Two Point Hospital | Praised | "when I say this game is clean, I'm talking about its user-interface and its design." | [S18] Polygon | 2018-09-06 |
| Two Point Hospital | Praised | "A series of smartly designed overlays, menus and data screens allow me to stay on top of emerging crises" | [S18] | 2018-09-06 |
| RimWorld | Mixed | "click on a colonist and right-click on something you want "prioritised" ... It's a bit fiddly but comes in useful in a pinch" | [S9b] RPS | 2016-07-18 |
| RimWorld | Developers admit clutter | "Relevant icons now display on float menu entries. This should help you quickly find the right option in a crowded menu." | [S2] | 2025-07-12 |
| Chef | Players asked for it | "It is now possible to click on most in-game entities to learn more about what's happening in the restaurant!" | [S24] | 2019-04-02 |
| Big Ambitions | Players asked for it | "would be great if we can click on a worker and with another click to the HR Manager for that worker" | [S26] Steam | 2024-10-23 |
| Big Ambitions | Couldn't tell it was clickable | "Clicking on my employees does nothing for me." (later worked) | [S26] | 2024-10-23 |
| The Sims 4 | Criticised | "it's a pain to click through all the options ... She has literally hundreds of social options to click through. It takes ages to find the interaction I want." | [S13] | 2023-02-27 |
| Planet Zoo | Criticised | "Zero, and I mean ZERO, feedback as to why I can't do something." | [S21] Steam | 2019-11-14 |
| Planet Zoo | Criticised | "Would a tooltip saying "not deep enough" or "uneven terrain" be too much to ask?" | [S21] | 2019-11-14 |
| JWE (1) | Criticised | "Remove "add Task" because it's redundant ... Just let me click the thing instead of having to click another thing before I click the thing I want." | [S23] Steam | 2018-07-22 |
| JWE (1) | Criticised | "A WAY TO PAUSE TIME. this would be my preference" | [S23] | 2018-07-22 |

Verdict [J]: reviewers praise the **Two Point Hospital** click-a-person panel most. **RimWorld** has the deepest version, with a reason on every refusal, but it gets "fiddly". The most-criticised patterns are **Sims 4** pie bloat, **Planet Zoo** refusals with no reason, and the **JWE** extra-click flow with no pause.
[send-message t41s358] ## Q3. FightCamp recommendation: one model, the "action ring" [J]

**Direct answer to "is that a good idea?" [J]: Yes.** It turns the 3D gym into the menu (2026-10-05 ruling), and three shipped games prove the "call a worker from the thing that needs them" idea [S19][S14][S26]. Two changes make it better:
(1) show every coach with their real availability and a reason, instead of "call nearest" (Planet Zoo and Prison Architect hide who comes) [J];
(2) make every thing on the floor work the same way, so the player learns one rule.

**Global rules [J]**
- R1 Left-click a thing: time **hard-pauses** (ruling) and a ring of **at most 6 icons** opens around it, with the thing's name in the centre. A picker (e.g. the coach list) opens as a small card beside the ring, because its rows need text.
- R2 Hover before clicking: the thing gets an outline, the cursor becomes a hand, and a name tag shows ("Heavy bag 2 - free"). This fixes the Big Ambitions problem of not knowing what's clickable [S26]. Hovering an icon shows a tooltip: what it does, time cost, energy or money cost, and the effect.
- R3 **Greyed with a reason, never silent** (RimWorld style [S3]; Planet Zoo complaint [S21]). Format: "<why> - <when it frees>". Hide an action only when its whole system is off (like TPH's Vaccinate [S16]).
- R4 Cancel: **Esc or right-click** closes one level (picker, then ring, then nothing). Clicking empty floor also closes. Closing without acting resumes the previous speed (as in the Sims mod [S12]).
- R5 Shortcuts: keys **1-6** pick ring slots, clockwise from the top. With the fighter selected, **right-click a station = "Train here"** with no ring (the RimWorld / Prison Architect / Game Dev Story pattern [S1][S15][S27]). This avoids JWE's "Add Task" step [S23].
- R6 Each link works from both ends: from the fighter you can call a coach, and from a coach you can "Coach fighter".

**Click the FIGHTER** (max 6)
1. Whistle - **CALL A COACH**: opens the coach card. One row per coach on staff: portrait, specialty icon (pads / strength / cardio / defence), "Week left 6h of 20h", where they are now. Free coaches come first, sorted by fit with the current station. Unavailable coaches are greyed: "Busy with sparring until 14:00", "Day off today", "No hours left this week". Pick one: the coach walks over and time resumes. If there are none: "No coach on staff - hire in Office".
2. Glove - **Train at...**: valid stations light up; click one. Greyed examples: "Ring occupied until 11:30", "Energy too low (18%)".
3. Bench - **Rest / recover**. Greyed: "Already resting".
4. Speech bubble - **Talk** (morale, plan).
5. Clock - **Day plan**: highlights the fighter's lane on the timeline bar.
6. ID card - **Profile**: stats side panel.

**Click a COACH** (max 6)
1. **Coach fighter** (go now). Greyed: "Busy until 14:00 (pads)", "Week hours used 20/20".
2. **Set drill focus** (choose from their specialties).
3. **Send to station** (set up before the fighter arrives).
4. **Week hours**: their lane on the timeline.
5. **Talk / contract**. Greyed: "Contract talks only in Office hours".
6. **Profile**.

**Click a STATION** (e.g. heavy bag, speed bag, mirror, cardio, weights, stretch, ring; max 5)
1. **Train here**: shows the drill, duration and energy cost. Greyed: "Occupied until 11:30", "Fighter energy 12%".
2. **Coach here**: coach card filtered by this station's specialty.
3. **Queue next**: runs after the current drill.
4. **What it trains**: info.
5. **Repair / upgrade**. Greyed: "Not enough money (need 400)".

**Click the OFFICE WINDOW** (max 6)
1. **Week review** (also forced at week end, per the ruling). 2. **Hire coach**. 3. **Money**. 4. **Calendar and bout offers** ("fight camp" = pre-bout prep only). 5. **Gym upgrades**. 6. **Messages**.

**Click a PERSON WALKING IN FROM THE STREET** (max 6)
- Arrival counts as a decision, so it hard-pauses and nudges the camera toward them (ruling) [J]. The hover tag says "Walk-in" until you talk to them.
1. **Greet / talk**: reveals who they are (prospect, sponsor, reporter...). 2. **Offer trial session**: prospects only. Greyed: "No free coach until 15:00". 3. **Take to office** (deal). 4. **Ask to come back** (pick a day). 5. **Send away**. 6. **Profile** (once known).

## Prefab check (Godot 4)

| Name | What | Licence | Godot | Verified (2026-10-08) | Fit [J] |
|---|---|---|---|---|---|
| Radial Menu Control (Jesuisse / Pascal Schuppli), Asset Library #3469, v1.1 (2024-11-07) | Pie menu control with submenus; keyboard, mouse, gamepad; themable | MIT [S29][S30] | Min 4.3 [S29]. GitHub master project uses 4.7, last push 2026-07-31 [S30] | Asset page and LICENSE fetched | **Best fit for the ring** |
| Godot Radial Menu (tavurth), #1885, v1.0 (2025-06-16) | Shader-drawn radial menu, mobile and desktop | MIT [S31] | 4.4 [S31] | Asset API and repo fetched (350 stars) | Good, more styling work |
| iRadialMenu (iRadEntertainment), GitHub only | Radial menus in 2D, plus `RadialMenu3DFlat` for 3D; selected/canceled signals | MIT [S35] | Project uses 4.4 [S35] | Repo fetched, last push 2025-04-12 | Useful if the ring should sit in 3D |
| Advanced Radial Menu (diklor), #2220, v1.2 (2024-10-28) | Radial menu node, controller support | Apache-2.0 [S32] | 4.0 [S32] | Asset API fetched | OK |
| Extra GUI Controls (don-tnowe), #1922, v0.9.3.1 (2025-04-26) | Control collection that includes radial menus | MIT [S33] | 4.0 [S33] | Asset API fetched | OK, bigger dependency |
| GD Context Menu (Schimiongames), #4053, v1.1 (2025-05-27) | Right-click list context menu | MIT [S34] | 4.4.1, **C#** [S34] | Asset API fetched | Only if the project uses .NET |
| PopupMenu (engine built-in) | List menu with items, icons, disabled items [J: from memory of the API, page not read in full] | Engine | 4.x docs [S36] | Docs page returns 200 | Coach card / fallback list [J] |

## Sources (all accessed 2026-10-08)

| id | url | date of page/post |
|---|---|---|
| S1 | https://rimworldwiki.com/wiki/Controls | wiki, undated |
| S2 | https://www.rimworldwiki.com/wiki/Version/1.6.4518 | release 2025-07-12 |
| S3 | https://github.com/Ludeon/RimWorld-fr/blob/master/Core/Keyed/FloatMenu.xml (English strings in "EN:" comments) | last repo commit 2026-09-21 |
| S4 | https://github.com/josh-m/RW-Decompile/blob/master/RimWorld/FloatMenuMakerMap.cs | old build, version unknown |
| S5 | https://www.rimworldwiki.com/wiki/User_interface | wiki, undated |
| S6 | https://www.rimworldwiki.com/wiki/Drafting | wiki, undated |
| S7 | https://github.com/josh-m/RW-Decompile/blob/master/RimWorld/Pawn_DraftController.cs | old build |
| S8 | https://steamcommunity.com/sharedfiles/filedetails/?id=2928608119 (Searchable Menus) | posted 2023-02-04 |
| S9 | https://github.com/DingoDjango/PersistentFloatMenus | undated |
| S9b | https://www.rockpapershotgun.com/rimworld-review-early-access | 2016-07-18 |
| S10 | https://www.thesimswiki.com/wiki/Live_mode | wiki, undated |
| S11 | https://github.com/ColonolNutty/Sims4CommunityLibrary/wiki/Custom-Interaction-Tutorial | wiki, undated |
| S12 | https://www.patreon.com/pancakemizore/posts/auto-pause-on-123423629 (also curseforge.com/sims4/mods/auto-pause-on-pie-menu-interactions) | 2025-03-02 |
| S12b | https://forums.ea.com/idea/the-sims-4-bug-reports-en/multiple-more-choices--options-on-non-active-sim/12195548 (title only) | NOT FOUND |
| S13 | https://simscommunity.info/2023/02/27/the-sims-4-pie-menu-update/ | 2023-02-27 |
| S14 | https://prison-architect.fandom.com/wiki/Guard_Response | wiki, undated |
| S15 | https://prison-architect.fandom.com/wiki/Guard | wiki, undated |
| S16 | https://two-point-hospital.fandom.com/wiki/Staff | wiki, undated |
| S17 | https://two-point-campus.fandom.com/wiki/Staff | wiki, undated |
| S18 | https://www.polygon.com/reviews/2018/9/6/17828188/two-point-hospital-review-windows-pc-mac-linux/ | 2018-09-06 |
| S19 | https://planetzoo.fandom.com/wiki/Animal_Information_Panel | wiki, undated |
| S20 | https://one.planetzoogame.com/help-centre/player-guides/staff-and-guests | undated |
| S21 | https://steamcommunity.com/app/703080/discussions/0/1637550282081751917/ | 2019-11-14 |
| S22 | https://www.jurassicworldevolution.com/en-US/3/help/player-guides/operations-guide (JWE3) | undated |
| S23 | https://steamcommunity.com/app/648350/discussions/1/1710690176755749382/ (JWE1) | 2018-07-22 |
| S24 | https://store.steampowered.com/news/posts/?feed=steam_community_announcements&appids=886900&enddate=1562253631 | patches 2019-02-08, 2019-04-02, 2019-06-25 |
| S26 | https://steamcommunity.com/app/1331550/discussions/0/4697909843220007404/ | 2024-10-23 |
| S27 | https://www.niahak.org/quick-guide-game-dev-story-pc/ | post undated (comments from 2012) |
| S28 | https://www.passion4fm.com/how-to-use-touchline-shouts-in-football-manager/ | 2025-10-11 |
| S29 | https://godotengine.org/asset-library/asset/3469 | 2024-11-07 |
| S30 | https://github.com/jesuisse/godot-radial-menu-control | pushed 2026-07-31 |
| S31 | https://godotengine.org/asset-library/asset/1885 | 2025-06-16 |
| S32 | https://godotengine.org/asset-library/asset/2220 | 2024-10-28 |
| S33 | https://godotengine.org/asset-library/asset/1922 | 2025-04-26 |
| S34 | https://godotengine.org/asset-library/asset/4053 | 2025-05-27 |
| S35 | https://github.com/iRadEntertainment/iRadialMenu | pushed 2025-04-12 |
| S36 | https://docs.godotengine.org/en/stable/classes/class_popupmenu.html | docs |

## Limits

- Blocked (Cloudflare or 403): the Paradox Prison Architect wiki, the Sims fandom wiki, the Kairosoft wiki.gg, the SI community FM manual, GameSkinny and TrueAchievements. I used other sources where I could; otherwise the cell says NOT FOUND.
- JWE2 itself is not directly verified. Its rows rely on the JWE3 official guide and JWE1 player posts.
- Game Dev Story rows come from a guide to the Japanese PC edition; the mobile edition may differ.
- No game was played and no screenshots were checked. Button strings appear only where a fetched page shows them.
- RimWorld strings come from the official translation repo's English comments (current) and an old decompile. Exact 1.6 wording may differ.
- Whether time pauses while a menu is open is undocumented for most of the 10 games. The Two Point Campus action footer was NOT FOUND. Chef was hardly researched beyond its patch notes.
- The action names in Q3 are proposals [J], not tested with players.

---

That's the whole document. A copy is on my computer at `/workspace/j64/J64_CLICK_A_THING_SEE_ITS_ACTIONS.md`, so Claude can land it as `research/J64_CLICK_A_THING_SEE_ITS_ACTIONS.md`. Source numbering skips S25; nothing is missing.

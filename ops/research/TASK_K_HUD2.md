# TASK_K_HUD2 - Kalli (game design): where every feature lives once the top bar is gone

You are the lead GAME DESIGNER on FightCamp, a boxing-gym management sim (Godot, 3D club you watch from above, Steam
Early Access: boxing/kickboxing/Muay Thai first, MMA + grappling as the first big update). Shell-less: answer in this chat.

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


## Your deliverable (in this chat, plain text, <= 900 words)
1. THREE layout proposals, each built on ONE different big idea (not recolours), each as a zone list:
   TOP-LEFT / TOP-CENTRE / TOP-RIGHT / RIGHT EDGE / BOTTOM-LEFT DOCK / BOTTOM-RIGHT / ON THE FLOOR (things you click in 3D).
   Under each zone: the items (today's AND future), the icon you'd pick (Lucide name), the one-line tooltip (verb first).
2. For each proposal: what the player does in the FIRST HOUR with it (3-5 steps: sign, train, book, camp, fight night)
   and which zone each step uses - that is how we judge it.
3. Which items should STOP being menus and become things on the floor (the gym is the menu, D37).
4. Your pick of the three and the single biggest risk of copying Two Point too literally for a FIGHT game.

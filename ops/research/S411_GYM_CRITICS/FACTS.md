# The gym as the main menu: facts for the critics (S411, 2026-11-09)

The thing under review is the isometric gym on the Home page, its five clickable places, and how it fits the rest of the game.

## Pictures (E:/FightCamp/critic_pack/gym_s411, open with the file tool)
Real renders of the game. Hidden-desktop renders are 1009 px tall: the bottom 71 px of a 1080 screen is cut off, which is not a fault of the game. Boxers on the floor walk and work (they animate in the game). In these renders the same boxer can repeat in a list: that is test data.
- home_layout_A.png: Home with the gym on top; everything else sits below it and scrolls.
- home_layout_B.png: a second Home layout, on one screen, with things around the gym. Its sticky notes are currently missing their titles (known bug): judge the arrangement.
- home_with_a_fight_booked.png: Home with a bout booked, an older render of layout A.
- choose_your_building.png: the setup page where the player picks one of four buildings.
- fighters_page.png, versus_page.png: two pages the owner chose and likes, for the look the game is heading to.
- painted_concepts_four_menus.png: four painted concepts of other pages. Surfaces only: they carry too much text, invented numbers, and a left menu that no longer exists.

## What the gym is now
- Drawn from data: assets/data/gym_plans.json + scripts/rules/GymPlan.gd, by scripts/ui/IsoGym.gd. A plan is 24 x 18 cells with zones (reception, office, lockers, bags, weights, ring, mats) and items. `GymPlan.problems` refuses a plan that is not a sound building.
- Fixed 2D isometric, one angle. On Home it is 700 px tall on a 1920x1080 screen. No zoom, pan or rotate. Nothing can be built or moved yet.
- Four buildings, picked once at setup, each with one small bonus for the whole career (the bonus is real and read by the rules): Front of house (+5% members), Two full rings (+5% club show), The bag wall (+3% power and technique training), Conditioning floor (-10% days out injured).
- Start of a career: 30 members; the club has one fighter walk in, a roster grows towards about eight.
- 2 + members/5 people on the floor, cap 12, the club's own fighters first (scripts/rules/GymPeople.gd).

## The clickable places today (scripts/ui/GymHub.gd PLACES)
| Label on the gym | Sits on zone | Opens |
|---|---|---|
| Reception | reception | Members, walk-ins, signing |
| Fighters | bags | Roster, find a fighter |
| Playbook | mats | The fighter's game plans, moves, combinations |
| Fights | ring | Bout offers and what is booked |
| Club office | office | Money, staff, the club |
| World | none: placed at the end of the bag wall | Rankings, other gyms, the wider boxing world |
The same five destinations are also on the top bar as icon pills (Home, Fighters, Fights, Club, World). Playbook is reached from the gym or a fighter's page.

## The owner's rulings that touch this (verbatim, with session)
- S408: "make the fucking game look like a game not a website form". He agreed with an isometric club and "the hud skipping side panel" (no left rail: icon pills on top, bubbles over rooms).
- S408, on single AI paintings of the gym: "reception door is drawn inside the gym", "playbook is on the door", "you need to make the gym make sense ... make a tool to properly design the gym and maybe use the tool for player too design his own".
- S408: "all 4 look nice", "maybe add option for player to select", "each gym slight bonus different from each other", "or even option to create their own later with preset assets or how other games do that".
- Standing: gym art is bright and alive, modern, never an old garage. The facility is a "gym"; a fight camp is only the pre-bout preparation.
- S244: "Make sure every agent is aligned with 2point museum perspective and item integration per room" (ops/research/TWOPOINT_ALIGNMENT.md, written for the planned 3D gym).
- S278: draw the zone, then the items. S277: rooms are drawn empty, no pre-furnished room or free starter kit. Earlier: the training floor holds training only (no bath, board or chairs on it).
- CLAUDE.md: "2D menus and the simulation first. The 3D fight and 3D gym come later as views on the same data." One gym, a small roster, amateur to first pro fight.
- S268 / S275: "weird panels everywhere", ONE top bar, nothing opens by itself.
- S398: only actionable info on screen, "unless the player can really do something about it".
- S303-S403: every menu shows only what the game really does; not built = marked as not built.
- S410: Fighters and the bout offer: "Build it like the right, painted surfaces".
- S411: the four other pages: "Yes, but with fewer words and bigger pictures, like Fighters".

## Other decisions that may or may not depend on it
Later features already agreed or planned: the player builds their own gym on the same rules; Move premises (a later bigger building); the four buildings; one fighter's week and the Playbook as the main training mechanics; bouts booked from Fights; no-gi BJJ ships with boxing (a mat zone matters); the first-hour guide (a first-week tutorial) which points at places on the Home page.

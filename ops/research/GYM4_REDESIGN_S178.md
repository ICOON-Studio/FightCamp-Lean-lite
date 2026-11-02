# GYM4 - the club redesigned from real gyms (S178, 2026-10-08) - ON PAPER, waiting for the operator's OK

Supersedes the GymHall3D floor LAYOUT (GYM3D1_LAYOUT.md, rejected S177). Engine rules unchanged (CareerMorning, DayLap, interview /
coach hire logic, mornings wiring). `gym3d_main` stays OFF until the operator OKs the video. Nothing is built before he OKs this page.

## The operator's words (verbatim, S177 + S178)
- S177 verdict: "I have no idea what have you designed. What you designed it doesn't look like a gym at all. I see a board in the
  middle, a chair. You have a bathtub in the gym floor [...] Do gym floor have bathtubs? The whole design is very bad."
- Floor use: "Training + a stretch corner".
- Stations on the floor: "in the skipping area i want to select the moves/skills and be displayed there with their animations",
  Treadmill + bike, Weights, Recovery (stretch mats), Skipping area.
- Coach: "3 [in the office window], if you click on the fighter you can call any available coach . is that a good idea ? can you make
  an interface like that to link actions available by assets in the screen, but check first what games are famous for this and how
  they achived it and then delegetate to cursor,qwen,arena,codex,grokbots,cline,and any other agents we have to work on the cloud"
- Meetings: "make the gym like a living entity poeple come and go outside and anyone can walk in , something simalar to the game Chef
  [...] the player at the start is in his office until a customer(fighter) or coach or a trainer or other stuff join [...] (motorsport
  manager loop . i am thinking the race is the scheduled training the lap is the day there is a goal to reach in time and time is
  ticking and trying to achieve the best result out of the trianing session each day or week (not sure about the pacing)"
- Building: "design the whole gym so i can zoom in on each area use opace effects , how other games do that when zooming in and walls
  are opace then dissapear as zoom in more and the inside , can you do that ? is is it a good idea design ?"
- Size: "Small club, grows later". Camera: "Both, zoom between them". Move cards at the mirror strip: "Yes, exactly".
- S178 rulings on the plan: "OK, build it"; keep from the current hall: "Keep none" (all new models); pacing: "2:00 day (Kalli)".
  Correction: "thereceptionis where the interviews happen" - the fighter and coach interviews happen AT THE RECEPTION DESK, not in the office.
- Keep: "show me each to choose and let me know for what use is each of them". Downloads: "yes anything free you can download but
  monitor space on e and d ,check if you can make more space on e". Also: "check pinterest gym schematics pdfs too".

## Prior research
G113 (real sizes), G121 (real plans: ring at one end, bags on a long wall, rooms off a lobby), J61 (Two Point: click the object), J62
(continuous-time refs), G112 (watching is the reward), GYM3D1_LAYOUT (rejected layout + routes/camera mechanics that stay).
New this session: J64 (click a thing -> its actions), K87 (day pacing), M43 (one real photo per zone), D71 (living building, Dola,
fast mode: pointers only), Chef read from its own code (below), UFC Gym franchise plan PDF, 14 Pinterest boxing-gym plans/cutaways.

## What would a human do?
Walk into Gleason's, Repton or Peacock and copy them: red walls covered in photos, painted concrete, bags on chains from a rail, a
ring you can lean on, a mirror lane, a crammed weights corner, a desk at the door, the owner's office full of belts. Then do what Two
Point Hospital does to show a building: roof off when you zoom in, walls cut when you go closer.

## Prefab check
Every training prop has a model in `assets/models/props/gym/` (heavy_bag, speed_bag, double_end_bag, compact_weights, exercise_bike,
rowing_ergometer, plyometric_step_rig, physio_table, cold_water_tub, first_aid); ring = club_ring (needs the 4th rope + low platform);
Kenney Furniture Kit (CC0) for office/reception furniture. Radial action menu: Radial Menu Control (Asset Library #3469, MIT, Godot 4.3+,
repo on 4.7) - J64. Wall fade: a dither alpha on the wall material driven by camera distance (engine feature, no addon).

## The plan (images in previews/gym4_plan/)
- 01_top_down_plan.jpg - the club, metres. Data: `research/GYM4_PLAN_S178.json`, drawn by `Godot/tools/gym4_plan_draw.py`.
- 02_zone_references.jpg - one real photo per zone + what to copy (M43, Commons, Pinterest). Kept OFF git (third-party photos): E:/FightCamp/refs/gym4/.
- 03_keep_choices.jpg - 12 things from the current hall, numbered, with their use now and in the new club. He picks.
- 04_zoom_levels.jpg - the three zooms with real and game references. Kept OFF git: E:/FightCamp/refs/gym4/.

Building 20 x 16.5 m on a street. Hall 20 x 12 = 240 m2 (G113 club band 150-250). Front block: LOCKER ROOM, PHYSIO (the ice tub and
treatment table live HERE), RECEPTION (street door, desk + bell; THE INTERVIEWS happen here - candidate one side of the desk, you the other), YOUR OFFICE (you
start here; coach's desk at a window onto the floor; contracts, money, offers, tape on its TV). Hall: ring back-right (16 ft, low, 4 ropes), bag line back wall (4 bags on a rail, 6 when the club
grows), speed bags back-left wall, mirror + skipping strip left wall (MOVE CARDS: pick one, he shadow-boxes it), open floor for pads and
the slip rope, weights corner left-front on rubber, cardio (treadmill + air bike), stretch corner right-front (mats + rollers, low so
the office window sees the floor), bench + water along the right wall, round timer above the ring, the Wall (story pins) on the back
wall. BAY 2 dashed on the right = where the club grows (+2 bags, 2nd ring or mat room).
Room routes kept from the shipped scenes: office_room, locker_room, physio, film_room (its TV is in the office), staff_room (interviews happen at
the reception desk in a small club), mat_room (BAY 2 later).

## Chef, read from its own code (E:\SteamLibrary\steamapps\common\Chef, Unity, Assembly-CSharp.dll via dnfile)
- Who walks in: `CustomerGroupsGenerator` - a POOL per customer type (`customerModelsPool`, `PoolSizeToFrequencyRatio`) times a
  time-of-day `frequencyCurve` / `probabilityCurve`; `IsCategoryComing`. Reputation/marketing change the pool, the clock shapes arrivals.
- Where they walk: fixed authored waypoints, not a crowd sim - `StaticPositionsManager_Customers_Spawn / _WaitingRoom / _AskForTable /
  _ExitRestaurant`, `StaticPositionsManager_Waiters_ReceiveCustomers`; a visible `HallQueue`; doors open on a trigger (`DoorOpening`).
- Camera: `CameraGame` with named shots (`ShotAtStart`), zoom in/out limits with inertia, edge + drag scroll, rotation, a limits box.
  Chef has NO wall fade: its building simply has no roof and full-height walls. The fade is The Sims / Two Point.
Copy for us: arrivals = pool (fame, ads) x day curve; authored waypoints street -> door -> desk -> office/locker -> floor -> exit.

## Click a thing, see its actions (J64, John - adopted as the proposal)
Left-click any person or object: time pauses, a ring of at most 6 icons opens around it; unavailable actions stay visible, greyed with
"<why> - <when it frees>"; Esc/right-click closes one level; keys 1-6. With the fighter selected, right-click a station = train there.
- FIGHTER: CALL A COACH (every coach with specialty, week hours left, where he is; busy ones greyed with the reason), Train at...,
  Rest, Talk, Day plan, Profile.
- COACH: Coach fighter, Drill focus, Send to station, Week hours, Talk/contract, Profile.
- STATION: Train here, Coach here, Queue next, What it trains, Upgrade.
- OFFICE WINDOW: Week review, Hire, Money, Calendar + offers, Upgrades, Messages.
- WALK-IN: Greet, Interview (at the reception desk), Trial session, Come back later, Send away, Profile.

## Pacing (K87, Kalli - proposed, the operator said "not sure about the pacing")
A day = 2:00 real minutes (12 s per game hour), Mon-Fri watched, Sat sparring as a card, Sun rest - a week ~10 minutes (a short
Motorsport Manager race). Queue only the NEXT station (MM's own fix: "forced people into paying attention"). One DAY goal and one
WEEK goal always on screen ("stamina above 30 at the bell", "jab usable by Friday"). Auto-pause: queue empty, stamina 30, coach pool
short for the rest of the week, injury flag, the bell. Speeds: pause / 1x / 2x. NOTE: DayLap today = 600 game min at 0.3 s/min = 3:00;
moving to 2:00 is one data key (`real_s_per_min` 0.2) - a ruling for the operator, not changed here.

## Build plan AFTER the OK (delegated, per the operator)
1. ARENA - `GymClubLayout.gd` + `assets/data/gym_club.json` from GYM4_PLAN_S178.json (rooms, zones, doors, waypoints, aisle graph) +
   its test (no zone overlap, ring apron 1 m, every station reachable, doors clear, walk-in waypoints connected). Pure, headless.
2. ARENA - `ThingActions.gd`: (thing kind, state) -> up to 6 actions with enabled + reason (J64 table) + test with mutants. Pure.
3. ARENA - `WalkIns.gd`: pool x day curve -> who arrives when (fighter/coach candidates, members, promoter, reporter) + test. Pure.
4. CLAUDE (PC, window) - the 3D club: build from 1, wall/roof dither fade by zoom, three camera zooms, radial menu (Asset Library
   #3469), walkers on the waypoints; one still per zoom from the game camera (as_game), opened before sending.
5. Codex/Qwen/Cursor when their seats are confirmed; Kalli/Maria/John for art + words reviews of the stills.

## Open for the operator
- OK the plan (or name what moves). - Pick what to keep from 03_keep_choices.jpg (numbers). - Pacing: 2:00 day (K87) or keep 3:00.

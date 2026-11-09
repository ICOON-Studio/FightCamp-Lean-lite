# Two gym planner websites, compared, and what fits the game (S414, 2026-11-09)

The owner: "learn both compare them and see if we can adapt them in the game". Claude used both by hand: placed machines, tried overlap, rotation, camera, the 2D plan and the budget. Notes in our own words; nothing of theirs (models, pictures, text) goes in the game.

- Life Fitness: https://www.lifefitness.com/en-us/customer-support/gym-planner/builder (the planner inside is made by London Dynamics). S287: "this is how i want it pretty simple".
- 3DGymPlanner: https://3dgymplanner.com/workspace

## Side by side
| | Life Fitness | 3DGymPlanner |
|---|---|---|
| Start | Pick size and one of three shapes (square, L, T), then Create | Opens straight on an empty 6.1 x 6.1 m room |
| Catalogue | Right side: one dropdown, big picture tiles, one brand family | Left side: tabs, search, 58 brand filter, category tiles with counts that open inline; hundreds of items |
| Add a piece | Drag a tile in: it lands square to the room | Same, or the + on the tile |
| Selected piece | A ring on the floor to turn it, two round buttons (edit, delete) | A toolbar over it (move, turn, resize, edit, copy, delete) and its sizes drawn in metres |
| Turn | Drag the ring | A toolbar button (not tried beyond seeing it) |
| Overlap | Allowed, no warning | Allowed, no warning |
| Camera | Drag empty floor to orbit, near walls drop away by themselves, cube shows the side | Orbit, plus an auto tour of corner views, first-person walk |
| 2D plan | One click, same screen | One click, its own page, hover a piece for size, muscles, price |
| Money | None (a Request Proposal button) | Budget panel: price per piece, new or used, total against a goal |
| Room | Set at the start, changeable later | Numbers or drag a side; inner walls; custom shapes; six kinds of ceiling light seen |
| What the gym can do | Nothing | List of exercises the placed kit allows, updating as you add |
| Floors, zones | Not seen | Flooring and zones you lay on the floor |
| Combat kit | None seen in the categories read | Tatami floor and tatami wall mat only: no ring, no heavy bag category |

Feel: Life Fitness is the simple one, which is what the owner asked for in S287. 3DGymPlanner has more ideas and far more buttons.

## What neither has, and we do
Neither has rules or a game behind it. Both let you stack machines inside each other and block the door. Our GymPlan already refuses that in plain words: items in the right zone, not on top of each other, clear floor round the ring, a walkable route from the door, the entrance into reception. That is the part that makes a builder a game instead of a drawing tool.

## Can it fit? Yes, and most of the base exists
A gym is already data (gym_plans.json: a grid, zones, items), checked by GymPlan.problems, drawn by IsoGym, walked by GymPeople, counted by GymPlaces, saved on the career as gym_plan. A player's gym is the same dictionary, so nothing downstream changes. What is missing is the editor.

| Take | From | In our game |
|---|---|---|
| Drag a picture tile onto the floor | both | Our 12 pieces, in one short list |
| Very few buttons | Life Fitness | One tile list, one rail, no menus |
| Select: ring or two buttons | Life Fitness | Turn and remove. Quarter turns only: the grid has no angles |
| Sizes and clear floor shown while placing | 3DGymPlanner | Green or red footprint with GymPlan's reason in words |
| Live budget | 3DGymPlanner | Cash left, always on screen. Pieces have no prices yet |
| "What this gym allows" list | 3DGymPlanner | Our version is the best idea here: places used out of the premises' limit, updating with every piece |
| Zones laid on the floor | 3DGymPlanner | Our zones already exist: paint them first, or move a preset's |
| 2D plan one click away | both | Straight-down view of the same plan |
| Near walls drop away | Life Fitness | Roof-off already, same as his gym picture |

Leave out: brands, hundreds of items, resize, custom room shapes, lighting, first-person walk, export and share, exercise library.

## Decisions it needs (game rules, not the site's)
1. Places must stay capped by the premises (23, 47, 83), or the best gym is all bags. Over the cap: refused, with the reason.
2. The four presets give a bonus (5% members and so on). A player-made gym: Claude's proposal, the bonus follows what it has most of, the same four bonuses, so a free layout cannot beat them all at once.
3. Start from a preset and change it, not a blank floor: the first hour stays quick (his S287 goal: "build the rooms quickly ... and start training").
4. Each piece needs a price, from real kit costs (a research job for John, no invented numbers).

## Work
- Pure rules, a Qwen job: turn on items (GymPlan swaps w and h), the cap, prices, an edit list with undo.
- The screen, a Cursor job from an approved picture: tile list, rail, footprint, budget, places.
- Art: IsoGym has no turning, and each of the 12 pieces has one drawn angle. A mirrored sprite covers most; a ring and a bag look the same turned. Desk, sofa, rack and lockers need a check.
- The old repo's builder (BuildMode 133 KB, BuildWindow 37 KB) drove the old free 3D gym and breaks the 500-line rule. Do not port it. BuildRail and the S287 task are useful as a list of gestures.

Depends on the camera answer (Q-S294-144): the editor works on the current drawn gym either way, but a real 3D gym would change how pieces are picked.

## Third site: 3D Gym Design (https://3dgymdesign.com/, the owner sent it in S414)
A planner for gymnastics clubs, also sold as a download and a done-for-you service. The free web version is a Unity app (about 25 s to load here), usable as a guest.
SEEN in the app: size in metres or feet and currency at the start; "templates" offered only Blank; catalogue as a deep list (category, then type, then item: Gymnastics, Parkour, Ninja Warrior, General Fitness, Cheer, Wrestling, Climbing, Facility); bottom toolbar with separate select, move, rotate and scale tools plus grid, snap, undo; 3D, 2D and walk-through buttons; camera needs Alt + click and Shift + click.
NOT TESTED: placing a piece. The drag and click tools here did not put a mat in the room, so its selecting, overlap and prices were not seen. From its own page, not checked: live price list, custom mat size and colour, position and rotation numbers on three axes, inspection checklists in the paid version.
VERDICT: the weakest fit of the three. It is the heaviest to use (nested menus, separate tools for each action, keyboard camera), which is the opposite of "pretty simple". Boxing kit: Wrestling held only mats; no boxing category.
WORTH TAKING, one idea: paint mats and the ring in the club's colours. Later maybe: equipment wear with inspections, as a new mechanic, only if the floor feels like decoration.

## All eight sites, and which one is best for the game (S414)
The owner: "compare all these designers and propose which one you think is the best for the game". The owner also leans to a 3/4 view instead of real 3D, so 3D polish counts for nothing here.

| Site | Kind | Pieces | What it reads back | Tested | For the game |
|---|---|---|---|---|---|
| Gym Equipment Rental, gymequipmentrental.com/gym-planner | Top-down grid, half-foot snap | 12 generic, each with its footprint | Machines, space used %, a verdict ("Under-equipped") | Added pieces; dragging not tried | BEST |
| Fix Fitness, fixfitness.com/gym-designer | Top-down grid | 16 generic with sizes | Area used % | Added pieces; dragging not tried | Close second, less read-back |
| Life Fitness | Simple 3D | One brand family | Nothing | Placed, turned, orbited, 2D | Best way to select and turn a piece |
| 3DGymPlanner | Rich 3D | Hundreds, 58 brands | Budget, exercises the kit allows | Placed, overlap, budget | Best extra ideas, too many buttons |
| Blue Sky, blueskyfitsupply.com/pages/gym-layout-designer | Top-down, five steps: walls, floor, kit, customise, quote | 241 | Area per space | Drew a room, reached Equipment; no piece placed | Step order is useful, tool too big |
| RoomToDo, roomtodo.com/planner | General home planner | Furniture catalogue | Not seen | Opened the tools; the room did not draw | Not a gym tool |
| 3D Gym Design | Unity, gymnastics | Gymnastics first | Price list (its own claim) | Editor opened; no piece placed | Weakest of the working editors |
| FloorPlanMaker, floorplanmaker.app/gym-layout-planner | AI: words in, top-down drawing out | None to pick: it places them | Total area | Failed twice in the built-in browser ("Couldn't verify your session"), worked first time in Chrome, under a minute. Drew the boxing gym described. One drag of a bag did nothing, so editing is unproved | Not a builder (nothing to play, and it would need an AI service at runtime), but a fast way for us to sketch layouts |

Two racks added to Gym Equipment Rental landed on exactly the same spot with no warning: same gap as the others, and our GymPlan rules fill it.

### Proposal: build on Gym Equipment Rental's model, in our 3/4 view
Why it wins: it is the only one shaped like our game. A short list of generic pieces, each with a known footprint, on a snapped grid, with a live count and a verdict. We have 12 pieces on a 1 m grid, the same size of problem. It needs no 3D and very few buttons, which is what the owner asked for in S287 ("pretty simple").
The read-back becomes the game: instead of "Space used 12%, Under-equipped", "Places 31 of 47, Room to take more members", or "Floor full: members have stopped growing".
Borrow three things: Life Fitness's turn control (quarter turns only), 3DGymPlanner's always-visible budget, and Blue Sky's order (the room first, then the pieces), which for us means zones, then pieces.
Add what none has: GymPlan's rules, refusing a bad gym with the reason in words. Start from a preset.

FloorPlanMaker's test (24 x 18 m boxing gym): reception, office, lockers, a ring with a marked walkway, 8 bags on one wall and 4 racks all came out in sensible places. Faults: two bags sit inside the weights zone, and it reported 468 m2 for a 432 m2 room. So even a good drawing needs our rules. Use it, if at all, to rough out new preset layouts for us; check its terms before anything from it goes near the game.

## The drawing, after the owner's notes (S414)
docs/mockups/s414/builder_clean, builder_place, builder_refused, builder_turned (tools/gym_builder_still.gd).
His notes: "need to strengthen the connection between equipment-fighter/members", "zoom it a bit", "fit to the edges or add the extra rooms", "how the screen looks without the side panels", "remove the dots ... one meter per zone", "rotate the camera a bit clockwise".
Done in the drawing: full screen, no side panels; controls float in the corners with no floor; street, car park and locked rooms fill the edges; real people on the equipment; one meter a zone; a card for the piece in hand.
Real numbers: places, who fits (GymPlaces.fill at 140 members), the refusal (GymPlan.problems), the prices and effects on the locked rooms (GymUpgrades).
NOT REAL YET, and the point of his first note: GymPlaces is not called by the game. Today equipment changes nothing for a boxer or a member, apart from the Strength corner upgrade and the four presets' bonuses. "Builds Power, Technique", "Trains here this week", "no longer waits" are proposals. Proposed rule, to measure on the balance harness before building: a member with no place at the busy hour is likelier to leave; a boxer whose station is full loses part of that session; a station's kind decides what it builds.
Upgrades drawn as rooms are also a proposal: today they are a list on the Money page.
Camera: turned 20 degrees clockwise the gym draws 9% bigger (scale 1.438 against 1.315), but all 12 equipment pictures are painted at one angle and the 19 boxers' sprite strips are baked at it, so the art must be redone (the turned picture shows the mismatch). The same 9% is free by zooming to the width and letting the top and bottom tips run off screen, with drag to pan.

## Piece prices in the drawing (S414, retail snapshots, draft: a full price list is still a research job)
| Piece | Drawn | From |
|---|---|---|
| Ring | $3,500 | Everlast 18 ft floor-level ring $3,500 (everlast.com/products/floor-level-full-size-custom-boxing-ring); Continental Sports floor ring from GBP 2,547 = about $3,180 at our GBP x 1.25 (continentalsports.co.uk/floor-mounted-boxing-ring) |
| Heavy bag | $570 | 100 lb bag $349 (fitnesssuperstore.com/French-Fitness-Heavy-Punching-Bag-100-lb-p/ff-hpb100.htm) + TKO commercial wall mount $220 (progymsupply.com/p/tko-strength-commercial-heavy-bag-wall-mount/) |
| Weights rack | $1,050 | Body-Solid 5-50 lb hex set with rack $1,034 (fitnessfactory.com/item/body-solid-vertical-5-50-lb-hex-dumbbell-package-with-rack) |
| Bench | $400 | TKO commercial flat bench $400 (strengthwarehouseusa.com/products/tko-strength-flat-bench-860fb) |
| Floor mat, 3 x 2 m | $390 | About $6 a sq ft for 4 x 8 ft folding mats (Home Depot gym mat listings), 65 sq ft. Consumer grade: the weakest of the five |

The camera "the other way" (20 degrees anticlockwise): scale 1.329 against 1.315, about 1% bigger, so it fits no more of the gym than the clockwise test (9%) or a zoom (9%). The art would still need redoing.
What each piece builds is a proposal.

## The straight-on view (S414)
The owner: "like top-down but with angle?", "2d". The building square to the screen, seen from above and tilted so the back wall shows: docs/mockups/s414/builder_angle_only.jpg and builder_angle_hud.jpg. Still 2D, no real 3D. Scale 1.752, against 1.315 for the diagonal view (33% bigger) and 1.421 for the diagonal zoomed to the width (23%). The 24 x 18 building fills the window edge to edge; nothing is cropped.
Costs: the 12 equipment pictures are painted for the diagonal and must be redrawn facing front; the boxers' strips are baked from 3D by tools/bake_hub_sprites.gd and can be baked again at this camera. The panels now lie over the floor, so they need to slide away.

## The painted gym, and can tools do it (S414)
The owner: "no weird angles, straight up full screen ... generate as a high detailed background screen with our art style, can external tools do that?", "door looks wrong ... should be on top side and expand maybe towards the bottom or sides".
Test, about 10.5 Ludo credits, `ludo image edit` from the CLI. Pictures: docs/mockups/s414/builder_painted_only, builder_painted_hud, builder_grow. Working files E:/FightCamp/tmp/s414_builder/paint (final/ = the room and pieces used; style_ref.png = a sheet of our 12 pieces).
What worked: a painted EMPTY room from our own render keeps every wall and zone exactly in place (three tries, all usable). Each piece redrawn front-facing from our own picture, as a separate cut-out, keeps colours and materials: 11 of 11 usable first try.
What failed: painting the whole gym with the equipment in it kept the diagonal angles, looked aged, and would freeze the layout. S408's rule stands: never one painting for the gym. Room as the painting, pieces and people on top.
Weak point: the boxers are 3D renders, sharper and turned three-quarter, against painted surroundings. To do: re-bake at this camera, then try a paint pass.
Tripo: not signed in on his Chrome, no CLI or key here. Value would be four-way turning from one model. `ludo model create` is the same idea from the CLI, not tried.

## How expansion will work (proposal)
1. The door and the back wall never move. The building grows down and to the right.
2. Three stages, real premises numbers: Start, the unit, 16 x 12, 70 members, 23 places, $1,800 a month. Stage 2, bigger unit, 24 x 18, $12,000, 140 members, 47 places, $3,400 a month. Stage 3, club building, 32 x 24, $25,000, 250 members, 83 places, $5,500 a month.
3. The next stage shows as a locked area with its price and what it gives, before you can afford it.
4. On moving up, everything stays where it stands and the new floor arrives empty.
5. Each stage needs one painted room per plan shape, or a room built from painted strips.
Not solved: this layout does not nest. The Start outline cuts through the ring, so Start needs its own layout that holds a ring and leaves every piece in place at Stage 2. The four presets are not nested either.

## How adding equipment will work (proposal)
1. Pick a piece: the zones it may stand in light up, and the piece follows the mouse.
2. Green footprint shows cost, +places, what it builds. Red footprint gives GymPlan's reason, and it cannot be placed.
3. Placing it pays the price; it arrives after a week of fitters, as upgrades already do (GymUpgrades.FIT_DAYS 7).
4. Zone meters and the top number update at once. The places cap comes from the premises.
5. Selected piece: Turn, Remove (part of the price back: number to be set).
6. A full zone is what pushes you to buy or expand: needs the rules in "The drawing, after the owner's notes", measured on the harness first.

## His own picture as the gym (S414)
The owner: "can you use this exact picture" (C:/Users/user/Downloads/MMA Manager Gym Floor Plan.png, 1672 x 941, his mock HUD baked in; a version without the HUD exists only in the chat). Test, about 4 Ludo credits, working files E:/FightCamp/tmp/s414_builder/his.
Worked: `ludo image edit` removed every object and person and kept the building, floors, light and camera; a second edit removed the HUD and continued the grass and wall. Pieces cut out of the picture one at a time (image-type sprite) came back whole. Pictures: docs/mockups/s414/hisgym_empty.jpg, hisgym_moved.jpg (a different layout from his, the picture's own scale).
Limits: one left-hand room kept its showers after the emptying; the bags lost their rail and float; a sign, cage and posters say MMA and the demo is boxing only; entrance is on the front wall, against his earlier note (door on top, grow down or sideways); 1672 wide, Ludo upscale caps at 2048; he should confirm where the picture came from; Steam asks for AI content to be disclosed.
To build: the plan's zones and items must be remapped to this room (its own tile grid and picture scale, rooms on the left, main floor on the right), and every piece the game needs cut out or generated with this picture as the style reference. The boxers need to match this darker, more realistic look.

## "Why you do not use it exactly as it is?" (S414)
His latest picture, no HUD and no people, kept at E:/FightCamp/tmp/s414_builder/his3/gym.png; in the game frame docs/mockups/s414/hisgym_exact.jpg. As it is, it can be the main screen at once: pins and meters placed on its own rooms. What a fixed picture cannot do: show a change when the player adds a piece or expands, or match a gym that does not own a cage. An emptied room and cut-out pieces from his previous version (his2/empty, his2/piece) are ready for when the builder needs them.

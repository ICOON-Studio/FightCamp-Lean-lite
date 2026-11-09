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

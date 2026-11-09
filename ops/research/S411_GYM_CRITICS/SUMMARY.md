# The gym critics, S411 (2026-11-09)

Owner: "to me the gym feels small, there are options like World that do not fit on the scene, playbook also". Three fresh sonnet critics: player (not told his notes), game designer, art director (both told). Reviews: player.md, designer.md, art.md here. Drawings of each one's 10/10: docs/mockups/s411/gym_10/{player,designer,art}.png, side by side in three_10s.png. Claude checked the claims below against the code and the pictures.

| Critic | Presentation | Options | Hard fails |
|---|---|---|---|
| Player | 5 (about 7 without the fail) | 5 | World is on nothing that is World; Playbook on the mats borderline |
| Designer | 5 | 5 | World and Playbook on false objects; layout B's styles; needs below the fold |
| Art director | 5 | - | Boxers are about 65 px here, 250 on Fighters, 650 on Versus; a flat diorama on a dark photo in layout B |

All three agree with him, including the player who was not told.

## Why it feels small
Only about 20% of the screen is gym (floor about 1,200 px wide). People about 65 px. Walls one figure high. About 20 objects, flat light, plain colour floors. The picture never grows, though the rules already sell it: GymUpgrades has Unit 1,500 sq ft / 70 members / 3 places, Bigger unit 3,000 sq ft and a second ring / 140 / 5, Club building two floors / 250 / 7. The drawn plan (24 x 18 cells) is about 3,700 sq ft by the designer's reading, already bigger than the Unit the career starts in.

## World and Playbook
Neither is a place in a gym. All three: make them objects on the wall that really are what they open. World: a TV or noticeboard with news and rankings. Playbook: the coach's whiteboard, opening the next bout's plan. The player also wants a Training week place.

## What changes in earlier decisions (designer's table, in full in designer.md)
Keep: isometric gym as Home, no left rail, plans from data, the Fighters and Versus look, one top bar, nothing opens by itself, only actionable info, needs first, fewer words, first-hour guide (it pulses the object).
Change: the gym is a status picture plus shortcuts, not a second copy of the top bar. Move premises comes earlier and visibly grows the building. The four buildings become flavours of a small start. People: about 20 (rule today 2 + members/5, cap 12). Labels: badges only when you must act, names on hover.
Drop or park, on paper only: Two Point alignment and the planned free-camera 3D gym for the first release; "rooms drawn empty" applies to the builder, not the presets. Build-your-own stays later; GAME_BIBLE line 54 says facility building is out, so that needs reconciling in writing.
Neither Home layout should ship as it stands.

## Where they differ
Backdrop: designer and art director want the dark warm surround of Fighters and Versus; the player wants a light warm one.
Size: the art director scales the same building to about 45% of the screen with boxers about 105 px; the designer starts with a smaller 16 x 12 unit that grows.
Approach: the art director wants a two-day spike of a 3D orthographic render from the game's own assets, for real shadows, zoom and the same boxers as other pages.

## Claude's recommendation
Art director's scale, walls and dark surround; designer's TV, whiteboard, clickable boxers and growth through Move premises; player's state on the floor (flag on the boxer who needs you, a walk-in at the door, the fight on a wall poster). Spike the 3D orthographic render first, because it decides how every later piece gets made.

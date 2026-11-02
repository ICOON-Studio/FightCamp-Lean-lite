# M41 - The scene tree as pictures (Maria, art direction)

Sources: the pasted SCENE_TREE_REVIEW_INPUT map and the operator's four comments. I did NOT open TRAINING_LOOP_DESIGN.md, FLOW_PASS2_ROUTE_WORDS.md, S148_SCHEDULE_TUTORIAL_DESIGN.md or topics/gym_rooms_art.md in this pass, so nothing below is checked against them (NOT VERIFIED). All strings are EXAMPLE (Kalli owns words). Pixel numbers are at 1920x1080.

## 0. Answer in five lines
1. Twelve scenes today become six painted ones: HOME, Training floor, Office, Locker room, Staff room, Film room (Film is late-game).
2. Deleted as scenes: the three area pictures (FIGHTERS, FIGHTS, FINANCE), the Front desk, the Mat room and the Physio. Their jobs move to HOME pins, a floor corner, or a corner of the Locker room.
3. One rule: every screen has ONE home object, and HOME is the only place that has doors. The floor has stations, not doors. The left rail stays as the shortcut and is the only allowed second route.
4. The Training floor becomes the hero scene: your fighter at a station, the coach beside him, five stations as click objects, a move picker with an animated preview.
5. The operator's worry is solved by object design: a calendar that is a wall calendar, a hiring board that is a noticeboard with pinned cards.

## 1. Review: which rooms earn a painted scene
A room earns a scene only if it has at least three objects that each do a job nobody else does. Otherwise it is a corner of another room or a panel.

| Today | Verdict | Why |
|---|---|---|
| HOME | KEEP, becomes the only hub of doors | The gym wide shot is the product's face (M34 direction A). |
| FIGHTERS area | DELETE as a scene; rail icon opens Roster directly | Four buttons on a picture is a menu wearing a painting. |
| FIGHTS area | DELETE; rail opens Schedule, Rankings and Offers become tabs | Same. |
| FINANCE area | DELETE; rail opens the books | Its Office, Staff and Contracts buttons duplicate the Office and Staff room. |
| Training floor | KEEP, rebuilt as stations (section 3) | It is the game. Today it is a hallway of doors. |
| Front desk | MERGE into HOME as two pins | Only two jobs (ladder board, sign-up desk). |
| Office | KEEP | Five distinct jobs. Its calendar becomes the only Schedule door besides the rail. |
| Locker room | KEEP, absorbs Physio | Scale, lockers, body chart are all "the fighter's body". |
| Physio | MERGE into the Locker room as a corner | One object does not earn a room. |
| Mat room | MERGE into the floor as a mat corner | Its two objects both duplicate other routes (dues board is Finance, the coach is Staff). |
| Staff room | KEEP, cut from 3 to 2 objects | One job: people you employ. |
| Film room | KEEP, late-game, 3 objects | One job: prepare for the booked opponent. |

Click objects: 49 today (counting every pin and every back door), about 31 after, of which 6 are plain back arrows. Routes to Schedule: 3 to 1 (plus the rail). Routes to the Staff screen: 5 to 1 (plus the rail). The operator's "here it is again" cases are removed by deleting the object, not by relabelling it.

Flag for the operator: deleting the three area pictures is the one cut he may resist because he liked HOME-style pictures. Fallback if so: keep each area as a small panel with 3 to 4 icon buttons, never as a painted scene.

Flag, NOT VERIFIED: the map gates the Staff room at tier 4. The hiring board is demo-critical (you need a coach early). Either the Staff room is open from tier 1, or the hiring board lives on the Office wall until it opens. I recommend open from tier 1, small and plain, so there is never a second hiring door.

Flag, NOT VERIFIED: whether "Promotions (phone)" and "Fight offers" are the same job. If yes, the phone is the only object for both.

## 2. My scene tree, one art brief per room
Camera for every room: the same high 3/4 painted view as HOME (match HOME exactly; I do not have its pitch or FOV numbers). Canvas 1920x1080. Keep x<120 clear for the rail and y<88 clear for the top bar (approximate from the HOME screenshot, confirm). House rule: bright, warm, populated, never dark or empty. Pins are 64 px circles with a Lucide icon at 32 px, and a tooltip after 500 ms (M33). Never colour alone: each pin has an icon plus a name in the tooltip.

**HOME** (painted wide shot of the whole gym)
Brief: the gym from the street end, one pin per door, so a new player reads "these are the rooms of my gym".
Pins, six at launch plus one late: Training floor `dumbbell` (the big open floor, centre), Office `briefcase` (glass office, left), Staff room `users` (small back room), Locker room `shirt` (right, door with a bench in front), Ladder board `trophy` (a wooden board by the street door, opens Rankings), Sign-up desk `user-plus` (a desk with a clipboard by the door, opens Scouting). Late: Film room `film`.

**Training floor** (section 3)
Brief: your fighter and his coach at a station, four more stations around, no doors.

**Office**
Brief: the manager's desk, a window to the street, everything on the wall or the desk.
Objects, each its own screen:
- The books: a green ledger open on the desk with a pen. Finances. Icon `receipt`.
- The phone: a desk phone with a stack of pink message slips. Promotions and offers. Icon `phone`.
- Contracts cabinet: a four-drawer filing cabinet, drawers tagged with ribbons. Contracts. Icon `archive`.
- Fight calendar: a big wall calendar with a day circled in red and a glove sticker. Schedule, the ONE home of Schedule. Icon `calendar-days`.
- Photo wall: gold frames of past fighters. Former fighters. Icon `image`.
The "MAY 2024" calendar in the old art is repainted to show no real month (M34 flag).

**Locker room**
Brief: warm, bright, lived in, the room where bodies are measured.
Objects:
- The scale: a physician's balance scale by the door. Weight class. Icon `scale`.
- A fighter's locker: a row of metal lockers with name tags, one open with kit. Opens that fighter's profile. Icon `shirt`.
- Physio corner (was Physio): a massage table, an ice bucket and a body chart on the wall. Fighter profile, body page. Icon `heart-pulse`.
- The fight-week board is deleted. Its job (weigh-in countdown) belongs on the scale screen.

**Staff room**
Brief: a small plain room with a table, a coffee pot and a noticeboard, people sitting in it.
Objects:
- Hiring noticeboard: cork board with pinned index cards, some with photo clips. Staff screen, Hire tab. Icon `clipboard-list`.
- A coach: each coach is a seated figure. Click opens that coach's card (an overlay with fire, raise, duties). Icon `user`.
- The staff board is deleted: it opened the same Staff screen as the noticeboard.

**Film room (late game)**
Brief: a dim-but-warm viewing room, projector beam in the dust, a long table.
Objects:
- Projector screen: footage plus tendencies together, one object (they opened the same page). Fighter profile, camp. Icon `film`.
- Laptop: the game plan. Fighter profile, camp, game-plan tab. Icon `laptop`.
- Folder stack: his record and the other files together. Scouting (opponent file). Icon `folder`.

Lucide names above are from memory and are NOT VERIFIED against the 52-icon set shipped in M34; Claude should check them and ask me for any missing.

## 3. The Training floor in 2.5D
Concept image: `m41_training_floor_concept` (attached). It was generated with GenerateImage as MOCK ART, fictional people, no source terms beyond that tool. It shows the right idea: warm sun from the left window, brick, the fighter and the coach at the pads in the middle, the heavy bag at the left, the ring behind, a speed bag and a rope station on the right, an office door at the back. Corrections for the final painting: the heavy bag should be brown leather like the gym concept art (it came out black), the ring canvas green to match M38, and no potted plants blocking stations.

**Frame.** The same camera as HOME. Hero pair (fighter and coach at the pads) at about x960, y600, about 420 px wide. Everything else sits clear of the hero.

**Stations as click objects (five, each a different job):**
| Station | Position (px) | Icon | Trains (EXAMPLE grouping, Claude maps to the real technique list) |
|---|---|---|---|
| Heavy bag | 430, 560 | `hand-fist` | power punches: cross, hooks, uppercuts, body shots |
| Focus pads | 960, 600 (the hero pair) | `target` | combinations and counters with the coach |
| Speed bag | 1640, 500 | `zap` | jab speed and timing |
| The ring | 1380, 430 | `swords` | footwork and sparring, plus Watch spar night |
| Rope and bench | 1760, 760 | `footprints` | stamina and conditioning |
Station shape: hover draws a 3 px gold outline round the object (static, no pulse) and a tooltip with the station name and what it trains. Click opens the picker.

**The picker (replaces "a training floor with no options").** A drawer slides in from the right (240 ms), 520 px wide, `#2a2019`, brass border, over the scene, which stays visible on the left 1400 px:
1. Fighter chips across the top: 64 px portraits with a gold ring on the chosen one.
2. Below: the moves that station trains, one row each, 88 px tall: name 22 px, level pips, and a 240x240 live preview in a corner: a looping render of the fighter's 3D model throwing that move, 1.5 s loop, hover or select plays it. This is the operator's "preview it in animation".
3. Bottom: one gold button, TRAIN THIS (INK text). Choosing it calls the existing per-fighter technique assignment.
4. Closing the drawer returns to the floor with the chosen fighter now at that station.

**What moves in the living loop** (calm, ambient, no looping UI pulse):
- The hero pair: a 6 s loop of the fighter on the pads, jab-jab-cross-hook, the coach shifts the pads and nods. This is the one cut-out clip (about 420x520 region, 12 fps, 72 frames).
- The heavy bag: a gentle sway, a second small clip (about 8 frames, 2 s).
- Speed bag: a quick bounce at about 4 Hz in a very small region (about 4 frames).
- Light shaft and dust motes from the window, slow drift (the M34 live layer).
- A second fighter skipping rope far right and two distant sparring figures in the ring, tiny, 1 clip each.
- When a fighter is assigned to a station he walks there over 1.2 s and the loop swaps to that station. Idle fighters stand and stretch (2 s loops).
Clip budget: about 5 small clips (the office window clip was 10 s; these are shorter and smaller). Reduce-motion shows the still.

**Mat corner (was the Mat room).** A painted blue mat patch in the bottom-left of the floor, appears from tier 3. One object, the dues board on the wall beside it, opens classes and their income. No coach click: the coach is a person you hire.

**Fighters on the floor.** A fighter not at a station stands near the walls. Click opens his profile. Not a door to anything else.

**Navigation.** One back chip top-left under the rail, `arrow-left` plus "Home". No doors to other rooms on the floor, because HOME is the only hub.

## 4. Shipped game I would copy
Hollywood Animal's studio lot: the place is the menu, one building per department, one door per job (this is the model behind M34 direction A, from the M34 reference board; I am citing that board, not re-checking the screen today). Secondary: Punch Club 2's map, where a place is the menu.

## 5. Order of work for the demo (2026-10-06)
1. Training floor still plus picker (the operator's ask, and the first-10-minutes loop).
2. HOME pins re-laid (6 pins), floor doors removed.
3. Office: keep all five objects; remove the Schedule door from the Locker room board so the calendar is the only one besides the rail.
4. Locker room with the physio corner, Staff room with 2 objects.
5. Delete the three area scenes (rail goes straight to the screen) and the Front desk, Mat room and Physio scenes.
6. Film room after the demo.

## 6. Self-attack
- I did not read the four prior-research files.
- Stations to moves is my grouping, not checked against the real technique list or the gym tiers.
- The concept image is AI mock art with unrecorded terms, so it cannot ship; it is a target for layout and mood only.
- Whether a painted Staff room is worth a scene for two objects is a fair question; a panel would be cheaper.
- The living-loop clips need real 3D renders from the fighter models, not AI frames.
- Deleting the area pictures removes six painted scenes of art already made; the cost of that art is sunk, the maintenance saved is real.

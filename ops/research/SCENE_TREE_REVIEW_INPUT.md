# Scene tree review - the shared input for K85 (Kalli), M41 (Maria), J61 (John)

Operator 2026-10-03 (S150): "i also want other agents to provide their own scene-tree aspect and review the current one".
The page he reviewed: `Godot/docs/scene_tree/scene_tree.html` (pictures of every scene + what each click opens; built by
`Tools/scene_tree_page.py` from the game code). The same map as text is below - you do not need the HTML.

## The operator's comments on the current tree (verbatim)
1. On the Office "Fight calendar -> Schedule": "this exists also in the staff room it is very confusing"
2. On the Locker room "Fight-week board -> Schedule": "here it is again"
3. On the training floor: "in this scene i want to be able to select the move i want to train , be able to preview it in
   animation , why we have training floor with no options to train"
4. Follow-up: "this needs also to be displayed in 2.5d the fighter training with the coach etc"

## Claude's reading (a starting point - challenge it)
- Duplicates: Schedule opens from 3 places (Office calendar, Locker fight-week board, FIGHTS area); Staff from 5 (three
  objects in the Staff room alone, the Mat room coach, FINANCE area). Proposed rule: every object in a room does ONE
  different job; every screen has ONE home room; the left rail is the always-there shortcut.
- The training floor is only a hallway of doors. The engine already trains a chosen move per fighter
  (GameState.assign_technique_training, today buried in the fighter profile's Skills page). Proposal TRAIN1: click a
  station (heavy bag, pads, ring, speed bag) -> pick the fighter -> the moves that station trains, each with an animated
  preview -> TRAIN THIS; the floor painted 2.5D with the fighter working the station beside his coach (living loop).
- Rooms go 2.5D (operator S147): painted stills with click pins like HOME; the fight stays 3D. The office v2 preview is
  done (painted still + 10 s living ring clip in the window).

## The map as it is today (generated from Tools/scene_tree_page.py, which reads the game code)

Left rail (always on screen): HOME -> HOME [SCENE], FIGHTERS -> FIGHTERS area [SCENE], FIGHTS -> FIGHTS area [SCENE], FINANCE -> FINANCE area [SCENE]

### HOME (painted picture)
- Office pin -> Office [SCENE]
- Staff room pin -> Staff room [SCENE]
- The ring pin -> Training
- Gym floor pin -> The training floor [SCENE]

### FIGHTERS area (painted picture)
- Roster -> Roster & floor
- Training -> Training
- The floor -> The training floor [SCENE]
- Scouting -> Scouting

### FIGHTS area (painted picture)
- Schedule -> Schedule
- Rankings -> Rankings
- Offers -> Fight offers

### FINANCE area (painted picture)
- The books -> Finances (the books)
- Office -> Office desk
- Staff -> Staff
- Contracts -> Contracts

### The training floor (3D room today, becomes painted 2.5D)
- Door: front desk / street -> Front desk (lobby) [SCENE]
- Door: office -> Office [SCENE]
- Door: locker room (tier 2+) -> Locker room [SCENE]
- Door: mat room (tier 3+) -> Mat room (classes) [SCENE]
- Door: staff room (tier 4) -> Staff room [SCENE]
- Door: physio (tier 4) -> Physio [SCENE]
- Spar card: watch -> Spar night

### Front desk (lobby) (3D room today, becomes painted 2.5D)
- Out to the city -> FIGHTS area [SCENE]
- Back to the floor -> The training floor [SCENE]

### Office (3D room today, becomes painted 2.5D)
- The books -> Finances (the books)
- The phone -> Promotions (phone)
- Contracts cabinet -> Contracts
- Fight calendar -> Schedule
- Photo wall -> Former fighters
- Back to the floor -> The training floor [SCENE]

### Locker room (3D room today, becomes painted 2.5D)
- The scale -> Weight class
- Fight-week board -> Schedule
- A fighter's locker -> Fighter profile
- Back to the floor -> The training floor [SCENE]

### Mat room (classes) (3D room today, becomes painted 2.5D)
- Dues board -> FINANCE area [SCENE]
- The coach -> Staff
- Back to the floor -> The training floor [SCENE]

### Staff room (3D room today, becomes painted 2.5D)
- Staff board -> Staff
- Hiring noticeboard -> Staff
- A coach -> Staff
- Back to the floor -> The training floor [SCENE]

### Physio (3D room today, becomes painted 2.5D)
- A fighter's body chart -> Fighter profile - body
- Back to the floor -> The training floor [SCENE]

### Film room (3D room today, becomes painted 2.5D)
- Footage screen -> Fighter profile - camp
- Tendencies board -> Fighter profile - camp
- His record (folders) -> Scouting
- Game plan (laptop) -> Fighter profile - camp
- Other files -> Scouting
- Back to the floor -> The training floor [SCENE]

## Constraints that are settled (do not reopen)
- Rooms go 2.5D: painted picture + pins, living loops where cheap (S147, D-ledger). The fight stays 3D.
- The facility is a "gym"; "fight camp" means only the pre-bout preparation.
- Icons with tooltips over text labels (operator 09-30 / 10-01).
- Demo is a boxing career (2026-10-06): sign -> train -> book -> fight -> money -> up the ladder (regional -> national 5 net
  wins -> international 7 more, D32).

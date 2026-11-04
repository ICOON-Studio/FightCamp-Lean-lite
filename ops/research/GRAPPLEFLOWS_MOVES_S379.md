# GrappleFlows community moves, mapped onto FightCamp (S379)

Source: GrappleFlows community flows read S379 as REFERENCE - facts only (technique names, which leads to which); users own their flows and the site forbids commercial use of its content, so no titles, wording, authors or links are copied.

2026-11-04, S379 (Claude, workflow step). Research only: no game code was changed and nothing was committed. Data file: `ops/research/grappleflows_moves_S379.json` (every move, chain and plan below, with all fields).

What was read: 84 community flows (12 in each of 7 sections: standup, guard, passing, pins, back, leg locks, submissions). From each flow the workflow kept only technique names, their kind (position, control, takedown, pass, sweep, submission, escape, defence, transition), whether the move needs a gi, how many flows use it, and which move leads to which. The operator asked for the community moves, not the whole site: the names of techniques and which one leads to which are facts of the sport, not a flow's wording. No flow title, sentence, author or link is in this file or in the json.

## Short answer

- **438 no-gi moves** after merging spellings (32 gi-only moves set aside, 17 generic labels such as 'takedown' or 'top control' left out). The game **has 66** of them as their own id, **50 are near** (covered by a wider id or only named in a coach cue), **322 are missing**. Most missing ones are small grips and details used by one flow; 51 missing moves are used by 2 or more flows, 17 by 3 or more.
- **The game already has the core.** Every move used by 8 or more flows is in the game except two: knee on belly (it scores 2 points in `BeltRoad.POINTS`, but no move or seat reaches it) and the seatbelt grip (a coach cue only). The open guard is one `guard` seat in `GroundRules`.
- **357 no-gi chains** (and 32 gi ones set aside). The most-used links are back -> rear naked choke, front headlock -> back take, mount -> armbar, front headlock -> guillotine and side control -> knee on belly.
- **What BJJ lacks most is not moves but the planner.** Boxing has `Combos.BOOK`, the player's own combinations (`OwnCombos`, `f["book"]`) and fight-plan templates (`PlanTemplates`). BJJ has the belt syllabus (`BeltRoad.SYLLABUS`) and one drilled move a week (`NoGi`, `f["drill"]`), with no chains and no premade plans. Section 4 proposes six plans in the shape those files already use.

## 1. The merged no-gi vocabulary

Merge rules (all in the json `method`):
- **Spellings merged** into one name: Knee Slice / Knee Slice Pass / Knee Slide Pass -> Knee Cut Pass; Triangle Choke -> Triangle; Guillotine Choke and the arm-in / arm-out versions -> Guillotine; Knee Bar -> Kneebar; Mata Leao -> Rear Naked Choke; Seat Belt Grip / Seatbelt Control -> Seatbelt Grip; Achilles Lock / Straight Foot Lock -> Straight Ankle Lock; Flower Sweep -> Pendulum Sweep; Side Mount / Crossbody -> Side Control; Back Mount -> Back Control; HQ -> Headquarters; Dogfight Half Guard -> Dogfight. The two sides of one position count as one (closed guard top -> closed guard, top half guard -> half guard, top turtle -> turtle).
- **flows_using** = for each section, the largest count among a move's spellings, summed over the 7 sections. It is a lower bound (a flow that uses two spellings counts once).
- **Gi-only** = flagged gi-only in every section that names it. Three calls of ours over the readers' flags: the collar tie is no-gi (a hand behind the neck; `WrestleChains` already uses it in no-gi); the pant grip and the triceps-and-belt back fall need cloth, so they are gi.

Every no-gi move used by 2 or more flows (the rest, used by one flow each, are in the json):

| Move | Kind | Flows | In the game | Game file and id | GrappleMap (for near / lack) |
|---|---|---|---|---|---|
| Back Control | position | 30 | have | scripts/rules/GroundRules.gd POSITIONS back; BeltRoad POINTS back |  |
| Armbar | submission | 25 | have | scripts/rules/BeltRoad.gd SYLLABUS armbar_guard; scripts/rules/GroundRules.gd armbar_guard, armbar_mount |  |
| Mount | position | 25 | have | scripts/rules/GroundRules.gd POSITIONS mount; BeltRoad POINTS mount |  |
| Side Control | position | 25 | have | scripts/rules/GroundRules.gd POSITIONS side_control |  |
| Back Take | transition | 20 | have | scripts/rules/GroundRules.gd fhl_to_back, turtle_to_back, mount_to_back; scripts/rules/BeltRoad.gd SYLLABUS arm_drag_back |  |
| Underhook | control | 19 | have | scripts/rules/WrestleChains.gd TIES underhook |  |
| Kimura | submission | 16 | have | scripts/rules/BeltRoad.gd SYLLABUS kimura; scripts/rules/GroundRules.gd kimura_side, kimura_half |  |
| Closed Guard | position | 15 | have | scripts/rules/GroundRules.gd POSITIONS guard; scripts/rules/BeltRoad.gd SYLLABUS posture_closed_guard |  |
| Half Guard | position | 14 | have | scripts/rules/GroundRules.gd POSITIONS half_guard |  |
| Front Headlock | control | 13 | have | scripts/rules/GroundRules.gd POSITIONS front_headlock; scripts/rules/WrestleChains.gd TIES front_headlock |  |
| Open Guard | position | 13 | near | scripts/rules/GroundRules.gd POSITIONS guard (one guard seat, no open-guard id) | yes: the untagged bottom_supine vs top_kneeling / combat_base positions (BjjMatch.classify note: 88 + 60) |
| Triangle | submission | 12 | have | scripts/rules/BeltRoad.gd SYLLABUS triangle; scripts/rules/GroundRules.gd triangle_guard |  |
| Turtle | position | 12 | have | scripts/rules/GroundRules.gd POSITIONS turtle |  |
| Knee On Belly | position | 11 | near | scripts/rules/BeltRoad.gd POINTS knee_on_belly (scores 2); no seat or move id | yes: tag knee_on_belly (6); 'knee on belly vs underhook', 'reverse knee on belly' |
| Heel Hook | submission | 10 | have | scripts/rules/BeltRoad.gd SYLLABUS outside_heel_hook, inside_heel_hook |  |
| Knee Cut Pass | pass | 10 | have | scripts/rules/BeltRoad.gd SYLLABUS knee_cut_pass |  |
| Kneebar | submission | 10 | have | scripts/rules/BeltRoad.gd SYLLABUS kneebar |  |
| Single Leg | takedown | 10 | have | scripts/rules/GroundRules.gd single_leg; scripts/rules/WrestleChains.gd ANSWERS Snatch single |  |
| Americana | submission | 9 | have | scripts/rules/BeltRoad.gd SYLLABUS americana |  |
| Rear Naked Choke | submission | 9 | have | scripts/rules/BeltRoad.gd SYLLABUS rear_naked_choke; scripts/rules/GroundRules.gd rnc_back |  |
| Standing | position | 9 | have | scripts/rules/GroundRules.gd POSITIONS standing |  |
| Arm Drag | transition | 8 | have | scripts/rules/BeltRoad.gd SYLLABUS arm_drag_back; scripts/rules/WrestleChains.gd ANSWERS Arm drag |  |
| Guillotine | submission | 8 | have | scripts/rules/BeltRoad.gd SYLLABUS guillotine; scripts/rules/GroundRules.gd guillotine_guard; scripts/rules/WrestleChains.gd ANSWERS Guillotine |  |
| Seatbelt Grip | control | 8 | near | scripts/rules/BjjSteps.gd STEPS rear_naked_choke / arm_drag_back cues; scripts/rules/BeltRoad.gd SYLLABUS seatbelt_escape | yes: tag seatbelt (18); 'mounted turtle w/ seatbelt', 'turtle w/ seatbelt and near hook' |
| Ankle Pick | takedown | 7 | lack |  | yes: tag ankle_pick (18); 'collar tie ankle pick from knee', 'double ankle pick' |
| Collar Tie | control | 7 | have | scripts/rules/WrestleChains.gd TIES collar_tie |  |
| Knee Shield | defence | 7 | near | scripts/rules/BjjSteps.gd STEPS k_guard / counter_pass cue | yes: tag knee_shield (3); 'recover knee shield' |
| D'Arce Choke | submission | 5 | have | scripts/rules/BeltRoad.gd SYLLABUS darce |  |
| Leg Drag | pass | 5 | have | scripts/rules/BeltRoad.gd SYLLABUS leg_drag |  |
| Omoplata | submission | 5 | have | scripts/rules/BjjSteps.gd STEPS / scripts/rules/BjjFilm.gd FILM omoplata (off the syllabus) |  |
| Single Leg X | position | 5 | have | scripts/rules/BeltRoad.gd SYLLABUS single_leg_x |  |
| Toreando Pass | pass | 5 | have | scripts/rules/BeltRoad.gd SYLLABUS bullfighter_pass |  |
| Truck | position | 5 | lack |  | yes: tag truck (2); 'truck', 'to truck', 'calf crank from truck' |
| Body Triangle | control | 4 | lack |  | no: no body-triangle position or transition |
| Bridge | escape | 4 | have | scripts/rules/BeltRoad.gd SYLLABUS shrimp_bridge; scripts/rules/GroundRules.gd escape_mount |  |
| Butterfly Hook | control | 4 | near | scripts/rules/BjjSteps.gd STEPS butterfly_sweep cue (hooks inside the thighs) | yes: tag butterfly (37); 'removing butterfly hooks' |
| Crucifix | position | 4 | have | scripts/rules/BeltRoad.gd SYLLABUS crucifix |  |
| De La Riva | position | 4 | have | scripts/rules/BeltRoad.gd SYLLABUS de_la_riva |  |
| Dogfight | position | 4 | lack |  | yes: tag dogfight (6); 'power dogfight', 'dogfight w/ double unders' |
| Gable Grip | control | 4 | near | scripts/rules/BjjSteps.gd STEPS anaconda cue | no: grips are barely modelled (GrappleMap's own FAQ) |
| Half Butterfly | position | 4 | lack |  | no: no half-butterfly title |
| Headquarters | position | 4 | lack |  | partial: no HQ title; tag combat_base (25) is the nearest kneeling passer stance |
| Hip Escape | escape | 4 | have | scripts/rules/BeltRoad.gd SYLLABUS shrimp_bridge; scripts/rules/GroundRules.gd shrimp_side |  |
| North-South | position | 4 | near | scripts/rules/BeltRoad.gd SYLLABUS north_south_choke (scripts/rules/BjjFilm.gd FILM 'to north/south'); no seat id | yes: tag north_south (6); 'north/south kimura', 'north/south darce' |
| Overhook | control | 4 | near | scripts/rules/BjjSteps.gd STEPS butterfly_sweep cue | yes: tags overhook / top_overhook / bottom_overhook (36) |
| S-Mount | position | 4 | lack |  | yes: tag s_mount (2); 'to S-mount', 's-mount w/ isolated arm' |
| Sprawl | defence | 4 | near | scripts/rules/GroundRules.gd shot_fhl; scripts/rules/WrestleChains.gd reaction 'sprawls back' | yes: tag sprawl (13); 'sprawl vs turtle w/ single' |
| Wrist Control | control | 4 | have | scripts/rules/WrestleChains.gd TIES wrist_control |  |
| 50/50 | position | 3 | near | scripts/rules/BjjFilm.gd FILM inside_heel_hook films 'to 50/50' | yes: tag 50_50 (5); 'to 50/50', '50/50 heel hook' |
| Anaconda Choke | submission | 3 | have | scripts/rules/BeltRoad.gd SYLLABUS anaconda |  |
| Arm Triangle | submission | 3 | near | scripts/rules/BjjFilm.gd FILM anaconda films GrappleMap tag arm_triangle | yes: tag arm_triangle (6); 'side control arm triangle', 'mounted arm triangle' |
| Back Triangle | submission | 3 | have | scripts/rules/BeltRoad.gd SYLLABUS back_triangle |  |
| Banana Split | submission | 3 | lack |  | no: truck positions exist, no banana split |
| Body Lock (standing) | control | 3 | have | scripts/rules/WrestleChains.gd ANSWERS Bodylock; scripts/rules/GroundRules.gd body_lock_trip |  |
| Butterfly Guard | position | 3 | near | scripts/rules/BeltRoad.gd SYLLABUS butterfly_sweep (the sweep only) | yes: tag butterfly (37) |
| Chest-to-Chest Pin | control | 3 | lack |  | partial: 'chest pass'; double-unders side-control positions |
| Elbow Escape | escape | 3 | near | scripts/rules/BeltRoad.gd SYLLABUS frame_recover_guard; scripts/rules/GroundRules.gd escape_mount | yes: 'open elbow escape' (2 transitions); 'shrimp escape' already films shrimp_bridge |
| Granby Roll | escape | 3 | lack |  | yes: 'granby to back' (1 transition) |
| Guard Pull | guard_pull | 3 | lack |  | yes: tag guard_pull (7); 'pull guard' (4 transitions) |
| Guard Retention | escape | 3 | have | scripts/rules/BeltRoad.gd SYLLABUS frame_recover_guard, counter_pass |  |
| Inverted Armbar | submission | 3 | lack |  | no: none |
| Isolate Arm | control | 3 | lack |  | yes: 'top isolates near arm', 's-mount w/ isolated arm' |
| Knee Tap | takedown | 3 | have | scripts/rules/WrestleChains.gd ANSWERS Knee tap |  |
| Leg Over Head | control | 3 | lack |  | yes: 'leg over head' (spiderweb) |
| Pendulum Sweep | sweep | 3 | lack |  | yes: 'pendulum sweep start', 'halfway pendulum sweep' |
| Reverse Kesa Gatame | control | 3 | lack |  | no: none |
| Saddle | position | 3 | have | scripts/rules/BeltRoad.gd SYLLABUS saddle_entry |  |
| Scarf Hold | control | 3 | lack |  | yes: 'kuzure kesa gatame', 'scarf hold neck crank' |
| Straight Ankle Lock | submission | 3 | have | scripts/rules/BeltRoad.gd SYLLABUS straight_ankle_lock |  |
| Ankle Grip | control | 2 | lack |  | no: grips barely modelled |
| Arm Frame | defence | 2 | lack |  | partial: tag frame (26), not this frame by name |
| Armpit Grip | control | 2 | lack |  | no: grips barely modelled |
| Ashi Garami | position | 2 | near | scripts/rules/BjjSteps.gd STEPS straight_ankle_lock cue 1 | yes: 'ashi', 'double outside ashi', 'butterfly ashi' |
| Biceps Slicer | submission | 2 | lack |  | no: none (only 'bicep control' grips) |
| Brabo Choke | submission | 2 | lack |  | no: none |
| Butterfly Sweep | sweep | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS butterfly_sweep |  |
| Chair Sit | position | 2 | lack |  | yes: 'chair sit' (2 transitions, back) |
| Clinch | position | 2 | have | scripts/rules/GroundRules.gd POSITIONS clinch |  |
| Clock Choke | submission | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS clock_choke |  |
| Deep Half Guard | position | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS deep_half |  |
| Double Leg | takedown | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS double_leg; scripts/rules/GroundRules.gd double_leg |  |
| Double Trouble | control | 2 | lack |  | no: none |
| Down Block | defence | 2 | lack |  | no: none |
| Feet on Hips | position | 2 | lack |  | yes: 'bottom puts feet on hips' |
| Foot Stomp | transition | 2 | lack |  | no: none |
| Foot Sweep | takedown | 2 | near | scripts/rules/WrestleChains.gd ANSWERS Foot block | partial: tag ashi_waza (5) is judo's foot throws; BjjFilm already rejected one as the wrong film |
| Frame | defence | 2 | near | scripts/rules/BeltRoad.gd SYLLABUS frame_recover_guard | yes: tag frame (26) |
| Gift Wrap | transition | 2 | lack |  | no: none |
| Grip Break | defence | 2 | lack |  | no: grips barely modelled |
| Head Escape | escape | 2 | lack |  | no: none |
| High Leg (Lasso) Guard Recovery | escape | 2 | lack |  | partial: 'recovering guard', 'bottom recovers'; the lasso itself is a gi grip |
| High Mount | position | 2 | near | scripts/rules/BjjSteps.gd STEPS mounted_triangle cue 1 | yes: 'high mount w/ one arm trapped' |
| High Single Leg | takedown | 2 | near | scripts/rules/GroundRules.gd single_leg | yes: 'high single w/ head on chest' |
| Kimura Defence | defence | 2 | lack |  | no: none |
| Kimura Grip Break | defence | 2 | lack |  | no: none |
| Lat Grip | control | 2 | lack |  | yes: 'side ctrl w/ lat trap' |
| Leg Weave Pass | pass | 2 | lack |  | no: only 'leg weave takedown' |
| Long Step Pass | pass | 2 | lack |  | no: none |
| Mounted Triangle | submission | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS mounted_triangle |  |
| North-South Choke | submission | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS north_south_choke |  |
| Peruvian Necktie | submission | 2 | lack |  | no: none |
| Pressure Pass | pass | 2 | near | scripts/rules/GroundRules.gd pass_to_side (no named pass) | partial: many unnamed passes, none called a pressure pass |
| Rear Body Lock | control | 2 | near | scripts/rules/WrestleChains.gd ANSWERS Slide by -> 'Bodylock go-behind' (a finish, no tie of its own) | yes: 'standing behind w/ body lock', 'turtle body lock' |
| Reverse De La Riva | position | 2 | lack |  | yes: 'standing vs reverse dlr', 'defeat rdlr' |
| Reverse X | position | 2 | lack |  | no: none |
| Russian Tie | control | 2 | have | scripts/rules/WrestleChains.gd TIES russian_tie |  |
| Scramble | transition | 2 | lack |  | auto |
| Seated Guard | position | 2 | lack |  | yes: tag bottom_seated (44) |
| Shin to Shin | control | 2 | lack |  | no: none |
| Snap Down | transition | 2 | have | scripts/rules/WrestleChains.gd ANSWERS Snapdown; scripts/rules/GroundRules.gd snapdown |  |
| Spinning Armbar | submission | 2 | lack |  | no: none |
| Stack Pass | pass | 2 | lack |  | yes: tag stacked (6); 'stacked double under pass' |
| Standing Back Control | position | 2 | near | scripts/rules/WrestleChains.gd ANSWERS go-behind finishes (Duck under, Arm drag, Throw-by) | yes: 'standing behind w/ body lock' |
| Straight Jacket | control | 2 | lack |  | no: none |
| Toe Hold | submission | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS toe_hold |  |
| Twister | submission | 2 | lack |  | yes: tag twister_side (8); 'twister side control', 'twister roll start' |
| Whizzer | control | 2 | lack |  | yes: tag whizzer (11); 'standing w/ whizzer' |
| Wrestle Up | transition | 2 | have | scripts/rules/BeltRoad.gd SYLLABUS wrestle_up |  |
| Wristlock | submission | 2 | lack |  | no: only 'get double wrist lock' (a kimura grip) |
| X Guard | position | 2 | lack |  | yes: tag x_guard (7); 'x-guard push sweep start' |
| X Pass | pass | 2 | lack |  | yes: 'x-pass' (4 transitions) |
| Z Guard | position | 2 | lack |  | yes: tag z_guard (7); 'z guard toe hold threat' |

**Gi-only, set aside** (32): Bow and Arrow Choke (5), Lapel Grip (5), Ezekiel Choke (4), Collar Choke (3), Cross Collar Choke (3), Pant Grip (3), Sleeve Grip (3), Collar Grip (2), Double Collar Tie (2), Lapel Choke (2), Loop Choke (2), Tripod Sweep (2), Assassin Canto (1), Assassin Choke (1), Back Fall Takedown (1), Belt Grip Break (1), Blast Double (1), Collar-Grab Posture Retention (1), Cross Choke (1), Cross Collar Grip (1), Cross Sleeve Control (1), Double Sleeve Grip (1), Gi Handcuff (1), Grip Strip (1), Lapel Grip and Leg Insert (1), Paper Cutter Choke (1), Punch Choke (1), Reverse Assassin Choke (1), Single Wing Choke (1), Sleeve Grip Armbar (1), Sleeve Grip Defence (1), Stray Jacket (1).

**Generic labels, left out of the counts:** Top Control, Takedown, Guard Pass, Shot, Bottom Position, Guard Bottom, Guard Top, Leg Attack, Leg Lock, Reset, Sweep (generic), Taken Down, Top Game, Armlock, Handfight, Non-Choking Side, Standing Opponent.

## 2. What the game has and what it lacks

Where the game keeps its grappling (read S379 on `main`):

| File | What it holds | Ids |
|---|---|---|
| `scripts/rules/BeltRoad.gd` `SYLLABUS` | the no-gi belt syllabus, 42 moves in 12 groups, white to brown | shrimp_bridge, frame_recover_guard, seatbelt_escape, posture_closed_guard, bullfighter_pass, knee_cut_pass, scissor_sweep, hip_bump_sweep, double_leg, armbar_guard, kimura, americana, rear_naked_choke, guillotine; de_la_riva, single_leg_x, deep_half, butterfly_sweep, over_under_pass, leg_drag, arm_drag_back, berimbolo, triangle, straight_ankle_lock, darce; k_guard, waiter_sweep, body_lock_pass, outside_heel_hook, kneebar, toe_hold, anaconda, north_south_choke, back_triangle; inside_heel_hook, saddle_entry, calf_slicer, crucifix, mounted_triangle, counter_pass, wrestle_up, clock_choke |
| `BeltRoad.gd` `POINTS` | IBJJF points | mount 4, back 4, pass 3, takedown 2, sweep 2, knee_on_belly 2 |
| `scripts/rules/GroundRules.gd` `POSITIONS` / `MOVES` | the ground fight on paper: 9 seats, 30 moves | standing, clinch, front_headlock, turtle, guard, half_guard, side_control, mount, back; double_leg, single_leg, body_lock_trip, snapdown, fhl_to_back, turtle_to_back, stand_turtle, pass_half, pass_to_side, sweep_guard, armbar_guard, triangle_guard, guillotine_guard, side_to_mount, kimura_side, kimura_half, shrimp_side, mount_to_back, armbar_mount, escape_mount, rnc_back, esc_back, ... |
| `scripts/rules/WrestleChains.gd` `TIES` / `ANSWERS` | six standing tie-ups, the answer picked by the reaction | collar_tie, underhook, wrist_control, two_on_one, russian_tie, front_headlock; Snapdown, Duck under, Slide by, Snatch single, Arm drag, Throw-by, Bodylock, Knee tap, Gator roll, Guillotine, ... |
| `scripts/rules/BjjSteps.gd` `STEPS` | 4-6 coach cues per syllabus move, plus omoplata | the syllabus ids |
| `scripts/rules/BjjFilm.gd` `FILM` | the GrappleMap sequence that films each move | 37 ids; americana, clock_choke, waiter_sweep, k_guard, over_under_pass, scissor_sweep unfilmed |
| `scripts/rules/NoGi.gd` | the week on the mat: one move drilled (`f["drill"]` coach / open / fav / move:<id>), `SUBS` for the opens | 17 submission ids |
| `scripts/rules/BjjMatch.gd` | the belt match on the GrappleMap graph | **branch claude/bjjmatch1 only, not merged**; its `TAG_SYLLABUS` maps 16 GrappleMap tags to syllabus ids |

**Near** (the game covers it inside a wider id or a cue, with no id of its own): Open Guard (13), Knee On Belly (11), Seatbelt Grip (8), Knee Shield (7), Butterfly Hook (4), Gable Grip (4), North-South (4), Overhook (4), Sprawl (4), 50/50 (3), Arm Triangle (3), Butterfly Guard (3), Elbow Escape (3), Ashi Garami (2), Foot Sweep (2), Frame (2), High Mount (2), High Single Leg (2), Pressure Pass (2), Rear Body Lock (2), Standing Back Control (2); plus 29 near moves used by one flow (mostly armbar, kimura and back-escape variants).

**GrappleMap for what we lack.** GrappleMap (public domain, `assets/grapplemap/GrappleMap.txt`, already read by `GrappleMapDB.gd`) was searched by tag and title for every missing or near move used by 2+ flows. 'yes' means a position or transition exists, so the move can be animated from public-domain data the way `BjjFilm` already does; 'no' means it would need keyframes made by hand or another source. Of the 51 missing moves used by 2+ flows, GrappleMap has 21, has something close for 4, and has nothing for 25 (mostly grips and fine details, which its FAQ says it barely models); 'scramble' is left unchecked, as it names a situation, not one move.

### The 10 most useful moves we lack

Ranked by how many flows use them; when the count is tied, the one GrappleMap can film comes first.

| # | Move | Flows | GrappleMap | Why it matters in our game |
|---|---|---|---|---|
| 1 | Knee On Belly | 11 | yes | scores 2 in BeltRoad.POINTS but no move or seat reaches it; 4 flows go side control -> knee on belly |
| 2 | Ankle Pick | 7 | yes | the no-gi takedown after the double/single; fits the WrestleChains collar-tie and underhook answers |
| 3 | Truck | 5 | yes | the turtle/back hub the brown-belt calf_slicer cue already names; twister and banana split come off it |
| 4 | Dogfight | 4 | yes | the half-guard bottom's way to the back and to wrestle_up |
| 5 | S-Mount | 4 | yes | the mount -> armbar bridge (mount > s-mount > armbar in 2 flows) |
| 6 | Body Triangle | 4 | no | how no-gi holds the back (3 flows: back > body triangle) |
| 7 | Headquarters | 4 | partial | the stance every open-guard pass starts from (smash, knee cut, half butterfly passes) |
| 8 | Half Butterfly | 4 | no | a guard 4 flows build on (inverted armbar, half guillotine sweep, saddle entry) |
| 9 | Guard Pull | 3 | yes | how most no-gi opens start on the mat; standing -> closed guard |
| 10 | Pendulum Sweep | 3 | yes | the second closed-guard sweep (also called the flower sweep); scissor sweep has no film |

Close behind (3 flows): Granby Roll, Scarf Hold, Isolate Arm and Leg Over Head (GrappleMap yes); Chest-to-Chest Pin (partial); Inverted Armbar, Reverse Kesa Gatame and Banana Split (GrappleMap no).

## 3. The 15 most-used chains, in our own words

Support = the flows that use the chain, counting longer chains that contain it. A gi chain (bow and arrow from the back, 4) is left out.

| # | Chain | Support | Our line | In the game |
|---|---|---|---|---|
| 1 | Back Control -> Rear Naked Choke | 7 | On the back with the hooks in: arm under the chin, squeeze. | have: GroundRules rnc_back; BeltRoad rear_naked_choke |
| 2 | Front Headlock -> Back Take | 6 | Keep the head down, spin off it and climb onto the back. | have: GroundRules fhl_to_back |
| 3 | Mount -> Armbar | 6 | From mount, an arm that pushes gets stepped over and straightened. | have: GroundRules armbar_mount |
| 4 | Front Headlock -> Guillotine | 5 | Head under the arm: wrap the neck and choke from the front. | have: WrestleChains front_headlock 'lifts her head' -> Guillotine; BeltRoad guillotine |
| 5 | Side Control -> Knee On Belly | 5 | From side control, come up and drive a knee into the belly for two points. | lack: BeltRoad POINTS knee_on_belly scores it; no move reaches it |
| 6 | Side Control -> Mount | 4 | From side control, slide the knee over the hips and sit in mount. | have: GroundRules side_to_mount |
| 7 | Front Headlock -> D'Arce Choke | 4 | From the front headlock, thread an arm under the arm and neck and lock the D'Arce. | near: BeltRoad darce; no front_headlock -> darce edge |
| 8 | Triangle -> Armbar | 4 | A triangle that will not finish turns into an armbar on the arm already trapped. | near: both moves exist, no link between them |
| 9 | Arm Drag -> Back Control | 4 | Pull the arm across, step to the side, take the back. | have: BeltRoad arm_drag_back |
| 10 | Rear Body Lock -> Back Take | 4 | Lock the hands around the waist from behind, bring them down and stay on the back. | near: WrestleChains Slide by ends in a bodylock go-behind; no ground back take from it |
| 11 | Saddle -> Heel Hook | 4 | With the legs tied up in the saddle, hide the heel and turn it. | have: BeltRoad saddle_entry -> inside_heel_hook (BjjSteps cue 1) |
| 12 | Single Leg X -> Heel Hook | 4 | From single leg X, expose the heel and attack it. | near: BeltRoad single_leg_x and outside_heel_hook, no link |
| 13 | Side Control -> North-South | 4 | Walk around the head into north-south for the choke and the arms. | lack: no north-south seat; north_south_choke exists |
| 14 | Back Control -> Armbar | 3 | When the neck is shut on the back, change to an arm. | near: armbar exists only from guard and mount |
| 15 | Back Control -> Body Triangle | 3 | Lock the legs in a triangle around the waist to keep the back. | lack: no body triangle |

Runners-up (support 3): half guard -> heel hook, half guard -> kneebar, standing -> front headlock, closed guard -> armbar, closed guard -> triangle, closed guard -> open guard, side control -> kimura. 7 of the fifteen already play in the game as a move from that position. 5 need only a LINK between things we have (front headlock -> D'Arce, triangle -> armbar, rear body lock -> back take, SLX -> heel hook, back -> armbar). 3 need a new position or move (knee on belly, north-south, body triangle).

## 4. Six premade BJJ training plans

**The shape.** A plan row mirrors PlanTemplates.WRESTLING ({id, name, from, idea, arrows}) with the BJJ fields the game already uses: 'moves' are BeltRoad.SYLLABUS ids drilled in order through NoGi f['drill'] = 'move:<id>' (NoGi.drilling_for, one move a week, DRILL_GAIN 3.2), 'chains' are rows like OwnCombos f['book'] ({name, chain}) whose steps are game ids (GroundRules.POSITIONS, BeltRoad.SYLLABUS, WrestleChains.TIES), and 'add' lists ids the game does not have yet.

Two rules in today's code that a plan has to live with:
- **One move a week.** `NoGi.week` drills ONE move (`DRILL_GAIN` 3.2 a week at 3 classes) until it is owned (30) before the next, as a coach finishes a move. So a plan runs as a block: its moves in order, one per week, each held until owned. This keeps `NoGi.week` and its tests as they are. Splitting a week across moves, the way `Combos.drill` splits pad minutes, is the other choice; it would need new numbers.
- **Belt gating.** `NoGi.drilling_for` accepts `move:<id>` only for a move in her belt's syllabus (`BeltRoad.moves_for`). A plan for a white belt therefore drills only its white-belt moves, and its higher-belt moves show as 'from blue' and so on. The `belts` field below says which belt each move belongs to.

### White belt fundamentals (`bjj_fundamentals`, from white belt)

Idea: Survive underneath first, then one takedown, one pin and one finish.

- Moves, drilled in order: `shrimp_bridge` (white), `frame_recover_guard` (white), `posture_closed_guard` (white), `double_leg` (white), `kimura` (white), `rear_naked_choke` (white).
- Chain 'Get out from under': `side_control` -> `shrimp_bridge` -> `frame_recover_guard` -> `guard`
- Chain 'Takedown to the pin': `standing` -> `double_leg` -> `side_control` -> `mount`
- Chain 'Finish from the back': `back` -> `rear_naked_choke`
- To add: nothing; every id exists today.

### Closed guard week (`bjj_closed_guard`, from white belt)

Idea: From the back: break the posture, then the arm, the neck or the sweep - whichever the top gives.

- Moves, drilled in order: `hip_bump_sweep` (white), `scissor_sweep` (white), `armbar_guard` (white), `kimura` (white), `triangle` (blue). Unfilmed today: scissor_sweep (steps only, no film).
- Chain 'Pull and attack': `standing` -> `guard_pull` (add) -> `guard` -> `armbar_guard`
- Chain 'Arm or neck': `guard` -> `triangle` -> `armbar_guard`
- Chain 'Sweep to mount': `guard` -> `hip_bump_sweep` -> `mount`
- Chain 'The other sweep': `guard` -> `pendulum_sweep` (add) -> `mount`
- To add: `guard_pull`, `pendulum_sweep`

### Passing week (`bjj_passing`, from white belt)

Idea: Get around the legs or through them, then climb: pass, knee on belly, mount.

- Moves, drilled in order: `bullfighter_pass` (white), `knee_cut_pass` (white), `leg_drag` (blue), `over_under_pass` (blue), `body_lock_pass` (purple). Unfilmed today: over_under_pass (steps only, no film).
- Chain 'Around the legs': `guard` -> `bullfighter_pass` -> `leg_drag` -> `x_pass` (add) -> `knee_cut_pass`
- Chain 'Through half guard': `half_guard` -> `body_lock_pass` -> `knee_cut_pass` -> `side_control`
- Chain 'Pass, then climb': `knee_cut_pass` -> `side_control` -> `knee_on_belly` (add) -> `mount`
- To add: `knee_on_belly`, `x_pass`

### Back-take week (`bjj_back_take`, from blue belt)

Idea: Every road to the back: the drag, the front headlock and the turtle - then hold it and choke.

- Moves, drilled in order: `arm_drag_back` (blue), `rear_naked_choke` (white), `darce` (blue), `back_triangle` (purple), `crucifix` (brown).
- Chain 'Drag to the back': `standing` -> `arm_drag_back` -> `back` -> `rear_naked_choke`
- Chain 'Head first': `front_headlock` -> `back` -> `rear_naked_choke`
- Chain 'Turtle to the back': `turtle` -> `back` -> `body_triangle` (add)
- Chain 'Neck shut, legs in': `back` -> `back_triangle`
- To add: `body_triangle`

### Leg-lock week (`bjj_leg_locks`, from blue belt)

Idea: Tie up one leg, then the foot, the heel or the knee - the saddle is home.

- Moves, drilled in order: `single_leg_x` (blue), `straight_ankle_lock` (blue), `outside_heel_hook` (purple), `saddle_entry` (brown), `inside_heel_hook` (brown), `kneebar` (purple).
- Chain 'SLX to the foot': `single_leg_x` -> `straight_ankle_lock`
- Chain 'SLX to the heel': `single_leg_x` -> `outside_heel_hook`
- Chain 'Saddle heel hook': `saddle_entry` -> `inside_heel_hook`
- Chain 'Half guard to the knee': `half_guard` -> `kneebar`
- To add: nothing; every id exists today.

### Competition prep week (`bjj_comp_prep`, from white belt)

Idea: Score first (takedown 2, sweep 2, pass 3, knee on belly 2, mount 4), and keep a choke ready on a bad shot.

- Moves, drilled in order: `double_leg` (white), `guillotine` (white), `hip_bump_sweep` (white), `knee_cut_pass` (white), `kimura` (white).
- Chain 'Stuffed shot, take the head': `standing` -> `front_headlock` -> `guillotine`
- Chain 'Points ladder': `knee_cut_pass` -> `side_control` -> `knee_on_belly` (add) -> `mount`
- Chain 'Sweep and score': `guard` -> `hip_bump_sweep` -> `mount`
- Chain 'Start on the feet': `standing` -> `ankle_pick` (add) -> `side_control`
- To add: `knee_on_belly`, `ankle_pick`

As data, the first plan reads like this (the rest are in the json under `plans`):

```gdscript
{"id": "bjj_fundamentals", "name": "White belt fundamentals", "belt": "white", "from": "GrappleFlows community flows S379 (counts only)",
	"idea": "Survive underneath first, then one takedown, one pin and one finish.",
	"moves": ["shrimp_bridge", "frame_recover_guard", "posture_closed_guard", "double_leg", "kimura", "rear_naked_choke"],
	"chains": [{"name": "Get out from under", "chain": ["side_control", "shrimp_bridge", "frame_recover_guard", "guard"]}, {"name": "Takedown to the pin", "chain": ["standing", "double_leg", "side_control", "mount"]}, {"name": "Finish from the back", "chain": ["back", "rear_naked_choke"]}],
	"add": []}
```

## 5. What building it would take (not started)

1. **Knee on belly and north-south as seats** in `GroundRules.POSITIONS`, with moves side_control -> knee_on_belly (2 points, already in `BeltRoad.POINTS`) and side_control -> north_south. Both are in GrappleMap (tags knee_on_belly 6, north_south 6), so `BjjFilm` can film them like the rest.
2. **The links the chains need between things we have**: front_headlock -> darce / anaconda, triangle -> armbar_guard, single_leg_x -> outside_heel_hook, back -> an armbar, and the WrestleChains bodylock go-behind -> back. These are edges, not new moves.
3. **A BJJ plan file** (for example `scripts/rules/BjjPlans.gd`, pure static, the six rows above), read by the Playbook mat book: pick a plan and her `f["drill"]` walks its moves in order.
4. **New moves in the order of section 2**, starting with the GrappleMap 'yes' ones (ankle pick, truck, dogfight, S-mount, guard pull, pendulum sweep); body triangle and half butterfly need keyframes from another source.

Checked S379: the GrappleMap counts come from our own decode of `assets/grapplemap/GrappleMap.txt` (2,086 sequences = 601 positions + 1,485 transitions, the S334 numbers). The game ids come from reading the files named above on `main` at 1f00821f.

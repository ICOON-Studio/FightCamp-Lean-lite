# THE TRAINING FLOOR - a gym->training loop you watch, understand and want to repeat
Claude, 2026-09-26 (operator request after S82: "find pictures/schematics of real gyms, check manager/sim games, invent a
way to make gym training fit the game and be addictive not boring, easy to understand, features we do not have, where is
the trainer in the scene, how stats show on every change, more in-game assets than still images with pointers").
Evidence: G112_TRAINING_LOOP.md (real gyms + 13 sim games, sourced), G110 (rooms), G109 (live counts), J16 (floor plans:
copyright - hand-author, never trace), G88 (crowding), R146 (equipment/training audit), C208 (3 live fighters = 5.8 ms a
frame), C210 + C212 (training motion sources; Mixamo audition running), S81 surveys (Punch Club 2, Cage Legacy) and a
played survey of MMA Career Simulator Demo (below). Concept picture: `training_loop/concept_training_floor.jpg` - a
CONCEPT, not a render of our game.

## What would a human do?
A head coach does not look at a spreadsheet to know his gym is working. He stands at the ring holding mitts for the one
fighter who matters today, the round clock on the wall runs everyone in 3-minute rounds, he walks the bag line between
rounds and barks at sloppy work, and he knows a man improved because the combination came back sharper today than last
week (G112 §a: Roach on mitts all day at Wild Card; Cordeiro walking the pairs at Kings). A game designer makes a
repeated action rewarding by landing the reward in the same moment as the visible work, batching it so it never spams,
and seeding a rare spike worth chasing (G112 §b, §3).

## Where we are today (the problem, measured in our own code)
- Training is a week planner board: one activity per fighter per day at a station (`TrainingHubPanel.gd`).
- The day runs off-screen. The drawer previews fatigue and body load (`BEFORE -> AFTER`) but **no stat change is ever
  shown**.
- Gains are fractions: `_apply_focus_stat_gains` (`GameState.gd:4730`) adds `0.6 x quality x condition x coach x
  headroom x crowd` - roughly 0.1-0.5 of a point per session. An integer display cannot show a day's work at all, so the
  player never sees training land. That is the core defect, and it is fixable without touching the balance.
- The live gym floor is a 2D grid (`GymHubPanel.gd`); HOME is a picture with pins (S82).

## MMA Career Simulator Demo (played 2026-09-26; Godot 4.4, 3,180 pack files, 38 scenes, low-poly 3D)
Play-as-the-fighter career. Menus sit on a 3D gym / cage backdrop; the fighter sits on a stool in the cage as the hub.
**Training is a spreadsheet**: 15 skills with +/- buttons spending skill points, plus Workout (-15 training points, +10
stamina), Sparring (-30, +25) and Weight cut (+10% success). Pressing them changes numbers only - no animation. Worth
taking: (1) **camp events with a risky choice** ("a pro is visiting - drop him in sparring for a viral clip?" -> -10
health), (2) a **fight-camp overview card** before the bout (overall 3 -> 3, hype, injuries, weight cut), (3) a
**pre-fight gameplan** panel of dropdowns (pace, striking focus, takedown anticipation, clinch). Its fight is real-time 3D
in a cage with health/stamina bars and speed controls. Sheet: `training_loop/mmacs_survey_sheet.jpg`.
**Verdict: it depicts the fight and never the training. Nobody in this genre shows the gym working - that is the gap.**


## OPERATOR DIRECTION, 2026-09-26 (after the first concept) - supersedes the ring-centred picture
Verbatim: *"there are very [few] things visible and you always build everything around the idea that there is a box
ring, maybe we can have a bigger gym with the real stations separated like in the real world gyms and can be scrollable
too and while you build that consider adding other things to it like the office door, exit to the city maybe etc"* and
*"maybe we can add few as presets? and expand the presets as gym grows?"*

So:
- **The gym is a big, zoned, scrollable place, not a room around a ring.** Zones separated like real gyms (AKA's
  discipline rooms, City Kickboxing's open plan, Fairtex's bag halls, G112 §1): STRIKING HALL (bag rows along the wall,
  banana bags, speed bags, pad lane, footwork grid), RING + CAGE, MAT ROOM (tatami, grappling dummies), STRENGTH &
  CONDITIONING (racks, dumbbells, bikes/rowers, sled track). The ring is one station among many; a grappling gym may not
  have one at all. Zone plan: `training_loop/gym_zone_plan.png` (48 x 20 m; the camera shows ~16 m and scrolls).
- **Doors are the navigation.** Along the front wall: ENTRANCE with the EXIT TO THE CITY (the world, events, other gyms),
  OFFICE (offers, contracts, finance), STAFF ROOM (hire, assign), LOCKER ROOMS (weigh-in scale), and the rooms you build
  (film room, kitchen, recovery suite - G110). A door is a way to another screen, the way Two Point's rooms are.
- **Presets that expand as the gym grows** (J16 route C: hand-authored layouts, never traced; the player places stations
  inside a preset's zones, the preset decides the shell):
  | Tier | Preset | Size | Zones and doors |
  |---|---|---|---|
  | 1 | Back-room club | ~12 x 10 m | one striking corner (2 bags, pad spot), a small mat, office desk in the corner, exit |
  | 2 | Boxing club / Muay Thai club | ~24 x 14 m | striking hall + ring, lockers, office, exit |
  | 3 | Fight academy | ~36 x 16 m | + mat room (and cage for MMA), staff room |
  | 4 | Fight team HQ | ~48 x 20 m | + strength & conditioning, doors for built rooms (film, kitchen, recovery) |
  | 5 | Elite campus | 60 m+, second floor | several halls by discipline, dorms, media office (G110) |
  Each tier comes in discipline flavours so the shell fits the gym: boxing (two rings, long bag hall), Muay Thai (rings +
  banana bags + pad lanes), grappling (mat room dominant, no ring), MMA (cage + mats + striking hall). Expanding keeps
  the player's stations where they were and opens the new wing - the growth moment is a wall coming down.
- **Floor colour marks the zones** as it does in the real gyms on the Pinterest board (red/black and blue/black mats,
  bag rows hung along a wall, the cage in a corner on mats), so zones read without walls between them.
- **Pinterest boards, 2026-09-26** (viewed in the operator's signed-in Chrome; nothing downloaded or traced - J16):
  the layouts that work are dollhouse isometric cutaways of a whole gym with side rooms (showers, lockers, office) in one
  picture; two rings side by side with a bag row on the back wall and a running track round the edge; the cage and a
  raised ring on red/black mats behind a rail. A second pattern everywhere: **the walls carry the gym's character** -
  murals, slogans ("discipline builds freedom"), fight posters, neon signs, a trophy wall. That is a feature we lack:
  **decor as a buildable layer** (posters of your own champions, the belts you won on the trophy wall, a mural once
  you can afford one) that raises member appeal and fighter morale and makes every gym look like its history.
- Second concept, drawn to the zone plan: `training_loop/concept_zoned_gym.jpg`.
- The cutaway view (walls cut away, several rooms visible at once) seen on that board is the target camera for the
  higher tiers.

## THE DESIGN

### 1. The floor is a 3D scene, not a picture with pointers
- The GYM FLOOR route (S81 decision) becomes our own 3D room: the stations the player owns on the floor grid are real
  props at their grid positions (ring, heavy bags, speed bag, mitt pad, weights, cardio, mats, dummy), laid out on the
  Gleason/AKA pattern G112 found: **ring as the stage, a bag bank along one wall, the mitt pocket beside the ring,
  weights/cardio on a side wall, mats and dummy opposite**. Hand-authored layouts per gym tier (J16 route C), never
  traced plans.
- A fixed three-quarter camera like Two Point Campus, with a short pan to a second wing when rooms are built (G110/G111):
  **rooms are doors off the floor**, which solves the HOME space problem - HOME keeps its picture and 4 pins; the floor
  holds the rooms.
- Every fighter stands at the station his week plan puts him on today and plays that station's loop. Performance budget
  is measured: C208 ran 3 live fighters at 5.8 ms a frame and 12 at 8.0 ms p95.

### 2. Where the trainer is, and what he does
- **The head coach stands in the mitt pocket beside the ring**, holding pads for today's *featured* fighter (the player
  picks one per day; default = the fighter with the nearest bout).
- Between rounds he **walks the floor** to the next station on a short loop and plays a correction gesture, with a one-line
  bark over the fighter ("hands up", "turn the hook over") drawn from the station and the fighter's weakest stat on it.
- **Assistant coaches** (staff) stand at the stations they are assigned to; an uncoached station shows a fighter working
  alone at lower gain - the player SEES why a coach matters.
- Two fighters booked into the ring the same day = **gym sparring**: the coach steps onto the apron as referee
  (feature 4d).

### 3. A training day is a session you can watch (or skip)
- Continue on a training day opens the floor and plays the day as **rounds under a diegetic wall clock**: 3:00 work /
  1:00 rest, the bell rings for everyone (real gym rhythm, G112 §1). One day = 4-6 rounds, ~60-90 s at 1x; 2x / 4x / skip
  always available, and "auto-skip days with nothing new" as a setting so it never becomes a chore.
- Watching is optional; the outcome is identical whether watched or skipped. The fight engine's pace rules are untouched.

### 4. Every change is shown, once, where it happened
- **Progress bars to the next point.** Each stat shows its fractional progress as a bar (hidden decimals stay in the
  sim). The day's gain is visible as bar growth even when the integer does not move.
- **Round-end float.** At each bell, one stacked label over each fighter at his station ("POWER ▮▮▮▯"), and when a bar
  crosses a whole point: a bigger "+1 POWER" with a short sound. Never per punch.
- **Day slate.** When the day ends: a locker-room card, one line per fighter, max 3 stats each + fatigue / injury flag.
  Same numbers as the floats, once.
- **Arrows on the profile for 7 days** (Football Manager model): green up / amber flat / red down beside every stat the
  week touched.
- **Weekly report** on Monday: a sparkline per fighter and one coach's note ("Rico's jab is two points sharper since he
  moved to the mitts").
- **Camp card before the bout** (from MMA Career Simulator): "Overall 61 -> 64 · what this camp built · what it missed".
- **Preview before committing** (Uma Musume): in the planner and when dragging a fighter onto a station, the expected
  gain per stat and the injury risk are shown on the station - the same formula as `_apply_focus_stat_gains`, run as a
  pure preview, so the preview is honest.

### 5. Features we do not have, that create the "one more day" pull
a. **Drill mastery I-V per fighter per station.** Hours at a station fill five pips under his name tag at that station.
   Each pip is a small permanent bonus; pip V unlocks something the fight can see - a named combination or a technique
   variant through the existing `technique_progress`. An almost-full pip at the end of the day is the reason to press
   Continue.
b. **Breakthrough sessions.** A rare day (target ~8-12% on a fresh drill with a good coach bond and low fatigue, G112 §4)
   where the station gets a gold ring on the floor, the gain doubles, the coach shouts, and the round is saved to the
   fighter's tape. Rare enough to chase, never scripted.
c. **Coach-fighter bond.** `CoachRapport.gd` already exists and is invisible on the floor. Show it as a bond meter on the
   pair; mitt days together build it; a high bond raises breakthrough odds and unlocks that coach's own mitt routine.
d. **Gym sparring days and rivalries.** Book two gym-mates into the ring: a 2-3 round light spar played by our own fight
   engine at training intensity, in 3D, in the gym. Winner gains a visible edge (composure/timing), the loser risks a
   bruise; repeated pairings become a named rivalry that shows up in the weekly report. Legal-fixture rules apply
   (same ruleset, never identical men, weight classes respected).
e. **The fatigue stake, shown on the body.** Per-body-region load already exists (R146) and so does the body map
   (`BodyMapFigure.gd`, S68). Show each fighter's loaded regions glowing on the floor overlay; pushing a fourth hard day
   before a camp peak is a visible gamble, not a hidden formula.
f. **Floor events with a choice** (from MMA Career Simulator and Two Point's comedy events): a visiting pro, a member
   filming a clip, a sparring partner no-show, a broken bag chain. One small decision, a visible consequence on the
   floor, at most one per few days.

### 6. Easy to understand
- **Drag a fighter chip onto a station** in the 3D floor to set today (the week planner stays for power users and copies
  a day across the week).
- **Tap a station**: who trains there, what it builds, its condition, the preview gain for the selected fighter.
- One colour language everywhere: green up, amber flat, red down, gold = breakthrough; the same as HOME's amber
  "needs you".

## What NOT to do (G112 §3, Punch Club 1/2 lessons)
- No +0.01 spam every tick; no identical animations for bag vs mitts vs mats; no stat that moves without a body doing the
  work; no nightly decay that steals yesterday; no six menus to learn that Power went up; no mandatory watching.

## The build, in slices (each shippable)
1. **Show the change, 2D first (cheap, no new art):** progress bars per stat, 7-day arrows on the profile, the day slate,
   the weekly report, preview gains in the planner, the camp card. Makes training legible immediately on the current
   screens.
2. **The floor in 3D:** the room with the player's stations as props, fighters idling at their stations, the wall clock,
   the coach in the mitt pocket, round-end floats. Needs station clips: bag, rope, speed bag, warm-up from the Mixamo
   audition (C212, running); mitts and weights need Cascadeur authoring (C210's recommendation).
3. **The pull:** drill mastery pips, breakthroughs, the coach bond, floor events.
4. **Gym sparring days** on the fight engine, and rooms as doors off the floor (G110 table).

## Decision for the operator
The recommended order is slice 1, then 2, then 3 and 4, with rooms (G110) folded into slice 4 rather than built as a
separate HOME feature. The alternative is to keep S83 as rooms / media hire / scouting file first and do this after.

## Rooms, expansion and the look (2026-09-26)
Published page with every room design, what-you-buy-is-what-you-see, growth presets and the render plan: https://claude.ai/artifact/EvCjFQjxSKjyMiRuUaDd5P . Room concepts in `training_loop/` (street, reception, office, staff, lockers, film, kitchen, recovery, dorms, media, tier1, tier2). Door rule: work with depth opens a SCREEN (city, office, hiring, film/scouting); quick checks open a POP-UP over the running floor (reception, assign coaches, lockers, kitchen, recovery, dorms, media).

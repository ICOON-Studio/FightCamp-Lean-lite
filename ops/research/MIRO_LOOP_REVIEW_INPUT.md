# The Miro loop board - review input (S351, 2026-11-02)

Board: https://miro.com/app/board/uXjVETf7la4=/ (private; this file describes it in full).
Purpose (operator): 'a real miro board with the ingame screens from menus/submenus/modals/tooltips, it should help us
see the big picture loop of what the player should expect.' The game: FightCamp, a boxing gym management sim (Godot,
Windows). The player runs a small boxing gym, trains a female amateur boxer week by week, books fights, watches them
in 3D, works the corner, grows the gym to a pro.

## Layout
- Title + one-line subtitle at the top.
- Frame 'The loop at a glance' (3400 x 1060): yellow nodes 1 Start a career -> 2 The week -(CONTINUE)-> Week review
  -(next week, curved back)-> 2 The week; 2 The week -(an offer arrives)-> 4 Booking and camp -(fight day)->
  5 Fight night -> Result and goal -(back to the week)-> 2 The week. Right column 'Any day, from the left menu':
  3 Playbook, 6 Run the gym, 7 The world, 8 Grow the gym, 9 Save, mail, settings (blue cards, no arrows).
- Beside it a frame 'PROPOSAL: your training blueprint in the game' (camp phases BUILD / SHARPEN / PEAK + BASE; a
  week of HARD / SKILL / ENGINE / REST day cards; effort and weight logs).
- Below, one frame per chapter, stacked top to bottom, each one row: a strip image of real 1920x1080 game screens
  shrunk to 640x360 each, 64 px apart, a caption card under each screen ('N. name' + one line), straight arrows
  caption to caption left to right. Frames are 764 px tall and 2,176 to 7,104 px wide (one row each).
- Style: white frames, black headline text, pale blue caption cards, yellow loop nodes, dark arrows.
- Known capture limits: screens rendered on an invisible desktop, so the Gear menu and the hover tooltip draw left of
  their control; three 3D fight stills come from the previous build (S350); the 2D corner screen and the 3D corner card
  both appear.

## The chapters and every screen (in order)
### 1  START A CAREER  (5 screens) - From the title to your first fighter and coach. Played once.
1. Title - New career, load, settings
2. New career - Pick a start: quick start opens a built gym
3. Home, day one - The gym is open; one thing needs you
4. Interview (modal) - Meet the boxer, pick her three week cards
5. Gym > Staff - Hire a coach: training runs at 60% without one

### 2  THE WEEK - THE CORE LOOP  (9 screens) - Plan her week, press CONTINUE, read the week review, plan again.
1. Home - What needs you this week; CONTINUE runs the days
2. Fighters > Training (NEW) - Her week as 8 sessions round her body; - / + sets each session's rounds
3. Tooltip: load - Harder = faster gains, more injury risk
4. Tooltip: more time - One more block on a session
5. Fighter page - Her stats, goal, record, next fight
6. Fighter > Coach notes - What the coach saw in her last fight
7. Fighter > Moves and combos - What she can throw, how sharp
8. Fighter > Record - Every bout, how it was won or lost
9. Week review (modal) - What training built; then the next week

### 3  PLAYBOOK  (4 screens) - Her moves, fight plans and combos, played on her own body.
1. Playbook > Moves - Walk her move map; a click plays the move
2. Playbook > Plans - Her fight plan as arrows on the map
3. Playbook > Combos - Build a combination, see if it flows
4. Playbook > Escapes - Ways out of the ropes and the corner

### 4  A FIGHT: BOOKING AND CAMP  (7 screens) - An offer arrives; accept, run a camp, make weight.
1. Fights > Offers - Offers for her; a mismatch is flagged
2. Bout page: unsafe - Why this one is a bad idea
3. Bout page - The opponent, the purse, accept or decline
4. Home, booked - The fight date on the plan
5. Fight camp (modal) - Camp focus, protocol, film study
6. Fighters > Fight camps - The camp running, days to the fight
7. Weigh-in (modal) - Make weight or pay for it

### 5  FIGHT NIGHT  (10 screens) - Watch the rounds, work the corner, live with the result.
1. Home, fight night - GO to the fight
2. Tale of the tape - The two fighters side by side
3. Round 1 (3D) - The settled round, watched
4. Shout bar - Call one change during the round
5. Tooltip: her body - Mouse on her liver: what landed there
6. Corner card - The minute: recover, talk, fix, the plan
7. Corner (2D) - Energy at the bell, the corner line
8. Round 3 - The last round
9. Result - The verdict, what it did to her
10. Goal talk (modal) - Set her next goal

### 6  RUN THE GYM  (5 screens) - Money in, money out, the place itself, the members.
1. Money > Deals - Sponsors and their terms
2. Money - Cash, this week in and out
3. Money > Bills - Rent, fees, staff
4. Gym > Facilities - Equipment and its condition
5. Gym > Members - Dues-paying members, who stays

### 7  THE WORLD  (5 screens) - The boxing world around the gym.
1. World > News - Results and stories
2. World > Rankings - Where she stands
3. Rival file (modal) - Any rival's file, any time
4. World > Events - Shows and championships
5. World > Search - Find anyone

### 8  GROW THE GYM  (8 screens) - Scout and sign a second fighter; turn the first one pro.
1. Fighters > Scouting - Prospects to invite
2. Trial (modal) - A week's trial, then sign
3. Fighters > Roster - Two fighters now
4. Training, two fighters - Each one's own week
5. Fighter > Moves - The new fighter's moves
6. Week review, two - Both fighters' week
7. Pro offer (modal) - Seven wins: the pro debut offer
8. Home, a pro - The gym with a pro fighter

### 9  SAVE, MAIL, SETTINGS  (3 screens) - The top bar's helpers.
1. Title: resume - Load the saved career
2. Mail - Messages for the gym
3. Gear menu - Save, load, settings, handbook, quit

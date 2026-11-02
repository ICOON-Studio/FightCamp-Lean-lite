# S176 DIGEST - BUYER1: the career as a chain of mornings + the finished-gym pass (2026-10-08)

Operator slice (verbatim brief in the session): "This session is the buyer piece. The empty morning, the interview,
and the one watched floor must look like a finished gym on a mid-to-high machine, captured from the gym's own camera."
Recorded next action (walk clip, hall video, OpenCode trial, review-part-1 fixes) left where it was, as asked.

## What now works (commit 011710f3, all behind gym3d_main = OFF for players)
- `CareerMorning.gd` + `assets/data/career_morning.json` - the rules: forcing from the booked bout (club debut ONE
  forced visit per camp, pro bout one per camp week, title the last 7 days with stops on blocks/meal/weigh-in, fight
  night never), skip only from the home morning, block choices send_on/rest/leave, stamina words
  fresh/working/spent/at_risk, strain (fills, never pays), sending on spent+strained = medical hold, the meal (25 back,
  8 skipped), the lived week -> none/moderate/aggressive, coach tags regional/film/pad_man (+15% bag+pads)/conditioner
  (x1.25 recovery at bike/treadmill/weights/rest, moves at 85%), hype floor/push +4/cool -3 never under the floor,
  Go Watch 80/40 minutes never finishing a move, film layers 1 (2 for the film coach) capped 3.
- GameState (end of file + `_advance_weight_cuts`): switch `career_mornings` (default = gym3d_main), `get_morning`,
  `skip_morning` (refused while a fighter is forced), `file_visit` (lived day, camp visit count, medical hold, then
  advance_day), `sign_from_interview` (3 distinct boxing cards on `program_cards`, favourite art stored, a non-boxing
  card refused), `hire_tagged_coach`; the lived week files the EXISTING week diet once at week end (`filed_diet`).
  TRAP met: `week_program` was already the 7-day plan array - mine is `program_cards`.
- GymHall3D: the Marpa boxing pack's ring fitted to 16 ft / deck 0.95 (licence assets/venues/LICENCES.md), rubber
  floor + brick walls from the ambientCG CC0 maps already in the repo, flyer posters drawn in-engine (no third-party
  art), debug floor marks / painted door words / zone tints / RoomFx's window shaft (a translucent slab on a wall with no
  window) hidden, wall lamps (the only glow), PhysicalSky reflections, rim-faded wear decals, `quality()` high/low
  (`-- gym_low` or headless = low). HUD: STAMINA + STRAIN bars, the word, one sentence (card + minutes owed); block stop
  panel (SEND HIM ON / REST / LEAVE + THE MEAL toggle, REST with the meal = the refuel service); home morning card
  (STEP IN / SKIP THE DAY, SKIP locked with the reason when forced); empty gym (no fighter row).
- NO NEW DOWNLOADS: every asset in the shots was already in the repo with its licence written (ambientCG CC0, Marpa
  Unity EULA, Kenney CC0, Tripo props). Nothing went in the scratchpad.

## Evidence
- `tests/career_mornings_path_test.gd`: 0 fails - empty career, coach tagged pad_man, Paulo Nakamura (male, LHW, 0-0,
  UK pool) signed with body_hook/cross/feint, quiet week = 7 skips, weight 84.0 held (filed none); club bout booked from
  get_amateur_bouts; camp forced=1 skipped=13; the visit's gains/stamina == DayLapSplice.run of its plan; skipped meal +
  400 bike minutes filed aggressive (84.0 -> 79.4 with the weigh-in); weights + meal filed none, weight held.
  Mutant heavy_cardio_minutes 90 -> 900: FAIL (the test can read worse).
- run_tests --only day_lap, daylap_splice, pit_stop (+corner_pit_stop), weight_cut (+g156), timeline (bar + clock),
  gym_hall (3d, layout, panel), first_fight_for_every, amateur_booking: all SUITE fails=0.
- Stills (opened, `-- as_game gym3d_main timeline_bar gym_is_menu`, 1920x1080, quality=high):
  `docs/previews/buyer1/01_empty_morning, 03_station_both_bars, 04_block_stop_meal_choices, 05_quiet_morning_skip,
  06_club_camp_morning`. NOT SENT to the operator - visible defects below.

## Defects seen on the stills (fix first next session, then send)
1. 01 empty morning shows the coach body by the ring though no coach is hired yet (layout places the coach always).
2. The wall sign reads "BOXING CLUB" (preset name), not the player's gym name - a stand-in label.
3. The fighter trains barefoot in white briefs with no gloves (the kit: trunks colour, boots, gloves) - not a boxer.
4. The rubber floor reads near-black even at tint 0.62 (the rubber albedo is dark): try the Concrete031 map sealed
   dark-grey, or a lighter rubber set; the wear decals read as smoke, make them smaller and directional.
5. Interview still not captured: no interview panel exists in the hall yet (sign_from_interview is the engine).

## Owed (named, not hidden)
- Interview panel (goals, art, strong/weak side, pay -> confirm the week) and the coach-hire panel with the four tags.
- Wire GymHall3D <-> GameState in the game: morning card from get_morning, STEP IN/SKIP -> skip_morning/ visit,
  visit_ended -> file_visit; offers -> film room lit on booking; hype push in the office; Go Watch activity.
- The coach tag effects are encoded (tag_effects) but not yet applied in DayLapSplice (pad_man 1.15 etc.).
- Week length targets are data only (not measured on a played week).
- Agent sweep: Arena MORNING1 (chat 01a11ba5) compiled Godot from source in its sandbox ~25 min, then "Something went
  wrong" - nothing pushed; CareerMorning written by Claude to the same brief. Next brief to Arena must say: do NOT build
  Godot; push the files and let us run the test.

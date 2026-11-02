# S276 DIGEST (2026-10-20) - the loop plays; nothing interrupts; build mode on the live floor; the gym becomes a Mad Games / Two Point game

## What now works (each on master, measured on the real route or tested)
- Collected: Arena FIGHTLINK2B c68cfd66 (drilled punch chosen more, stage 2), Cursor PLAYFIX275 r2 ffd39342 (11 attributes on the
  cards), Goose profile_overview e1207f5e. Goose re-tasked (#303 round 2), Cursor #305 ASGAMERED1 (8 as_game reds), Arena ATTRWIRE1
  corrected (40-bout test + 200-bout tool), Ziva ZIVATREMBLE1 resumed after the 19:15 freeze.
- Still gate 89a3ac23: CleanView.save_if_clean refuses a gym still with the Day Plan / a drawer / a pop-up (CLAUDE.md s2 rule).
- THE WEEK REPEATS 569c6ce6 + TARGET ROTATION 56c2a01e: each weekday keeps his plan; PLAN gold dot only on fight week / a knock /
  worn down; up to 3 targets rotate (the longest block moves to a station that trains today's target).
- Walking-but-not-moving FIXED 56c2a01e (probe: running=false at minute 0 for 40 s - the STEP IN hold).
- NOTHING INTERRUPTS bea70077 (switch no_interrupts, operator: "nothing interrupts everything that happens trigger an icon"): the day
  runs from entry and rolls over by itself; TODAY / FIGHT WEEK, DECISION, REPORT, WEEK, APPLICANT, PLAN dot icons; the first-gain 1x
  lock once per career (it re-locked every Mon/Tue). Probe tools/s276_loop_probe.gd: minute 0 -> 561, day 0 -> 1, no overlay.
- QUICK START + creation cut 7ed68220: title QUICK START = empty gym on the floor; New Career = country -> gym -> OPEN GYM; the
  preview no longer shows Mara (one rule for save + preview).
- Training page = the week the floor runs 2cbf65a6 (WeekPlanBoard: day cards, TRAINS, LIGHT/MEDIUM/HARD); the old page refused every
  work day without a coach. Gain bubbles x2.3. Station pop-up kept on screen.
- ROTATION 52c97cc8 + 7389642b: wheel-button drag / Q / E turn the free camera AND the near walls re-cut at every angle (stills
  previews/s276_rotate).
- BUILD MODE 29e313e3 (B / BUILD): start with nothing, SHOP of zones priced from the catalogue, place / drag / swap / R / Delete /
  Ctrl+Z, stations-kit-beams follow; stripped_start (hall empty but the ring). Probe tools/s276_build_probe.gd, stills
  previews/s276_build. The .exe was opened on the operator's second monitor at his request.

## The operator's direction (verbatim in research/GYMBUILD_PLAN_S276.md)
The gym becomes a Mad Games Tycoon 2 / Two Point game: an EMPTY walled building on its own plot (grass, street, trees), no rooms;
he draws every room (Build a Room menu with locked types), places every item from a palette sorted by room (icons + tooltips), people
walk in and train on what he built; decor from a catalogue (GYMDECOR1 queued to John, SQ9). Questioned in-session: "how ludo designed
it" -> the pre-Ludo BUYER1 holds were removed; "wtf am i doing wrong" -> the loop had never been played end to end (memory
feedback_play_the_loop_in_the_exe_s276).

## Open / next (in order)
1. GYMBUILD step A: the empty shell on an MGT2 plot (outer walls + door, grass/pavement/street/trees), no side rooms on a new career.
2. GYMBUILD step B: draw a room (walls + door generated, room types menu with locks, key item per room: office PC, physio bed,
   locker, reception desk).
3. GYMBUILD step C: item palette by room from equipment_catalog.json (95 priced items), item placement replaces zone kits on new
   careers, stations from placed items, grid pathing.
4. Fight half of the loop not yet played through in this build (fight week -> fight night -> result -> gym).
5. In flight: Ziva ZIVATREMBLE1, Arena ATTRWIRE1, Goose #303 r2, Cursor #305 ASGAMERED1, John SQ9 GYMDECOR1.

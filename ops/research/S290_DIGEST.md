# S290 DIGEST (2026-10-23) - gym floor playtest fixes, MGT2 timeline, tooltip cards

## Operator asks this session (verbatim)
- "when you done with orientation let me know so i can pipoint somethings to fix onthe gymfloor"
- "right click should deselect the current selection" · "the bag is tiny and too high" · "the quick bag has not where to hang
  from it has a different base" · "how do i remove items ?" · "this is a locker not mitts , wtf" · "your icons make no sense, why
  there swords icons in this game ?" · "make an option to automatically place everything to the gym for quick testing" · "i want to
  be able to see the hologram of the item i am placing to see there it is faced" · "the assets should not have background"
- "the quick start : is empty gym wtf ? the days pass by without me building anything and i see people coming in the gym wtf ?"
  · "this is not going to work like this if a day is 3-5 seconds and everything resets the game is unplayable you need to fix the
  time" · "i do not understand why everything has to reset every day ?" · "why you do not use the mgt2 timeline ?"
- "you need to make cooler tooltips , look for tutorials or other games that have been praised for their tooltips" · "you do not
  need to delegate all that you can make the research yourself and implement it" · "why its taking so long" · "new session ?"

## What now works (evidence)
1. 889c7cc8 GYM FLOOR: right-click (not a pan drag) deselects in BUILD and closes ring/card/pop-up on the floor
   (gym_build_input_test red->green); swords -> a boxing-glove icon (IconKit alias); BUILD FILL = the original gym whole, free
   (build_fill_all_test); placement HOLOGRAM = the piece's own model see-through at the cursor, blue/red, turning with R, a white
   ring where the member stands (BuildMode.piece_model); speed bag pouch x0.68 + 6 cm lower; double-end bag on a free-standing
   frame; the mitt station is a stand with focus mitts ("Focus-Mitt Stand"); BUILD thumbnails rendered alone, transparent.
2. FOUND BY THE HOLOGRAM (station_turn_test red->green, 6 FAIL on master): a turned dressed piece NEVER turned (node -yaw vs the
   move baking +yaw into dressing) and faced away from its member at 90/270; models now turn +yaw like their data, the move no
   longer bakes dressing; a 2nd shell copy kept the 1st one's work spot (rows rebased with the piece).
3. 743ccfc3 MGT2 TIMELINE: with nobody signed every day end ran GymHallPanel.rebuild() (the whole floor); now the day soft-rolls on
   the kept floor whoever is on the books. A shell is CLOSED (clock held, no walk-ins, GYM CLOSED note) until reception + one piece
   (GymHallPanel.gym_open). QUICK START builds the whole gym (BuildMode.fill_everything_on_career). gym_open_timeline_test red on
   master (155 min in 1.2 s, 16 visitors) -> 12/12. Live probe (real quick start route, 1x, 36 s): days 15.3 s, 0 floor rebuilds.
   His "3-5 s" was 3x (15 s at 1x, his Q-S277-7 number - unchanged).
4. 22e9bf8b TOOLTIP CARDS (research: Paradox EU5 diary on CK3 nested tooltips, CK3/Old World, Unity, Adobe Spectrum): TipLayer
   draws a brass/cream card - header (icon + title), body, stat rows green/red, key chips, 120 ms pop-in; Glossary terms are
   CONCEPT blue and open their own nested card (up to 4); BUILD tiles carry price/stock/space/trains/wall + Click/R/Drag/Del.
   tooltip_cards_test 17/17; 13 tooltip tests green plain arm.

## Stills (game camera, opened)
docs/previews/s290_floor (hologram, bags, mitt stand, turned treadmill, catalogue, thumbs sheet), s290_quickstart (built gym, date
ticking, visitors), s290_tooltips (tile card, term card + nested). Review board: "Gym floor fixes ..." (S290).

## Reds seen, NOT from this session (same on master)
bag_mount, reception_keeps_gym, floor_pick_station (game), combo_training (game hang), career_mornings_path, coach_day_drawer,
floor_gain_coach_day, day_attention, first_job_card, build_holds_clock plain arm; + the S289RED1 six (Cursor #344, still running).
Cursor #344 OWNS BuildMode.gd + GymClubLayout.gd, both edited here - collect by DIFF onto master, never whole files.

## Decided (developer calls)
- Models turn +yaw (the data's sense); dressing is node-local. - A closed shell has no clock; the day never rebuilds the floor.
- Tooltip spec keys: title, icon, text, rows [{label, value, tone, icon}], keys [[key, word]], value/delta, bar.

## Next
See roadmap now (S291).

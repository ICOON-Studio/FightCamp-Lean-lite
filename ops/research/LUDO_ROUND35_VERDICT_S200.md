# Ludo round 35 - verdict (S200, 2026-10-11)
Source: `research/LUDO_ROUND35_S200.txt` (verbatim; part 1 27,889 chars, Ludo stopped itself mid-table; part 2 28,876 chars after
"continue" + the operator's S200 ask "ask it also to place each UI item needed"). Asked on the overview still
`docs/previews/s199_for_ludo/01_ludo_overview.jpg`. A third ask (operator S200: "ask it also to generate a corrected preview with the ui")
is out - the image goes on the board beside these verdicts when it lands.

Each item below needs the operator's OK on the board before anything is built (D39 LUDO FIRST).

## V1 - The hall's zones (Ludo 3.1-3.2 + A)  -> ADOPT for the HALL, keep our rooms
Ludo: the ring in the middle of the floor splits the gym; the bags, the ring and the recovery area belong along the back wall, a clear
2.4 m corridor across the middle, and the training decks in the front half.
- Back half (z 0-7.6): BAG LINE west (x 0-11.5; every heavy bag on the back-wall cantilever rig at z ~1.5, plus a double-end ball and
  the speed-bag boards), RING centre-back (centre x 15, z 3.8, 6.5 m apron), STRETCH/RECOVERY mats east (x 18.5-30).
- Corridor (z 7.8-10.2): polished concrete, nothing standing in it.
- Front half (z 10.2-17.8): CARDIO west (treadmills, rowers, air bikes), STRENGTH centre (2 racks, 2 lifting platforms, cable crossover,
  dumbbell rack, plate tree), TURF + sled lanes east (2 lanes, plyo boxes, kettlebell rack).
- NOT taken: Ludo's lockers/wrap benches on the west wall and the reception + coach desk in the hall's south-east corner. We already
  have a locker room, a reception, an office and a physio room as separate rooms off the hall (z 18-22.5); Ludo did not know. The glove
  rack and the scale stay on the west wall (already there).
- Bags: this plan puts EVERY heavy bag on the back wall, which also fixes the BAGRIG1 problem (3 bags deleted because the bag zones sat
  3 m off the wall). Codex BAGRIG1B re-lays them to this plan once V1 is approved.
Build: Codex (gym_club.json floor_zones + places + the layout/clearance/fill tests re-derived from the plan, never loosened).

## V2 - Overview camera vs the 38% drawer (Ludo B)  -> Ludo recommends option (b)
Option (b): the hall framed into the left 62%, right 38% kept clear, via a horizontal frustum/lens offset, so nothing is hidden under
the drawer. Option (a) (full width) hides the east third of the hall whenever the drawer opens. Stills of both on the game camera are
attached to the board question (operator Q-S198-1: "Show me both as stills first").
Build: Cursor (ludo_camera overview stop: h_offset while the drawer is open, eased; full width when closed - or always offset, his pick).

## V3 - Where every UI item sits (Ludo C, 1920x1080)  -> ADOPT the 14 placements for the items we have; PARK 3 new ones
Take: time bar top centre (540,12 840x48) with the morning ticker + STEP IN under it; money top-left (16,16 320x64); fight countdown
top-right (1600,12 304x80); icon dock left (16,120 56x420); goals left (16,560 240x160); fighter stamina + strain + auto-pause bell
bottom-left (16,960 380x104); day feed bottom centre (410,960 480x104); drawer right (1190,0 730x1080, slides in 180 ms, Tab);
station info card and skip-day preview at the drawer's foot; last-spar decision centred (660,240 600x600); station labels as floor
stencils. Drawer open: time bar shifts left to x=180, countdown moves left or into the drawer header, feed narrows to 380.
Roster quick-select (F1-F4) only once the gym has more than one fighter.
Park (new mechanics, not in the demo scope): room climate/HVAC readout (item 15), heatmap toggles (17), live sparring overlay (18).
Build: UISYS1 (Codex) restyle uses this as the layout sheet.

## V4 - The look (Ludo 1, failures 1-3, 5, 7, 8)  -> ADOPT, minus anything worn
Take: a real key light (DirectionalLight3D pitch -55, yaw 35, #FFF7ED, energy 1.85, shadows) + SSAO (radius 1.4, intensity 2.8) so
machines sit ON the floor; the black rubber -> #1E222A, the pale tan wood -> red maple #78350F, aluminium threshold strips between floor
kinds; floor signs as painted stencils (Chakra Petch, 0.40 m letters, #64748B) instead of white boards; turf desaturated to #14532D;
ring canvas #E2E8F0 with red/blue/white corners; one gold accent #D69E2E used sparingly.
REJECTED (operator S198 "brand new" ruling): Ludo's foot-traffic grime decals and "chipped paint" stencils - nothing worn.
Kept as built: walls at 0.45 m (GYMART1A, Ludo r33) - r35 says 0.35; not worth a change.
Build: GYMLOOK3 (Cursor), behind gym_look2.

## V5 - Which grey boxes get real models first (Ludo 2)  -> ADOPT the order
Treadmill, power rack, dumbbell rack, adjustable bench, prowler sled, air rower, air bike, cable crossover, plyo box, wall bag arm -
prompts in part 1 lines 101-160 (all "factory-new"). Goes into EQUIP3 (generation starts once Nullspace is finished, per the queue).

## Ludo's own follow-ups (part 2 D) - read, nothing new to act on
Fighter-model pipeline (ANIMPROOF1 already queued), the zone table (= V1), camera transform (= V2), wireframes (= V3).

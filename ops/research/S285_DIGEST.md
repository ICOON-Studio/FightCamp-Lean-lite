# S285 digest (2026-10-22) - placement review, MGT2 rooms + doors, MGT2 weekly time, Arena/Qwen back on

Operator brief: "use arena and qwen", then "review the whole placement process and fix the errors, i want the building setup to
be quick and flawless like 2pm or mgt2. why your textures are so wierd", then the input pass, the reception room, MGT2 walls and
the MGT2 time question. Agent launches and the two big reworks ran in linked sessions started from this one.

## Shipped (master, newest last)
- 1d5ad561 placement review: all 28 gym surface textures imported WITHOUT mipmaps (bricks -> diagonal moire, floors -> static) ->
  mipmaps on (gym_texture_mipmaps_test); training-floor wood roughness 0.38 -> 0.6; the empty-shell shop is an unlimited catalogue
  (`BuildMode._shell_station_shop`; was: the starter set, "None left to buy" x420, rows vanished after 2 buys); hover no longer
  writes unbought phantom stations (8 per sweep, drawn at the hall 0,0 corner - likely his black squares); bought pieces survive a
  reload (`GymClubLayout._restore_shell_places`; 11 of 16 were lost); empty-hand click refused; floor pieces slide inside at an
  edge (`_nudge_inside`); speed-bag wall footprint 0.6x0.8; PLAN with no boxer says so (`GymHall3D.day_plan_reopen`).
  gym_shell_catalogue_test: 11 red on master -> 39/39 as_game.
- 02720d90 input pass: the green/red ghost never drew for a carried/dragged piece (`_update_ghost`) -> fixed; R turns the piece in
  hand (`_carry_yaw`); sold pieces drop their saved row; honest key line (Del sell). gym_build_input_test 6 red -> 19/19.
- 5bc3e0aa room draft keeps its area + items + door drawn while furnishing (operator: "the area disappears") -> 25/25; Ludo time
  verdict saved (ludo_rx/LUDO_S285_TIME_raw.txt, VERDICT_S285_TIME.md).
- 737b8d75 (session mgt2-walls-doors) drawn rooms like MGT2: door = step 1 of the draft, 2.6 m partitions + cap, one finish, door
  in its wall and cut with it (room_walls_mgt2_test). Board Q-S277-8 asks his OK on the stills.
- b136da93 collect ASGAMERED8 (Qwen #337): day_feed_wire_fit + focus_card green as_game; build_single_piece still open.
- 58b5e3fd (session timeflow-mgt2) TIMEFLOW1: MGT2-style calendar - Q-S277-6 "Approve, but slower days", Q-S277-7 "15 s a day";
  Space/1/2/3/Tab, five auto-pauses (fight offer with deadline, fight night, major injury, cash below zero, contract in 7 days),
  per-pause Settings toggles. Week measured 106 s at 1x. Exe rebuilt 19:19, boots headless with 0 script errors; NOT played yet.

## Agents
- Arena NIGHTLY13 -> PR #339 (relayed from lite): 4/5 nightly reds green on runners, but the bout is not repeatable run to run
  (the uncamped control moves 31.2% <-> 33.5%), so single-run greens may be luck. NOT collected. Qwen NIGHTLY13B round 3
  (#340, run 39815898562) measures spread on master vs Arena's commit before any change.
- Cursor #336 AUTOFILL2 and #335 BUILDFLOW1 r3 landed, NOT collected (both touch BuildMode/BuildWindow; told on their issues).

## Board
Q-S277-6 answered + built; Q-S277-7 answered (15 s); Q-S277-8 open (MGT2 rooms look - stills attached).

## HANDOFF
Next session: collect #336 + #335 against today's BuildMode (gym_shell_catalogue / gym_build_input / room_walls_mgt2 tests both
arms), read Qwen #340's spread numbers and decide #339, play the 19:19 exe route (new career -> build -> draw reception -> door ->
a week passing -> an auto-pause card) and fix what it shows. Ghost is a flat footprint (Two Point shows the model) - queue it.

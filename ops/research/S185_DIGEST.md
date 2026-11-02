# S185 DIGEST - 2026-10-09 - the first FOUGHT bout from the club, a playable floor slice, HUD2 variants

## What now works (evidence opened by Claude, game camera, as_game)
- **The whole first-bout loop from the 3D club**: new career -> hire coach -> sign Bastien -> book an EVEN offer -> camp ->
  week review -> fight week -> weigh-in -> fight night (live round) -> SIM TO RESULT -> SKIP corner -> RESULT (UD 29-28).
  `research/s184_club_bout_walk.plan` 60 steps, 0 failures. Stills: `docs/previews/s185_bout_walk/` (51 fight-week card,
  53 fight week, 54 weigh-in, 57 live round, 60 result).
- **Fight-day soft-lock fixed** (5081b5a9): the club's morning card said "Fight night", the day refused to end ("ATTEND
  TODAY'S FIGHT") and nothing led to the bout - the old HOME's gold ENTER FIGHT WEEK was never ported to the club. It is
  on the card now in fight week (`GymHallPanel.fight_week_entry`, `GymHall3D.fight_week_requested`).
  `club_fight_week_entry_test` 7/0.
- **FLOOR-PLAY slice 1** (5081b5a9): the fighter ring's TRAIN AT... (was greyed "coming next") lights every station on the
  floor; click one and he goes (queued if walking); Esc / right-click cancel; the day holds. `floor_pick_station_test`
  16/0, red on the old tree. Design call: 10 station kinds do not fit a 6-button ring -> pick on the floor (D37).
- **HUBS-DELETE** (88dfea46): AreaHubScreen + fighters_hub/fights_hub/money_hub routes + their 3 pictures removed; the
  lobby street door -> Fights, the mat room's dues board -> Finance. 15/15 focused.
- **Animated ground under the set-pieces** (b3626932, operator S185 "can you use animated backgrounds instead of the
  grey"): fight week / weigh-in / result stood on Godot's default grey clear colour; SetpieceRoot now lays the
  AmbientBackdrop shader under them (stills 54, 60). 22/0.
- **Result screen**: moments title counts what is shown (THE MOMENT / TWO / THREE); Chapter 1 line at a 17 px pitch
  (the caps font draws 23 px lines for 13 px text) - fbb757e0 + follow-up; **fight week** notes no longer draw over
  "Camp done" (CAMPVIS1's extra lines). result/story_ 20/0.
- **menu_clarity_test** was red on master since CORNER1 (scorebug capitalises the order) - compares the words now.
- **Walker**: `[Node_name]` matches the node's name (icon buttons were labelled by a sibling count badge "@3").

## Agents this session (cloud first)
- **Arena TIPS2** (PR #69, merged 11682e51): 163 hover targets in 9 panels, 117 uncovered; 6 rows spot-checked. Antigravity
  had died on launch (429 quota, resets ~10-11). **Arena can push to ICOON-Studio again** (S179's diff-copy workaround not
  needed this time).
- **Arena TIPS3** RUNNING (chat 01a11efd-7e07): apply the 117 tips; acceptance = CI parse gate + S185_TIPS3_APPLIED.md.
- **HUD2 no-top-bar variants** (operator S185 + Two Point Museum screenshot): brief `TASK_HUD2_VARIANTS.md`.
  Delivered: Maria A brass / B broadcast / C chalkboard (`docs/previews/ui_s185/M_*.png` + HUD2_STYLE/DIRECTIONS/PLACEMENT),
  cloud Cursor V3 fight-week rail + V4 minimal broadcast (ec350d3a), Kalli's 3 layouts (K_HUD2_KALLI.md, picks "the
  fighter lives bottom-left"). RUNNING: cloud Cursor V1 museum-faithful + V2 fighter-first (issue #67).
- **Qwen cloud key is dead**: `QWEN_API_KEY` repo secret answers 401 Invalid API-key - operator only.

## Seen, not fixed (next)
- Fight week strip shows MON..SAT with FIGHT NIGHT on Sat while the bout is today (DAYS 0) - the week template ignores
  the real bout day.
- Bastien reads 7-4-1 on fight week/weigh-in but "1-0-0" under WHAT THE NIGHT CHANGED - two records, unlabelled.
- Mock placeholders: V3/V4 copy the museum's numbers (0/2, 11, 1,420) and name the fighter two ways.

## Next (roadmap `now`)
Operator picks a HUD2 direction from the 7 mocks; then build it (top bar out) - the D37 dock carries FLOOR-PLAY's
equipment place/move/buy. Meanwhile: collect TIPS3 + V1/V2, the two record/fight-day defects above, GYM5-LOOK still.

# TASK DAYGOAL2 - the day-goal plate explains itself and pays (Kalli K86, operator-approved) (Arena)

Model: any. Seat: Arena (cloud). Tier: scripts edited -> parse + the 3 existing plate tests + the new test.
Operator C73 on the plate: "no clue wtf is this". Board Q-S225-13 answer: **"Build Kalli's version"**.
Spec (binding, verbatim copy lines): `research/K86_DAYGOAL_WORDS_REPLY_XAI.md`.

## Today
- `Godot/scripts/DayGoals.gd` (127 lines): pure goal builder (`day_goal(ctx)` kinds stamina_at_bell / sets_by_time,
  week kind move_usable_by_day), data `Godot/assets/data/day_goals.json` (stamina_floor 30). It pays NOTHING.
- Drawn by `Godot/scripts/DayGoalsHud.gd` (307 lines, `show_goals(day, week)` line 58) and on the club floor by
  `Godot/scripts/ui/FloorHud2Widgets.gd` (preloads DayGoals line 6); read by `GymClub3D.gd` (const Goals line 73) and
  `GymHallPanel.gd` (line 22). Grep these for `day_goal(`, `week_goal`, `show_goals` and read those windows only.
- Tests: `Godot/tests/day_goals_test.gd`, `day_goals_hud_test.gd`, `floor_day_goal_plate_test.gd`.

## Build (K86 sections 1-3, exactly)
1. Copy: header `COACH: +3 morale, +2 trust each`; stamina line `End last block with stamina 30+`; jab/move line
   `<Move> reaches Usable before Friday` (the move's own name; "Usable" capitalised); resolved lines
   `Met. +3 morale, +2 trust`, `Missed. Ended at {n}.` (the real end stamina), `Missed Friday. No bonus.`. No "bell".
2. Progress: stamina row = a chip with current stamina (same number as the stamina bar), underline EMPTY until the last
   block resolves (no partial credit; 30 pays, 29 pays 0); move row = chip + underline = the move's own Usable percent,
   five day ticks Mon-Fri that fill as days END. On resolve: icon check/X, the Met/Missed line.
3. Payout (new): once per goal when it resolves Met: athlete morale +3 and coach trust +2 (find the existing morale and
   coach-trust fields - grep `"morale"` and `trust` in GameState.gd windows / the athlete dict; NEVER invent a new stat;
   if no coach-trust field exists, say so in the PR and pay morale only). A goal never pays twice; Missed pays 0; gains
   already earned stay.
4. Where/when: same spot under the stamina/strain bars, 8 px below strain; selected fighter only; HIDDEN when he has no
   live goal (no empty plate); Met/Missed stays until the day advances.
Constants in day_goals.json: `reward_morale: 3`, `reward_trust: 2`.

## Acceptance
- New `Godot/tests/day_goal_payout_test.gd` (red on master first - there is no payout today): stamina 30 at the last
  block -> Met line + morale +3 (+ trust +2); 29 -> `Missed. Ended at 29.` + no change; a met goal resolving twice pays
  once; the move row pays once when the move reaches Usable, and `Missed Friday. No bonus.` at Friday close under 100%;
  the plate is hidden with no live goal; the header text is exactly the K86 header.
- The 3 existing plate tests updated ONLY where they pinned the old copy (say which lines in the PR), all green.
- Only the files named above + day_goals.json + the new test change. Never delete or weaken a test.

## Prior research
K86_DAYGOAL_WORDS_REPLY_XAI.md (Kalli), DECISION in board Q-S225-13, UI census UI_CENSUS_S227.md (plate row).

## What would a human do?
Rename the target in plain words, show what it pays, pay it once.

## Prefab check
None - game rules + one HUD block.

## Trap
Typed GDScript: no `:=` on Variant returns. Plain --script tests keep game switches OFF - the plate is not behind a switch.

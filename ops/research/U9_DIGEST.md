# U9 DIGEST — THE INJURY ON THE SCREEN

Cursor · 2026-09-08 · `ProfileRevampPanel.gd` + `ScheduleHubPanel.gd` + the three named tests. Top tier / high / Fast off.

## What shipped

A named injury now prints on the BODY LAB and on the schedule's amateur hold row, in Q3/Q4's words. No third copy.

- Region cell: diagnosis beside the 0-100 number (`HEAD / NECK  ·  HEAD KNOCK`). A clear region is unchanged — no empty label, no NONE.
- Two date lines under the banner, never inside a cell (the lab is placed by hand). DIRECT is stated flat, AUTHORED is THE GYM ESTIMATES, UNKNOWN is NO DATE SET. Grade words never reach a Label.
- Banner keeps its 48px shape and original y, and gains diagnosis · region. Unnamed holds still print an em-dash (C37). Named clearances sit as chips under the banner.
- Amateur refused row: `FIGHTER UNDER A MEDICAL HOLD  ·  HEAD KNOCK · HEAD / NECK`. Same helper, same words.

Did not edit Injury.gd, InjuryWords.gd, RecoveryWords.gd, BodyReadiness.gd, GameState.gd or HANDOFF.md. Attribute assertions stay at seven.

## Gate

Parse gate clean. `profile_revamp_test` 0. `body_region_screen_test` 47/0. `schedule_hub_panel_test` 70/0. `smoke_test` 0. Full suite **174/174** after rebase onto origin/master (R62/C44/G19/Q7).

## Left

Please write the HANDOFF block from this digest — I did not edit HANDOFF.md (your U8 note). Branch `cursor/u9-injury-on-screen-7555`.

# S283 digest (2026-10-21) - office DEALS tab in, the one top bar fixed on OFFICE and HOME, HITFEEL2 r5 out

Stage cut short: the weekly Claude usage reached 99 % (resets 2026-10-22 14:00).

## Shipped (master)
- 0592759d OFFICEDEALS1 r2 collected by diff from Cursor PR #330 (closed): office DEALS tab - this week's offers, staff pay tier,
  loans. Morale number moved clear of its meter (the one r1 defect left on the r2 still). office_deals_tab_test 22 PASS as_game, plain green.
- 0bd4bf44 Office top bar: HUD2 turns ContinueUnit into a screen-sized holder; OneTopBar moved it like a normal unit, so the date
  plate sat under the cash (x 1464) and Continue was off screen (x 2456) on any shell without a clock. Holder stays at the origin,
  its halves go right to left. OfficeHubPanel._game_state no longer does an absolute get_node before the panel is in the tree (engine
  ERROR on the office route; a route straight to DEALS lost the tab - came in with OFFICEDEALS1). New one_top_bar_overlap_test,
  red on the shipped tree (2 FAIL), green now.
- 32b284ef ASGAMERED6 row 1 BY DESIGN: HOME is the 3D gym under the one top bar (still on the real route). scene_router_test
  rewritten to the game's behaviour (248/248 both arms). The still showed two bar defects, fixed: HUD V3 money plate drew
  "$0/wk" + runway over the cash (S280 MemberCap chip shifted the cash chip; chip now under the cash in the 384 px plate) and the
  floor tray ran into the timeline (OneTopBar.fit_tray folds tray buttons to icons, last first). Overlap test covers OFFICE + HOME.

## Evidence
- Stills opened: previews/office_deals/deals_tab.jpg, previews/s283_home_topbar.jpg (both on 8787/review).
- 12 bar/HUD/floor tests plain green; as_game 10/12 - day_feed_screen_test + day_plan_floor_test red on master too (noted in the audit).

## HITFEEL2 (Cursor #323) - r4 NOT collected, r5 launched
- Measured: two OFF runs of the same seeded live bout differ at FRAME 0 (22 bones). Every OFF-vs-ON cross-run check (pose
  byte-identity, penetration ON <= OFF) is noise: penetration read 0/0 on one run, 0.061/0 on the next. Runtime 372-455 s as_game,
  plain arm > 300 s. r5 brief (issue body): within-run checks only, plain arm quits at once, < 120 s.
- Finding for later: the live bout is not repeatable run to run in one process (source unknown - clip phase or unseeded random).

## Next
See roadmap now.next_action (S284).

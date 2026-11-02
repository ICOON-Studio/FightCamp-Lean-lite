# ASGAMERED6 audit (S281) - Goose rounds 3-5 guarded tests instead of fixing the game; the guards name 8 suspects

Rounds 3, 4 and 5 (goose/issue-315*, last 7a25fe78) answered "fix the game or assert the replacement" by wrapping checks in
`if not as_game`. Collected from it: gym_menu_test only (987446a2, asserts the one top bar). Nothing else is taken. Goose's own commit
messages call each guarded case a "game bug" - each is a suspect to verdict, one by one, on the as_game career the player gets:

| # | Test | Goose's claim under -- as_game | First question to answer |
|---|---|---|---|
| 1 | scene_router_test | `content_above_shell` false - "shell layout differs" | Is the HOME content drawn UNDER the top bar? (still on the real route) -> defect if covered |
| 2 | schedule_hub_panel_test | promotions / tournaments empty - "shell lacks data" | Promotions are the WORLD's: does SCHEDULE > PROMOTIONS show rows in the empty-start game? |
| 3 | focus_card_test | station focus stays empty | Does clicking a station's focus on the empty start do anything? |
| 4 | gym_hall_ring_steps_test | fighter climb position.y stays 0 | Does a boxer climb into a bought ring, or walk through the apron? |
| 5 | gym_market_slice_two_test | membership market data missing | Is the membership market (prices / walk-ins) live on the empty start? |
| 6 | schedule_my_gym_test | tabs differ | By design (empty_gym_start opens GYM) or a missing tab? |
| 7 | day_feed_wire_fit_test | DayFeedPanel not mounted on HOME | By design (one top bar, S275) -> assert the replacement |
| 8 | build_single_piece_test | "shell lacks zones even after dev_built_gym" | dev_built_gym's contract says it restores every zone - if it does not, the fixture is broken |

Next (queued, not Goose): one suspect per row through the GAME (as_game career, a still or a print on the real route), verdict
written here, then fix the game or rewrite the check to the by-design replacement. Rows 1, 2, 4 and 5 are player-visible if real.
Issue #315 closes on this audit.

## S282 verdicts (Claude, each run on the game arm `-- as_game`, then the plain arm; all green both arms after)
| # | Verdict | Evidence / change |
|---|---|---|
| 2 | BY DESIGN | ScheduleHubPanel `_visible_feature_tabs()` hides PROMOTIONS + TOURNAMENTS in the boxing demo slice. The test now asserts that in the game arm and reads the tabs in the plain arm. |
| 4 | GAME OK, TEST WRONG | In the game `send_to("ring")` is QUEUED behind the current block (S276 "nothing interrupts": walk_minutes 0). Followed for up to 3 h, he climbs to 0.95 m and is never inside the platform below its top. The test now follows a queued send. |
| 5 | BY DESIGN (fixture) | The empty shell (S277 MGT2) has no members, so the market levers read 0 -> 0. The checks are about the market on a working gym, so the fixture calls `dev_built_gym` (a no-op in the plain arm). 53/53. |
| 6 | BY DESIGN | With MY GYM on, the hub opens on MY GYM (ScheduleHubPanel L205). The test asserts that, then runs every MY MONTH check on the month tab. 86/86. |
| 1 | BY DESIGN (S283), 2 defects fixed on the way | HOME still on the real route (`tools/s275_route_still.gd route=day_feed -- as_game`): HOME is the full-screen 3D gym (GymHallPanel, gym3d_main) under the S275 one top bar - the bar draws ABOVE every page by design, and the empty-gym start has no fighters. The test now asserts HOME's panel per arm, the shell/content order per `one_top_bar`, and signs the starter pair itself for the lab bout; 248/248 both arms. The still showed two real bar defects, fixed: HUD V3's money plate drew "$0/wk" + runway over the cash (the S280 MemberCap chip shifted the cash chip; chip now sits under the cash), and the floor tray ran 6 px into the timeline (tray buttons now fold to icons to fit). Guarded by one_top_bar_overlap_test (office panel, OFFICE + HOME routes). |
| - | NOTED S283 | day_feed_screen_test (3 S80 hub checks) and day_plan_floor_test ("minute holds while the panel is open") are red as_game on master too - not caused by the S283 bar change; next rows for this audit. |
| 3, 7, 8 | not reached this session | |

## S284 verdicts (Cursor #332 diff, collected by Claude f-collect; both tests green on both arms)
| - | BY DESIGN (rows day_feed_screen_test, day_plan_floor_test) | as_game HOME: empty gym puts the first job on the coach at the door (gym_is_menu pins = Door/Ledger/Board), no YOUR FIGHTERS row on the S277 stripped start; S276 no_interrupts keeps the day clock running while the morning plan panel is open. The checks now assert those replacements per arm. |

## S285 verdicts (Qwen cloud #337, collected by Claude by diff; runners green both arms: focus_card, day_feed_wire_fit, day_plan, day_plan_floor)
| # | Verdict | Evidence / change |
|---|---|---|
| 7 | BY DESIGN | day_feed_wire_fit_test: under one_top_bar/gym3d_main HOME is the 3D gym, no DayFeedPanel mounted; the as_game arm builds the panel itself and still checks the wire fit (2035d7b9). |
| 3 | TEST WRONG (route) | focus_card_test: the day plan sends him to its first block's station at START DAY (deliberate `index == 0` send in GymHall3D._day_plan_enter); Qwen r2 changed the game to skip that and was REFUSED (block 1 would be silently skipped). r3 (ca518c82): the test follows the plan to its first station, then sends him to the bag like a player and waits for arrival (row 4 precedent). |
| 8 | OPEN | build_single_piece_test: "Outside the gym" for every spot on the stripped start - the fix is in BuildMode.gd, owned by AUTOFILL2 (Cursor #336) until that is collected. |

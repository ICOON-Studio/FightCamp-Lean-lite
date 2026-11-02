# S277 DIGEST (2026-10-20/21) - the new start: an empty building you build yourself, Mad Games rooms, money only from what is built

Operator direction this stage, verbatim: "focus on the new start, blank gym player designs everything with limited budget , and slowly
everything tightens on the loop"; "our game must be way better than this" (Gym Empire, Steam 756300); "finish your ghidra on 2point
and mega games"; "use REA github"; "ludo is free for questions ... askludo and compare your numbers with it"; "Yes - rent that grows
during the year, as Ludo proposed."; "make the box purchasable item"; "Yes - members and income come only from what is built: each item
adds training places, the desk opens sign-ups, comfort items raise the gym score."; "this is not how MGT2 builds its rooms".

## What now works (commits on master)
| Commit | What |
|---|---|
| 3013afbd | GYMBUILD A: a new career is an EMPTY SHELL on its own lot (grass, hedge, trees, street door on the building); no rooms, no free dressing (club_look/GymPlot.gd, GymClubLayout._apply_built_rooms, is_shell) |
| 42710b57 | The RING is bought (BUILD shop, 18,000, on its spot); ROOMS the MGT2 way - BUILD > ROOMS > drag a rectangle, Qwen's RoomDrawRules check it live (price on the cursor), it stands EMPTY (walls + door); ITEMS > the key item (front desk 800) placed where clicked; MONEY from what is built (floor equipment = what stands; 0 members until a front desk stands in a reception; target capped at training places x 5) |
| 3791ce96 | RENT that grows: 1,200 for 2 months, then +350/month + 4.50 per built m2 (room_types.json); only shell gyms pay |
| 0069d3d1 | Economy research: TWOPOINT_ECONOMY_S277.md (UnityPy configs), MGT2_STUDY_S277.md (REA 6.7.0 + IL decoder), CLAUDE_START_ECONOMY_S277.md (mine first), Ludo's answer (ludo_rx/LUDO_S277_BLANKSTART_raw.txt, 30,609 chars), LUDO_S277_BLANKSTART_VERDICT.md (side by side; Ludo wins most rows) |
| 4f52e822 | Cursor ASGAMERED1 collected (8 gym tests as_game) + 4 more ported; S277_GYM_EMPIRE_BENCHMARK.md (the bar in GYMBUILD_PLAN) |
| d5fe4376 | Arena ATTRWIRE1 collected: ko_leverage / damage_mitigation / trauma_threshold reach the bout + 11-attribute e2e test (chin fixture fixed on collect) |
| 7100d7df | Qwen ROOMDRAW1 (RoomDrawRules.gd) + Goose ITEMPALETTE1 (ItemPalette.gd) collected |
| 38da9108 | John GYMDECOR1 decor asset list (CC0 Kenney/KayKit/Quaternius/One More Rep) for GYMBUILD D |

Evidence: tools/s277_shell_probe.gd on the real route with real mouse input (stills previews/s277_shell 01-06, on the
review board): empty $25,000 -> ring $7,000 -> reception drawn $1,240 ($5,760, empty, target 0) -> front desk $800 ($4,960, counter
stands, target 20). tools/s277_capacity_probe.gd: empty 0 kit / $0 -> +ring 4 places, 0 members -> +desk cap 20 ($320/wk) -> +bag line
cap 50 ($800/wk). New tests: ring_purchase_test, rent_test (+ Qwen/Goose module tests) green plain + as_game. s276_loop_probe on the
shell: clock runs, day rolls, no script errors.

## Decided (Claude, developer calls)
- A drawn room's furniture is ONLY what the player placed (GymClubLayout builds it from the data furniture row at his spot).
- Building a room rebuilds the gym screen (CareerRoot never reuses a gym marked `rebuild`; the parked key carries built rooms).
- GameState.dev_built_gym(): test/dev support only - a shell career back to the built starter gym; DevJump uses it (a jumped
  mid-season career is a built gym). No-op on any other career, so the plain arm is byte-identical.
- Members per training place = 5 (membership.json, from Ludo's minimum open gym vs his 35-member cap).

## Board
- Q-S273-6 rent: ANSWERED "Yes - rent that grows during the year, as Ludo proposed." (built)
- Q-S273-7 approve the rest of the new-start numbers (LUDO_S277_BLANKSTART_VERDICT.md) - OPEN (goals chain, income channels,
  policies, loans, bail-out wait for it).

## Measured, not fixed here (in flight)
The as_game arm was red across the board on master BEFORE S277 (baselined each time by switching the S277 lines off): Cursor
ASGAMERED2 #309 (10 gym/room tests), ASGAMERED3 #310 (3 fight-wiring), NIGHTLY12 #303 (3 nightly reds); Goose ASGAMERED4 #311
(39 DevJump/gym tests + day_clock + daily_progression; first suspect: DevJump cannot book a bout under the game switches).

## Open / next (in order)
1. Collect what lands (#303, #309, #310, #311; Ziva ZIVATREMBLE1 in wt/ZIVA).
2. GYMBUILD C: the item palette as a SIDEBAR (ItemPalette.gd rows by room/type, icons + tooltips) replacing the long bottom tray;
   training-floor items placed one by one (not only zones); R turns items; sell/move.
3. Rooms: the room's other items (phone, bell, trophy cabinet, lockers, physio kit...) as buyable room items with prices; office PC,
   locker and physio key items wired to their systems (office goals, showers, treatment) like the desk to sign-ups; walk-in route to
   wherever the reception was drawn (walk_in points are still the fixed data ones).
4. After Q-S273-7: Ludo's 16-goal first hour, early income channels (pad sessions, sparring hire, banner sponsor), the four policies,
   loans + promoter bail-out, the taped floor ring (1,200).
5. GYMBUILD D: comfort/decor items raise the gym score (John's CC0 list) - the operator's "comfort items raise the gym score".

## Lessons
- MGT2 builds a room EMPTY; a pre-furnished room at a fixed spot is not "drawing a room" (operator caught it at once).
- An empty gym earned $1,248/week from 10 invisible starter items - the money model and BUILD read different lists; probe the
  economy of the real start, not only its picture.
- Ask Ludo is free (operator S277); never quote a credit cost again. Board questions in player words, two options.

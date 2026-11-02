# S170 DIGEST - 2026-10-06 (Sonnet 5.5, medium)

## Shipped (all on master, tests named, stills opened on the game camera)
- THE FIGHT BUSINESS demo walked by computer-use -> `S170_FIGHT_BUSINESS_WALK.md` (880bf865). It is a menu-only manager; our floor is already ahead.
  Copy: recruitment table shape (dashes for unscouted), a named "DESK CLEAR" state, facility ladder, two named cash pools.
- STORY4A merged (f8867798): `StoryCampaign.wall()` pure read, `story_wall_test` 22/0 (Arena PR #51, diff applied).
- OFFERS_CARD_M42 merged (77b8bd71): Schedule offers are cards (Arena PR #52, diff applied + 1 test fix: the blocked-card check built the card
  without the panel wrapper and re-parented a parented node). `offer_card_test` 91/0; schedule 8, amateur 5, booking 4 green.
  Still: `docs/previews/s170_offers5/24_offers_signed.png`. Left: the SPONSOR row and pro rows share the new shape only for graded offers.
- Defects fixed (found walking the first ten minutes): no coach hired -> planner said "COACHES ARE FULLY BOOKED" four times and printed it
  over the hint line (ad5672d3; `training_no_coach_test` 7/0, training 12/0); fighter/coach tag on the floor unreadable -> dark plate
  (a45cda15; floor 6/0); Inbox/Wall content ran under the side panel (b6835783).
- STORY4B (b6835783): THE WALL panel + `get_story_wall` + `story_wall` route + THE WALL button on the inbox. `story_wall_panel_test` 42/0,
  mutant (no tilt on a fallen frame) goes red; story 9/0; scene_router 1/0. Stills `docs/previews/s170_wall3/`.
- Floor with a boxer + coach working, game camera: `docs/previews/s170_coach5/35_floor_working_later.png` (plan `research/s170_coach.plan`).
- Rule added to CLAUDE.md s2: NO REPORT BEFORE THE NEXT ITEM (operator: "I kept ending my turns with a report"). Memory: feedback_no_report_before_next_item.

## Traps
- Walk plan buttons drift: signing is now OPEN THE OFFER -> SEND OFFER -> SIGN CONTRACT; "Go to the door" is gone. Plans: `s170_offers/floor/coach/wall.plan`.
- Demo launch: steam:// fails in computer-use; run the exe; window opens minimised at -32000 (ShowWindow 9); grant display name AND exe basename.
- `git apply` of an Arena diff needs `--ignore-whitespace` (CRLF repo). A Label3D outline change did nothing on the tag; a billboard quad plate did.
- `run_tests.py --only tag` matches far too many tests (400 s); use a specific substring.

## Open
- Arena PR #43 (KM3, capsule geometry): not merged - it moves C223 contact geometry, needs its own measured pass.
- HOME pin for the Wall (spec) not built - reached from the Inbox only. Locked frames have no lock icon, only the word LOCKED.
- Candidate-card video; floor as the Training default; sponsor/pro offer rows to the card shape.
- Operator question 2026-10-06: build from Creed: Rise to Glory? Answered no (no source; ripped assets never ship, CLAUDE.md s10); use it as a reference.

# S169 digest (2026-10-05/06, PC) - agent sweep, operator playtest fixes

## Shipped (all pushed on master)
- Agent sweep: STORY4A launched on Arena (chat 01a10da6, new chat, PR must touch only StoryCampaign.gd + story_wall_test.gd); NIGHTLY1C2 = Arena PR #50 applied as a diff (21afb077; footwork 19/0, back bands 0 fails, six neighbours green on my run in a worktree); J62 + M42 full memos collected (J62_HUB_REFERENCE_LOGIC_FULL.md, M42_HUB_MOCKUPS_FULL.md).
- Operator played the dev tree (switches on) and hit: guide plate covered the OFFERS Enter/Accept bar (could not book). FIXED 9ea35e06: plate on HOME only, a pill elsewhere; the card follows the save (next step loads by itself); tutorial_guide_test 37/0, red on the old code.
- 1f0be8db: WATCH THE FLOOR button on the training planner; week review IN tile names its sources (members' dues / sponsors; "I earned money, I did nothing" = member dues); stopped time bar says "press play to go on"; week_review_test +3.
- ee7dfd89: SCOUTING/OFFICE header drew its title twice and the band art's sketch text read through (band title blank, Darken 0.72); candidate_card_test +1.
- Stills as the game shows them: docs/previews/s169_floor_cards2/ (14 boxer candidate card, 18 the 3D training floor, 20 planner with the floor button) - sent to the operator.

## Findings
- The 3D training floor exists (route training_floor, TRAIN1/TRAIN1B merged) but the rail's Training opens the planner. Floor shows no fighter/coach at work when nobody is programmed (0 on the floor). Operator wants it to be one of the best screens.
- All three of Kalli, John, Maria recommended Option A (NAV1); the operator ruled B. The agents did NOT agree.
- THE FIGHT BUSINESS demo (Steam app 5299070, Godot, E:\SteamLibrary\steamapps\common\THE FIGHT BUSINESS BOXING MANAGER Demo) is installed; J62 said "not found" - wrong. Reference only. Captured its title menu; not yet walked.
- Operator: Schedule OFFERS table "looks like 2004" -> rebuild to Maria's offer_row mock (M42 section 2.4).

## Owed
- Computer use is ON in the app but its tools did not load in this session: next session, request_access and walk the Fight Business demo (New Demo Career -> scouting, offers, training, finance), capture and compare.
- Floor still with a programmed boxer + coach working; coach candidate card still; first-ten-minutes video (walk plan research/s169_floor_cards.plan, last dead end at step 23 'try STAFF' path).
- Offers table redesign; make the floor the Training default; collect Arena STORY4A.
- The popup probe SAW windows during the walks (3-4); likely the demo I launched + operator windows, not proven - ask the operator.

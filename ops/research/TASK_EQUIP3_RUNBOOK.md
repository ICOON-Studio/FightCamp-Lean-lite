# EQUIP3 RUNBOOK - brand-new factory equipment models from Ludo (written S199 for the next session)
Decision S199: start NEXT session, first action, ONLY after the operator's other Ludo project (Nullspace) is confirmed finished
(operator S198: "let the other project finish") - both use one Ludo account/credit pool (~200 credits a round, ~230 total at S197).
Check the board / ask once: "Is Nullspace finished?" - if the operator already said yes in chat, go.

## Operator rulings (verbatim, S198)
"ask it to ship as it came out of the factory" / "it means brand new"; "yes" to "Ludo should be asked to make the models that way".
Every machine, bag, ring and rack looks BRAND NEW: clean PBR, no _worn models, no duct tape/scuffs/chips/stains.

## What exists
14 prop models; 81 of 95 catalogue items still greybox. Sourcing order = Ludo r33 section 1.4 top-15 (LUDO_ROUND33_S198.txt lines 227-248):
heavy bag (2,400 tris, 2048 tex) FIRST, ring, treadmill, focus mitts, speed bag, power rack, sled, bench+bar, rower, dumbbell rack, foam roller, reflex bag, corner stool, chalk stand, 8-door wall locker bank.
Brief that went wrong before: [[feedback_ludo_wrong_chat]] - read the chat title before EVERY send ('Multi-Hub Space Strategy' is NULLSPACE, not ours; project FightCamp
https://app.ludo.ai/project/6ac93f6894905495ba8795db). Max out each ask ([[feedback_ludo_huge_questions]]), log reply char counts in a LUDO_EQUIP3_*.md file.

## Steps
1. `python Tools/prior_research.py ludo 3d model prop` ; open Ludo in the user's Chrome (Chrome tabs_context first, reuse the tab). Confirm project = FightCamp.
2. Ludo 3D: heavy bag ONLY. Prompt = our tri/texture budget, "brand new, factory finish, clean PBR, no wear", Godot glTF (.glb), Y-up, metres, origin at the floor centre (the bag: at the hang point - check how `_place_model` anchors).
3. Import to `Godot/assets/models/equipment/`; light files (check .pck impact); wire where the catalogue item's greybox is chosen (find with grep "greybox" in scripts/club_look and GymClub3D `_place_model`; EQUIP2 notes in TASK_EQUIP2.md / TASK_EQUIP2B.md).
4. PROOF: game-camera still (`gym_club_stills.gd` as_game ... gym_look2) opened by Claude; does the bag hang, scale (~1.0 m), face the right way. review_add + SendUserFile. Only then repeat for the other 14.
5. Run EVERY test that reads the club scene (club_fill/zones/gym_look2_props/gym_club_3d/layout/clearance/floor_pick/gym_hall_3d) - S199 lesson: a data change broke two neighbours that nobody ran.
6. Money: if Ludo credits run out mid-list, that is the operator's money question - post it with `agent_comms.py ask`, do not buy anything.

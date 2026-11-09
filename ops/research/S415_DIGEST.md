# S415 digest (2026-11-09)

## Asked and done
- Session start. REARHAND2 (PR 133) merged: it stopped at its own control check, as its brief told it to. Low-over-hips agrees on the three controls (0.019, 0.022, 0.025; bar 0.03); ahead-of-hips does not (0.054, 0.043, 0.059, raw always further ahead). No right-hook table yet. REARHAND3 (Qwen, queued) divides by each skeleton's arm length and always writes the height column.
- Home PRs 107 and 120 closed: superseded by his picture.
- Home: the three corner panels are gone. One low shelf on the pavement at the picture's bottom edge (the job, Mail, More below, HomeCorners.gd). The week's news and club numbers are in the right column under the gym (HomeSide.fill). The job plate clicks through to Fights.
- UFC lettering removed from all 11 bags in assets/ui/art/gym_main.jpg: 2,876 of 1,573,352 pixels, each row rebuilt from the fabric either side; no AI edit. The red machine's white mark is a garbled shape, not a legible logo: left.
- His question: must the look be rebuilt as sprites, layers and modular tiles? Answer given: equipment yes (cut from his picture), ring two layers, fighters animated 2D re-baked at this camera; floor and walls no (one emptied picture), cage waits on his call.
- Test of that answer: one Ludo edit (1 credit, 2 results), tools/gym_slots_diff.py registers the empty room on his picture (ECC 0.9719), keeps his pixels outside the main hall, one smooth light correction inside it, finds pieces as what differs. tools/gym_slots_compose.py reveals 18 test slots from his own pixels. Pictures docs/mockups/s415 (gym_start, gym_middle, gym_empty, gym_grows). Checked by eye: no seams, no halo.

## Evidence
Tests green: gym_hub (went red-first on the new shelf check by construction: the old corners are asserted gone), home_look, guide_person, first_week, first_hour_walk, no_pronoun, plain_words, golden_path. Home and the page under it rendered and opened. Exported.

## Not done
Nothing scored by a critic. The slots are a test, not in the game. The 18 slots are hand rectangles; the red floor, rail and six bags are one slot because no picture has that floor without its bags. Places still reach no game rule. FIGHTERMODEL4H red on CI (plan_bots 2, matchmaking_bots); 4B still running.

## Later in S415
- REARHAND3 merged (PR 134, tools and a doc, merged before its CI finished). All eight right hooks: raw and game hand height agree within 0.03 of body height, and the raw low point is at the hips too (raw low_h -0.023 to 0.099). So the drop is in the bought capture, not the bake. The forward column stays unproved: dividing by arm length made the controls worse (0.22 to 0.27), so section d was rightly not written. REARHAND1's "all 10 right hooks" is eight.
- REARHAND4 (Qwen): every hook we own, height column only, to see if a better take exists.
- FIGHTERMODEL4B's run died: "Connection lost" in its output, runner and Cursor processes gone, no exit logged, last file write 18:07. Three files saved as commit dae63cc2 on its branch, unproved. FIGHTERMODEL4I continues from it.
- The board job launched MENUPLAYBOOK2B from the queue once 4B's run was marked stale. It waits on dark or cream, so it was stopped within a minute, its empty worktree and branch removed, and it and MENUFIGHT1B set to held. Its live_runs entry stays, so a re-run needs a new id.

## The gym you buy up (later in S415)
His yes: start small. Built on his third picture of the session, ops/research/GYM_SLOTS_S415.md has the method, numbers and prices. Career.gym_slots, GymSlots (pure), GymEquip, GymSpend.buy_slot and the floor as a member limit; a seventh pin, Equip the gym, on the weights area (his question: "why there is no menu on this area ? what can be used for ?"). tests/gym_slots_test.gd. Stills docs/mockups/s415/home_start, home_equip, home_full, checked by eye; not scored by a critic.
Not done: boxers on the floor; each kind building something; the balance harness has no bot that buys equipment.
His Q-S294-146: "why do you have the guide on every screen you draw ? are you trying to annoy me ? dark looks nice , i like the wooden look of the menus though". Stills now render with the guide off (tools/gym_still.gd). The look is NOT yet decided by it: dark panels with a wooden look is a new direction to draw.

## REARHAND4 (merged, PR 135)
19 hook takes in the two Punch packs, controls passed (0.284, 0.273). No right hook reaches 0.15 of body height over the hips; the highest is 0.099 (Right_Hook_Hard_FT, a benched-style take), left hooks reach 0.35. Its strike_h column equals low_h on every row, so that column is void; low_h is the one that passed its controls. Only files named hook in the two Punch packs were read. So the low hand cannot be fixed by swapping a take.

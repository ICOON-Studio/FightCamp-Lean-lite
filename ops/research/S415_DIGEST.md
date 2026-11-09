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

# S414 digest (2026-11-09)

## Asked and done
- Q-S294-143 "Show me one real page first": the fighter Overview in dark panels (scripts/ui/DarkOverview.gd). FighterPage.dark_overview on until his answer (Q-S294-146).
- Eight gym planner websites compared (ops/research/GYM_PLANNER_SITES_S414.md). The builder drawn step by step from his notes (tools/gym_builder_still.gd, docs/mockups/s414/builder_*.jpg).
- "why you do not use it exactly as it is ?", then "yes": his own gym picture is Home's main screen, unchanged (assets/ui/art/gym_main.jpg, GymHub). Pins at PIN_AT. IsoGym and HubFigures stay in the tree hidden, because GymPlan's rules and tests read them.
- REARHAND1 probe corrected: Qwen had the two hands swapped. All 10 right hooks reach hip height and go behind the hip; every benched right hook but one is worse, so no swap. REARHAND2 (Qwen) running: is it the capture or the bake?

## Evidence
Tests touched, green: next_step_card, attr_board, no_pronoun, plain_words, first_week, guide_person, golden_path, gym_hub, home_look. Home rendered on the real route and opened (E:/FightCamp/tmp/s414_home/home.png). Exported.

## Not done
Miro map not redrawn at the start or the end of S414 (roll S414 done in roadmap). MENUWEEK2 PR 130 held: red tests, two script errors, built for cream. Nothing scored by a critic.

## Next: pin and slot (his question: "do we need to generate any assets or use the pin and slot method ?")
1. Home's corner panels now lie over the picture: The job and Since last Monday hide lockers and bags. Decide with him.
2. Slots: a fixed list on the picture (x, y, kind, price, places), each empty or filled. Replaces free placement. Empty room: one Ludo edit of gym_main (his2 proved the method). One cut-out per slot, from his picture.
3. Remove "UFC" from the bags before anyone outside sees it (a trademark): one masked Ludo edit.
4. Places must reach the game: GymPlaces is not called. Rules to measure on the harness first: no place at the busy hour = likelier to leave; full station = part of a session lost; kind decides what it builds.
5. Boxers on the floor: re-bake at this camera (tools/bake_hub_sprites.gd), pins and walkable spots mapped to the picture.
6. Scope points for him: the cage and "MMA GYM" sign in a boxing-only demo; left menu or top tabs (his mock has a left menu); expansion (door on the front in his picture).

# TASK MENUWORLD1 - CURSOR (Grok 4.7 High) - the World page, rebuilt around the rankings

Status: OPEN (S403, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
OWNS: scripts/ui/areas/World.gd, scripts/ui/WorldLadder.gd, scripts/ui/WorldCompare.gd, scripts/rules/WorldLadderRules.gd, tests/menu_world_test.gd, tests/world_ladder_rules_test.gd
RED_TEST: tests/menu_world_test.gd -> MENU_WORLD failures=0
REGRESSION: world_ladder_rules_test, kit_icon_test, world_rules_test, world_years_test, matchmaking_bots_test, pro_debut_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/world.html and world.png (the spec), scripts/ui/WarmKit.gd, scripts/ui/KitIcon.gd, and today's page scripts/ui/areas/World.gd. Find today's win band, scouting and "ask for a named fighter" in scripts/rules and scripts/ui/areas/Fights.gd.

## Prior research
`python ops/Tools/prior_research.py rankings ladder`. The job of this page is rivals and the ladder: which fight do I ask for next, and what does a win do.

## What would a human do?
A manager opens the rankings to pick the next opponent: who is beatable, who is scouted, what a win is worth.

## Prefab check
None needed. Reuse the game's win band and scouting: do not write new maths.

## Build
1. Tabs News, Rankings, Championships as today. On Rankings: one row of fighter faces with state icon, division and rank, choosing the division. Sport chips: Boxing live, MMA not built.
2. The ladder: ranks 1 to 10 of the selected division, your fighter pinned in place or at the bottom with the rule to enter. Columns: rank, name and mark (champion, challenger, next opponent), record, age, win chance as a band (wide when not scouted), scouted or not (partly in amber), trend, finishes, style, and Ask for this fight on rows within reach (today's promoter band). Rows out of reach faded. Booked rows show the date instead.
3. Side by side, for the selected rival: your fighter against them on today's attributes, the rival as ranges when not scouted, with Ask for this fight (grey with reason when not possible) and Scout with its price and what it opens.
4. Title route for the selected fighter, from the real rules, counted honestly (pure function in WorldLadderRules with a test: an unranked fighter's route starts at entering).
5. Complete key, and the news box stays.

## Do
1. tests/menu_world_test.gd FIRST, printing `MENU_WORLD failures=<n>`, on a real career with a ranked fighter. It must fail on main. Cover: panels exist by name; ladder shows at most 10 plus your fighter in rank order; band is wider unscouted than scouted; Ask shown only within reach; a booked rival's Ask is grey with its reason; every icon drawn is in the key; every action on today's page is still reachable.
2. Build inside OWNS.
3. Run REGRESSION. Do not edit an existing test's numbers.

## PR body
`RESULT: tests/menu_world_test.gd -> MENU_WORLD failures=0`, the not-built list, and what moved.

## The one trap
Reading a win band must not draw a random number: one more rng call shifts every later roll in the career and save_load and golden_path go red for no visible reason.

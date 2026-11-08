# TASK FIGHTERMODEL4A - CURSOR (Grok 4.7 High) - the fighter model on the agreed 10 attributes and 5 boxing skills

Status: OPEN (S404, Claude main). Discipline: boxing. Model: grok-4.7-high. Replaces FIGHTERMODEL3C, which was held because the owner redid the attribute list.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. The last two rounds ran out of time: work in small commits, in the order below, and stop after step 6.
FIRST: merge origin/main into this branch and keep every touched test green.

## Contract
BASE: cursor/fightermodel3b
OWNS: scripts/rules/AttrGen.gd, scripts/rules/Attrs.gd, scripts/rules/BoutRead.gd, scripts/rules/BoutRules.gd, scripts/rules/ComboOdds.gd, scripts/rules/Duels.gd, scripts/rules/Exchanges.gd, scripts/rules/Knockdowns.gd, scripts/rules/Matchmaking.gd, scripts/rules/PadWeek.gd, scripts/rules/RoundStyle.gd, scripts/state/BoutNight.gd, scripts/state/LiveRead.gd, scripts/state/LiveRound.gd, scripts/state/ProLadder.gd, scripts/state/Region.gd, scripts/state/RingDuel.gd, scripts/state/Sim.gd, scripts/ui/AttrBoard.gd, scripts/ui/BoutCompare.gd, scripts/world/WorldBout.gd, scripts/world/WorldGen.gd, scripts/world/WorldSim.gd, tests/attr_board_test.gd, tests/balance_harness_test.gd, tests/bout_read_test.gd, tests/fighter_model_bars_test.gd, tests/fighter_model_test.gd, tests/matchmaking_bots_test.gd, tests/world_years_test.gd, tools/fighter_bars.gd, tools/round_reports.gd, scripts/rules/FightWords.gd, scripts/rules/WeekPlan.gd, scripts/rules/TrainingWeek.gd, scripts/rules/InjuryRoll.gd, scripts/rules/PerkFight.gd, scripts/rules/PerkRoad.gd, scripts/rules/FighterProfile.gd, scripts/state/Data.gd, tests/attr_ten_test.gd
RED_TEST: tests/attr_ten_test.gd -> ATTR_TEN failures=0
REGRESSION: fighter_model, attr_board, bout_read, world_years, perk_fight, week_plan, training_week, save_load, golden_path_test
VISUAL: no

## Prior research
ops/research/S400_REVIEW/PRIMARY_ATTRIBUTES_S403.md and SKILLS_PROPOSAL_S404.md (both AGREED by the owner, the source of truth); ops/research/FIGHTER_MODEL_S397.md (what this branch built); ops/research/TASK_FIGHTERMODEL3C.md (the scouting audit, which comes back as 4B on this list).

## What would a human do?
A coach says "fast, strong, no gas tank, can't defend". That is a handful of plain qualities and a handful of craft skills. The punches themselves are a separate list of what the fighter has actually learned.

## Prefab check
None needed: this reshapes our own model.

## The owner's list (do not add, rename or merge)
PRIMARY, the same in every sport: strength, explosiveness, speed, stamina, recovery, flexibility, durability, fight_iq, composure, heart. Screen names: Strength, Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure, Heart.
BOXING SKILLS: accuracy, timing, defence, footwork, inside. Screen names: Accuracy, Timing, Defence, Footwork, Inside fighting.
MOVES: a punch is a move, kept in the existing move mastery. No attribute per punch and no attribute per hand.
Not bars: height, reach, stance, weight (facts), Aggression (the existing pace/forward dials), Cuts (a label).

## Do, in this order
1. tests/attr_ten_test.gd FIRST (prints `ATTR_TEN failures=<n>`): the bars below. It must fail on this branch as it stands.
2. scripts/rules/Attrs.gd keeps its shape with the new keys. The branch's 20 abilities map like this:
   - hand_speed + foot_speed -> speed. engine -> stamina. chin + body -> durability. ring_iq -> fight_iq. guard + head_movement -> defence. strength, recovery, composure, heart, accuracy, timing, footwork, inside keep their names. explosiveness and flexibility are new.
   - power stops being an attribute. Inside the fight, how hard a punch lands = strength and explosiveness + that punch's move level.
   - jab, straight, hooks, uppercuts stop being attributes. Duels reads the fighter's move mastery for that punch instead (the 0-100 mastery on the same scale). AttrGen gives opponents and world boxers move levels the same way it gave them these four numbers.
   - footwork is a stored, trained number. Nothing may work it out from Speed and Defence any more (RoundStyle and FighterProfile do today). A save with no stored footwork starts from the old mean once, then keeps its own.
   - LEGACY keeps the old seven as a summary so screens and saves still work: power <- strength + explosiveness; speed <- speed; technique <- accuracy + timing; defense <- defence; conditioning <- stamina + recovery; fight_iq <- fight_iq + composure; chin <- durability. The old seven stay exact at migration, as this branch does now.
3. Every attribute must really do something in the bout or the career:
   - explosiveness: the first shot of an exchange and knockdown chance.
   - recovery: energy back between rounds, and how fast weekly fatigue clears.
   - flexibility: the training and bout injury chance in InjuryRoll (lower when higher). No random number added.
   - durability: damage taken and standing counts; a stoppage loss lowers its ceiling by a small amount, so it wears down over a career.
   - composure: whether the plan holds while hurt. heart: getting up, holding on, going for the finish (as now).
4. Training: every attribute and skill except heart is raised by something in the week, with the existing cards where one fits: roadwork and intervals -> stamina; strength circuit -> strength; heavy bag -> strength and explosiveness; speed bag -> speed; slip rope -> defence; shadow -> footwork and accuracy; neck work -> durability; rest -> recovery; pads -> accuracy, timing and the drilled moves; sparring -> timing, defence, inside, fight_iq, composure. Add one new morning card, Mobility (flexibility, light load) in WeekPlan's ORDER and TrainingWeek. Heart is not trained.
5. Perks point at the new numbers: Iron chin Durability 70, Second wind Stamina 70, Stiff jab Accuracy 65, Counter sense Defence 65, Ring general Fight IQ 65, Finisher Explosiveness 70, Fast hands Speed 70. Body snatcher stays on its move.
6. Data.gd LABEL and AttrBoard show the new names. Rename keys inside tests/fighter_model_bars_test.gd and tests/attr_board_test.gd to match; do not change a threshold.

## Bars (tests/attr_ten_test.gd, seeded, headless, under 3 min, opponents different from the fighter in stats and style)
1. Attrs lists exactly the 10 primary + 5 skills above, and no key for a punch or a hand.
2. An old save with the old seven stats migrates and those seven read back exact.
3. For each of explosiveness, speed, stamina, strength, durability, fight_iq, accuracy, timing, defence, footwork, inside: +10 raises the bout win chance against a reference field by at least 0.01.
4. recovery +10: more energy at the start of later rounds AND fatigue clears faster. composure +10: a higher win chance in bouts where the fighter was hurt. flexibility +20: a training injury chance at least 10% lower. heart +10: more standing counts beaten.
5. Every attribute and skill but heart rises after 8 weeks of the card that trains it, and only the cards named in step 4 raise it.
6. Footwork differs from the mean of Speed and Defence after training, and a change to Speed alone does not move it.
If Explosiveness or Recovery cannot pass bar 3 or 4 without breaking another bar, STOP and put both numbers in the PR body: the owner's condition is that they do real work or they go.

## Not in this task
BJJ's six stats join this list later (one body in every sport). Kickboxing, Muay Thai and MMA have no engine. Rule 2 and the scouting audit come back as FIGHTERMODEL4B on this list, so do not run tests/matchmaking_bots_test.gd here. The screens get their new layout through the menu work, so change names only.

## Result lines (PR body)
RESULT: tests/attr_ten_test.gd -> ATTR_TEN failures=0
RESULT: +10 win chance per attribute <key x, ...>
RESULT: recovery <x> composure <x> flexibility <x> heart <x>
RESULT: regression <pass/fail per test>

## The one trap
Files stay under 500 lines; several here are close (Attrs, WorldBout, Duels), so split rather than squeeze. Do not draw extra random numbers in the career path or save_load and golden_path go red for no visible reason. No his/her in any words a player reads.

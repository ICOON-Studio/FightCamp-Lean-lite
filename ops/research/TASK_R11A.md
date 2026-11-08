# TASK R11A - QWEN (qwen3-coder) - an injury says why it happened

Status: OPEN (S403, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: mechanics row R11, "every random swing gets a readable reason" (critics 8+, the operator's build list, ops/research/S400_REVIEW/MECHANICS_DECISION_S402.md). The census docs/SWING_CENSUS.md ranks the training injury and the post-bout injury as its top two. No new screen and no change to any chance.
Start every Godot run through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`.

## Contract
OWNS: scripts/rules/InjuryRoll.gd, scripts/state/Injuries.gd, tests/injury_why_test.gd
RED_TEST: tests/injury_why_test.gd -> INJURY_WHY failures=0
REGRESSION: injuries_test, injury_roll_test, training_load_test, review_reveal_test, plain_words_test, save_load_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py swing reason injury`. J_STRESS_S206: players accept harsh swings when they can see and influence the cause. Operator S398: nothing on screen unless the player can act on it, so the reason names something the player controls whenever one applies.

## What would a human do?
A coach told "Lucy is hurt: a strained shoulder" asks "why?". The answer is one short clause: she jumped her hours, the week ran too hot, you pushed through the warning, or it was plain bad luck. Next week the coach changes that one thing.

## Prefab check
None needed.

## How it works today (read these first)
- scripts/rules/InjuryRoll.gd: `training_chance(hours, ratio, peak, risk)` multiplies load_mult(ratio) * fatigue_mult(peak) * risk. `bout_chance(damage)` reads head damage and rounds. Both are pure.
- scripts/state/Injuries.gd: `end_week` rolls training (line ~194; a second roll when a twist was answered "push through", WeekTwist risk 2), `_hurt(c, f, roll, "in training")` stores the injury, `new_this_week` builds the line the week review shows through ReviewReveal.headline ("%s is hurt: %s.").

## The rule
1. Add a pure `InjuryRoll.training_cause(ratio, peak, risk, pushed) -> String` returning one plain clause, picked in this order: pushed through ("you pushed through the warning"); else the larger of the load and fatigue multipliers when it is above 1.0 ("her hours jumped against her usual week", "the week ran her too hot"); else risk above 1.0 ("the floor and kit are poor"); else "plain bad luck, the load was fine".
2. Add a pure `InjuryRoll.bout_cause(damage) -> String`: "from the head shots she took" when head damage drove it, else "from the rounds she boxed". A KO keeps today's line.
3. `_hurt` stores the clause in the injury dictionary as "why". `new_this_week` ends with it: "<today's text>, <clause>". An injury saved before this change has no "why" and reads exactly as today.
4. Every number and chance stays unchanged: the seeded rolls must give the same injuries as before.

## Do
1. tests/injury_why_test.gd FIRST (prints `INJURY_WHY failures=<n>`). Run it on main: it must fail. Cover each branch of both causes, the order of rule 1, a real career (main.act("quick")) with an injury showing the clause in new_this_week, an old save without "why", and that training_roll's result for a fixed seed is unchanged.
2. Make it pass inside OWNS. Under 500 lines per file.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put what you measured in the PR body.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/injury_why_test.gd -> INJURY_WHY failures=0`.

## The one trap
Do not draw an extra random number anywhere: one more rng call shifts every later roll in the career, and save_load and golden_path go red for no visible reason. The fighters are not all women: use the game's own pronoun-free wording if plain_words_test or no_pronoun_test objects to "her" or "she" (then "the load jumped against the usual week").

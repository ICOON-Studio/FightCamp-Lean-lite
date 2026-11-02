# TASK LUDO-R17-MATH2 - club drill routes + auto-firing mastered cards as pure modules + data (Ludo round 17 sections 5-6) (cloud seat)

Operator S188 (board Q-S188-2/3): "yes all picks" (CLUBROUTES1, CARDAUTO1 among them). Ludo's build-ready design:
`research/LUDO_ROUND17_S193.md` part "Round 17b" SECTIONS 5 and 6 (his classes `ClubRoutes1`, `CardAuto1`) + the VERDICT at the end.
This task is ONLY the two pure modules, their JSON tables and one test; wiring comes later behind switches that default OFF.

## Owned files
- `Godot/assets/data/club_routes.json` + `Godot/scripts/rules/ClubRoutes.gd` (NEW) - Ludo SECTION 5, renamed class.
- `Godot/assets/data/card_autofire.json` + `Godot/scripts/rules/CardAutofire.gd` (NEW) - Ludo SECTION 6, renamed class.
- `Godot/tests/ludo_r17_math2_test.gd` (NEW) - extends SceneTree, prints `LUDO_R17_MATH2_TEST FAILS=<n>`, quit(1) on any fail.
- `AgentComms/messages/*` (your done note)
Every module: `extends RefCounted`, static funcs only, no nodes, no RNG (rolls are parameters), NO preloads of game scripts; it reads its
own JSON table (cached in a static var, like `Godot/scripts/PromoterTrap.gd`); no number in code that is in the table. Ludo's
`run_tests()`/`assert()` cases move into the test file. `class_name` only if a repo-wide grep shows no collision.

## Prior research
- `Godot/scripts/MoveCards.gd` (cards + mastery that already exist): CardAutofire takes a card's mastery as an INPUT number - it never
  stores cards itself and never duplicates MoveCards' data.
- `Godot/scripts/GymClubLayout.gd` (the club floor's station names/positions): ClubRoutes takes station ids + positions as INPUT
  (a Dictionary), never hard-codes the layout.
- House style: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd`.

## What would a human do?
Put Ludo's tables in JSON, one pure function per rule, test every number and every worked example he gave.

## Prefab check
N/A - our own rules.

## Acceptance (the test, from Ludo's numbers - not from your code)
- Every assertion in Ludo's `ClubRoutes1.run_tests()` and `CardAuto1.run_tests()` becomes a `_check` with the numbers in its message.
- ROUTES: a day plan of 3 stations gives a route through them in plan order with Ludo's colour per training type; an unknown training
  type gets his fallback colour; the route's animated progress at day-time t matches his formula at 3 sample times.
- AUTOFIRE: fire chance = mastery x ring IQ per his formula for two worked inputs; the cooldown blocks a second fire inside it; a 3-step
  chain reports "executed 2/3" when the third step's roll fails; over-use: after his threshold of fires the opposing-corner read flag is set.
- One JSON-edit case per module (change one table value in a loaded copy -> the output changes).
Mutants (each must FAIL; report FAIL counts in the PR): (a) autofire cooldown halved, (b) chain length 3 -> 2, (c) one route colour
swapped, (d) over-use threshold +1.
Run: parse each new .gd, then `--headless --path Godot --script tests/ludo_r17_math2_test.gd` -> `LUDO_R17_MATH2_TEST FAILS=0`, no SCRIPT
ERROR, no engine ERROR line. Push your branch, open a PR into master, never merge it, never touch other files, never delete or weaken an
existing test.

Model: cloud seat (Qwen qwen3-coder or Goose). Tier: new files only - parse + this test.

## The one trap
Ludo's text wraps numbers in LaTeX (`$0.35$`) - read the number. Godot JSON numbers are floats: compare with an epsilon.

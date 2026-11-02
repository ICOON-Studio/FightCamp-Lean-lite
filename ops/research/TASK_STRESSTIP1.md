# TASK STRESSTIP1 (S210) - the header STRESS tooltip names the REAL causes (pure module + test, Arena)

Model: Arena (cloud). Repo ICOON-Studio/FightCamp, your own branch, PR into master; never merge, never master.
Approved by the operator (board Q-S207-2 "Approve all", `research/LUDO_ROUND43_VERDICT_S208.md` section 5): the profile header's
STRESS mini-bar gets a tooltip like "STRAINED 62 - two hard weeks and a weight cut". Ludo's tooltips invented effects
("-5% composure"); ours must name the causes from the boxer's own stress log and the effects ONLY from our stress rules.

## Prior research
StressRules.gd (GAINS / RELIEF tables with categories, apply() keeps state["log"] = newest-first [{event, delta, total}] max 20,
band(), effects(affliction, virtue)), StressWeek.gd (one week -> events), tests stress_rules_test.gd / stress_week_test.gd.

## What would a human do?
A coach glancing at the bar wants one honest line: how bad, why (the two biggest causes in plain words), and what it is doing to him.

## Prefab check
None - project-specific text from our own tables.

## Build: NEW `Godot/scripts/rules/StressCauses.gd` (extends RefCounted, static funcs, no autoload, no scene, only preloads StressRules.gd)
- `causes(state: Dictionary, max_items: int = 2) -> Array`: from `state["log"]` take only GAINS entries (positive delta), group by the
  event's GAINS category (training / trauma / weight_cut / wear / career), sum delta per category, return up to `max_items` rows
  sorted by sum descending (ties: category name ascending), each {category, total (float), count (int), events (Array of event ids,
  most frequent first)}. Empty log or no gains -> [].
- `phrase(row: Dictionary) -> String`: plain English for a row from its events and count, e.g. hard_day x2 -> "two hard days",
  back_to_back -> "back-to-back hard days", overreach_week -> "an overreach week", loss_ko -> "a KO loss", loss_ud/loss_split ->
  "a decision loss", knockdown xN -> "a knockdown"/"N knockdowns", cut_3_5 -> "a weight cut", severe_cut -> "a severe weight cut",
  failed_weigh_in -> "a missed weigh-in", injury -> "an injury", withdrawal -> "a withdrawal", opponent_pullout -> "an opponent pull-out",
  broken_promise -> "a broken promise", ignored_request -> "an ignored request", inactive_week -> "a week without training".
  Numbers one..nine in words, 10+ as digits. A row uses its most frequent event's phrase (with its count).
- `tooltip(state: Dictionary) -> String`: "<BAND> <stress rounded> - <phrase 1> and <phrase 2>" (one cause: no "and"; none:
  "<BAND> <n> - nothing weighing on him"). BAND = StressRules.band() with "_" -> " ". If state has an affliction or virtue, append
  a second line "\n<NAME>: " + the effects from `StressRules.effects()` as short readable items in a fixed key order
  (e.g. "training gains x0.5, injury risk x1.25"; "_minus" keys -> "-N <stat>", "_plus" -> "+N <stat>", bool true -> the key in words).
  Never invent an effect that is not in effects().

## Test: NEW `Godot/tests/stress_causes_test.gd` (extends SceneTree, prints PASS/FAIL lines and "STRESS_CAUSES_TEST FAILS=<n>", exits 1 on fail)
Build every state THROUGH `StressRules.apply()` (never hand-write log rows), with two DIFFERENT composure values (e.g. 35 and 80):
1. Two hard_day + cut_3_5 -> causes() top row category "training", second "weight_cut"; tooltip contains "two hard days" and
   "a weight cut" and starts with the band and the rounded stress.
2. loss_ko + knockdown x2 -> one row "trauma", count 3, phrase from loss_ko ("a KO loss").
3. Only relief events (rest_day, win_ko) -> causes() == [] and tooltip ends "nothing weighing on him".
4. Ordering: a trauma total bigger than a training total puts trauma first even when training events came later.
5. State with affliction "OVERCOOKED" -> second line starts "OVERCOOKED:" and lists exactly the 4 keys of effects("OVERCOOKED","")
   with their values (assert each number appears); STEELED virtue likewise; no affliction/virtue -> single line.
6. The log keeps only 20 rows: apply 25 events -> causes() sums only what the log holds (assert the total equals the sum of logged deltas).
7. MUTANT CHECK: say in the PR that swapping the sort to ascending fails test 4, and that counting relief as a cause fails test 3.
Command: `godot --headless --path Godot --script tests/stress_causes_test.gd` (Godot 4.7.2; loads no LFS models - CI can run it).

## Owned files
- `Godot/scripts/rules/StressCauses.gd` (NEW)
- `Godot/tests/stress_causes_test.gd` (NEW)
Touch nothing else (no UI wiring - Claude does it).

## The one trap
GDScript: `var x := <call>` on a Variant-returning call fails to parse - type it (`var n: int = ...`); a variable name reused in one
function is a parse error even across blocks; `%` in a format string is `%%`. Do not delete or weaken any existing test.

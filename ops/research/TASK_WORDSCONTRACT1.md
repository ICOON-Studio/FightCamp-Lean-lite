# TASK_WORDSCONTRACT1 - blind contract test: the ring's words never disagree with the punches it plays (Arena)

Model: Arena (arena.ai Agent Mode), repo ICOON-Studio/FightCamp-Lean-lite (code-only mirror of FightCamp-Lean main),
branch main. Discipline: boxing (demo).

## Why
S303 shipped a corner card that said "works inside" while the film showed the jab landing - the words and the ring
disagreed. The round's beats come from `scripts/rules/RoundScript.gd` `build(...)`, the card from
`scripts/rules/CornerCard.gd` `summarize(beats)`, the combo captions from `scripts/rules/ComboWords.gd` `caption(...)`,
and each side's punch mix from `scripts/rules/RoundStyle.gd` (`of_fighter`, `from_opponent`, `punch_weights`).
Write ONE test, from the CONTRACT written in those files' header comments (`##` lines), that plays hundreds of seeded
rounds and proves they agree. Do not read the function bodies first - write the checks from the header contract, then
run them.

## Owned files (create / edit only these)
- `tests/fight_words_contract_test.gd` (new, extends SceneTree, same shape as `tests/combos_test.gd`: `_check(cond,
  label)` prints `PASS <label>` / `FAIL <label>`, last line `WORDSCONTRACT failures=<n>`, quit(1) on any failure).
- `tools/run_tests.sh`: add `fight_words_contract_test` to the list, before `golden_path_test`.
Never edit a file under scripts/. If a check fails on the real code, keep the check, print `FINDING <label> <numbers>`
instead of FAIL for that one check only, and list every FINDING in the PR body - a FINDING is the answer we need, not a
reason to loosen anything.

## Population (project rule: never test identical fighters)
Our fighter: a profile from `RoundStyle.of_fighter(f)` for two DIFFERENT fighters you build (different stats, combos
and moves - read `scripts/state/Data.gd` for the move ids and a fighter's keys). Opponents: every entry of
`Data.OPPONENTS` through `RoundStyle.from_opponent`. Rounds 1-3, winner a and b, margins close / clear / dominant
(build the round dict `{n, won, mine, theirs, corner, lines}` so `RoundScript.margin` gives each), at least 300 seeds.
Name the population in the test's first output line.

## Checks (from the contracts)
1. Landed counts per margin: close 4-3, clear 5-2, dominant 6-1 (+ the one knockback the header mentions) - winner first.
   Use `RoundScript.landed(script)`.
2. The winner lands the last landed punch of the round.
3. Beats are in time order; the last beat is at least 2 s before the bell (`seconds`).
4. Rounds 2+: the first two beats are thrown by our fighter and show the corner call.
5. `CornerCard.summarize(beats)`: for each side, the landed totals equal RoundScript.landed, and every move it lists as
   landed was a landed beat of that side; the card's top punch for a side is one with the most landed beats.
6. Style shows in the mix (over all seeds): a "Pressure fighter" or slugger opponent throws a larger share of hooks than
   an out-boxer opponent, and the out-boxer a larger share of jabs (if Data has no out-boxer, say so and skip).
7. `ComboWords.caption`: a combo caption appears only on a combo that landed whole in that round.

## Commands
Arena has no Godot: write the test carefully from the contract; CI runs it on the relayed PR in FightCamp-Lean.
(For reference: `godot --headless --audio-driver Dummy --path . --script res://tests/fight_words_contract_test.gd`.)

## Prior research
searched: corner card words disagree beats (S303 digest in the old repo: the opponent style mix fix f35e1b9). No earlier
contract test for the words.

## What would a human do?
A QA engineer writes the spec's promises as assertions and runs them over many generated cases (property-based testing),
then reports where the product breaks its promise.

## Prefab check
GUT / gdUnit4 add a framework the project does not use; plain SceneTree tests like the other 21.

## The one trap
GDScript: `var x := <call>` on a Variant-returning call is a parse error - type it (`var n: int = ...`); `%` in a format
string is `%%`; rule modules are loaded with `preload("res://scripts/rules/<X>.gd")`, Data with
`preload("res://scripts/state/Data.gd")`.

## Report
PR body: `RESULT: tests/fight_words_contract_test.gd -> WORDSCONTRACT failures=0` (CI proves it) and every FINDING.

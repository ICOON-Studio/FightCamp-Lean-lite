# TASK CORNERCONTRACT2 (S232) - the corner contract must PROVE an instruction applies at a real rest (Arena)

Model: any. Seat: Arena (cloud). Own branch + PR into master; never merge, never master. Never delete or loosen a check.
Plain `--script` tests are the OFF control arm (`-- as_game` turns GAME_ON features on).

## The red (Claude, master S232)
`godot --headless --path Godot --script tests/corner_instruction_contract_test.gd` ->
`FAIL: instructions_applied=0 ruleset=boxing must expose an explicit real-time refusal` (`C79 checks=16 failures=1`).
Red on every nightly since 10-14 (10-16 nightly at 9d320fd5).

## Why round 1 (CORNERCONTRACT1, Grok, issue 203) was REJECTED - read before you start
It made the gate pass by returning an "honest refusal" when the lab bout ENDS BEFORE ANY REST (a round-1 stoppage), so the
contract went green without ever showing a corner instruction applied. Claude's ruling: the FIXTURE must reach a between-round
rest; then the contract has to see `instructions_applied >= 1`. A refusal is only legal where the game really offers nothing.

## Do
1. Read `tests/corner_instruction_contract_test.gd` (~270 lines; `_check_realtime` ~60-90) and find how it builds the lab bout.
2. Make the bout reach the first between-round rest every time: pin the two fixture fighters (explicit stats - durable chins,
   modest power, high stamina - and DIFFERENT from each other, CLAUDE.md s5: never two identical fighters; same weight class,
   same sex) and/or the seed so round 1 goes the distance. Print in the test output the round the rest was reached.
3. At that rest drive the path the GAME runs since CORNERLIVE2 (4e8581f1): the live corner card on the 60 s clock
   (CornerPitStop cards -> `FightRealtime.apply_player_corner`). If `corner_button_for_test(side, index)` (grep the screen script
   that defines it) still looks for the old instruction buttons, point it at the card's pick button.
4. Add a CONTROL check in the same file: a bout that is stopped in round 1 (a mismatched pair) reaches no rest and must report the
   explicit refusal - so the refusal path stays honest and cannot stand in for the applied path.

## Acceptance
- `corner_instruction_contract_test.gd` -> `C79 checks=N failures=0` with N >= 17 and a printed `instructions_applied=` >= 1.
- These stay green: corner_live_card_test, corner_card_wired_test, corner_pit_stop_test, corner_call_effect_test,
  story_corner_wired_test. Paste every PASS line in the PR body.
- Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. `GameState.gd` / `FightRealtime.gd` are never read whole
  (grep + windows). No LFS in the sandbox: do not add a test that loads meshes.

## Prior research
CORNERCONTRACT1 (TASK_CORNERCONTRACT1.md + the S231 rejection in AgentComms/live_runs_archive.json), CORNERLIVE1/2 (S225 digest),
J55_THE_CORNER_BETWEEN_ROUNDS.md, CORNERCALL1B (S230).
## What would a human do?
Book two sturdy, evenly matched sparring partners so the round goes the distance, then give one instruction in the corner and
watch it change round 2 - and separately note that a first-round knockout leaves no corner to work.
## Prefab check
None - our own test fixture and seam.
## The one trap
A green that comes from the refusal branch is the round-1 rejection again: the applied count must be >= 1.

# CORNERCONTRACT1 (S230) - corner_instruction_contract_test red on every nightly since 10-14: the real-time corner hook drifted

Seat: Grok Dev (cloud, label `grok`). Own branch + PR into master; never merge, never master. Never delete or loosen a test.
Plain `--script` tests are the OFF control arm (`-- as_game` turns GAME_ON features on).

## The red (read on master 9b6a123a, S230)
`godot --headless --path Godot --script tests/corner_instruction_contract_test.gd` ->
`FAIL: instructions_applied=0 ruleset=boxing must expose an explicit real-time refusal` / `C79 checks=16 failures=1`.
The test (270 lines, `_check_realtime` ~line 60-90): opens the boxing lab bout, reaches the between-round rest
(`open_command_bar_for_test`), then asks `screen.corner_button_for_test("a", 0)`. It gets null, and no explicit refusal
is exposed either, so the contract reads "silent no-op".

## Why (Claude's read - verify it)
Since CORNERLIVE2 (S225, 4e8581f1) the real-time corner is the CORNER CARD on the real 60 s clock (CornerPitStop cards,
`apply_player_corner`), not the old instruction buttons that `corner_button_for_test` finds. The game works; the test's
seam points at a UI that is gone. Find the function the GAME runs at the real-time rest (trace FightNight.tscn's screen ->
the corner card -> FightRealtime.apply_player_corner) before you change anything.

## Do
1. Make `corner_button_for_test(side, index)` (in the screen script that defines it - grep it) return the live corner card's
   pick button for that side/index when the card is up, so the contract exercises the path players use.
2. If the real-time rest really offers no instruction for side "a" in this lab bout, expose the explicit refusal the test
   reads (`_has_explicit_refusal` - read what keys it accepts) instead. Never a silent no-op.
3. The test itself stays as is (it is the blind contract); a hook/seam fix only, plus the smallest code fix if the card is
   really missing.

## Acceptance
`corner_instruction_contract_test.gd` -> `C79 checks=N failures=0` (N >= 16), and these stay green: corner_live_card_test,
corner_card_wired_test, corner_pit_stop_test, corner_call_effect_test, story_corner_wired_test. Paste the PASS lines in the PR.

## Prior research
CORNERLIVE1/2 (S225 digest), J55_THE_CORNER_BETWEEN_ROUNDS.md, CORNERCALL1B (S230, measured every call).
## What would a human do?
A cornerman between rounds does one of the card's jobs or says "nothing to do"; the test asks for exactly that.
## Prefab check
None - this is our own seam.
## The one trap
Do not make the test pass by returning an "honest refusal" while the card IS offered - that hides the live path.

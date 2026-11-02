# TASK CARDAUTO1A - mastered cards fire on their exact opening, with a visible banner (engine half, switch `ludo_cardauto`, default OFF)

Model: cloud Codex (issue label `codex`, gpt-6-luna). Branch: the workflow names it. Never master, never HANDOFF.md, never AgentComms/.
Operator S188 ("yes all picks", CARDAUTO1): "Mastered card auto-fires on its exact opening with a visible banner (Ludo Q1.2); over-use gets
read by the opposing corner". Pure rules merged: `Godot/scripts/rules/CardAutofire.gd` (`evaluate_chain_trigger(...)`,
`calculate_fire_probability`) + `Godot/assets/data/card_autofire.json` (chains SLIP_CROSS_COUNTER on OPPONENT_LEAD_JAB, DUCK_HOOK_RIP on
OPPONENT_REAR_HOOK). REUSE them; never copy numbers into the engine.

## Owned files
- `Godot/scripts/FightRealtime.gd` (~9,300 lines - NEVER read whole; grep + `sed -n` windows). Anchors:
  - option pattern: grep `ludo_shouts` / `ludo_referee` (both merged) and copy it; do NOT add the switch to DEMO_SWITCHES (~1179).
  - the existing card machinery to sit beside (not replace): `_pad_chain_react` (~9195), `pad_routines`, `pad_card_progress` (set ~2252),
    `PadChains.mastery(...)`, and the counter-damage hook (~6170, `pad_counter`).
  - RNG: add a DEDICATED stream `_rng_cardauto` via `_stream(seed, <new SEED_ const>)` next to `_rng_shouts`; never draw from impact/decision
    so an un-fired fight is unchanged.
  - the log: copy how `shout` / `composure` entries are appended.
- `Godot/tests/card_autofire_live_test.gd` (NEW).

## Prior research
- `research/LUDO_ROUND17_S193.md` (card auto-fire section); the module and json above. Composure band: `ComposureMod.band(...)`
  ("Focused" when composure is off); a "Broken" band blocks (the module already returns BROKEN_COMPOSURE_BLOCK).

## What would a human do?
A well-drilled boxer slips the jab and fires the cross without thinking - and a corner that has watched him do it three times starts calling it.
The player sees a banner naming the move; the opponent starts to read it.

## Spec
1. With `state["ludo_cardauto"]` set (boxing only), when a fighter ATTEMPTS an action equal to a chain's `trigger_event` against the other man
   (map the engine's lead-jab / rear-hook action ids to OPPONENT_LEAD_JAB / OPPONENT_REAR_HOOK in one named table), call
   `CardAutofire.evaluate_chain_trigger` for the defender with his mastery for that chain's card (from `pad_card_progress`, 0 if absent),
   ring IQ, composure band, seconds since his last fire, his count this fight, three rolls from `_rng_cardauto`.
2. Result: log `{type: "cardauto", side, chain, steps_completed, banner_text, countered}`; on steps_completed == 3 apply `damage_mult` to the
   defender's counter using the SAME mechanism `pad_counter` uses (reuse, don't fork); on countered, the attacker's next hit on him is
   `PUNISH`-weighted as the json implies - if the engine cannot express it yet, log the intent and say so, never fake it.
3. OFF (switch off, or on but no card mastered): the fight log hash equals master's (print both in the test).

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/card_autofire_live_test.gd`.
- `card_autofire_live_test.gd`: two DIFFERENT boxers (name them); 6 seeds. Mastery 100 + high IQ fires over a jab-heavy opponent, mastery 10
  never fires (control arm that cannot share the bug); banner text present in the log; the 4th use in one fight can be read (countered
  rate rises vs the first); cooldown respected; switch ON with nothing mastered -> log hash = switch OFF. RED first on master (paste the
  count), then green. Do NOT pin a hash literal - compare ON vs OFF in the same run.
- `python Godot/tools/run_tests.py --only card --jobs 2` and `--only pad --jobs 2` -> 0 fails.
Final message: red count, green results.

## The one trap
`_pad_chain_react` already fires for the same trigger actions: a man with a pad routine AND a mastered card must not fire both on one jab.
Check `_pad_pending` / `_pad_ready_s` first and let the pad routine win; test it.

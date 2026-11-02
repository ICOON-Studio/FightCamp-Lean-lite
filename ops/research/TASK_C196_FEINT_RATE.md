# TASK_C196 - FEINTS slice two: the RATE (Codex, engine build)

Model: gpt-5.6-luna, medium (engine logic, not motion). Owner: codex. Assigned S70, 2026-09-24. Engine lane.

## Why
S70 shipped FEINTS slice one behind the realtime option `feint` (default OFF): a feint can draw a reaction, queue a lifted
follow-up, and decays when unanswered (`Godot/scripts/FightFeint.gd`, whole file is small - read it; your own C195 blind test
`tests/fight_feint_blind_test.gd` covers it). The measured gap (`research/S70_DIGEST.md` "Gate", the table): fighters
throw **~0.5 feints per man per minute** against Grok G86's gate bands (`research/G86_FEINTS.md` section 6):
boxing 6-14/min (counter styles upper half, pressure lower half), kickboxing/Muay Thai 4-10, MMA 3-8 at distance (lower in
the clinch). Feints are a thin slice of `FightMoves.select`'s palette (only `boxing_feint`, `boxing_distance_read`,
`kickboxing_switch_step_read` carry the feint effect words), so they are rarely picked.

## Build (DECIDED)
Behind the SAME `feint` switch (OFF must stay byte-identical - no new draw on `_rng_impact`, no change to `Moves.select`'s
result when the switch is off):
1. With `feint` ON, raise the selection weight of feint nodes (the arsenal entries with `feint: true`) by a per-ruleset factor
   so the delivered rate lands in G86's band for the discipline. The factor lives as a named, labelled constant table in
   `FightFeint.gd` (AUTHORED, fitted to G86's GATE band - say so), not an inline literal.
2. Style: the counter-puncher / counter-striker plans feint more than pressure plans (G86: counter ~upper half, pressure
   ~lower half). Read the plan off the fighter the engine already carries; do not invent a new stat.
3. MMA: feints only at distance (standing, not clinched) - the clinch rate stays as is.
4. Do NOT touch the reaction chance, lift, window or decay.

## Measure
`Godot/tools/s70_feint_probe.gd -- bouts 20` (extend it with an MMA row: striker `kickboxing_counter_striker` vs grappler
`wrestling_attack_rate`, different stats/frames). Print per-MAN feints/min beside G86's band per discipline, and re-print the
reaction share / follow-up lift / decay columns - they must not collapse (more feints -> more unanswered -> more decay is
expected; report it). Gates are BANDS: landing inside is the goal; report where it lands.

## Owned files
`Godot/scripts/FightFeint.gd`, the `Moves.select` call site in `Godot/scripts/FightRealtime.gd` (~5,700 lines - NEVER open it
whole; `grep -n "Moves.select\|_feint_"` and read `sed -n 'A,Bp'` windows), `Godot/scripts/FightMoves.gd` only if the weight
must be applied inside `select` (grep `static func select`), `Godot/tools/s70_feint_probe.gd`, `Godot/tests/fight_feint_test.gd`
(add a rate check), `research/C196_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. OFF byte-identical: run `tools/s70_feint_off_hash.gd` on master
before your change and after it - the HASH lines must match exactly. Then `tests/fight_feint_test.gd`,
`tests/fight_feint_blind_test.gd`, `python Godot/tools/run_tests.py --only fight_commit`, `--only fight_realtime`,
`--only fight_moves` (ONE `--only` per run; read `total=`). Ceiling: no new red vs master. No full suite.
Branch `codex/c196-feint-rate` off `origin/master` (merge `origin/codex/c195-blind-feint-test` into it first - your blind
test is not on master yet). Commit with explicit paths, push,
`python Tools/agent_comms.py send --from codex --to claude --topic C196 --body "<factor table, per-man feints/min vs band per discipline, reaction/lift/decay after, OFF hash identical?>"`.
Do NOT edit or read HANDOFF.md, CURRENT_STATUS.md or digests other than S70's and G86.

## The one trap
Fitting a weight until the number lands is only honest if the number is labelled a fit to a GATE band that G86 itself says
is NOT FOUND in-fight. Say that in the constant's comment, and never tune the reaction chance to rescue the lift.

# TASK_C192 - a BLIND contract test for the manager contract (Codex, test only)

Model: gpt-5.6-luna, medium (text/contract test, not motion). Owner: codex. Assigned S67, 2026-09-24.

## Why
S67 shipped `Godot/scripts/ManagerContract.gd` and wired it through GameState. Claude wrote its tests against Claude's own
implementation, so they only ever agree with it. A test written from the RULES alone, by a second hand that has not seen
the code, is what finds defects in the contract (it did for C142 and C152). **DO NOT OPEN `ManagerContract.gd`,
`Godot/tests/manager_contract_test.gd`, `research/S67_DIGEST.md` or the S67 commits.** You may read the files below.

## The rules (the contract - test these, not an implementation)
Read `research/G71_THE_MANAGER_CONTRACT.md` sections 1, 4 and 5, `research/J4_THE_DESK_AND_THE_CUT.md`
assertions E19-E24 (grep `^| \*\*E2`), and `Godot/assets/data/manager_share_caps.json`. The public API (exact names):
- `ManagerContract.share_cap_percent(jurisdiction: String) -> float` - the most a filed share may be, % of gross.
- `ManagerContract.max_term_weeks(jurisdiction: String) -> int` - statutory maximum term, in weeks (52 per year).
- `ManagerContract.is_manager_share(share_percent: float, jurisdiction: String) -> bool` - the E3/E24 manager line.
- `ManagerContract.answer(proposal: Dictionary, terms: Dictionary) -> Dictionary` - proposal `{share_percent,
  jurisdiction, term_weeks}`, terms `{weekly_salary, market_salary, loyalty (0-100), expected_purse,
  weeks_between_bouts}`; returns `status` in `accepted` / `countered` / `refused` / `illegal`, plus `reason`
  (a non-empty string), `counter_percent` when countered, `wage_to_sign` (int) when refused or countered.
- `ManagerContract.build_contract(athlete_id, share_percent, jurisdiction, signed_week, term_weeks) -> Dictionary` with
  `expires_week` and `manager_licensed`; `ManagerContract.is_active(contract, week) -> bool`.
- Live: `GameState.propose_manager_contract(athlete_id, share, jurisdiction, term_weeks)`,
  `GameState.raise_athlete_wage(athlete_id, weekly)`, `GameState.get_manager_contract_view(athlete_id)`; a filed share is
  paid to the gym on a bout and a gym ledger read exposes it.
Behavioural rules you may rely on (the DEFINITION, not the formula): no default percentage anywhere (E2); the statute is
checked before the fighter, so an over-cap share or over-long term is `illegal`, never `refused`; a fighter paid more
relative to market, or more loyal, will accept at least as much as one paid less or less loyal (monotone); paying him
exactly `wage_to_sign` makes the same proposal no longer `refused`; a contract is collectable from its signing week and not
at or after `expires_week`; with no contract the gym is paid exactly 0 of a purse (E23).

## Deliverable
`Godot/tests/manager_contract_blind_test.gd` - statute (every jurisdiction in the caps file, derived from the FILE, never
copied), monotonicity sweeps, the illegal-before-refused order, `wage_to_sign` round-trip, expiry edges, E23, and one live
settlement. Then break the module 5 ways by INJECTION in a throwaway copy (never commit a mutant) and report each caught.
If a test fails against the shipped module, DO NOT change the test to pass: report it as a candidate defect with the rule
it breaks. Mutant diagnostics must not use the runner's words (`FAIL`, `failures=N`, `N failure(s)`) - use `checks_failed=`.

## Gate (tier: a NEW test file only)
Parse gate on the test, run that ONE test. No suite. Branch `codex/c192-blind-manager-test` from origin/master, commit the
test and `research/C192_DIGEST.md`, push, one `python Tools/agent_comms.py send --from codex --to claude --topic C192`.
Do NOT edit HANDOFF.md.

## Trap
`callv` with the wrong arity returns `{}`, not null - an `if result != null` check passes and measures nothing. Assert a
real key on every result.

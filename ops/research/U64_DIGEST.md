# U64 DIGEST — blind catalogue contract test

- New: `Godot/tests/technique_catalogue_contract_test.gd` only. No scripts or catalogue edited.
- **UNRUN** — Claude holds Godot for the S1 merge; no parse gate, no test, no suite.
- Test reads `technique_catalog.json` + `combat_rulesets.json` from disk; asserts shape,
  global id uniqueness, contract-five roles, `move`/`combination` kinds, tier 1..N gaps,
  same-discipline prereqs, acyclic DAG, combination→move chain refs; reachability is report-only.
- Greppable lines: `U64 nodes=…`, `U64 tier_gaps=…`, `U64 unreachable_…`, `U64 RESULT failures=…`.
- Static read of pre-merge v5 catalogue (272 nodes): expect `bad_kinds=94` (55 `skill` + 39
  `sequence`), `bad_roles=133` (legacy roles like counter/takedown/submission), `dup_ids=0`,
  graph checks likely clean; `unreachable_disciplines=7` (wrestling, sanda, savate, capoeira,
  arnis, pencak_silat, mma — no ruleset names them verbatim). Post-merge numbers are the point.

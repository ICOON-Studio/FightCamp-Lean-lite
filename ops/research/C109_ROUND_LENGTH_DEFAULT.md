## DECISIONS

**C109 - the engine books the ruleset's own round length** (operator ruling ROUNDS, 2026-09-13: "Use ruleset's
length"). The change is Codex's, exactly as the task file specified (`FightRealtime.begin`: `round_seconds` /
`rest_seconds` fall back to the ruleset dictionary before `FightClock`'s 300 s / 60 s; an explicit option still
wins; `rounds` untouched). **Collected and gated by Claude**: Codex's session stalled on a one-second git call,
and its sandbox could not produce a valid gate - every test tripped `ERROR: Failed to read the root certificate
store.` at boot (280 of 280 "failed" while each printed its own 0 failures), and `git checkout` was refused
(`.git/index.lock`). `run_tests.py` now treats that exact line as host chatter.

- **Before** (baseline at `56d498d`, the task's): `SUITE total=280 fails=4` - athlete_development, fight_realtime,
  fight_scoring, fight_stage_realism (red by design).
- **After, with the change** (Claude, main checkout, no agent in Godot, `--jobs 2`): `SUITE total=280 fails=5` -
  the four plus `grapple_adapter_test.gd`.
- **Proven this change's:** grapple_adapter_test fails with C109 and passes (`total=1 fails=0`) on HEAD's
  `FightRealtime.gd`; the file was copied aside and back, never stashed.
- **After the re-pin:** grapple_adapter_test `total=1 fails=0`, so the suite is the baseline four. (A re-pinned
  test file cannot move another test, so no second full run.)
- **Baseline failures unchanged:** athlete_development, fight_scoring and fight_realtime print byte-identical
  FAIL lines with and without C109 (the realism test's live room already passed its round length).

| test | assertion | old | new | why the round length moves it |
|---|---|---|---|---|
| grapple_adapter_test | MT witness seed (one throw, unanimous decision) | 93248 | 93003 | three 180 s muay thai rounds instead of 300 s: 93248 now ends by SUBMISSION, no card; re-found with the same sweep (`tools/find_r102_seeds.gd -- mt`, 17 hits), the first taken |
| grapple_adapter_test | MT striking per round, a / b | 39.31, 29.20, 28.91 / 19.61, 14.15, 13.74 | 27.54, 19.05, 16.41 / 7.94, 8.02, 12.33 | shorter rounds, a different bout |
| grapple_adapter_test | MT card | 30-24 x3 | 30-25 x3 | the three candidates printed return 30-25, 30-24, 30-24 - pinned as found |

Not re-pinned: nothing else moved.

**ENGINE FINDING, surfaced by the re-find and NOT pinned into the witness:** the same sweep counted every method -
**400 muay thai bouts (Grappler vs Fish, 3 x 180 s): SUBMISSION 150, KO 51, DECISION 198, TKO 1.** Muay thai has
no ground fighting and no submissions (the engine's stall stand-up is the same two-stage clock for every ruleset
but judo, `FightRealtime.gd` ~2386). Measured across the four styled rulesets as Q90; the rule texts as K36.

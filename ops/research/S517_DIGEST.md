# S517 digest (2026-11-18, main line, Opus)

Commits: 6e77649bc (code), handover commit after it. Build exported (WHAT_TO_TRY S517).

## Evidence
- LADDERPROBE1 (Qwen #370) ran before the idle clock; rerun on main = docs/LADDERPROBE2_RESULT.md: with the clock our
  novices drained to ~1 point (Lucy median 40 -> 1 by day 728) because in 23 of 30 runs every sheet name had passed 10
  bouts (no legal name, no bout ever again).
- Control arm for golden_path: with newcomers off 0 failures, on 9 (the other boxer's new legal offer blocks fight night
  as NEEDS YOU) - the test now answers it.

## Built
- scripts/state/Newcomers.gd (sheet / arrive), wired into Bouts, AskFlow, HomeBout, PullOutWire. tests/newcomers_test.gd.
- Region._free_week: map R8 free week for the idle clock.
- scripts/state/LadderSeason.gd: 1 Jan final tables (c.seasons), Records line, LAST SEASON on World > Rankings.
  tests/ladder_season_test.gd.
- PullOutWire.weigh_miss: no night re-match past WeighGap.gap_kg (home_bout_test red since S513, now green).

## Delegated
- Goose #372 RIVALOFFER1 (R9 offers + DUCKED/OWED pure rules), Goose #371 + John SQ222 critics club week v11,
  Qwen LADDERPROBE3 (wt/LEAN_LADDERPROBE3). Guard v3 critics John SQ221 + Goose #369 from S516.

## Next
NEXT_SESSION_PROMPT.md "MAIN LINE - DO FIRST".

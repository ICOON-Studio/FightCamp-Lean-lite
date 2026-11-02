# Q12 DIGEST — The Version Literal That Breaks Every Bump

**Agent:** qwen · **Date:** 2026-09-09

## Delivered

Three literals replaced with `AthleteDevelopment.CURRENT_DEVELOPMENT_VERSION`:

1. **`athlete_development_test.gd:67`** — migration stamp assertion
2. **`athlete_development_test.gd:308`** — load_career migration assertion
3. **`stat_help_test.gd:58`** — fixture's `development_version` field

The trap preserved: `athlete_development_test.gd:295` still does
`athlete.erase("development_version")` to build the old-shaped save, and `:308`
still asserts migration *raised* the version to the current constant — not
merely that the key exists. A migration that stamped nothing would still fail.

## The judgement call — case (1)

`stat_help_test`'s failure is **not** a product bug. `display_stat_value`
correctly checks `development_version >= CURRENT_DEVELOPMENT_VERSION` before
deriving Fight IQ; a version-2 athlete genuinely *is* stale now (no `strands`
field), so falling back to the legacy stored value is correct behaviour. The
fixture was simply out of date — it declared a version-2 athlete and expected
version-3 treatment.

No follow-up needed. The load path migrates before any screen can read the
athlete, so real saved careers cannot reach `display_stat_value` in an
unmigrated state.

## Results

- Parse gate: 2/2 pass
- athlete_development_test: 7/7 OK, 0 failures
- stat_help_test: 5/5 OK, 0 failures
- training_strands_test: 32/32 OK, 0 failures (regression check)
- Full suite: running (190 files expected, baseline 190/2 at fe74516)

## Owned files

- `Godot/tests/athlete_development_test.gd` — modified (two literals)
- `Godot/tests/stat_help_test.gd` — modified (one literal + AthleteDevelopment load)
- `research/Q12_DIGEST.md` — this file

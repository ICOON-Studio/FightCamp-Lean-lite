# R70 DIGEST — The belt that should not exist

**Agent:** claude · **Landed:** 2026-09-08 · **Source ruling:** C46
(`C46_THE_BELTS_OWNER.md`), items 1, 2 and 4. C46 item 3 (the
`org_id|discipline|weight_class|sex` key reshape) stays out, as the task
required.

## What changed

**1. Belt eligibility is a catalogue fact.**
`championship_rules.json` (version 1 → 2) gains `belt_authority`: a CLOSED
table of discipline → who owns the title, in three values.

| value | meaning | disciplines |
|---|---|---|
| `promotion` | a house belt somebody carries and defends on the next card | mma, kickboxing, muay_thai, karate |
| `sanctioning_body` | a ratings authority separate from the promoter | boxing |
| `event` | won on a date, medal handed out, nobody carries it | wrestling, judo, brazilian_jiu_jitsu, taekwondo, sanda, sambo |

`belt_authority_default` is `event`, so a discipline nobody has authored
evidence for bears no belt. `WorldPopulation.belt_authority()` and
`discipline_bears_belt()` are the only readers; `BELT_AUTHORITY_FALLBACK`
mirrors the table for a build with no data file, the way `championship_rule()`
already carries its fallback.

**2. Event disciplines seed nothing, and boxing takes no substitute.**
`ensure_championships` skips a non-belt-bearing discipline while grouping, so
the division never reaches the three-contender test.
`sanctioning_organization_id` now returns `""` for any discipline whose
authority is not `promotion` — which is what stops a generated market
association, eligible only because it carries positive local
`discipline_weights`, from being printed as the authority behind a boxing world
title. The gate is about who owns the TITLE, not about disqualifying generated
promotions: the same association still sanctions MMA.

**3. A save migration that retires, never deletes.**
`_retire_event_discipline_belts` moves every event-discipline belt WHOLE out of
`championships` and into a new `population["retired_championships"]`, keeping
holder, `since_week`, `defenses` and whatever promotion an older build stamped
on it, adding `title_status = "retired"`, `retired_reason =
"event_discipline"` and `retired_by_schema`. `GameState.get_retired_championships()`
is the copy-safe read.

It stops being defendable for one reason and not by a new exclusion rule: every
booking, settlement, interim and double-champ path reads `championships` and
nothing else. **No retirement week is stamped** — nothing happened in the world
on the week the save was loaded, and dating a catalogue correction would be
inventing a fact.

## The version decision, and why

**A new `CHAMPIONSHIP_SCHEMA_VERSION := 2`, NOT a `SCHEMA_VERSION` bump.**
`SCHEMA_VERSION` is a world-REGENERATION gate: `GameState.ensure_world_population()`
(`GameState.gd:241`) compares it and, on a mismatch, calls
`WorldPopulation.generate()` and replaces `career["simulation_world"]` outright.
Bumping it to correct a belt would throw away every career, athlete, event and
ranking in every existing save — the exact opposite of a migration that is
supposed to preserve a career. The championship model therefore carries its own
version beside it, stored as `population["championship_schema_version"]`, and
this migration is its only reader.

It is version-gated, so it runs ONCE per save. Retirement repairs belts already
written; the seeding filter is what keeps new ones from appearing. A test that
deliberately inserts an event-discipline belt after the repair keeps it, which
is correct.

## The trap, asserted rather than assumed

R68's CHAMPIONS board builds its discipline chips from the belt KEYS
(`RankingsHubPanel._champ_disciplines()`), so a retired belt left in
`championships` would leave a chip standing over an empty board. That is why
retirement moves the row OUT rather than flagging it in place, and
`championship_read_test` repeats the panel's own fold — the distinct disciplines
across every key — and asserts no event discipline survives it, in
`get_championships()` and in `get_championships_read()`.

## Measured effect

A fresh Cyprus career, same seed, before and after:

```
before: 55 belts — boxing 12, brazilian_jiu_jitsu 8, judo 5, kickboxing 6,
                   mma 9, muay_thai 6, sanda 2, taekwondo 1, wrestling 6
after:  33 belts — boxing 12, kickboxing 6, mma 9, muay_thai 6
```

The eight BJJ belts were being stamped to ONE Championship — a promotion that
really does run submission grappling, presented as the authority behind an
IBJJF-shaped world title. They are gone. Boxing keeps its twelve belts and its
empty `organization_id`, which is now a guarantee rather than an accident of
this world's organization list.

## Files

`Godot/assets/data/championship_rules.json`, `Godot/scripts/WorldPopulation.gd`,
`Godot/scripts/GameState.gd`, `Godot/tests/championship_read_test.gd`,
`Godot/tests/titles_rankings_test.gd`.
`real_organizations.json` was NOT touched — `karate_combat` is already a
promotion and `ijf`/`united_world_wrestling`/`world_taekwondo` are already
federations, and U12 is live on that file.

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/titles_rankings_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd
```

championship_read 30/0 (21 → 30 checks), titles_rankings 0 failures,
rankings_hub_panel 95/0.

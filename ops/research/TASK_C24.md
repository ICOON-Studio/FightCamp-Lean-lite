# TASK C24 — THE ORGANIZATION READ API (Codex)

**Status: COMPLETE 2026-09-06** (commit `11cb76e`, gate pass). R39 shipped first, as required — this read calls `Sanctioning.gd`,
which R39 creates. Read the contract below and plan against it; do not start
the implementation until `Godot/scripts/Sanctioning.gd` is on `master`.

Model: Sonnet, effort medium, Fast off. This mirrors a pattern you have built
twenty times (C4, C7, C19, C20, C23) — one read, no writes, no UI.

## Why this exists

The game ships 18 real organizations and, after R39, knows which rules each
one fights under. Nothing can ask it. Every screen that wants to say "this is
a RIZIN card, here is what that means" would have to hand-assemble it from
`real_organizations.json`, `combat_rulesets.json`, the event list and the
player's contract state — four sources, in a scene script, four times over.

One read, the way C23 did it for the post-fight screen.

## What to build

In `Godot/scripts/GameState.gd`, in the read-API region alongside the other
`get_*_read` functions:

```gdscript
func get_organization_read(organization_id: String) -> Dictionary
func get_organizations_read(country_name: String = "") -> Array
```

`get_organization_read` returns, for one org:

| Key | Contents |
|-----|----------|
| `id`, `name`, `short_name`, `country`, `tier`, `reputation` | identity, straight off the catalog |
| `entity_type` | `promotion` \| `federation` \| `tournament_operator` |
| `entity_label` | the human line from the catalog's own `entity_types` block — do **not** write your own copy |
| `disciplines` | the org's discipline list |
| `rules` | one row per discipline: `{discipline, ruleset_id, ruleset_name, competition_ruleset_id, authority, evidence, fallback}`, each from `Sanctioning.rules_for()` — never re-derived |
| `rounds` | per discipline, `{rounds, round_seconds, rest_seconds}` off `combat_rulesets.json` |
| `events` | upcoming events for this org: `{id, name, week, venue, discipline, status}`, soonest first |
| `standing` | the player's relationship: `{signed, goodwill, bouts_taken, last_result}` — empty dict when there is none |
| `official_url`, `source` | already on the catalog |

`get_organizations_read` returns the same rows minus `events` and `rounds`,
country-filtered the way `get_world_organizations()` (`:585`) already filters.

## Rules

- **Read only.** No writes to career, world or save. No new state.
- **Never re-derive the rules.** `Sanctioning.rules_for()` is the single
  answer; if a field you want is not on it, say so in your report rather than
  computing it a second way here.
- **Empty, not fabricated.** An org with no upcoming event returns `events: []`.
  An `evidence` of `UNKNOWN` is passed through as `UNKNOWN` — do not soften it
  into a guess. C23's honest-empties rule.
- No UI, no scene script, no copy-writing beyond passing the catalog's own
  strings through.
- Do not touch `Sanctioning.gd`, `real_organizations.json`, or anything R38
  owns (`JudgePanel.gd`, `RoundScoring.gd`, `_close_round`, `_finish_fight`).

## Anchors

- The pattern to mirror: `get_post_fight_read` (C23) and
  `Godot/scripts/PostFightRead.gd` — a pure module doing the shaping, a thin
  `GameState` accessor in front of it.
- `Godot/scripts/GameState.gd:585` `get_world_organizations(country_name)`,
  `:594` `get_world_organization_by_id`, `:2505` `get_ruleset`.
- Events live on the population: `Godot/scripts/WorldPopulation.gd:103-104`
  (`organizations`, `events`), each event carrying `organization_id`,
  `discipline`, `scheduled_week`, `venue`, `status`.
- Goodwill: `GameState.gd:2217,2247` `_promoter_goodwill(organization_id)`.
- The contract R39 gives you: `research/TASK_R39.md` Stage 1.
- The rules themselves, if you want to know what a field means:
  `research/J1_ORGANIZATION_RULES_AND_JUDGES.md` §0.

## Owned files

```
Godot/scripts/OrganizationRead.gd     (new, pure — the shaping)
Godot/scripts/GameState.gd            (the two accessors only)
Godot/tests/organization_read_test.gd (new)
```

## Parse gate

```bash
python Godot/tools/check_scripts.py Godot/scripts/OrganizationRead.gd Godot/scripts/GameState.gd
```

## Test

| ID | Assertion |
|----|-----------|
| O1 | All 18 orgs return a read; none is empty; an unknown id returns `{}` |
| O2 | `rules` matches `Sanctioning.rules_for()` exactly for every org × discipline — no second derivation |
| O3 | The three `entity_type` values all appear across the 18, each with the catalog's own `entity_label` |
| O4 | An org with no upcoming event returns `events: []`, not a placeholder |
| O5 | `evidence: UNKNOWN` survives the read unchanged |
| O6 | The read performs no writes: world and career are byte-identical before and after |

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/organization_read_test.gd
```

Then `real_organizations_test.gd` and `sanctioning_test.gd` unchanged.

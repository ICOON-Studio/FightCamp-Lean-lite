# TASK R39 — THE SANCTIONING SPINE (Claude)

**Status: COMPLETE (2026-09-06).**

Model: Opus, effort high, Fast off.

Option A of the operator's 2026-09-06 call, half one. J1's **D1**. R40 (the
entity-type pathways) is half two and is not written yet; it waits on **J2**.

## Why this exists

An event record already carries `organization_id` — `GameState.gd:7521`,
and it is read all over for purse, goodwill and rankings. The rules do not
come from it. They come from the discipline:

```
event.organization_id  ->  money, ranking, goodwill  ->  dead end for rules
event.discipline       ->  WORLD_DISCIPLINE_RULESET (GameState.gd:94)
                       ->  combat_rulesets.json  ->  scoring_profile
```

So a UFC card and a RIZIN card in the same slot resolve to the identical
`mma` profile. The organization is sitting on the record, unread.

## The one rule this stage exists to establish

**R39 changes no fight outcome.** Every organization must resolve to exactly
the ruleset `WORLD_DISCIPLINE_RULESET` gives it today. This is a spine, not a
rebalance. If a seeded bout's result moves, the stage is wrong.

That is also what makes it safe to land next to R38.

## Stage 1 — `Sanctioning.gd` (new, pure, stateless)

New `Godot/scripts/Sanctioning.gd`, shaped like `RoundScoring.gd`:
`extends RefCounted`, statics only, no node access, no RNG.

```gdscript
static func rules_for(organization: Dictionary, discipline: String, overrides := {}) -> Dictionary
```

returns:

| Key | Meaning |
|-----|---------|
| `ruleset_id` | the **playable** id in `combat_rulesets.json` (`mma`, `boxing`, …) — what the sim reads |
| `competition_ruleset_id` | the **researched** id in `competition_rulesets_v2.json` (`mma_abc_professional`, …) — evidence, not runtime |
| `authority` | who the rules actually come from (`"ABC / state athletic commission"`, `"IJF"`, …) |
| `evidence` | `DIRECT` \| `INHERITED` \| `UNVERIFIED_SECONDARY` \| `UNKNOWN`, per J1 §0 |
| `fallback` | `true` when the org had no binding and the discipline map answered |

`overrides` is the per-event hook (a tournament night under different rules).
It is read in this stage and **written by nobody** — R40 and P1+ fill it.

Resolution order: `overrides.ruleset_id` → the org's `ruleset_ids[discipline]`
→ the org's `default_ruleset_id` → `WORLD_DISCIPLINE_RULESET[discipline]`
→ `"mma"`. The last two set `fallback = true`.

## Stage 2 — the catalog fields

`Godot/assets/data/real_organizations.json`, per organization, from **J1 §0's
binding table** (`research/J1_ORGANIZATION_RULES_AND_JUDGES.md`) — do not
re-research, do not invent:

```json
"default_ruleset_id": "mma",
"ruleset_ids": {"mma": "mma", "muay_thai": "muay_thai"},
"competition_ruleset_id": "mma_abc_professional",
"authority": "ABC Unified Rules / state athletic commission",
"evidence": "DIRECT"
```

Every MMA org binds `default_ruleset_id: "mma"` in this stage — that is the
point. The **researched** id is where UFC and RIZIN already differ, and P1–P5
change the playable id later without touching this schema.

Where J1 says MISSING (ONE, RIZIN, GLORY, Karate Combat, RWS): keep the
playable binding, set `competition_ruleset_id` to `""`, `evidence` to
`UNKNOWN`, and leave a `note`. Do **not** author `mma_one_global` here.

Bump `catalog_version` to `2`. Leave `schema_version` and `snapshot_date`
alone — the identity snapshot has not been re-taken.

## Stage 3 — stamp it, don't re-resolve it

The resolved `ruleset_id` goes onto the **event and each bout when the event
is created**, never at sim time. A later rules change must not silently
re-score fights already in a player's career (J1 §2.3, Saves).

- `WorldPopulation.gd` `merge_real_organizations()` (`:174-231`) — the opening
  event each merged org receives.
- `GameState.gd` the Grand Prix event record (`:7519-7545`).
- `GameState.gd` `get_world_bout_contract()` (`:727`, `:732-733`) — read
  `bout.ruleset_id` / `event.ruleset_id` when present, and fall back to
  `WORLD_DISCIPLINE_RULESET` when absent. **The fallback is the save
  migration**: every event already in a save has no stamp and must keep
  scoring exactly as it does today.

Do not touch `selected_ruleset_id` (`:164`, `:2683`, `:3191`) — that is the
exhibition picker, a different thing.

## What NOT to do

- **No entity_type behaviour.** Federations still hand out promotional
  contracts after this stage. That is R40, and it is wrong on purpose until
  J2 lands.
- No new researched ruleset ids (`mma_one_global`, `kickboxing_glory`, …).
  J1 P1–P5.
- No judge work — R38 owns `JudgePanel.gd`, `RoundScoring.gd` and
  `_close_round`. If R38 has not landed, R39 still goes in: the two touch
  different files.
- No UI. C24 builds the read; nobody draws it yet.
- No change to any `scoring_profile` number, and no edit to
  `competition_rulesets_v2.json`.

## Anchors

- `Godot/scripts/GameState.gd:94` `WORLD_DISCIPLINE_RULESET` (15 disciplines
  → 11 rulesets); `:585` `get_world_organizations` (country filter only);
  `:594` `get_world_organization_by_id`; `:727` the bout contract's ruleset;
  `:7519-7545` the GP event record.
- `Godot/scripts/WorldPopulation.gd:174-231` `merge_real_organizations` —
  "organizations receive deterministic ids and their own opening event";
  `:254` copies `entity_type`.
- `Godot/assets/data/real_organizations.json` — `schema_version`,
  `catalog_version`, `snapshot_date`, `brand_assets_policy`, `entity_types`,
  `market_assignments`, 18 `organizations`.
- The binding table to copy from: `research/J1_ORGANIZATION_RULES_AND_JUDGES.md`
  §0, one row per org, with its evidence grade already decided.

## Owned files

```
Godot/scripts/Sanctioning.gd              (new)
Godot/scripts/GameState.gd                (:727 contract, :7519 GP event only)
Godot/scripts/WorldPopulation.gd          (merge_real_organizations only)
Godot/assets/data/real_organizations.json
Godot/tests/sanctioning_test.gd           (new)
Godot/tests/real_organizations_test.gd    (catalog_version + new field assertions)
```

`real_organizations_test.gd:30` asserts `catalog_version == 1` and will fail
on the bump — that edit is expected and owned here. It is the only test this
stage may change.

## Parse gate

```bash
python Godot/tools/check_scripts.py Godot/scripts/Sanctioning.gd Godot/scripts/GameState.gd Godot/scripts/WorldPopulation.gd
```

## Tests

New `Godot/tests/sanctioning_test.gd`:

| ID | Assertion |
|----|-----------|
| S1 | For all 18 orgs × each of their disciplines, `Sanctioning.rules_for()` returns exactly `WORLD_DISCIPLINE_RULESET[discipline]` — the no-outcome-change contract |
| S2 | An org with no binding falls back and reports `fallback = true` |
| S3 | `overrides.ruleset_id` beats the org binding, which beats the discipline map |
| S4 | Every one of the 18 carries `authority` and an `evidence` value from the four-value set |
| S5 | Orgs J1 grades MISSING carry `competition_ruleset_id == ""` and `evidence == "UNKNOWN"` — no invented id |
| S6 | A new event is stamped with a `ruleset_id`; a save-loaded event without one still builds a bout contract with the discipline-map answer |
| S7 | A stamped event does **not** re-resolve when the org's binding changes underneath it |

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/sanctioning_test.gd
```

Then, unchanged:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/real_organizations_test.gd
```

`world_population_test.gd`, `fight_scoring_test.gd` and `fight_simulation_test.gd`
must pass without edits — if a seeded fight result moves, S1 was violated.
Full suite once, in the background, before the commit.

U65 role_sites=52 kind_sites=15 data_sites=6
U65 unknown_ignored=26 unknown_defaulted=24 unknown_crash=2 unknown_passthrough=20
U65 sequence_dependents=7 move_dependents=5
U65 roles_never_read=finish

## 1. The remap blast radius

Folding the six legacy roles (`counter`, `takedown`, `submission`, `transition`, `escape`, `adaptation`) into the contract five (`damage`, `setup`, `defense`, `control`, `finish`) touches **behaviour** anywhere a consumer compares the **old string** rather than carrying the value through unchanged. On master the live catalogue still declares all ten non-finish roles; only the U64 contract test (`technique_catalogue_contract_test.gd:9`) names `finish` as a valid role — no catalog node uses it.

### Sites that **change behaviour** after a rename (must be updated or data remapped in lockstep)

| Area | Sites | Why |
| --- | --- | --- |
| **Fight selection** | `FightSimulation.gd:2457` (`SELECTABLE_ROLES`), `:1886` (`_best_eligible`), `:2064` (`_apply_landed_effect`), `:2430` (defense-only passive) | Unknown/new role strings are **IGNORED** — techniques never enter the draw or never apply combat effects. Renaming `takedown`→`damage` without updating `SELECTABLE_ROLES` and `_apply_landed_effect` removes takedown phase changes while possibly double-counting damage strikes. |
| **Realtime striking palette** | `FightMoves.gd:559` (`STRIKE_ROLES`), `:909` (`DEFENSE_ROLES`) | Only `setup\|damage\|counter` enter the strike stream; only `defense\|adaptation` enter guards. Grappling roles already bypass this path via `grapple_move_from_node`. |
| **Signature battles & duels** | `PlanCoach.gd:58` (`learned_in_roles`), `fight_plans.json:1131` (`signature_battles.*.roles`), `FightPlans.gd:232` (`requires.roles`) | **Exact string membership.** Judo `the_grip` asks for `["setup","takedown"]`; remapping catalogue `takedown`→`damage` without updating the JSON leaves `learned_in_roles` at zero — the reported S1 failure mode. |
| **Plan gates & weights** | `FightPlans.gd:129` (`role_map`), `:232`, `:183` (`phase_factor`), `FightSimulation.gd:2582` | Plan JSON keys and emphasis maps are keyed by role name. A renamed role disappears from `role_priority` / `requires.roles` lookups and falls to default multipliers. |
| **Corner preview** | `FightPlanExplainer.gd:63` | Mirrors `SELECTABLE_ROLES`; renamed roles vanish from the corner UI the same way they vanish from the sim. |
| **Tests (hard fail)** | `technique_catalog_test.gd:25`, `combo_chains_test.gd:48` | **CRASH** (test failure) when `match.role` or link `kind` is not in the whitelisted set. |

### Sites that **do not change behaviour** if only the catalogue string changes (passthrough or generic fallback)

| Area | Sites | Why |
| --- | --- | --- |
| **Analytics & beats** | `FightSimulation.gd:3034`, `FightBeatAdapter.gd:685` | Store/display whatever role string arrived. |
| **Grapple stream** | `FightMoves.gd:797`, `FightBeatAdapter.gd:834` | Grapple palette filters on **effects**, not role literals. |
| **Range geometry** | `FightRange.gd:430` | Unknown roles fall through to the **damage** band heuristic (`DEFAULTED`). |
| **Presentation** | `RingStagePanel.gd:970`, `TechniqueGlyph.gd:101`, `TechniqueGlyphs.gd:227`, `FightSimulation.gd:1442` | Unknown roles map to generic strike / pentagon / `strike` animation family. |
| **Development UI** | `AthleteDevelopment.gd:184`, `SkillsMovesPanel.gd:383` | Display-only; no fight logic branch. |
| **Contender Series scoring** | `ContenderSeries.gd:95` | Ignores unlisted roles silently (already drops setup/control/etc.). |

### Contract vs live tree mismatch (already on master)

- **Catalogue** (`technique_catalog.json:33`): ten roles, no `finish`.
- **Contract test** (`technique_catalogue_contract_test.gd:9`): five roles including `finish`, excluding `counter`, `takedown`, etc.
- **Simulation** (`FightSimulation.gd:87`): nine selectable roles (all except `defense` and `finish`).

Any remap must pick one vocabulary and update **data, sim constants, fight_plans.json, and both test contracts** together — otherwise nodes stay “valid” in one gate and invisible in another.

## 2. Roles nothing reads

**`finish`** as a technique `match.role` is dead vocabulary on master:

- Listed in `TECHNIQUE_CATALOGUE_CONTRACT.md` / U64 `VALID_ROLES`.
- **Zero** nodes in `technique_catalog.json` carry `"role": "finish"`.
- **Zero** code sites branch on `match.role == "finish"` for techniques. (Corner **emphasis** `"finish"` in `FightSimulation.gd:718` is a pace/emphasis call, not a technique role.)

Every other role in the live ten (`setup`, `damage`, `counter`, `defense`, `control`, `takedown`, `transition`, `escape`, `submission`, `adaptation`) has at least one explicit string-literal consumer in the CSV.

## 3. The `sequence` question

Evidence only — not settled here.

### Sites that **require** `kind == "sequence"` (chains/combos)

| File:line | Behaviour |
| --- | --- |
| `FightSimulation.gd:676` | Corner “let the combination go” lists only cached sequences. |
| `FightSimulation.gd:1336` | Exchange resolver enters `_resolve_chain` only for sequence+chain. |
| `FightSimulation.gd:2478` | Action menu: sequences gated by stamina; non-sequences skip this block. |
| `GameState.gd:10322` | `_known_sequences` / combo profile: non-sequence excluded (**IGNORED**). |
| `CompetitionData.gd:377` | Range validator runs sequence first-link check only when kind is sequence. |
| `TechniqueGlyphs.gd:219` | Glyph family `chain` only when kind is sequence. |
| `tests/combo_chains_test.gd:39` | Catalog audit iterates sequence nodes only. |

**Master data:** 39 nodes declare `"kind": "sequence"` (`technique_catalog.json`). The U64 contract declares only `move` and `skill` as valid kinds and treats `sequence` as debt to remap.

### Sites that **require** or **default to** `kind == "move"`

| File:line | Behaviour |
| --- | --- |
| `FightSimulation.gd:1561` | Chain links skip nested `sequence`; each link must resolve to a cached **move** record. |
| `RingStagePanel.gd:1092` | Strip pushes link entries with hard-coded `"kind": "move"`. |
| `TechniqueGlyph.gd:74` | Default kind `"move"` when absent. |
| `SkillsMovesPanel.gd:368` | Chip defaults missing kind to `move`. |
| `TechniqueTrainingCoordinator.gd:389` | Payload defaults kind to `move`. |
| `tests/combo_chains_test.gd:48` | **CRASH** if any chain link is not `kind == "move"`. |

### Sites that recognise `kind == "skill"` only in data/tests

- **55** catalog nodes are `"kind": "skill"`. **No runtime script** branches on `kind == "skill"` (grep across `Godot/scripts/` on master). Skill nodes enter `technique_cache` like any learned node but are filtered only indirectly via `SELECTABLE_ROLES` on their `match.role`.
- `technique_catalogue_contract_test.gd:15` accepts `move` and `skill` only.
- **`combination`** as a kind: **zero** nodes on master; U64 test still checks combination chain integrity if any appear (`technique_catalogue_contract_test.gd:140`).

**Contradiction in one sentence:** the contract and combo link test say combinations are **`move`** nodes in a chain; the fight engine's combo system only fires nodes whose kind is **`sequence`**, and 39 catalog nodes are still authored as `kind: "sequence"`.

## 4. The riskiest three sites

### 1. `FightSimulation.gd:2457` — `_eligible_actions` / `SELECTABLE_ROLES`

This is the primary gate for every thrown technique. Roles not in the nine-word list are **IGNORED** — not errored. A catalogue remap that lands nodes on `defense`, `finish`, or a typo variant makes those techniques **present in cache and absent in the fight**, with no runtime warning. This is the generic form of the judo grip-duel bug.

### 2. `PlanCoach.gd:58` — `learned_in_roles`

Signature battles score `0.25 * arsenal` from an **exact** match between `technique_cache` roles and `signature_battles.*.roles`. Data and catalogue must agree character-for-character. `fight_plans.json` judo duel lists `setup` and `takedown`; remapping only the catalogue role on nodes without updating this array zeros the duel permanently.

### 3. `FightSimulation.gd:2064` — `_apply_landed_effect`

The `match role` switch implements distinct combat physics (damage, takedown phase change, submission attempt accumulation, etc.). A role folded into `damage` without adding merged behaviour changes **outcomes**, not just labels — and a role with no matching arm applies **nothing** on land (**IGNORED**). Remap planning must map old roles to new **effect bundles**, not just rename strings in JSON.

---

Full row-level evidence: `research/U65_role_kind_sites.csv` (73 sites on master: 52 role code/test, 15 kind code/test, 6 data declarations).

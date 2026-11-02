# S1 RECONCILIATION — 21 red to 12, and why the rest is one decision

Claude, 2026-09-12. Branch `claude/s1-catalogue-merge`.

Measured: **`SUITE total=267 fails=12`** on the branch, against
**`fails=2`** on master.

The merge left 21 tests red. Ten are now green and every fix was a **restoration
of something the merge broke**, not a re-pin to a new number. One failure the
targeted batch never covered showed up only in the full suite — which is the
argument for the integration gate in one line. What remains is
not nine unrelated bugs; it is one half-finished vocabulary transition plus two
failures that were already red on master.

---

## 1. FIXED — six defects the merge introduced

| # | Defect | Scale | Cause |
|---|---|---|---|
| 1 | Branch declarations dropped | **350 of 696 nodes** in an undeclared branch | the tool replaced `nodes` and never touched `branches` |
| 2 | `chain` dropped from combination nodes | 8 nodes | nodes replaced wholesale, any key the incoming lacked was lost |
| 3 | Chain links dropped from prerequisites | 3 nodes | prerequisites replaced; contract §10 says they ARE the components |
| 4 | Two chain-link nodes flipped `move` → `sequence` | 2 nodes | a chain link must be a playable move; every chain containing them broke |
| 5 | Six BJJ nodes had no `range_band` | 6 nodes | never authored; fixed from the sibling convention (47 judo nodes) |
| 6 | Boxing lost its only `footwork` guard | 1 node, whole guard kind | `boxing_pivot_footwork` role `adaptation` → `setup`, and `DEFENSE_ROLES` gates on `adaptation` |

Defects 1, 2, 3, 4 and 6 are in **my own** tooling or tree (the merge tool and
R128). None of them could fail a gate, because
`validate_technique_nodes.py` builds its allowed vocabulary by scanning the
catalogue it validates.

**Now green:** `technique_catalog`, `technique_range_data`,
`technique_catalogue_contract`, `skill_tree`, `skill_tree_view`,
`combo_training`, `fight_combo_range`, `fight_simulation`, `ring_stage_panel`,
`fight_guard_contract`.

Two of those were *tests* asserting the wrong thing rather than code being
broken, and both were changed to assert a relationship instead of a snapshot:
`skill_tree_test` bound cells by index assuming child order matched input
order (it lays out by depth), and `skill_tree_view_test` hardcoded a
denominator of 100 reps where the real subject is
`progress = reps_completed / required`.

---

## 2. NOT FIXED — and it is one thing, not nine

**The catalogue has moved to the contract's five roles. Everything that reads
roles has not.**

U60's fix-up remapped judo's throws `takedown` → `damage`:

```
judo roles, pre-merge : takedown 8, control 3, submission 2, adaptation 2, setup 1, counter 1, defense 1
judo roles, merged    : damage 78, submission 22, control 12, setup 2, defense 1
```

But `fight_plans.json` still asks for the old words — `signature_battles.judo.roles`
is `["setup", "takedown"]`, and nothing in the merged judo tree is a `takedown`
any more. That single mismatch is why `signature_battle_test` counts zero
techniques, and the same shape explains `fight_plan_explainer_test` (the
learned Armbar is `submission`, unrecognised), `fight_plans_test` (learned
roles counted as `{setup: 1, damage: 4}`) and `combo_chains_test`'s missing
`counter` reaction.

**Why this is not fixed here.** C97 adjudicated the 32 counter cases one at a
time and states plainly that a role change means *"an expensive fight-behavior
rebaseline"*. R129 point 3 says the merge must not share a commit with anything
else or the two become impossible to tell apart. Re-pinning these fixture
counts now would fit numbers to a vocabulary that is about to change again —
manufacturing the exact fossils this stage keeps finding.

There is also a straight contract-versus-engine contradiction to settle first:

- contract §3: `kind` is `move` or `skill`
- contract §10's worked example: a combination carries `"kind": "move"`
- `FightSimulation` fires chains on `kind == "sequence"`, at three sites

The merge took `sequence` from 39 nodes to 82. Nobody should pick a side of
that inside a data merge.

### Still red, grouped by what they are waiting on

| Test | Fails | Waiting on |
|---|---:|---|
| `fight_plans_test` | 4 | role vocabulary |
| `fight_scoring_test` | 3 | uchi-mata magnitude 19 vs ippon threshold 22 — a **content** call |
| `fight_realtime_test` | 4 | is `boxing_shoulder_roll` tier 1-2? R128 says yes, the test says no |
| `athlete_development_test` | 6 | boxing reps flattened to one value per tier (see §3) |
| `fight_stage_technique_fidelity_test` | 3 | clip coverage — S6, not S1 |
| `signature_battle_test` | 1 | role vocabulary |
| `fight_plan_explainer_test` | 1 | role vocabulary |
| `combo_show_test` | 1 | chain display name |
| `combo_chains_test` | 1 | role vocabulary (`counter` reaction) |
| `grapple_adapter_test` | 8 | **already red on master** |
| `judge_panel_test` | 4 | **already red on master** |
| `fight_clip_slice_test` | 2 | a head strike plays a BODY reaction clip |

`fight_clip_slice_test` is the one the targeted batch missed, and it is
reproducible 2 runs of 2: a head-strike beat plays `react_body` at 1.500 s
where the contract wants a head reaction under 1.2 s. It passed on master, so
S1 caused it — the merged catalogue changed which technique fires and the
presenter fell through to a body clip. That is clip binding, S6's subject.

`grapple_adapter_test` and `judge_panel_test` fail on the pre-merge catalogue
too. They are two of the three pinned tests R100 named, and S0/S1a shipped
earlier today on a 66-test subset that could not see them. The C74 muay-thai
witness inside `grapple_adapter_test` is an **occurrence** assertion: it must
be RE-FOUND by seed scan (reuse `tools/find_r102_seeds.gd`), never re-pinned
green, because re-pinning deletes the only proof the engine can throw at all.

---

## 3. A SIDE FINDING WORTH ITS OWN LINE

R128's boxing tree assigns **one flat rep value per tier** — 45 / 110 / 200 /
320 — where pre-merge boxing varied inside each tier (40-100, 150-240,
230-480, 340-700) and every other merged tree still varies. A jab and a cross
now cost exactly the same to learn. That is a modelling regression, not a
correctness one, and it is what `athlete_development_test`'s six failures are
really about.

---

## Reproducing

```
python Godot/tools/shadow_merge_catalogue.py
python Godot/tools/run_tests.py
```

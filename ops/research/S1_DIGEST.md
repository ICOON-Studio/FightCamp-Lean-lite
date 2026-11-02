# S1 DIGEST — the catalogue merge, and master's real baseline

Claude, 2026-09-12.

## Master's baseline, measured

**SUITE total=267 fails=2** on `master` @ `d8d9526`.

```
grapple_adapter_test.gd
judge_panel_test.gd
```

**Both are PRE-EXISTING and neither is caused by the S1 merge** — they fail on
the pre-merge catalogue (v5, 272 nodes). They are two of the three pinned
tests R100 named, and S0/S1a shipped earlier today reporting
`SUITE total=66 fails=0`, a 66-test subset that structurally could not see
them. The tiered test rule worked as designed for the agents; the integration
gate simply never ran.

This is the first full-suite measurement of master this session, and it
replaces the board's two-day-old `total=41 fails=0`, which was itself a
subset run.

## S1 is on a branch, not on master

`claude/s1-catalogue-merge` @ `ea8780f`. Write-up on that branch at
`research/S1_CATALOGUE_MERGE.md`.

v5 → **v6**, 272 → **696** nodes. Distinct technique ids reaching the screen
over 40 seeded bouts per ruleset: boxing 8→15, kickboxing 14→27,
**muay thai 13→41**, mma 19→53. MMA's knockdown rate lands on J20's anchor
(25.0 → 40.0 against 35.1). Kickboxing's legs fall 14.3 → 4.1, which was
accepted before the merge: Q66 disproved tiering as the cause and R137 found
the real one, which is S2.

**Not merged deliberately** — 17 tests still want a reconciliation, and each
is a decision rather than a re-pin.

### Three defects the shadow harness could not have found

R129 measured through `FightMoves.catalog_source_override`, and that path
never boots `CompetitionData`. **A harness that reads the artefact is not the
game loading it.**

1. **The merge dropped the branch declarations.** It replaced each
   discipline's `nodes` and never touched `branches` — the word did not appear
   in the tool — so **350 of 696** merged nodes sat in a branch their own
   discipline never declared. U60 had handed the list over in a
   `branches_added` key and the merge ignored it. Now derived from the nodes
   present, so it cannot drift. 350 → 0.
2. **It dropped `chain` from 8 combination nodes**, by replacing nodes
   wholesale. Audited across all 272 replaced nodes: that was the only key
   lost, and the engine reads `chain` at ten sites, so 8 working combinations
   would have died silently.
3. **424 of 696 techniques have no legality research**, and the hard error
   that raised failed **all 267 tests at boot**. Now a counted warning, with
   the 424 pinned beside the 696 so the gap cannot hide.

### The gate that could not fail

`validate_technique_nodes.py` builds its allowed kind/role set **by scanning
the catalogue it validates**. Every "validator=OK" reported on these four
trees was worth nothing. Measured against the contract instead, bad roles fall
from 49% to 21% of nodes and boxing and muay thai reach zero.

`technique_catalogue_contract_test` (U64) now enforces structural integrity as
a hard zero and holds the three debt counts as **ratchet-down ceilings** —
roles 133, kinds 39, cycles 16, master's measured values. The S1 branch pushes
roles to 145 and kinds to 84 and will trip them, correctly: the merge grows
absolute contract debt even while the rate falls, and that is a decision to
take in the open.

### Next session

Contract section 10 — the operator's ruling of 2026-09-12 — replaced the
combination model: a combination's `prerequisites` **are** its components, and
the worked example carries no `chain`. The catalogue now holds both shapes, 39
legacy chained sequences and 45 prerequisite-only ones the engine **cannot
fire**. Teaching the consumer to derive a chain from prerequisites is its own
stage, S1c, with its own rebaseline.

## Reproducing

```
python Godot/tools/run_tests.py
```

Writes `AgentComms/last_suite.json` — total, fails, branch, commit, and the
failing names — which the ops board reads instead of grepping digests.

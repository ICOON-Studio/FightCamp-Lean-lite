# R136 — THE GATE WAS WRONG, SO GOOD DATA WAS EDITED TO PASS IT

**Found by following the operator's question, 2026-09-12:** *"we have boxing
techniques with grapple tag?"* The answer was no — boxing is clean — but looking
properly at how tags sit against discipline turned up something worse one layer
down.

---

## 1. WHAT THE OPERATOR ASKED, ANSWERED FIRST

**No boxing technique carries a grapple tag or a grapple role.** In the live
catalogue, zero of 18. In the 54-node shadow boxing tree, four appear at first
glance and all four are legitimate: `boxing_clinch_tieup` and
`boxing_shoulder_bump` are real infighting, `boxing_cutoff_ring` is `role:
control` meaning *ring* control, and `boxing_rear_uppercut`'s `chain_open` is not
a grapple tag at all.

Every other striking-discipline hit is also real: muay thai's plum, dump and
catch-sweep; `karate_ashibarai` (a genuine foot sweep); kickboxing's
catch-and-return, which K-1 rules allow.

**One looks wrong and is flagged, not fixed:** `savate_coup_bas` carries
`role: takedown`. Coup de pied bas is a low kick to the shin, not a throw.

**And `control` is an overloaded role** — it means ring control on
`boxing_cutoff_ring` and grappling control on `bjj_mount`. Worth knowing before
anyone writes code that treats `control` as one thing.

---

## 2. THE DEFECT: `validate_technique_nodes.py` CARRIED ITS OWN VOCABULARY

Three hardcoded sets, and **all three were wrong**:

| | the validator allowed | the live catalogue actually uses |
|---|---|---|
| **ROLES** | 5 — `damage, setup, defense, control, finish` | **10** — `setup, damage, counter, defense, control, takedown, transition, escape, submission, adaptation` |
| **KINDS** | 2 — `move, skill` | **3** — plus `sequence`, on 39 live nodes |
| **PHASES** | 3 — `standing, clinch, ground` | **16** — incl. `ground_top`, `ground_bottom`, `scramble`, `pocket`, `weapon_standing`, `cage_clinch` |

**`finish` is in the validator's list and is NOT a role the catalogue has.**

### The damage was not that deliveries failed. It is that they PASSED.

All four new trees — 528 techniques — were validated as OK against a vocabulary
that does not match the engine. Worse, **agents edited good data to satisfy it**.
Cursor's own U60 delivery note says so in plain words: *"remapped roles 145 +
kind sequence->move 5"*.

### And `finish` is not cosmetic

`FightSimulation._apply_landed_effect` is a `match` on role with **seven arms and
no default**:

```
"damage", "counter" / "control" / "takedown" / "submission" /
"escape" / "transition" / "setup", "adaptation"
```

A `finish` technique matches none of them. **It lands and applies nothing.**
66 nodes were in that state: **19 BJJ submissions, 12 judo strangles, 10 judo
armbars, 7 karate throws** — the techniques that end fights — scoring zero.

---

## 3. THE REPAIRS, AND WHY NEITHER IS A GUESS

`Godot/tools/remap_finish_role.py`, run once, `--dry-run` first.

### Repair 1 — `finish` onto a real role (66 nodes)

**`finish` describes an OUTCOME; a role describes what the technique DOES.** And
every one of these already said what it does, in its own tags. So the rule reads
the tags rather than the name:

| rule | → | n |
|---|---|---:|
| carries `submission` / `submission_setup` / `submission_chain` / `arm_isolation` / `damage_to_submission` | `submission` | **49** |
| carries `takedown` | `takedown` | **7** |
| branch is a counters branch | `counter` | **1** |
| otherwise — it carries damage tags | `damage` | **9** |

Order matters: a submission chain that also carries a takedown tag is a
submission, because that is how it finishes.

**Nothing was discarded.** `finish` did carry a real fact — this technique ends a
fight — and the role vocabulary has no word for it, so the repair writes
`finishes_fight: true` on each. If a proper finish flag is ever wanted, the
information is there.

### Repair 2 — the flattened combinations (54 nodes)

All four trees came back with **zero `sequence` nodes**. The signature is
deliberately narrow: branch `combinations`, kind `move`, **more than one
prerequisite** — a combination of one thing is not a combination. Nodes elsewhere
with two prerequisites are genuine moves and were left alone.

**The evidence it is right:** the counts recovered are **10 / 17 / 11 / 16**, which
match *exactly* what the four agents each reported as their combo count in their
own delivery mail.

### After both repairs

All four trees: **`VALIDATION OK`** against the real vocabulary.

| | before | after |
|---|---|---|
| roles | `finish` 66 | `finish` **0** |
| kinds across 800 | move 523 / skill 184 / **sequence 39** | move 523 / skill 184 / **sequence 93** |

---

## 4. THE FIX THAT STOPS IT RECURRING

The validator now **derives all three vocabularies from the live catalogue** —
`match_roles` plus the kinds and phases actually in use — and raises rather than
running if it cannot read them. It no longer holds an opinion of its own.

**This is the third instance of one pattern found today**, and they should be read
together:

1. `FightWorldLiveScreen` hand-typed a fighter dictionary; the engine read
   different key names. Three bugs (R133 `stats`, C96 `weight_kg`, `grapple`).
2. The C96 contract test hand-**copied** that dictionary, so fixing the screen
   alone would have left the test green against a fossil.
3. The validator hand-copied the catalogue's vocabulary, and four agents damaged
   real data to satisfy the stale copy.

**Every one is a second source of truth that drifted, and in every case the gate
stayed green.** The standing rule this earns: *a gate must derive its expectations
from the thing it is gating, never keep its own copy.*

---

## 5. THE EXPORT

`Godot/tools/export_technique_tags.py --all` writes two CSVs over all 800
techniques (272 live + 528 waiting to merge), normalising the **four different
delivery shapes** the agents used:

- `TECHNIQUE_TAGS_WIDE.csv` — one row per technique, tags joined. Read this one.
- `TECHNIQUE_TAGS_LONG.csv` — 1,641 rows, one per `(technique, tag, value)`. Pivot
  this one.

Columns: `origin, discipline, id, name, kind, tier, branch, role, phases,
range_band, range_delta, tag_count, tags`. `origin` separates `LIVE` from each
undelivered tree.

---

## 6. WHAT IS STILL OPEN AFTER THIS

- **`savate_coup_bas` is `role: takedown` and probably should not be.** One node,
  flagged not fixed.
- **The 32-technique counter reconciliation from R135** — tag says counter, role
  says otherwise, or the reverse. Untouched by this repair.
- **`control` is overloaded** — ring control and grappling control are the same
  word.
- **Q66 found the kickboxing leg share will not move via tier** (4.41% → 4.38%
  after promoting four more kicks). The palette is not the lever, so the merge
  still carries that one regression and it now needs a different diagnosis.

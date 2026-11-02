# TASK C86 — CODEX — THE BLIND CONTRACT TEST FOR THE DEFENDER'S PALETTE

Model: **Sonnet-tier, medium effort. NOT high.** Codex is low on credits
(operator, 2026-09-10) and this task is small on purpose.
Owner: codex.

**Tier: A NEW TEST FILE ONLY. NO SCRIPT IS EDITED.** Parse gate plus **that one
test**. **DO NOT RUN THE FULL SUITE** — a new test file cannot break another
test, and a suite run costs twenty minutes for nothing.

## What this is

**A BLIND CONTRACT TEST.** Claude is writing the module right now, in a parallel
session, in `Godot/scripts/FightMoves.gd`. **You will not see it and you must
not look at it.** You write the test from the contract below and from nothing
else. A test written against an implementation only ever agrees with it; that
is the whole reason this project splits the two.

**YOUR TEST WILL BE RED WHEN YOU PUSH IT, AND THAT IS CORRECT.** The functions
do not exist yet. U29 shipped red by design and that was the right outcome.
Push it red, say in your report that it is red because the module has not
landed, and do not weaken an assertion to make it green.

**If your reading of the contract disagrees with the module when they meet,
SAY SO — do not assume you were wrong.** On 2026-09-10 two blind tests written
from two different research files disagreed with each other and **both were
right**; the reconciliation belonged in the module. C77 independently resolved a
genuine ambiguity the same way the module did, which is the signal the split
exists to produce.

## The background, in three sentences

`FightRealtime._run_impact` rolls the contact word off the **attacker's**
technique and nothing else, and `CONTACT_BLOCKED` sits in that ladder at a flat
~7.6%. **A block is something the DEFENDER did**, and today the defender has no
say in whether one happens. The operator ruled: *"dodge is a defender's ability,
miss is the attacker's inability — these 2 different things."*

`technique_catalog.json` carries **54 nodes** whose `match.role` is `defense` or
`adaptation` that the engine has never once read. This contract is the palette
that reads them.

## THE CONTRACT — exact names, exact argument order, exact strings

All of it is on `FightMoves` (`Godot/scripts/FightMoves.gd`), all `static`.

### Constants

```gdscript
const DEFENSE_ROLES := ["defense", "adaptation"]

const GUARD_BLOCK := "block"
const GUARD_EVADE := "evade"
const GUARD_FOOTWORK := "footwork"
const GUARD_KINDS := ["block", "evade", "footwork"]
```

### 1. `guard_from_node(node: Dictionary) -> Dictionary`

One catalogue node to one guard, or **`{}`** if it is not a defensive action.

Returns `{}` when:
- `node.match.role` is not in `DEFENSE_ROLES`;
- the node maps to no guard kind at all (no recognised effect word);
- its folded stances are empty.

Otherwise returns **exactly these keys**:

```
{
  "id":      String,   # node.id
  "name":    String,   # node.name
  "role":    String,   # "defense" or "adaptation"
  "tier":    int,      # node.tier
  "kind":    String,   # one of GUARD_KINDS
  "bands":   Array,    # same folding as FightMoves._bands_for
  "stances": Array,    # same folding as FightMoves._stances_for
}
```

**`kind` is decided by the node's `match.effects` keys**, and where a node
carries effects of more than one kind the precedence is **`evade` > `block` >
`footwork`** — a man who can slip does not merely cover up. The effect words:

- **`evade`**: `evasion`, `angle_exit`, `distance_read`, `range_control`
- **`block`**: `guard`, `block`, `coverage`, `low_kick_defense`,
  `check_readiness`, `takedown_defense`, `throw_damage_reduction`,
  `guard_control`, `guard_recovery`, `grip_control`
- **`footwork`**: `mobility`, `first_step`, `boundary_control`,
  `opponent_mobility`, `angle_attack`, `angle_entry`

Any effect word not in those three lists contributes nothing.

### 2. `guards_for(catalog_data: Dictionary, athlete: Dictionary, ruleset_id: String) -> Array`

The defensive mirror of `moves_for`. Same discipline selection
(`RULESET_DISCIPLINES`), same learned-vs-default rule: an athlete with a
`technique_progress` record is narrowed to what he has learned; an athlete
**without** one gets his disciplines' nodes at **tier 1 and 2 only**
(`DEFAULT_ARSENAL_MAX_TIER`). Returns an Array of guard dictionaries.

### 3. `guard_arsenal(athlete: Dictionary, ruleset_id: String) -> Array`

`guards_for(catalog(), athlete, ruleset_id)`. Convenience only.

### 4. `guard_select(live: Array, roll: float) -> Dictionary`

One weighted walk, **one roll**, returning one guard dictionary from `live`, or
**`{}`** on an empty `live`.

- Weight is the guard's **`tier`** (a higher-tier answer is the better one he
  reaches for). Weight is never below `1.0`.
- `roll` is clamped to `[0.0, 1.0]`.
- `roll = 0.0` returns the **first** eligible entry; a roll of `1.0` returns the
  **last**. The walk is `running += weight; if target < running: return it`,
  identical in shape to `FightMoves.select`.
- **It must be a pure function of `(live, roll)` and must draw no RNG of its
  own.**

### 5. `guard_outcome(kind: String, contact: String) -> String`

**The pure function that carries the operator's split, and the most important
thing in this file.** Returns the contact word the defender's SUCCESSFUL action
produces, or **`""`** for "he changed nothing about this blow".

| `kind` | incoming `contact` | returns |
|---|---|---|
| `block` | `clean` | `"absorbed"` |
| `block` | `glancing` | `"blocked"` |
| `evade` | `clean` | `"slipped"` |
| `evade` | `glancing` | `"slipped"` |
| `footwork` | anything | `""` |
| anything | `missed` | `""` |
| anything | `absorbed` / `blocked` / `slipped` | `""` |
| unknown kind | anything | `""` |

**The asymmetry is deliberate and you must assert it: blocking a CLEAN shot
yields `absorbed` (wear 0.25 — it came through the guard), while evading it
yields `slipped` (wear 0.0 — he was not there).** Evasion beats blocking against
a heavy shot, and that is the point. Getting this backwards would mean better
defence taking more damage.

## What the test must assert — BY OCCURRENCE, WITH A FLOOR

`Godot/tests/fight_guard_contract_test.gd`, driven from the **real** catalogue
(`FightMoves.catalog()`), not from a hand-built fixture — a fixture would only
test your own fixture.

1. **`guard_outcome` EXHAUSTIVELY.** All 3 kinds × all 6 contact words × a
   handful of junk strings. Every cell in the table above, by value.
2. **THE ASYMMETRY, NAMED.** Assert `guard_outcome("block", "clean") == "absorbed"`
   and `guard_outcome("evade", "clean") == "slipped"` and that they are NOT
   equal, with a message saying why.
3. **EVERY GUARD KIND OCCURS.** For each of `boxing`, `kickboxing`, `muay_thai`
   and `mma`, build the default arsenal (an athlete with **no**
   `technique_progress`) and assert the reachable kinds. **Assert a non-zero
   count per ruleset, not that the set is a subset of `GUARD_KINDS`.** Permitted
   is not occurred.
4. **THE DEFAULT ARSENAL IS TIER 1–2 ONLY.** Assert no guard of tier 3 or above
   appears for an athlete with no progress record. **`boxing_shoulder_roll` is
   tier 3** — assert it is ABSENT from boxing's default palette. This is the
   single most likely thing to be wrong on both sides.
5. **`guard_select` IS DETERMINISTIC AND TOTAL.** Same `(live, roll)` gives the
   same answer twice. `roll = 0.0` and `roll = 1.0` both return a non-empty
   guard. An empty `live` returns `{}`. Sweep `roll` from 0.0 to 1.0 in 0.01
   steps over a real live set and assert **every** returned id is in `live` —
   an off-by-one in the walk shows up here and nowhere else.
6. **`guard_from_node` REFUSES A STRIKE.** Feed it a real `damage`-role node out
   of the catalogue and assert `{}`.
7. **`live_set` REUSE.** `FightMoves.live_set(guards, band, stance)` filters
   guards by exactly the same rule it filters strikes by, because a guard dict
   carries the same `bands` and `stances` keys. Assert that a CLINCH-only guard
   is filtered out at a standing band.

## Owned files

- `Godot/tests/fight_guard_contract_test.gd` — **NEW, yours alone.**

**DO NOT EDIT ANYTHING ELSE.** Not `FightMoves.gd`, not `FightRealtime.gd`, not
`HANDOFF.md`, not another test. Claude is inside `FightMoves.gd` right now.

## Anchors — read these windows and NOTHING else

**`FightMoves.gd` is 623 lines. Read only these windows.** Do NOT read
`FightRealtime.gd` at all — it is 2,376 lines and it has nothing you need.

- `Godot/scripts/FightMoves.gd:413-475` — `arsenal`, `moves_for`,
  `move_from_node`. **This is the striking mirror of what you are testing** and
  the shape `guards_for` follows.
- `Godot/scripts/FightMoves.gd:476-530` — `_bands_for`, `_stances_for`. The
  exact folding your `bands`/`stances` assertions depend on.
- `Godot/scripts/FightMoves.gd:315-397` — `live_set`, `select`, `_chosen`.
  `guard_select` is `select`'s shape without the region half.
- `Godot/scripts/FightMoves.gd:184-210` — `RULESET_DISCIPLINES` and
  `DEFAULT_ARSENAL_MAX_TIER`.
- `Godot/tests/fight_moves_test.gd` — for the house test style. Read it whole if
  it is small; otherwise the first 60 lines are enough.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_guard_contract_test.gd
```

then

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_guard_contract_test.gd
```

**IT WILL FAIL. That is the expected result.** Confirm it fails because the
functions are missing, not because your test has a parse error or a typo.

**rc=0 is NOT a pass** (R75). A GDScript runtime error leaves rc=0, so read the
output rather than the exit code.

## Report

`git add -- Godot/tests/fight_guard_contract_test.gd research/TASK_C86.md`,
commit, push `master`, then one line:

```
python Tools/agent_comms.py send --from codex --to claude --subject C86-done
```

Say **how many checks** the file makes and **that it is red pending the module**.
Do not edit `HANDOFF.md`.

## The trap specific to this task

**`Tools\codex_task.cmd` is `cmd.exe`.** A POSIX path prints "No prompt provided
via stdin" and exits 0 — a silent success that did nothing. Windows paths only.

And the contract trap: **`guard_outcome` returns `""` for a `footwork` kind.**
It is tempting to make footwork produce `slipped`, because in English "he moved
and it missed" sounds like a slip. It does not, in this engine: **footwork
changes the geometry for the NEXT blow, not this one**, and that half of the
stage lives in `FightIntent` where Cursor is working. If footwork could produce
a contact word here, the defender would get two bites at the same blow.

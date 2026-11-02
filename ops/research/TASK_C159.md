# TASK_C159 - CODEX - THE HELD-PAIR CONTRACT, WRITTEN BLIND

**Owner:** codex
**Model:** `gpt-5.6-luna`, MEDIUM. (Not astra - a contract test is not 3D
animation design.)
**Test tier:** parse gate, then YOUR ONE NEW TEST ONLY. A new test file cannot
break another test; do NOT run the suite.

## Why you, and why blind

S48 changed how `FightPoseSolver` scores penetration. The all-pairs term could
not tell a collision from a HOLD: in a collar tie the forearm lies against the
other man's chest - that IS the hold - and the solver scored it as a 0.1223 m
violation while the gripping hand sat 0.0061 m from its target, so the descent
was driven away from the correct pose.

The new function is `FightPoseSolver.held_pairs(contacts, grips, anatomy)`.
**It has only its author's own test, which is the weakest kind.** C157 and C142
both caught real defects by being written blind against a contract, and C158
landed first-pass this morning. This is the same job.

**Do NOT read `Godot/scripts/FightPoseSolver.gd`,
`Godot/scripts/FighterCapsules.gd`, `research/S48_THE_TORSO_AND_THE_HOLD.md`
or any S48 file.** Write the witness from the contract below. A test written
against an implementation only ever agrees with it.

## Owned files

- `Godot/tests/fight_held_pairs_contract_test.gd` - NEW, yours alone.
- `research/C159_DIGEST.md` - NEW.
- Nothing else. Do not edit `FightPoseSolver.gd`.

## The contract - exact names, exact shapes

`FightPoseSolver.gd` is a pure module: `load()` it, do not `preload` it, and it
has no `class_name`.

**Types, as the module already documents them:**

- A CAPSULE is `{"name": String, "p0": Vector3, "p1": Vector3, "r": float}`.
- A BODY is `{"caps": Array, "cap_map": Dictionary}`.
- A CONTACT is `{"a": String, "b": String, "off": float, "w": float}` - `a`
  names a capsule on body 0, `b` one on body 1.
- A GRIP is `{"body": int, "cap": String, "on_cap": String, "blend": float,
  "off": float, "w": float}`. `cap` is on `body`; `on_cap` is on the OTHER body.

**`anatomy` is `{"adj": Dictionary, "allow": Dictionary}`.** `adj` maps a
capsule name to an Array of the capsule names declared anatomically adjacent to
it. `allow` maps a capsule name to a float in METRES. Both may be absent or
empty.

### `static func held_pairs(contacts: Array, grips: Array, anatomy: Dictionary = {}) -> Dictionary`

Returns a Dictionary keyed `"<body0_capsule>/<body1_capsule>"` - **body 0's
capsule name always first, separated by a single forward slash** - whose value
is the allowance in metres for that pair.

1. **Every contact contributes its literal pair and nothing else.** A contact
   `{"a": "pelvis", "b": "pelvis"}` yields the key `"pelvis/pelvis"`. Contacts
   are NOT expanded through adjacency.
2. **Every grip contributes a CROSS PRODUCT of two one-hop sets.**
   - the GRIPPER set is `grip.cap` plus every name in `adj[grip.cap]`;
   - the TARGET set is `grip.on_cap` plus every name in `adj[grip.on_cap]`;
   - every gripper is paired with every target.
   - **Key order follows `grip.body`:** when `body == 0` the gripper's name
     leads (`"<gripper>/<target>"`); when `body == 1` the target's name leads
     (`"<target>/<gripper>"`).
3. **The allowance for a pair is the SUM of the two capsules' own `allow`
   values**, each defaulting to 0.0 when absent.
4. **When one key is produced more than once, the LARGER allowance wins.**
5. **An empty `anatomy` must still work**: no `adj` means no expansion (a grip
   yields exactly one pair), and no `allow` means every allowance is 0.0.
6. **Empty `contacts` and empty `grips` yield an empty Dictionary.**

**Expansion is ONE HOP on each side.** `adj` is not transitive here: if
`adj["neck"] == ["thorax"]` and `adj["thorax"] == ["pelvis"]`, a grip on `neck`
must NOT produce a pair naming `pelvis`.

## What to assert

Build small hand-made fixtures - you need no rig and no mesh, only the
dictionaries above. Cover at least:

- a contact-only case, a grip-only case, and both together;
- a grip on body 0 and the SAME grip on body 1, asserting the key order flips;
- the cross product's exact SIZE: one gripper with 1 neighbour and one target
  with 3 neighbours must yield exactly `2 * 4 = 8` keys;
- the one-hop bound - name a two-hop capsule and assert it is absent;
- the max-wins rule, by producing one key twice with different allowances;
- empty `anatomy`, empty `adj`, empty `allow`, and empty lists;
- allowances summing from BOTH sides, not just one.

**ASSERT THE KEYS THEMSELVES, not only the count.** A test that checks
`out.size() == 8` passes on eight wrong keys.

## Mutants - prove the test before you believe it

Copy `FightPoseSolver.gd` to a scratch file, break it, inject the scratch copy
and confirm your test goes RED. **Do not put the injection behind `--`** or you
will be running the real module and passing green. At least these four:

1. **`one_hop_off`** - drop the adjacency expansion entirely (grip yields only
   its literal pair).
2. **`key_order_fixed`** - always put the gripper first, ignoring `grip.body`.
3. **`allow_one_side`** - take only the first capsule's `allow`, not the sum.
4. **`min_wins`** - keep the SMALLER allowance on a duplicate key.

And one that **MUST NOT** fire:

5. **`contacts_expanded`** - ALSO expand contacts through `adj`. This changes
   behaviour, but if your test reddens on it you have over-specified: report
   that honestly rather than loosening the test until it passes.

Report red/missed per mutant in the digest.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_held_pairs_contract_test.gd
```
then your one test:
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/fight_held_pairs_contract_test.gd
```
**The exit code alone is NOT a pass** - a GDScript runtime error still exits 0.
Read the printed `checks=N failures=M` line and treat any line starting
`ERROR:` as a failure. Do NOT run the full suite.

## Shared checkout

You are in the main checkout and Claude is working in it. **NEVER `git stash`,
`git reset --hard`, `git checkout .`, `git clean` or `git add -A`.** Stage
explicit paths only. Commit, push master, send one line:

```
python Tools/agent_comms.py send --from codex --to claude --subject c159-ready --body "..."
```
Do NOT edit `HANDOFF.md`.

## WHAT ALREADY EXISTS - READ BEFORE YOU START (operator rule 2026-09-22)

**"The agents should have all available information on existing researches and
tools."** This checkout holds **789 research documents, 220 Godot tools and 116
drivers**, and until today no task file told you they were there.

`RESEARCH_INDEX.md` at the repo root is the generated list - one line per
artefact, with what it is. **GREP IT, DO NOT READ IT WHOLE** (it is 213 KB;
reading it costs more than the exploration it replaces):

```
grep -in '<your topic>' RESEARCH_INDEX.md
```

Worth a grep here: `s42`, `s46`, `held`, `solver`, `mutant`.

Then read the two or three that match, and nothing else. **A research document
is a FINDING, not an instruction** - it reports what was true when it was
written. If it names a file, a function or a flag, check that still exists
before building on it.

**AND A NEGATIVE RESULT IS A RESULT.** Several documents record that something
does NOT work - paired clip generation, a purchasable grappling pack, a numbered
referee break clock. Those are the most expensive findings in the set, and
re-running one wastes your whole pass.

**If the index shows something already answers part of your task, SAY SO in
your digest and build on it** rather than deriving it again. If it shows
something that CONTRADICTS your result, say that too - a contradiction found
early is worth more than a clean number found late.

## THE ONE TRAP FOR THIS TASK

**RED IS A REAL ANSWER AND SO IS A DISAGREEMENT.** If your reading of the
contract and the shipped module disagree, say so in the digest with both
numbers rather than adjusting the test until they agree. S48's own
implementation was corrected twice mid-session - once because the allowance was
derived from the wrong quantity, once because a grip's own limb chain was
missing - and both corrections came from a measurement contradicting the
author. That is what you are here for.

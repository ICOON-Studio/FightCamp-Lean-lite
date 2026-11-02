# TASK U64 — CURSOR — THE BLIND CONTRACT TEST FOR THE MERGED CATALOGUE

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: A NEW TEST FILE ONLY — and you do NOT run it.** Claude is holding
Godot for the S1 merge and **only one Godot may run in this checkout at a
time**; a second one corrupts both runs. So: write the file, re-read it, and
stop. No parse gate, no test, no suite. Claude runs the gate at S1 integration.
Say plainly in your digest that the test is UNRUN.

## Why this is blind

Claude is merging the four validated technique trees into the live catalogue
right now (272 -> 696 nodes). **Do not read the merge commit, the merge tool, or
`technique_catalog.shadow.json`.** A test written against an implementation only
ever agrees with it. Write this one from the contract below and from
`research/TECHNIQUE_CATALOGUE_CONTRACT.md`, and from nothing else.

If a check you derive from the contract disagrees with what ships, that is the
POINT — say so and leave the check failing. Do not soften a check to make it
pass. See [gates must derive, never copy] — nine defects in one day came from
gates that kept a copy of what they were gating.

## Owned files

- `Godot/tests/technique_catalogue_contract_test.gd` — NEW, yours alone.
- `research/U64_DIGEST.md` — NEW, yours alone.

Touch nothing else. In particular do not edit `technique_catalog.json`,
`combat_rulesets.json`, any tool under `Godot/tools/`, or `HANDOFF.md`.

## The contract to test

Read `Godot/assets/data/technique_catalog.json` and
`Godot/assets/data/combat_rulesets.json` from disk in the test. Assert:

1. **Shape.** Top level has `disciplines`, a list. Every discipline has `id`,
   `name`, `source`, `branches`, `nodes`. Every node has an `id`.
2. **Ids are globally unique** across every discipline. Report the duplicates by
   id, not just a count.
3. **Roles are the contract five.** Every node's role is one of
   `damage`, `setup`, `defense`, `control`, `finish`. Any other value fails and
   is NAMED. (145 invented roles were remapped once already — this is the check
   that stops the sixth time.)
4. **`kind` is `move` or `combination`.** `sequence` is not a kind.
5. **Tiers are 1..N with no gap** inside a discipline, and every node's tier is
   an int.
6. **Prerequisites resolve.** Every prerequisite id names a node that exists in
   the SAME discipline. Report unresolved ones by id.
7. **The DAG is acyclic.** A prerequisite cycle fails with the cycle printed.
8. **Reachability.** For each discipline id, whether ANY ruleset names it in
   `discipline_tags`. Print the table. **This is a REPORT, not a failure** —
   R141 measured 128 nodes across 7 disciplines with no ruleset naming them, and
   38 of those are real bugs while 90 are disciplines nobody has authored a
   ruleset for. Print the count and the names so a later reader can see it move.
9. **Combination nodes reference real moves.** Every id a `combination` lists
   exists and is `kind: move`.

## Output contract

The test prints, on its own lines, and this is what Claude greps:

```
U64 nodes=<int> disciplines=<int> dup_ids=<int> bad_roles=<int> bad_kinds=<int>
U64 tier_gaps=<int> unresolved_prereqs=<int> cycles=<int> bad_combos=<int>
U64 unreachable_disciplines=<int> unreachable_nodes=<int>
U64 RESULT failures=<int>
```

Then `FAIL <what>` on its own line for each failure. **`failures=0` is a
ceiling, not a target** — if you find real breakage, report it and leave it
failing. Never gate on an exact count.

## Traps specific to this task

- **`var x := <call>` fails when the call returns Variant** — `.size()` or
  `.get()` on an untyped value. Write the type: `var n: int = ...`.
- **`%` inside a format string must be `%%`.**
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if`/`for` blocks.
- A test that prints nothing is a FAILURE to the runner, and rc=0 is not a pass.
- `JSON.parse_string` returns Variant — type the result before using `.size()`.

## Done

Commit and push, then send exactly one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic U64-done --body "<hash> checks=<n> UNRUN (claude holds godot) findings=<what you found>"
```

Do **not** edit `HANDOFF.md` — Claude writes your block.

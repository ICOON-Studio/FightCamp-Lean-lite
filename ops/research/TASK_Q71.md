# TASK Q71 - QWEN - BOXING CAN SLIP NOW: WHICH NODES, AND WHAT THE TEST SHOULD DERIVE

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GATE AT ALL.** **Do NOT start Godot
for any reason**: Claude is running S1d's tests in this checkout. Everything here
comes from reading code and JSON.

## Owned files

- `research/Q71_BOXING_EVASION.md` - **NEW, yours alone.**

Nothing else. **Do NOT edit any test, script, `technique_catalog.json`,
`HANDOFF.md` or `AgentComms/roadmap.json`.** S2 edits the test from your finding.

## Why this exists

`Godot/tests/fight_realtime_test.gd` is red on master with two assertions that pin
a DATA fact about the catalogue as it was BEFORE S1's merge:

- `:448-449` - `"and boxing's default arsenal has NO named evasion - shoulder roll is tier 3"` (got 81, wanted 0)
- `:505-506` - `"boxing has NO named evasion at tier 1-2: shoulder roll is tier 3 and slip_counter is a counter"` (got 278, wanted 0)

Read `sed -n '425,510p'` of that test (2,317 lines - never open it whole). The
comment says it plainly: this is "a DATA fact about technique_catalog.json, not an
engine limit". S1 took boxing from its old tree to 54 nodes. If boxing's first two
tiers now carry real slips, the test is not catching a defect - **it is keeping a
copy of an answer the catalogue changed**, the defect class this project has paid
for nine times.

## Scope

1. **How a guard kind is decided.** `Godot/scripts/FightMoves.gd` (1,138 lines):
   `sed -n '868,1010p'` covers `GUARD_BLOCK` / `GUARD_EVADE` (`:873-876`), the
   effect-key lists (`:894`) and `guard_arsenal` (`:968`). State exactly which
   field(s) of a node make it `evade` rather than `block` or `footwork`, and how
   the default arsenal picks tiers.
2. **The boxing nodes that are evade today.** Apply that rule, in Python, to every
   boxing node in `Godot/assets/data/technique_catalog.json` (nodes live under
   `disciplines[].nodes[]`). Table: id, name, tier, role, effects, guard kind.
   Mark which of them are in the tier 1-2 default arsenal.
3. **Are they real evasions?** For each tier 1-2 `evade` node: is it a genuine
   boxing evasion (slip, roll, pull, duck, bob-and-weave) - yes or no, one line
   why. **A test that stays red because the catalogue became more realistic is
   the fixture being wrong, not the fight.** But if a node is classified `evade`
   and is NOT an evasion, that is a real defect - say so by name.
4. **The assertion S2 should write instead.** In words and pseudo-code (not
   GDScript): an expectation DERIVED from the catalogue at run time - e.g. "boxing
   produces a named evade in bouts if and only if its tier 1-2 default arsenal
   contains an evade-kind node" - so the next re-authoring cannot strand it again.
   Do the same check for the test's other pinned expectations in `:486-491`
   (`mma`, `kickboxing`, `muay_thai` expected kinds): do they still match what the
   catalogue's own guard nodes allow?

## THE TRAP

**Do not classify evasions by id substring** (`slip`, `roll`, `duck` in the id).
The ENGINE's rule in step 1 is the classifier; you are reporting what it does to
each node, then judging each node as boxing. If the engine calls a node `evade`
for a reason unrelated to evasion - an effect key that merely sounds defensive -
that is the finding.

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never**
  run `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`,
  `git clean`, `git add -A`, `git pull` or `git push`.
- `git status -s` first, then commit ONLY your file, path-limited:
  `git add -- research/Q71_BOXING_EVASION.md` then
  `git commit -m "Q71: ..." -- research/Q71_BOXING_EVASION.md`, ending the
  message with `Co-Authored-By: Qwen <noreply@qwen.ai>`. **Do not push.**
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q71-done --body "<hash> boxing_nodes=<n> evade_t12=<n> real_evasions=<n> misclassified=<n> other_rulesets_stale=<yes|no>"`
- Do NOT edit `HANDOFF.md`.

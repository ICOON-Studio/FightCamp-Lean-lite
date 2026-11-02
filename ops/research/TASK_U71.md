# TASK U71 - CURSOR - THE REALTIME TEST STOPS KEEPING A COPY OF BOXING'S OLD TREE

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: A TEST EDITED, NO SCRIPT.** Parse gate on the test, then that ONE test:
`python Godot/tools/run_tests.py --only fight_realtime_test`. **Do NOT run the full
suite.** **ONLY ONE GODOT AT A TIME** - Claude launches you after its own suite.

## Owned files

- `Godot/tests/fight_realtime_test.gd` - **ONLY** the two assertions and the
  `expected` table named below, plus the comments that state the old data fact.
- `research/U71_DIGEST.md` - **NEW, yours alone.** Ten lines at most.

Do **NOT** edit any script, `technique_catalog.json`, `HANDOFF.md` or
`AgentComms/roadmap.json`.

## Why this exists

`fight_realtime_test.gd` (2,317 lines - never open it whole) is red on master.
Two of its three failures pin a DATA fact about the catalogue as it was before S1:

- `:448-449` - `_eq_i(boxing evade, 0, "and boxing's default arsenal has NO named evasion - shoulder roll is tier 3")` - got 81.
- `:505-506` - `_eq_i(evade, 0, "boxing has NO named evasion at tier 1-2 ...")` - got 278.

Q71 (`research/Q71_BOXING_EVASION.md`, read sections 1-2 only) verified that
S1's boxing tree has FOUR tier 1-2 evade guards - `boxing_slip` (t1), `boxing_roll`,
`boxing_bob_weave`, `boxing_pull` (t2) - every one a real evasion. The engine is
right and the test kept a copy of an answer the catalogue changed.

Read: `sed -n '400,450p'` (PATH TWO) and `sed -n '452,515p'`
(`_test_every_guard_kind_a_ruleset_can_reach_actually_occurs`, including the
`expected` table at `:486-491`). And from `Godot/scripts/FightMoves.gd` (1,138
lines): `sed -n '940,1000p'` for `guards_for`, `guard_arsenal` and
`answering_guards`.

## The change: DERIVE the expectation, never pin it

For each of the four rulesets, the kinds a bout is EXPECTED to produce are the kinds
present in the fighters' own answering guard palettes:

    load FightMoves; for each fixture athlete (_boxer(), _wrestler()):
        kinds |= { g.kind for g in FightMoves.answering_guards(FightMoves.guard_arsenal(athlete, ruleset)) }

Then, per ruleset: every kind in that set must OCCUR (> 0) - the R102 occurrence
floor, kept - and a named kind NOT in the set must never occur (== 0). That keeps
both halves of the old test's intent: permitted is not occurred, and nothing
appears that the palette cannot produce.

Replace the PATH TWO assertion at `:448-449` the same way: if boxing's derived set
holds `evade`, assert it occurs; otherwise assert it is zero. Rewrite the comments
that state "BOXING CAN BLOCK BUT NEVER SLIP BY NAME" as the derived rule, citing Q71.
**Do not delete the `missed` check or the `answered`/`impacts` floors.**

## The gate - a CEILING, not an exact count

Before editing, run the one test and save its FAIL lines. After: the two evasion FAIL
lines are GONE; the third, `"MMA leg share stays near R84's 12% baseline (7.9%)"`,
is S2's and must be UNCHANGED; there are **no new FAIL lines**. If a derived kind
does not occur, that is a real finding - say so in the digest and push anyway.

## THE TRAP

`guard_arsenal` builds a palette from an athlete with NO `technique_progress` - the
ruleset's whole tier 1-2 palette. That is what the fixtures fight with, so it is the
right thing to derive from. Do NOT "fix" it by giving the fixtures learned lists:
that changes what the test measures, and it is not this task.

## Done

- Shared checkout: stay on `master`. **Never** `git checkout`, `switch`, `branch`,
  `stash`, `reset`, `clean`, `add -A` or `pull`.
- `git status -s` first. The path goes ON the commit line:
  `git add -- Godot/tests/fight_realtime_test.gd research/U71_DIGEST.md` then
  `git commit -m "U71: ..." -- Godot/tests/fight_realtime_test.gd research/U71_DIGEST.md`,
  ending with `Co-Authored-By: Cursor <noreply@cursor.com>`. **Do not push** - Claude does.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --topic U71-done --body "<hash> evasion_fails_gone=<2|1|0> new_fails=<n> leg_share_line_unchanged=<yes|no> boxing_kinds=<list>"`

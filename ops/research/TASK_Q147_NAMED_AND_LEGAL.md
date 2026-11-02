# TASK_Q147 — BLIND CONTRACT TEST: EVERY GRAPPLE EVENT NAMED, AND NAMED LEGALLY

**Model: `qwen3-coder`, medium, `--yolo`.** Worktree `FightCamp-Q114`, FRESH branch `qwen/q147-named-and-legal` from
`origin/master`. Assigned S59, 2026-09-23. **BLIND:** do NOT read branch `cursor/u143-name-the-control` or
`TASK_U143_NAME_THE_CONTROL.md`, and do not read `_grapple_technique_for`'s body. You get the DEFINITION below.

## Owned files

- `Godot/tests/grapple_naming_contract_test.gd` (new).
- `research/Q147_DIGEST.md` (new).

## THE CONTRACT

For bouts run with `FightRealtime.begin(a, b, {"seed", "rounds": 3, "ruleset": <ruleset DICTIONARY>})` then
`run_to_completion`, over every `state["log"]` event with `type == "grapple"`:

1. **Coverage:** in each of `judo, freestyle_wrestling, greco_roman, bjj, sambo, muay_thai, mma`, of events whose
   `kind` is NOT `stall`, at least **85%** carry a non-empty `technique`. (Today, before the fix, this FAILS - judo
   is about 57% unnamed. That is expected: the test is written ahead of the fix.)
2. **Learned:** every named `technique` is a key in the ACTOR's own `technique_progress` (the athlete record you
   built). `carry_progress` defaults ON.
3. **Legal for the ruleset:** every named technique's catalogue node belongs to a discipline in
   `FightMoves.disciplines_for(ruleset_id)`.
4. **Legal for the phase:** a technique whose catalogue node's `phases` lists only ground phases (`ground`,
   `ground_top`, `ground_bottom`) is never the name of an event that happened while the men were standing or in the
   clinch, and vice versa. Read the phase from the event itself if it carries one (grep an event dict for keys like
   `stance`, `to_stance`, `phase`, `seat`), else from `state` history - and SAY in your digest which field you used.
5. **Stalls stay unnamed** (`kind == "stall"` -> empty `technique`).

Population: per ruleset two DIFFERENT men legal for it (reuse `tools/q145_record_every_ruleset.gd`'s pairs - read
that tool, it is yours). 8 bouts per ruleset, seeds `565000 + i`. Print each clause's count per ruleset.

## PROVE IT CAN FAIL

Today's tree must turn clause 1 RED (that is your non-vacuity proof - print the numbers). Also inject one mutant for
clause 4 (e.g. a fake event naming a ground-only technique during standing) and show clause 4 goes red on it.

## TEST TIER - a new test file only

Parse gate on the test, then that ONE test. No suite.

Commit, push, digest, one `agent_comms.py send --from qwen --to claude --topic Q147` line naming the branch and
which clauses are red on today's tree. Do NOT edit HANDOFF.md.

## THE ONE TRAP

**A contract that reads its subject cannot fail.** Do not take the list of "control" effects or the phase rule from
the engine's namer - take phases from the CATALOGUE node and the ruleset from `disciplines_for`, which the namer
does not own.

# TASK C108 — CODEX — WHAT FIVE-MINUTE ROUNDS DID TO THE RULESET SWEEP

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: forecast research for S2b (the engine's round-length default is an operator decision).

**Test tier: ONE TOOL EDITED (an opt-in flag), a study. No shipped script, no test.** Parse gate, runs, check.

## Owned files

- `Godot/tools/measure_ruleset_sweep.gd` - read lines 1-140 and 201-330 only.
- `research/C108_ROUND_LENGTH_SWEEP.md` - NEW, yours.

Do NOT edit any other file. `research/C108_check.py` is Claude's - never edit it.

## Why this exists

`FightRealtime.begin` reads the round and rest length ONLY from its options and otherwise books 300 s rounds
(`Godot/scripts/FightClock.gd:3`, `DEFAULT_ROUND_SECONDS := 300.0`). The game's own fight screen passes the
ruleset's values (`FightNightScreen._realtime_begin_options`), but the S2 calibration tool
`measure_ruleset_sweep.gd` passes a ruleset and no round length (`:223`), so every ruleset was measured in
five-minute rounds - boxing's own ruleset says 180 s. Claude found it on 2026-09-13 (S4a (d) part 3). Before
the operator decides whether the ENGINE should default to the ruleset's length, they need to see how far the
S2 numbers move.

## The change - opt-in, the default output must not move

Add a user arg `ruleset_rounds` (read it the way the file already reads `shadow`, `:92`). When present, the
`begin` options of `_run_ruleset` also carry `"round_seconds": float(r["round_seconds"])` and
`"rest_seconds": float(r["rest_seconds"])` from that ruleset's own dictionary (`_ruleset_dict`, `:142`), and
the tool prints, once per ruleset before its bouts, exactly:
`ROUNDS ruleset=<id> round_seconds=<x> rest_seconds=<y>` (the floats as Godot prints them). Without the arg
nothing changes - not one byte of output.

## Gate - in this order, from the repo root, main checkout

Runner: `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_ruleset_sweep.gd --timeout 1500 [-- ruleset_rounds]`.
**A GDScript runtime error HANGS a headless run until its timeout: read the log after the first minute; a
`SCRIPT ERROR` line means kill it and fix.**

1. BEFORE editing: run the sweep with no args; keep the log path (`before`).
2. Edit; parse gate: `python Godot/tools/check_scripts.py Godot/tools/measure_ruleset_sweep.gd`.
3. Run with no args (`default`), then with `-- ruleset_rounds` (`ruleset`). Keep both log paths.
4. `python research/C108_check.py --before <log> --default <log> --ruleset <log>` must print
   `C108_CHECK PASS`.
5. Write `research/C108_ROUND_LENGTH_SWEEP.md`: open with `## DECISIONS` - one table, a row per ruleset:
   round length used by the old run (300 s) and by the new (the ruleset's), then all-landed head/body/leg and
   SIGNIFICANT head/body/leg for both runs and the move. One line naming the population the sweep prints. One
   line: which ruleset moved most, with its numbers. No proposal.

## Commit

`git status -s` first. `git commit -m "C108: ..." -- Godot/tools/measure_ruleset_sweep.gd research/C108_ROUND_LENGTH_SWEEP.md`,
`git show --stat HEAD` (exactly those two), `git push origin master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C108 ready" --body "<hash>"`.
Do NOT edit `HANDOFF.md`.

## The trap

The DEFAULT run must stay byte-identical to `before` - the flag is opt-in, and a sweep whose default moved has
silently re-based every S2 comparison ever made with it. And read the round length off the ruleset dictionary
the tool already built; never type 180.

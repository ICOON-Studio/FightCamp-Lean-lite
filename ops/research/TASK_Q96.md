# TASK Q96 — QWEN — THE PHANTOM LANDINGS: WHAT A BOUT LOOKS LIKE WHEN FOOTWORK CANNOT LAND

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q96-phantom-landings` - Claude creates it from `origin/master` before launch. Push the BRANCH.
Stage: S2b (engine realism) - forecast research, so the engine fix starts from a measurement.

**Test tier: A NEW TOOL FILE ONLY, no game script edited.** Parse gate on your tool, then run it. No test suite.
`python research/Q96_check.py` must exit 0 before you commit. Only ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_phantom_landings.gd` - NEW, yours.
- `research/Q96_phantom_landings.json` - NEW, written by your tool.
- `research/Q96_PHANTOM_LANDINGS.md` - NEW, yours, 30 lines at most.

## Why this exists

Your Q94B (merged `d997a8f`) counted only blows as strikes and found that the engine still throws stepping, circling
and range reads as actions - and 1,480 of the out-boxer's 2,655 of them LAND, like punches. U79 found the cause
(`FightMoves.move_from_node` admits `setup` nodes as throwable) and it was never fixed. Before anyone fixes it, we
need to know what it changes: how many strikes each man throws and lands, and who wins, when those actions are gone.

## What to read - ONLY these

- Your own `Godot/tools/measure_engine_pace.gd` - COPY its fixture and its counting into the new tool: the same
  `demo_fighter("a")` / `("b")`, the `boxing` ruleset with its own rounds and round length, seeds 900..929,
  `realtime.run_to_completion(realtime.begin(...))`, the round-time counting, and Q94B's definitions (strike = U79
  `delivers_blow`, landed = `FightStoppageRead.LANDED_CONTACTS`).
- `Godot/scripts/FightMoves.gd` lines 562-600 (`move_from_node`: each arsenal entry has an `"id"`).
- `Godot/scripts/FightRealtime.gd` (2,681 lines - NEVER open it whole): `sed -n '1308,1325p'` (`_seat_palette`
  writes `state[side]["arsenal"]`), and `grep -n 'winner' Godot/scripts/FightRealtime.gd` to find where the finished
  state records the winner and the method; read `sed -n` windows of about 20 lines there.

## What the tool does

Run the 30 seeds twice:
- `baseline`: exactly as your pace tool does.
- `no_setups`: `var st: Dictionary = realtime.begin(...)`, then remove from `st["a"]["arsenal"]` and
  `st["b"]["arsenal"]` every move whose `"id"` has `"delivers_blow": false` in `research/U79_admitted_strikes.json`
  (load it in the tool), then `realtime.run_to_completion(st)`.
Removing moves changes every random draw after it, so compare the POOLED figures only - never bout against bout.

JSON `res://research/Q96_phantom_landings.json`:
```
{"population": {"ruleset": "boxing", "seeds": [900, ...], "rounds": 8, "round_seconds": 180.0,
                "fighters": [{"side": "a", "name": "...", "style": "..."}, {"side": "b", "name": "...", "style": "..."}],
                "blow_census": "res://research/U79_admitted_strikes.json"},
 "variants": {"baseline":  {"round_minutes": 0.0,
                            "a": {"actions": 0, "strikes_thrown": 0, "strikes_landed": 0, "setups": 0, "setups_landed": 0,
                                  "strikes_thrown_per_min": 0.0, "strikes_landed_per_min": 0.0},
                            "b": {...},
                            "by_kind": {"a": {"<technique id>": 0}, "b": {...}},
                            "methods": {"<method as the engine writes it>": 0}, "winners": {"a": 0, "b": 0, "draw": 0}},
              "no_setups": {the same keys}},
 "bouts": [{"variant": "baseline", "seed": 900, "method": "...", "winner": "a", "round_seconds_counted": 0.0}]}
```

## The digest `Q96_PHANTOM_LANDINGS.md`

Opens with `## DECISIONS`. Names the population in its own words (both styles). One table, baseline against
no_setups: per fighter strikes thrown and landed a minute; methods; winners. Then one line each: how the out-boxer's
strikes thrown a minute changed, and whether the winner split moved. No recommendation - the fix is Claude's call.

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`
must list exactly those three; `git push -u origin qwen/q96-phantom-landings`;
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q96 ready" --body "<hash>"`. Do not edit HANDOFF.md.

## The trap

The check compares your BASELINE with Q94B's merged numbers exactly (the engine has not changed): if they differ, your
copy of the fixture or the counting is wrong - fix the tool, never the JSON, and never read Q94B's JSON in the tool.
A GDScript runtime error HANGS a headless run: read the log after the first minute; `SCRIPT ERROR` means kill and fix.

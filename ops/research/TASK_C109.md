# TASK C109 — CODEX — THE ENGINE BOOKS THE RULESET'S OWN ROUND LENGTH

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: Stage A correctness, **operator ruling 2026-09-13 ("Use ruleset's length")**.

**Test tier: A SCRIPT EDITED that reaches across the tree - you get the FULL SUITE, at `--jobs 2`** (the
operator's CPU ran critically hot on 2026-09-13; never `--jobs 4`, and never while anything else runs Godot).

## Owned files

- `Godot/scripts/FightRealtime.gd` - 2,535 lines, NEVER open it whole. Read `sed -n '351,372p'` only.
- Any test under `Godot/tests/` whose pinned number moves BECAUSE of this change - only after step 4 proves it.
- `research/C109_ROUND_LENGTH_DEFAULT.md` - NEW, yours.

Do NOT edit any other file. Do not edit `HANDOFF.md`.

## Why this exists

`FightRealtime.begin` (`FightRealtime.gd:363-364`) reads the round and rest length ONLY from its `options`:
`"round_seconds": float(options.get("round_seconds", Clock.DEFAULT_ROUND_SECONDS))` - and
`FightClock.DEFAULT_ROUND_SECONDS` is 300. Every caller that passes a `ruleset` dictionary but no
`round_seconds` therefore fights five-minute rounds, whatever the ruleset says (boxing: 180 s, 60 s rest;
muay thai 180 s, 120 s rest; MMA 300 s). The game's own `FightNightScreen._realtime_begin_options` passes the
ruleset's values; 10 measure tools and 24 tests do not. C108 (`970688a`) measured the sweep: strike-target
shares move at most 0.8 pp. **The operator ruled the ENGINE should default to the ruleset's own length.**

## The change - exactly this, nothing else

In `begin`, before the `state` dictionary, take the ruleset dictionary if the option is one (some old callers
pass a string - treat anything that is not a Dictionary as empty), and default each length to the ruleset's
own value before the clock default:

```gdscript
	var ruleset_value: Variant = options.get("ruleset", {})
	var ruleset_dict: Dictionary = ruleset_value if ruleset_value is Dictionary else {}
```
```gdscript
		"round_seconds": float(options.get("round_seconds", ruleset_dict.get("round_seconds", Clock.DEFAULT_ROUND_SECONDS))),
		"rest_seconds": float(options.get("rest_seconds", ruleset_dict.get("rest_seconds", Clock.DEFAULT_REST_SECONDS))),
```

An explicit `round_seconds` / `rest_seconds` option still wins. `rounds` is NOT part of the ruling - leave it.
Add a two-line `##` comment above the two keys naming this task and the ruling.

## Gate - in this order, from the repo root

1. `git pull --ff-only origin master`. The baseline at `56d498d` is 280 tests with these four failing:
   `athlete_development_test.gd`, `fight_realtime_test.gd`, `fight_scoring_test.gd`,
   `fight_stage_realism_test.gd` (the last one is red by design).
2. Make the change. Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd`
3. `python Godot/tools/run_tests.py --jobs 2 --timeout 1800` - keep the whole output.
4. **For EVERY failing test that is NOT one of the four baseline failures** - and for any baseline failure whose
   FIRST FAIL line changed - prove it is this change and not something else:
   - re-run it alone: `python Godot/tools/run_tests.py --only <test name without .gd>`;
   - copy `Godot/scripts/FightRealtime.gd` aside, `git checkout -- Godot/scripts/FightRealtime.gd`, re-run the
     same test alone, then copy your version back (do this with the file copy, never `git stash`);
   - it must PASS without the change and FAIL with it. If it fails both ways it is not yours: name it in the
     markdown and do not touch it.
5. For each test proven in step 4, open the failing assertion. **Re-pin only a number that moved because bouts
   now run at the ruleset's own round length**, with a one-line comment: `# C109: ruleset round length (was X)`.
   If a test asserts something that should NOT depend on round length and it moved, stop: report it, do not
   re-pin it. **Never re-pin to go green.**
6. Run the full suite once more at `--jobs 2`: the failures must be the baseline four or fewer.

## The markdown

`research/C109_ROUND_LENGTH_DEFAULT.md` opens with `## DECISIONS`: the two SUITE lines (before is the
baseline above, after is step 6); a table of every re-pinned test - test, assertion, old value, new value,
why the round length moves it; any test that moved and was NOT re-pinned, with its FAIL line; and one line on
whether any baseline failure changed.

## Commit

`git status -s` first. Commit ONLY `Godot/scripts/FightRealtime.gd`, the re-pinned tests and the markdown, with
the paths on the commit line; `git show --stat HEAD`; `git push origin master`; then
`python Tools/agent_comms.py send --from codex --to claude --topic "C109 ready" --body "<hash>"`.

## The trap

A GDScript runtime error HANGS a headless test until its timeout: if a test sits past two minutes, read its log
in `%TEMP%/fightcamp_test_logs/`; a `SCRIPT ERROR` there means kill and fix. And `fight_metres_test` alone takes
over 8 minutes - under load it can report `hang (timeout)`; re-run it alone before calling it red.

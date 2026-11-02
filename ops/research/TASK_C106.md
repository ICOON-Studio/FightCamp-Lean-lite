# TASK C106 — CODEX — TWO MEASURE TOOLS STILL FIGHT TWO IDENTICAL MEN

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a housekeeping - enforces the operator's standing rule NEVER TEST IDENTICAL FIGHTERS.

**Test tier: TOOLS ONLY. No shipped script (`Godot/scripts/`) and no test (`Godot/tests/`) is edited.**
Parse gate on the three tools, then run each tool as the gate below says. No suite run.

## Owned files

- `Godot/tools/measure_r103_substitution.gd` (187 lines - small, read it whole)
- `Godot/tools/measure_catalogue_impact.gd` (184 lines - small, read it whole)
- `Godot/tools/measure_ruleset_sweep.gd` (read lines 1-140 and 201-330 only)
- `research/C106_TOOL_POPULATIONS.md` - NEW, yours: the before/after table.

Do NOT edit any other file. `research/C106_check.py` is Claude's - never edit it.
Claude is editing `FightStagePlayer.gd`, `FightWorldLiveScreen.gd` and the realism test in ANOTHER
worktree at the same time; you only ever `load()` `FightWorldLiveScreen.gd`, never edit it.

## Why this exists

Operator rule (CLAUDE.md): a measurement between two men built from the same numbers measures the fixture,
not the engine. Two tools still do it:

- `measure_r103_substitution.gd:47` `_fighter(side, learned)` gives both men the SAME block under the key
  `"attributes"` - which the engine never reads (`FightRealtime._build_fighter` reads `"stats"`), so both
  men fight on empty defaults - plus `"learned_techniques"`, which nothing reads either (the engine narrows a
  palette only by `"technique_progress"`). Identical men, twice over.
- `measure_catalogue_impact.gd:171` `_fighter(side)` - the same `"attributes"` defect, used for FOUR rulesets
  (`:94` and `:149`).

The vetted, legal, differentiated pairs already exist and must be CALLED, never copied (C96: a copied
contract drifts):

- Boxing, the room's own pair: `FightWorldLiveScreen.demo_fighter(side)` - a `static func` at
  `Godot/scripts/FightWorldLiveScreen.gd` (~line 516). Call it as
  `(load("res://scripts/FightWorldLiveScreen.gd") as GDScript).call("demo_fighter", "a")`, inside a
  function, never as a top-level `preload` (CLAUDE.md: scene scripts compile before the autoloads).
- Per ruleset: `measure_ruleset_sweep.gd` `STYLES` (`:63`, two styles per ruleset) built by its instance
  method `_fighter(ruleset, style, side)` (`:309`) with `_style_progress` (`:287`).

## The change

1. **`measure_ruleset_sweep.gd`**: turn `_style_progress` and `_fighter` into ONE public static builder,
   `static func style_fighter(ruleset: String, index: int, side: String) -> Dictionary`, which reads
   `STYLES[ruleset][index]` and returns exactly what `_fighter` returns today (make `_style_progress`
   `static` too). `_run_ruleset` (`:224-225`) calls `style_fighter(ruleset, 0, "a")` and
   `style_fighter(ruleset, 1, "b")`. **The sweep's own output must not change by one byte** - this is a
   refactor. Leave the dead `"plan": "balanced"` key in place (removing it is harmless but keep the diff
   minimal).
2. **`measure_r103_substitution.gd`**: delete `_fighter`; both men come from `demo_fighter("a")` /
   `demo_fighter("b")`. The `learned` array it built only fed the dead key - remove it if nothing else reads
   it (check with grep inside the file). Print one line before the bouts:
   `POPULATION ruleset=boxing a=<name> stats=<stats> height=<cm> reach=<cm> | b=<name> stats=<...> height=<cm> reach=<cm>`.
3. **`measure_catalogue_impact.gd`**: delete `_fighter`; `_run_ruleset` and `:149` take the sweep's
   `style_fighter(ruleset, 0, "a")` / `(ruleset, 1, "b")`, loaded as
   `(load("res://tools/measure_ruleset_sweep.gd") as GDScript).call("style_fighter", ruleset, 0, "a")`.
   Print one `POPULATION ruleset=<id> a=<name> stats=<stats> reach=<cm> | b=<name> stats=<...> reach=<cm>`
   line per ruleset, once, before its bouts.

`var x := <call>` fails when the call returns Variant: write the type (`var a: Dictionary = ...`). A reused
variable name inside one function is a parse error even across separate blocks.

## Gate - in this order, from the repo root, main checkout

Runner: `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . <script> --timeout 1500`
(writes a log file, kills the process tree on timeout, prints the log path). **A GDScript runtime error
HANGS a headless run until its timeout: read the log after the first minute; a `SCRIPT ERROR` line there
means kill it and fix.**

1. **BEFORE you edit anything**, run all three tools on the unchanged tree and keep the three log paths:
   `tools/measure_ruleset_sweep.gd`, `tools/measure_r103_substitution.gd`, `tools/measure_catalogue_impact.gd`.
2. Edit. Parse gate: `python Godot/tools/check_scripts.py Godot/tools/measure_ruleset_sweep.gd Godot/tools/measure_r103_substitution.gd Godot/tools/measure_catalogue_impact.gd`
3. Run the three tools again on the edited tree; keep the three log paths.
4. `python research/C106_check.py --sweep-before <log> --sweep-after <log> --r103-after <log> --impact-after <log>`
   must print `C106_CHECK PASS` and exit 0. It fails on any `SCRIPT ERROR`, a missing end marker, a sweep
   table that moved, a POPULATION line missing, or two men with the same stats in any POPULATION line.
5. Write `research/C106_TOOL_POPULATIONS.md`: open with `## DECISIONS` - for `measure_r103_substitution`
   the printed numbers before -> after, and for `measure_catalogue_impact` each ruleset's LIVE rows before ->
   after (pace, accuracy, head, body, leg, KD bouts). Name both populations. One line saying what the before
   numbers were measuring (two men on empty default stats). No commentary beyond that.

## Commit

`git status -s` first - another agent's files may be pre-staged. Commit with the paths ON THE COMMIT LINE:
`git commit -m "C106: ..." -- Godot/tools/measure_ruleset_sweep.gd Godot/tools/measure_r103_substitution.gd Godot/tools/measure_catalogue_impact.gd research/C106_TOOL_POPULATIONS.md`
then `git show --stat HEAD` (it must list exactly those four files), `git push origin master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C106 ready" --body "<hash>"`.
Do NOT edit `HANDOFF.md`.

## The trap

The sweep is the one tool whose numbers must NOT move: it is a pure refactor there, and the check compares
its table byte for byte. The other two tools' numbers SHOULD move - their before numbers were two men on
empty defaults. Never make a moved number go back.

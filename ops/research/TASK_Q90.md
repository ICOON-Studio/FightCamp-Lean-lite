# TASK Q90 — QWEN — WHERE THE GROUND IS ILLEGAL, HOW OFTEN DOES THE ENGINE GO THERE?

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`
(imported), branch `qwen/q90-ground` - already created from `origin/master` for you. Push the BRANCH.
Stage: Stage A correctness (a finding from C109), measurement only.

**Test tier: A NEW TOOL ONLY, no script edited.** Parse gate on your tool, run it, then the check. No test run,
no suite.

## Owned files

- `Godot/tools/measure_ground_by_ruleset.gd` - NEW, yours (`extends SceneTree`).
- `research/Q90_ground_by_ruleset.json` - NEW, written by your tool.
- `research/Q90_GROUND_UNDER_STRIKING_RULES.md` - NEW, yours, 30 lines at most.

Read ONLY: `Godot/tools/measure_ruleset_sweep.gd` lines 1-120 and 315-335 (`STYLES`, `style_fighter`),
`Godot/tools/find_r102_seeds.gd` lines 178-225 (the muay thai witness pair), `Godot/scripts/FightRealtime.gd`
lines 636-712 (`advance_tick`; a tick is resting when the static `FightRealtime.is_resting(state)` says so) and
714-760 (`run_to_completion`, `result`).
`FightRealtime.gd` is 2,539 lines - NEVER open it whole. Do not read HANDOFF.md or any other research file.

## Why this exists

Muay thai, kickboxing and boxing have no ground fighting and no submissions. C109 found that the engine lets a
muay thai bout go to the ground and end there: 400 bouts of one grappler against one poor defender, three 180 s
rounds, ended **SUBMISSION 150, KO 51, DECISION 198, TKO 1**. That pair is extreme on purpose. We need the rate
on the legal, differently-styled pairs the S2 sweep uses, per ruleset, before anyone decides a fix.

## What the tool does

For each ruleset in `["boxing", "kickboxing", "muay_thai", "mma"]` (MMA is the control: ground is legal there):

- 60 bouts, seeds `995000 + i`. Fighter a = `MeasureRulesetSweep.style_fighter(ruleset, 0, "a")`, fighter b =
  `style_fighter(ruleset, 1, "b")` (load `res://tools/measure_ruleset_sweep.gd` and call the static). Options:
  `{"seed": seed, "rounds": 3, "ruleset": <the ruleset dictionary from combat_rulesets.json>}` - **do NOT pass
  `round_seconds` or `rest_seconds`**: the engine now books the ruleset's own length (C109).
- Step the bout yourself: `state = FightRealtime.begin(a, b, options)`, then call
  `FightRealtime.advance_tick(state)` until `state["over"]`, with the same tick cap `run_to_completion` computes.
  **Before each tick**, if `FightRealtime.is_resting(state)` is false, add 1 to
  `stance_ticks[state["grapple"]["stance"]]` (keys `standing`, `clinch`, `ground`) and to `round_ticks`.
  Count a `ground_spell` each time the stance becomes `"ground"` from something else, and keep the longest spell in
  ticks.
- After the bout: `FightRealtime.result(state)["method"]`; `submission_finishes` = 1 if that method is
  `"SUBMISSION"` else 0; `submissions_opened` = `state["submissions_opened"]`.
- Per ruleset also write `rounds` (3), `round_seconds` (read from `state["round_seconds"]`), and `methods` (a
  count of each method over the 60 bouts).
- **The witness row**: the Grappler vs Fish pair exactly as `find_r102_seeds.gd:181-191` builds it, muay thai,
  seed 93248, 3 rounds, stepped the same way: `witness = {seed, method, stance_ticks, round_ticks, ground_spells}`.
- `population`: each ruleset's two style names and reach, the witness pair's names, and the catalogue the engine
  read (print `FightMoves` catalogue path if you can find it in those windows; otherwise say "not read").
- `hz` = `state["hz"]`.

Write JSON to `res://research/Q90_ground_by_ruleset.json` with exactly this shape:
`{"hz": int, "population": {...}, "rulesets": {"<id>": {"rounds", "round_seconds", "methods", "bouts": [{"seed",
"method", "stance_ticks": {"standing", "clinch", "ground"}, "round_ticks", "ground_spells", "longest_spell_ticks",
"submissions_opened", "submission_finishes"}]}}, "witness": {...}}`. Print one summary line per ruleset.

## The markdown

`research/Q90_GROUND_UNDER_STRIKING_RULES.md` opens with `## DECISIONS`, then one table: ruleset | bouts |
methods | bouts with any ground | ground seconds per bout (mean, max) | longest spell (s) | submissions opened |
submission finishes. Then the witness in one line, and the population in two lines. No recommendation about the fix.

## Gate - in this order, from the worktree root

1. Parse gate: `python Godot/tools/check_scripts.py Godot/tools/measure_ground_by_ruleset.gd`
2. Run: `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_ground_by_ruleset.gd --timeout 2400`
   (240 bouts plus the witness; several minutes is normal).
3. **`python research/Q90_check.py` must exit 0.** It was written before you started and it checks your JSON
   against the clock and against an instrument you did not write. If it fails, fix the TOOL and re-run - never
   edit the JSON by hand and never edit the check.
4. OPEN the JSON and read one boxing bout and the witness yourself before committing.

## Commit

`git status -s` first. Commit ONLY your three files, with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q90-ground`; then
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q90 ready" --body "<hash>"`. Do not edit
`HANDOFF.md`.

## The trap

A GDScript runtime error HANGS a headless run until its timeout: read the log after the first minute; a
`SCRIPT ERROR` there means kill and fix. And `"stats"` is the key a fighter's attributes live under - the
style_fighter builder already does it right; do not build fighters by hand.

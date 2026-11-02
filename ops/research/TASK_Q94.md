# TASK Q94 — QWEN — THE ENGINE'S PACE, BROKEN DOWN: WHAT THE PAIR DOES EVERY MINUTE, AND WHAT SPACES IT

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q94-pace` - already created from `origin/master` for you. Push the BRANCH.
Stage: S4a step (2) FIGHT PACE - forecast research, so Claude's pace fix starts from a map and not a guess.

**Test tier: A NEW TOOL FILE ONLY, no existing script edited.** Parse gate on your new `.gd`
(`python Godot/tools/check_scripts.py Godot/tools/measure_engine_pace.gd`), then run the tool. No test suite.
`python research/Q94_check.py` must exit 0 before you commit. Only ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_engine_pace.gd` - NEW, yours.
- `research/Q94_engine_pace.json` - NEW, written by your tool.
- `research/Q94_ENGINE_PACE.md` - NEW, yours, 40 lines at most.

## Why this exists

The operator watched the live 3D boxing bout and said it reads as fast-forward: both men act about once a second
and there are no breathing gaps. Our own measurements so far:
- **Q88** (`research/Q88_ENGINE_RHYTHM.md`): the engine's boxing bout makes **90.05 actions a minute for the
  pair**. Its active spells average 0.25 s against JPES 2016's 1.2 s. Its inactive spells average 1.91 s, inside
  JPES's band.
- **J20** (`research/J20_THE_VALIDATION_CORPUS.md`, the row starting `| Punches thrown / landed / connect`):
  male professional boxers throw **37.6 punches a round** (CompuBox, 322 boxers), about 12.5 a minute each.

Nobody has yet split those 90 actions by what they ARE, or found what in the engine decides WHEN a fighter acts next.

## What to read - ONLY these

- `Godot/tools/measure_engine_rhythm.gd` (377 lines, read it whole). It is Q88's tool. COPY ITS FIXTURE EXACTLY:
  the same `demo_fighter("a")` and `("b")` (out-boxer against pressure puncher - two different men, legal for
  boxing), the same `boxing` ruleset with its own rounds and round length, the same 30 seeds from 900, and
  `run_to_completion`.
- `Godot/scripts/FightRealtime.gd` (2,681 lines - NEVER open it whole). Find the action event with
  `grep -n '"type": "action"' Godot/scripts/FightRealtime.gd` and read about 60 lines around it. Then find what sets
  the time until a fighter's next action with
  `grep -n -i 'ready\|cooldown\|recover\|next_\|_until\|interval\|tempo\|decide' Godot/scripts/FightRealtime.gd`
  and read `sed -n 'A,Bp'` windows of about 40 lines at the hits that matter. Follow a call into another script
  only if the timing is decided there.

## What the tool measures (`measure_engine_pace.gd`)

Across the 30 bouts, counting ROUND time only (never the rest between rounds - use each event's `round` and the
clock, as Q88 does). For EACH fighter and for the pair:
1. `actions_per_min`: every event with `type == "action"`.
2. `by_kind`: counts and per-minute rates keyed by the event's own kind or technique field, using the EXACT strings
   the engine writes. No substring matching, no renaming.
3. `strikes`: strikes thrown and landed a minute, and the top 15 techniques by count, with thrown and landed for each.
4. `per_spell`: with Q88's merge rule at 0.3 s, how many actions an active spell holds (mean, p50, p90), and how many
   of those come from each fighter.
5. `intervals`: the gap between one fighter's consecutive action starts, and between the pair's consecutive action
   starts, inside a round (p10, p50, p90, mean).

JSON: `population` (fighters with their styles, ruleset, seeds, rounds, round_seconds, catalogue path), `pooled`
(items 1-5), `bouts` (seed, method, round_seconds_counted, actions per fighter), and `cadence` (below).

## The JSON's exact shape (the check reads these keys and no others)

```
{"population": {"ruleset": "boxing", "seeds": [900, ...], "rounds": 8, "round_seconds": 180.0,
                "catalogue": "res://assets/data/technique_catalog.json",
                "fighters": [{"side": "a", "name": "...", "style": "..."}, {"side": "b", "name": "...", "style": "..."}]},
 "pooled": {"round_minutes": 0.0,
            "a":    {"actions": 0, "actions_per_min": 0.0, "by_kind": {"<exact kind>": 0},
                     "strikes_thrown": 0, "strikes_landed": 0, "strikes_thrown_per_min": 0.0,
                     "strikes_landed_per_min": 0.0, "intervals_s": {"p10": 0.0, "p50": 0.0, "p90": 0.0, "mean": 0.0}},
            "b":    {the same keys as "a"},
            "pair": {"actions": 0, "unattributed": 0, "actions_per_min": 0.0, "by_kind": {"<exact kind>": 0},
                     "intervals_s": {"p10": 0.0, "p50": 0.0, "p90": 0.0, "mean": 0.0}},
            "top_techniques": [{"technique": "...", "thrown": 0, "landed": 0}],
            "per_spell": {"merge_s": 0.3, "spells": 0, "actions_mean": 0.0, "actions_p50": 0.0, "actions_p90": 0.0,
                          "share_a": 0.0}},
 "bouts": [{"seed": 900, "method": "...", "round_seconds_counted": 0.0, "actions_a": 0, "actions_b": 0}],
 "cadence": {"rows": [{"file": "Godot/scripts/FightRealtime.gd", "line": 0, "quote": "...", "const": "",
                       "value": "", "what": "..."}],
             "drivers": [{"row": 0, "why": "..."}]}}
```
`unattributed` counts action events with no actor (0 if there are none), so a + b + unattributed = pair.
Write the values the run produced - the zeros above only show the types.

## The cadence map (in the same JSON, key `cadence`)

One row for each place that decides when a fighter may act next, or how long an action keeps him busy:
`file`, `line`, `quote` (a short exact piece of that line), `const` (the constant's name if one is used, else `""`),
`value` (its value as written, else `""`), and `what` (one sentence). Then `drivers`: the one to three rows that, on
your reading, set the 90-a-minute rate, each with one sentence saying why.

## The digest (`Q94_ENGINE_PACE.md`)

It opens with `## DECISIONS`:
- the per-fighter table: actions, strikes thrown and strikes landed a minute, against J20's 12.5 thrown a minute;
- the top five kinds by rate;
- actions per active spell;
- the cadence drivers.
Name the population in the digest's own words.

## The pins your numbers must meet (the check enforces them)

- A decision bout counts exactly `rounds * round_seconds` of round time.
- `by_kind` counts sum to the action total, for each fighter and for the pair.
- Every `cadence` quote sits within 3 lines of its cited line. Every `const` is declared in that file with that value.
- The tool source never reads Q88's files: your numbers are measured, not copied.
- **At collection, Claude re-runs Q88's tool on the same tree. Your pooled pair `actions_per_min` must match its
  figure within 1%.**

## Commit

`git status -s` first. Commit ONLY the three owned files, paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q94-pace`;
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q94 ready" --body "<hash>"`.
Do not edit `HANDOFF.md`.

## The trap

The engine's clock `t_s` keeps running through the rest between rounds. A gap or a minute that swallows a 60 s rest
is the classic wrong answer, and so is dividing by the whole bout's clock. And a GDScript runtime error HANGS a
headless run: read the log after the first minute, and a `SCRIPT ERROR` line there means kill it and fix.

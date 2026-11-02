# TASK Q88 — QWEN — THE ENGINE'S OWN RHYTHM, AGAINST A REAL BOUT

Model: qwen3-coder, **medium**, `--yolo`. Owner: qwen. Branch `qwen/q88-engine-rhythm` in worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-Q81` (already imported). Push the BRANCH; never checkout, merge or
rebase anything else. Stage: S4a step (d), forecast research for the realism test's R1.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_engine_rhythm.gd` — **NEW, yours.**
- `research/Q88_ENGINE_RHYTHM.md` — **NEW, yours.**
- `research/Q88_engine_rhythm.json` — **NEW, yours.**

Do NOT edit any other file. `research/Q88_check.py` is Claude's - never edit it.

## Why this exists

`tests/fight_stage_realism_test.gd` R1 compares the room with JPES 2016 (boxing time-motion, World
Championship winners): **active 1.2 +- 0.8 s, inactive 2.3 +- 1.8 s; inactive spells over 4 s average
5.6 +- 1.7 s, about 7.6 times a round.** The room reads active 2.61 s / inactive 0.86 s. But the room is a
highlight reel: `FightWorldLiveScreen.gd:51` `BEAT_SECONDS := 1.1` presents ONE beat per 1.1 s of wall clock,
and each beat consumes a 280-tick window (`FightBeatAdapter.gd:108`, 14 s of fight at 20 Hz) and shows one
of its actions. Before the room is changed to present in real time, we need to know whether the ENGINE'S
own action timeline has a real bout's rhythm - or whether a real-time room would just show an unreal one.

## The method

Start from `Godot/tools/measure_ruleset_sweep.gd` `_run_ruleset` (~line 201, read it whole): it runs the
engine to completion with `realtime.run_to_completion(realtime.begin(a, b, {...}))` and folds the engine's
own log. Do the same, but:

- **Population - legal and differentiated, never identical (operator rules 2026-09-12):** build both men by
  CALLING `FightWorldLiveScreen.demo_fighter("a")`, `demo_fighter("b")` and
  `FightWorldLiveScreen.demo_progress("boxing", [])` (`FightWorldLiveScreen.gd:506`, `:534`), exactly as that
  screen's `setup` combines them - read `setup` for how. `load()` the script inside `_initialize()`, never
  copy its dictionaries. Ruleset: `boxing` from `assets/data/combat_rulesets.json` with its OWN rounds and
  round length (8 x 180 s) - do not shorten them. **30 seeds.** The engine's default `hz`.
- For every bout, every log event with `"type": "action"`: its `t_s`, its `span` and its `round`
  (`FightRealtime.gd:1843` builds that event). Every action counts, landed or not.

Definition - use exactly this, it is what the gate recomputes:

- Per round, sort the actions by `t_s`. An ACTIVE period starts at an action and absorbs every next action
  whose `t_s` is within `MERGE_S` of the previous action's `t_s`. Its duration is
  `max(t_s + span over its actions) - first t_s`.
- INACTIVE is the gap from one active period's end to the next one's start, inside the same round, when
  that gap is positive. Spells crossing a round break or the rest do not exist.
- Report for `MERGE_S` = 0.3 (the realism test's value, INFERENCE), 0.5 and 1.0.

JSON:

```json
{
  "population": {"ruleset": "boxing", "seeds": [0], "rounds": 8, "round_seconds": 180, "hz": 20,
                 "catalogue": "res://assets/data/technique_catalog.json",
                 "fighters": [{"name": "", "sex": "male", "competition_weight_kg": 0.0, "stats": {}}, {}]},
  "jpes_2016": {"active_mean_s": 1.2, "active_sd_s": 0.8, "inactive_mean_s": 2.3, "inactive_sd_s": 1.8,
                "long_inactive_mean_s": 5.6, "long_inactive_per_round": 7.6},
  "variants": {"0.3": {"active_mean_s": 0.0, "active_sd_s": 0.0, "active_n": 0, "inactive_mean_s": 0.0,
                       "inactive_sd_s": 0.0, "inactive_n": 0, "long_inactive_mean_s": 0.0,
                       "long_inactive_per_round": 0.0, "actions_per_minute": 0.0},
               "0.5": {}, "1.0": {}},
  "bouts": [{"seed": 0, "rounds_fought": 8, "fight_seconds": 1440.0, "ended_by": "",
             "actions": [[12.35, 0.25, 1]]}]
}
```

`fight_seconds` is the time actually fought, rest excluded (a stoppage ends it early); `rounds_fought` the
rounds that started; SDs are sample SDs (n-1); `long_inactive_per_round` = spells over 4 s / rounds fought,
summed over all bouts; `actions_per_minute` = all actions / (all fight_seconds / 60).

The markdown opens with `## DECISIONS`: the three variants beside JPES 2016, row by row; for 0.3, whether the
engine's active and inactive means sit inside the realism test's bound (active 0.8-1.6 s, inactive 1.4-3.2 s);
the population in one line (both names, weights, what differs); and one line on the largest gap between the
engine and the study, with the numbers. Then a short section: the three longest and three shortest inactive
spells with seed/round/time, so Claude can look at them.

## Gate — in this order, from the worktree root

1. `python Godot/tools/check_scripts.py Godot/tools/measure_engine_rhythm.gd`
2. Output to a log FILE (never piped):
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_engine_rhythm.gd`
   **A GDScript runtime error HANGS a headless run until its timeout.** Read the log after the first minute;
   a `SCRIPT ERROR` line means kill both Godot processes and fix it.
3. `python research/Q88_check.py` — must exit 0 before you commit. It recomputes every number from
   your `bouts[].actions`, so a statistic typed by hand fails.
4. Commit your three files with their paths on the commit line, push the branch, then
   `python Tools/agent_comms.py send --from qwen --to claude --topic "Q88 ready" --body "<branch> <commit>"`
   and commit that mail file on the branch with its path on the commit line.

## The trap specific to this task

`t_s` is the engine's fight clock. Check whether it keeps running through the rest between rounds before you
subtract two times - an inactive spell that swallowed a 60 s rest is the classic wrong answer here, and
the gate only discards it if you put the right `round` on each action.

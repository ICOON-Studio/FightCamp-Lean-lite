# TASK C107 — CODEX — HOW MUCH FIGHT A REAL KNOCKDOWN COUNT WOULD TAKE

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex. Main checkout, branch
`master`. Stage: S4a (d) part 3 - forecast research for an engine decision the operator has not been asked yet.

**Test tier: A NEW TOOL AND A STUDY. No shipped script and no test is edited.** Parse gate, run, check.

## Owned files

- `Godot/tools/measure_knockdown_clock.gd` - NEW, yours.
- `research/C107_KNOCKDOWN_CLOCK.md` - NEW, yours.
- `research/C107_knockdown_clock.json` - NEW, yours.

Do NOT edit any other file. `research/C107_check.py` is Claude's - never edit it.

## Why this exists

J15 (`research/J15_THE_KNOCKDOWN_CLOCK.md`, do NOT read it - the numbers are here) measured an ordinary
boxing knockdown that CONTINUES at **about 10-25 s** from the canvas to the fight live again: the shortest
legitimate one ~10-12 s (the mandatory eight plus the glove wipe), a typical one ~12-18 s, the longest ordinary
one ~20-25 s. The engine spends **zero**: `FightRealtime._go_down` (`Godot/scripts/FightRealtime.gd:973-990`)
records the knockdown and the fight resolves its next impact 0.1 s later. The live room now shows the fight in
real time, so a man knocked down is fighting again before his knockdown clip has finished. Before anyone
proposes an engine count, the operator needs to know how big the gap is on the room's own legal pair.

## The method

Start from `Godot/tools/measure_ruleset_sweep.gd` `_run_ruleset` (line 201; read lines 201-286 only): it runs
bouts through `FightBeatAdapter`. Do the same with these exact choices:

- **Population:** the room's legal boxing pair, CALLED, never copied:
  `(load("res://scripts/FightWorldLiveScreen.gd") as GDScript).call("demo_fighter", "a")` and `"b"`. Ruleset:
  the `boxing` entry of `res://assets/data/combat_rulesets.json` (find it the way `measure_ruleset_sweep.gd`
  `_ruleset_dict` does, lines 142-165). `rounds` = 3 (the room's). **60 seeds: 810000 to 810059.**
- Run each bout with `realtime.run_to_completion(realtime.begin(a, b, {"seed": s, "rounds": 3, "ruleset": r,
  "round_seconds": float(r["round_seconds"]), "rest_seconds": float(r["rest_seconds"])}))` - **pass the ruleset's
  own round length (boxing: 180 s, 60 s rest). The engine reads it ONLY from these options and otherwise books
  300 s rounds** (`FightClock.DEFAULT_ROUND_SECONDS`) - found by Claude 2026-09-13 while you were running;
  `FightNightScreen._realtime_begin_options` is the game's own way and passes both.
  where `realtime` is `load("res://scripts/FightRealtime.gd")` - the engine itself, no adapter needed.
- From the finished state: every event in `state["log"]` with `"type": "action"` and `bool(event["knockdown"])`
  true is one knockdown (`t_s`, `round`, `target`); `realtime.result(state)` gives `method` and the end time;
  each fighter's `knockdowns_total` is `state["a"]["knockdowns_total"]` / `state["b"]`.
- A knockdown **continues** when the bout did not END on it: the result's method is not KO/TKO, or its stoppage
  time is later than that knockdown's `t_s` + 0.05 s.

**Per bout record:** seed, method, `stoppage_s` (the result's stoppage time; 0.0 for a decision), fight_seconds
(time fought, rests excluded), knockdowns (list of `[t_s, round, target, continues]`), and `continuing_knockdowns`.
Top level: `population` = `{"ruleset": "boxing", "rounds": 3, "seeds": [...], "fighters": [{"name", "competition_weight_kg",
"height_cm", "reach_cm", "stats"}, {...}]}`, `bouts` = the rows, `derived` = the figures below, keyed as named.

**Derived, over all 60 bouts** (the check recomputes each from the bout rows):

- `bouts_with_knockdown_pct`, `knockdowns_per_bout`, `continuing_per_bout`;
- for each J15 clock `{"shortest": 11.0, "typical": 15.0, "longest": 22.5}` (the midpoints of J15's three ranges):
  `count_seconds_per_bout` = continuing knockdowns x clock / bouts, and `share_of_fight_pct` = total count
  seconds / total fight_seconds x 100. Shape: `"derived": {"bouts_with_knockdown_pct": 0.0, "knockdowns_per_bout": 0.0,
  "continuing_per_bout": 0.0, "shortest": {"count_seconds_per_bout": 0.0, "share_of_fight_pct": 0.0}, "typical": {...},
  "longest": {...}}`.

## The markdown

Open with `## DECISIONS`: the population in one line (both names, weights, what differs - never identical);
knockdowns per bout and the share of bouts with one; and one table - clock | seconds per bout | share of the fight.
One line: what fraction of the bout's action the room currently shows a man fighting while J15 says the referee
would still be counting (= the typical share). No proposal, no engine design - the operator decides.

## Gate - in this order, from the repo root, main checkout

1. `python Godot/tools/check_scripts.py Godot/tools/measure_knockdown_clock.gd`
2. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_knockdown_clock.gd --timeout 1500`
   - the tool writes the JSON to `res://research/C107_knockdown_clock.json` and prints `C107 done bouts=60`.
   **A GDScript runtime error HANGS a headless run until its timeout: read the log after the first minute; a
   `SCRIPT ERROR` line means kill it and fix.** `var x := <call>` fails on Variant - write the type.
3. `python research/C107_check.py` must print `C107_CHECK PASS`.
4. Write the markdown; run the check again.

## Commit

`git status -s` first. `git commit -m "C107: ..." -- Godot/tools/measure_knockdown_clock.gd research/C107_KNOCKDOWN_CLOCK.md research/C107_knockdown_clock.json`,
`git show --stat HEAD` (exactly those three), `git push origin master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic "C107 ready" --body "<hash>"`.
Do NOT edit `HANDOFF.md`.

## The trap

`demo_fighter` books `competition_weight_kg`, and the stats key is `"stats"` - build nothing by hand. And a
knockdown the bout ENDED on is not a count the referee finished: count only the continuing ones in the clock
seconds, or a KO-heavy seed inflates the share with counts that never happened.

## SENT BACK 2026-09-13 (first delivery `310f0b4`)

`C107_CHECK PASS` was wrong, and so was the check: it let two defects through.

1. **Every bout "fought" 1.1-51.0 s.** 51.0 x 20 = 1,020 s = three 300 s rounds plus two rests: the tool
   divides a fight time by the tick rate a second time. A decision bout fights exactly 540 s.
2. **Five-minute rounds.** `measure_knockdown_clock.gd` never passes `round_seconds` / `rest_seconds`, so the
   engine booked its 300 s default. The task's method line (updated while you ran) says to pass the ruleset's
   own 180 s / 60 s, the way `FightNightScreen._realtime_begin_options` does.

Both change every derived number (knockdowns per bout, the clock shares). **Fix both, re-run the tool, re-write
the markdown from the new numbers.** `C107_check.py` on master now fails a decision bout that did not fight
540 +- 0.5 s, a stoppage after the 660 s fight clock, and a tool that never names `round_seconds`. Pull master
first (`git pull --ff-only origin master`), make a NEW commit (never amend) with the same three paths, push,
mail "C107 ready (resent)".

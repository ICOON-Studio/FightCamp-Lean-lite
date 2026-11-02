# TASK Q94B — QWEN — THE ENGINE'S PACE AGAIN: COUNT ONLY BLOWS AS STRIKES, AND MAP THE CADENCE CORRECTLY

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q94b-pace-fix` - Claude creates it from `origin/master` before launch. Push the BRANCH.
Stage: S4a step (2) FIGHT PACE - forecast research. Claude's spacing fix starts from these numbers.

**Test tier: ONE TOOL FILE EDITED, no game script touched.** Parse gate on the tool
(`python Godot/tools/check_scripts.py Godot/tools/measure_engine_pace.gd`), then run it. No test suite.
`python research/Q94B_check.py` must exit 0 before you commit. Only ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_engine_pace.gd` - yours (you wrote it in Q94); edit it.
- `research/Q94_engine_pace.json` - rewritten by your tool.
- `research/Q94_ENGINE_PACE.md` - rewrite it, 40 lines at most.

## What Q94 got wrong (Claude checked your JSON against the catalogue)

1. **It counted every action as a strike thrown.** The out-boxer's 6,619 "strikes" include 665 `boxing_circle_lead`,
   665 `boxing_circle_rear`, 659 `boxing_step_in_out` and 666 `boxing_distance_read` - circling, stepping and reading
   the range. None is a blow. Its real rate is about half what Q94 printed.
2. **"Landed" was `contact != "missed"`.** A blocked or slipped punch did not land.
3. **The cadence drivers were garbled.** A row cited `FightRealtime.gd:149` `RECOVERY_FLOOR := 0.55` (a knockdown
   recovery constant) and described it as "strike range of 1.1 m". A driver said the gate gives "~3.5 throws/s", a
   figure no measurement supports - the pair throws about 0.4 actions a second.

The fixture was right and stays EXACTLY as it is: same fighters, ruleset, 30 seeds from 900, rounds and round length.
The engine has not changed since Q94, so your action totals must come out identical: a 6619, b 8705.

## The definitions - use these, do not invent your own

- **A strike** is an action whose `technique` has `"delivers_blow": true` in `research/U79_admitted_strikes.json`
  (key `rows`, one row per technique `id`). Load that file in the tool. NOT the catalogue's `match.role`:
  `boxing_jab` has role `setup`, and a jab is a punch. A technique missing from the census: STOP and report it.
- **A setup** is an action whose technique has `"delivers_blow": false`.
- **Landed** means the event's `contact` is in `LANDED_CONTACTS` of `Godot/scripts/FightStoppageRead.gd:13`
  (read that line; copy its strings into `population.landed_contacts`).
- **A sequence** is a strike whose catalogue node (`Godot/assets/data/technique_catalog.json`, `disciplines[].nodes[]`)
  has `"kind": "sequence"` - a one-two is at least two punches, so
  `punches_per_min_lower_bound = (strikes_thrown + sequence_actions) / round_minutes`.

## What the tool adds (keep every Q94 key; the check reads these)

In `population`: `"landed_contacts": [...]`, `"blow_census": "res://research/U79_admitted_strikes.json"`.

In `pooled.a` and `pooled.b`:
- `by_role`: counts keyed by the EVENT's own `role` field, exact strings (a report; must sum to `actions`).
- `strikes_thrown`, `strikes_thrown_per_min`, `setups`, `setups_landed` (setups whose contact is a landed one - U79
  found footwork landing as blows; report how often it still does), `sequence_actions`,
  `punches_per_min_lower_bound`.
- `strikes_by_contact`: strikes only, keyed by the exact `contact` string; sums to `strikes_thrown`.
- `strikes_landed`, `strikes_landed_per_min`: strikes whose contact is landed.
- `strike_intervals_s`: gaps between ONE fighter's consecutive STRIKE starts inside one round (never across a round
  break): `p10`, `p50`, `p90`, `mean`, `n`, `share_below_0_35`, `share_below_0_45` (K33: real combination punches
  are 0.35-0.45 s apart).

In `pooled.pair`: `strikes_thrown`, `strikes_thrown_per_min`, `strike_intervals_s` (the pair's consecutive strike
starts, either man, same keys).

In `cadence`: redo `rows` from scratch. Each row's `quote` must be text ON its cited line (not near it), and its
`const` must appear inside that quote. Add:
```
"model": {"hz": <DEFAULT_HZ from FightRealtime.gd>, "impact_cadence_ticks": <CADENCE "impact" from TickBudget.gd>,
          "impact_period_s": ticks / hz, "impact_checks_per_min": 60 / impact_period_s,
          "strike_actions_per_min": {"a": <pooled.a.strikes_thrown_per_min>, "b": <...>},
          "share_of_checks_that_throw": {"a": strike_actions_per_min.a / impact_checks_per_min, "b": ...}}
```
`drivers`: one to three rows, each `why` in one sentence. **Every number a `why` cites must be in that row's quote,
in `model`, or in a measured `pooled` figure** (a share may be written as a percentage). The model says how few
of the impact checks become a throw - the drivers must name what decides that, from the code you read.

## What to read - ONLY these

- Your own `Godot/tools/measure_engine_pace.gd` (485 lines).
- `research/U79_admitted_strikes.json` - only to learn its shape (`rows[].id`, `rows[].delivers_blow`).
- `Godot/scripts/FightStoppageRead.gd` lines 1-20. `Godot/scripts/TickBudget.gd` lines 1-15.
- `Godot/scripts/FightRealtime.gd` (2,681 lines - NEVER open it whole). `grep -n` for what decides whether a fighter
  throws on an impact check (try `impact`, `gate`, `randf`, `range`, `arsenal`, `_choose`, `_pick`), and read
  `sed -n 'A,Bp'` windows of about 40 lines at the hits that matter.

## The digest `Q94_ENGINE_PACE.md`

Opens with `## DECISIONS`. Names the population in its own words (both styles). Then:
- one line starting `Q94 counted` saying what Q94 got wrong, with the old and new strike rates;
- per fighter: actions, strikes thrown, strikes landed and the punches lower bound a minute, against J20's
  12.5 thrown a minute (`research/J20_THE_VALIDATION_CORPUS.md`, row `| Punches thrown / landed / connect`);
- setups a minute and how many landed;
- the strike intervals with both shares;
- the model line and the drivers.

## Commit

`git status -s` first - your index still holds a staged Q94 mail file; do not commit it. Commit ONLY the three owned
files, paths on the commit line: `git commit -m "Q94B (Qwen): ..." -- <three paths>`. Then `git show --stat HEAD`
(it must list exactly those three), `git push -u origin qwen/q94b-pace-fix`,
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q94B ready" --body "<hash>"`.
Do not edit `HANDOFF.md`.

## The trap

The check recomputes your strike counts from U79's census and the catalogue, not from your own numbers. If it says
your `strikes_thrown` is wrong, your classification is wrong - fix the tool, never the JSON. And a GDScript runtime
error HANGS a headless run: read the log after the first minute; a `SCRIPT ERROR` line there means kill it and fix.

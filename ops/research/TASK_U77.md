# TASK U77 - CURSOR - THE LIMB THAT SCORES: TWO SUBSTRING CLASSIFIERS AND A RECORD WITH NO LIMB

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running S2's test
subsets in this checkout and only one Godot may run at a time. Your gate is a Python
script that MUST exit 0.

## Owned files

- `research/U77_limb_census.json` - **NEW, yours alone.**
- `research/U77_THE_LIMB_THAT_SCORES.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, data file, `U77_check.py`, `HANDOFF.md` or
`AgentComms/roadmap.json`.

## Why this exists

S2 gives every kick an explicit target region. But a scorecard needs the LIMB as well as
the region: the karate profile in `Godot/assets/data/combat_rulesets.json` weights
`head_hand` 1, `head_foot` 3, `body_hand` 1, `body_foot` 2; taekwondo `head_foot` 3,
`body_foot` 2, `body_hand` 1; kickboxing `body_foot` 0.3 and `legs` 0.5 against
`body_hand` 0.1; muay thai `body_foot` 0.5 and `legs` 0.6 against `body_hand` 0.2.

**Which limb landed is decided three ways, and none of them reads the adjudicated census:**

- `FightSimulation._is_kick` (`Godot/scripts/FightSimulation.gd` - 3,489 lines, never open
  it whole; `sed -n '2078,2106p'`) - an id/name SUBSTRING match on `KICK_MARKERS`, which
  includes `knee`, `spin` and `coup`. `_credit_zone_hit` files every landed strike under
  a zone with it. It is also read at `sed -n '3365,3385p'`.
- `FightRange._is_kick` (`Godot/scripts/FightRange.gd`; `sed -n '105,115p'` and
  `sed -n '440,485p'`) - a DIFFERENT marker list that excludes knees.
- The realtime engine: `Godot/scripts/RealtimeRoundStats.gd` (`sed -n '45,90p'` and
  `sed -n '120,145p'`) files a landed strike by `REGION_TO_ZONE` alone. Its own comment
  says a kick to the body is counted as `body_hand` and that this "is free until a
  ruleset turns zone weights on" - **and kickboxing and muay thai have turned them on.**

The adjudicated census already exists: Qwen's `research/Q70_kick_targets.json`
(`census`: 326 standing-strike candidates, `is_kick`) and
`research/Q77_strike_targets.json` (`rows`: the 200 non-kicks, `is_strike`,
`strike_kind`). R137 showed what a substring classifier does to a leg share; you are
measuring what the same method does to a scorecard.

## Scope

**1. The census - one row per Q70 census candidate, all 326.** `id`; `adjudicated` - `kick`
if Q70's census says `is_kick: true`, otherwise Q77's `strike_kind` when Q77 says
`is_strike: true`, otherwise `none`; `sim_is_kick` - what `FightSimulation._is_kick` answers
(probe = lower-case `id + " " + name`, elbow -> false, else any marker); `range_is_kick` -
what `FightRange._is_kick` answers (elbow or knee -> false, else any of ITS markers). Read
the node `name` from `Godot/assets/data/technique_catalog.json` with Python (670 KB -
never open it whole). **Transcribe both functions exactly - including their mistakes.**

`summary`: `sim_wrong` = strikes (adjudicated kind not `none`) where `sim_is_kick` differs
from `adjudicated == "kick"`; `range_wrong` the same for `range_is_kick`.

**2. The report** `U77_THE_LIMB_THAT_SCORES.md`:

- the two disagreement lists, every id named, grouped by discipline, with what each
  mislabel does to the zone it is filed under;
- **CONSUMERS** - every code site that reads either classifier and what number it moves
  (zone credit; the range band; the stance family at `:3377`), with line numbers;
- **THE REALTIME RECORD** - trace what `RealtimeRoundStats` reads for a landed strike back
  to where FightRealtime writes that event (`grep -n` for the event's fields in
  `Godot/scripts/FightRealtime.gd`, 2,535 lines, windows only). Is the technique id - and
  so the limb - available at that point or not? Quote the lines. Which zones can
  kickboxing and muay thai therefore NEVER credit, and which weights in their profiles
  are dead as a result;
- **OPTIONS** - at least: (a) an authored limb on each striking node (from Q70/Q77), read
  by all three sites; (b) keep the substring classifiers and fix their marker lists;
  (c) carry the technique id into the realtime record and classify there. Consequences of
  each for S2's per-discipline commits; recommend one. **Do NOT build it.**

## The JSON

    {"rows": [{"id": "muay_thai_straight_knee", "adjudicated": "knee",
               "sim_is_kick": true, "range_is_kick": false}],
     "summary": {"sim_wrong": 0, "range_wrong": 0},
     "recommend": "a"}

## THE TRAP

**Transcribe the classifiers, do not improve them.** The point is to measure what the
engine does today. A census that quietly fixes `spin` or `coup` while copying them reports
a number the engine does not produce. And name your catalogue: the report's first line
states the commit hash (`git rev-parse --short HEAD`) of the files you read.

## The gate

    python research/U77_check.py

It parses both marker lists from the code, recomputes every row and both disagreement
counts, and checks every mislabelled id is named. It fails now because your files do not
exist. **Fix YOUR FILES, never the checker.**

## Done

- Stay on `master`; no branch. **Never** `git checkout`, `switch`, `branch`, `stash`,
  `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git add -- research/U77_limb_census.json research/U77_THE_LIMB_THAT_SCORES.md`
  then `git commit -m "U77: ..." -- research/U77_limb_census.json research/U77_THE_LIMB_THAT_SCORES.md`
  ending `Co-Authored-By: Cursor <noreply@cursor.com>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from cursor --to claude --topic U77-done --body "<hash> candidates=326 sim_wrong=<n> range_wrong=<n> realtime_limb=<available|absent> recommend=<a|b|c> check=exit0"`
- Do NOT edit `HANDOFF.md`.

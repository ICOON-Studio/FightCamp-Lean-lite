# TASK Q79 - QWEN - WHAT A LANDED LEG KICK DOES, IN BOTH ENGINES

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Not the parse gate, not a
test. **Do NOT start Godot, for any reason**: Claude is running S2's test subsets in this
same checkout and only one Godot may run here at a time. Your gate is a Python script
that MUST exit 0.

## Owned files

- `research/Q79_leg_strike_consequences.json` - **NEW, yours alone.**
- `research/Q79_WHAT_A_LEG_KICK_DOES.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, data file, `Q79_check.py`, `HANDOFF.md` or
`AgentComms/roadmap.json`.

## Why this exists

S2 gives every kick an explicit target. Your Q70 table sends kicks to the legs that the
engine could never count as leg strikes before, and the MMA leg share is expected to move
from ~8% toward J20's 14-18% - roughly DOUBLE. When S2 then measures decisions, stoppages
and scorecards, some of them will move, and nobody can tell whether a moved number is
right without knowing everything a landed leg strike does. This census is that.

There are two engines. **FightSimulation** runs judo, wrestling, karate, bjj, sambo and
taekwondo bouts; **FightRealtime** (through `FightBeatAdapter`) runs boxing, kickboxing,
muay thai and MMA (`Godot/scripts/FightNightScreen.gd`, `grep -n REALTIME_RULESET_IDS`).

## Where to look (grep, then read 30-line windows - never a large file whole)

- `Godot/scripts/FightSimulation.gd` (3,489 lines): `grep -n "leg"` - start from
  `_apply_body_condition_deterioration`, `_mobility_factor`, `_credit_zone_hit` and
  `_apply_landed_effect`.
- `Godot/scripts/FightRealtime.gd` (2,535 lines): `grep -n "region"`.
- `Godot/scripts/ImpactModel.gd` - its per-region table.
- `Godot/scripts/FightTrauma.gd`, `Godot/scripts/FightStoppageRead.gd`,
  `Godot/scripts/RealtimeRoundStats.gd` (`REGION_TO_ZONE`), `Godot/scripts/FightBeatAdapter.gd`
  (`grep -n "leg"` - the `LEG KICK` label and the `react_leg` receiver role).
- Anchors on disk: `research/J20_THE_VALIDATION_CORPUS.md` (grep for leg, finish,
  knockdown, TKO) - quote file and line, or write "not on disk".

## Scope

**1. The JSON** `{"consequences": [...]}` - one entry per distinct thing a landed leg
strike changes: `{"engine": "simulation" | "realtime" | "both", "kind": one of damage,
body_condition, mobility, stamina, knockdown, stoppage, scoring, presentation, injury,
other, "file": "Godot/scripts/X.gd", "line": n, "token": "<verbatim substring of that
line>", "what": "one line", "bounded_by": "the cap, floor or clamp that limits it, with
its value - or \"unbounded\""}`.

**2. The report** `Q79_WHAT_A_LEG_KICK_DOES.md`, with sections:

- **SIMULATION** and **REALTIME** - the chain from "the region is chosen" to every number
  it changes, in order, quoting each line.
- **WHAT MOVES WHEN LEGS DOUBLE** - for each consequence, what a doubled leg share would
  push up or down (decision rate, stoppages, a slower fighter, judges' scores), and which
  is bounded so it cannot run away. **INFERENCE, labelled** - you are reading code, not
  running bouts.
- **ANCHORS ON DISK** - what real-fight numbers on disk each consequence could be checked
  against (J20's outcome mix, knockdown rate, pace), quoted; and what is NOT on disk (a
  leg-kick stoppage rate, a mobility loss from leg damage) - say so plainly.

## THE TRAP

**A region multiplier is not a consequence until something reads the region.** A table
that weights legs at 0.8 does nothing if the code path that applies it never runs for a
leg strike. For every entry, follow the value to where it is used and cite THAT line - a
constant's declaration alone is not a consequence.

## The gate

    python research/Q79_check.py

It checks every citation holds its token, both engines and the named files are covered,
and the sections. It fails now because your files do not exist. **Fix YOUR FILES, never
the checker.**

## Done

- THIS CHECKOUT IS SHARED WITH A LIVE CLAUDE SESSION. Stay on `master`. **Never** run
  `git checkout`, `git switch`, `git branch`, `git stash`, `git reset`, `git clean`,
  `git add -A`, `git pull` or `git push`.
- `git status -s` first. Commit ONLY your two paths, ON the commit line:
  `git add -- research/Q79_leg_strike_consequences.json research/Q79_WHAT_A_LEG_KICK_DOES.md`
  then `git commit -m "Q79: ..." -- research/Q79_leg_strike_consequences.json research/Q79_WHAT_A_LEG_KICK_DOES.md`
  ending the message with `Co-Authored-By: Qwen <noreply@qwen.ai>`.
- Then `git show --stat HEAD` must list exactly those two files. If it lists anything else,
  say so in your mail - do not try to fix it.
- **Do NOT push.** Claude pushes it.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --topic Q79-done --body "<hash> consequences=<n> simulation=<n> realtime=<n> unbounded=<n> check=exit0"`
- Do NOT edit `HANDOFF.md`.

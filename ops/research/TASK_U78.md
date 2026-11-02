# TASK U78 - CURSOR - WHAT A BOOKED BOUT NEEDS TO REACH THE 3D ROOM

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running S2's test
subsets in this checkout and only one Godot may run at a time. Your gate is a Python
script that MUST exit 0.

## Owned files

- `research/U78_booked_bout_census.json` - **NEW, yours alone.**
- `research/U78_THE_ROOM_TAKES_A_REAL_FIGHT.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, scene, test, data file, `U78_check.py`,
`HANDOFF.md` or `AgentComms/roadmap.json`.

## Why this exists

Stage S4, "The room takes a real fight": `FightWorldLiveScreen` - the 3D room - is
hardcoded to boxing, two fixed fighters and seed 94301, reached only by a dev route. A
booked career bout never gets there. S4 makes it accept one: any realtime ruleset, both
career athletes, the right arena. This census is what S4 starts from, so it does not
spend its first hour finding the hardcodes.

## Where things are (windows only - never open a large file whole)

- `Godot/scripts/FightWorldLiveScreen.gd` (488 lines - small enough to read whole): the
  constants at the top and `setup()`.
- `Godot/scripts/SceneRouter.gd` (429 lines): the `fight_world_live` route (`grep -n`).
- `Godot/scripts/FightNightScreen.gd`: `sed -n '30,45p'` (`REALTIME_RULESET_IDS`),
  `sed -n '230,330p'` (how a booked bout begins - `FightBeatAdapter.begin` for realtime,
  `FightSimulation.begin_fight` otherwise - and what it passes).
- `Godot/scripts/GameState.gd` is ~13,000 lines - **never open it whole.** `grep -n` for
  `book_fight`, `bout_id` and `get_booked_fight_due_day`, and read 30-line windows around
  what you find.
- `Godot/scripts/FighterPhysique.gd` (what a career athlete's body is, as numbers) and
  `Godot/scripts/ArenaSurface.gd` / `ArenaRig.gd` (which arena specs the room can build):
  `grep -n` for their public funcs and read those windows.
- `Godot/assets/data/combat_rulesets.json`: each ruleset's `arena_profile`.
- The twelve bodies: `Godot/assets/models/fighters/*_rigged.glb`. Their file names encode
  sex, discipline and weight (`f03_f_box_fly`). Codex's C98
  (`research/C98_FIGHTER_SKINNING.md`) measured two of them - f06 and f08 - at a
  mesh height of **1.00 m** where the rest are 1.75 / 1.85 m.

## Scope

**1. The JSON.**

- `hardcodes`: every constant or literal in `FightWorldLiveScreen.gd` (and anything it
  loads that pins the same choice) that fixes the bout: `{"file", "line", "token",
  "what", "replace_with"}` - `token` a verbatim substring of that line.
- `route`: every code site between "a bout is booked" and "a fight screen opens", same
  shape.
- `arenas`: one row per ruleset in `combat_rulesets.json`: `{"ruleset", "arena_profile",
  "built_today": true|false, "evidence"}` - can `ArenaSurface`/`ArenaRig` build that
  profile now.
- `bodies`: one row per rigged fighter file: `{"file", "sex", "discipline", "weight",
  "height_note"}`.

**2. The report** `U78_THE_ROOM_TAKES_A_REAL_FIGHT.md`, with sections:

- **HARDCODES** - the table, and what each must become.
- **WHERE A BOOKED BOUT LIVES** - the data a booked bout carries today (athlete ids, ruleset,
  seed, venue), where it is stored, and the exact point it would have to hand over to the
  room.
- **WHICH BODY** - how a career athlete (sex, weight class, discipline, physique) would
  choose among the twelve files; which athletes have NO fitting body (a judoka, a
  karateka, a heavyweight woman...); what C98's two 1.00 m files mean for that choice.
- **WHICH ARENA** - per realtime ruleset (`REALTIME_RULESET_IDS`), the profile and whether
  the room builds it today.
- **THE ENTRY CONTRACT** - a proposed `FightWorldLiveScreen` entry (a function or a scene
  parameter) and the dictionary it takes, field by field, each field traced to where the
  booked bout already holds it. Options, not code. **Do NOT build it.**
- **GAPS** - what S4 cannot do with what exists (no body, no arena, no route), each a
  one-liner S4 can turn into a task.

## THE TRAP

**The dev route is not the game.** `SceneRouter`'s `fight_world_live` entry is a dev tier
route with no rail; the real path runs through `FightNightScreen`. A census that only
traces the dev route will propose wiring the room to a door no player ever opens. Trace
the booked bout from the booking, not from the room.

## The gate

    python research/U78_check.py

It checks every file:line citation holds its token, recomputes the arena and body tables
from disk, and checks the sections. It fails now because your files do not exist. **Fix
YOUR FILES, never the checker.**

## Done

- Stay on `master`; no branch. **Never** `git checkout`, `switch`, `branch`, `stash`,
  `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git add -- research/U78_booked_bout_census.json research/U78_THE_ROOM_TAKES_A_REAL_FIGHT.md`
  then `git commit -m "U78: ..." -- research/U78_booked_bout_census.json research/U78_THE_ROOM_TAKES_A_REAL_FIGHT.md`
  ending `Co-Authored-By: Cursor <noreply@cursor.com>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from cursor --to claude --topic U78-done --body "<hash> hardcodes=<n> route=<n> arenas_built=<n>/11 bodies=12 no_body_for=<short list> check=exit0"`
- Do NOT edit `HANDOFF.md`.

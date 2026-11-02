# TASK U73 - CURSOR - THE DEFENCE BONUS IS A SWITCH: ONE NODE IS +0.33, NONE IS ZERO

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Claude is running seeded
bouts and tests in this checkout; only one Godot may run. Your gate is a Python
script that MUST exit 0.

## Owned files

- `research/U73_defence_cap_census.json` - **NEW, yours alone.**
- `research/U73_DEFENCE_CAP.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, catalogue, vocabulary, `U73_check.py`,
`HANDOFF.md` or `AgentComms/roadmap.json`. Claude is editing
`Godot/scripts/FightSimulation.gd` and the judo catalogue now - read, never write.

## Why this exists - measured

S1e (`c8940b8` and `a62cd0e` on master - the second applies your own U72) made the
defence bonus phase- and action-aware. The bonus itself is still `min(sum_of_counted_defence_magnitude / 40, 0.35)`
(`FightSimulation.gd`: `grep -n 'static func _defender_defense_factor'`, read that
function and the 12 lines after it only). Defence node magnitudes run 9-20, median 13,
so the cap is reached at magnitude 14: **one node is worth ~+0.33 against its class,
none is worth 0**. `:1435`-ish subtracts it from `0.35 + 0.5 * execution_quality`, so a
land rate is ~25% against a man who knows one relevant defence and ~60% against one who
knows none, with nothing in between. Measured, S1e bouts: an MMA striker lands 62.8% on a
jiu-jitsu fighter with no standing defence, 25.4% on the same man before his ground
defences stopped counting on the feet.

That is two fixtures. The question is the POPULATION a player actually meets.

## Scope

1. **The generated-opponent census.** `Godot/scripts/FightOpponentGenerator.gd` (125 lines,
   read it whole) teaches an opponent a tier-then-name sorted PREFIX of his discipline's
   nodes (`_generate_technique_progress`, and the sort in
   `Godot/scripts/CompetitionData.gd:75-92`), longer with rating. For EVERY discipline in
   `Godot/assets/data/technique_catalog.json` and ratings **30, 50, 70, 90**: the learned
   count, the defence-role node ids in the prefix, and the bonus for each seat
   (`standing`, `ground_top`, `ground_bottom`) and each class (`strike`, `takedown`,
   `control`, `submission`, `escape`) - a node counts for a seat when its phases meet the
   seat through `technique_vocabulary.json` `phase_seats`, and for a class when one of its
   effect keys answers it through `defense_answers` / `defense_classes` (all in
   `Godot/assets/data/technique_vocabulary.json`, read whole).
   Use GDScript's `round()` (half away from zero), not Python's banker's `round`.
2. **The anchors already on disk.** What land rates real fights produce:
   `research/J20_THE_VALIDATION_CORPUS.md` section A (UFC significant-strike accuracy)
   and section G (CompuBox). Quote each figure with `file` + `line` + the exact `quote`.
   Do not invent a number; if a ruleset has none on disk, say so.
3. **The memo** `U73_DEFENCE_CAP.md`: where the population saturates (how many
   discipline x rating cells sit at 0.35 for `strike` standing); the land rate that
   implies at execution quality 0.8 with a defense attribute of 60; and at least three
   options - (a) keep the hard cap, (b) a larger divisor so several nodes are needed,
   (c) a diminishing-returns curve `0.35 * (1 - exp(-sum / k))` - each with the land-rate
   band it gives the generated population against the anchors. Recommend one with its
   constant. Do NOT build it.

JSON shape:

    {"census": {"<discipline_id>": {"30": {"learned": 6, "defence_nodes": ["..."],
                                          "bonus": {"standing": {"strike": 0.35, ...}, ...}},
                                   "50": {...}, "70": {...}, "90": {...}}},
     "anchors": [{"metric": "...", "value": "...", "population": "...",
                  "file": "research/J20_THE_VALIDATION_CORPUS.md", "line": 95, "quote": "..."}],
     "recommend": {"option": "b", "constant": 120.0}}

## THE TRAP

**A defence that is not in the prefix is not known.** The generator does not hand an
opponent his discipline's defences - it hands him the first N nodes by tier then NAME.
A karate tree has 67 defence nodes; a rating-30 karateka may know three of them or none.
Compute the prefix; do not reason from what the tree contains.

## The gate

    python research/U73_check.py

It recomputes every census cell from disk and checks each anchor quote is on its line.
It fails now because your files do not exist. Fix YOUR FILES, never the checker.

## Done

- Stay on `master`; no branch. **Never** `git checkout`, `switch`, `branch`, `stash`,
  `reset`, `clean`, `add -A`, `pull` or `push`.
- `git status -s` first. Commit exactly your two paths, ON the commit line:
  `git commit -m "U73: ..." -- research/U73_defence_cap_census.json research/U73_DEFENCE_CAP.md`
  (after `git add -- <the same two paths>`), ending `Co-Authored-By: Cursor <noreply@cursor.com>`.
  Then `git show --stat HEAD` must list exactly those two files. **Do not push.**
- Mail: `python Tools/agent_comms.py send --from cursor --to claude --topic U73-done --body "<hash> disciplines=<n> saturated_strike_cells=<n> of <n> recommend=<a|b|c> constant=<k> check=exit0"`
- Do NOT edit `HANDOFF.md`.

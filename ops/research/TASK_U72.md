# TASK U72 - CURSOR - A SPRAWL BLOCKS A JAB: WHICH INCOMING ACTION EACH DEFENCE ANSWERS

Model: Composer, **medium effort**. Owner: cursor. Launched `-p --force --trust`.

**Test tier: RESEARCH, NO `.gd` TOUCHED - NO GODOT AT ALL.** Do NOT start Godot:
Claude is running seeded bouts in this checkout and only one Godot may run at a
time. Your one gate is a Python script (below) that MUST exit 0.

## Owned files

- `research/U72_defence_answers.json` - **NEW, yours alone.**
- `research/U72_DEFENCE_ANSWERS.md` - **NEW, yours alone.**

Nothing else. Do NOT edit any script, test, `technique_catalog.json`, `U72_check.py`,
`HANDOFF.md` or `AgentComms/roadmap.json`. Claude is editing
`Godot/scripts/FightSimulation.gd` right now - read it, never write it.

## Why this exists - measured, not assumed

`FightSimulation._defender_defense_factor` (`Godot/scripts/FightSimulation.gd:2426-2437`;
the file is 3,295 lines - never open it whole, read `sed -n '2426,2437p'`) sums the
magnitude of EVERY `defense`-role technique a man knows, divides by 40, caps the
result at 0.35, and adds `defense_stat / 100 * 0.35`. `:1398` (read
`sed -n '1390,1412p'`) subtracts that from the success chance of EVERY incoming
action, whatever its role.

Defence node magnitudes run 9 to 20 (median 13), so ONE node is worth 0.225 to
0.35 - as much as or more than the whole defence attribute. Claude's S1e baseline
(`tools/measure_ground_seats.gd`, 40 seeded bouts, MMA grappler vs MMA striker):
the striker knows exactly one defence node, `wrestling_sprawl` (magnitude 19 ->
the full +0.35). The grappler knows none. **The grappler lands 43 of 209 standing
strikes (20.6%) and the striker 395 of 645 (61.2%); the grappler wins 0 of 40.**
The sprawl is defending jabs, kicks, passes and armbars.

The realtime presenter already knows better: `Godot/scripts/FightMoves.gd:880-935`
(read that window) says wrestling contributes no strike guards, and classifies
effect keys into EVADE / BLOCK / FOOTWORK strike guards. Precedent for a defence
that answers only some actions also exists in the engine: `_camp_defense_bonus`
(`sed -n '1052,1062p'`) gives `anti_wrestler` +0.12 against `takedown` only.

S1e is making the bonus phase-aware (Q73 option a: count a defence node only when
its seats include the seat the defender is in). That does not touch the sprawl -
its seats include standing. This task is the other half: what each node defends.

## Scope

1. **The key table.** Every effect key that appears on any `defense`-role node
   (derive the set from `Godot/assets/data/technique_catalog.json`,
   `disciplines[].nodes[]`) mapped to the INCOMING action classes it answers, a
   subset of: `strike` (incoming role setup / damage / counter), `takedown`
   (takedown), `control` (control / transition - clinch control, passes, pins,
   sweeps), `submission`, `escape`. An empty list is allowed for a key that
   answers nothing by itself (say why). One `reason` per key; cite the engine or
   presenter line when either already treats that key.
2. **The nodes.** Every `defense`-role node: `discipline`, `tier`, `magnitude`
   (sum of absolute effect values, as `_technique_magnitude` does), `seats` (the
   union of `Godot/assets/data/technique_vocabulary.json` `phase_seats` over its
   phases - NOT your reading of the words), and `answers` = the union of its keys'
   answers. You MAY override a node's answers when the union is wrong for that
   technique; then `override_reason` is required.
3. **Saturation, per discipline.** For each discipline: count of defence nodes,
   total magnitude, and the bonus `min(total/40, 0.35)` for (i) all its defence
   nodes and (ii) its tier <= 2 nodes - today (phase- and action-blind), and under
   seat + answers per seat (`standing`, `ground_top`, `ground_bottom`) per class.
4. **The memo** `U72_DEFENCE_ANSWERS.md`: the table, the nodes whose answers you
   overrode, the disciplines that saturate the cap, and at least three options -
   (a) Q73's seat filter alone, (b) seat + answers (one pool per incoming class),
   (c) (b) with a diminishing-returns curve instead of the hard /40 cap - with what
   each does to the MMA grappler-vs-striker numbers above. Recommend one. Do NOT
   build it.

JSON shape:

    {"keys": {"<effect_key>": {"answers": [...], "reason": "..."}},
     "nodes": {"<id>": {"discipline": "...", "tier": 1, "magnitude": 19.0,
                        "seats": ["standing", ...], "answers": [...],
                        "override_reason": ""}},
     "disciplines": {"<discipline_id>": {"nodes": 3, "magnitude": 45.0,
                        "bonus_all": 0.35, "bonus_tier12": 0.35,
                        "seat_answer_all": {"standing": {"strike": 0.35, ...}, ...}}}}

`seat_answer_all[seat][class]` = `min(sum of magnitude of the discipline's defence
nodes whose seats include seat AND whose answers include class / 40, 0.35)`, with
every seat and every class present (0.0 when nothing counts).

## THE TRAP

**A word in a key is not what it answers.** `guard_control` and `guard_recovery`
sit in the presenter's BLOCK list, but they are a bottom man keeping his guard -
they answer a pass, not a punch. `front_headlock_open` contains `head` and is
what a sprawl OPENS, not what it stops. Adjudicate each key from the techniques
that carry it (list them), not from its spelling.

## The gate - run it, it must exit 0 before you commit

    python research/U72_check.py

It recomputes the node census, seats, unions and every bonus from disk, and checks a
few anchors. **It fails right now** because your files do not exist. If it fails,
fix YOUR FILES - never the checker.

## Done

- Shared checkout: stay on `master`. **Never** `git checkout`, `switch`, `branch`,
  `stash`, `reset`, `clean`, `add -A`, `pull` or `push`. Do not create a branch.
- `git status -s` first. The paths go ON the commit line, both of them, nothing else:
  `git commit -m "U72: ..." -- research/U72_defence_answers.json research/U72_DEFENCE_ANSWERS.md`
  (after `git add -- <the same two paths>`), ending with
  `Co-Authored-By: Cursor <noreply@cursor.com>`. **Do not push.**
- Then check your own commit: `git show --stat HEAD` must list exactly those two files.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --topic U72-done --body "<hash> keys=<n> nodes=<n> strike_only=<n> takedown=<n> overrides=<n> recommend=<a|b|c> check=exit0"`
- Do NOT edit `HANDOFF.md`.

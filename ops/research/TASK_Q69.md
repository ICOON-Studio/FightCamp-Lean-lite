# TASK Q69 — QWEN — THE RENAME THAT MUST NOT MOVE A FIGHT

Model: qwen3-coder, **medium effort**. Owner: qwen.

**Test tier: RESEARCH — you edit NO `.gd` file and NO `.json` data file.** There
is NO parse gate, NO focused test, and you must **NOT run `run_tests.py` or
launch Godot at all**. Another agent holds the single Godot slot in this
checkout and a second one corrupts both runs. `git status -s` before you stage
is the whole check.

**YOU ARE MEASURING, NOT RENAMING.** Do not touch
`Godot/assets/data/technique_catalog.json`. It is locked by S1c, which is
landing a catalogue merge on another branch right now, and an edit here would
collide with it.

## Owned files

- `research/Q69_RENAME_COLLISIONS.md` — NEW, yours alone.
- `research/Q69_rename_table.csv` — NEW, yours alone.

Touch nothing else. Do **NOT** edit `HANDOFF.md`.

## Why this exists

The operator ruled on 2026-09-12 that all five R130 effect groups ship, **and
that the ORDER is part of the ruling**: the 23-key rename pass goes first,
specifically because it is *"no behaviour change, no verdict movement"*.

**That claim is true only if every rename is one-key-to-one-key.** Here is the
mechanism, and it is the whole task:

`FightSimulation._technique_magnitude` (`:2639`) sums `abs(value)` over **every**
effect on a node, whatever the key is called. So renaming `straight_damage` to
`damage` costs nothing — **unless that node ALREADY carries `damage`.** Then two
dictionary entries collapse into one, the node loses that term from its
magnitude, and the technique gets weaker. A weaker technique changes what lands,
which changes a seeded fight's verdict.

**A rename that collides is not a rename. It is a silent nerf.** Nobody has
checked whether any of the 23 collide, and the ruling that put the rename first
assumed they do not.

## What to read — and only these

- `research/U59_THE_UNREAD_EFFECTS.md` — the triage that named 23 keys as
  duplicates of keys that ARE read. This is your input list.
- `research/R130_UNREAD_EFFECTS_DECISION_SHEET.md` — the operator's ruling
  is stamped at the bottom; the duplicate-rename section names examples
  (`angle_read` → `angle_attack`, `angle_reset` → `angle_exit`,
  `straight_damage` → `damage`, `close_damage`, `counter_score`, `kick_speed`).
- `Godot/tools/audit_technique_effects.py` — the existing measurement tool. Read
  it and reuse it; do not write a second one that counts differently.

`Godot/scripts/GameState.gd` is 12,938 lines and `FightSimulation.gd` about
2,600 — you need NEITHER opened whole. If you must confirm a key is read, `grep
-n '"<key>"'` and read a small `sed -n 'A,Bp'` window around the hit.

## The output contract

`Q69_rename_table.csv`, exactly this header:

```
old_key,new_key,nodes_with_old,nodes_with_both,collision,magnitude_delta,verdict
```

- `nodes_with_old` — how many nodes carry the old key.
- `nodes_with_both` — **the number that matters**: nodes carrying the old key
  AND the new key.
- `collision` — `yes` when `nodes_with_both > 0`, else `no`.
- `magnitude_delta` — the total magnitude that would be LOST across all colliding
  nodes if the rename were applied naively (sum of `abs(old_value)` on those
  nodes, since the old entry disappears into the new one).
- `verdict` — one of `SAFE` (no collision), `NEEDS_MERGE` (collides; the two
  values must be added, not overwritten), or `NOT_A_DUPLICATE` (you checked and
  the two keys do not mean the same thing — say so in the prose).

`Q69_RENAME_COLLISIONS.md` opens with these lines and nothing before them:

```
Q69 pairs=<int> safe=<int> needs_merge=<int> not_a_duplicate=<int>
Q69 colliding_nodes=<int> magnitude_at_risk=<float>
Q69 unread_keys_before=<int> unread_keys_after=<int>
```

Then, in prose:

1. **Every colliding pair, named**, with the node ids that collide. If none
   collide, say `safe=23` and say it plainly — a clean result is a real result.
2. **The pairs you judge NOT to be duplicates.** U59's triage is a starting
   point, not scripture. `counter_score` and `counter_damage` may or may not be
   the same idea; `kick_speed` against `combo_speed` may not be. Where you
   disagree with U59, say so and give your reason.
3. **The safe order to apply them in**, if order matters at all.

## Rules

- **Report what you measure.** If a pair has zero collisions, the row says zero.
  Do not pad the table to look thorough.
- **Derive every count from the catalogue, in code.** Do not hand-type a number
  you read in U59 — U59 measured a 272-node catalogue and the tree has grown.
  State which node count yours ran against.
- Where you are unsure whether two keys mean the same thing, mark the verdict
  `NOT_A_DUPLICATE` and say in the prose that it is UNVERIFIED. An honest
  uncertain row beats a confident wrong one.

## Done

- `git status -s` FIRST, then `git add --` your **two explicit paths only**.
  Never `git add -A`, and never a bare `git stash` / `reset --hard` /
  `checkout .` / `clean` — this checkout is shared and has live uncommitted work
  in it.
- Commit ending `Co-Authored-By: Qwen <noreply@qwen.ai>`, then
  `git push origin master`.
- One line of mail:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q69-done --body "<hash> pairs=<n> collisions=<n> magnitude_at_risk=<f> not_a_duplicate=<n>"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## THE ONE TRAP

**Counting nodes that carry the old key is the easy half and it is not the
answer.** The number that decides whether the operator's "no verdict movement"
holds is `nodes_with_both`. A table of 23 rows that all say `nodes_with_old=6`
and never looks for the overlap would pass review and be worthless — it would
answer a question nobody asked while the rename silently nerfs six techniques.

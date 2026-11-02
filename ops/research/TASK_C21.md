# TASK C21 — THE RANGE BANDS IN THE CATALOG (Codex)

Model: top tier, effort medium, Fast off.

Pure DATA work on `Godot/assets/data/technique_catalog.json` plus one
validator and one test. **No `FightSimulation.gd`, no `FightRange.gd`, no
screen, no `.tscn`.** Per `AGENTS.md` precedence this task file beats the
general rule: **write no `HANDOFF.md` block** — Claude writes it.

## Why this exists

R35 shipped THE RANGE (stage A): the standing fight is now played on a
contested distance band — `OUT / LONG / MID / POCKET / CLINCH` — and every
technique has to answer two questions. From which bands can it be thrown,
and where does throwing it leave the fight.

`Godot/scripts/FightRange.gd` answers both today by DERIVING them from data
already in the catalog (phases, role, discipline, id/name markers). The
derivation is deliberately catalog-optional so the engine could ship without
waiting on this task, and it is honest for the 113 nodes that carry a
`clinch` / `pocket` / ground phase. It is a guess for the other 159, which
all carry the single undifferentiated phase `"standing"` — a teep, a jab and
a shovel hook are the same node to it.

This task replaces the guess with authored values. **Every value you write
overrides the derivation for that node** (`FightRange.bands_for` /
`FightRange.delta_for` check the authored field first), so this is a pure
accuracy upgrade with no engine change and no risk of a half-finished pass
breaking anything.

## The schema

Two new optional keys inside each node's existing `match` block:

```json
"match": {
  "role": "damage",
  "phases": ["standing"],
  "range_band": ["MID", "POCKET"],
  "range_delta": 1,
  "effects": { "...": 0 }
}
```

- **`range_band`**: array of band ids from `["OUT", "LONG", "MID", "POCKET",
  "CLINCH"]`, uppercase. A single string is also accepted but prefer the
  array. These are the bands the move is AT HOME at. One band away it is
  still thrown, at a heavy weight penalty; two bands away the engine gates
  it out entirely (`FightRange.GATE_BAND_DISTANCE`). So a two-band spread is
  the practical maximum and most nodes want one or two entries.
- **`range_delta`**: integer in `[-2, 2]`, **in ladder steps, positive
  toward CLINCH**. `+1` = the move ends one band CLOSER than it began.
  `-1` = it ends one band FURTHER OUT. `0` = it leaves the distance where it
  was, and is the right answer for most single strikes.

`OUT` is never a valid `range_band` for a technique: nothing is thrown from
out of range. It exists on the ladder only as the state the fight is in when
neither man will engage.

## What to author

All 272 nodes across the 15 disciplines in `disciplines[].nodes[]`. Work
discipline by discipline; the four rules below settle most of them.

1. **A node whose `phases` already pin it** (`clinch`, `clinch_break`,
   `cage_clinch`, `weapon_clinch`, `standing_back`, `pocket`, or any ground
   phase) is the easy case — confirm the obvious band and move on. Ground-only
   nodes are never band-gated; give them `range_band` anyway only if the move
   genuinely has a standing entry.
2. **The 159 `"standing"` nodes are the real work.** Ask what the fighter's
   feet are doing. A jab, a teep, a low kick, a long guard: `LONG` and/or
   `MID`. A cross, a body kick, a level change: `MID`. A hook, an uppercut,
   a shovel hook, dirty boxing: `MID` and `POCKET`. A head kick from a
   taekwondo or karate tree: `LONG`, `MID`.
3. **`range_delta` is about the FEET, not the damage.** A teep, a push kick,
   a frame, a pivot, a sprawl, an oblique kick: `-1`. An overhand, an
   uppercut off a slip, a level change, a shot, a body lock, a collar tie,
   an underhook: `+1`. Everything else: `0`. Resist making it interesting —
   a catalog where half the moves shove the band around produces a fight
   that never settles anywhere.
4. **Sequences (`kind: "sequence"`)** get the band their FIRST link is
   thrown from, and a `range_delta` equal to the net travel of the whole
   chain (combinations travel inward, so most are `+1`). Stage B rebuilds
   combos as per-link range walks and will read these.

## The validator

Add to `Godot/scripts/CompetitionData.gd` (or wherever the catalog's
existing structural validation lives — find it, do not add a second one):

```gdscript
func validate_technique_range_data() -> Dictionary:
```

Returns `{"ok": bool, "errors": Array}` and rejects: a band id not on the
ladder, `"OUT"` used as a technique band, a `range_delta` outside `[-2, 2]`,
a `range_band` spread wider than two ladder steps (which the engine would
gate out of its own middle), and an empty `range_band` array.

## Owned files

- `Godot/assets/data/technique_catalog.json`
- `Godot/scripts/CompetitionData.gd` (the validator only)
- `Godot/tests/technique_range_data_test.gd` (new)

## Do not touch

`Godot/scripts/FightRange.gd`, `Godot/scripts/FightSimulation.gd`,
`Godot/tests/fight_range_test.gd`. Those are R35's and stage B's.

## Anchors

- Ladder, gate distance and the derivation you are replacing:
  `Godot/scripts/FightRange.gd:44` (`BANDS`), `:129`
  (`GATE_BAND_DISTANCE`), and `_derived_bands` / `_derived_delta` at the
  bottom of the file.
- The authored-wins contract: `FightRange.bands_for` and
  `FightRange.delta_for`.
- Catalog shape: `disciplines[].nodes[].match`, e.g. the first node
  `boxing_stance_guard`.
- The engine's existing phase histogram, for a sanity check on your pass:
  `standing 159, clinch 44, ground_top 25, pocket 20, scramble 15,
  ground_bottom 15, weapon_standing 13, ground 5, weapon_clinch 4,
  cage_clinch 4, clinch_break 2, standing_back 2`.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/CompetitionData.gd Godot/tests/technique_range_data_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/technique_range_data_test.gd
```

Then confirm you have not moved the engine underneath R35:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_range_test.gd
```

Both must exit 0, and `fight_range_test.gd` must still report 0 failures —
its catalog sweep asserts every node derives or declares a legal band.

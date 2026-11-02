# TASK R35 — THE RANGE (Claude)

Model: Opus, effort high, Fast off. One session; end it when the stage ships.

Stage A of the distance system. Greenlit by the operator 2026-09-06 after a
design analysis of how space and distance work in combat sports: option B
(range + combos as range walks + a corner range call), delivered as A first
because A is independently valuable and de-risks the catalog pass.

## Why this exists

`FightSimulation.gd` had no distance axis at all. Its own header admits the
collapse: the catalog phases `pocket`, `clinch`, `clinch_break` and
`standing_back` all counted as one STANDING macro-phase, so a teep, a jab
and a shovel hook were the same action thrown from the same nowhere, and 44
authored clinch nodes plus 20 pocket nodes had nowhere to happen.

The design already expected this. `ATHLETE_PROFILE_TECHNIQUE_DESIGN.md`
section 7 weights every action by

```
action_weight = base_tactical_weight * phase_legality * range_and_position_fit * ...
```

and `range_and_position_fit` was specified in the document that authored the
272-node catalog and never implemented. R35 is that factor.

## The model

RANGE IS ONE CONTESTED SHARED STATE, and each fighter wants a different
value of it.

- Ladder: `OUT / LONG / MID / POCKET / CLINCH`. GROUND keeps its own
  macro-phase and never reads the band.
- Every technique answers two questions — which bands it is at home at, and
  where throwing it LEAVES the fight (`range_delta`, in ladder steps,
  positive toward CLINCH). Combinations therefore travel inward on their
  own, which is what real ones do.
- Each fighter's preferred band comes from the reach he has RELATIVE TO
  THIS OPPONENT, his primary discipline and his plan. The same gap is his
  range or no-man's-land depending on who is longer; that asymmetry is
  where "styles make fights" comes from.
- Every exchange the two argue about the band. The winner moves it one step
  toward his own; the man who wants it where it already is can hold it.
- Crossing a longer opponent's band to reach your own hands him one free
  look — walking onto the jab, priced.
- One hard gate only: two bands out of position and the move is not
  available. One band off is priced in the draw, because a fighter really
  does throw the wrong shot from the wrong place.

## Owned files

- `Godot/scripts/FightRange.gd` (new)
- `Godot/scripts/FightSimulation.gd`
- `Godot/tests/fight_range_test.gd` (new)
- `Tools/agent_comms.py`, `AgentComms/README.md` (Maria registered)

## Anchors

- `Godot/scripts/FightRange.gd:1` — the whole design in the file header.
- `FightSimulation.begin_fight` — `range_band` / `range_owner` /
  `range_event` on `fight_state`, preferred bands set at the opening bell.
- `FightSimulation._contest_range` and `_apply_range_delta` — the two new
  helpers, above `_resolve_exchange`.
- `FightSimulation._eligible_actions` — the one hard band gate.
- `FightSimulation._weighted_choice` — `range_fit`, the design's own
  `range_and_position_fit` term.
- `FightSimulation._resolve_action` — the comfort tax on execution, the
  entry toll on the defender's read, `range_band` / `entered_range` on
  every action event.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/FightRange.gd Godot/scripts/FightSimulation.gd Godot/tests/fight_range_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_range_test.gd
```

Then the systems it touches: `fight_simulation_test.gd`,
`combo_chains_test.gd`, `fight_scoring_test.gd`, `fight_playback_test.gd`,
`fight_targeting_test.gd`, `fight_plans_test.gd`. Full suite once before the
commit.

## What stage B adds (not this task)

Combos rebuilt as per-link range walks with abort points, and a corner range
instruction ("stay long", "get inside", "tie him up"). Kalli K22 rules the
vocabulary, Maria M1 rules the visual language, Codex C21 authors the
catalog's explicit band data.

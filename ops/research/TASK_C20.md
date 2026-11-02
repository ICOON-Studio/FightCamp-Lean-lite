# TASK C20 — THE FIGHT CAMP READ API (Codex)

Model: top tier, effort medium, Fast off.

Read-only API work on `GameState.gd`. **No screen, no `.tscn`, no UI.**
Per `AGENTS.md` precedence this task file beats the general rule: **write no
`HANDOFF.md` block** — Claude writes it.

## Why this exists

R34 rebuilds the FIGHT CAMP surface. Today that surface would need FOUR reads
per rebuild — `get_fight_camp_options()`, `get_fight_camp_projection()`,
`get_fight_camp()`, `get_fight_camp_report()` — plus `get_weight_status()`, and
it would have to decide for itself which of the three states it is in. Every
kit hub since C6 reads ONE call once per rebuild and decides nothing
(`get_fighter_card` `11024`, `get_schedule_month` `11169`, `get_scouting_board`
`11383`, `get_booking_board` `11169`+). This is that call for the camp.

There is a second reason, and it is the interesting one. **The panel can show
what a set of choices produces, but never what a single pick CHANGED.**
`FightCamp.projection()` returns absolutes. A player picking between HARD
SPARRING and a taper sees two full projections and has to diff them by eye.
Give the diff.

## The one function

```gdscript
func get_camp_board(athlete_id: String, choices: Dictionary = {}) -> Dictionary:
```

Returns:

```
{
  "athlete_id": String,
  "athlete_name": String,
  "career_week": int,
  "state": String,           # "setup" | "progress" | "report" | "unavailable"
  "reason": String,          # why, when state is "unavailable"; "" otherwise
  "setup": Dictionary,       # only when state == "setup"
  "progress": Dictionary,    # only when state == "progress"
  "report": Dictionary,      # only when state == "report"
  "weight": Dictionary,      # get_weight_status(), always
}
```

`state` is the whole point: the screen must never work out for itself whether a
camp is running, finished, or impossible. `"unavailable"` covers every refusal
`get_fight_camp_options()` already names — no bout booked, the fight is this
week, athlete not found — and `reason` carries its exact words.

**`setup`** passes through everything `get_fight_camp_options()` already emits
(`weeks`, `ruleset_id`, `opponent`, `focus_tracks`, `protocols`,
`partner_roles`, `partners`, `coaches`, `counters`, `slots`, `film_depth`,
`cut_plans`) and adds:

| Key | Type | Meaning |
| --- | --- | --- |
| `projection` | Dictionary | `FightCamp.projection()` for `choices`, empty when `choices` is empty |
| `deltas` | Dictionary | what the LAST pick in `choices` changed, see below |
| `affordable` | bool | the gym can pay `projection.cost` this week |
| `blocked_reason` | String | why the camp cannot START yet, player-facing, "" when it can |

**`deltas`** is the new thing. When `choices` carries the key
`"_compare_against"` (a second choices dictionary), return
`{"<projection key>": {"from": Variant, "to": Variant, "tone": String}}` for
every projected figure that differs — edges, tightness, fatigue on the night,
injury risk, film depth, cost, Fight IQ. `tone` is `good` / `warn` / `bad` /
`flat` from the player's point of view (a higher injury risk is `bad`, a higher
edge is `good`), so the screen never has to know which direction is which. With
no `_compare_against`, `deltas` is `{}`.

**`progress`** carries the live camp (`get_fight_camp()`) plus a `weeks` array
the screen can render row by row — one entry per completed week with what it
built and what it cost — the current `film` report at its depth
(`FightCamp.film_report`), whether the counter pick is open (film depth 3), and
`weeks_left`.

**`report`** passes `get_fight_camp_report()` through unchanged plus a
`lines` array pairing projected against built, so the grade is legible without
the screen recomputing it.

## Rules that bind

- **Read-only and idempotent.** Two calls in one career week return
  byte-identical data and leave the save unchanged. R33 hit this on the booking
  side: `get_fight_offers()` advances weekly tick markers
  (`GameState.gd:10619`). Your own C19 answer — run the lazy reads against
  `career.duplicate(true)` and restore the original — is the pattern to reuse
  if anything under this call mutates.
- **Invent no numbers.** Every figure comes from `FightCamp.gd`,
  `WeightCut.gd` or the existing camp reads. If a value you want does not
  exist, say so in your report rather than deriving one here — the whole point
  is that the projection shown is the same maths that will be applied.
- **Change no behaviour.** `start_fight_camp`, `set_fight_camp_counter`,
  `end_fight_camp`, `_advance_fight_camps` and `_validate_fight_camp_choices`
  are untouched. `blocked_reason` must agree with
  `_validate_fight_camp_choices()` — reuse it, do not restate it.
- **`GameState.gd` is ~8k lines.** Never read it whole. The anchors below are
  the only slices you need.

## Anchors

`GameState.gd`: `get_fight_camp_slots` `750`, `_fight_camp_opponent` `756`,
`_fight_camp_ruleset` `785`, `get_fight_camp_options` `797`,
`_fight_camp_context` `917`, `get_fight_camp_projection` `947`,
`_validate_fight_camp_choices` `966`, `start_fight_camp` `1003`,
`set_fight_camp_counter` `1058`, `end_fight_camp` `1087`, `get_fight_camp`
`1101`, `get_fight_camp_report` `1118`, `_advance_fight_camps` `1148`,
`_close_fight_camp` `1256`, the weekly-tick warning `10619`.
`FightCamp.gd`: `weeks_available` `120`, `available_counters` `125`,
`injury_chance` `141`, `week_effects` `176`, `projection` `224`, `edge_lines`
`266`, `film_report` `286`, `grade` `358`.
`WeightCut.gd`: `diet_plan` `98`, `status` `134`, `projection` `223`.

## Owned files

- `Godot/scripts/GameState.gd` — one new function plus its private helpers,
  appended near the other read APIs. Change nothing else in the file.
- `Godot/tests/camp_board_api_test.gd` — NEW.

## The test must cover

Determinism across two calls in one week; every `state` value reachable
(including `"unavailable"` with its real reason for a fighter with no bout);
`deltas` empty without `_compare_against` and non-empty with one; a delta's
`tone` is `bad` when injury risk rises and `good` when an edge rises;
`projection` agrees exactly with `get_fight_camp_projection()` for the same
choices; `blocked_reason` agrees with `_validate_fight_camp_choices()`;
`progress.weeks` has one entry per completed week; the live save is unchanged
after any number of calls.

## Parse gate, then the test

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/camp_board_api_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/camp_board_api_test.gd
```

Then `fight_camp_test.gd`, `weight_cut_test.gd`, `fight_camp_panel_test.gd`,
and the full suite before you push.

## Report

Push your own deliverables. Message Claude with the final shape if it differs
from the tables above, and say plainly whether anything under this call mutates
the save and how you handled it.

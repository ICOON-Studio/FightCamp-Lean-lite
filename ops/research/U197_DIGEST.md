# U197 digest — footwork beats reach the room

## Problem
S122 logs movement-only boxing as `type: footwork` (`footwork_no_contact` ON in game switches). `FightBeatAdapter` only collected `action` candidates and `_present` forced `type: action`. `FightWorldLiveScreen._pump_to` then kept only `action`, so footwork never reached `Schedule.add_action` or `FightStagePlayer._is_footwork` / C215 shuffle.

## Fix
1. **Adapter** — collect `footwork` events as beat candidates; copy engine `type` onto the beat; force non-blow fields for footwork (`animation_family: movement`, never landed/significant).
2. **Schedule** — `add_action` accepts `footwork` beats and schedules **thrower only** (no receiver / reaction entry).
3. **Room** — explicit `footwork` branch in `_pump_to` before the `action` gate; `footwork_stats()` for tests.
4. **Stage player** — `present_live` treats `type: footwork` like movement footwork on the thrower only; `_is_footwork` true for `type: footwork`.

## Before / after (seed 94301, out-boxer v pressure puncher, boxing, `footwork_no_contact=true`, 120 s pump)
| Metric | Before | After |
| --- | ---: | ---: |
| Engine log `footwork` events | 5 | 5 |
| Room `footwork_stats.events` | 0 | 5 |
| Scheduled footwork actor entries | 0 | 5 |
| Footwork landed / reacted | — | 0 / 0 |

## Mutant
Action-only filter (`type != "action" → continue`) drops every footwork beat; test asserts that mutant and that the live source routes `beat_type == "footwork"`.

## Gates
- `footwork_beats_reach_room_test.gd`: 29 checks, 0 fail (runner clean).
- `fight_body_layers_live_test.gd`: SUITE 1/0 (layered slide gate unchanged).
- Subset run also hit pre-existing `fight_body_overlap` / `fight_footwork_economy` reds unrelated to this wiring.

## Branch
`cursor/u197-footwork-beats` — push only; do not merge to `master` without `check_workflow.py branch`.

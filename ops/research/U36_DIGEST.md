# U36 DIGEST — FightNightScreen switches engines

## What shipped

`FightNightScreen` now carries **both** engines and picks by ruleset:

- **Real-time** (`FightBeatAdapter`): `boxing`, `mma`, `kickboxing`, `muay_thai`
- **Atomic** (`FightSimulation`): everything else, including judo / taekwondo / freestyle wrestling

Combo interrupt is cut on the real-time path only. `react_to_combo` is untouched for the three atomic sports that still use it.

## The four answers

### 1. Does `_record_live` survive?

**Yes.** Keys it and `FightResultPanel.payload_from_sim` need:

| Key | Real-time `result()` | Adapt? |
| --- | --- | --- |
| `winner_side` | yes | — |
| `method` | yes | — |
| `decision_type` | yes (empty on stoppage) | — |
| `rounds_completed` | yes | — |
| `scorecards` | yes | — |
| `scoring_style` | **no** | omit; payload defaults to `""` |
| `duration_seconds` / `final_health` / `knockdowns` / `signature_battle` | **no** | omit; not read by `_record_live` / payload |
| `technique_usage` | **no** analytics fold | omit at call site — never invent zeros |
| `log` for `_last_replay["log_count"]` | on `fight["log"]`, not the adapter wrapper | `_fight_log()` |
| `PostFightRead` (`status == "complete"`) | RT uses `over`, not `status` | `_post_fight_state_for_read()` shapes the real cards/log/result |

### 2. Between-rounds corner window

Hangs off the **rising edge** of `state_view().resting` (level would re-open every beat of the rest). `round_just_completed` is the clock's round during rest. No combo / hurt path on real-time. Dock is resume-only — FightSimulation corner verbs are not called against an adapter state.

### 3. The ten consumer tests

| Test | Moved? |
| --- | --- |
| `booking_eligibility_visibility_test` | no (setup gate only) |
| `combo_show_test` | **yes** — boxing lab no longer expects combo pause; asserts `uses_realtime` + coached_sides on the screen contract |
| `dev_jump_test` | not in focused subsets; not touched |
| `event_night_*` | green, unchanged |
| `ring_night_command_bar_test` | **yes** — pin moved to `freestyle_wrestling` (atomic, multi-round) |
| `ring_stage_panel_test` | **yes** — same; boxing lab would empty the idle pace ladder |
| `scene_router_test` / `setpiece_*` | green (setup / route only) |

No silent re-pins: every moved assertion names U36 in a comment.

### 4. Is the fight watchable?

Measured on the kickboxing lab (3 rounds, early KO): **26 beats, 1 rest, wall_ms=178** headless. At the 1.4 s presentation clock that is **~36 s** of watch time for this KO. A distance three-rounder at ~70–100 beats is still in the old atomic ~100 s ballpark; an 8-round boxing decision would run longer because the ruleset's own length is now presented honestly.

## Gates

```
check_scripts: total=2 fails=0
fight_night_realtime_test: failures=0
--only fight_night: total=1 fails=0
--only ring: total=6 fails=0
--only event_night: total=2 fails=0
--only setpiece: total=3 fails=0
```

Did not run the full suite (Claude's integration gate).

## Owned files

- `Godot/scripts/FightNightScreen.gd` (edited)
- `Godot/tests/fight_night_realtime_test.gd` (new)
- Pin moves: `ring_night_command_bar_test.gd`, `ring_stage_panel_test.gd`, `combo_show_test.gd`

`RingStagePanel.gd` untouched.

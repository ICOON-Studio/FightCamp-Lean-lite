# FIGHT_HOOKS.md - where the game calls the sound system (S385, wired S390)

The final set is `assets/audio/sounds.json`: 13 events, one kept file each. `SoundBank.files()` serves only rows the operator
heard and kept, so nothing else can play. `tests/sound_bank_test.gd` fails if any script plays an id without a kept row.
`tools/sound_fight_probe.gd` plays a real bout and compares what sounded with what showed.

## Wired

| What | Where | Call |
|---|---|---|
| A punch lands | `HitImpact.hit`, after the `was_cut` return (a cut-off punch shows nothing, so it is silent) | `FightSfx.landed(move, big)` |
| The round's big shot is thrown | `BeatFire._punch`, after `stage.close_up(other)` | `FightSfx.big_shot_ahead(at)` |
| A block | `BeatFire._punch`, when the punch showed (`punch_id >= 0`) and did not land | `FightSfx.blocked(at)` |
| A miss, slip or weave | same place; only a block is a block | `FightSfx.missed(at)` |
| A step in or out | `BeatFire.fire`, after `stage.step` | `FightSfx.step()` |
| The fall hits the canvas | `BeatFire._count`, inside the timer, only when the fall plays | `FightSfx.knockdown(FALL_ON_CANVAS_S)` |
| Opening bell + crowd bed | `FightView.play_round`, or `FightCast._intro_over` for round 1 (the intro hands over at the bell) | `FightSfx.bell(true)` |
| Closing bell | `FightView._bell` | `FightSfx.bell(false)` |
| The crowd stops | `FightView._exit_tree` (the bed runs through the corners and stops with the ring) | `FightSfx.crowd_off()` |
| A button press | `UI.button` | `Sfx.play("ui_click")` |
| A card turns | `FlipCard.flip`: no flip sound was kept yet, so the kept click marks it | `Sfx.play("ui_click")` |
| The poster lands | `PosterReveal.finish`: no poster sound exists, so it uses the kept heavy thud | `Sfx.play("knockdown_fall")` |

`at` is the seconds to the glove's contact: block and miss sounds wait for it, so they land with the picture, not at the throw.

## Not wired: no kept sound yet

Add the hook only once the operator has kept a row for it on the sound board.

| Event | Where it would go |
|---|---|
| `clinch_grab` | `BeatFire.fire`, after `stage.clinch.start(...)` |
| `ref_count_1..10` | `KnockdownCount._number`, after `_show(str(n), UI.GOLD)` |
| `crowd_round_swell` | `FightSfx.bell(false)` |
| `corner_minute_bed` | `CornerMinute.run` on, `CornerMinute.finish` off |
| `gym_pads_pop` | `PadWork._pop_mitt` |
| `ui_card_flip` | replaces `ui_click` in `FlipCard.flip` |

## The import

Every call site needs one of:
```gdscript
const FightSfx := preload("res://scripts/audio/FightSfx.gd")
const Sfx := preload("res://scripts/audio/Sfx.gd")
```

## Levels

Each kept file plays at its event's `volume_db`, plus the bus: SFX -4, Crowd -12, UI -10. Master ends in a -1 dB hard limiter
(SOUND_BENCHMARK R11). The short punches read under their class (R12), because their loudness is measured over a 400 ms window
they do not fill, so `volume_db` lifts them: `class - mmax`, capped so the peak reaches the limiter at no more than +2 dB (the
3 dB `audio_prep.py` allows off a transient). Only `punch_body` meets the cap: +7.5 where its class asks +9.3.

## Priority (R7)

The pool steals the oldest voice of the lowest priority at or under the new sound; a sound that outranks nothing is dropped.
sounds.json `"priority"` 0-3: 0 = footwork, 1 = blocks, misses, roar, clicks, 2 = landed punches, 3 = big shot, knockdown, bells.

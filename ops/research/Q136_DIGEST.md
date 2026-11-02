# Q136 DIGEST — SOUND PASS 3

**Date:** 2026-09-22
**Author:** qwen
**Commit:** e9be1b84

## What landed

1. **Crowd bed wired into both fight screens.** `start_crowd()` / `stop_crowd()`
   are no longer orphaned — both `FightNightScreen` and `FightWorldLiveScreen`
   call `FIGHT_AUDIO.begin_round()` at round start and `FIGHT_AUDIO.end_round()`
   at round end. The crowd bed now actually plays during a fight.

2. **Round bell.** Synthetic 880 Hz bell with harmonics (2nd, 3rd, 5th) and
   1.2 s exponential decay, generated at startup on the SFX bus. `play_bell()`
   fires at round start and round end via `begin_round()` / `end_round()`.

3. **Crowd reacts to engine state.** `_route_beat` now drives `crowd_swell()`
   off beat fields the engine already provides:
   - **Knockdown** → intensity 1.0 (full swell)
   - **Significant strike landed** → intensity 0.5
   - **Grapple grade 3** → intensity 0.6 (unchanged from pass 2)
   - **Grapple grade 2** → intensity 0.3 (unchanged from pass 2)
   - Non-significant landed, misses, low-grade grapples → no swell

4. **Static wrappers for scene-script wiring.** `begin_round()` and
   `end_round()` are static methods that find the autoload via the scene tree,
   following the same pattern as `on_beat()`. Scene scripts cannot use the bare
   autoload identifier (compiled before autoloads are registered).

5. **Between-rounds handling in FightNightScreen.** The crowd stops when
   entering rest between rounds and restarts with the bell when the next round
   begins. A `_crowd_stopped_for_rest` flag ensures `_resume()` only restarts
   the crowd after between-rounds rest, not after combo interrupts.

## What drives the swell and what state it reads

| Event | Swell intensity | State field read |
|-------|----------------|------------------|
| Knockdown (any region) | 1.0 | `beat.knockdown == true` |
| Significant strike landed | 0.5 | `beat.significant == true` |
| Grapple grade 3+ | 0.6 | `beat.grade >= 3` |
| Grapple grade 2 | 0.3 | `beat.grade >= 2` |
| Non-significant landed | 0.0 | — |
| Miss | 0.0 | — |
| Low-grade grapple | 0.0 | — |

All fields are already present on the beat dictionary from `FightBeatAdapter`.
No new state was invented.

## Achieved-beside-wanted timing table

| What | Wanted | Achieved | Source |
|------|--------|----------|--------|
| Bell at round start | On contact / round boundary | Synchronous with `_on_begin()` / `setup()` | Static call, ~0 ms offset |
| Bell at round end | On round end | Synchronous with `_finish()` | Static call, ~0 ms offset |
| Crowd swell on knockdown | On knockdown event | Synchronous with `_route_beat()` | Same call frame as beat |
| Crowd swell on significant | On significant strike | Synchronous with `_route_beat()` | Same call frame as beat |
| Crowd start at round begin | When round starts | Synchronous with `begin_round()` | Static call |
| Crowd stop at round end | When round ends | Synchronous with `end_round()` | Static call |

All audio decisions happen in the same call frame as the beat or round
boundary. The sync budget (-45..+80 ms) is not stressed by these additions
because they are synchronous calls, not scheduled events.

## Mutant table

| # | Mutation | Expected fail | Actual fail | Restored |
|---|----------|---------------|-------------|----------|
| 1 | Knockdown swell → 0.0 | knockdown body/head intensity | 2 fails: `knockdown body swell intensity 0.00 (want 1.00)`, `knockdown head swell intensity 0.00 (want 1.00)` | green |
| 2 | Significant swell → 0.0 | significant strike intensity | 1 fail: `significant head strike swell intensity 0.00 (want 0.50)` | green |
| 3 | Bell amplitude → 0.0 | bell transient check | 1 fail: `bell opens with a transient (peak 0 of 127)` | green |
| 4 | Remove `last_bell_played = true` | play_bell observable | 1 fail: `play_bell sets last_bell_played` | green |

All 4 mutants caught. All restored to green at 121/0.

## Real test numbers

- **Parse gate:** 4 files, 0 fails
- **fight_audio_test.gd:** total=121 fails=0 (up from 103 in pass 2)
  - Bell: 8 new checks (format, rate, stereo, data, transient, tail, player, observable)
  - Crowd swell triggers: 10 new checks (8 intensity cases + start/stop)
- **--only fight_audio:** 1 test, 0 fails
- **--only corner:** 5 tests, 0 fails
- **--only ui:** blocked by stage gate (session-level, not a test failure)

## Figures wanted and not sourced

- **MMA-specific crowd onset/sustain/decay ms** for knockdown, significant
  strike, near-finish: NOT FOUND (J22B). The swell intensities (0.5, 1.0) are
  product dials, not measured values. The decay is the existing 2.5 s from
  pass 2, which is also a product dial.
- **Round bell duration ms:** Used 1.2 s as a reasonable bell decay. No
  MEASURED figure for a boxing/MMA round bell was found. This is a product
  dial.
- **Between-rounds crowd behavior:** The crowd stops completely between rounds
  and restarts with the bell. No research was found on whether real crowds go
  silent between rounds or maintain a murmur. This is a product choice.

## One thing I would do next in pass 3 (if there were more time)

**Drive the swell off the last-round pressure.** J22B named `crowd_near_finish`
as a cue but deliberately gave no millisecond figure. The engine already knows
when a round is in its last 30 seconds (the beat carries `round` and the
adapter knows `round_seconds`). A swell that ramps up in the final seconds of
the final round — driven off `round_now >= total_rounds` and
`time_remaining < 30` — would add the tension that makes a close fight feel
close, without inventing a timer. The state is already there; the cue is not
yet wired.

## What is still wrong

- The crowd bed is a 2-second loop of filtered noise. It reads as "murmur" but
  not as "crowd." A richer generation (layered voices, occasional cheers) would
  need more PCM or a different synthesis approach.
- The bell is a single pitch. Real round bells have inharmonic partials and a
  sharper attack. The current synthesis is "pleasant tone," not "brass bell."
- The swell decays linearly over 2.5 s. Real crowd reactions have a sharper
  onset and a longer, more irregular decay. The current decay is a product dial.
- Between-rounds, the crowd goes completely silent. Real crowds maintain a
  murmur or talk among themselves. Stopping the crowd completely is a product
  choice that may sound abrupt.
- No listening test has been done. All validation is automated (PCM checks,
  intensity checks). The operator has not heard any of this yet.

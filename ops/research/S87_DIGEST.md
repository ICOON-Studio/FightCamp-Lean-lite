# S87 DIGEST - training floor step 4a finished: watch the spar, the coach's voice, the edge in the engine
Claude, 2026-09-26. Roadmap `now` from S86.

## Shipped
- **WATCH THE SPAR (3D).** `GameState.spar_fight_setup(booking, day)` is the ONE builder of a spar's engine run (two
  fighter copies + exact FightRealtime options, seed `hash('spar|a|b|day')`), used by the day tick (`run_spar`) and the
  fight view. FightNightScreen `spar|<athlete_id>`: mode `live` = today's booking (settles on finish via
  `settle_watched_spar`, which consumes the booking so the day tick runs nothing), mode `replay` = the last settled spar
  from a snapshot (`career.spar_replay`, the two men as they walked in; settles nothing). No corner calls, no intro, no
  record; SPARRING plate (`SPARRING · LIGHT · 3 x 3 MIN · THE GYM`), a SPAR OVER card with the ring card's own words,
  BACK TO THE GYM. FightWorldLive takes `engine_options` (laid over its own) and `spar_plate` (hides the corner card and
  broadcast plate - a corner call would change the spar). Ring card: WATCH THE SPAR / WATCH IT AGAIN; today's watched
  result reads "Today:"; the same pair cannot re-book the day they sparred.
- **Found and fixed on the way: the 3D room fights on the ring it DRAWS** (`_arena_half_m` from ArenaRig's contest,
  operator 2026-09-23), the day tick fought on the 3 m default - so a watched spar would NOT have equalled the settled
  one. `FightWorldLiveScreen.engine_half_width_for(discipline)` (static, no room built) now feeds `spar_fight_setup`.
- **THE COACH'S VOICE (G119).** `CoachVoice.gd` (pure): one sentence, one topic, by G119's priority injured >
  overtrained > (S86 rivalry) > fight week > hard spar (worse / better) > breakthrough > regress > improve > flat >
  "Quiet week. Leave him/her."; templates from G119 s2/s5, never a number. Monday report row: `note` = the D31 numbers,
  `coach_line` = his line (HOME shows both; the line quoted, under the numbers).
- **THE EDGE IN THE ENGINE.** Q189 merged. `apply_fight_edge(fighter)` sets `sharp_edge = 0.05` on the FIGHT COPY when
  `get_spar_edge` is live: spars (`spar_fight_setup`), booked and world bouts (FightNightScreen). Never on the save.
- **D32 acted on:** the ring card's pair line (`Cole 63 kg · 4-1 · OVR 58 vs ... · RISK MEDIUM`), booked and picking.
  **D31 carried item:** the planner's INJURY RISK sits on the EXPECTED line; risk, rested-instead and restrictions now
  come straight under the choice, above the body picture.

## Q189 verified, not taken at face value
Its test's "byte-identity" ran the NEW engine twice (determinism, Q188's gap again) and `q189_byte_identity.gd` crashed
at line 78 printing empty hashes. Fixed the tool; master vs Q189 engine, edge absent: **15/15 log+scorecard hashes
identical.** Q189's census: clean-landed share 55.7% -> 60.4% at edge 0.05 (MMA, 40 seeds), cap holds.

## Tests
- NEW `spar_watch_test` 0 failures: WATCHED == SETTLED field by field (landed, better, stopped, rounds, head, taps,
  marks, seed) at technical / light / hard; the replay shows the same spar and settles nothing; watching consumes the
  booking, the day tick runs 1 spar that day not 2, no record/history/title; the 3D room (FightWorldLive) runs the day
  tick's options - its engine log is byte-identical to the day tick's; SPAR plate up; sharp_edge only on the copy and
  only while live; CoachVoice walks all ten topics with no digit in his mouth, her/him; the Monday row carries both.
  **Mutants caught:** settle not consuming the booking (4 rows), arena ignoring `engine_options` (4 rows).
- `training_floor_3d_test`: + WATCH button, pair line with kg/OVR/RISK, WATCH routes `spar|<id>` live.
- `gym_sparring_test`: the rivalry now reads from `coach_line`.
- Subsets: 44 tests (spar, fight_sharp, training_, day_feed, fight_night, event_night, career_loop, smoke, fight_realtime/
  scoring/kb/footwork/pace, coach_, booking_eligibility, home_pin, menu_clarity, drill_mastery, athlete_development,
  development_screen, scene_router, gym_hub, rivalr, body_region, booked_training) = 3 red, all the known rows
  (athlete_development x2, fight_scoring, fight_realtime's six R91/judo rows); after the last edits, 21 tests (spar,
  training_, fight_night, event_night, booked, career_loop, smoke, planner, week_program) = 0 red. Nightly on disk: 2026-09-26 at 9847dd13, SUITE total=416 fails=13 (AgentComms/nightly/latest.txt).

## Collected
U181 (Cursor: skipping toe IK, slip p95 0.205 -> 0.072 m/s, `cardio_floor` bound), Q189 (Qwen), G120 (Grok:
visiting/paid sparring - `G120_VISITING_SPARRING.md`), D32 (Dola: raw transcript; #1 = pair context before booking).

## Assigned
Q190 (Qwen, running): `SparPartnerMarket.gd` - hire a partner who clones the opponent (G120 prices, legal, never
identical). U182 (Cursor): the spar watched in the GYM ring (club spec, gym light), half-width kept in step.
G121 (Grok, sent): real gym floor plans for S88's preset layouts. D33 (Dola): fresh eyes on the S87 renders.

## Not done
The spar plays in the championship venue (U182). S88 = step 4b (tiers 3-4, build-a-wing, room doors, presets from
G121) + paid partners (Q190).

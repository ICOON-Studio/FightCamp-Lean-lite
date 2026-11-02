# S86 DIGEST - gym sparring days (training floor, step 4a)
Claude, 2026-09-26. Roadmap `now` from S85. Commits f312c42a (merge Q188), 2917eed3 (merge U180), 684bb74a (S86 build),
d9e44106 (assignments).

## Shipped
- **`GymSparring.gd` (pure, zero preloads), G117 s7.** `check()` refuses with a reason: not the same rules, medical hold,
  > 1 weight class (same sex; mixed pairs by mass ratio > 1.24), two raw beginners (DECISION: < 3 bouts amateur + pro),
  Hard inside 10 days of a booked bout, > 1 spar a week off camp / 2 in camp, > 1 Hard a week, same pair > 2 a week.
  **Mixed-sex sparring allowed** (operator 2026-09-26, "yes"): sizes not close (mass ratio > 1.05) -> the pair is held
  to Technical/Light. Rounds: floor of G117's band, +1 in camp, Hard capped at fight length + 1.
- **GameState:** `check_spar` / `book_spar` / `cancel_spar` / `get_spar_bookings_today` / `get_last_day_spar_results` /
  `get_spar_edge` / `run_spar`. Booked spars run on **FightRealtime with Q188's `spar` option as the day ends** (before
  training). Never a record, KO or title. `better_side` = landed + 0.2 x head kept (within 1 = even). Per round: G117's
  bruise/cut rates on BodyReadiness regions (-6 / -12 readiness; bruises land arms/torso first, a cut on the head), the
  better man at 40%. Edge 3-7 days (`spar_edge`, +2 morale - the ENGINE does not read it yet: Q189). A spar day is a
  ring day: bond step + club_ring mastery hours. **Rivalry:** 3 spars in 21 days with one man on top twice (majority) or
  2 Hard -> `_stoke_rivalry(..., "sparring", heat 15)` (rivalries.json), a news line, and the Monday note.
- **Floor:** ring card bottom-right (pick two + intensity, BOOK / CALL IT OFF, the refusal's reason, yesterday's result
  with landed, marks, rivalry). The pair stand 2.4 m apart either side of ring centre, squared up, red SPAR tags; the
  coach referees ON the canvas 1 m off the pair's line (`ring_referee`; the apron put him on the speed-bag fighter). **D30 stacking:** `_stack_tags` lifts any tag within 1.7 m of an
  earlier one above it (world heights; pips follow). Renders: `docs/previews/s86/floor_spar_day.png` and `floor_spar_day_speedbag.mp4` (U180's speed-bag clip in motion; `tools/s86_render_floor.gd -- movie`).
- **Profile:** THIS WEEK card draws the drill's five pips + "DRILL II · 20% TO III" for the week's station.
- **D31 acted on:** Monday note = "{first} is sharper than last Monday: POWER +29%  ·  TECHNIQUE +18%." (day card's form).

## Q188 merged, with three integration fixes
Landed = clean/glancing contact only (Qwen counted every thrown action); Hard also stops at head <= 50
(`SPAR_STOP_HEAD_HARD`, G117: no gym war); `KB_HEAD_WEAR_MULTIPLIER` (a BOUT calibration) off in spars - with it KB Light
hit the coach-stop line in 48/50 spars. **Q188's "byte-identity" compared method + winner only**, not the log; Q189
re-proves it by hashing the log. U180 merged: speed bag bound (strike gap p95 0.151 -> 0.0006 m); skipping NOT bound
(slip 0.253 vs 0.08) -> U181. U180's "after" MP4s are copies of the "before" ones (same bytes).

## Tests (subsets; the full suite is the nightly)
- `gym_sparring_test` 0 failures: every gate refuses with its reason and mixed-sex allowed/held; a booked Light spar runs
  on the engine through `advance_day` and writes no record/history/title, consumes the booking, banks club_ring hours and
  moves the bond (30 -> 31); 20 engine spars across intensities; rates over 889 settled spars (4,000 rounds) per
  intensity: worse-man bruise 0.022/0.047/0.121 (G117 0.02/0.05/0.12), better man 0.008/0.023/0.047 (~40%), cut
  0.0018/0.0055/0.017; edge expires; rivalry forms from the trigger only (both patterns, window, even spars = none);
  Monday report names it; profile pips. **Three mutants caught** (raw-beginner gate removed, better-share 1.0, 2-Hard
  trigger off). NOTE: the rate probe drives `GymSparring.roll_marks` with the game's roll layout, not 889 engine bouts.
- `training_floor_3d_test` 0: tier-1 tags never overlap; a probe of three men round one spot stacks; the card books a Light
  spar, both drawn in the ring with SPAR tags, coach `ring_referee`; a refused booking prints its reason.
- Q188 subset (fight_realtime, scoring, kb, footwork, pace, spar): 8 tests, 2 red = fight_scoring + fight_realtime's six
  pre-existing rows. S86 subset (31 tests: gym_sparring, drill_mastery, training_*, day_feed, home_pin, coach_*, smoke,
  career_loop, menu_clarity, scene_router, gym_hub, rivalr*, fight_spar, body_region, athlete_development,
  booked_training, development_screen): 1 red = athlete_development's two pre-existing rows. Last nightly on disk:
  AgentComms/nightly/latest.txt.

## Collected
Q188 (Qwen), U180 (Cursor), G119 (Grok: what a coach says on Monday - one sentence, one topic, priority injury > fight
week > hard spar > breakthrough > regress > improve > flat, never stat deltas; `G119_WHAT_A_COACH_SAYS_ON_MONDAY.md`),
D31 (Dola: Monday note in ATTR +X%; planner warnings beside gains; `D31_PERCENT_OF_A_POINT_REPLY.md`).

## Not done (carried)
- Watch the spar in 3D: not a routing change (the fight view books from offers) - S87's first item.
- The engine reading the edge (Q189 builds `sharp_edge`; S87 sets it from `get_spar_edge`, 0.05 max).
- The coach's own voice (G119) beside the D31 numbers; planner warnings on the gains line (D31); a breakthrough burst.

## Assigned
Q189 (Qwen) sharp_edge in the engine + a log-hash byte-identity proof; U181 (Cursor) skipping clip contact windows ->
bind cardio_floor; G120 (Grok) visiting/paid sparring and gym-to-gym sessions; D32 (Dola) fresh eyes on the spar day.

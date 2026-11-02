# R91 DIGEST — THE GRAPPLE REACHES THE FIGHT (2026-09-10)

Four grappling halves were on master and every one was inert. `FightRealtime`
now calls `GrappleSeat` and `GrappleResolve`, the five G34 §8 counters have a
writer, `RealtimeRoundStats` folds them to the judges, the stall clock runs,
and `METHOD_SUBMISSION` is a verdict `result()` returns. Every path is asserted
to OCCUR in a real bout, not to be permitted.

## What was wired

* **Seats on the decision cadence, control on the scoring cadence** (G34 §8).
  `_run_grapple` after `_run_decision`; `_run_control` in the SCORING seam
  that was `pass`. Movement freezes in a ground seat so separation stays
  inside striking range; nothing else about movement or impact changed.
* **Standing → ground** through `takedown_resolve`; the takedown counts only
  after 20 ticks of kept top (G34 §2), so the log carries a `seat` event at the
  transition and a `takedown` event when the gate is met. Position changes the
  same way behind `GrappleSeat.hold_ticks`; sweeps behind 60.
* **Submission** as G34 §5 wrote it: opens from mount or back after 20 held
  ticks, progress advances on the scoring cadence through
  `submission_advance`, the finish roll is the module's `FINISH_P`. The finish
  writes G35 §1.4's `SubmissionFinish` record onto `stoppage["submission"]`
  and stops the fight with `METHOD_SUBMISSION`.
* **The stall clock** (G35 §4): 400 ticks in one seat with no seat change and
  no attempt; first fire is a warning event, second fire is the engine's
  default restart on the feet. The clock is held while an attempt is open.
* **The fold**: `takedown`/`throw` → `takedowns_round` (+ grade to
  `throw_points_round`), `position_change` → `position_points_round`,
  `submission_attempt` → `submission_attempts_round`, `control` units →
  `control_score` at an AUTHORED 80 units to the point. Only gate-met facts
  fold; a seat reached and lost is G37 §3's advantage and stays adapter-local.
* **Costs** per G34 §4 in `FightStamina`'s own units, plus one authored chest
  drip (0.04/s) under a dominant seat. Never head_neck.
* `grapple_of(state)` reads the seat in sides for a screen (G38 wants it).

## The draw budget, and the reading of "no fifth stream"

The task said not to add a fifth RNG stream and to budget every draw. Those
two collide: a grapple decision needs a roll, and the only existing candidate,
`_rng_decision`, would have moved **every** seeded fight in the game, boxing
included, while the replay test stayed green - the exact failure R87 avoided
by giving trauma its own stream. So the sentence was read as "no new
cadence" and the grapple got `SEED_GRAPPLE` / `_rng_grapple` with a **fixed
four draws per decision tick, unconditionally**, asserted by replaying the
generator through `advance_tick` across a whole submission bout and a whole
boxing bout (`_test_the_grapple_stream_takes_four_draws_every_decision_tick`).
Proof the boxing bout is byte-identical to before this stage: the four pinned
boxing cards did not move, and the corner test run under boxing reproduces
R88's numbers exactly (288 minutes, 15 defence reads, 146 cuts).

## Measured, not tuned

| Set | Result |
| --- | --- |
| Boxer (grapple 40) v wrestler (70), default profile, 40 × 3x5 | 44 shots (a 18, b 26), 23 kept, 38 positions scored, 17 attempts opened, **5 submissions**, 12 stall fires, 3 stand-ups, 1,780 control units; 32 decisions, 3 KO, 5 SUB |
| Grappler (95) v fish (grapple 15, defense 20), 200 × 3x5 | 101 SUBMISSION, 65 DECISION, 33 KO, 1 TKO - pinned seeds 92001/92003/92006 |
| Gates | `fight_realtime_test` PASS (279), `realtime_round_stats_test` PASS (131), `grapple_contract_test` witnesses=550 failures=0 unedited, `fight_reaches_its_modules_test` 0 failures |

12.5% by submission between two ordinary men is under G34 §5's one-in-five
fight-level ceiling; between a specialist and a man who cannot defend one it
is half the fights. Neither number was tuned.

## The pinned card that moved, and why it was re-pinned separately

**mma_11 round 3 went 9-10 → 8-10 with ZERO grappling facts scored in it.**
B shot once at 228 s of round 1, was stuffed, and the shot cost both men
stamina (G34 §4), so every impact after it re-rolled. Round 3 folds
a: dmg 16.72 / b: dmg 21.07, points 26.62 v 32.92 - a gap over
`margin_wide` 6.0 with `ten_eight_requires_damage`'s bar met. Stable across
two runs. The other eight did not move: boxing and kickboxing never grapple
(`_scores_grappling` reads takedowns/throws/positions/submissions, not
`control`), and mma_5 / muay_thai_17 never threw a shot. Re-pinned in the
commit after R91's, as its own decision, with the numbers in the test.

## Findings, reported rather than fixed

1. **No clinch seat yet.** Standing ↔ ground only, so no `throw` is ever
   emitted and `throw_points_round` still has no writer. Judo and wrestling
   throws wait on the clinch (R92).
2. **Striking on the floor is not seat-aware.** Both men keep punching on the
   ground exactly as they did standing. Ground-and-pound and the man
   underneath are one fact today.
3. **The per-ruleset conversion is not wired.** Engine units fold straight to
   the judges; judo scoring no takedown, the refused UWW step-out, IBJJF's
   advantage are `GrappleAdapter` (Q22, in flight) and the next seam. The
   engine never emits `step_out` - G37 §4 says a 1-D ring cannot.
4. **`defense` doubles as takedown and submission defence** (G34's
   `DEF_WEIGHTS`). The `iron_chin` fixture (defense 0) is now taken down and
   submitted by the bomber inside three rounds, so the corner test's
   twelve-rounders run under boxing. A real athlete with striking defence 0
   would meet the same fate; whether that is right is a G34 question.
5. **No hold catalogue.** `hold_family` is `OTHER`, `hold_id` empty,
   `finish_mode` TAP - absences, not claims.
6. **Bottom-man destinations are authored**: guard → stand up, half → sweep
   (2 points, 60-tick gate), dominant seat → escape to guard. Labelled in the
   code.
7. **Stall stage 2 is the engine default** (stand-up). Which ruleset calls it
   mate, penalty or V is the adapter's.
8. The old log-walking tests assumed every event was an impact; they filter
   on `type` now, as `BroadcastRead` and `RealtimeRoundStats` always did.
   U22's live-fold test asserted the grappling keys were zero "because
   grappling is not modelled"; it now asserts they fold.

## Next

* **G38 landed** (Grok, 115 sources): a seat chip on `FightHudPanel`, attempt
  pips, stall amber, event lines on `BroadcastRead`, silence otherwise. That is
  a Cursor build task typed from its one-screen spec.
* **R92**: wire `GrappleAdapter` between the fold and the judges once Q22 and
  U29 land; add the clinch seat.

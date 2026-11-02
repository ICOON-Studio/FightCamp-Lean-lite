# R92 DIGEST — THE ADAPTER BETWEEN THE FOLD AND THE JUDGES, AND THE CLINCH SEAT (2026-09-10)

Three things R91 left open are closed: the grapple event payload the blind pair
disagreed on is settled, `RealtimeRoundStats` folds the grapple log through
`GrappleAdapter` per ruleset, and the clinch seat exists, so a THROW is emitted
and `throw_points_round` has the writer G34 named two stages ago. The gate,
`grapple_adapter_contract_test.gd`, went from 12 red assertions to
`PASS (215 checks)` without one edit.

## 1. The payload, settled

Three shapes, one hole: Q22 read `type` / `amplitude` / `seat` /
`hold_seconds`; U29 fed G34's `kind` / `to_seat` / `from_seat` / `grade` /
`held_ticks`; the engine wrote `kind` / `via` / `seat` / `grade` / `points` /
`held_ticks`. **The engine's record is canonical** because it is the one that
exists in a real bout. `GrappleAdapter._norm` reads it, accepts G34's spellings
(`to_seat`, `held_ticks`, `band`, `danger`, `reversal`), keeps Q22's as
fallbacks, and every award reads the normalised record. The engine now also
writes `from_seat` and `to_seat` on the scored record, because a pass is a pass
only from guard or half.

Two corrections to Q22, each recorded in the module and in its own test:
**ABC awards carry `points: -1`**, not 1 - G37 §1.D publishes no number, and -1
is the module's own not-scored-as-points marker - and a finished ABC attempt is
evidence, not a `finish` kind, because under a 10-point must the finish is the
engine's method and there is no card left to write it on.

One interim derivation, labelled in the code and waiting on G39: with no band
given, an IJF throw of grade 4 reads as **waza-ari** and grade 2 as **yuko**,
never ippon. G39 landed the same session and says exactly that - side → yuko,
mount/back → waza-ari, ippon REFUSE - by landing seat rather than grade; the
seat mapping is R93's to type.

## 2. The fold, per ruleset

`RealtimeRoundStats.fold(log, side, round, ruleset := "")`. The game id maps
to an adapter by data (`judo` → ijf, `freestyle_wrestling` / `greco_roman` →
uww, `bjj` → ibjjf, `mma` → abc); the other seven keep R91's engine units,
labelled (boxing, kickboxing, karate, taekwondo never grapple; muay thai and
sambo do and have no sourced conversion yet). `_close_round` passes the id the
state now carries. Where a number lands: a takedown or throw always counts ONE
in `takedowns_round` for the read; its POINTS go to `throw_points_round`, the
counter wrestling and BJJ profiles weight; position points to
`position_points_round`; ABC `evidence` counts one and never a number; an
`advantage` folds nothing (G37 §3: adapter-local); control converts only for
ABC - G37 says judo, wrestling and BJJ never turn control into points.

**The fold reads how long a seat was KEPT off the log**, not off the engine's
gate: the seat began at `tick - held_ticks` and ended at the next `seat` event
or the round's last event. That is what lets IBJJF pay a takedown only after
three seconds when the engine's own gate is one - measured over R91's forty
default bouts, BJJ paid in 27 rounds and refused in 3.

## 3. The clinch

`standing → clinch/over_under` off the SAME gate roll a shot uses, read in
slices (below `p_shoot` he shoots, in the next `p_clinch` he ties up), so the
four-draw budget R91 asserted is untouched and its test did not change. The
action roll decides the lock through the module's clinch weights: the engager,
or nobody. Control credits the lock only after G34's 10-tick gate. Inside the
clinch the man with the lock (or either man when it is even) throws at
`CLINCH_THROW_P`, any man breaks at `CLINCH_WORK_P`, and G35's stall clock
runs with the second fire as the break. A throw that lands is `throw` behind
the 20-tick kept-top gate, with grade and both seats.

**Measured, and tuned once against a sourced ceiling.** At one rate for throws
and breaks, 52 of 66 clinches ended in a throw and 18 of 40 ordinary bouts by
submission - double G34 §5's one-in-five. The first fix (a throw rate a third
of the break rate) left 37 of 78, because an even clinch could only end by a
throw: nobody could let go. With either man able to break: **80 clinches, 15
throws, 20 takedowns, 6 submissions in 40 bouts, 17 stall fires**. The
grappler-fish sweep was re-run (92000..92059, 33 of 60 SUBMISSION); 92003
stopped finishing and 92002 replaced it, recorded in the test.

## 4. Pinned cards and the tests that moved

* judge_panel_test: **nothing moved, and there is no R92P commit.** The R91
  block forecast one - "pinned MMA cards WILL have moved" - and the re-run says
  otherwise: the nine bouts score exactly as R91P left them, gate green with
  the file UNEDITED, and T4/T8R's two runs of each agree card for card. Three
  reasons line up and none of them is a dead gate. The clinch draws NO new
  randomness (it is a slice of the shot's own gate roll, which is why R91's
  four-draw budget test needed no edit); `CLINCH_ENGAGE_BASE` is 0.0020, about
  1.2 clinches a round at grapple 50, and neither MMA seed took one that re-cut
  a round; and `_realtime_bout` folds with NO ruleset argument, so §2's
  per-ruleset conversion never reaches a judge's card at all - the cards come
  off the engine's own consensus. The forecast was honest and simply did not
  come due. A re-pin is a decision to be made when a gate goes red, never a
  chore to be performed because one was predicted.
* Two striking-era twelve-round tests (the doctor's stoppage, R86's
  championship distance) ran on the default profile and now end in a choke
  before a head wears down; they run under boxing, as R91 moved the corner
  test. A striking rule is tested on a striking bout.
* The R92 judo test folds every round in the log rather than the scored ones,
  because most grappler-fish judo bouts finish inside round one and a stoppage
  scores no partial round.

## 5. Findings, reported rather than fixed

1. **Judo osaekomi never scores from the engine**: the adapter requires
   `back_on_tatami`, a fact the engine cannot emit. Judo scores throws (interim
   band) and submissions only.
2. **UWW never reaches 5** and 4 only by the interim danger proxy (grade 4
   landing in side or mount). G39 confirms amplitude is a REFUSE.
3. **Muay thai folds engine units** although G39 says a dump without a weapon
   is not scored and a hip throw is a foul; an MT adapter is a new task.
4. **`takedowns_round` under a rulebook counts only what that rulebook
   scored**: a shot under judo folds to nothing, count included.
5. **The clinch stall uses G35's 400 ticks**; G39 Q2's default is no tick
   trigger for ABC and muay thai and 45 s for judo. R93 decides.
6. `CLINCH_THROW_P` and `CLINCH_WORK_P` are authored and were tuned once,
   against the one rate the contract publishes. They say so.

## Gate

Parse: `CHECK total=17 fails=0` (every dirty script in the shared tree, not
only R92's). Focused: `grapple_adapter_contract_test` PASS (215);
`grapple_adapter_test` 93/0; `realtime_round_stats_test` 131/0;
`judge_panel_test` PASS **with the pin file unedited**; `fight_realtime_test`
PASS.

Full suite: **`SUITE total=218 fails=2`** - `ring_stage_panel_test.gd` and
`smoke_test.gd`. **Neither is R92's**, and neither is a script error; both are
the same one-line assertion, `stamp_kinds == 5`, now reading 7.
`RingStagePanel.gd:1283` defines `stamp_kinds` as `UIKit.RING_STAMPS.size()`
and nothing else, and C72's UNCOMMITTED working-tree edit to `UIKit.gd` adds
exactly two keys to that dictionary (`SUB`, `SUBMISSION`). R92 touches no UI
file. C72 was still in flight when this ran; the two tests it must also move
are `ring_stage_panel_test.gd:65` and `smoke_test.gd`, and neither is named in
C72's owned-files list - flagged to Codex rather than fixed here, because they
are not R92's files.

## Next

R93: type G39's per-seat judo bands and the clinch conversions into the
adapter; decide the clinch stall per G39 Q2; U31/Q23's seat chip and fold
should be on master by then and want `over_under` shown as CLINCH.

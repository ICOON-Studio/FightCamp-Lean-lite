# RESULTDEFECTS1 - result (S442)

Brief: `ops/research/TASK_RESULTDEFECTS1.md`. Defects as listed in `ops/research/RESULT_ROUND3_S442.md` ("Defects found in
the game while dumping"). Bout: `tools/result_dump.gd` seed 44 (Lucy v Priya, loss 28-29 28-29 29-28). Nothing committed.

New test: `tests/result_defects_test.gd` - plays that exact bout through result_dump's own `_setup(44)` / `_fight` and checks
each defect against the bout's records, plus hand-made unit cases. New probe (no game code in it, arms set from outside on the
game's own fight-night steps): `tools/resdef_probe.gd` (`mode=place` for 5, `mode=marks` for 3, 4 and fix 1's side effects).
Probe population: Lucy (Out-boxer) v the division's legal opponents in turn (`opp_index = day % 6`), the result-dump plan and
corner policy, offer days 46+. Lucy wins about 20 % of these bouts, so the population is loss-heavy.

| # | Defect | Confirmed | Status |
|---|--------|-----------|--------|
| 6 | habit line "made X pay" on exchanges won | yes | FIXED (rule side) + optional UI colour line |
| 7 | shouts: round lines 2 of 6, corner tile 2 of 2 | yes | FIXED |
| 2 | FightWhy suggests a move the Playbook refuses at that place | yes | FIXED |
| 1 | two energies at the last bell | yes | FIXED at the source (every screen reads it); tiredness toll left on the old number, option measured |
| 4 | three head readings | yes | tile FIXED to say what the stand-down says; the two scales NOT unified (balance) - options measured; needs a UI line |
| 5 | two position systems | yes, and far wider than round starts | NOT FIXED (balance) - options measured |
| 3 | body map from punches the records did not count | yes | NOT FIXED (damage calibration) - options measured; needs a UI line |

## 6. The habit line on exchanges won - FIXED
- Confirmed: `scripts/rules/HabitFix.gd:77-81` (before) - `line(name, names, held)` never knew who won the exchange; called
  from `scripts/state/LiveRound.gd:347`. In the bout R1-1 and R1-2 (both won by Lucy) read "Priya made Lucy pay for a habit:
  slow starter."
- Red: `result_defects_test` "6. no 'made ... pay for a habit' on an exchange won (2 wrong)".
- Fix: `HabitFix.line(name, names, held, won := false)`: on a won exchange, "A habit cost Lucy an edge (slow starter), but
  Lucy still took the exchange." `LiveRound.gd:347` passes `bool(s["won"])`. Lost and held lines unchanged. FightWhy already
  counted a habit only when the exchange was lost (`FightWhy.gd:60`), so nothing else changes.
- UI line (optional, for the overlay agent): `scripts/ui/modals/FightNight.gd:112-113` paints every `habit_line` in
  `UI.AMBER`; on a won exchange (`last["won"]`) a neutral colour would match the new words.

## 7. Two counts of the corner's shouts - FIXED
- Confirmed: round lines = `LiveRound.close` "worked" of "calls" (`LiveRound.gd:400-409`: every shout taken in, worked = won
  with fit best/ok). The tile = `Aftermath.corner` (`Aftermath.gd:171-182` before) "right of right + wrong" from
  `CornerTrust.tally` (`CornerTrust.gd:23-32`), which counts only wrong-and-lost and right-and-won: the 4 shouts that were
  neither dropped out of the denominator. Bout: 1 of 2, 1 of 2, 0 of 2 = 2 of 6; tile "2 of 2".
- Red: `result_defects_test` "7. corner tile says '2 of 2', the round lines '2 of 6'".
- Fix: `CornerTrust.tally` also counts `calls_said` (every shout taken in); `CornerTrust.settle` returns `worked`, `said`,
  `wrong_all` (uncapped) beside the morale counts (capped at 3 as before, morale unchanged); `Aftermath.corner` shows
  "worked of said" and its line "2 of 6 calls worked, 0 went wrong." plus, when shouts neither worked nor went wrong, "4
  neither worked nor went wrong (a right call lost, or a wrong one won)." Old facts without `said` still read as before
  (fight_stats_test's "1 of 3").

## 2. FightWhy suggests a move the Playbook refuses - FIXED
- Confirmed: `scripts/rules/FightWhy.gd:159` (before) `best_answer(p[1])` = `PlanFight.ANSWERS[sit].best[0]` with no place.
  Line C is One-two-hook (`1-2-3`, from long); the counter best list opens with `feint` (from outside); `PlanLines.set_line`
  (`PlanLines.gd:61-63`) refuses a move from another place. Bout: "Against a counter-puncher, replace One-two-hook. Try Feint
  and draw."
- Red: `result_defects_test` "2. 'Feint and draw' is offered at long where 'One-two-hook' sits".
- Fix: `FightWhy.best_answer(sit, place := "")` returns the first best answer (then the first that works) thrown FROM that
  place; the replace line passes the replaced move's own place (`StrikeMap.move(arrow).from`). Bout now: "Try Double jab."
  (the Playbook's own top option there). Lines with no replaced line (no plan written; a good plan lost) keep the old
  any-place answer: a new line can be written at the move's own place.

## 1. Two energies at the last bell - FIXED
- Confirmed: `LiveRound.close` (`LiveRound.gd:393` before) set the round's `energy.a_end` to the round's bell tank less the
  calls only; the sim fights on `RingDuel.her_energy` / `opp_energy` (`RingDuel.gd:304-313`), which also take off the bout's
  body shots, and every exchange record's `after` holds that. Seed 44: rounds 73.6/70.0, 49.7/49.7, 39.2/33.9 on the stat row
  against 68.3/65.3, 39.0/40.2, 23.1/21.4 fought on.
- Red: `result_defects_test` "1. the stat row's tank is the energy the sim fought on, every round".
- Fix at the one source: `LiveRound.close` now writes `a_end` / `b_end` = `RingDuel.state(lv, exchanges)` (the last
  exchange's `after`). Every reader of `rounds[].energy.a_end` shows the sim's number with no UI edit: FightStats' tank row,
  FightNight's corner tank and energy line (`FightNight.gd:180-201`), FightCast's corner card and evidence
  (`FightCast.gd:67, 88, 118`), PlanTest's lost-round tank. The old figure is kept as `a_end_calls` / `b_end_calls`.
- Kept on purpose: `AfterFight.book` (`AfterFight.gd:33-38`) still feeds `Aftermath.toll` the calls-only tank it was tuned
  on (the tiredness tile, rest days). Option, measured (tools/resdef_probe.gd marks, 200 bouts, walking in at 20): on the
  calls-only tank the toll averages 75.3, 3.38 rest days, "Spent" (80+) in 25 of 200; on the true tank 84.0, 4.13 rest
  days, "Spent" in 183 of 200. That is a big change to recovery and training, so it was not made. If wanted, re-tune
  `Aftermath.TOLL_PER_TANK` together with the move (0.5 now; about 0.39 would keep today's mean toll on the true tank - worked out from the two means, not measured).
- Side effect measured: the replayed beats (BoutMarks, FightView on a closed round) read the round's bell tank for how tired
  the boxers look, so the body map moves a little: our mean places at the last bell, old tank v new (200 bouts): head
  63.4 v 63.6, left eye 89.3 v 89.5, right eye 73.5 v 74.3, nose 73.1 v 72.7, left ribs 81.0 v 81.1, liver 65.6 v 65.2.
  rib_damage_test stays green: S318 loser hurt 42.0 % over the eight windows (S439 read 43.4 %; the bar is 40-90), body plan
  rib at or under 35 at 10.1 % (bar: at most 20). No result changes
  (the 3D never decides; seed 44 plays the same cards).

## 4. Three head readings - tile FIXED, scales NOT unified
- Confirmed: `StandDown.make` reads `m.damage.a` (`Injuries.gd:178-182`, `StandDown.gd:7,14`: head = 100 - 2.2 x damage);
  the injury roll reads the same head (`Injuries.gd:187`). The body map's head comes from the 3D beats (`BodyMap.HEAD_HIT`
  0.59 a punch). The damage tile (`Aftermath.damage`) read only the body map, so: StandDown "head took 46", head place 0,
  critical, 21 days without sparring; map head 63, fine; tile "Nothing lasting".
- Red: `result_defects_test` "4. the damage tile says what the stand-down says" (shown red by cutting the new wiring:
  tile 'Nothing lasting' / 'Took 70 punches, 18 to the body.').
- Fix (display, no number moves): `AfterFight.stand_down_facts(f)` hands the tile the stand-down's head, band, days and
  words; `Aftermath.damage` takes the head from it, with the stand-down's own band (`Aftermath._band`, so 55 reads fine on
  both). Seed 44 now: "Head badly hurt" / "No sparring for 21 days." with the hover "No sparring until Sun 29 Mar: the head
  took 46 damage."
- UI line needed (FightNight is the overlay agent's): `scripts/ui/modals/FightNight.gd:307`
  `ResultMarks.figure(m.get("body_map", {}), "a", ...)` draws the 3D map's head (63, fine) beside the tile's "Head badly
  hurt". Give the figure the stand-down head (`AfterFight.stand_down_facts(f)["head"]`, or read the tile's `lines`) so the
  picture and the tile agree.
- Not made: one scale for the head. Measured (marks, 200 bouts, none stopped): the stand-down reads critical (21 days) in
  148, hurt (10 days) in 25, fine (5 days) in 27; the map's head reads fine in 191, hurt in 9. Head damage p10 20, p25 28,
  median 44, p75 66, p90 74; a win carries 21.1 (51 bouts), a loss 54.8 (149). With 2.2 a point, any bout over 45 damage is
  head place 0. The damage tile now leads with the head in 147 of 200 (it said "Nothing lasting" in 112 before).
  Options: (a) keep the stand-down as the head (done for the tile): truthful, but about three bouts in four now read "Head
  badly hurt, no sparring for 21 days"; (b) the stand-down and the injury roll read the body map's head: 5 days in 191 of
  200, 10 days in 9, never 21 (and the injury roll's head almost never low); (c) rescale `StandDown.HEAD_PER_DAMAGE` /
  `Injuries.DAMAGE_TO_WORST` (both 2.2, set for "a bout between equals carries ~22 damage", which a win matches here and a
  loss more than doubles). Stand-down bands at other scales (fine / hurt / critical of 200): 1.6: 52/30/118; 1.2:
  72/52/76; 1.0: 106/31/63; 0.8: 124/68/8; 0.6: 189/11/0. (b) and (c) change sparring nights and the injury roll (the
  probe saw 26 of 200 bouts end "Injured"), so they are balance calls. The population is loss-heavy (Lucy wins 20 %).

## 5. Two position systems - NOT FIXED
- Confirmed: the plan card `rec["at"]` comes from `lv["at"]`, reset to "" at each round's open (`LiveRound.open` builds a new
  live dict) and then set from the situation's card (`LiveRound.gd:256-257`, `PlanFight.GAME_CARD`: counter -> long); the
  ring ladder `rec["place"]` carries the last bell's place into the next round (`RingDuel.open`, `LiveRound.gd:100`
  `last_place`) and then moves by the duel's step inside the exchange (`RingDuel.step`). Seed 44: R2-1 and R3-1 at long on
  the card, Inside on the ladder.
- It is not only round starts. Measured (place, 300 bouts, card long/outside = ladder long, mid = pocket, inside/clinch =
  inside, ropes and corner left out): the first exchange of rounds 2 and 3 disagrees in 392 of 558, and all exchanges in
  2,856 of 4,038 (71 %).
- Options, same bouts, same dice, only the arm changes (300 bouts each):

  | arm | wins | rounds won | exchanges won | first ex. of R2/R3 off | all off |
  |---|---|---|---|---|---|
  | today | 61 (20.3 %) | 242 / 884 | 2,127 / 5,304 | 392 / 558 | 2,856 / 4,038 |
  | the ladder opens every round at long | 61 (20.3 %) | 238 | 2,129 | 333 / 558 | 2,782 / 4,040 |
  | the card opens each round on the ladder's place | 64 (21.3 %) | 241 | 2,119 | 390 / 558 | 2,859 / 4,290 |
  | the card follows the ladder before every exchange | 72 (24.0 %) | 249 | 2,129 | 394 / 564 | 3,158 / 5,040 |

  None removes the disagreement: the ladder moves inside the exchange (`RingDuel.step`), after the card has picked the
  line, so the place the exchange ends at is not the place the line was chosen at. The arm that touches every exchange moves
  wins by +3.7 points (about 1.1 standard errors on 300 bouts each). A real merge (one place: the ladder chooses, the card follows the rung the duel
  ends on, or the card's line asks the ladder for its place as a call does in `RingDuel.CALL_PLACE`) changes which line
  fires and the duel edge, so it is a balance call.
- What can be done without a balance change: say which is which on screen. The plan card names where the LINE fired ("the
  line at long range fired"); the ring line (`RingDuel.round_lines`) names where the exchange was FOUGHT. No change made.

## 3. The body map's punches against the records - NOT FIXED
- Confirmed: `ExchangeBeats.build` (`scripts/fight3d/ExchangeBeats.gd:31-110`) builds each exchange's beats from the
  exchange's margin BAND (`RoundScript.build` with `BAND_MINE`), then reshapes them (habits, bursts, inside spells, clinches,
  counter cuts, the read's counter); only the body count is matched to the record (`_body`), never the landed count.
  `BoutMarks.build` (`BoutMarks.gd:23-47`) and the ring (`FightView._queue`) put those beats on the body map. Seed 44: beats
  62 v 68, records 58 v 70 (R1-1 4-3 v 4-2, R1-2 5-2 v 3-2).
- Measured (marks, 200 bouts; the replay equals the game's own `m.body_map` in 200 of 200): per bout the totals agree on
  average (records 57.8 v 69.2, beats 57.7 v 69.0), but 1,602 of 3,576 exchanges (45 %) are off - 802 with more punches in
  the beats, 725 with fewer. Of those, 343 had a clinch hit and 400 a read; the rest are the band-based script itself.
- Option measured: the beats cut or padded to the record per exchange and side (the last extra landed punches miss; a short
  side lands its last punch again). Our mean places at the last bell, today v matched: head 63.6 v 64.7, left eye 89.5 v
  89.5, right eye 74.3 v 75.0, nose 72.7 v 73.6, left ribs 81.1 v 79.3, liver 65.2 v 64.7; map head bands fine/hurt 191/9 v
  187/13. Small on average, but it redistributes damage between exchanges and rounds. Per-punch damage is unchanged, but the S439 rib and face bands were
  tuned on today's beats (tests/rib_damage_test.gd, eight windows), so matching the counts is a re-tune: re-run the S439
  windows after it.
- UI line needed: the corner card's punch tally reads the beats, not the records -
  `scripts/fight3d/FightCast.gd:87` `"tally": BodyMap.tally(view._round_beats)`. For one count on screen, read landed and
  body from the round's records (`FightStats.of(done)["rounds"][-1]`); the per-kind split (jab / hook / ...) exists only on
  the beats.

## Tests run
Each touched script was parse-checked first (`--check-only`), and every test went through `godot_slot.py`, headless with Dummy audio.
- `tests/result_defects_test.gd` (new): red on the tree as it was, with 4 FAILs (6, 7, 2, 1). 4 was shown red by cutting the
  new wiring. Now `RESULT_DEFECTS failures=0` / `PASS result_defects_test`, and seed 44 plays the same bout (loss, 28-29
  28-29 29-28).
- `habit_fix_test` HABIT_FIX failures=0; `corner_trust_test` CORNER_TRUST failures=0; `fight_stats_test` FIGHT_STATS
  failures=0; `fight_why_test` FIGHT_WHY failures=0 (good plan graded good 494 of 540, the same as S439); `fight_why_counts_test`
  failures=0; `stand_down_test` checks=8 failures=0; `stand_down_wire_test` checks=9 failures=0; `plan_pressure_test`
  checks=8 failures=0; `plan_bots_test` checks=26 failures=0; `habit_beats_test` failures=0; `rib_damage_test`
  RIB_DAMAGE failures=0 (numbers in fix 1).
- `bout_marks_test`: went red after fix 4 ("the tile counts the sore places the map has (6 of 12)"), because the tile now
  takes the head from the stand-down. The expectation was changed for that one place only, and only for this defect: the
  head is counted with the stand-down's band when there is a stand-down; every other place still comes from the map, and
  "never 'Nothing lasting' with a sore place" is unchanged. Now BOUT_MARKS failures=0.
- End gates: `golden_path_test` GOLDEN_PATH failures=0; `no_pronoun_test` NO_PRONOUN failures=0; `file_limits_test`
  FILE_LIMITS failures=0. LiveRound.gd is 462 lines.

## What the player sees change
- Result page and corner minute: the tank at every bell is lower (the body shots now count): seed 44's last bell 39 v 34
  -> 23 v 21. The corner's tired words and evidence lines read the same lower number.
- Habit captions on exchanges won: "A habit cost Lucy an edge (slow starter), but Lucy still took the exchange."
- Corner tile: "2 of 6" (was "2 of 2"), with the shouts that decided nothing named in the hover.
- The Why's replace line names a move from the line's own place ("Try Double jab", was "Try Feint and draw").
- Damage tile: the head as the stand-down reads it. In the probe population the tile now leads with the head in 147 of 200
  bouts ("Head badly hurt" plus "No sparring for 21 days." in most); before, it said "Nothing lasting" in 112 of 200.
- Nothing changes who wins, the cards, damage, tiredness, sparring days or injuries: seed 44 plays the same bout.

## Also found (not in the seven, not touched)
- `Injuries.after_bout` runs before `AfterFight.book` (`BoutNight.gd:460-461`), so for a bout the ring did not show to the
  last bell (Skip, words, headless) the injury roll reads only the head: the body map is built after it.
- `scripts/state/LiveRoundAfter.gd` is not used anywhere (its her_energy keeps an older body cost).

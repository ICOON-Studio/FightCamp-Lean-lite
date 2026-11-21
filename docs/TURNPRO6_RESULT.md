# TURNPRO6 RESULT - the pro debut's opponent gap: the cause, a curve we can trust, a read that tells the truth, the gaps

S533, Fable side console. Probe: `tools/turn_gap_probe.gd` (rebuilt). Test: `tests/debut_read_test.gd`. Supersedes `docs/TURNGAP1_RESULT.md`.

## 1. The cause, in one sentence
TURNGAP1's "20 boxers x 10 seeds" was ONE boxer on THREE nights, so its cliff and its flat were one Saturday's bout
flipping from a 2-2 draw to a win; and the "offer's read" it printed was never on the offer screen and was made on the
wrong inputs. The game's own read had a second, real fault, fixed here.

| What TURNGAP1 said | What it was | Proof |
|---|---|---|
| 20 boxers | 1 boxer. `Career.quick_start` signs the same walk-in whatever the seed (the seed only moves injuries) | boxers 0 and 1: both day 174, 7-2, strength 65.9465, the same result on every row |
| 10 seeds a gap | 3 fight nights. The "seed" moved the signing day by 0..9 days; the debut is the Saturday N weeks out, so the days land on 3 Saturdays (1 / 7 / 2 seeds). A bout's dice are the fight day's (`LiveRound._rng`: day x 31 + round + exchange) | days 201, 208, 215 at every gap |
| a cliff from -2 to -1 | day 208 (7 of 10 "seeds"): a 2-2 card (a draw, counted as not won) at gap -2 becomes a win at gap 0 | gap -2: day 208 = 5 draws + 2 wins; gap 0: 7 wins |
| flat from 0 to +2 | the same three nights: loss, win, win = 90 %, until the first night flips | gap 0 and +2: day 201 loss, days 208 and 215 wins |
| p10..p90 the same at every gap | the same boxer, the same nights | above |
| the offer reads 50.5 % | not what a player saw (the offer showed no chance, only "a debutant 1.0 under"). The probe built it itself: a boxer with another name (so another shape), no camp, the middle of a hidden rating range, the boxer 4 weeks before the bout | `_bout_read_at_signing` in the old probe |

## 2. The route the game runs for a debut (traced, not guessed)
- The call: `Roster.check_pro` -> `ProOfferWire.make` -> `ProCall.who_calls` / `ProCall.terms` (each house's `opp_gap`, weeks, purse).
- Signing: `Roster.turn_pro` -> `ProOfferWire.signed` (the deal) -> the opponent: rating = the boxer's strength with no camp
  (`BoutRules.fight_power(stats, {}, 0, "", true)`) less the deal's gap, fixed at signing; style Boxer-puncher, "Heavy right
  hand", "Fades after round 3", 0-0, 4 rounds on the Saturday `debut_weeks` out. Since S533 that dict is `DebutOpp.make`.
- `Matchmaking.gd` is NOT on this route (it books the amateur offers and the pro ladder, never the debut).
- The bout: `Bouts.fight_step` -> `BoutNight.fight_step` "sim" -> `_open` / `LiveRound.open` + `LiveRound.exchange` (six exchanges
  a round; who is better is `RingDuel.step` on the boxer's attributes against `AttrGen.attrs_of(opponent)`; each exchange is
  `Exchanges.settle`) -> `BoutNight._counts` (knockdowns, stoppages) -> `BoutNight.outcome_of` (`BoutRules.cards_of` +
  `verdict`; the judges panel is held off, `JudgeNight.DECIDES` false). `scripts/state/Sim.gd` only steps the days.
- The read: `scripts/rules/BoutRead.gd` (`round_edges` walks the bout in expectation, `chance` turns the rounds into a
  chance). The bout page calls `BoutRead.band`; the offer screen called nothing.

## 3. The control arm (cannot share the bug)
One boxer on the morning of fight night (signed through `Roster.turn_pro`, played by the game's own days: camp started
when due, weighed in). Only the opponent's rating moves. Every gap is fought on the same independent nights: PlanTest's
own scratch career, bout k on day 50000 + k x 7 (`BoutNight.play_out`, nothing booked). The scratch bout on the real
day's dice gave the booked bout's result in 20 of 20 checks. On Lucy alone, 40 nights: the win count rises 11, 14, 21,
23, 23, 27, 27, 30, 31, 34, 34, 36, 39 of 40 from gap -8 to +8. No cliff, no flat. The bout rules answer to rating.

## 4. The new curve
Population: the six people the game can sign, two sets of training picks (A: Jab and move / Pad rounds / Hill sprints;
B: Body work / Defence drills / Film study), each played from signing to the first pro offer by a bot that takes every
legal bout. Tess and Josh arrive the same on both sets (counted once): 10 different boxers.

| Boxer | Style, stance, class | Picks | At the offer | Strength (no camp) |
|---|---|---|---|---|
| Lucy Jackson | Out-boxer, orthodox, wlw | Jab and move / Pad rounds / Hill sprints | day 174, 7-2 | 65.9 |
| Kira Mensah | Out-boxer, orthodox, wfw | Jab and move / Pad rounds / Hill sprints | day 265, 7-1 | 67.1 |
| Samira Khan | Slugger, orthodox, www | Jab and move / Pad rounds / Hill sprints | day 398, 7-8 | 69.9 |
| Tess Reilly | Pressure fighter, southpaw, wmw | Jab and move / Pad rounds / Hill sprints | day 41, 7-4 | 59.4 |
| Danny Osei | Boxer-puncher, orthodox, mlw | Jab and move / Pad rounds / Hill sprints | day 167, 7-1 | 63.7 |
| Josh Harper | Pressure fighter, southpaw, mww | Jab and move / Pad rounds / Hill sprints | day 111, 7-2 | 60.4 |
| Lucy Jackson | Out-boxer, orthodox, wlw | Body work / Defence drills / Film study | day 153, 7-1 | 64.7 |
| Kira Mensah | Out-boxer, orthodox, wfw | Body work / Defence drills / Film study | day 251, 7-1 | 67.0 |
| Samira Khan | Slugger, orthodox, www | Body work / Defence drills / Film study | day 328, 7-6 | 67.4 |
| Danny Osei | Boxer-puncher, orthodox, mlw | Body work / Defence drills / Film study | day 202, 7-2 | 65.0 |

Each boxer x each house (its own weeks to the debut) x each gap x 300 played bouts (200 at gaps 3, 5, 6, 7, 8):
66,000 bouts. Win / draw / loss are shares of bouts; "by boxer" is the lowest and highest boxer's win share.

**Bow Lane (ticket house, debut 4 weeks out)**

| Gap | Win | Draw | Loss | Stopped: won / lost | Win by boxer | Read on fight night | Read on the offer | Bouts a boxer |
|---|---|---|---|---|---|---|---|---|
| -4 | 25.7 | 18.9 | 55.4 | 4.5 / 22.1 | 12.3 .. 48.0 | 26.7 | 25.1 | 300 |
| -2 | 34.5 | 19.8 | 45.7 | 5.9 / 15.6 | 18.7 .. 58.0 | 35.5 | 33.6 | 300 |
| -1 | 38.8 | 20.2 | 41.0 | 7.0 / 13.4 | 22.0 .. 64.0 | 40.3 | 38.3 | 300 |
| 0 | 44.0 | 19.6 | 36.5 | 8.4 / 11.2 | 25.3 .. 68.3 | 45.2 | 43.1 | 300 |
| +1 | 48.7 | 20.1 | 31.2 | 10.1 / 8.8 | 30.7 .. 73.0 | 50.0 | 47.9 | 300 |
| +2 | 53.6 | 20.0 | 26.4 | 12.0 / 6.8 | 34.7 .. 77.7 | 54.8 | 52.7 | 300 |
| +3 | 60.1 | 16.8 | 23.1 | 14.5 / 6.2 | 44.5 .. 81.5 | 59.7 | 57.6 | 200 |
| +4 | 63.5 | 18.1 | 18.5 | 16.8 / 4.2 | 47.3 .. 84.0 | 64.3 | 62.3 | 300 |
| +5 | 69.8 | 13.8 | 16.3 | 20.6 / 4.0 | 56.0 .. 88.5 | 68.9 | 66.8 | 200 |
| +6 | 73.7 | 13.4 | 13.0 | 24.8 / 2.8 | 57.5 .. 91.0 | 73.1 | 71.0 | 200 |
| +7 | 78.2 | 12.4 | 9.4 | 29.1 / 2.1 | 62.0 .. 92.5 | 77.0 | 75.1 | 200 |
| +8 | 81.7 | 11.6 | 6.8 | 33.5 / 1.5 | 67.5 .. 94.0 | 80.6 | 78.7 | 200 |

**Harrow & Finch (guarantee house, debut 6 weeks out)**

| Gap | Win | Draw | Loss | Stopped: won / lost | Win by boxer | Read on fight night | Read on the offer | Bouts a boxer |
|---|---|---|---|---|---|---|---|---|
| -4 | 27.4 | 18.9 | 53.7 | 4.7 / 21.1 | 12.3 .. 48.3 | 27.5 | 25.1 | 300 |
| -2 | 36.3 | 20.0 | 43.8 | 6.3 / 15.0 | 18.7 .. 58.7 | 36.4 | 33.6 | 300 |
| -1 | 40.7 | 20.3 | 39.0 | 7.4 / 12.5 | 22.0 .. 66.0 | 41.2 | 38.3 | 300 |
| 0 | 45.9 | 19.7 | 34.4 | 9.2 / 10.2 | 26.3 .. 69.0 | 46.1 | 43.1 | 300 |
| +1 | 50.4 | 20.2 | 29.4 | 10.5 / 7.9 | 31.0 .. 74.7 | 50.9 | 47.9 | 300 |
| +2 | 56.0 | 19.4 | 24.6 | 12.9 / 6.2 | 35.3 .. 79.7 | 55.8 | 52.7 | 300 |
| +3 | 61.8 | 16.6 | 21.6 | 15.3 / 5.5 | 44.5 .. 82.0 | 60.6 | 57.6 | 200 |
| +4 | 66.1 | 16.9 | 17.0 | 18.4 / 3.8 | 48.0 .. 84.7 | 65.2 | 62.3 | 300 |
| +5 | 71.1 | 14.3 | 14.6 | 21.8 / 3.4 | 58.0 .. 89.0 | 69.7 | 66.8 | 200 |
| +6 | 74.9 | 13.6 | 11.5 | 26.4 / 2.6 | 61.0 .. 92.0 | 73.9 | 71.0 | 200 |
| +7 | 79.6 | 12.4 | 8.0 | 30.8 / 1.9 | 65.0 .. 93.0 | 77.8 | 75.1 | 200 |
| +8 | 83.1 | 10.6 | 6.3 | 36.2 / 1.3 | 71.0 .. 94.0 | 81.2 | 78.7 | 200 |

What it says:
- Smooth. About 4.7 points of win share for each rating point, from -4 to +8.
- The old gaps were not safe: +1.0 won 48.7 % and +1.5 about 53 % (TURNGAP1 had said 79 %).
- Two more weeks of camp are worth about 2 points (Harrow & Finch against Bow Lane at the same gap).
- A draw is 1 bout in 5 near level. Two rounds each is always a draw on today's cards (two of the three cards are the
  round count). That is the held JUDGES1 work, not changed here.
- THE GAP IS NOT THE WHOLE STORY. At the same gap the boxers spread about 40 points (gap 0: 25 % to 68 %). The gap is
  taken from the mean of six stats; the bout is fought on the boxer's shape and tank against one fixed debutant (a
  boxer-puncher with a strong right hand). So one number per house cannot give every boxer the same debut. The offer now
  shows each boxer's own chance (section 5), which is the honest answer to that.

## 5. The read against real bouts
The game's read was wrong for pro bouts, in the rule module (not the probe). On main, booked debut at gap 0, Bow Lane,
300 played bouts:

| Boxer | Bouts won | BoutRead on main | Off by |
|---|---|---|---|
| Lucy Jackson | 68.3 | 70.8 | 2.5 |
| Kira Mensah | 45.0 | 46.7 | 1.7 |
| Samira Khan | 48.3 | 51.7 | 3.3 |
| Tess Reilly | 28.3 | 52.7 | 24.4 |

Three things `BoutRead` left out that the bout has. Tess shows all of them: the corner calls "Go to the body" every
round, the tank is empty in round 3 and round 4 is lost 4 times in 5.
1. ROUNDS. It walked 3 rounds (the amateur card: 2 rounds of 3, no draw) for a 4-round debut. Now `round_edges` walks the
   booked bout's rounds, and a card that is not 3 rounds goes through the new `CardOdds` (a level card is a draw).
2. THE CALL'S COST. `LiveRound` charges the corner call every exchange ("Go to the body" 1.5 = 9 a round; "Jab and move"
   gives 3 back). The read's tank never did. Now `BoutRead._energy` does.
3. SECOND WIND. The perk's energy back at round 3 was in `BoutNight._energy`, not in the read. Now in both.
And one calibration: the read walks no knockdowns. On real bouts a share of the level cards never reaches the judges
(a stoppage), and that share grows with the boxer's edge. `CardOdds.result` moves that share of the draws to the win:
0.12 + 0.33 x the card's win chance (least squares on all 240 boxer x house x gap cells: rms 3.0 points, worst 8.0).
So the read is BOTH: the same rule as the bout for the rounds and the tanks, and calibrated against played bouts for
the stoppages (walking knockdowns in expectation would be a new model; a fitted share with a test is what the module
already does for the plan's carry).

Gap 0, Bow Lane, after the fix (round edges in power points, rounds 1 to 4):

| Boxer | Bouts won | Read on fight night | Read on the offer | The read's round edges |
|---|---|---|---|---|
| Lucy Jackson | 68.3 | 70.5 | 68.6 | 2.1, 9.1, 8.9, 9.1 |
| Kira Mensah | 45.0 | 47.8 | 46.0 | -3.9, -1.5, 5.2, 6.1 |
| Samira Khan | 48.3 | 52.6 | 51.1 | -1.6, 0.1, 5.0, 7.0 |
| Tess Reilly | 28.3 | 29.1 | 21.6 | -1.5, 2.0, -3.9, -11.0 |
| Danny Osei | 57.7 | 56.2 | 53.4 | -0.0, 1.8, 5.5, 6.4 |
| Josh Harper | 38.0 | 40.8 | 39.4 | -3.9, -0.5, 3.0, -0.3 |
| Lucy Jackson (picks B) | 53.7 | 56.1 | 56.0 | -0.6, 3.5, 5.0, 5.7 |
| Kira Mensah (picks B) | 32.0 | 34.4 | 33.4 | -6.1, -3.7, 0.7, 0.8 |
| Samira Khan (picks B) | 25.3 | 25.2 | 24.2 | -5.6, -7.0, -3.2, -3.3 |
| Danny Osei (picks B) | 43.0 | 38.9 | 37.3 | -2.9, -2.7, 0.5, 1.5 |

All boxers, both houses, gaps -2, 0 and +2 (60 cells of 300 bouts):

| Read | Within 5 points | Worst | Mean error |
|---|---|---|---|
| The amateur card (3 rounds), with fixes 2 and 3 | 27 of 60 | 17.5 | +5.6 |
| The booked bout's read on fight night (the bout page), fixed | 57 of 60 | 5.3 | +0.6 |
| The offer's read at signing (DebutRead) | 44 of 60 | 15.3 | -1.9 |

- The booked bout's read meets the brief's bound (5 points) in 57 of 60 cells; the three misses are 5.1 to 5.3.
- The offer's read is the same read made 4 to 6 weeks early, on the boxer as today. It errs LOW, because the camp's
  training is still to come: about 2 points for most, 7 to 15 for a newcomer who is still growing fast (Tess, 6 weeks in
  the gym at the call; her tank is what loses her bouts and the camp trains it). It never read more than 4.2 points
  high. NOT FIXED: counting the training to come needs a forecast of the boxer's attributes; say if it should be built.

What the player sees now (`scripts/ui/modals/ProOffer.gd`, one row a house): "Debut: 4 weeks out, a debutant rated 3.0
under" and "Win chance: about 79%, a draw 13%" - `DebutRead.card`, which reads the opponent `Roster.turn_pro` will book
(`DebutOpp.make`, one rule for both).

## 6. The gaps set
The owner's agreed shape: a debut the boxer is expected to win but can lose. The maps (v9 section 3: "a safer start, or
an earlier and bigger gate") make the guarantee house the safer one and the ticket house the bigger gate.

| House | Old gap | New gap | Measured at the new gap (10 boxers) | Target |
|---|---|---|---|---|
| Bow Lane (ticket house, 4 weeks) | 1.0 (won 48.7 %) | **3.0** | win 60.1 %, draw 16.8 %, loss 23.1 % | 55-65 % |
| Harrow & Finch (guarantee house, 6 weeks) | 1.5 (won about 53 %) | **6.0** | win 74.9 %, draw 13.6 %, loss 11.5 % | 70-80 % |

Both targets are reachable. The numbers are in `ProCall.promoters` (`opp_gap`), which `ProCall.terms` -> the offer ->
`ProOfferWire.signed` -> `Roster.turn_pro` -> `DebutOpp.make` reads. The band's edges: 55-65 % is a gap of about 2.3 to
4.3; 70-80 % is about 5 to 7.

At the new gaps, boxer by boxer (win / draw / loss of played bouts, then the two reads):

**Bow Lane, gap 3.0**

| Boxer | Win | Draw | Loss | Read on the offer | Read on fight night |
|---|---|---|---|---|---|
| Lucy Jackson | 81.5 | 13.0 | 5.5 | 79.3 | 80.7 |
| Kira Mensah | 61.0 | 19.0 | 20.0 | 61.7 | 63.6 |
| Samira Khan | 63.5 | 15.0 | 21.5 | 67.9 | 69.5 |
| Tess Reilly | 47.5 | 16.5 | 36.0 | 33.1 | 42.0 |
| Danny Osei | 75.0 | 16.5 | 8.5 | 68.2 | 70.5 |
| Josh Harper | 53.5 | 17.5 | 29.0 | 53.7 | 54.5 |
| Lucy Jackson (picks B) | 66.5 | 18.5 | 15.0 | 70.4 | 70.5 |
| Kira Mensah (picks B) | 49.5 | 17.5 | 33.0 | 49.7 | 50.8 |
| Samira Khan (picks B) | 44.5 | 19.5 | 36.0 | 38.1 | 39.4 |
| Danny Osei (picks B) | 58.5 | 15.0 | 26.5 | 53.9 | 55.6 |

**Harrow & Finch, gap 6.0**

| Boxer | Win | Draw | Loss | Read on the offer | Read on fight night |
|---|---|---|---|---|---|
| Lucy Jackson | 92.0 | 5.5 | 2.5 | 87.5 | 89.1 |
| Kira Mensah | 75.5 | 13.0 | 11.5 | 75.7 | 78.3 |
| Samira Khan | 84.0 | 10.0 | 6.0 | 79.9 | 81.7 |
| Tess Reilly | 63.0 | 17.5 | 19.5 | 46.3 | 58.5 |
| Danny Osei | 83.0 | 13.5 | 3.5 | 80.0 | 82.7 |
| Josh Harper | 68.0 | 17.0 | 15.0 | 67.7 | 69.8 |
| Lucy Jackson (picks B) | 81.5 | 12.0 | 6.5 | 81.3 | 81.5 |
| Kira Mensah (picks B) | 67.0 | 18.0 | 15.0 | 66.2 | 67.2 |
| Samira Khan (picks B) | 61.0 | 16.0 | 23.0 | 56.1 | 58.1 |
| Danny Osei (picks B) | 74.0 | 13.5 | 12.5 | 69.7 | 71.7 |

## 7. What changed
- `scripts/rules/DebutOpp.gd` (new): the debut opponent, one rule for the bout and the offer's read. A man now debuts
  against a man (the only name list was women's).
- `scripts/rules/CardOdds.gd` (new): the chance of a card of any length; draws; the fitted stoppage share.
- `scripts/rules/DebutRead.gd` (new): the chance the offer shows, and the opponent line's words.
- `scripts/rules/BoutRead.gd`: the booked bout's rounds, the call's cost, Second wind (499 lines).
- `scripts/rules/ProCall.gd`: the two gaps. `scripts/state/Roster.gd`: `turn_pro` books `DebutOpp.make`.
- `scripts/ui/modals/ProOffer.gd`: the two rows above. `tools/turn_gap_probe.gd`: rebuilt. `tools/run_tests.sh`: the new test in the list.
- Tests: `tests/debut_read_test.gd` (new, 38 checks; cannot load on main - the three modules do not exist - and its
  bound is the one main's read misses by 24 points on Tess), `tests/pro_call_test.gd` (the new gaps).

Tests run (through the Godot queue, all pass): debut_read_test, bout_read_test, cardio_line_test, cardio_path_test,
ladder_table_test, nocamp_page_test, phase_wire_test, punch_start_test, versus_test, pro_call_test, pro_offer_wire_test,
pro_contract_test, pro_debut_test, pro_lean_test, pro_week_lines_test, pro_read_test, pro_ladder_test,
loyal_pro_share_test, loyalty_hooks_test, test_jump_test, golden_path_test, no_pronoun_test, plain_words_test,
words_on_screens_test. file_limits_test FAILS on `scripts/ui/Main.gd` at 471 lines (limit 470): the main session's file,
not touched here.

## 8. Left open (for the main session or the owner)
1. One gap per house cannot fit every boxer (section 4: 40 points apart at the same gap). A matchmaker picks the
   opponent to the boxer: set each house by its TARGET CHANCE and let `DebutRead` find the rating (60 in 100 for the
   bigger gate, 75 in 100 for the safer house). The read is good enough to do it. A design change; not done.
2. The offer's read errs low for a boxer still growing fast (section 5).
3. The asks still move the gap by 0.5 (`SOFTER_OPP_ADD`, `SPLIT_TAKE_OPP`): now about 2.4 points of win share each way
   (the maps called it flat; it is not). Their prices were set against the wrong curve.
4. A pro bout that is OFFERED but not yet booked (the pro ladder's rows) still reads as 3 rounds: the read learns the
   rounds from the booked bout. Booked pro bouts read their own rounds.
5. Draws are 1 in 5 near level because a 2-2 card is always a draw (JUDGES1, held).
6. The maps v3-v9 quote TURNGAP1's numbers (v9 lines 81, 114-118, 165). They are wrong; this page replaces them.

Measured on the working tree of 2026-11-21 (main at 61831aaaf plus this task's changes; other sessions' uncommitted edits to
the fight files - LiveRound, PlanFight, Sim, BoutFinish - were in the tree and are part of what was played).

Reproduce: `python ops/Tools/godot_slot.py run --who turnpro6 -- <godot.exe> --headless --audio-driver Dummy --fixed-fps 60
--path . --script res://tools/turn_gap_probe.gd -- nights=300 out=<file.jsonl>` (about 55 minutes on a quiet PC; the
tables above are two runs: 300 nights at gaps -4, -2, -1, 0, 1, 2, 4 and 200 nights at 3, 5, 6, 7, 8).

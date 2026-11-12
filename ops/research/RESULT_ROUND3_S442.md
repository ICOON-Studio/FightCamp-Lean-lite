# Result page round 3 (S442): a bout the game really played

Picture: `docs/mockups/s442/result/fight_result.png` (html beside it, generator `build_result.py`, data `bout.json`).
Data tool: `tools/result_dump.gd` (295 lines). Command:
`python ops/Tools/godot_slot.py run --who S442R3 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tools/result_dump.gd -- out=<repo>/docs/mockups/s442/result/bout.json seed=44 cf=200`
(`scan=40-45` prints one line per offer day instead.)

## The bout
Seed 44 = the career day the offer arrives; fight night is day 61 (Sat 7 Mar). Lucy Jackson (orthodox out-boxer, 3-1) v
Priya Nair (orthodox counter-puncher, 5-1). LOST on points, split: 28-29, 28-29, 29-28. Rounds 4-2, 3-3, 1-5 on exchanges;
round 2 (3-3, 20-22 in punches) went to Priya on the margin and judge 3 alone gave it to Lucy. No standing counts.

How it was played (the game's own path, nothing hand-set inside the fight): `Career.quick_start`, Lucy on the books,
`Bouts.day_events` makes the offer, `Bouts.accept`, `Bouts.weigh`, then `BoutNight.fight_step` start / shout / corner / end.
Two things are set by the tool: Lucy's weight at the limit minus 0.3 kg (no cut week to model) and `c.seed = 442`.
The player's part is a fixed policy: a three-line plan; a shout on the 3rd and 5th exchange of each round taken from the
corner's clue (`LiveRound.preview` "coach"); between rounds the coach's read (`Exchanges.read`) plus a habit fix when one
was offered (none was). The plan:
- A: At long range, any time -> One-two (`1-2`). Rated "Works" against her main game.
- B: At mid range, when the opponent presses -> Step back. "Beats it". Never fired: Priya never pressed.
- C: At long range, when the opponent waits to counter -> One-two-hook (`1-2-3`). "Walks into it" (PlanFight.ANSWERS).
  Fired 3 times (the first exchange of every round), won 1. The game's no-plan replay says it turned R2-1, the closest
  exchange of the bout (margin -0.3), inside the 3-3 round that decided the fight. FightWhy: WRONG PLAN, -5%, cost 14 of the tank.

## Where each part of the page comes from
- Top band: names, stance, style from `fighter` / `opponent`; record and rank before -> after from `before` / `after`
  (RankLine.before over AfterFight.rows; Priya No. 4 -> No. 3, Lucy unranked both times, "1 win from entering").
  Judge grid from BoutRules.cards_of's rule (two judges round for round, judge 3 flips `flip_round`), asserted equal to
  `cards`. "On points, split" = BoutHistory's "points, split". No win chance: the game does not store one (below).
- What decided it: every lost exchange (10) sits in exactly one tile by its situation (`sit` on the record): Loading up 4
  of 5, Line C 2 of 3 (counter, all line C), Fought hurt 2 of 4 (she_hurt), Tired 2 of 2 (she_tired). Asserted to sum to
  FightStats' 10. Evidence: Hands up's record on loaded shots (won 1 of 4), line C's turned exchange (`plan_swing`) and
  tank cost (FightWhy `pressure.tank`), hurt flags (`after.hurt`), the first exchange under 35 (`after.a`).
- What would have won it: measured in the dump (`counterfactual`), 200 other fight nights, one bout each, same opponent
  and corner policy, only the plan changes: as written 35, line C rewritten to Double jab (the Playbook's top option at long
  range v a counter-puncher) 96, no line C 65, a new line "loads up -> Step back" 39, both changes 100. This night's own
  dice replayed: no line C -> WIN 29-28, 29-28, 28-29; line C rewritten -> still a loss (round 2 went 3-3 again).
- The grid: every cell from the exchange record: `mode` (opponent's game, runs asserted <= 3), `won` / `margin` / `landed`
  (bar height = margin, label = landed winner first), `planned` / `arrow` / `arrow_fit` (letter chip, asserted fired on its
  own card and its own WHEN situation), `call` / `shout` / `fit` (dot = the round's call, megaphone = a shout; colours are
  Exchanges.EDGE_WORD), `after.hurt`, `habit`, `place` (RingDuel.PLACE_WORD_CAP: At range / In the pocket / Inside;
  asserted to move at most one place an exchange), energy = round `start` then `after.a/b` per exchange, tired line 35
  (Exchanges.SHE_TIRED).
- Damage: body map at the last bell (`body_map`, the game's BoutMarks build): no place at or under 55, so the list is empty
  and says so. Injury roll: Injuries.line "None" (not injured, so training is full, not a quarter). Sparring: StandDown's
  words split at the colon: "no sparring until Sun 29 Mar" / "the head took 46 damage".
- The numbers (8 rows, one scale per row): FightStats xwon, landed, head, body; exchanges won by place; times left hurt.
  Sums asserted against the grid.
- Plan and corner: each line with its Playbook fit and a won/lost square per use; each round's call with fit and result per
  exchange it stood for (shouts counted apart); the shouts (6, all Big edge, won 2); the clash the records show: R2-1 and
  R3-1 the round's call (Hands up / Tie up, chosen from the end of the round before) stood at "No edge" while line C threw
  One-two-hook into the counter; both lost.
- Footer: the three tile buttons (Playbook new line, Playbook rewrite C, Training tab Cardio) and Drill it: Double jab
  (PadEdit.drill_it; `drillable` true), then Continue.

## Build gates in build_result.py
Fail the build on: an opponent run over 3; a plan line fired off its card or its WHEN situation; grid sums that disagree
with FightStats (exchanges, landed, body, per round); causes not summing to the exchanges lost; the punch table's place rows
or head+body not adding up; the judge grid not giving the game's cards; the replay not reproducing the bout; a place step
over one; any he/she/her/him/his in page text or hovers; any font under 16 px.

## Critic asks left out, and why
- Win chance before the bell (both critics): not stored; FightPrep computes a band on the prep page only.
- "Cardio +3" and "every shout fitting" replays (A): only plan changes were replayed. All 6 shouts already had Big edge.
- Where the energy went, body / pace / fitness (B): the game does not split it; not estimated. Pace was Steady all 18
  exchanges (records), so a pace row would say nothing.
- Per-punch rows, counters, thrown / blocked / slipped, clean-shot counts (A, B): not on the records. The 3D beats have
  per-punch counts but they disagree with the records (defect 3), so using them would break the totals.
- Body silhouettes, hurt places with cause and round (A, B): no place went below fine in this bout.
- Physio for the cut, cut timeline, cutman (A, B): no cut, no injury. Corner-minute jobs (recover, talk, fix): none used;
  the only habit paid for (Slow starter) is not one HabitFix offers.
- Watch round 3 / Replay the plan (A, B): no screen for a finished bout exists in scripts/ui.
- New on the opponent's file (A): the game does open the whole file after the bout ("The whole file on Priya is open now");
  left off for space and because the page is the fight only. Easy to add as a hover on the opponent card.
- Tickable "Apply and continue" (B): no batch-apply exists; each button opens its own screen.
- "Rate my plan v pressers" (B): Priya never pressed in this bout.
- Nationals road: in the JSON ("5/5 bouts, 8 of 13 weeks registered"), not on the page (not about the fight).

## Defects found in the game while dumping
1. Two energies at the last bell. FightStats' "Tank at the last bell" reads `rounds[-1].energy.a_end` (39 v 34 here); the
   exchange records and the fight display (`RingDuel.her_energy`, `after.a`) also take off the bout's body shots (23 v 21).
   The sim fights on the second; the result page's stat row shows the first.
2. FightWhy.next names a move the line cannot hold: "Against a counter-puncher, replace One-two-hook. Try Feint and draw."
   Feint is an Outside-card move; line C sits at long range, so the Playbook (PlanLines.set_line) refuses it. `best_answer`
   reads ANSWERS[sit].best[0] without the line's card. The Playbook's own top option there is Double jab.
3. The body map is built from punches the records did not count: ExchangeBeats lands 62 for Lucy and 68 for Priya against
   the records' 58 and 70 (R1-1 record 4-3, beats 4-2; R1-2 record 5-2, beats 3-2).
4. Three head readings disagree after this bout: StandDown says the head took 46 damage (head place 0, 21 days without
   sparring), the body map's head is 63 (fine), and the Aftermath damage tile says "Nothing lasting".
5. Two position models disagree on one exchange: R2-1 and R3-1 are fought "at long range" on the plan card (`at`, where
   line C fired) but Inside on the duel ladder (`place` 2).
6. The habit line says "Priya made Lucy pay for a habit: slow starter" on R1-1 and R1-2, exchanges Lucy won (the habit cost
   an edge, not the exchange).
7. Two counts of the corner's shouts: the round lines say 1 of 2, 1 of 2, 0 of 2 worked; the Aftermath corner tile
   (CornerTrust) says "2 of 2".
8. Not a defect, a correction to the logic check: landed pairs are not always 4-3 / 5-2 / 6-1. A clinch adds its shots
   (R1-3 is 5-3).

## Logic pass (the 19 items of RESULT_LOGIC_CHECK_S442.md)
1 holds (asserted, longest run 3). 2 holds (line C is a long-range line; asserted on card). 3 holds (no Step in line).
4 holds (rewrite = PlanLines.options at the line's own place). 5 holds (Slow starter punished R1-1, R1-2, both shown;
FightWhy counts it only when lost: 0). 6 holds (no exchange pinned; nothing drawn). 7 holds (asserted). 8 not applicable
(no eye on the page; the map shows only right eyes hit, both orthodox). 9 holds (only the body map's own verdict is shown).
10 holds (one source: exchange records). 11 holds with the correction above (the page shows the records). 12 holds (no
counters row, no thrown counts, no cut side, no opponent or own win chance, hurt shown as a state). 13 holds (Playbook,
Training tab, Drill it exist; no Replay button; not injured, so full training is said). 14 holds (no "legs went"; the body
report says all held; tired = energy under 35). 15 holds ("In the pocket"). 16 not applicable (the wanted place is in the
JSON, not drawn). 17 not applicable (nationals not on the page). 18 holds (the round's call graded per exchange it stood
for). 19 holds (lines read "when the opponent ..." with their place).

## Round 4 (after critic A 6/10 and critic B 6/10 on round 3)
Files: `docs/mockups/s442/result/build_result_r4.py` -> `fight_result_r4.html` / `.png`, data `bout_r4.json` (round 3's
files untouched). `bout_r4.json` is the same seed-44 bout dumped again from today's tree (same exchanges, same cards); the
dump now also stores the opponent's file as it stood before the bout and two corner variants, measured the same way:
the minute's call answers how her rounds open (Draw the lead for rounds 2 and 3), and Push from exchange 4 of round 3.

Measured, 200 other fight nights each, plus this night's own dice:
| Change | Wins of 200 | This night |
|---|---|---|
| Plan as written | 35 | lost |
| Line C -> Double jab | 96 | lost (round 2 goes 3-3 again) |
| No line C | 65 | won |
| New line: loads up -> Step back | 39 | lost |
| Both plan changes | 100 | lost |
| Minute calls Draw the lead for the opening | 36 | won |
| Push the last minute of round 3 | 34 | lost |
Under 10 of 200 (5 in 100) is treated as luck: no button.

What the page does now:
- One row of cause cards with the measured fix on each, ranked by measured gain; line C first, BEST FIX, the page's only
  primary (gold) button "Rewrite line C: Double jab". "Right call, not the tools" (Hands up called 4 times with a big edge,
  won 1; Lucy is OK at it) has a secondary "Training: Defence focus" button marked not measured. "Tired at the end" and
  "The minute called the last round" show their measured numbers as luck, no button. A chances panel puts as-written /
  rewrite / no line C beside this night's result. Continue is a quiet button. Each fix button appears once.
- Colour legend in the generator and asserted: Lucy amber, Priya steel blue everywhere; green / red only for good / bad
  (fit, won/lost squares, LOST); gold only for the primary button, the deciding judge cell, the best-fix card and the
  turned exchange. The page's colours must all be in the legend or the base greys.
- Strip rows labelled where they sit; scores always Lucy first; shouts named from the records; one key line for plan chips,
  call dots, hurt, ROPES and the plan-card disagreement mark; the turned exchange (round 2, exchange 1) outlined and
  labelled TURNED IT. Distance: the ring's place (At range / In the pocket / Inside), plus ROPES / CLINCH from the plan card
  (on the ropes 7 of 18), plus a mark where the plan card says another distance.
- Header: record, "Ladder: unranked, 1 win to enter", "Nationals: needs 3 months registered (5 weeks to go)",
  Priya "Rank No. 4 -> No. 3"; one verdict pair: "On points, split. Round 2 swung it: 2 judges gave it to Priya."
- Numbers: two groups (exchanges won and where; punches landed, head, body), each on one scale.
- Damage as one story: hurt 4 times (2 on the ropes), nothing lasting (injury roll none), no sparring until Sun 29 Mar
  (the head took 46 damage), only sparring locked.
- Hovers carry no code names (asserted).

From critic A: the merged cause cards with measured bars, BEST FIX, one primary, colour discipline, in-place row labels,
the turn outline, rank in words, one-scale numbers, the plan table's column headers, no "R2-1" jargon on the face.
From critic B: rank by measured lever, line C tied to her file, "right call, not the tools", the minute and the pace
measured, chances with this night's result, ropes count, the corrected tired count (3 under the line, 1 won), the habit
mark dropped (both punished exchanges were won), "the plan had a line for 5 of 18", the damage story.

Left out:
- Win chance before the bell (A): the game stores none.
- Watch the turning point / watch round 2 (A, B): no such screen exists.
- "Her file said: right hand counter over the jab" (B): not true in the data. The weapon tell was still hidden before the
  bout (film depth 1); the card says so instead: "Not on Priya's file before the bout".
- Double jab's boxing reason in the critic's words (B): the page uses the game's own reading (feints and single jabs answer a
  counter; long combinations walk into it) in the button hover, not an invented one.
- Body figure with 0-100 bars (A): the page shows only what the game says, once.
- A Cardio button (B: unsupported): dropped; Priya ended lower (21 v 23).
- "Learned on Priya: smells blood and forgets to defend" (B): that line is a coach's note about Lucy, not Priya; the
  footer keeps the true Priya line ("The whole file on Priya is open now").
- Per-exchange plain sentence per round, reveal animation, hover per exchange (A, B): no room in a still at 16 px; hovers
  carry the details.
- The two corner variants as cards with buttons: both measured inside luck, so no button.

Game changes seen between round 3 and round 4 (the fixers' work in the tree):
- Fixed: the round energy at the bell now equals the fight display's (23 v 21 both); FightWhy.next now says "Try Double
  jab", agreeing with the measured fix.
- New defect: the habit line on a won exchange now reads two contradicting sentences: "A habit cost Lucy an edge (slow
  starter), but Lucy still took the exchange. Priya made Lucy pay for a habit: slow starter."
- Still open: the head readings disagree (StandDown's 46 damage locks sparring 21 days while the body map's head is 63 and
  the damage tile says "Nothing lasting"); the plan card and the ring disagree on 8 of 18 exchanges here (rounds 1-3,
  2-1, 2-2, 2-3, 2-6, 3-1, 3-5, 3-6), not only the two line C exchanges; the 3D punch counts still differ from the records.

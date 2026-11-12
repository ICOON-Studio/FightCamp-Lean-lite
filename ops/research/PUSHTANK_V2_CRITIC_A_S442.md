Depth 5/10 · Play 4/10 (fresh systems critic, Motorsport Manager player; read CRITIC_PACK, CRITIC_ACCESS, the v2 map, the v2 drawing, the code below; no earlier review or version)

# PUSHTANK v2, critic A (S442)

Code read: `PaceAim.gd`, `Exchanges.gd`, `RingDuel.gd`, `Knockdowns.gd`, `Combos.gd`, `CornerJobs.gd`, `CornerTrust.gd`, `BoutRules.gd` (tank), `Duels.gd` (constants, `effective`), `BodyLoad.gd` (constants), `LiveRound.gd` (pace, cost carry), `BoutNight.gd` (`_counts`, `_energy`), `PlanFile.gd` (ROUND row, COLD_EDGE), `SidePanel.gd`, `InjuryRoll.gd`, `StandDown.gd`. Real screen `19b_corner1_real.png`.

## 1. Scores

**Depth 5.** The best idea is HEAD as the wear nothing refills; it is the race's engine wear, and it links to the career (`InjuryRoll`, `StandDown`). The rest does not hold up as a trade:
- HANDS is decided by one number. Push has no cost except wind. `PaceAim.edge` gives +6 whatever the opponent is doing, and Push changes no guard and no counter risk (`Duels.PACE_GUARD` and `PACE_COUNTER` read the attribute `pace`, not the corner's pace). So the right HANDS step is a function of wind alone: Push above about 45, Steady under it. Pushing while hurt is right (case 5), which no boxing man will accept.
- FEET does not buy what HANDS buys. HANDS buys edge; FEET buys a PLACE, and what a place is worth is hidden in the duel table. The race screen works because driving mode and engine mode both buy lap time. Here the player cannot ask "which tank is cheaper now", because only one control buys exchanges.
- FEET duplicates the place calls. Jab and move = long, Go to the body / Tie up = inside (`RingDuel.CALL_PLACE`), and the map says a placed call overrides FEET. This is the same fault the map uses to cut AIM.
- LEGS hardly binds in a 3x3 amateur bout, which is most of a career's first hundred fights. See 2.3.

**Play 4.** In a watched round the player sets two steps in the minute and watches. A change costs a shout, and the shout is worth less than the change (2.4), so the cost is a small tax, not a choice. Over a hundred fights a round script wins (2.2), and the ROUND row already lets the player write it once before the fight (`PlanFile.pace_for`). After that, the panel is something to read, not to play. The corner minute already holds five decisions (fix, recover, set-up, talk, plan, see the real screen); v2 adds two more with no trade between them.

## 2. Breaking it

### 2.1 The case table: my pick and whether one read gives it
| # | My pick | One read? |
|---|---|---|
| 1 Ahead 2-0 | Steady + Hold. Only a count can lose it now. Keep exchanges close (a close round has MARGIN_FACTOR 0.3). | Yes: the score |
| 2 Behind 0-2 | Push to the 40 line, then the finish / best call | Yes: score, then the wind line |
| 3 Level 1-1 | Push to 40, then Steady | Yes: the wind line. That is the listed habit "Push above 40/45" |
| 4 Opp hurt | Push + finish call while wind > 40 | Yes: hurt flag |
| 5 We are hurt | Tie up (the call). Push here is a code artefact (no guard cost), not boxing | Yes: hurt flag |
| 6 Body puncher | Steady + Move | Yes: style word |
| 7 Mover | Push + Hold | Yes: style word |
| 8 Opp wind lower | Steady + Press | Yes: the opponent's wind range |
| 9 Slow starter | Push R1 (`PlanFile.COLD_EDGE` 3 for 2 exchanges, true) | Yes: the tell |
| 10 Fader | Steady R1-2, Push R3 | Yes: the tell |
| 11 Short fuse | Not a HANDS/FEET case (the map says so). Drop it | n/a |
| 12 Weight drained | Steady, Push one round | Yes: the wind bar |
| 13 Steal last 30 s | WRONG in the map. At 2-3 a 3-3 round goes to the bigger margin sum (`Exchanges.round_of`), so winning the last exchange is not enough: it must be won by more than the deficit. Push is +6 on a roll 66 wide; the best call is +17. Spend the shout on the best call, not on Push | Yes: the call grade |
| 14 Pinned | "Jab and move" already asks for long (CALL_PLACE). FEET adds nothing | Yes |
| 15 Round lost 0-4 | The map quotes the round band (18 -> 32) that its own 3.3 replaces with per-exchange head. Two exchanges left: Coast saves 4 wind and costs about 1-2 head. Either is fine | Yes: score |
| 16 War | Push + Hold if Stamina higher on the tape | Yes: tale of the tape |
| 17 6-round R4 | Steady + Hold, Push in close rounds | Yes: round count |

All 17 are one-read lookups. None tests two reads that disagree (level 1-1 AND a counter-puncher AND wind 52). That is where depth would come from, and the table never asks it.

### 2.2 The eighth habit: the round script
**"Push round 1, Steady after; Hold all fight; never spend a shout on HANDS or FEET; written once in the ROUND row."**
The arithmetic, from the code: a round spends about 32 (`Combos` calibration: rounds end 68 / 46 / 29); drop 5.3 an exchange; Push adds 0.35 x 5.3 = 1.9 an exchange, and nothing refills it (`LiveRound.gd:403-408` takes `lv.cost` off the next start outside the debt). Push in round 1 stays above 55 the whole round (100 -> 57) = +6 x 6 = +36 edge points with no fade. It costs 11 wind for the rest of the bout: round 2 starts 67 instead of 78, round 3 about 50 instead of 61. That is about -0.9 a round from `tired_penalty` (6/70 a point) plus about -1 from `Duels.effective` (TIRED_AT 65): about -2 an exchange over 12 exchanges = -24. Net +12, and round 1 is a third of a 3x3 card. "Push above 55" behaves almost the same way, but it needs a read. The script needs none, and the ROUND row automates it. It also uses no shouts: both full shouts go to calls.
A ninth habit to probe: **FEET by the opponent's style word**, set once (Move vs body punchers and pressers, Hold vs movers, Press vs faders). Cases 6, 7, 8 and 10 are exactly this table.

### 2.3 Arithmetic and code claims
- Push cost and buy: right. +6, x1.25 landed, x1.35 drain, fades from 55 to 0 at 40 and -6 at 25 (`PaceAim.gd:10-12`, `:182-190`). "Push five, Save one" = 6.75: right at drop 5. Note that the x1.25 landed is almost cosmetic: rounds go on exchanges won, and landed only feeds the body-shot count.
- The head line at 60 is FALSE as a decision line. The count chance is linear in damage (`Knockdowns.gd:34`: x(1 + dmg/60); 30 already gives x1.5). A count can end the bout at ANY damage: the referee's wave-off is 0.2 x (1 + dmg/60) x (1.4 - heart/100), already 17% at 0 damage with heart 55 (`:55-60`). KO_DAMAGE 60 only changes the result's word from RSC to KO; both stop the bout. "Head 60: a count can finish it" teaches a wrong rule. Show the multiplier instead.
- Head per exchange (NEW 3.3): "same scale over a round" holds for the total but not for who takes it. Per-exchange bands use `EX_SPREAD` 66 (close 44%, clear 40%, dominant 16% between equals), so each side takes about 8-9 a round. Today the round's winner takes 2 and its loser about 15. Under v2 a fighter who wins every round still takes about 7 a round. That changes no-sparring days and injury rolls for winners. The map does not flag it, and the probe does not log it.
- LEGS sizing does not add up. Press costs x1.5, but Press takes the fight inside, and inside halves it (x0.5, `BodyLoad.INSIDE_LEGS`). So Press inside costs about 0.75 base, the same as Hold (0.7) and cheaper than Move (1.0). With base 2.0, the wind link (about 1.2) and fitness (about 0.96): Press inside is about 1.7 an exchange. Over 18 exchanges that is about 31, plus about 6 from body shots, less about 8 from the minutes, so about 70 at the last bell. "Always Press reaches 30 in round 3" is not true unless the opponent keeps it long. Under case-table play, legs end a 3x3 bout around 60-70: above the 50 cliff start for the whole bout. In amateur bouts LEGS is a meter that never matters.
- Press "as if the dial were 75" also costs guard (`Duels.FWD_GUARD` 0.28 x 25 = -7 guard). This is a hidden head cost the map does not state.
- The fitness factor uses mean(Stamina, Footwork). That goes against the code's own S433 rule ("Stamina alone, never the mean", `Combos.spend_factor`). Pick one.
- Case 12: 25 is `TANK_MAX`, the cap for tiredness + weight + last bout together (`BoutRules.gd:189-198`). The weight part is (kg + kg over 0.5) x 10 on the day, so 15 for 1 kg.
- The corner minute: right. 52% of the fast debt (60% of spend) x Recovery 0.8-1.2 is about 31% of the round back (`Combos.after_round`). Water is +3 a point (+6 under 40), `CornerJobs.gd:15-16`. Clear the head only removes the hurt flag (`:52-62`). Nothing gives head back. Correct.
- The opponent's ranges, 16 / 6 (`SidePanel.gd:19-20`): right.

### 2.4 The shout price
Only shouts after the second land at half (`Exchanges.uptake`). A HANDS change costs one call dropping from full to half: about 0.5 x 17 x grade = 5-8 points, once. Push from exchange 2 to 6 buys up to +30. So the price never decides anything. It is a tax that makes the screen look scarce without making the choice harder.

## 3. The race feel
The forecast lines in clock time ("gassed 2:00 into round 3 at Push") are the right instrument, and HEAD as the wear that never comes back is right. It falls short in five places:
1. **Not substitutes.** In Motorsport Manager both modes buy pace. Here FEET buys a place, so there is no "which is cheaper now" question.
2. **The gain is invisible.** The panel shows every cost (hatched next 30 s) and no gain. The race screen shows the lap delta. Push = +1 exchange in 11 should be printed on the step.
3. **No pit-stop choice.** The minute's refill is automatic; legs get a fixed 20%. A pit stop matters because you choose what to restore (compound, fuel, wing). The three recover points are the place for it, but legs are not on them.
4. **No track position.** Driving mode in the race buys position against a car that is also managing. Here the opponent's HANDS is a script by style and score; it does not answer yours.
5. **No wear that carries to the next race.** The head links to no-sparring days in code, but the screen never shows that cost during the fight.

## 4. Amount
For 6 exchanges of 30 s, two three-step controls and three meters is the right count only if both controls buy the same thing. As drawn it is too much on screen and too little in choice. Cut: the floor rings as the reading instrument (keep them only as a flash at a line), the opponent's full HANDS/FEET rows (one tell line is enough), five of the six readout sentences (show one: the meter nearest its line), and FEET's place role from the calls (or the calls' place from FEET: one owner). Missing: the gain on each step, a situational risk on Push, a legs point in the minute, and the after-fight cost on HEAD.

## 5. Set free in the minute, a shout in the round
For play this is the wrong lever. Calls already give the round its rhythm; the controls should be the race's mode dial: free to change, with a price paid in the resource, not in shouts. Make it free, with effect from the next exchange plus one settling exchange at half effect. A Low fighter keeps the minute's setting (`CornerTrust.lands`). That gives the player something to do mid-round that is a real trade, not a tax. Without it the controls become a three-times-a-fight setting, and the ROUND row plays them for you.

## 6. The screen
- Rings under the feet: on a broadcast camera at an angle, an arc's fill is foreshortened and hard to read as a fraction. When both fighters are inside, the two rings overlap; in the drawing they already touch at mid range. They also duplicate the panel bars. Readable as an alarm, not as a gauge.
- "Less than today" is not true in reading load. v2 removes four widgets, but each corner panel has 5 control/meter rows and 3 sentence readouts, plus a hatched tooltip: about 16 lines of text live in a watched round. Today's in-round screen has fewer words (the corner minute is where today's load is). The opponent's panel rows ("Breaking soon at this pace", "Pressing costs these legs too") are information the player cannot act on beyond what one tell line gives (owner's rule: only actionable information).
- The three line marks are good. Drop "a count can finish it" at 60 (false, 2.3).

## 7. The probe
Arms A-D at 3 and 6 rounds with paired seeds are right. Missing:
1. The **round-script** habit (2.2) and the **FEET-by-style** habit. Every listed habit is a threshold or a constant; the script beats thresholds because it needs no read.
2. **Full bouts from the first bell**, favourite and underdog (5 and 10 points apart). The 17 starting states cannot show a whole-bout policy.
3. **Legs at the last bell by FEET policy in 3 rounds** (a distribution). If case-table play never crosses 50, FEET is inert for amateurs: fail.
4. **The shout-cost cell**: "change HANDS mid-round whenever the table says so" against "never change mid-round". If changing always wins, the price is a tax.
5. **The two-reads cell**: states where wind, score and the opponent's game point different ways. This is the only cell that measures depth.
6. **Head per side by round outcome**, to catch the winner's new damage (2.3).
The bar "beats every habit by 3 points" at 400 paired bouts is fine if it is measured as a paired difference with its interval. Report the interval.

## 8. To reach 10/10 (most important first)
1. **Make FEET buy exchanges too, so both controls buy the same thing with different tanks.** Walk down: the pinned side's ROPES 8 x (1.3 - composure/100) gets applied as edge after 2 exchanges, plus the opponent's legs x1.3. Back off: removes the opponent's place edge (their `Duels.at` edge at their wanted place goes to the long one). Each step costs legs. Then move place OUT of the calls (`RingDuel.CALL_PLACE` emptied: a call says what to do, FEET says where), so nothing is duplicated.
2. **Give Push a situational risk, not only a wind cost.** Against Waiting to counter and Loading up, Push raises the margin spread and the her_hurt chance (x1.5, `RingDuel.gd:349`); against Pressing and Tiring it does not. HANDS then reads two things (wind and the clue), and Push while hurt becomes wrong.
3. **Size LEGS so it binds in a 3x3 amateur bout.** Drop the inside x0.5 for the side that pressed in (keep it for the pressed side). Base about 3.0, so that Walk down all bout crosses 50 by mid round 2 and Hold ends near 55. Probe target: under case-table play, legs under 50 in round 3 in at least a third of bouts.
4. **Print the gain on every step.** "+1 exchange in 11 · -2 wind" on Push and "+1 in 9 · -4 legs" on Walk down, from the same expectation BoutRead already computes (`RingDuel.mean_edges`). In the minute, one line: "Cheaper now: Walk down".
5. **Changes free, from the next exchange, with one settling exchange at half effect;** trust still gates (`CornerTrust.lands`). Shouts stay for calls only. The FULL_SHOUTS tax goes.
6. **The pit stop as an allocation.** Add "Rub the legs" (+6 legs a point) to the three recover points (`CornerJobs.options`), and drop legs' free refill to 10%. The minute then asks wind or legs or ribs: the compound choice.
7. **HEAD tells the truth and carries out of the ring.** No 60 line; show "counts x1.4" (1 + dmg/60) and, live, "after the fight: no sparring N days" from `StandDown.make`. Make per-exchange head keep today's winner/loser split: the round's winner's exchanges lost take half, or the probe shows the winners' new rest days.
8. **The opponent's HANDS answers yours:** a corner that sees you Push and leads by 2+ exchanges Coasts and counters; behind, it Pushes. Shown as one tell line, never a full row.
9. **Fix the case table:** add the two-reads cases (level, counter-puncher, wind 52); correct 13 (best call beats Push), 15 (per-exchange numbers), 12 (25 is the total cap); drop 11.
10. **Probe additions:** round-script, FEET-by-style, whole bouts favourite and underdog, legs-at-last-bell in 3 rounds, shout-cost, two-reads cell, head by round outcome. A habit that needs no read and wins more than 5 cells of 10 fails the design.
11. **Screen:** rings only as a flash when a line is about to be crossed; the opponent panel is three bars as ranges and one tell; your panel has one sentence, for the meter nearest its line; the minute shows the next round's forecast at the chosen setting.

## 9. My 10/10 drawn
`docs/mockups/s442/pushtank_v2_critic_a/ten.html` -> `ten.png` (1920x1080). Two controls in the bottom bar, each step with its gain and its cost per 30 s; calls keep the shouts; compact corner panels with lines and one forecast sentence; the ring flashes only on the opponent about to lose the legs; the pit-stop column with water / rub the legs / ice / clear the head, both controls, the next round's forecast, "the trade this round" with which tank is cheaper now, and the head's cost after the fight.

# STATION FOCUS (S266) - set his program, watch him do it, the ring is the test (boxing demo)

Operator S266, verbatim: "you setup his program and then watch him do it , the bars of attriton and stamina there you se the
gains ;like bubles , you select the heavy bag and you have 2-3 options to focus with different +/- .same with other stations ,
and the real test is the ring time" ... "just need more simulation like style" ... "keep it simple but deep".

## Simple (what he sees)
1. Morning: he sets the day's program (Day Plan, built) - which stations, in what order.
2. He watches: the boxer walks and works each station; the meters (gains / attrition / fatigue, top-left) move; a GAIN BUBBLE rises
   over the boxer for each attribute that grew ("+0.3 POWER"), one bubble per attribute per gain tick.
3. Click a station (or the boxer on it): a small card with 2-3 FOCUS options for THAT station. Each option is one line:
   the name, what it builds (+), what it costs (-). Keys 1-3. It replaces today's generic POWER THROUGH / CRISP FORM / PACE YOURSELF bar.
4. The ring is the test: a SPARRING block ends with a RING REPORT - three lines comparing this spar with the last one.

## Deep (what runs underneath - all on systems we already have)
- A focus re-weights the station's hours across ITS attributes (Attributes.STATIONS rates, PACE, coach, age, caps untouched) and can
  add one CROSS-TRAIN attribute at a reduced rate. Gains still go through Attributes.gain (diminishing returns near the cap).
- A focus scales the station's LOAD (LoadLedger.station_hourly_rate x LOAD) - the same ledger the attrition meter reads. Harder focus =
  faster gains AND faster attrition: the trade-off is real, not a label.
- The same focus day after day raises Foster monotony (TrainingMeters already reads it) -> gains flatten -> CHANGE THE PLAN fires.
  Varying focus is the skill the player learns.
- The coach's specialty boosts matching focuses (the existing hire picks: Pad man +15% at bag/pads -> applies to every focus there).
- WEAR: options marked "wear" add to niggle risk (Niggle, built) - sparring HARD and INTERVALS only.

## The table (gain multiplier per attribute; LOAD = x station load; "default" = what plays if he never picks)
| Station | Focus | + builds | - costs |
|---|---|---|---|
| Heavy bag | POWER SHOTS | power x1.6, technique x0.6 | LOAD x1.3 |
| | COMBINATIONS (default) | technique x1.6, power x0.6 | LOAD x1.0 |
| | BAG ROUNDS (3-min rounds) | power x0.8, technique x0.8, +conditioning x0.4 | LOAD x1.2 |
| Pads (coach) | HAND SPEED | hand_speed x1.6, head_movement x0.6 | LOAD x1.0 |
| | DEFENCE (coach fires back) (default) | head_movement x1.6, hand_speed x0.6 | LOAD x1.0 |
| | UNDER FIRE | hand_speed x1.0, head_movement x1.0, +composure x0.3 | LOAD x1.3 |
| Speed bag | RHYTHM (default) | hand_speed x1.2 | LOAD x0.8 |
| | ENDURANCE | hand_speed x0.8, +conditioning x0.4 | LOAD x1.2 |
| Double-end / defence drill | GUARD (default) | guard x1.6, head_movement x0.6 | LOAD x1.0 |
| | SLIPS | head_movement x1.6, guard x0.6 | LOAD x1.0 |
| | COUNTERS | guard x0.8, head_movement x0.8, +fight_iq x0.3 | LOAD x1.2 |
| Shadowbox / mirror | TECHNIQUE (default) | technique x1.3 | LOAD x0.8 |
| | FOOTWORK | technique x0.6, +footwork x0.8 | LOAD x1.0 |
| Agility ladder | QUICK FEET (default) | footwork x1.4 | LOAD x1.0 |
| | LONG SETS | footwork x0.8, +conditioning x0.4 | LOAD x1.2 |
| Treadmill / bike | STEADY (default) | conditioning x1.0 | LOAD x1.0 |
| | INTERVALS | conditioning x1.5 | LOAD x1.5, wear |
| | EASY SPIN | conditioning x0.3, +recovery x0.6 | LOAD x0.4 |
| Weights / platforms | STRENGTH (default) | power x1.4 | LOAD x1.2 |
| | EXPLOSIVE | power x1.0, +hand_speed x0.2 | LOAD x1.0 |
| Ring (sparring) | TECHNICAL (default) | guard, fight_iq, composure x0.8 | LOAD x0.7 |
| | HARD | guard, fight_iq, composure x1.4 | LOAD x1.4, wear + cut risk |
| | SITUATIONAL (coach sets the problem) | fight_iq x1.6, guard x0.6, composure x0.6 | LOAD x1.0 |
| Recovery (stretch / physio / ice) | - one option, no card | | |

Card text format (one line each, exactly): `[1] POWER SHOTS   + POWER  - more fatigue`. "+" words = the x1.4+ attributes; "-" = LOAD >= 1.2
("more fatigue"), LOAD <= 0.8 ("easy"), wear ("injury risk").

## The ring is the test - RING REPORT (after every sparring block)
Three lines, each against his LAST spar (first spar: no arrows):
1. `LANDED 34% (+4)` - his clean-punch share (the bout engine's accuracy over the spar's exchanges).
2. `GUARD: 12 clean shots taken (-3)` - clean head shots he took.
3. One coach line naming the weakest of the three - gassed late (conditioning), took the most shots (guard / head movement),
   landed least (technique / hand speed): "He fades in round 3 - put him on the bike." The line names a STATION, so the report
   tells the player what to set up tomorrow. That closes the loop: program -> watch -> test -> change the program.

## Build
1. Arena: pure `rules/StationFocus.gd` + `tests/station_focus_test.gd` - the table as data, `options(station)`, `weights(station, focus)`,
   `load_mult(station, focus)`, `card_lines(station)`, `ring_report(this_spar, last_spar)` (coach line picks the weakest).
2. Claude wires: the focus card replaces the effort bar (bottom centre, keys 1-3), AttributeTraining.apply_day reads the weights,
   LoadLedger the LOAD, the floor's gain bubbles name the attribute; SparringBlock writes the ring report. Switch `station_focus` in GAME_ON.
3. Stills on the iso game camera: the card at the heavy bag, bubbles rising, a ring report - on the board for his OK.

## Every attribute wired end to end (operator S266: "all 12 atributes or most of them should be wired into the training,body,fight,moves etc")
We have 11 (10 trained + chin, innate). Status from master (S260-S265 commits), and what this plan adds:
| Attribute | Trained at (focus table above) | Fight (numbers) | Body / moves (what you SEE) |
|---|---|---|---|
| hand_speed | pads HAND SPEED, speed bag, weights EXPLOSIVE | yes (derived accuracy) | YES jab/cross clock (3e6c4521) |
| power | heavy bag POWER SHOTS, weights | yes (damage) | NO -> bigger hip/shoulder turn + target snap on landed power shots |
| technique | heavy bag COMBINATIONS, shadowbox | yes (accuracy) | NO -> straighter punch lines, less wind-up (telegraph) on the move clips |
| footwork | ladder, shadowbox FOOTWORK | yes (range/escape) | NO -> step length + step rate, pivots instead of flat-footed shuffles |
| guard | double-end GUARD, ring | yes (blocks) | PARTLY (guard_lift_m exists but is 0 while the guard IK is on) -> glove height in the IK target + faster return after a punch |
| head_movement | pads DEFENCE, double-end SLIPS | yes (evasion) | NO -> slip/roll depth and how often he moves his head between exchanges |
| conditioning | bike/treadmill, BAG ROUNDS | yes (stamina tank) | NO -> late-round hands drop and stance narrows as the tank empties |
| fight_iq | ring SITUATIONAL, COUNTERS | yes (choices) | NO -> range choice: steps in/out to his best punch distance |
| composure | ring, pads UNDER FIRE | yes | YES damage snap (2375713d) -> also: covers up vs panics when hurt |
| recovery | EASY SPIN, physio, ice bath | NO -> between-round reset of stamina + swelling | corner minute: how much he gets back (shown on the stool card) |
| chin | innate (not trained) | yes (KD threshold, attrition after KOs 72e4897a) | NO -> how hard a clean shot wobbles him |
Body/move rows are Ziva's area (fight animation) - each goes to Ziva as one motion item with a red number first, AFTER spacing (#5).
The training rows are this spec; the fight rows exist; recovery's fight row is new (Claude, FightRealtime corner minute).

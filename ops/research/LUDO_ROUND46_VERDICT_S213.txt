# LUDO ROUND 46 - VERDICT (S213): skill learning that always reaches the fight

Operator brief S213 (verbatim): "ask ludo to review our current learning skill system and propose imporvements/mechanics that always
reach the fight in a meaningful and enjoyable way for the player to be addicted in continuing playing the game and in the same time be
close tohow real fighters improve by triaining"
Ask `LUDO_ROUND46_ASK_S213.txt` (16.6k chars: facts sheet + code audit + real-world research). Reply verbatim
`LUDO_ROUND46_S213_reply.txt` (27,660 chars, complete A-H, one reply). Code audit behind the ask: Explore pass S213 (file:line in the ask).

## The problem in one line
Training is real but invisible in the fight: five progress records (stats, technique unlock, drill pips, combo tightness, move-card
minutes), and the live boxing engine reads almost none of them and writes nothing back.

## Defects found by the audit (fixed or queued at once, not waiting for this verdict)
- FIXED 4d8d724d: career strand edge never reached the fight (`strands` written, `training_strands` read) - test strand_edge_career_key_test.
- QUEUED: live fights record no technique usage (FightNightScreen.gd:1527-1540) -> slice 2 below.
- QUEUED: fatigue does not slow learning although the tooltip says it does (AthleteStatModel.gd:149) -> slice 3.
- QUEUED (small): Aging BAND_STEPS still age `grapple`, the three grapple stats never age (Aging.gd:155-157); wrestling_leg_ride needs a
  non-existent attribute "control" (MMA, not in the demo).

## TAKEN (build to this)
1. ONE RECORD PER TECHNIQUE with mastery STAGES after it is learned - the real path a coach would name:
   LEARNED (pads/mitts, shadow) -> DRILLED (partner drills, bag) -> SPARRING-PROVEN (situational + open sparring) -> SIGNATURE (landed in
   real fights under pressure). Record = {stage 1-4, reps, spar_rounds, fight_lands}. Stage gates (DESIGN, tuned by tests):
   Drilled ~1,500-2,500 reps over 3-6 weeks; Sparring-proven 20-35 live sparring rounds; Signature 25-40 clean lands in fights.
2. THE LIVE FIGHT READS THE STAGE (the core of the brief). Per technique, the stage scales: how often the boxer chooses it, how fast it
   is thrown, its accuracy, its stamina cost, how well it holds when tired, the counter window, and its damage. A stage-1 slip is only
   tried when fresh; a signature slip still happens at low stamina. Ranges come from Ludo's table, mapped to OUR engine's existing
   knobs (see CHANGED for the scaling).
3. THE FIGHT WRITES BACK: per technique attempts / lands / lands under pressure / counters taken; lands under pressure feed stage
   progress (only for moves the boxer trains); the hole the opponent exploited is named (e.g. "ate 6 clean overhands: lazy return on the
   cross").
4. POST-FIGHT DEBRIEF = the proof screen: rows "camp focus | planned | done in the bout | what it did" ("Slip-cross counter - drill to
   Sparring-proven - 9 thrown, 6 landed - knockdown round 4"), the exposed hole with a suggested focus for next week, body wear.
5. LOSSES TEACH: an exposed hole gives a time-limited learning boost on the techniques that close it (DESIGN +15-25% reps for 3 weeks
   with the head coach), so a loss sets next week's plan.
6. CAMP SHAPE matters: build (volume) -> intensity (hard sparring, stages 2->3, injury risk) -> taper (last week ~60% less volume,
   fatigue sheds, sharpness kept); fight night readiness shows if the taper was right.
7. FATIGUE SLOWS LEARNING (makes the tooltip true): above fatigue 75, technique progress falls (DESIGN -40 to -60%) and soft-tissue wear
   rises - training hard is a real trade-off.
8. RUST: a Sparring-proven/Signature move unused 4+ weeks executes one stage lower until a few pad rounds tune it back (stages are never
   lost). Conditioning detrains after ~3 weeks off.
9. DRILL PIPS and MOVE-CARD MINUTES become views/feeds of the technique record (station hours -> reps of the moves drilled there);
   COMBO TIGHTNESS becomes derived from the stages of the chain's moves. Old save fields migrate, nothing is deleted from saves.
10. SMALL LIVE TAG in the broadcast HUD when a trained move lands ("Slip-cross counter - Sparring-proven") and an amber one when a
   low-stage move fails tired - short, one at a time, switchable (Ludo gate for the look).
11. PLATEAU BREAKERS are decisions with costs: a coach whose specialty matches, a sparring partner of the style that exposes the hole,
   a bout against a type - never a free reward or a timer.

## CHANGED / REFUSED (Claude)
- "Tiers 1-2 auto-granted is wrong" - KEPT AS IS: the fight needs a full boxing palette; identity comes from STAGES instead - a T1/T2
  move the boxer never drilled fights at stage 1 (rarely chosen, slow, gasses). Same effect, no empty palette.
- Ludo's stage-1 numbers are too punitive for our hit model (accuracy x0.40, stamina x1.6): we map stage to a multiplier band on our
  existing chances, roughly x0.85 (stage 1) to x1.12 (signature) for speed/accuracy/damage and choice weight 0.4-1.6; tested with a
  bounded target (signature vs stage-1 slip-counter lands +30-70% over 200 seeded rounds, never an exact count), with a control arm.
- Milliseconds (60-250 ms counter windows) become our engine's own window units; the ratio is kept, not the ms.
- Signature in "1-2 years": kept as needing real fight lands, but 25-40 lands so a signature arrives within a season of activity.
- Film study "+1.2-2.5 fight IQ" refused: fight_iq is derived (fights 0.40 ...); film study instead gives a read edge vs that style for
  the next bout and counts toward the fights component.
- Stat plateau formula (quadratic in the last 5 points) refused: our headroom term already slows near potential; F-table rates are
  checked against ours in slice 3, not pasted.
- Invented names (Leo Vance, Julian Cruz, Marcus Sterling, D. Washington) ignored; the UI mock layout is input for the Ludo UI ask,
  not a spec. Raw ids (boxing_slip_counter) never shown to the player - display names only.
- Ludo's test sketch (FightSimulationEngine API) is not our API; slice tests are written against FightRealtime.

## BUILD ORDER (after the operator approves)
- SLICE 1 TECHSTAGE1 (Codex): stage record + migration from technique_progress/pips/move cards for the 25 certified boxing moves;
  FightRealtime reads stage -> choice weight, speed, accuracy, stamina, tired-hold, counter window, damage (behind switch
  `technique_stages`). Test: same boxer, slip-counter stage 1 vs 4, 200 seeded rounds, lands up within the band; OFF = byte-identical.
- SLICE 2 FIGHTLOG1: the live fight records per-technique usage + pressure lands + exposed hole; written back to the record after the
  bout (fixes the "no usage" defect). Test: a scripted bout writes the counts the log holds.
- SLICE 3 CAMPLOAD1: fatigue slows learning, rust, taper/readiness, hole -> boost. Tests per rule with control arms.
- SLICE 4 DEBRIEF1 (UI, Ludo gate first): post-fight camp-focus table, live HUD tag, profile stage chips + "needs 6 more spar rounds".

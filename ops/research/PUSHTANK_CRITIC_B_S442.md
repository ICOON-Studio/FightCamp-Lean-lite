THE IDEA AS WRITTEN: depth 5/10, play 7/10
THE MAP (PUSHTANK_MAP_S442): depth 6/10, play 6/10
One control or two: TWO. HANDS spends WIND, FEET spends LEGS.
10/10 drawing: docs/mockups/s442/pushtank_critic_b/ten.png (from ten.html)

# PUSHTANK, critic B (a corner man of twenty years who also plays Motorsport Manager), S442

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, PUSHTANK_MAP_S442.md, fight_bars.png, and in code PaceAim.gd, Exchanges.gd
(calls, BODY_COST, SHE_TIRED, OPP_TIRED, FULL_SHOUTS), Combos.gd (round_spend, refill, after_round, tired_penalty),
Duels.gd (TIRED_AT 65, effective, PACE_HOT / PACE_WORK / PACE_COUNTER). No other reviews read.

## 1. The idea as he wrote it: depth 5, play 7

What is true. Managing a fighter's pace against his gas is half of real corner work. Between rounds you decide how much
to spend next round: "bank this one, take the jab, win it easy" or "this is the round, empty the tank". During the round
you have a few shouted words; the classic one is the last-30-seconds call, when the corner bangs the apron and the fighter
steals the round with a flurry. A tank that drains and partly comes back is exactly what a cornerman watches: mouth open,
hands dropping, feet flat, leaning on the other man.

What the real tank is. Three things, not one:
- WIND (breath). Goes fast in a busy exchange, comes back fast. The minute gives back most of it. A quiet 30 seconds (jab
  and move, a clinch) gives some back inside the round. This is the fuel.
- LEGS. Go slowly over the whole fight, from pressing, cutting the ring off, moving on the outside, and from body shots.
  The minute gives back little. When they go, they go at once: the fighter cannot get off the ropes, cannot step in
  with the punch, plants flat and gets hit. This is the tyre and its cliff.
- ARMS (shoulders). Heavy arms mean the guard drops. In practice they follow output and fall with wind and legs together,
  so they do not need their own bar.
Body shots take wind at once (a liver shot stops your breathing for seconds) and take the legs over rounds. Second wind
is real but it is heart and a lull, not a rule you can count on.

What pushing costs and buys, by style. Pushing (more punches, more work) buys exchanges and the judges' eye (amateur
judges score competitiveness and initiative as well as clean blows). It costs wind. Against a counter-puncher pushing
walks into counters; against a mover, pushing your feet forward costs legs and wins nothing if the hands do not land;
against a body puncher pushing into the pocket is where he wants you. So the price of pushing depends as much on WHERE
you push (feet) as on how MUCH you throw (hands).

Why depth 5. As written, it is one switch over one bar: "when do I spend?". Good feel, but a timing question with few
real answers: push when behind, when the other man is hurt or gassing, ease when ahead. A player solves it in three
fights. Play 7 because it is tactile, readable, and gives the fight a heartbeat between the shouts.

## 2. The map: depth 6, play 6

Strong: it is built from the code, it found the real exploit (Save's +6 an exchange pays for 4.6 Push exchanges; free,
unlimited toggles), it removes Save, it asks for a probe before any screen, it shows the cost before pressing, and it
greys what the minute can never give back. The "lasts to the bell" readout is the best part: it is the race's fuel delta.

What a coach calls wrong:
1. **Free, unlimited switching every 30 seconds.** No corner turns a fighter on and off like a tap. In the round you get
   two or three shouts the fighter actually hears; the code already says so (FULL_SHOUTS 2, then half). The map keeps
   the pace free and unshouted (section 9, "Free: no shout, no heard pip"). That is untrue and it makes the switch a
   fiddle. The real rule: the round's pace is set in the minute for free; changing it mid-round is a shout, uses one of
   the two, and passes through trust (a Low fighter does not hear it, a short fuse may not stop).
2. **Wind back within a round.** Some, yes, in a quiet stretch. Breathe at +3 an exchange is fair. The old Save at +6
   plus x0.6 drain was not. Good that it goes.
3. **"Tired" as one line.** Tiredness is a slope; the code already has it as a slope (Duels.effective from 65,
   tired_penalty linear). The named 35 tick is fine as "now it is the problem", but the readout should say a slope:
   "slowing" from 65, "gassed" under 35. The real cliff is the LEGS, which the map does not model.
4. **One resource.** The map rejects legs because the sim has one tank. That is a fact about the code, not about boxing.
   He asked for "the tires and the fuel". One control on one bar is not the race screen: the race screen is two controls
   on two resources that trade against each other.
5. **Judges "pro only" for work.** Amateur scoring rewards initiative and competitiveness too. Push and Press should tip
   a close amateur round, not only pro.
6. **No time weight inside the round.** Judges remember the last 30 seconds. All six exchanges weigh the same in the map.
7. **Readouts in exchanges.** A coach counts in time: "gassed a minute into round 3", not "5 exchanges early".

The case table, case by case:
| Case | Map's answer | Verdict |
|---|---|---|
| 1 Ahead 2-0 into R3 | OFF | Mostly right. A real corner says "stay first, stay busy with the jab, move, no risks", not "coast". Coasting in front of judges and a referee costs. Right answer: hands Steady, feet Move. |
| 2 Behind or level into R3 | ON all of it | Right. Add: feet Press, cut the ring off. |
| 3 Opponent hurt | ON + finish | Right, with one condition: only if our wind can carry the flurry. A gassed finisher punches himself out and gets countered. |
| 4 Our fighter hurt | OFF, Tie up | Right. Also feet Move: get off the ropes, circle away from the power hand. |
| 5 Opponent's tank lower | ON | Right. Better: go to the body and make him move: press the feet, his legs go first. |
| 6 Body puncher | ON early, OFF late | WRONG. You do not push into the pocket against a body puncher; that is where he digs. You keep him on the end of the jab and move, and tie up when he gets in. This is a FEET answer the one-switch map cannot give. |
| 7 Short fuse hit hard | OFF + Calm down | Right. |
| 8 Slow-starting opponent | ON early | Right ("jump on him"). |
| 9 Fader | OFF R1-2, ON R3 | WRONG in a 3-rounder. Give away rounds 1 and 2 and a winning round 3 still loses 1-2 on the cards. Right: win rounds 1-2 at Steady, go to the body to speed the fade, then everything in R3. |
| 10 6-round pro | short bursts at close rounds | Right. |

Missing cases (each with the right answer in a real fight):
- **Drained by the weight cut.** Starts with less wind and refills worse in the minute. Right: Steady, Move, spend only in the round that decides it. The game has fight-week tiredness at the first bell but not a drained refill.
- **Southpaw puzzle.** Not a pace question; a feet question: outside foot, step to the lead-hand side. Pushing straight in walks onto the straight left.
- **Last 30 seconds of a close round.** The steal. Push for the last exchange only, even when fuel is short: the round is a scoring unit, the tank refills in the minute.
- **Pinned on the ropes.** Legs. Feet Move costs legs to escape; Hold costs damage. A fighter with no legs left cannot choose.
- **Mirror war (both push).** Two pushers burn each other; the one with more wind and the better chin wins. The opponent's corner must push too, or there is no war.
- **Round already lost (opponent 3 exchanges up with 1 left).** Bank it: steady, take the refill into the next round.
- **Cut on our fighter / on theirs.** Ours: push now before the doctor stops it. Theirs: work the cut, keep it busy.
- **Reach disadvantage.** Pressing costs legs to close distance; a tall mover makes you pay in legs, not wind.

## 3. The reference: tyres and fuel in boxing

- FUEL = WIND. Burnt by output (punches thrown, combinations, the bursts). Mostly back in the minute (the code's 52% of
  the fast debt x Recovery is about right). A little back in a quiet 30 seconds (Breathe, Tie up, Jab and move).
- TYRES = LEGS. Worn by where the feet go: pressing and cutting the ring off wears them most, moving on the outside wears
  them steadily, holding the centre and planting wears them least but takes more punches. Body shots wear them (the late
  part of a body shot). The minute gives back very little (a few points). A cliff at about 30: below it footwork and guard
  fall away (the code's Duels.effective already lowers guard, head movement and footwork; drive those from legs instead
  of from energy), the "ropes" place comes up more, and the push edge is lost because a flat-footed fighter cannot step in.

The two controls:
- HANDS: Push / Steady (his on / off). Push: more exchanges won and more landed (today's +6, x1.25); wind x1.35.
- FEET: Press / Hold / Move.
  - Press: takes the centre, pins the opponent, makes his legs work too (his legs x1.2), wins close exchanges (work for
    the judges), legs x1.5 for us; walks onto counters against a counter-puncher.
  - Hold: plants in the middle; legs x0.7; more punches taken both ways (more body shots on us).
  - Move: on the outside; legs x1.0, fewer punches taken, wins at range against a presser, loses close exchanges to a
    busy fighter; buys wind back (Jab and move's -0.5).
The trade: Push + Hold spends wind and saves legs (a pocket war). Steady + Move spends legs and saves wind (boxing).
Push + Press spends both: the all-in round. Steady + Hold is the bank. Four corners of a square with real fights in each
(a slugger lives in Push + Hold; an out-boxer in Steady + Move; round 3 when behind is Push + Press).

Is two better than one for play? Yes. One switch gives one question ("now?"). Two give a plan ("which tank do I spend
tonight, and on whom?"), and the opponent's style answers it differently: against a body puncher spend legs (Move), not
wind; against a mover spend wind, not legs (Hold the centre and make him come); against a fader spend his legs (Press)
early. That is the race screen: style burns tyres, engine burns fuel, and the pit stop gives back fuel but not tyres.
It costs one new resource in the rules (LEGS per side), but the code already reads footwork and guard off the tank; moving
that read onto legs is the smallest real change. Keep both controls set for free in the minute, so in-round it is still
one shout a change, never two fiddles.

## 4. "Next to the fighter"

The drawing's plates at the top corners are the right home for the controls and the readout: the camera moves and the
fighters swap sides, so a floating panel would chase them and cover the action. But he said NEXT to the fighter, and he
is right that the eye watches the fighters, not the corners. Best of both: the plates keep the controls; each fighter
also carries two thin rings ON THE CANVAS at his feet (outer wind, inner legs, in the plate's colours), like a race
car's tag on the track. They must never cover: heads, gloves, the torso where punches land, the referee, a knockdown or
the count, the clinch, the scoreboard clock. Rings at the feet cover none of those; hide them during a count. Colour the
plate's top edge in the corner's colour (red / blue) so the eye matches plate to fighter at once.

## 5. The corner minute as the pit stop

Right: the refill on the same bar up to the grey end and never past it. A real minute gives back: breath (most of it),
some sharpness, water, ice on the neck, Vaseline, cut work, a clear head, instructions. It never gives back: legs worn
(only a little), body damage, swelling, a cut, the chin's damage, a fighter's belief once broken.
What the player should plan there (the pit wall's real job): the next round's HANDS and FEET for free, read against the
cards ("1-1, last round"), the two readouts ("wind lasts with a minute spare; legs go at 1:30 if you press"), and the
opponent's tells ("mouth open, hands drop after the jab"). The map puts the minute's pace row in the second step; it is
the first. A real corner sets pace in the minute; the in-round shout is the exception.

## 6. The branches

True and first: Cardio training (roadwork and intervals train wind via Stamina; Recovery the minute's refill; ADD legs:
skipping, hills, sprints train LEGS); body shots greying the opponent's tank (split: wind now, legs later); the plan's
ROUND row (Hands and Feet per round, plus PlanPhase's if ahead / if behind for the last round: wire it); the after-fight
toll (a fight finished on empty legs costs more rest days than one on empty wind).
True, second: heart (lowers the cliff, a second wind once a fight when wind is under 35: a high heart gets +10 free,
not only the perk); trust (Low fighter ignores the mid-round change); short fuse (goes Push on his own after a big
shot); the opponent's own corner pushing (no war without it); judges' work for AMATEUR as well as pro; pro distance
(legs matter most over 6-10 rounds).
Missing: weight cut (a drained fighter: lower wind cap and slower refill, shown at the first bell); age (older fighters
refill slower, legs go earlier); the last-30 steal (round end weighs more); the "hard rounds" sparring drill is true
(fighters learn to work tired) and should lower the Push wind cost, as the map says, plus a legs version (ring-cutting
drills).
BJJ: the HUNT / hold on the gas tank is fine later; no-gi has its own "legs" (grip strength, forearms) worth the same
two-tank split then.

## 7. Words

- Jargon to drop: "wear", "grey end", "ghost", "hatched", "readout", "probe", "arm", "exchange" in player text. Say
  "gone for tonight" for the grey, "if you push" for the ghost.
- Count in time, not exchanges: "gassed at 1:00 of round 3", "a minute spare".
- "Tank" is good boxing talk; better to name the two: WIND and LEGS. "Push", "Press", "Move", "Hold", "Steady" are words
  a coach uses.
- "Tiring under 45: about 1 exchange" shows a raw threshold: say "breaking soon" and keep 45 in the hover.
- Pictures: a lung for wind, a leg for legs; the opponent's tells as small icons (open mouth, dropped hands) beside the
  words.

## 8. To reach 10/10 (most important first)

1. Add LEGS as the second resource per side (0-100, starts 100 less fight-week tiredness). Spent by FEET: Press x1.5,
   Move x1.0, Hold x0.7 of a base legs cost; body shots take a late share (half of today's BODY_COST goes to legs over the
   next round). Minute refill 10% of what was spent. Drive Duels.effective's guard, head movement and footwork fade from
   LEGS (cliff from 30), and keep hands and power on WIND.
2. Add the FEET control: Press / Hold / Move, with the effects in section 3 (Press: opponent's legs x1.2, +work, more
   counters taken against a counter-puncher; Hold: more punches both ways; Move: fewer taken, wins at range vs a presser).
   Keep HANDS as Push / Steady (Save gone, as the map says).
3. Set HANDS and FEET in the corner minute for free (first build, not second); any change mid-round is a SHOUT: it uses
   one of the two full shouts and passes through CornerTrust (a Low fighter ignores it). Kill the free toggle.
4. Fix the case table: case 6 becomes "Steady + Move, tie up inside"; case 9 becomes "win R1-2 at Steady going to the
   body, then Push + Press in R3". Add the missing cases (weight-drained, southpaw, last-30 steal, ropes, mirror war,
   round already lost, cuts, reach) as probe cells.
5. Give the last exchange of a round more weight for the judges (a close round goes to who won the last 30 seconds), and
   let Push and Press tip close AMATEUR rounds too (initiative), not only pro.
6. Give the opponent a corner that sets their HANDS and FEET by style and the score, shown on their plate as read from
   the ring, with tells as icons (mouth open, hands dropping, flat feet), never as exact numbers.
7. Readouts in clock time for both tanks: "Wind: to the bell, a minute spare" / "Legs: gone at 1:30 of round 3 if you
   press". Slope words: slowing from 65, gassed under 35.
8. Put two thin rings on the canvas at each fighter's feet (outer wind, inner legs), hidden during a count; plates keep
   the controls in corner colours. Nothing over heads, gloves, torsos, referee or clock.
9. Wire weight cut: a drained fighter starts with a lower wind cap (minus the kilos cut in the last week x 3) and refills
   at x0.8 in the minute; shown at the first bell.
10. Heart's second wind as an event: once a fight, under 35 wind, heart 70+, +10 wind and the line "second wind" on the
    plate.
11. Training links: Stamina and Recovery to wind (as today); a new LEGS line trained by skipping, hills and sprints; the
    hard-rounds sparring card lowers the Push wind cost; a ring-cutting drill lowers the Press legs cost.
12. The probe (PUSHPROBE1) gets a fourth arm D (two controls, two tanks) and passes only if no fixed Hands x Feet pair is
    best in more than 4 of the cells, and the style reader beats every fixed pair by 3 points.

## 9. The drawing

`docs/mockups/s442/pushtank_critic_b/ten.html` -> `ten.png`. Round 3 of 3, cards 1-1, round 2-2 with a minute left.
Our plate: HANDS Push / Steady, FEET Press / Hold / Move, WIND and LEGS bars each with the grey "gone for tonight" end,
the hatched cost of the next 30 seconds, the minute's refill beside each, two clock-time readouts. Their plate: the same
controls as read from the ring, both tanks as ranges, tells in words. Two rings at each fighter's feet with a hooked
label out of the body. Bottom bar: shouts left this round (a mid-round pace change is one of them, "STEP IT DOWN"), the
plan for this round as set in the minute.

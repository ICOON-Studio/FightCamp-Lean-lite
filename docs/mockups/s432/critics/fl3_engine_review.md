# FL3 engine critic: how the fighter's build, training, plan and corner decide the fight (FIGHT_LINK_MAP_S432 v3)

Critic: a fresh, blind designer of sports simulation games (the Out of the Park Baseball / Football Manager match engine school). I judge two things: do the
player's inputs really drive the outcome, and can the player learn from results. I read CRITIC_PACK, CRITIC_ACCESS, the whole map, its drawing
(fightlink_v2.png), the real result screen (21_result_real.png) and the code: BoutRules, Exchanges, Knockdowns, Attrs, Duels, LiveRound, RingDuel, BoutNight,
FightWhy, Data. Nothing was run. I did not read other critics' files.

## Score
**Depth as designed: 7 / 10.** The fight as built today: about 4.

One line: the map turns a fair engine into one where every part of the edge is stored, replayed and priced in one unit before and after the bell (rare, and
the right idea), but its two most painful results, the count and the stoppage, sit on a coarse model built outside the exchange stream, and the opponent's
corner never decides anything, so the player is learning to beat a script.

## What I checked in the code (it holds up)
- The map's trace is accurate. `BoutRules.stale_energy` returns 0 when `camp.protocol < 1` (line 165), and `night_edge` charges `NO_CAMP_EDGE -1.5` with an empty
  camp (line 200): on the amateur path a hard week costs nothing and every bout pays a flat tax. Real defect.
- `BoutRules.scorecards` builds the three cards from rounds won only, with a formula split for the third judge (line 244). The real result screen shows the
  side that won 10 of 18 exchanges and landed 61 to 56 losing 28-29, 28-29, 29-28. Real defect.
- `BoutRules.why` writes "The camp held up when it mattered" for any camp at protocol 2+, and credits the corner call for any won round with a call. The real
  result screen carries exactly that line. Canned. Real defect.
- `Data.START_MOVE_SHARE` sets Uppercut and Check hook to 0 for our fighter, while `AttrGen._attrs_build` lays every opponent punch at its rating. Real defect,
  and a hidden one: the pocket and inside start lost.
- `plan_swing` (LiveRound line 401) already replays the plan's edge on the same dice. The seeds per round and exchange make the replay idea sound.
- The edge `d` is a sum of named terms (duel, call, perks, habit, talk, set-up, pace and aim, The Read, plan). Storing each term is cheap and honest.

## What is strong
- One unit: exchanges for what happened, "in 100" only for real chances. This is what lets a player compare the pads with the corner. Most sports sims never
  manage it.
- The bill as the forecast of the receipt's own rows, with the result ticking against it. That is the prediction-then-outcome loop that teaches a player
  (OOTP's projections against the season, done per fight).
- The split at signing (what you made against what you signed) and the Monday snapshots of abilities AND mastery. It fixes `Sim._as_of` missing the pads.
- THE TARGET table (preparation 55-70, the night 20-30, luck 10-20 of every 100 exchanges turned), written before the probe, each with its knob. The right order.
- Every row ends in one button that IS the next decision. Nothing on the result is read-only.
- The towel: a real trade between tonight and the fighter's future, with the durability ceiling as the lasting price. It also fills the empty spot in the
  corner minute (until now durability was never a decision).

## What keeps it from 9-10
1. THE COUNT IS NOT IN THE EXCHANGE STREAM. `Knockdowns.round_counts` rolls once, after the round, from the round's margin band (close / clear / dominant).
   A knockdown therefore never happens in the exchange that caused it and never changes the rest of that round. The map's card says "the round and the
   exchange" and the drawing says "at 1:30": the code cannot know either. So the most painful result gets the least true receipt.
2. DAMAGE COMES FROM ROUND BANDS, NOT PUNCHES. Damage = 8 / 18 / 32 per lost round. "26 carried in: 11 from the open habit" can only move when removing a group
   flips a whole round's band, so the split will mostly read 0 or a whole band. Elbows in / Gloves high move where punches land but do not change this damage.
3. THE OPPONENT'S CORNER NEVER DECIDES. `Exchanges.next_mode` walks a style script, biased by where the opponent wins. No shout, no corner change, no towel.
   So "your night" is a free bonus no opponent ever has, and a plan that beats a style once beats it every time. The map leaves "opponents who adapt" for
   later. For this engine it is the depth, not a garnish.
4. THE LUCK KNOB IS ON THE WRONG TERM. The luck a player feels is the 18 exchange dice: with a near-even edge the exchanges won miss their expected count by
   about 1.7 exchanges on average per bout, while a 5-point build gap is worth only about 1.3 exchanges. FORM_SD is the small term. If LUCK reads over 20 in
   the target, the knob must be EX_SPREAD (66 to about 58) or more, shorter exchanges, not FORM_SD 3 -> 2.
5. THE CORNER EDGE IS ALREADY KNOWN TO BE TOO BIG. The map's own trace: a right call (+12 to +14) is two to three times a 5-point build gap on every exchange it
   fits. Waiting for LEVERS1 to say so is a slow way to an answer already in the table: cut the direction now (best 17 to 12), let the probe set the size.
6. ONE BOUT IS NOISY, AND THE ROWS DO NOT SAY SO. 18 exchanges per bout: a row of "-2" can be noise. Without a "normal luck" band beside each row the player
   learns lessons from dice. The season line ("who decides this fighter's fights") helps, but the row is where the eye goes.
7. THE TRUE REPLAY REPLAYS SHOUTS AT FIXED EXCHANGE NUMBERS. Remove YOUR WORK and the opponent's modes move (they read energy and hurt), so the replayed shouts
   land on the wrong clues and the re-run blames the night for the work.
8. NO BOX SCORE. Punches landed / thrown per punch, per place, against which answer: the simplest bridge from the pad card to the night. FightStats exists;
   the map does not use it.
9. SCOPE. Fourteen mechanics and twenty probes before any screen shows a size. Honest, but the map does not say which mechanics ship if half the probes fail.
10. BJJ (the fourth fighter) gets one paragraph: no rows, no buttons, no golden-path line.

## To reach 10/10 (most important first, each buildable)
1. Put the count inside the exchange stream. In `RingDuel` (the hurt roll near line 342), let a hurt exchange roll a count from power v chin and damage
   carried; a count sets `her_hurt` / `opp_hurt` for the next one or two exchanges and costs tank. Retire the after-the-round roll in `BoutNight._counts`
   (keep its seed rule per exchange). THE COUNT card then names the exchange, the punch and the habit truthfully. Probe: counts per bout and stoppage rates
   within 10% of today's on 600 bouts.
2. Damage from landed punches. Each landed head exchange adds damage by power v chin and margin (body share by Elbows in / Gloves high); round bands go. The
   "carried in" split then moves per exchange and DAMAGE1 can pass.
3. The opponent's corner on the same rules. One corner change a minute from the same menu (one WHERE step, pace, a fix), its own towel line, a coach
   rating; the agreed "adapted" note (R25) is its readout. On the result: a "their corner's change" row and their decisions beside yours. In the Playbook: a
   line type "if they switch to the pocket". Probe: a plan written for round 1 loses some edge by round 3 against a good corner, and an "if they switch"
   line wins it back by 1.5 in 100 or more.
4. Move the luck knob to the exchange dice: over 20, EX_SPREAD 66 to 58 or 27 shorter exchanges a bout; FORM_SD only for the form part. Cut the corner's best
   call 17 to 12 now; LEVERS1 sets the final size.
5. A normal-luck band on every row (from LEVERS1's season spread for that row in that matchup); a row inside its band prints grey with "inside normal luck".
6. A punch-by-punch box on the result and in History: landed / thrown per punch, the place, the answer it met, and the pad card that moves it.
7. In the true replay, replay the player's policy, not the shout times: for each clue, the shout this player gave to that clue in this bout (else Coach's
   pick). Then removing a group does not punish another.
8. Name the core that ships whatever the probes say: the defects, the scales, the judges, the count and the towel, the three places, the punch rule. Officials'
   known leans, the corner's card and readiness ship only if their probes pass; say so on the map.
9. Ship NOCAMP1 with a stand-in Legs (week tiredness only) now, without waiting for CLUBWEEK, so the amateur path stops paying the flat tax this week.
10. Check the amateur count rule with John: under the amateur 10-point must, a standing count is a strong factor for the judges, not an automatic 10-8. Keep
    10-8 for professionals; for amateurs make the count weigh heavily on the round (a set bonus) rather than fixed.
11. BJJ: list the mat receipt's rows (belt gap, your weeks, your calls, the referee, luck), their buttons, and one golden-path assertion, as for boxing.

## Complete for this version?
With the list applied: yes. Four fighters from the first amateur offer to the first professional fight are covered: the amateur path (no camp, the Legs,
amateur panels), the professional debut (pro panels, NO_CAMP for pros, the towel), and the grappler through the mat receipt once item 11 is written. Nothing
else is needed for this version; named judges and longer professional fights can wait for the small world.

## My 10/10, drawn
`docs/mockups/s432/critics/fl3_engine_10.html` / `.png`: the result of a bout lost on a count, where the count sits on its exchange in the bout strip (gold
tile, then two hurt tiles), the damage is counted from head shots landed, both corners' decisions are shown side by side with the opponent's switch as its
own row, each row carries the bill and a normal-luck band, a punch-by-punch box links the lead hook to its pad card, and the season line says who decides
this fighter's fights.

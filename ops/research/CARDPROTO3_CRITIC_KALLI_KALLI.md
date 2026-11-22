# CARDPROTO3_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ290)

Brief: research/CARDPROTO3_CRITIC_KALLI.md
Sent: 2026-11-22 15:35 | collected: 2026-11-22 16:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring card game round 3 now, as a fresh critic.

**DEPTH 5, PLAY 5, GENERAL 6. It still fails the 8/8 bar.** It's a better prototype than round 2: pressure now has a ladder, dead exchanges are down to 8.3 %, there are no draws, and style pairs sit inside 43.5 to 53.1 %. But the decision you make every exchange is worth nothing, and the lines still don't read like boxing.

**The single most wrong thing: Predict is worth exactly zero.** It's used on 31.2 % of exchanges, it costs 2 wind and it's right 35.7 % of the time. The predictor arm scores 50.0 %, the same as the engine. So the headline choice every exchange, React or Predict, is a coin with a wind tax. A careful player learns to always press React, and then half the fight's decision is gone.

**DEPTH 5**
- **The chip does nearly all the work, and the film adds almost nothing.** Following the chip alone wins 59.0 %. Reading film, chip and wind together wins 61.3 %. That's +2.3 points for all the film work, so the scouting part of the game barely pays.
- **A read is right 35.7 % of the time, and 37.4 % when film and chip agree.** Agreement is meant to be the moment you commit, and it buys 1.7 points.
- **Three cards are dead or traps.** Catch breath: 1.3 % of plays, −7.09 a play, 40.8 % bout win. Feint: 1.5 %, −2.25. Pivot out: 1.5 % in the card table but 0.7 % in "how bouts end", and those two numbers can't both be true. Round 2's dominant card was overcorrected into a dead one.
- **Combinations aren't measured.** Up to three cards can go out together, and nothing tells us how often bots do it or whether it wins. The transcripts show single cards only.
- **Two style pairs never meet.** Counter against out-boxer shows 0 bouts both ways, and all four mirror pairs are "no legal pairing". So 10 of 16 match-ups are tested. Same-style bouts are common in real boxing.
- **In its favour:** the ropes ladder, the honest film odds and the camp edge (+8.5 points) are real.

**PLAY 5**
- **All the danger arrives in round 3.** Of 217 stoppages, 205 come in round 3, 11 in round 2 and 1 in round 1. The first two rounds carry no fear, and that's two-thirds of the bout.
- **Knockdowns don't change anything.** The boxer gets up and the next card plays the same way. No hurt state, no survive choice and no closing the show.
- **A random hand still wins 36.9 %.** That's fine for surprise, but the skilled ceiling is only about 61 %.

**GENERAL 6.** The tests and harness are honest, there are no draws in an amateur bout, five judges is right for amateurs, opponents come from other clubs, and every file is under 500 lines. Points off for the lines below and the dead cards.

**Do the lines read sensibly? No.**
- **"Man" in every generic line.** "Neither man gives ground" and "neither man commits" appear even in bout 3, between two women. The README also says "a man standing still". Both break the no-fixed-he rule the README claims to follow.
- **Defence and footwork "land".** "The opponent's step back beats your boxer's cross; the shorter answer lands first." "The opponent's block beats your boxer's cross; the shorter answer lands first." "The opponent's feint beats your boxer's cut off the ring; the shorter answer lands first." The README says these cards deal no damage, so the default reason line is wrong for every non-punch win.
- **Defence and footwork "trade".** "Your boxer's jab and the opponent's roll trade." "Your boxer's cut off the ring and the opponent's lead hook trade." A trade means both land, and a roll or a cut-off can't land.
- **A trade then a knockdown.** "Your boxer's uppercut and the opponent's uppercut trade; neither man gives ground — the opponent is down!" contradicts itself.
- **Named reasons read well:** "Uppercut counters Slip — slipping into it", "Pull counter beats Cross at range", "Roll counters Body hook". The problem is only the fallback lines.

## (1) Missing cards and options
1. **A hurt state after a knockdown**, with a survive card: hold, cover up or take a knee. Your corner then chooses to survive or keep throwing.
2. **A second way off the ropes.** Today only Pivot out gets off. Real boxers clinch or spin out off the ropes, so Clinch should be legal there too.
3. **Named combinations from the main game's combinations book** (1-2, 1-2-3, 3b-3), drilled in camp, so the camp-to-fight link matches FightCamp's own Playbook.
4. **A broad-family Predict**: call attack, defence or movement, not one of 10 shapes.
5. **Film habits with triggers** ("after the jab lands, the cross comes back 7 in 10"), so the film says something the chip can't.
6. **Mirror and counter against out-boxer pairings.**

## (2) Useless or dominated
- **Predict, as built:** the arm equals the engine at 50.0 %.
- **Catch breath:** −7.09 a play. A jab beats it, so it's punished by everything, not only body shots as the README says.
- **Feint:** it wins nothing and only cancels.
- **Pivot out:** it's only needed on the ropes, and the ropes are rare.
- **The film's second habit:** it's worth about +2 points over the chip.

## (3) What each change would do
| Change | What it does |
|---|---|
| A broad-family Predict | the right rate goes up to about 50–60 %, so committing becomes a real bet |
| Trigger habits on film | reading pulls away from following the chip, so scouting matters |
| A hurt state and a survive card | fear in rounds 1–2 and a corner decision after a knockdown |
| Earlier stoppage chances | every round has stakes, not only the last |
| Repairing Catch breath, Feint and Pivot out | 17 live cards instead of 14 |
| All 16 style pairs | balance is proven where it isn't today |
| Fixed lines | the transcript reads like a fight, and the rules teach themselves |

## (4) TO REACH 10/10, most important first (numbers are targets for the next harness run)

1. **Make Predict a real bet.**
   - Predict calls one of three families: ATTACK (straight, looping, uppercut), DEFENCE (evade, guard, hold) or MOVE (escape, close, feint, rest).
   - Cost drops to 1 wind.
   - A right call keeps today's reward: clean win plus the card's effect. A wrong call keeps today's price.
   - Harness gates: predictor arm 55 %+; predicting when film and chip agree beats reacting by 5+ points; predicting when they disagree loses to reacting. Predict share stays at 20–35 %.
2. **Make the film beat the chip.**
   - Every habit gets a trigger and a follow-up: "after your boxer's jab lands, throws Cross 70 %", or "after a lost exchange, clinches 60 %".
   - The chip stays a shape guess.
   - Gate: reading beats the chip-follower by 5+ points (today 2.3), and a bout with both habits known beats a bout with none by 5+.
3. **Rewrite the line templates by card kind.**
   - Punch beats punch: "lands first".
   - Defence wins: "slips it — no damage, an opening".
   - Block wins: "takes it on the gloves".
   - Movement wins: "steps out — the cross falls short".
   - Feint wins: "draws the cut-off and is gone".
   - A "trade" only between two punches. A punch against movement that the table calls t reads "both miss".
   - A trade with a knockdown reads "they trade — the opponent goes down".
   - "Man" becomes "boxer" everywhere.
   - Test: every printed line checked against both cards' kinds, and no "man" in any string.
4. **Add a hurt state.**
   - A knockdown, or head damage over 70 % of the limit, makes the boxer HURT for 2 exchanges: punches 20 % softer, takes 20 % more.
   - Add the card "Survive" (hold and cover): it beats looping and uppercut, loses to straight. It's only in hand while hurt.
   - The next corner minute offers "Stand and fight / Buy time".
   - Gate: stoppages by round at least 10 % in round 1 and 30 % in round 2, total 10–20 %.
5. **Repair the dead cards.**
   - Catch breath: +6 wind. It loses only to Body hook, Uppercut and Cut off, and does nothing against straights at out range.
   - Feint: a win sets an opening, like Slip, at +15 accuracy.
   - Pivot out: a win clears the trap and the ropes, and costs the cutter 2 wind.
   - Gate: every card 3 %+ of plays, net per play no worse than −3.
6. **Measure combinations.** Report the share of 2- and 3-card exchanges, their win rate, and a combination-priority arm. A combination of three should never be the one-card-style answer: the arm stays at 45 % or under.
7. **Play all 16 style pairs,** mirrors and counter against out-boxer, each at 42–58 %.
8. **Fix the reporting contradiction.** Pivot out is 1.5 % in the card table and 0.7 % in "how bouts end". Print one number from one source.
9. **Fix the README and the brief.** The README says five judges and the brief says three. Amateur bouts use five, so the brief should say five.
10. **Bridge to the main game.** Camp drills add the main game's named combinations (1-2, 1-2-3, 3b-3) as combination cards, so what you learn here is what the gym teaches.

Round 3 scores DEPTH 5, PLAY 5 and GENERAL 6, so it still misses the 8/8 bar.

The single most wrong thing is that Predict is worth nothing. A bot that predicts wins exactly 50 %, the same as the plain engine, because it's only right 35.7 % of the time.

The other big problems:
- The film adds just 2.3 points over following the chip.
- Catch breath, Feint and Pivot out are effectively dead cards.
- 205 of 217 stoppages happen in round 3.
- The lines still say "man", and they have defence "landing" and "trading".

The fixes that matter most:
- Make Predict call one of three families (attack, defence or move) for 1 wind.
- Put triggers on film habits so scouting tells you something the chip can't.
- Rewrite the lines by card kind.
- Add a hurt state after a knockdown, with a Survive card.

# DESIGN_GUARDDMG1_V6_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ273)

Brief: research/DESIGN_GUARDDMG1_V6_CRITIC_KALLI.md
Sent: 2026-11-21 15:10 | collected: 2026-11-21 15:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring GUARDDMG1 v6 now. I'm starting with the new Hands sum and checking whether any setting wins everything.

# GUARDDMG1 v6: critic score (S459, fresh critic, 2026-11-21)

**Depth 6 · General design 6 · Play 6.** v6 fixes the right thing: the guard now feeds the exchange before it is settled. It still misses the bar on both Depth and General design, because the new rules contradict each other in four places.

## Depth: 6 / 10
**What works**
- **The method fix is real.** Hands adds points to `d` before `Exchanges.settle`. I checked the map's sizes against two ±33 dice and they hold: +3 is about 4 exchanges in 100, +8 about 11, +17 about 22. Covering can now lose a round, which v5 could never do.
- **The section 1 audit corrects my v5 finding, and the correction is right.** "Hands up" already moved the winner, but only against a loader, and it was a free cover in the other five games. v6 puts a price on it.
- **The rope trade is the best idea in the map.** High drains a presser, the opponent turns Tiring under 45, and then the player has to switch to Loose. Real boxing backs it: Ali covered on the ropes against Foreman in 1974 and only turned it around in the 8th. That's also why the map's "3 rounds too short, 6 rounds enough" split is honest.
- **The week feeds it.** Defence and head movement grade High, and Stamina and hand speed grade Loose.

**Why it stops at 6**
1. **With the clue on screen, the table is a lookup, not a trade-off.** The setting counts from the next exchange, and the opponent's game is shown as a clue. Each row in 2.2 has one best answer: Loose wins 4 rows, High 3 and Normal 1. Nothing is risked by switching every 30 seconds, so the right move is to match the clue each time. That's a chore, not a choice.
2. **It pays twice for the same read.** The rows where High wins (loads up, your boxer in trouble) are the rows where "Hands up" is already the best call. The rows where Loose wins (tiring, hurt) are where "Let your hands go" already wins. The shout stacks on top: +17 plus +6 against a loader. A player who reads the clue right gets paid twice, and no new decision appears.
3. **The referee's look kills the rope before it pays.** Point 2 says a boxer who covers against a heavy hitter "is stopped around the end of round 2 or in round 3, amateur or pro". Section 2.4 says the drain needs more than 3 rounds to bring a fresh presser under 45. So ROPE stops your boxer before the switch can come. Bar 4 of the probe fails by design, and the heavy-presser row of table 4 has no live High.
4. **"Through the guard" works against itself.** Blocks come from misses, and misses are counted from landed (thrown = landed / 0.33). Landing 1 fewer means about 2 fewer misses and about 1.2 fewer blocks (DERIVED). At 4 landed, opponent blocks go from 4.9 to 3.6, so x1.5 wear gives only about 12% more wear. At 2 landed it gives *less* wear than no aim at all. The aim meant to break a guard hardly touches it.
5. **High barely protects, depending on an order the map never states.** The map doesn't say whether thrown is counted before or after High turns 1 in 3 landed into blocks.
   - If after: High saves about 0.75 of a clean punch an exchange at a full guard.
   - If before: the extra 0.15 of misses blocked adds back most of the leak (about 35% a block at a full guard, doubling as it empties). The saving falls to about 0.1, and turns into a loss once the guard is worn.

   All of this is DERIVED, and it treats a leaked punch as a share of a clean one. Either way the only reliable protection is the x0.7 hurt chance.

## General design: 6 / 10
**What works**
- The section 1 audit is the best yet. It traces every term of `d`, every guard rule after settle, the dead `in_round` branch and the unused `moving` and `posture` arguments.
- The CODE, DERIVED, ESTIMATE, V5 and CUT tags are honest, and the files opened are listed.
- The probe is designed well. It uses several boxers, four opponent types and three formats, and includes a mutant arm that must fail.
- Hands is separated clearly from posture, and "Gloves high" is renamed "Protect the head".

**What it loses points on**
1. **"Normal is 0 everywhere: today's game" is false.** The worn edge (2.3), the Defence block share, the power factor, the look and its new stop all apply at Normal. Bar 1 compares Normal with a CONTROL that switches off `HandsEdge`, but it doesn't say what else that switch turns off.
2. **The Defence link runs backwards.** A miss that isn't blocked costs nothing. A block costs wear and leaks damage. "0.50 + Defence / 500" turns more misses into blocks, so a better defender takes *more* guard wear and *more* leaked damage.
3. **Two block shares.** High sets it to "0.75" and Defence sets it to "0.50 + Defence / 500". Which one wins, or do they add?
4. **Two rules for one exchange.** "If the round's plan call is one of the two, it holds all round." What happens when the player has set Hands to the opposite?
5. **No order between situations.** Your boxer can be tired while the opponent loads up. Which row of 2.2 applies?
6. **Loose has no energy price.** It overlaps Push: both mean "throw more", and Loose + Push against a tiring boxer is +12, with the tank paying only for Push. Pace and Hands need one sentence each on what they own.
7. **Scope.** Around 17 rules ride in. Several of them change no pick:
   - moving −5% wear;
   - 5 off the opponent's refill per 3 body shots;
   - Tie up +13 or +16 against +10;
   - "covered and landed 0-1", which is nearly always the same exchange as "lost 6-1".
8. **Kit and words.** "The chosen one gold" on the corner bar puts gold on a bar where Pace and Aim also show a chosen state. Use gold for one thing only (the coach's pick, see the page). "Loose" means relaxed in a gym ("stay loose"), so check it against the glossary. "Low" is the plain word for hands down.

## Play: 6 / 10
- Fight night gets a lever with a payoff the player can see. The Why line "Hands High cost 3 exchanges; 14 on the guard, 4 got through" and the rope switch on a tiring presser are good moments.
- Played every 30 seconds it becomes a fourth dial to adjust after the shout, Pace and Aim. That pulls against the agreed "dark and tight, three fixes, time for two".
- Between bouts it gives the week a reason. Defence and head movement show up as "High guard: OK", which is a good line on the Training tab.
- The opponent never covers, so the guard is only ever your boxer's problem. Nothing rewards breaking a shell: pros like Arthur Abraham lost on the cards to boxers who worked around a high guard, and that is a fight the game can't stage yet.

## Options: what each changes, what's missing, what's useless (S403)

### What each option changes (as v6 writes it)
| Option | Changes | Verdict |
|---|---|---|
| Hands High | −8 to +6 points by the opponent's game; 1 in 3 opponent landed becomes a block; your landed x0.75; block share 0.75; +8% wear; hurt chance x0.7; drains a presser 1 an exchange | Keep. It protects less than it says (Depth 5) |
| Hands Normal | 0 points | Keep. It isn't today's game (General 1) |
| Hands Loose | −10 to +6 points; +1 landed for whoever wins; block share 0.45; hurt chance x1.3; +2 head damage | Keep, but give it an energy price and rename it Low |
| Shout "Hands up" | High for 30 s, on top of its +17 against a loader | Shouldn't stack (Depth 2) |
| Shout "Let your hands go" | Loose for 30 s, on top of its own call edge | Same |
| Plan round row: Hands | Opens the round on a setting, rated Beats it / Works / Walks into it | Keep: the best place for the decision |
| Corner minute: coach's Hands pick | The pick for the next round, with its reason from the last three exchanges | Keep |
| Aim "Through the guard" (pro) | Opponent's wear x1.5, 1 fewer clean, −1.5 | Self-defeating as written (Depth 4) |
| Tie up | Halves the exchange's leak; +10 guard, +13 at Sharp | Keep the half-leak. The +13 and +16 change nothing |
| ONE CHANGE: Protect the head / Protect the body | Head against body for one round | Keep, renamed |
| Worn edge (−2 / −4, both sides) | Rounds cost a worn guard | Keep: the reason High can't be held all night |
| Referee's look | Fills to an "outclassed" stop; scales the stop chance after a count | Keep as one gauge, but retune it (Depth 3) |

### Missing
1. **A commitment.** Make Hands a bet on the next round, not a reaction to the clue, so switching costs something.
2. **An energy price on Loose,** so Pace keeps the tank and Hands keeps the read.
3. **The opponent covering.** For example, the opponent shells when hurt, as a scouted habit. Then "Through the guard", body work and the tape have something to break.
4. **A rule for which situation comes first** when your boxer is in trouble and the opponent is loading up.
5. **A probe bar for the week link:** proof that High pays more for a good defender than a poor one.

### Useless or near-useless
- The Defence block share as written (backwards).
- High's 0.75 block share of misses: pure cost, unless the order is fixed so the cost is meant.
- "Jab and move" passing −5% wear.
- Body shots taking 5 off the opponent's refill per 3.
- Tie up +13 at Sharp and +16 at Signature.
- The look's "covered and landed 0-1" feeder, which duplicates "lost 6-1".
- Gold on the chosen Hands tile.

## To reach 10/10 (most important first; sizes are ESTIMATES for the probe)

1. **Make Hands a bet for the round.**
   - Set it in the plan's round row and at the corner minute. It holds for the whole round.
   - In the round it changes only through the two shouts, for 30 seconds each, and each uses one of the two instructions a minute that get through fully.
   - The player then backs a forecast against the opponent switching games, and a correction during the round costs a shout.
   - The probe's READ arm may use only what the corner minute shows.
2. **Stop the double pay.** When the shout is "Hands up" or "Let your hands go", that exchange takes the bigger of the call edge and the Hands points, not both. Then +17 against a loader stays +17, not +23.
3. **Tie the referee's look to a worn guard, so the rope can pay.** Heavy blocks fill the look only once your boxer's guard is under half (+1 for every 4 power or heavy punches blocked). Covering on a fresh guard is safe. Holding High through a worn guard gets your boxer stopped. The skill becomes timing the switch, and bar 4 can pass.
4. **Turn the Defence link around.** Leave the block share at 0.60. Defence cuts the leak instead: transmission x (1.25 − Defence / 200), so Defence 30 = x1.10, 50 = x1.00 and 80 = x0.85. Show it on the Training tab as "Defence 58: 4 in 100 less through the guard".
5. **Make High's protection one clear rule.** Cut the 0.75 block share. Thrown is counted from settle's landed *before* High turns 1 in 3 landed into blocks, so High saves about two-thirds of a clean punch an exchange on a full guard, falling to about a third on an empty one (DERIVED). Its prices stay the exchange points and +8% wear. That makes "High in bursts" fall out of the numbers.
6. **Give Loose an energy price.** Make it 1 energy an exchange, half of Push or as the probe sets. Write one line each: Pace owns the tank over rounds; Hands owns the answer to the opponent's game.
7. **Make "Through the guard" hit the guard.**
   - The landed punch your boxer gives up turns into 3 blocks on the opponent's guard, and all its blocks wear x1.5.
   - DERIVED: at 4 landed, opponent blocks go from 4.9 to about 8.6 after the x1.5, so the guard falls about a round sooner.
   - Show the round the opponent's guard is forecast to reach WORN.
8. **Let the opponent cover.** In the Hurt game the opponent goes High: its landed −1, and 1 of your clean punches becomes a block. Put "shells when hurt" on the opponent's file as a guard habit (the file already holds three). Then Aim Body, "Through the guard" and the tape each have something to beat.
9. **Say what Normal is.** Use one switch per rule (the Hands table, worn, the Defence leak, the look) and apply bar 1 to each. Delete "Normal ... today's game" unless every other switch is off.
10. **Write the order between situations.** Your boxer hurt, then your boxer tired, then the opponent's game. The Hands hover names the row in use.
11. **Cut the small rules** (moving −5%, body −5 refill, Tie up +13/+16, the "covered and landed 0-1" feeder), or show each one moves a probe number by 1+ win in 100.
12. **Fix the words and the kit.** "Loose" becomes "Low" after a glossary check. The chosen tile is slate with a mark, and gold goes on the coach's pick only. Keep "Protect the head / body". England Boxing 10.3.2 stays CHECK.
13. **Two more probe bars.**
    - The best defender of the three gains at least 3 wins in 100 more from READ than the worst.
    - With the look on, amateur stoppages stay inside 5-12 in 100 for every arm, not only Normal.

Nothing above needs a new system. Each one changes a number or a call site the map already names.

## The 10/10 page at 1920×1080: the corner minute, round 2 of 6 (pro)
It's fight night, so it's dark and tight, with the coach's notes in Kalam and the numbers in IBM Plex Mono, nothing under 12 px. There's one figure on screen: your boxer on the stool, head to feet, as a silhouette. Gold sits only on the coach's Hands pick. No green. All figures are **example data**.

- **Header** (0–90 px): "ROUND 2 OF 6 · CORNER" with both names, the only names on the page. At the right is a 60-second ring timer.
- **Left third:** your boxer on the stool. Under the figure are the guard arc at 41% with "WORN: −2 an exchange", energy 58, and the referee's gauge at 4 of 10 with pips for 1 of 3 counts. Hover on the gauge: "Fills from heavy blocks only while the guard is under half."
- **Centre, the corner card** (handwritten):
  - "Pressed in 4 of the last 6. Hands came back slow at the bell."
  - The opponent's energy bar at 49, with a line at 45 marked "turns Tiring below here".
  - The drain line: "Your boxer's High took 6 off the opponent last round."
- **HANDS FOR ROUND 3:** three tiles, each showing its points against pressing and against tiring, and what the round costs or buys.
  - Up: "−3 now · drains 6 · guard x1.08 wear".
  - Normal: "0".
  - Low: "+2 now, +6 once it tires · 1 energy an exchange".
  - The coach's pick (Low, gold) reads "It tires inside this round: open up".
  - Under the tiles: "In the round, 'Hands up' or 'Let your hands go' changes it for 30 seconds, using one of two instructions."
- **Right third:** RECOVER (3 points: water, ice on the ribs, clear the head), TALK, ONE CHANGE (Protect the head / Protect the body / a habit fix), and the tie-up line "A tie-up buys 10 back on the guard". The buttons are slate.
- **Foot strip:** last round's line in the result's own form: "Lost 4-3 · 2 on the guard · High cost 1 exchange". Hover on it shows the guard round by round.
- **Motion:** pressing a Hands tile tweens its points into the corner card's forecast line ("Round 3 forecast: about 55 in 100 exchanges"). Nothing opens by itself.

GUARDDMG1 v6 scores Depth 6, General design 6 and Play 6, so it misses the 7+ bar on both.

Putting the guard into the exchange before it's settled was the right fix. Five problems still hold it back:
- With the clue on screen, Hands is a 30-second lookup.
- It pays twice for the same read the shouts already reward.
- The referee's look stops a covering boxer before the rope-a-dope switch can pay.
- "Through the guard" barely wears the guard, because blocks are counted from punches landed.
- The Defence link runs backwards: more blocks means more leaked damage.

The fixes that matter most:
- Make Hands a bet for the whole round.
- Take the bigger of the shout and Hands, not both.
- Let the look fill only once the guard is worn.
- Make Defence cut the leak instead of adding blocks.

The score rests only on the critic pack and the map. I couldn't open `CRITIC_ACCESS.md` or any code because I can't reach the repo from here.

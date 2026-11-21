# DESIGN_GUARDDMG1_V5_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ270)

Brief: research/DESIGN_GUARDDMG1_V5_CRITIC_KALLI.md
Sent: 2026-11-21 12:13 | collected: 2026-11-21 12:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring GUARDDMG1 v5 now. I'll send the scores and reasons first, then the options review, To reach 10/10, and the 10/10 page.

# GUARDDMG1 v5: critic score (S459, fresh critic, 2026-11-21)

**Depth 6 · General design 7 · Play 5.** It clears the bar on General design but not on Depth, so the mechanic isn't designed yet.

## Depth: 6 / 10
**What works**
- Section 3.4 is the first real menu of choices. Five calls each have a state where they're wrong.
- "Go to the body" taking 5 off the opponent's next corner refill is a good trade with a delay. It matches the old rule of thumb "kill the body and the head will fall".
- The opponent's power entering the leak (3.5) and the tape habit "goes to the arms when ahead" give scouting a reason to touch the guard.

**Why it stops at 6**
1. **In the amateur game, covering wins on its own.** The map says covering is wrong against heavy hands, and its own numbers don't support that. The amateur guard never breaks (3.1). The power factor moves the leak by at most ×1.14 (3.5). The map itself sizes the leak at 7–11% of a bout's damage. So a heavy hitter adds about one point of a bout's damage, while covering takes one clean punch off the landed count every exchange (DERIVED from the map's figures). For an amateur, covering cuts damage against every opponent, and its only costs are the 30% output cut and the referee's look. The whole first part of a career is amateur, so the trade-off is missing from most of the game.
2. **Every v5 rule acts after the exchange is settled.** The covering cut, the counter, BROKEN and the extra landed punch from "Jab and move" all change `s["landed"]` after `settle` has already picked the winner. Who wins the exchange, and so the cards, doesn't move. The map says this on purpose ("the round is still the exchanges"). The result is that the guard only changes knockdown odds and the referee's look, never who wins on points. Real judges score clean punches and effective aggression, so a shell that throws nothing loses rounds. Here, covering costs damage dealt but not rounds won.
3. **The most famous guard trade in boxing can't happen.** Ali covering on the ropes in Kinshasa in 1974 worked because Foreman spent himself punching the guard. v5 turns down any cost to the puncher (point 4), so covering against a tiring heavy hitter can never be right. That was the trade with the most depth on offer.
4. **The week doesn't feed it.** The only training lever is shoulder endurance, from Stamina and Strength. Defence, Timing, the Tie up and Roll out steps (which already have mastery bars), neck work, and the existing habit "drops the right after the jab" all leave the guard alone. Nothing a player does on Tuesday changes Saturday's guard, apart from two stats that are trained for other reasons anyway.
5. **The player can't choose a guard plan.** The game plan's defence answers are steps, so there is no "When the opponent loads up → cover" line, and the Why never grades the guard.

## General design: 7 / 10
**What works**
- The code audit is the best part of the map. Section 1.6 finds three lines on screen that the code doesn't back, and each one is cited down to the line.
- Every number is tagged, and every rule names the number it changes.
- John's 11 points each get a verdict with a reason.
- Amateur and pro stay apart.
- Nothing new is drawn by the 3D fight, and names stay in headers.

**What it loses points on**
1. **The map contradicts itself.** Section 3.2 says "while the call holds", but section 4 turns down "it lasts until the bell" and correctly says a shout changes the next 30 seconds (`FULL_SHOUTS` is 2). It never says whether covering lasts one exchange, the round, or until the next shout.
2. **The numbers break the game's own exchange counts.** Exchanges land 4-3, 5-2 or 6-1. Cover them and an opponent's 4-3 win can show 3-3, or 3-2 with the counter. The map doesn't say whether the winner from `settle` stands and how the figures read. "30% fewer" on a count of 1–6 needs a rounding rule.
3. **The look prices contain a duplicate and a missing system.**
   - "Let your hands go: −1 for each exchange won" repeats the base rule in 3.3 (−1 per exchange won), so it isn't a price of the call.
   - "Tie up: +2 on a warning, 1 in 8" needs referee warnings, and the game has none.
4. **There are two ways for the referee to stop it.** The look gauge stops the fight at 10, `REF_STOP` already stops it after counts, and amateurs already stop at 3 counts in a round or 4 in a bout. The map doesn't show how the player sees all three on one gauge.
5. **It misses the guard choice the game already has.** The corner minute's ONE CHANGE already offers "Gloves high" and "Elbows in", and `posture_damage` sits unused. v5 turns down wiring them because they'd be "a second cover choice", but they're the natural home for a guard choice that lasts the round.
6. **A caption the player can't answer.** "The hands are coming down – over the top!" names no button. Under the pack's rule that only actionable information is shown, it has to point at a call or an Aim, or be cut.
7. The England Boxing 10.3.2 "outclassed" source is John's, not checked here. Mark it CHECK.

## Play: 5 / 10
- In the amateur game the guard rarely matters: round 3 in yellow, red rare, and never broken. The early hours barely show it.
- Fight night gets sharper: a cracked bar, a referee's gauge, priced tiles, a count chance. Those moments are good, but they only last one evening.
- Nothing carries over between fights: no guard line in the Why, no training card, no plan line, and no "next opponent has heavy hands" on Fight prep. There's no reason to come back to it.
- The reward is mostly avoiding something bad (fewer knockdowns). A guard trade that wins a round, or a tired opponent caught after covering, is what would make it felt.

## Options: what each changes, what's missing, what's useless (S403)

### What each option changes
| Option | Changes (as v5 writes it) | Verdict |
|---|---|---|
| Hands up, move your head (cover) | The opponent lands 1 fewer (it is blocked instead); your boxer lands 30% fewer; a counter chance off blocked power punches; the look +1 when your boxer lands 0–1 | Keep the idea; fix the timing. It acts after settle and leaves the cards alone (Depth 2) |
| Tie up | +10 guard once a round under half; halves this exchange's leak; 2 energy back | Keep. It should grow with the Tie up step's mastery |
| Jab and move | Half the blocks become misses; on the ropes or under 35 energy the opponent lands 1 more | The miss part only changes wear, which nobody sees. The wrong state is good |
| Let your hands go | Costs 3 energy; the look −1 per exchange won | No guard line of its own (the −1 is the base rule). Give it one, or say "no guard effect" |
| Go to the body | Every 3 body shots landed take 5 off the opponent's next refill | Keep: the best new idea. Say whether Aim Body also counts |
| BROKEN (pro) | 1 block in 3 lands at full worth | Keep. It doesn't move who wins the exchange |
| Opponent power ×(0.7 + power/180) | Leak and wear scale with power | Too small to change any choice (×0.92 to ×1.14) |
| "Goes to the arms when ahead" (opponent, pro) | 1 landed punch an exchange goes to the guard | Keep. The player can't do the same thing |
| Referee's look 0–10 | A stop at 10 | Keep. Merge it with REF_STOP and amateur RSC on one gauge |
| Count chance "about 1 in N" | Read from `Knockdowns` | Keep: honest and actionable |

### Missing
1. **A guard setting that holds** beside Pace and Aim (High / Normal / Loose), or the corner minute's "Gloves high" wired through `posture_damage`. A shout is too short for a guard plan.
2. **A cost to the opponent for punching a covered guard**, on the existing Pace energy (Push into a high guard costs +1 an exchange). That makes the 1974 trade possible without a second energy model.
3. **"Through the guard" as an Aim, pro only**, mirroring the opponent's habit.
4. **Guard as a plan answer**: "When the opponent loads up → cover", rated Beats it / Works / Walks into it.
5. **A training link**: Defence sets the block share and the parry, Tie up and Roll out mastery set the clinch refill, and "drops the right after the jab" opens the head when the guard is under half.
6. **A guard line in the Why** and on Fight prep (heavy hands, the opponent's guard habit, Write it).
7. **Amateur punishment for covering against heavy hands.** Without it, covering wins on its own in the amateur game.

### Useless or near-useless
- The "over the top" caption: it names no button.
- "Jab and move" turning blocks into misses: an effect on wear the player never sees.
- "Let your hands go": a look price that is really the base rule.
- The guard-by-round row 100 / 96 / 88: a history the player can't act on in a 60-second minute. Show it on hover or in the Why, not on the corner card.
- The hands-up +5 at the next corner: too small to change a pick once covering exists. Fold it into the cover.
- Dead code: `blocked_strikes`, and the clinch's stamina −10 / free exchange. Wire them or delete them, as the map says.

## To reach 10/10 (most important first; every number is an ESTIMATE until a probe sizes it)

1. **Put covering into the exchange edge before settle, and make it hold.**
   - Add **Hands: High / Normal / Loose** as a third standing setting beside Pace and Aim, set from the shout bar or as the corner minute's ONE CHANGE ("Gloves high" wires `posture_damage`).
   - High guard: the opponent's edge to land −0.15 and your boxer's scoring edge −0.20, both in the same edge sum the call grade feeds. Then 1 landed in 3 becomes a block.
   - Loose: the reverse, +0.10 scoring and the opponent +0.10.
   - The shout "Hands up" stays as a 30-second High.
   - This way covering can lose rounds, which is the real cost.
2. **Make "wrong against heavy hands" true for amateurs.**
   - Every 2 heavy punches blocked from an opponent with power 70+ add +1 to the look (amateur RSC for hard blows taken).
   - Widen the power factor to ×(0.5 + power/110): power 40 = ×0.86, power 80 = ×1.23.
   - Probe bar: High guard loses to a heavy hitter on stoppages in 3-round amateur bouts.
3. **Let covering tire the puncher (the 1974 trade).**
   - Against a High guard, the opponent's Push pace costs +1 energy an exchange, on the existing Pace energy line, with no cost per punch.
   - Covering is then right against a pressing heavy hitter whose tank is going, and wrong against a fresh one. The energy bar tells the player which.
4. **One count rule.** The winner from `settle` stands, and the figures read "lost 4-3 · 2 on the guard". Rounding for a 30% cut: 6→4, 5→4, 4→3, 3→2, 2→1, 1→1. BROKEN's clean punches show as "through a broken guard".
5. **Link the week to the guard.**
   - Defence sets the block share as 0.50 + Defence/500 (Defence 50 gives 0.60, today's figure) and feeds `parry_chance`.
   - Tie up step mastery scales the clinch refill: +10 at Usable, +14 at Sharp, +18 at Signature.
   - The habit "drops the right after the jab" turns 1 block an exchange into a head shot when the guard is under half. The corner minute's habit fix answers it.
   - Neck work mornings cut the head leak by 10%.
   - Show each of these on the Training tab as "guard" lines.
6. **Guard in the plan and in the Why.**
   - The plan answer "Cover" (High for that situation), rated Beats it / Works / Walks into it.
   - The Why's AGAINST YOU gets "N on the guard, M got through, about X in 100 of the result". NEXT points at the training line from point 5.
   - Fight prep's WHAT YOUR PLAN SHOULD ANSWER gets heavy hands and guard habits, each with Write it.
7. **Give the player "Through the guard" as an Aim, pro only.** It wears the opponent's guard ×1.5 and costs your boxer 1 clean landed punch an exchange. It mirrors "goes to the arms when ahead".
8. **One referee gauge.** The look, REF_STOP after counts, and amateur RSC (3 counts in a round, 4 in a bout) all show on one gauge for each boxer.
   - Drop the "warning" price until referee warnings exist.
   - Drop the "Let your hands go" duplicate.
   - Mark the 10.3.2 source CHECK.
9. **Fix and cut.** Fix the three lines in 1.6. The caption names its answer ("over the top: Let your hands go, Aim Head") or is cut. Delete `blocked_strikes`. Wire or delete the clinch leftovers.
10. **The probe, before any board.**
    - Test against four opponent types (light presser, heavy presser, counter-puncher, volume) in 3-round amateur and 4- and 6-round pro bouts, with today's rules as the control.
    - Bars: no single Hands setting is best against all four types. Each setting is best against at least one. High against a tiring heavy presser beats Normal by 5+ wins in 100. High against a fresh heavy presser loses by 5+.
    - Can't be run today: 12-round bouts (they don't exist yet).

## The 10/10 page at 1920×1080: the corner minute
Fight night style: dark and tight, coach notes handwritten in Kalam, numbers in IBM Plex Mono, nothing under 12 px. Gold sits on one thing (the coach's recommended change), and green is only "Back to the ring". All figures below are **example data**.

- **Header** (0–90 px): both boxers' names, once each, with portraits. "End of round 4 of 6". Below the header, only "your boxer" and "the opponent".
- **Left column, YOUR BOXER** (x 40–620):
  - The guard arc large: 38% in amber, with the state word WORN.
  - The state line: "A blocked jab lets 34% through, a big shot 71%."
  - The landed card: "Head 9 · Body 4 · On the guard 22 (6 got through)".
  - Referee's gauge: 4 of 10, with the counts dot under it.
  - "A count next round: about 1 in 7."
- **Centre, THE COACH'S NOTE** (x 660–1260):
  - A handwritten card: "The opponent has gone to the arms since round 3 – 41 on the guard. A tie-up buys 14 back; High guard only works while the opponent's tank lasts."
  - Under it, the event strip at 30-second steps: "1:30 guard under half · 2:00 tie-up · 2:30 heavy right on the guard".
- **Right column, THE OPPONENT** (x 1300–1880):
  - The guard arc, or "?" until scouted.
  - Energy 41 and falling.
  - Referee's gauge 1 of 10.
  - The tape line: "From the tape: heavy hands · goes to the arms when ahead".
- **Foot, ONE CHANGE** (y 760–1040):
  - The Hands setting as three tiles: High / Normal / Loose. Each shows its price in two lines: land, take, guard, look, and the opponent's energy against Push. High carries the gold border as the coach's pick.
  - Beside it, the five priced call tiles (Tie up, Hands up, Jab and move, Let your hands go, Go to the body), each with energy pips and a guard and a look line.
  - "Why?" opens a hover card with the round's guard rows.
  - The green button "Back to the ring".
- **Motion**: the arc tweens to its new value after the corner refill (+15, or +18 with Sharp Tie up). Nothing opens by itself.

That's the full GUARDDMG1 v5 score: Depth 6, General design 7, Play 5, so it misses the 7+ bar on Depth.

The biggest fix is to put covering into the exchange before it's settled, as a Hands setting (High / Normal / Loose) that lasts. Then make covering wrong against heavy hands in the amateur game too, and let covering tire out an opponent who keeps pressing.

I didn't open any repo files or code. The score rests only on the critic pack and the map.

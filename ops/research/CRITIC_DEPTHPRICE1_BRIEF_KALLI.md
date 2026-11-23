# CRITIC_DEPTHPRICE1_BRIEF_KALLI - Kalli answer (seat queue SQ316)

Brief: research/CRITIC_DEPTHPRICE1_BRIEF.md
Sent: 2026-11-23 21:40 | collected: 2026-11-23 22:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm on DEPTHPRICE1. I'll start by checking the code for FightWeek and DayJob.

`SCORE fightweek depth=4 play=4 general=6`
`SCORE dayjob depth=6 play=5 general=6`

Both are below the bar. The fight week's load should be cut as a player choice and picked by the game, unless it's tied to the opponent (see the 10/10 list). Keep the boxer's deal, but it has to become a choice the player comes back to, not one set once.

**THE FIGHT WEEK'S LOAD**

Depth is 4. With the price added, the probe's own limits section shows the choice is decided by one printed number: fresh boxers tick over and tired ones rest up. A one-line rule plays it as well as the player can. Train through is best in no cell, and the mastery a load keeps never changed which load won, so the training-kept column doesn't matter to the decision. The price changes where the line falls; it doesn't add a second reason to choose. The page also leaves out the best part already in the code: Tick over makes one chosen plan line fire one level up in rounds 1 and 2 (`round_one`, boost). That's the only link to the plan, and the page's table doesn't show it.

Play is 4. The choice comes before every amateur bout, but nothing on fight night shows its effect. A flat round 1 is an edge of 3, and the player can't see it in the Why. There's no anticipation and no reward to feel.

General is 6. The three words are clear and the code is small. But the line the game prints on Train through ("a plan move is within a week of Usable, or the opponent is 5+ below") promises a reason that the probe found never wins. That makes it a dishonest line.

- **What each option changes:** Rest up sets the tank cost to 0, rests the boxer down to 30 tiredness and makes round 1 flat. Tick over costs 6, keeps round 1 sharp and gives the one-line boost. Train through costs 8, banks the full week and adds +6 tiredness after the bout.
- **Useless:** Train through as it's measured, and the training-kept column as a reason to choose.
- **Missing:** the opponent. Ring rust after a rest is real; trainers taper for fast starters and drill hard against slow ones. Also missing is a move about to cross Usable, which would turn the banked training into a weapon on fight night.
- **If it's cut,** the coach picks from tiredness. You lose about 3 wins in 100 that a player could earn with a one-line rule, and nothing a player would miss.

**THE BOXER'S DEAL: SPONSORSHIP OR A DAY JOB**

Depth is 6. This is a real trade: $8,700 against 2.9 wins in 100 over 78 weeks, and it touches money, training, loyalty and the rival club's approach. Real amateurs do work jobs, so it rings true. But the gap in wins is only one and a half times the noise, and pro offers came at the same time in all 56 of 56 careers in each arm. In that probe, the deal never changed a career.

Play is 5. It's set once on the money page and forgotten. A pick that doesn't change with the week isn't a weekly decision.

General is 6. The words are good, it uses what the game has, and the price is one sentence. But the page's table leaves out the loyalty cost the code already charges (below), which is the deal's strongest interaction.

- **What each option changes:** full costs $250 a week and keeps every session. Half costs $125, loses one morning and, under the new price, one pad evening. A day job costs $0 and loses two mornings and two pad evenings. Moving between deals also changes loyalty, and low loyalty brings the rival club.
- **Useless:** none, but half is only a midpoint. It's never best for a reason of its own.
- **Missing:** timing. The money should go where the fight is: time off work in the weeks before a booked bout or the nationals, and the job in the weeks with nothing booked.

**Code check**

The fetch failed again on the GitHub login, so I read origin/main `8d34d5c4` (21 Nov, 10:03 Cyprus time, UTC+2). That's older than the 23 Nov the brief asks for. I used read-only git only.

Files read: `scripts/rules/FightWeek.gd` (all of it), `scripts/rules/DayJob.gd` (all of it), `scripts/state/GymSpend.gd` (:30-45, :110-155), `scripts/state/ApproachWire.gd` and `scripts/rules/Approach.gd` (constants), and `scripts/rules/Loyalty.gd` :49, plus searches for who calls `DayJob` and `FightWeek`.

**True in my copy**
- `STOP_TANK` 0, 6 and 12.
- `REST_UP_TIRED_TO` 30.
- `REST_UP_EDGE` [[40, -2], [65, -1]], with nothing from 65.
- The tiredness layer is 1 a point over 50, capped at 25.
- Sparring nights cost 3 or 5 off the tank.
- `BANK_SHARE` is 0.2, 0.5 and 1.0.
- `TRAIN_THROUGH_TIRED_AFTER` is 6.
- `DEFAULT_STOP` is Tick over.
- The functions `tank`, `round_one`, `banked`, `tired_after`, `count_of` and `lost_days` all exist.
- A day job loses 2 mornings (`LOST`) and half loses 1 (`HALF_LOST`). A pro never works.
- The stipend is $250 and half is $125.
- The rival's approach answer holds the sponsorship for 84 days, which is 12 weeks.

**Wrong or incomplete**
- **The page's fight-week table is missing Tick over's boost.** `round_one` gives Tick over a boost: one chosen plan line fires one level up in rounds 1 and 2. Without it, Tick over looks like Rest up with a cost.
- **The day job's lost mornings are on set days.** They're Tuesday and Thursday (`LOST_DAYS` [1, 3]), and half loses Tuesday. The new lost evenings (Monday and Wednesday, or Wednesday for half) would leave a day-job boxer touched on 4 of 6 days. That isn't in the code; it's new and fine, but the week plan's "Work" label then has to cover evenings too (`WeekBoard.gd` :200 reads only `lost_days_of`, which is mornings).
- **"Nothing feeds back into the deal" isn't quite true.** Changing the deal moves loyalty: +5 when given, -8 when pulled, half +3 or -4 (`GymSpend.set_stipend` and `set_half`, `Loyalty.gd` :49). The rival's approach comes at loyalty under 35 (`ApproachWire` :5), and its forecast charges a holder who isn't Loyal three ticks of -3 over 12 weeks (:32). That loop is there; the page should show it.
- **The $250 is not always $250.** A boxer at home in the juniors' scheme gets half the stipend (`HomeJuniors.HALF`), so it's $125 for full and about $63 for half. The table's flat $250 and $125 miss this.
- **The printed `BEST_WHEN` line for Train through promises a case the probe says never wins.**

**Not in my copy:** `docs/DEPTHPRICE1A_RESULT.md`, `docs/DEPTHPRICE1B_RESULT.md` and the price changes themselves. The page says those aren't built, which matches.

**The probes**

Both bars can pass while the choice stays shallow.
- **"No option best in more than 6 of 10 cells" passed while one printed number decides.** Splitting 5 and 4 by a tiredness line isn't a decision; it's a lookup. Measure a one-line rule bot (tick over under 50 tiredness, rest up from 50) against the informed pick. If the rule bot is within 1 win in 100, the choice is solved by a rule.
- **"3 wins in 100 or real money" passed close to the noise.** The day job's 2.9 is 1.5 times the noise, and the fight week's 3.1 is the informed pick against one habit. Use a gap of 2.5 times the noise, or more runs.
- **Real money is counted in dollars, not in what it buys.** $8,700 matters only if it changes something. Measure whether the gym stays open, the weeks of runway, and whether spending the saved money on a coach or upgrades wins the wins back.
- **The probe never measured how often the state crosses the line in a real career.** If most amateur fight weeks start under 50 tiredness, the choice is Tick over almost every time. Measure how often each answer is right across the bouts of a real 78-week career.
- **What I'd measure instead:** the share of fight weeks where the best load beats the second by 2 wins in 100 or more (30% or more as the target); whether the opponent's tell ever flips the load; whether a timed sponsorship beats every set-once deal; and career outcomes (the nationals, pro offers, gym survival) rather than wins per 100.

**THE FIGHT WEEK'S LOAD: To reach 10/10**
1. **Let the opponent's start change round 1.** A fast starter makes a flat round 1 cost 5; a slow starter makes it cost 1. Print it as a tell from tape. Then resting up against a slow starter is a real read, and the tiredness rule stops being enough.
2. **Make Train through pay a named move.** When the week's full units take a plan move across Usable (30) before the bell, print "the lead hook becomes a weapon on fight night" and make it fire. Otherwise, remove Train through and make the choice two loads.
3. **Show Tick over's boost on the card,** with the line it lifts ("the jab fires as Sharp in rounds 1 and 2"), and let the player pick that line.
4. **Show the result in the Why:** "Round 1 flat: -3 against a fast starter, 1 exchange lost", so the pick has a reward the player can see.
5. **Tie it to the weight cut.** A boxer more than 1 kg over on the Monday makes Rest up the only load that doesn't add to the cut.
6. **If items 1 and 2 don't pass a re-run, cut it.** The coach picks from tiredness, and the screen shows the pick with no buttons.

**THE BOXER'S DEAL: To reach 10/10**
1. **Add time off for the bout.** Pay $250 for the 3 weeks before a booked bout or a nationals stage, and use the day job otherwise. The money then follows the calendar, and the choice comes back with every booking.
2. **Show what the job costs in this boxer's terms:** the plan's moves that are slower to Usable, and the stat gain lost each week, not "1 morning".
3. **Show loyalty on the deal:** +5, -8, ±3 or -4, the line under 35 where a rival club looks, and the -3 ticks while working.
4. **Let ambition read the deal** (the signing card's ambition does nothing today). A title-chaser loses loyalty on a job; a steady earner minds less.
5. **Give half a reason of its own:** keep the boxer's pad evenings and lose only the morning, so half protects plan mastery at half the cost.
6. **Label evenings as Work on the week board** (the code only marks mornings), and include the junior-scheme half stipend in the money line.
7. **Re-run the probe** with career outcomes, a timed-sponsorship arm, and a 2.5-times-noise bar.

The page shows both choices at 10/10. On the left, the fight week has the opponent's start and a move about to cross Usable on the cards. On the right, the boxer's deal has the costs in the boxer's own terms, the loyalty line, and time off for the bout. There's one gold choice a side and green only on Continue. Everything on it is example state, and the parts I added are tagged as critic proposals.

```html
<!doctype html><html><head><meta charset="utf-8"><title>DEPTHPRICE1 - fight week load and the boxer's deal at 10/10 (critic)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#c9b08a;font-family:'IBM Plex Mono',monospace;font-size:14px;color:#2b2620;position:relative}
.d{font-family:'Bebas Neue',sans-serif;letter-spacing:1px}
#top{height:60px;background:#15181c;color:#d9dde3;display:flex;align-items:center;padding:0 28px;gap:26px;font-size:14px}
#top .gym{font-size:28px;color:#fff}#top .sp{flex:1}
#top .cont{background:#2f7d4a;color:#fff;padding:8px 18px;font-size:22px}
.panel{position:absolute;top:76px;width:924px;height:990px;background:#f3efe6;border:12px solid #b9bec4;padding:16px 22px}
.panel h1{font-size:44px;line-height:44px}.panel .sub{font-size:13px;color:#5b5348;margin:4px 0 12px}
.opt{border:1px solid #d8cfbf;background:#fff;padding:12px 14px;margin-bottom:10px;position:relative}
.opt h3{font-size:28px;line-height:28px}
.opt.gold{border:3px solid #c9971f}
.row{display:grid;grid-template-columns:230px 1fr;line-height:21px;border-bottom:1px dotted #d8cfbf}
.mut{font-size:13px;color:#5b5348;line-height:18px}
.tag{display:inline-block;font-size:12px;background:#ece6d8;border:1px dashed #8a7a62;padding:1px 6px}
.pick{position:absolute;right:14px;top:12px;border:2px solid #2b2620;padding:4px 14px;font-size:20px;background:#f3efe6}
.gold .pick{background:#c9971f;border-color:#8f6a12}
.strip{background:#fbf8f1;border:1px solid #d8cfbf;padding:10px 14px;margin-top:6px}
.bar{height:14px;background:#ece6d8;position:relative;margin:4px 0}.bar i{position:absolute;left:0;top:0;bottom:0;background:#4a5360}
#foot{position:absolute;left:40px;bottom:2px;font-size:12px;color:#5b5348}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 12 Apr 2027 · Week 67</span><span class="sp"></span><span>$6,410 · running +$140 a week</span><span class="cont d">CONTINUE ▸ TO SAT 17 APR, THE CLUB SHOW</span></div>

<div class="panel" style="left:24px">
 <h1 class="d">FIGHT WEEK · SAM OKAFOR</h1>
 <div class="sub">Amateur · 4-1 · lightweight · bout Sat 17 Apr, 3 x 3 · example state, not engine output</div>
 <div class="strip"><div class="row"><span>Tiredness now</span><span>58 · moves the tank 8 off at the bell</span></div>
  <div class="row"><span>The opponent</span><span>a fast starter: wins round 1 in 4 of 5 bouts (tell, from tape) <span class="tag">critic proposal</span></span></div>
  <div class="row"><span>Plan line close to Usable</span><span>the lead hook at 26 · Usable at 30</span></div></div>
 <div class="opt" style="margin-top:10px"><h3 class="d">REST UP</h3><span class="pick d">PICK</span>
  <div class="row"><span>Off the tank</span><span>0 · tiredness down to 30</span></div>
  <div class="row"><span>Round 1</span><span>flat · 3 off the edge, and 5 against a fast starter <span class="tag">critic proposal</span></span></div>
  <div class="row"><span>Training kept</span><span>a fifth: the lead hook stays at 26</span></div>
  <div class="mut" style="margin-top:4px">Right when the boxer is tired or cutting hard and the opponent starts slow.</div></div>
 <div class="opt"><h3 class="d">TICK OVER</h3><span class="pick d">PICK</span>
  <div class="row"><span>Off the tank</span><span>6 + 8 from tiredness = 14</span></div>
  <div class="row"><span>Round 1</span><span>sharp · one plan line fires a level up in rounds 1 and 2: the jab, Usable to Sharp</span></div>
  <div class="row"><span>Training kept</span><span>half: the lead hook reaches 28</span></div>
  <div class="mut" style="margin-top:4px">Right for most fresh weeks.</div></div>
 <div class="opt gold"><h3 class="d">TRAIN THROUGH</h3><span class="pick d">PICK</span>
  <div class="row"><span>Off the tank</span><span>8 + 8 from tiredness = 16</span></div>
  <div class="row"><span>Round 1</span><span>sharp</span></div>
  <div class="row"><span>Training kept</span><span>the whole week: the lead hook reaches 31, a weapon on fight night</span></div>
  <div class="row"><span>After the bell</span><span>+6 tiredness</span></div>
  <div class="mut" style="margin-top:4px">Right only when a plan move crosses Usable before the bell. The line names it.</div></div>
 <div class="strip"><b class="d" style="font-size:20px">THE COACH'S PICK IF YOU PRESS CONTINUE</b><div class="mut">Tick over. The coach reads tiredness only; the opponent's start and the lead hook are yours to weigh.</div></div>
</div>

<div class="panel" style="left:972px">
 <h1 class="d">THE BOXER'S DEAL · SAM OKAFOR</h1>
 <div class="sub">Office desk › Money › Sponsorship · amateur · example state, not engine output</div>
 <div class="strip"><div class="row"><span>Next bout</span><span>Sat 17 Apr · the nationals' entry closes week 10</span></div>
  <div class="row"><span>Loyalty</span><span>48 · a rival club looks below 35</span></div>
  <div class="bar"><i style="width:48%"></i></div>
  <div class="row"><span>The gym's runway</span><span>11 weeks</span></div></div>
 <div class="opt" style="margin-top:10px"><h3 class="d">FULL SPONSORSHIP</h3><span class="pick d">PICK</span>
  <div class="row"><span>The gym pays</span><span>$250 a week, billed in 4-week blocks</span></div>
  <div class="row"><span>Lost to work</span><span>nothing</span></div>
  <div class="row"><span>Loyalty</span><span>+5 when given</span></div></div>
 <div class="opt"><h3 class="d">HALF</h3><span class="pick d">PICK</span>
  <div class="row"><span>The gym pays</span><span>$125 a week</span></div>
  <div class="row"><span>Lost to work</span><span>Tue morning · Wed pad evening</span></div>
  <div class="row"><span>What that costs</span><span>about 1 week in 6 of stat gain; the lead hook 0.5 slower a week</span></div>
  <div class="row"><span>Loyalty</span><span>-4 from full · +3 from a day job</span></div></div>
 <div class="opt"><h3 class="d">DAY JOB</h3><span class="pick d">PICK</span>
  <div class="row"><span>The gym pays</span><span>$0</span></div>
  <div class="row"><span>Lost to work</span><span>Tue and Thu mornings · Mon and Wed pad evenings</span></div>
  <div class="row"><span>What that costs</span><span>a third of stat gain; two of three pad nights</span></div>
  <div class="row"><span>Loyalty</span><span>-8 when the sponsorship is pulled</span></div></div>
 <div class="opt gold"><h3 class="d">TIME OFF FOR THE BOUT</h3><span class="pick d">PICK</span><span class="tag">critic proposal</span>
  <div class="row"><span>The gym pays</span><span>$250 a week for the 3 weeks before a booked bout, then back to the job</span></div>
  <div class="row"><span>Lost to work</span><span>nothing in those weeks</span></div>
  <div class="row"><span>Loyalty</span><span>+2 · the boxer sees the gym back the fight</span></div>
  <div class="mut" style="margin-top:4px">The sponsorship goes where the fight is; idle weeks go to the job.</div></div>
</div>
<div id="foot">Kalli · critic page · DEPTHPRICE1 · example state, not engine output · name in the header only · gold on one thing a side, green on Continue only</div>
</body></html>
```

I scored both choices below the bar: the fight week's load at 4 for depth and 4 for play, and the boxer's deal (full sponsorship, half or a day job) at 6 and 5.

**The fight week's load:** one printed number, tiredness, decides it, and Train through never wins. I'd cut it as a player choice and let the coach pick from tiredness. The only way to keep it is to tie it to the opponent: whether they start fast or slow, plus a plan move that becomes usable on fight night. Even then it stays only if a re-run passes.

**The boxer's deal:** keep it. It's a real trade of money against wins and it already moves loyalty. The fix is a time-off-for-the-bout option, so the sponsorship pays for the weeks before a booked bout and the boxer works the rest.

The code check is on my 21 Nov copy because the fetch failed. The page and its preview are at `/workspace/depthprice1/`.

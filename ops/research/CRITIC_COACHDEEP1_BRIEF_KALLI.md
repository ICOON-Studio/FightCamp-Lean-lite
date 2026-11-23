# CRITIC_COACHDEEP1_BRIEF_KALLI - Kalli answer (seat queue SQ302)

Brief: research/CRITIC_COACHDEEP1_BRIEF.md
Sent: 2026-11-23 04:40 | collected: 2026-11-23 05:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking the repository at the 23 Nov commit first, then I'll score the coach design.

**COACHDEEP1: the score**

`SCORE depth=6 play=5 general=6`

It's below the bar on both depth and play, but I'd keep it. Coaches as people is the right way to make a multi-boxer gym matter. What the map builds today, though, is a puzzle you solve once at setup, not a choice you face every week.

**Depth 6.** The pieces are real: a coach's way of boxing against your boxer's style, temper against heart, a bond that grows, and a corner for fight night. All of them hook into rules the game already has. But one rule wins almost everywhere, and three things push it that way:

- Chemistry is the biggest number on the board. It moves learning by up to 30%, while the whole gap between a pads-11 coach and a pads-15 coach is about 5% (the coach term in `MoveMastery.gain`, 1.23 against 1.29). The probe's estimates make "pair by chemistry" the winner before the player does anything.
- Bad chemistry is never worth choosing. A clash only costs, so the right move is always to avoid it.
- The bond rewards never moving anyone, which pulls the board toward one fixed setup.

**Play 5.** Nothing in a normal week makes you change the board. The rule "whoever boxes soonest gets the best coach" was never the best rule in any of the ten coach pairs, which shows the bout calendar doesn't make you re-pair anyone. The payoff against "everyone the same" is 11 to 20 points over two years, about 0.15 points a week, too small to notice from one week to the next. The moments that would bring you back are missing: two boxers on the same show with only one good corner, a camp that needs more coached nights than you have, and a clash you have to handle.

**General 6.** Most of it is wired to real rules and it's clearly laid out. The problems:

- **Overlaps.** The Cutman attribute repeats the Cutman staff job ($150 a pro night). Weight repeats the Old hand's easier cuts. Motivation overlaps the chemistry morale line.
- **Unclear value.** Teaching young matters for one boxer in the test club.
- **The head coach is left out.** You are the head coach, but the map gives you no evenings.
- **Fixed he and she.** The map writes he for coaches and she for boxers, which breaks S412, and the card line "he shouts, she folds" breaks it on screen.
- **The numbers don't match.** Section 2.5 says three pad nights each (12 wanted, 6 coached), but the probe gives two each (8 wanted, 6 coached).

**The central claim: a choice, or a solved puzzle?**

It's solved. Counting which rule comes out best (bar a) hides how close it is. Here is how much worse "pair by chemistry" does than the best rule in each coach pair:

- 0.6 points in AB, 5.0 in AD, 0.4 in BC, 0.6 in CE, and zero in the other six pairs.

So in 9 of the 10 pairs, the chemistry rule finishes within one point of the best. A player would find it in the first two or three weeks, because the coach card prints the chemistry word with its reason (Good, Fine, Rubs your boxer wrong). After that the rule is simple: pair the Good words, send the no-gi athlete to the coach who knows the mat, and don't touch the board again.

**Which options are missing**

- **You as a coach.** You're the head coach, so you should have your own evenings and a way of boxing, and every evening you spend coaching is one you don't spend in the office.
- **One corner, two bouts.** A choice for when two of your boxers fight on the same show.
- **Coached sparring and camp nights.** PEAK weeks want sparring nights coached, which is where the demand really spikes.
- **A word with the coach.** You can't ask the coach to ease off one boxer, or push harder, at a price.
- **A trade-off for a clash.** Real gyms put a hard voice on a soft fighter on purpose. Today a clash is never worth it.
- **A morning share.** Coached mornings already exist (`CoachedMornings.owned`), but the map only hands out pad nights.
- **Letting a coach go and hiring a replacement.** The map sends all of this to Phase 3.

**Which options are useless as written**

- **Cutman, as a coach attribute.** The Cutman staff job already does this.
- **Weight, as a coach attribute.** It repeats the Old hand edge.
- **Teaching young.** It's a hidden multiplier that applies to one boxer.
- **The coach's rating.** The map already cuts it, and that's right.

**What each option changes**

- **Assigning a night** changes how fast your boxer learns moves, plus mood and the bond. The size of each effect is a probe estimate.
- **Who works the corner** changes how many lines the plan reads and how many tells the film opens.
- **Their corner card (Phase 2)** changes the weigh-in answer and how fast they spot a repeated combination. This one is good, because you can act on every line of it.

**Real boxing**

Trainer changes for style are real. Tyson Fury moved to SugarHill Steward to box on the front foot before the Wilder rematch in February 2020. Long bonds are real too: Canelo Álvarez has had Eddy Reynoso in the corner for his whole career. Both point the same way: who the coach is matters when a style change or a camp is coming, not as a fixed pairing on day one.

**Code check**

I couldn't open main from 23 Nov. Fetching failed on the GitHub login, so I read my copy of `origin/main` at commit `8d34d5c4` (21 Nov, 10:03 Cyprus time) with `git show` and changed nothing.

**Not in my copy, so I can't judge them:** `tools/coachdeep1.gd`, `tools/coachdeep1_rules.gd`, `scripts/rules/WeighMiss.gd`, `scripts/state/WeighMissWire.gd`, `docs/COACHHIRE1_RESULT.md`, and the "THEIR CORNER" line in `WeighIn.gd:46`. I checked `WeighMiss` against your excerpt only, and it matches what the map says.

**Matches my copy:** `Career.gd:23` and `:69`, `Data.gd:33-40`, `CoachAreas.gd:8` and `:63`, `MoveMastery.gd:66`, `DrillWeek.gd:159`, `CoachPlan.gd:27` and `:65`, `BoutRead.gd:272` and `:382`, `OppFile.gd:120`, `:135` and `:209`, `FighterProfile.gd:7`, `:39` and `:163`, `CornerTrust.gd:11` (Low means the corner stops landing), `Exchanges.gd:249`, `CoachedMornings.gd:34` and `:142`, `HeadCoach.gd:65` and `:79`, `StaffCard.gd:53`, and `Loyalty.gd:202`. `Sim.hire` sits one line lower in my copy (476-481); your 23 Nov excerpt matches the map.

**Claims that are wrong or misleading:**

1. **The coach's plan lines (2.3).** `CoachPlan.write(style, rating, …)` takes the opponent's style (`BoutRead.gd:272` passes `opp.style`), and it has no input for the coach's way of boxing. So "his plan for her, in his style's order" can't be shown with today's function. It needs a new argument, which is a code change, not a wire.
2. **Cutman wired to `GuardState.gd:124`.** That line is guard recovery during the round (`GuardWear.in_round`). Recovery between rounds is the corner minute's RECOVER. The map points at the wrong rule.
3. **The departure stand-in.** `Loyalty.leaves` fires when loyalty is under 25 after two talks. The probe's "Low mood for 6 weeks" is a different rule, so in the game chemistry would never make a boxer leave unless a clash writes to the loyalty log.
4. **`OfficeDesk.gd:356` lists the coaches.** In my copy that line doesn't do that, and the file has no `COACHES` reference. It may have landed after 21 Nov.
5. **Pad nights.** The map says three a boxer and the probe uses two, as I said above.

**The probe**

It's an honest probe, and its own caveats are right. But the bars test whether the lever can move a number, not whether the choice is deep. All three ways it might be shallow while still passing show up:

- **Bar (a)** counts which rule wins, not by how much. A rule that comes within one point everywhere is dominant even when it "wins" only 6 of 10.
- **Bar (c)** leans on Ana, the no-gi athlete: without her it is exactly 5 of 10. And coach A is best for every boxer in three pairs.
- **Bar (d)** compares against an even split that no player would choose.
- **Departures cost nothing in the score.** The best rules lose Kira in 13 to 30 of the 30 careers in three of the pairs.

What I'd measure instead:

1. **The cost of the obvious rule.** How much the chemistry rule loses against the best rule in each pair. Pass when it loses 2 points or more (beyond 2 standard errors) in at least 5 pairs.
2. **Whether the week matters.** The share of weeks where the best setup moves at least one night. Pass at 30% or more.
3. **The bar without the no-gi athlete:** at least 7 of 10 pairs.
4. **Price departures** through `Loyalty.leaves`, with the stipend paid so far and the boxer's future bouts.
5. **Charge wages, and add a market.** Wages in the score, and three coaches for five boxers, so the right hire isn't settled on the hire screen.
6. **A blind test.** Have two people play 12 weeks without seeing the rules, and record what they say their rule is and in which week they found it.

**To reach 10/10** (most important first)

1. **Make the week change.** Add three pressures that move from week to week:
   - Two boxers on the same show with one proper corner. The second corner gets a rushed plan worth half its lines.
   - PEAK weeks that want two coached sparring nights.
   - A twist card for the coach: ill, or away for a week.
   Measure with point 2 above.
2. **Shrink chemistry and give a clash a payoff.** Size chemistry below the craft gap (learning ×(1 ± 0.10)). Then a hard voice on a soft heart costs 2 morale a week but grows heart by 1 every 4 weeks, so a clash is sometimes the right call. Measure with point 1 above.
3. **Hide chemistry at first.** Learn the word over the first 2-3 coached weeks, the way habits are learned in fights. Until then show "not seen yet".
4. **Make you, the head coach, the third coach.** Give you 4 evenings and a way of boxing from your background, and make every evening you coach one fewer office action that week.
5. **Price a departure for real.** A clash week writes `coach_clash` to the loyalty log, so `Loyalty.leaves` fires the game's own way. Show loyalty and the leave line on the boxer's row.
6. **One word with the coach each week.** "Ease off" halves a clash for 4 weeks and costs the coach 1 motivation. "Push" doubles the clash's payoff and its morale cost.
7. **Wages by ability, and a real coach market.** No coach is best at everything: each has one high attribute and one low. Show three candidates on the hire screen at prices tied to the attributes. Add a Let go button that costs a week's pay, matching the staff jobs.
8. **Cut and merge the attributes down to six:** Pads, Conditioning, Tactics, Film, Voice (temper and motivation merged), and Patience. Drop Cutman and Weight, which already exist as the staff job and the Old hand edge. Drop Teaching young. Every one of the six must move a probed number.
9. **Give `CoachPlan.write` a coach-style argument,** so "the coach's plan for your boxer" can be shown on the Plan screen before you pick the corner. Flag it as a code change.
10. **Fix the wiring and the words.** Cutman goes to the corner minute's RECOVER, not `GuardState`. Pad nights become three in both the map and the probe, and so does the 12-wanted count. No fixed he or she: "the coach shouts, your boxer folds".
11. **Keep Phase 2, the other corner, as written.** Their temper decides the weigh-in answer and their film decides how fast they read you, and you can act on both lines. Make it the first thing after the week works.

My 10/10 drawing is the Week board: who coaches whom, a show night with two bouts as the one gold choice, a word with the coach, and camp nights.

```html
<!doctype html><html><head><meta charset="utf-8"><title>COACHDEEP1 - who coaches whom, at 10/10 (critic)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#c9b08a;font-family:'IBM Plex Mono',monospace;font-size:15px;color:#2b2620}
.d{font-family:'Bebas Neue',sans-serif;letter-spacing:1px}
#top{height:64px;background:#15181c;color:#d9dde3;display:flex;align-items:center;padding:0 28px;gap:28px;font-size:14px}
#top .gym{font-size:28px;color:#fff}#top .sp{flex:1}
#top .cont{background:#2f7d4a;color:#fff;padding:8px 18px;font-size:22px}
#board{position:absolute;left:40px;top:88px;width:1840px;height:970px;background:#f3efe6;border:14px solid #b9bec4;box-shadow:0 6px 0 #8a7a62}
#hdr{position:absolute;left:32px;top:20px;right:32px;display:flex;align-items:flex-end;gap:20px}
#hdr .nm{font-size:56px;line-height:50px}
#hdr .sub{font-size:14px;color:#5b5348;padding-bottom:6px}
#coaches{position:absolute;left:32px;top:96px;width:400px}
.coach{background:#fff;border:1px solid #d8cfbf;padding:12px 14px;margin-bottom:12px}
.coach .n{font-size:30px;line-height:30px}
.coach .k{font-size:13px;color:#5b5348;margin-bottom:6px}
.attr{display:grid;grid-template-columns:118px 1fr 28px;gap:6px;align-items:center;font-size:13px;margin:3px 0}
.bar{height:10px;background:#e7e0d2}.bar i{display:block;height:10px;background:#7d8b99}
.ev{margin-top:8px;font-size:13px;display:flex;gap:4px;align-items:center}
.ev b{display:inline-block;width:22px;height:14px;background:#7d8b99}.ev b.f{background:#e7e0d2;border:1px solid #b9b0a0}
#grid{position:absolute;left:460px;top:96px;width:960px}
.gh{display:grid;grid-template-columns:230px repeat(3,1fr) 190px;gap:8px;font-size:22px;margin-bottom:6px}
.br{display:grid;grid-template-columns:230px repeat(3,1fr) 190px;gap:8px;margin-bottom:10px}
.who{background:#fff;border:1px solid #d8cfbf;padding:8px 10px}
.who .n{font-size:26px;line-height:26px}.who .s{font-size:12px;color:#5b5348}
.night{border:2px dashed #b9b0a0;background:#fbf8f1;display:flex;flex-direction:column;justify-content:center;align-items:center;font-size:13px;padding:6px;text-align:center}
.night.c{border:2px solid #2b2620;background:#fff}
.night .cn{font-size:24px}
.mix{background:#fff;border:1px solid #d8cfbf;padding:8px 10px;font-size:12px;line-height:17px}
.mix .w{font-size:20px}
.rub{color:#9a3a2a}
#side{position:absolute;left:1446px;top:96px;width:362px}
.card{background:#fff;border:1px solid #d8cfbf;padding:12px 14px;margin-bottom:12px;font-size:13px;line-height:19px}
.card h3{font-size:24px;font-weight:normal;margin-bottom:4px}
.gold{border:3px solid #c9971f;background:#fffaf0}
.btn{border:2px solid #2b2620;text-align:center;padding:6px 0;font-size:20px;margin-top:8px;background:#fff}
.gold .btn.g{background:#c9971f;border-color:#8f6a12}
.two{display:grid;grid-template-columns:1fr 1fr;gap:8px}
#count{position:absolute;left:460px;top:820px;width:960px;background:#fff7d6;border:1px solid #d8c98f;padding:12px 16px;font-size:14px;line-height:21px}
#count .big{font-size:30px}
#foot{position:absolute;left:32px;bottom:12px;font-size:12px;color:#7b7266}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 13 Apr · Week 15</span><span class="sp"></span><span>$7,880 · running −$420 a week</span><span class="cont d">CONTINUE ▸ TO TUE 14 APR</span></div>
<div id="board">
 <div id="hdr"><div class="nm d">WHO COACHES WHOM</div><div class="sub">Pad nights this week · 12 wanted · 9 coached (3 + 3 + you 3) · 3 alone · example state, not engine output</div></div>
 <div id="coaches">
  <div class="coach"><div class="n d">LUKE REID</div><div class="k">Sessional · $450 a week · way: outbox, jab and move</div>
   <div class="attr"><span>Pads</span><span class="bar"><i style="width:75%"></i></span><span>15</span></div>
   <div class="attr"><span>Conditioning</span><span class="bar"><i style="width:50%"></i></span><span>10</span></div>
   <div class="attr"><span>Tactics</span><span class="bar"><i style="width:60%"></i></span><span>12</span></div>
   <div class="attr"><span>Film</span><span class="bar"><i style="width:45%"></i></span><span>9</span></div>
   <div class="attr"><span>Voice</span><span class="bar"><i style="width:30%"></i></span><span>calm</span></div>
   <div class="ev">Evenings <b></b><b></b><b></b> 3 of 3 used</div></div>
  <div class="coach"><div class="n d">MARCUS HALE</div><div class="k">Full time · $1,090 a week · way: pressure, walk them down</div>
   <div class="attr"><span>Pads</span><span class="bar"><i style="width:60%"></i></span><span>12</span></div>
   <div class="attr"><span>Conditioning</span><span class="bar"><i style="width:90%"></i></span><span>18</span></div>
   <div class="attr"><span>Tactics</span><span class="bar"><i style="width:70%"></i></span><span>14</span></div>
   <div class="attr"><span>Film</span><span class="bar"><i style="width:65%"></i></span><span>13</span></div>
   <div class="attr"><span>Voice</span><span class="bar"><i style="width:85%"></i></span><span>loud</span></div>
   <div class="ev">Evenings <b></b><b></b><b></b><b></b><b></b> 3 pads + 2 sparring</div></div>
  <div class="coach"><div class="n d">YOU · HEAD COACH</div><div class="k">Old hand · no wage · way: counter</div>
   <div class="attr"><span>Pads</span><span class="bar"><i style="width:50%"></i></span><span>10</span></div>
   <div class="attr"><span>Tactics</span><span class="bar"><i style="width:65%"></i></span><span>13</span></div>
   <div class="ev">Evenings <b></b><b></b><b></b><b class="f"></b> 3 of 4 · the 4th is the office</div></div>
 </div>
 <div id="grid">
  <div class="gh d"><span>BOXER</span><span>MON PADS</span><span>WED PADS</span><span>FRI PADS</span><span>WITH THE COACH</span></div>
  <div class="br"><div class="who"><div class="n d">LUCY JACKSON</div><div class="s">Out-boxer · 22 · bout Sat 25 Apr</div></div>
   <div class="night c"><span class="cn d">OUTBOX</span>pads 15 · the coach's way</div><div class="night c"><span class="cn d">OUTBOX</span>pads 15 · the coach's way</div><div class="night c"><span class="cn d">YOU</span>pads 10</div>
   <div class="mix"><span class="w d">GOOD · 9 WEEKS</span><br>calm voice, steady boxer. Moves +14% this week.</div></div>
  <div class="br"><div class="who"><div class="n d">KIRA</div><div class="s">Out-boxer · 18 · heart soft</div></div>
   <div class="night c"><span class="cn d">PRESSURE</span>pads 12 · not the coach's way</div><div class="night"><span class="cn d">ALONE</span>training alone</div><div class="night c"><span class="cn d">YOU</span>pads 10</div>
   <div class="mix"><span class="w d rub">HARD VOICE · 3 WEEKS</span><br>morale −2 a week, heart grows +1 in 4 weeks. Loyalty 31: leaves under 25.</div></div>
  <div class="br"><div class="who"><div class="n d">JOSH</div><div class="s">Pressure fighter · 24 · bout Sat 25 Apr</div></div>
   <div class="night c"><span class="cn d">PRESSURE</span>pads 12 · the coach's way</div><div class="night c"><span class="cn d">PRESSURE</span>pads 12 · the coach's way</div><div class="night"><span class="cn d">ALONE</span>training alone</div>
   <div class="mix"><span class="w d">GOOD · 12 WEEKS</span><br>hard voice, hard heart. Engine +18% this week.</div></div>
  <div class="br"><div class="who"><div class="n d">ANA RIBEIRO</div><div class="s">No-gi · blue belt</div></div>
   <div class="night c"><span class="cn d">OUTBOX</span>boxing only: mat alone</div><div class="night"><span class="cn d">ALONE</span>training alone</div><div class="night c"><span class="cn d">YOU</span>knows no-gi</div>
   <div class="mix"><span class="w d">FINE · 5 WEEKS</span><br>no coach here knows the mat well: classes at alone rate except yours.</div></div>
 </div>
 <div id="count"><div class="big d">THIS WEEK AGAINST EVERYONE THE SAME</div>Moves learned +6 points over the four. Mood: one boxer down (the hard voice), two up. Bond: 3 pairs grow; a boxer moved to another coach starts the bond again. Hover any night for its number and where it comes from.</div>
 <div id="side">
  <div class="card gold"><h3 class="d">SAT 25 APR · TWO BOXERS, ONE SHOW</h3>Both bouts are on the same card, rounds apart. A coach can work one corner properly. Pick who works which, or keep each boxer with their own coach and accept a rushed second corner.
   <div class="two"><div class="btn d">OUTBOX COACH: FIRST BOUT</div><div class="btn d">PRESSURE COACH: FIRST BOUT</div></div><div class="btn g d">KEEP BOTH ON THEIR OWN COACH</div></div>
  <div class="card"><h3 class="d">TALK TO MARCUS HALE</h3>One word a week. "Ease off the young one": the clash halves for 4 weeks, the coach's motivation −1. Or leave it: the hard voice may grow heart.<div class="btn d">EASE OFF THE YOUNG ONE</div></div>
  <div class="card"><h3 class="d">CAMP NIGHTS</h3>Both bouts are 12 days off: PEAK weeks want sparring nights coached. Next week asks 2 more evenings than you have.<div class="btn d">OUTSIDE PARTNER ($160)</div></div>
 </div>
 <div id="foot">Kalli · critic page · COACHDEEP1 · example state, not engine output · names in headers only · gold on one thing, green on Continue only</div>
</div>
</body></html>
```

I'd keep the coach design but change it before it's built: depth 6, play 5, general 6, which is under the 8/8 bar on both. Pairing each boxer by chemistry comes within one point of the best plan in 9 of the 10 coach pairs, so a player would find it in a couple of weeks and stop changing the board.

The fix that matters most is giving each week a reason to re-pair boxers: two boxers on one show with only one good corner, camp weeks that want more coached nights, and a coach who's ill or away. Smaller chemistry effects and a payoff for a clash come next.

I couldn't open the 23 Nov code because fetching it failed on the GitHub login. I checked the map against my copy from 21 Nov and changed nothing. The two biggest wrong claims are that the coach's plan lines can't follow the coach's way of boxing without a code change, and that the Cutman attribute is wired to recovery during the round, not between rounds.

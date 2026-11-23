# CRITIC_TURNPRO1_V15_BRIEF_KALLI - Kalli answer (seat queue SQ304)

Brief: research/CRITIC_TURNPRO1_V15_BRIEF.md
Sent: 2026-11-23 11:40 | collected: 2026-11-23 12:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm on it. First I'll check the code at the newest commit I can reach, then score the turning-pro map, judge the probe and draw the 10/10 page.

The code check and the 10/10 page are underway. I'll send the scores, the code findings, the probe judgement and the page once they're ready.

## TURNPRO1 v15: turning pro, the road after the debut

`SCORE depth=6 play=6 general=6`

**Below the bar on both depth and play. Keep the two debut nights and the kind chip on every row, but rebuild the favour before it's built.**

**Depth 6.** v15 fixed the direction of the favour, but in doing so it turned the favour into a reward for doing what the house wants. That makes the house's preferred kind of fight the right booking nearly every time. The probe's own tables show it:

- **At the ticket house, the house's preference is the answer.** The bot that keeps the house happy and the bot that chases reputation are the same player. Gym cash differs by $117 to $128, the name by 0.3 to 0.4, and both are ranked 94% of the time. Booking tune-ups (the win-chaser) is about $2,000 behind and 8 reputation behind. Its only gain is about 1.1 more wins than losses. With the favour on, going against the house costs a further $1,400 to $1,800 by week 80.
- **At the guarantee house there's a real trade.** Chasing the name gives +4.6 reputation and about the same cash, for 1.6 fewer net wins. But the favour then pays the keeper $3,560 to $4,190 in ticket blocks by week 80. At about $4.85 a week per reputation point with room in the gym, 4.6 reputation is worth about $900 over the same stretch. So the money settles it, and the keeper wins.
- **One of the four debut nights is a trap.** The guarantee house's test night reads "build beats test" at seats 48. It's 8 debut wins behind for $3 less and +2.8 reputation.
- **The "moment" never enters the rules.** The map says a hard last night, a gym with no room, or a title two wins away changes which kind is right. Only the date gap (6 against 12 weeks) and the room in the gym are real rules. Nothing reads your boxer's form. So the depth the map claims comes from the player's story, not the game.

**Play 6.** The fight-by-fight beat is good. Every row shows what a win makes and how the favour moves, and climbing toward top of the bill gives you something to look forward to. But once you see that pleasing the house pays, every set plays itself. The headline reward, the area title shot, is booked 0% of the time in the main run.

**General 6.** It's clear, it reuses data the game already has (`ProLean.LEAN_KIND` is the house's lean), and it cuts the dead asks. But the map contradicts itself in places that would be built wrong:

- Sections 3d, 7 and 11 and the golden path still say a tune-up win pays +2. v15 made it +1.
- Section 7's favour head still says "brings only tune-ups… offers stand 4 days", and build item 6 still builds the 4-day set. v15 cut both.
- Section 0a has the card read 500 nights per debutant, but bar 4 rules on 1,000 per boxer.
- The guarantee house's +$300 a purse goes to the boxer, while the $250 ticket block goes to the gym. The page never says who gets which.

**Missing options**

- **Spending the favour.** You can only bank it today. There's no "spend 2 favour on a date I choose / a named opponent outside the band / the title shot early".
- **Rest as a choice.** You can't turn down a set to rest a boxer who's just come off a hard night without it counting as defiance.
- **Leaving the house.** The map cuts switching houses. That leaves no exit when a gym is stuck under 3 favour.
- **Your boxer's say.** The boxer's wish is cut. Nothing on the road reacts to Heart or Confidence.

**Useless as drawn**

- **The guarantee test night.** It loses to the build night on every axis except +3 reputation.
- **The payday row.** Its favour is 0, and a bot only books it when there's no step up on the table. It's filler unless it pays something the step up doesn't.
- **The title row.** It's never fought in the main run.
- **"Later +2".** It's fine, but it only shows up for weight or injury, and rarely.

**What each option changes**

- **The house** changes the debut odds: 53–63 wins in 100 at the ticket house against 67–75 at the guarantee house. It also changes cash (the ticket house is $1,900 to $2,100 ahead in a gym with room) and reputation (+8 to +13).
- **The debut night** changes the odds by about 10 wins in 100, against about +7 reputation and $1,250, at the ticket house only.
- **The kind of fight** changes reputation (+1 against +5), the next date (6 against 12 weeks) and the favour (±1).
- **The favour** changes when fights are dated (3 weeks later under 3). At 8 or more it adds $250 a fight to the gym, +$300 to the boxer's purse at the guarantee house, and opens the title row at the ticket house.

**Real boxing.** Promoters do reward a trainer who takes their matchmaking with better slots on the card. But that loyalty runs both ways. Top Rank kept Terence Crawford in hand-picked fights for years, and Crawford's camp left in 2021 over the matchmaking. A promoter's road becomes the wrong road once your boxer outgrows it. v15 rewards loyalty for good and never turns it into a cost.

**Code check**

I couldn't open main from 23 Nov: fetching failed again on the GitHub login. I read my copy of `origin/main` at commit `8d34d5c4` (21 Nov, 10:03 Cyprus time) with `git show` and `git grep` only, and changed nothing. The map cites a tree from 22 Nov, one day newer. So "not in my copy" below doesn't mean it's wrong on main.

**True in my copy:** `ProLean.gd` :7, :8 (`{"hf":"tune","bow":"above"}`), `extra` :12-33, `pro_fights` :36-37. `ProLadder._make_offers` :175-216 with the step up left out at :209, `_drop_dominated`, `OFFER_DAYS` :31, `LEAD_DAYS` :32, `ROUNDS_TITLE` :36, `day_events` :134-137, `join` :93-107, `division_for` :43-49. `WorldRank` :5 and :164-168. `BoutRules` :114-115. `BoutFinish` :92-122. `Bouts.accept` :192-200. `DebutRead.card` :17-24 (never reads `debut_weeks`). `ProCall` `who_calls`, `promoters`, `AGE_STOP`, `calls_open`, `expires`, `_apply_later`, `LOST_CUT_A_WEEK`. `Roster` `check_pro`, `pro_ready`, `debut_day`, `decline_pro`. `Needs` :67-70, :140-141, :167-168. `Membership` :15-16 and :45-53. `GymSpend.member_cap` :160-161.

**Right content, lines off by 1 to 3:** `ProLadder.book` is at :336-367 (it writes the bout at :359-361 with no kind, as the map says; it calls `note_choice` at :353). `result` :371-377, `_review_streak` :404-416, `ask_rows` :320-332, `road` :420-434. In `Matchmaking.gd`, every cited line sits 1 to 3 lines earlier (for example, `note_choice` :195-200, `pay_of` :215-224, `_take_belt` :300-308). `ProFights` :116 and `KIND_WORD` :20. `ProOffer._house` :104-148, with the win chance at :131. `Roster.turn_pro` runs :265-315.

**Not in my copy, so I can't judge them:** `DebutPick.gd` (the whole file, and with it every "two debutants a house" line). Also the "VS (name)" line in `ProOffer` and the probe files: `tools/turnprobe15*.gd`, `docs/TURNPROBE14_RESULT.md` and `docs/TURNPROBE15_RESULT.md`. So I couldn't read how the probe builds the $250 block, the 3-week delay, the title door or the keeper bot.

**Wrong in my copy (they may have changed on 22 Nov):**

1. **`DebutOpp` constants :15-17.** There are none. The style, threat and weakness are written inside `make` (:31-33).
2. **`DebutOpp.name_for`.** It's at :14-16 and picks by day and sex only (`names[posmod(day, 4)]`). It doesn't use the length of the house's name.
3. **`ProOfferWire.make` :38 calls DebutPick.** It calls `sync`. The debut gap comes from `ProCall.promoters` (3.0 at the ticket house, 6.0 at the guarantee house).

Nothing new in v15 (the favour, the kind kept on the bout, the block, the delay, two debutants a house) is in my copy, which matches the map's own "nothing here is built".

**The probe**

The money and the card are measured honestly, and bar 4 (the card reads each boxer's own nights) is a real fix. But several bars pass while the choice stays shallow:

- **Bars 7, 8 and 11 count three bots, but two of them play the same road.** At the ticket house the keeper and the name-chaser are within $130 and 0.4 reputation. Two bots differing by a line only proves the other bot differs.
- **Bar 15, as tightened, demands the dominant pull.** It requires the keeper to gain and the rebel to lose. It proves the favour punishes going against the house, which is exactly why the house's kind becomes the answer.
- **Bar 13 is true by construction.** A bot told to book step ups books step ups.
- **Bar 17 checks that both kinds are on the table,** not that both are ever worth booking.
- **Bars 5, 9 and 16 compare averages.** Each debut loss costs $1,844 at week 40, but no bar weighs that risk.
- **The verdict's own caveat is the real gap.** No bot reads form, room or a nearby title, so "the moment" is never tested.

What I'd measure instead:

1. **A look-ahead bot against the obedient one.** A bot that picks the best row each set (play each row ahead 200 nights) against "always book the house's kind". Pass when obeying loses a line in at least half the house × gym cells.
2. **The share of sets where the look-ahead bot goes against the house:** 30% or more at each house.
3. **Keeper and name-chaser at the ticket house must differ by a line,** or they count as one road.
4. **Title shots fought per 100 careers:** 25 or more by week 80.
5. **Fights fought by week 80 for each road,** since the 12-week gap after a step up is a real cost.
6. **Risk alongside the averages:** the share of careers that end the window with less cash than the plain guarantee house.
7. **A blind test with two players over the six fights.** Write down which rule they say they're following, and from which set.

**To reach 10/10** (most important first)

1. **Make the favour a currency you spend.** Keep +1 for the house's kind and −1 for the other. At 6 or more, add one ask per set: "spend 2 favour" for a date you pick (±2 weeks), a named opponent outside the band, or the title shot one win early. Then obeying earns the favour and spending it is the decision. Measure with point 1 above.
2. **Make the house's road wear out.** After three step ups in a row, the next step up's read drops 3 and its stoppage risk rises (use the pro damage ledger the world already keeps). After three tune-ups in a row, each tune-up win pays 0 reputation and costs a fan (the game's soft-win rule already costs one), and the purse stays put. Then every road peaks and turns, and the right pick depends on what came before.
3. **Put form into the rules, so the moment is real.** A hard night (cut, knocked down, or a body place hurt at the final bell) takes 4 off the next fight's read unless the gap is 8 weeks or more. Show it on the row ("a hard night last time: −4 on this read"). A tune-up then rests your boxer, and the step up costs something the player can see.
4. **Make the title actually happen.** Open the ticket house's title row at favour 7 with 3 pro wins, or price it as the thing you spend favour on (item 1). Target 25 or more title shots per 100 careers.
5. **Fix or cut the guarantee test night.** Pay it +1 reputation for every 6 seats (not 8) and the table's last seat, or drop it so that house has only the build night. Today it's dominated.
6. **Give the payday a reason to exist.** Make it pay something the step up doesn't, such as a favour +1 at both houses or double the ticket block, or cut the row.
7. **Clean the map before anyone builds it.**
   - Every "+2" becomes "+1" (sections 3d, 7 and 11, the golden path).
   - Cut the "only tune-ups / 4 days" lines and build item 6's 4-day set.
   - Settle 500 against 1,000 nights.
   - Say who gets which money: the $250 to the gym, the $300 to the boxer.
8. **Show the risk next to the debut choice.** Draw the band and the loss line on each debut card ("a loss: a rebuild fight first, −2 reputation"). The map already allows the band.
9. **Re-run the probe** with the seven measures above. Then put it back to two fresh critics.

My 10/10 is the NEXT FIGHT page on the road. It has the favour pips with what 8 opens and what under 3 costs, and a row of your boxer's form and facts. Each offer row shows the win band, what a win makes, the favour move and the date gap. Under the step-up row, a "hold out for the title" line spells out the next two bookings. A side card lists what changes the pick, and a strip shows the road so far. The one gold thing is the BOOK button on the house's pick.

The page is example state. It still draws today's favour (banked, never spent), so items 1 to 3 would add a "spend 2 favour" ask under the favour strip and a "hard night: −4" note on the step-up row.

```html
<!doctype html><html><head><meta charset="utf-8"><title>TURNPRO1 v15 - the road's next fight, at 10/10 (critic)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#c9b08a;font-family:'IBM Plex Mono',monospace;font-size:15px;color:#2b2620;position:relative}
.d{font-family:'Bebas Neue',sans-serif;letter-spacing:1px}
#top{height:64px;background:#15181c;color:#d9dde3;display:flex;align-items:center;padding:0 28px;gap:28px;font-size:14px}
#top .gym{font-size:28px;color:#fff}#top .sp{flex:1}
#top .cont{background:#2f7d4a;color:#fff;padding:8px 18px;font-size:22px}
#board{position:absolute;left:40px;top:88px;width:1840px;height:970px;background:#f3efe6;border:14px solid #b9bec4;box-shadow:0 6px 0 #8a7a62}
#hdr{position:absolute;left:32px;top:18px;right:32px;display:flex;align-items:flex-end;gap:22px}
#hdr .nm{font-size:56px;line-height:50px}#hdr .role{font-size:34px;line-height:34px;color:#4a5360}
#hdr .sub{font-size:14px;color:#5b5348;padding-bottom:6px}
.card{background:#fff;border:1px solid #d8cfbf;padding:12px 16px}
.card h3{font-size:26px;line-height:26px;margin-bottom:6px}
#fav{position:absolute;left:32px;top:88px;width:1300px;height:128px}
.pips{display:flex;gap:8px;margin:4px 0 8px}.pips i{width:46px;height:20px;border:2px solid #4a5360;background:#f3efe6}.pips i.on{background:#4a5360}
.pips .mk{width:2px;background:#2b2620;margin:0 4px}
.row2{display:flex;gap:26px;font-size:13px}.row2 b{font-weight:600}
#facts{position:absolute;left:32px;top:230px;width:1300px;height:70px;display:flex;align-items:center;gap:34px}
#facts h3{margin:0}#facts span{font-size:14px}
#offers{position:absolute;left:32px;top:316px;width:1300px}
.hd,.of{display:grid;grid-template-columns:140px 150px 150px 170px 100px 110px 120px 100px 1fr;gap:10px;align-items:center}
.hd{font-size:12px;color:#5b5348;padding:0 16px 6px}
.of{background:#fff;border:1px solid #d8cfbf;padding:14px 16px;margin-bottom:10px;font-size:14px}
.chip{display:inline-block;background:#4a5360;color:#fff;padding:4px 10px;font-size:20px}
.tag{display:block;font-size:12px;color:#4a5360;margin-top:4px}
.btn{border:2px solid #2b2620;background:#f3efe6;padding:8px 10px;font-size:20px;text-align:center}
.btn.g{background:#c9971f;border-color:#8f6a12;color:#1f1a10}
.mut{font-size:12px;color:#5b5348;display:block}
.hold{background:#ece6d8;border:1px dashed #8a7a62;margin:-6px 0 10px 0;padding:10px 16px;font-size:14px}
.hold b{font-family:'Bebas Neue',sans-serif;font-size:22px;letter-spacing:1px;margin-right:12px}
#side{position:absolute;right:32px;top:88px;width:440px}
#side p{font-size:14px;margin:10px 0;padding-left:12px;border-left:4px solid #4a5360}
#side .note{font-size:12px;color:#5b5348;margin-top:12px}
#road{position:absolute;left:32px;right:32px;top:740px}
.steps{display:flex;gap:12px}
.st{flex:1;border:1px solid #d8cfbf;background:#fbf8f1;padding:10px 12px;font-size:13px}
.st .k{font-size:22px;line-height:22px}
.st.now{border:2px dashed #4a5360;background:#f3efe6}
#foot{position:absolute;left:32px;bottom:10px;font-size:12px;color:#7b7266}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 14 Sep · Week 37</span><span class="sp"></span><span>$8,420 · running +$140 a week</span><span class="cont d">CONTINUE ▸ TO MON 21 SEP, THE OFFERS STAND UNTIL THEN</span></div>
<div id="board">
 <div id="hdr"><span class="nm d">LUCY JACKSON</span><span class="role d">THE TICKET HOUSE · NEXT FIGHT</span><span class="sub">fight 4 of the road · the offers stand 7 days</span></div>

 <div id="fav" class="card"><h3 class="d">FAVOUR 6 OF 10 · TOP OF THE BILL AT 8</h3>
  <div class="pips"><i class="on"></i><i class="on"></i><i class="mk"></i><i class="on"></i><i class="on"></i><i class="on"></i><i class="on"></i><i></i><i class="mk"></i><i></i><i></i><i></i></div>
  <div class="row2"><span><b>At 8:</b> a $250 ticket block to the gym each fight · an area title shot once your boxer has 4 pro wins (you have 3)</span><span><b>Under 3:</b> the fight is dated 3 weeks later</span><span>The house wants step ups</span></div>
 </div>

 <div id="facts" class="card"><h3 class="d">FORM AND FACTS</h3><span>Pro record 3-0 · ranked #18</span><span>Last fight a hard night: 3 weeks since</span><span>Room for 12 more members; 3 reputation brings about 2</span></div>

 <div id="offers">
  <div class="hd"><span>KIND</span><span>THE OPPONENT</span><span>WIN CHANCE</span><span>A WIN MAKES</span><span>FAVOUR</span><span>DATE</span><span>NEXT NIGHT</span><span>TO THE GYM*</span><span>STOPPAGE RISK</span></div>
  <div class="of"><span><span class="chip d">TUNE-UP</span></span><span>Unranked · 6-4</span><span>about 81<span class="mut">76 to 86</span></span><span>+1 reputation<span class="mut">no place moves</span></span><span>favour −1</span><span>6 weeks out</span><span>6 weeks after</span><span>$810</span><span style="display:flex;justify-content:space-between;align-items:center">low <span class="btn d">BOOK</span></span></div>
  <div class="of"><span><span class="chip d">STEP UP</span><span class="tag">the house's pick</span></span><span>Ranked #14 · 9-2</span><span>about 50<span class="mut">44 to 56</span></span><span>+5 reputation<span class="mut">takes #14</span></span><span>favour +1</span><span>6 weeks out</span><span>12 weeks after</span><span>$1,020</span><span style="display:flex;justify-content:space-between;align-items:center">even <span class="btn g d">BOOK</span></span></div>
  <div class="hold"><b>HOLD OUT FOR THE TITLE</b>Book this step up and win: favour 7 and 4 pro wins. Book one more step up: favour 8, top of the bill, and the area title row opens in the set after.</div>
  <div class="of"><span><span class="chip d">PAYDAY</span></span><span>Ranked #7 · 14-1</span><span>about 31<span class="mut">24 to 38</span></span><span>+5 reputation<span class="mut">takes #7</span></span><span>favour 0</span><span>6 weeks out</span><span>12 weeks after</span><span>$1,260</span><span style="display:flex;justify-content:space-between;align-items:center">high <span class="btn d">BOOK</span></span></div>
  <div class="mut" style="padding-left:16px">* the gym's 25% of purse and tickets, example figures · a loss: −2 reputation (−4 stopped) and a rebuild fight before any step up · Scout $250 narrows a band</div>
 </div>

 <div id="side" class="card"><h3 class="d">WHAT CHANGES THE PICK</h3>
  <p>A hard night last time: a tune-up rests the chin.</p>
  <p>No room for members: the name buys a seat on the table, not members.</p>
  <p>Title two wins away: the house wants step ups.</p>
  <div class="note">Each line reads your boxer's own state this week. None tells you which row to book.</div>
 </div>

 <div id="road" class="card"><h3 class="d">ROAD SO FAR · FAVOUR STARTED AT 5</h3>
  <div class="steps">
   <div class="st"><span class="k d">THE DEBUT · TEST NIGHT</span><br>Won on points · +5 reputation and the seats bonus · the table's last seat<br>favour +1 → 6</div>
   <div class="st"><span class="k d">FIGHT 2 · TUNE-UP</span><br>Won · +1 reputation · 6 weeks to the next night<br>favour −1 → 5</div>
   <div class="st"><span class="k d">FIGHT 3 · STEP UP</span><br>Won · +5 reputation · took #18 · a hard night<br>favour +1 → 6</div>
   <div class="st now"><span class="k d">FIGHT 4 · YOUR PICK</span><br>3-0 · favour 6 · two step ups from the title row</div>
  </div>
 </div>
 <div id="foot">Kalli · critic page · TURNPRO1 v15 · example state, not engine output · names in headers only · gold on one thing, green on Continue only</div>
</div>
</body></html>
```

I'd keep turning pro but change it before it's built: depth 6, play 6, general 6, under the 8/8 bar on both. v15's favour rewards you for booking what the house wants, so that becomes the right answer nearly every time. At the ticket house, keeping the house happy and chasing the name come out the same.

The fixes that matter most:
- Let you spend favour on something.
- Make the house's road wear out after three fights of the same kind.
- Put your boxer's form into the rules, so a hard night actually changes the pick.

I checked the code against my copy from 21 Nov, because fetching the newer version failed on the GitHub login. I changed nothing. The two-debutant search (`DebutPick.gd`) and the probe files aren't in my copy, so I couldn't check them.

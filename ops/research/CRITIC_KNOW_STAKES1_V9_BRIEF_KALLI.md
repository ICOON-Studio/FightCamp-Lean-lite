# CRITIC_KNOW_STAKES1_V9_BRIEF_KALLI - Kalli answer (seat queue SQ312)

Brief: research/CRITIC_KNOW_STAKES1_V9_BRIEF.md
Sent: 2026-11-23 15:40 | collected: 2026-11-23 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm on it. First I'll check the code at 7fc74f4e1 or newer if I can reach it, then score v9 and draw the 10/10.

The code check and the 10/10 page are underway. I'll send the scores, the code findings, the probe judgement and the page once they're ready.

**KNOW_STAKES1 v9: the prospect boxes Saturday, the trial runs by the day**

`SCORE depth=7 play=8 general=7`

Play reaches the bar; depth doesn't. My verdict is to keep it. One change is still missing, and section 7 of the map already names it.

**The central claim: are hunch, look and wait each the right call some of the time?** Yes, for the first time. Among decisive decisions the hunch is best 45.4% of the time, the trial 22.2% and waiting 32.4%. The hunch still leads, and it dominates in one situation: a rival who rates the prospect above the level, with a window that opens inside a week and no bout before it.

The problem is what "best" is worth. In 82% of prospects, the best call beats the second-best by less than $250. So the three calls are each right some of the time, but they are usually right by very little. The choice is real in about a quarter of prospects.

**The dates on the card can make the choice for you.** The map says it plainly: "the two dates on the card say which." A bout before the window means wait; a window opening tomorrow means the hunch. When two dates on a strip decide it, the player is reading a timetable, not making a call. That is fine for the first ten prospects and flat by the thirtieth.

**The deadline.** Basing the window only on what the rival sees is right. It is one rule, read off a look that is already on the card, and the stacked minus-7 for a good record is gone. Letting the window run out now writes a news line, which makes it different from Pass. Good.

**The options, and what each changes**
- **Sign now.** The 12-week bond, at most $3,000, is the bet. Its odds line ("1 first look in 3 ends under the level") is honest and measured.
- **Start the trial.** This is the best piece of v9. Stopping any evening turns a fixed purchase into press-your-luck, and it halves the prospects lost during a trial (16.2% down to 7.5%). Two weaknesses: the days run in a fixed order, so a doubt about skills still pays for the body day first, and $36 a day was chosen as "the cheapest price at which thinking beats always buying." That is a price tuned to pass a bar, not one the game explains.
- **Wait for the bout.** It now has a reason to exist. Real boxing works this way too: clubs and promoters judge a prospect by watching them box at a show, because you can't see someone under fire in the gym.
- **Pass.** Freeing the place today is the real difference from letting the window run out. It's useful when a second name is due.
- **Missing:** a call that isn't a look. Two of the three calls are ways of looking again, so one stands alone only when the other two both go wrong. The map names the fix (a short, dearer bond) and leaves it out unmeasured. That is the gap between 7 and 8 on depth.
- **Missing:** choosing tomorrow's question in the trial.
- **Useless:** nothing outright. Folding the test day into day 1 of the trial was the right cut.

**Code check**

The fetch failed again on the GitHub login, so 7fc74f4e1 isn't in my copy. I read origin/main `8d34d5c4` (21 Nov, 10:03 Cyprus time, UTC+2), which is two days older than the map, using only read-only git.

Files I read:
- `KnowReads.gd` (:1-36, :56-80, :105-119)
- `Leaving.gd` (:25-75, :95-113)
- `CardAsk.gd` (:20-30)
- `VisitWire.gd` (:140-160)
- `Clock.gd` (:41-70)
- `ui/modals/Trial.gd` (:1-43)
- `Fighters.gd` (:214-226)
- `Roster.gd` (:85-145)
- `RecruitPanel.gd` (:44-48, :102-106)
- `Career.gd` (:119-124)
- `Data.gd`, `Knowledge.gd` and `KnowWire.gd` by searching only

**True in my copy**
- C1, the prices: `KnowReads.gd` :8-11 and :28. The trial is $500 (4 weeks × $250 ÷ 2).
- C3: `_apply_trial` :105-111 reads body 24 and skills 24, plus under fire 8 only if it's already open.
- C5: `let_go_price` at :65-73 prices reputation only.
- `Fighters.gd` :221-223 draws the true value plus or minus 5.
- `Roster.gd` :88-89, :103-105 (no caller) and :143.
- `RecruitPanel.gd` :46-47 and :104.
- `KNOWN_SHARE` 0.6 at :43, and `share_gone` exists at :225.

**Wrong or incomplete**
- **C2 is only partly true.** The test day gives body 16 only for a prospect with fewer than 5 bouts; from 5 bouts on it gives 8 (`KnowReads.gd` :114-119). The map's "day 1 = body 16 wide to about 7" is true only for novices.
- **C4's caller list is loose.** `BoutFinish` (:179, :187), `Roster` (:143) and `Sim` (:209, :297) call `KnowWire`, not `Knowledge`. `KnowWire` is the only file that uses `Knowledge`, and no game code calls `KnowReads` at all. No screen under `scripts/ui` reads any of the three: that part is true.
- **`bout_day` is already used.** It is a fighter's own booked bout in `AskBout`, `Sim`, `FightPrep`, `WeekStrip` and others. A prospect's bout field needs its own name.
- **The trial screen shows exact numbers.** `ui/modals/Trial.gd` :2 says "stats (exact now)", and the verdict is potential 80 or more (`Roster.gd` :117). The day-by-day ladder means rebuilding this screen, not adding to it.
- **The clock can't stop for a prospect yet.** `Clock.next_stop` (:41-69) stops for a trial Monday and the visitor's last day only. There are no stops for a prospect's bout or window.
- **Line shifts:** `PROSPECTS` is at `Data.gd` :221 and the loop at `Career.gd` :121.

**Not in my copy:** `TRIAL_LOSS`, `trial_lost` and `trial_came`. The map says they landed after 21 Nov, which fits, but I can't confirm it.

**The probe**

`tools/knowstakes9.gd` and `docs/KNOWSTAKES9_RESULT.md` aren't in my copy, so I'm judging the probe from the result text alone.

- **The first half of B5 measures the price, not the decision.** A full trial costs $252 and the bar is $250, so this half passes because the trial is expensive. The result says so itself: at $125 a week it reads 26.8%. Drop that half.
- **The second half of B5 is the right bar, and it fails at 17.8% against 30.** That is the honest gap the map names. It matters: it means most choices don't change the outcome by much.
- **B2 and B3 pass on thin margins.** B2 beats always-trial by only $32 (low end $19), and B3 passes by 0.7 of a point. Both moved with the trial's price and with how the selective player is written. A bar that passes only at one tuned price could also pass while the mechanic is shallow.
- **The pure wait call is a straw man.** It waits for the bout even inside an open window and loses 40.5% of prospects that way. A wait that never sits inside an open window would show what waiting is really worth.
- **The no-clock control was the wrong bar.** A hunch that is right 27% of the time without a clock is fine: reads cost money when the first look was right. The useful comparison, which the probe has, is that the clock moves the hunch from 27% to 45%.
- **Not measured:** a bout that falls inside a trial, and a club short of cash (the map says so itself).

**What I'd measure instead:**
1. Best beats second by $250 or more, in 30% or more of all prospects, at two trial prices ($36 and $18 a day).
2. A "timetable bot" that reads only the two dates and never the ranges. If it scores within $100 of the selective player, the dates are making the choice, not the reads.
3. B2 and B3 across three ways of writing the selective player, not one.

**To reach 10/10, most important first**
1. **Add a fourth call that isn't a look:** sign short, at $325 a week bound 4 weeks, then keep at $250 or let go free of cash. Probe it against the $250-or-more best-over-second bar. This is the map's own named lever.
2. **Let the player pick tomorrow's question in the trial:** body, skills, the pad test, or the hard spar, one per day. A doubt about skills shouldn't pay for a body day first. Measure whether the share of flipped calls rises above 30%.
3. **Make the dates a trade-off, not an answer.** About a third of bouts should fall inside the window, so watching risks the rival. Test it with the timetable bot above.
4. **Explain the trial price in the game's own terms:** a day's stipend plus the evening's pad time taken from your boxers. Then $36 means something to the player.
5. **Bout night pauses the trial and costs no trial day.** My page draws it this way. It's simpler than the map's rule, which swaps that day's question for under fire.
6. **Name the test-day rule honestly:** body 16 under 5 bouts, 8 from 5 bouts on.
7. **Rebuild `Trial.gd` as the day ladder,** without exact numbers or the 80-potential verdict.
8. **Add the clock stops** for a prospect's bout and their window's first and last day, in `Clock.next_stop`.
9. **Give the prospect's bout a field name other than `bout_day`.**
10. **Re-run the probe:** drop B5's first half, use a smarter wait, test three selective players, a club short of cash, and the real game loop.

The page below is the signing card at 10/10. It has gold only on START THE TRIAL, green only on Continue, and sign short marked as my proposal. Everything on it is example state, not engine output.

```html
<!doctype html><html><head><meta charset="utf-8"><title>KNOW_STAKES1 v9 - the signing card at 10/10 (critic)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#c9b08a;font-family:'IBM Plex Mono',monospace;font-size:15px;color:#2b2620;position:relative}
.d{font-family:'Bebas Neue',sans-serif;letter-spacing:1px}
#top{height:64px;background:#15181c;color:#d9dde3;display:flex;align-items:center;padding:0 28px;gap:28px;font-size:14px}
#top .gym{font-size:28px;color:#fff}#top .sp{flex:1}
#top .cont{background:#2f7d4a;color:#fff;padding:8px 18px;font-size:22px}
#board{position:absolute;left:40px;top:80px;width:1840px;height:988px;background:#f3efe6;border:14px solid #b9bec4;box-shadow:0 6px 0 #8a7a62}
#hdr{position:absolute;left:32px;top:14px;right:32px;display:flex;align-items:flex-end;gap:22px}
#hdr .nm{font-size:56px;line-height:50px}#hdr .role{font-size:30px;line-height:32px;color:#4a5360}
#hdr .sub{font-size:13px;color:#5b5348;padding-bottom:6px}
.card{position:absolute;background:#fff;border:1px solid #d8cfbf;padding:12px 16px}
.card h3{font-size:26px;line-height:26px;margin-bottom:8px}
.mut{font-size:12px;color:#5b5348}
.g{display:grid;grid-template-columns:130px 560px 1fr;align-items:center;gap:12px;margin:6px 0}
.g .lab{font-size:22px}
.ax{position:relative;height:34px;background:repeating-linear-gradient(90deg,#efe9dd 0 1px,transparent 1px 93.33px);border-bottom:2px solid #b9b0a0}
.b{position:absolute;height:12px}
.you{top:3px;background:#4a5360}.riv{top:18px;background:repeating-linear-gradient(45deg,#a08c6c 0 5px,#cdbd9f 5px 10px)}
.unk{top:3px;height:27px;background:repeating-linear-gradient(45deg,#d6cfc2 0 6px,#ebe5da 6px 12px)}
.lv{position:absolute;top:-6px;left:186px;width:2px;height:46px;background:#b5412f}
.v{font-size:13px}
.scale{display:flex;justify-content:space-between;width:572px;margin-left:136px;font-size:12px;color:#7b7266}
.cal{display:flex;gap:3px;margin:6px 0 4px}
.cal i{flex:1;height:58px;border:1px solid #cfc5b3;background:#fbf8f1;font-style:normal;font-size:12px;text-align:center;padding-top:4px;line-height:16px}
.cal i.s{background:#e3ecdc;border-color:#8fa883}
.cal i.w{background:#e8c9bf;border-color:#b5412f}
.cal i.t{border:2px solid #2b2620}
.cal i.bt{background:#2b2620;color:#f3efe6;border-color:#2b2620}
.band{display:flex;gap:3px;font-size:12px;margin-top:2px}
.band span{text-align:center;padding:3px 0;border-top:3px solid}
.legend{font-size:13px;line-height:20px;margin-top:6px}
.cap{font-size:15px;font-weight:600;margin-top:8px;border-top:1px dashed #b9b0a0;padding-top:8px}
.opt{top:430px;width:344px;height:392px;display:flex;flex-direction:column}
.opt h3{margin-bottom:4px}
.opt .tag{font-size:12px;background:#ece6d8;border:1px dashed #8a7a62;padding:2px 6px;margin-bottom:6px;align-self:flex-start}
.opt .cost{font-size:14px;font-weight:600;margin-bottom:6px;line-height:19px}
.opt p{font-size:13px;line-height:18px;margin-bottom:6px}
.opt .odds{margin-top:auto;font-size:13px;line-height:18px;border-top:1px dashed #b9b0a0;padding-top:8px;margin-bottom:8px}
.lad{font-size:12px;line-height:17px;margin-bottom:4px}
.lad div{display:grid;grid-template-columns:58px 1fr;border-bottom:1px dotted #d8cfbf}
.lad b{font-weight:600}
.lad .bo{background:#f1ece2}
.btn{border:2px solid #2b2620;background:#f3efe6;padding:7px 0;font-size:22px;text-align:center}
.btn.gold{background:#c9971f;border-color:#8f6a12;color:#1f1a10}
#last{left:32px;top:834px;width:1776px;height:88px;background:#fbf8f1}
#last div{font-size:14px;margin:3px 0}
#foot{position:absolute;left:32px;bottom:10px;font-size:12px;color:#7b7266}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 11 Jan 2027 · Week 54</span><span class="sp"></span><span>$7,860 · running +$95 a week</span><span class="cont d">CONTINUE ▸ TO SAT 16 JAN, THE PROSPECT BOXES</span></div>
<div id="board">
 <div id="hdr"><span class="nm d">NIA OKAFOR</span><span class="role d">PROSPECT · 19 · 60 KG · ORTHODOX · 3-1</span><span class="sub">Fighters › Find a fighter · brought by the scout · places 2 of 3 used · example state, not engine output</span></div>

 <div class="card" style="left:32px;top:80px;width:900px;height:336px">
  <h3 class="d">YOUR LOOK AGAINST LYNN AC'S LOOK · THE LEVEL HERE IS 60</h3>
  <div class="mut" style="margin-bottom:4px">Solid bar: your look. Hatched bar: Lynn AC's look, with its own misread. Red line: the region's level.</div>
  <div class="g"><span class="lab d">BODY</span><div class="ax"><div class="b you" style="left:149px;width:149px"></div><div class="b riv" style="left:168px;width:112px"></div><div class="lv"></div></div><span class="v">yours 56-72 · theirs 58-70</span></div>
  <div class="g"><span class="lab d">SKILLS</span><div class="ax"><div class="b you" style="left:93px;width:224px"></div><div class="b riv" style="left:112px;width:131px"></div><div class="lv"></div></div><span class="v">yours 50-74 · theirs 52-66</span></div>
  <div class="g"><span class="lab d">UNDER FIRE</span><div class="ax"><div class="b unk" style="left:0;width:560px"></div><div class="lv"></div></div><span class="v">not seen yet</span></div>
  <div class="g"><span class="lab d">CEILING</span><div class="ax"><div class="b you" style="left:280px;width:261px"></div><div class="lv"></div></div><span class="v">up to 70-98 · theirs not shown</span></div>
  <div class="scale"><span>40</span><span>50</span><span>60</span><span>70</span><span>80</span><span>90</span><span>100</span></div>
  <div style="font-size:14px;margin-top:6px">Body and skills straddle the level: the first look is wrong about 1 time in 3 at this distance.</div>
 </div>

 <div class="card" style="left:952px;top:80px;width:856px;height:336px">
  <h3 class="d">THE TWO DATES · MON 11 TO SUN 31 JAN</h3>
  <div class="cal"><i class="t s">M11<br>today</i><i class="s">T12</i><i class="s">W13</i><i class="s">T14</i><i class="s">F15</i><i class="bt">S16<br>bout</i><i class="s">S17</i><i class="w">M18</i><i class="w">T19</i><i class="w">W20</i><i class="w">T21</i><i class="w">F22</i><i class="w">S23</i><i class="w">S24</i><i>M25</i><i>T26</i><i>W27</i><i>T28</i><i>F29</i><i>S30</i><i>S31</i></div>
  <div class="band"><span style="flex:7;border-color:#8fa883">SAFE · Mon 11 to Sun 17</span><span style="flex:7;border-color:#b5412f">LYNN AC'S WINDOW · Mon 18 to Sun 24</span><span style="flex:7;border-color:#cfc5b3">after: signed or still yours</span></div>
  <div class="legend">
   <b>The bout:</b> Boxes Sat 16 at the Lynn show, free to watch.<br>
   <b>The window:</b> Lynn AC want this one: they decide between Mon 18 and Sun 24, on any one of the seven days.<br>
   Their look sits above the level, so the window opens inside two weeks. ▸ Next name due: about Mon 1 Feb.
  </div>
  <div class="cap">The bout falls before the window: you can watch and still decide.</div>
 </div>

 <div class="card opt" style="left:32px"><h3 class="d">SIGN NOW</h3><div class="cost">$250 a week, bound 12 weeks · 0 days</div>
  <p>Letting go sooner pays the weeks left, up to $3,000.</p><p>Reads nothing more. The ranges stay as they are.</p>
  <div class="odds">About 1 first look in 3 like this ends under the level.</div><div class="btn d">SIGN NOW</div></div>

 <div class="card opt" style="left:390px"><h3 class="d">SIGN SHORT</h3><span class="tag">critic's proposal, not in the map</span><div class="cost">$325 a week, bound 4 weeks · 0 days</div>
  <p>Then keep at $250 or let go free of cash.</p><p>Costs $300 more than the long bond if they are good; caps a flop at $1,300.</p>
  <div class="odds">About 1 first look in 3 like this ends under the level.</div><div class="btn d">SIGN SHORT</div></div>

 <div class="card opt" style="left:748px"><h3 class="d">START THE TRIAL</h3><div class="cost">$36 a day, stop any evening, refunded if Lynn AC sign during it · a place held</div>
  <div class="lad">
   <div><b>D1</b><span>Tue 12 · fitness test: body</span></div>
   <div><b>D2-4</b><span>Wed 13 to Fri 15 · pads: skills</span></div>
   <div class="bo"><b>Sat 16</b><span>their bout: the trial waits, you watch</span></div>
   <div><b>D5</b><span>Sun 17 · pad test: the ceiling</span></div>
   <div><b>D6</b><span>Mon 18 · conditioning: body</span></div>
   <div><b>D7</b><span>Tue 19 · hard spar, optional: injury x2 that night, +15 tiredness</span></div>
  </div>
  <div class="odds">Tue 12 to Sun 17: 0 in 7 Lynn AC decide during it. Days 6-7 fall in the window: 2 in 7.</div><div class="btn gold d">START THE TRIAL</div></div>

 <div class="card opt" style="left:1106px"><h3 class="d">WAIT FOR THE BOUT</h3><div class="cost">$0, your evening Sat 16</div>
  <p>Under fire opens, about 23 wide; the record moves; the open session narrows body and skills a little.</p><p>Then a day to decide, Sun 17, before the window.</p>
  <div class="odds">0 in 7 Lynn AC decide before the bout.</div><div class="btn d">WAIT FOR THE BOUT</div></div>

 <div class="card opt" style="left:1464px"><h3 class="d">PASS</h3><div class="cost">$0, frees the place today</div>
  <p>They box on at Lynn AC; can be offered against your boxer within 26 weeks.</p>
  <div class="odds">Kept on the got-away list with your look. Letting the window run out writes it in the news instead.</div><div class="btn d">PASS</div></div>

 <div class="card" id="last"><h3 class="d" style="font-size:22px;margin-bottom:4px">LAST TIME</h3>
  <div>Got away: passed in March, your first look body 56-72. They box at 66 now, 4-1 at Lynn AC.</div>
  <div>Last trial: stopped on day 3. Skills 50-74 → 58-68: now clear of the level.</div></div>
 <div id="foot">Kalli · critic page · KNOW_STAKES1 v9 · example state, not engine output · names in headers only · gold on one thing, green on Continue only</div>
</div>
</body></html>
```

I've finished the KNOW_STAKES1 v9 critique, and it scores 7 for depth, 8 for play and 7 overall. Play reaches the bar but depth doesn't, so my verdict is to keep it and add one thing: a fourth call that isn't another look, a short dearer bond. Hunch, trial and waiting are now each right some of the time. But in 82% of prospects, the best call beats the second-best by less than $250.

The code check is on the 21 Nov copy again because the fetch failed. The test day reads body 16 only for prospects with fewer than 5 bouts, the field name `bout_day` is already taken, and the trial screen needs rebuilding. On my page the trial pauses on bout night instead of using the map's rule, which swaps that day's question for under fire; that's my recommendation, not the map's.

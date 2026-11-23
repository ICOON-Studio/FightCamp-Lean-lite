# CRITIC_KNOW_STAKES1_V8_BRIEF_KALLI - Kalli answer (seat queue SQ307)

Brief: research/CRITIC_KNOW_STAKES1_V8_BRIEF.md
Sent: 2026-11-23 12:40 | collected: 2026-11-23 13:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm on it. First I'll check the knowledge code and the probe file at the newest commit I can reach, then score v8 and draw the 10/10.

The code check and the 10/10 page are underway. I'll send the scores, the code findings, the probe judgement and the page once they're ready.

**KNOW_STAKES1 v8: signing a prospect under a rival's deadline**

`SCORE depth=6 play=6 general=7`

This is below the 8 and 8 bar. My verdict is to keep it, but change it before it ships.

**The central claim: are hunch, look and wait each right some of the time?** Barely. Among decisive decisions, the probe puts hunch best 56.4% of the time, look 30.8% and wait 12.8%. The bigger problem is that only 18.1% of decisions are decisive at all. In 82% of prospects, all three calls end the same way. So hunch dominates where it matters, and nothing matters most of the time. Wait is the weakest of the three: it misses its own 15% bar.

The scout filter is doing the work. Without it, hunch is best 78.3% of the time. The filter changes which prospects show up; it doesn't make the call itself harder. That means the spread between the three calls comes from who arrives, not from what you read on the card.

**The deadline (already decided, so judging how it's done).** The rival signs on one day of the 7 before the shown date. Their last day is 21, minus 7 for a good record, minus 7 if the rival's look is above the level, minus 0 to 6, with a floor of 7. Showing the rival's look and the date on the card is right: you can work out the odds yourself.

The weak spot is the stacking. My inference (I haven't measured this) is that the prospects worth having, a good record plus a rival who rates them, both push toward the floor of 7. Waiting is then almost never safe on exactly the prospects where waiting should be the clever call, which fits wait's 12.8%. The deadline should tighten on what the rival sees, not on what the player can already see.

**The options**
- **Sign now.** The 12-week bond, capped at $3,000 (12 weeks at the $250 stipend), is the right price for a hunch. It has real teeth.
- **Test day.** It is cheap and narrows body only, which is useful. It has no deadline risk, so it's nearly free information. It needs a cost in time or a place held.
- **Trial week.** It reads the most. Halving the ceiling width with the pad test, and refunding the fee if the rival signs during the week, are both good. Cutting the trial's body reading from 24 to 12 weakens the trial against the test day.
- **Wait.** It gives about +8 width per week on body and skills. That's too little to beat the window. Right now it's an option that loses to the others in most cases.
- **Pass.** It's fine, but it's only worth anything if a passed prospect comes back to hurt you, and v8 doesn't show that happening.
- **Missing.** Watching the prospect's own bout inside the window. It's a free, timed read of under fire, and it would give wait a reason to exist.
- **Useless as it stands.** Numbers coming back after a good read AND 12 weeks or 3 bouts. That's feedback too late to change the next signing.

**Code check**

The fetch failed again on the GitHub login, so I couldn't reach 37dce4f37 or anything newer. I read the 21 Nov snapshot, origin/main `8d34d5c4` (10:03 Cyprus time, UTC+2), with read-only git and the excerpts. Neither 37dce4f37 nor 053597329 exists in my copy.

**Not in my copy (these may have landed on 22–23 Nov):**
- `CardAsk.TRIAL_LOSS 0.25` at :26 doesn't exist; :26 is `REPEAT_MIN := 2`.
- The dice roll at `CardAsk` :137 doesn't exist; :134-136 is `trial_seen`.
- `VisitWire` `trial_came` isn't there. So v8's "the trial's 1-in-4 dice is gone" removes something my copy never had.

**Wrong in my copy:**
- The trial costs $500 in code: `KnowReads` :28 prices it at 4 weeks of half stipend (`GameMoney.FIGHTER_STIPEND` = 250, `GameMoney.gd:9`). The map says $125. The test day costs $0 in code, not $60.
- `KnowReads` :79-80 calls `is_hyped` and `clear_hype`, not `set_hyped`. Only tests call `set_hyped`.
- `Leaving.let_go_price` at :65-73 prices reputation only. Charging "the weeks left" on the bond is new work.

**True in my copy:**
- `Leaving` :29-30, :59-61, and :98 / :108-112 (the rival's rating is a flat 60).
- `KnowReads` :56-75, :105-111 and :114-119 (test day: body exposure 16).
- `Knowledge` :17-24, :38, :43, :106, :174-183, :251-261 and :372-376.
- `Roster` :88-89, :103-105 (no caller), :117 and :143.
- `KnowWire` :17-25.
- `HeadCoach` :36 and :69.
- `StatBlock` :24.

Several lines have moved by 1 to 8. `Data.PROSPECTS` is at :221, `SCOUT_SPREAD` at :216, the `Career` day-0 loop at :121-122, and `CardAsk` `walkin` at :141-159.

**No screen reads any of the knowledge code.** A search under `scripts/ui` finds no reference to `Knowledge`, `KnowWire` or `KnowReads`. The whole mechanic is invisible to the player today.

**The probe**

`tools/knowstakes8.gd` and `docs/KNOWSTAKES8_RESULT.md` aren't in my copy, so I'm judging the probe from the result text alone.

**The bars can pass while the mechanic is shallow.** B1 measures shares among decisive decisions only, but 82% of prospects aren't decisive. Wait could reach 15% of a small slice and the screen would still be a formality four times out of five. B2 and B4 pass, but they say nothing about how often the choice matters. B3 flips 18.0% against a bar of 25%, which means the reads too seldom change the answer.

**What I'd measure instead:**
- The share of all prospects where the best call beats the worst by more than one week's stipend in cash, or by reputation of the same value. Target: at least 40%.
- Regret per prospect for a bot that reads only the card (ranges, window and level), against the bot that sees the truth.
- Each call's best share, with the scout filter on and off, side by side. That shows whether the filter, not the player, is making the choice.
- One thing I can't confirm without the probe file: whether the three calls share the same dice. If they don't, part of every gap is noise.

**To reach 10/10, most important first**
1. Make more decisions matter. Widen the starting ranges so body or skills cross the level line more often, and make the bond bite on the misses. Target: 40% of prospects decisive.
2. Give wait its own read: the prospect's bout inside the window, which is free to watch and opens under fire. Wait should win when the bout comes before the rival's likely day.
3. Base the deadline on what the rival sees (their look against the level), and drop the stacked minus 7s for record and rival look. Keep the floor of 7.
4. Price the test day in time or a held place, so it isn't free information.
5. Put the trial's body reading back to 24. The trial should beat the test day on body, not just on skills.
6. Settle the trial price: $125 on the map versus $500 in code. Pick one and write it into `KnowReads`.
7. Charge the weeks left on the bond in `let_go_price`, and show that price on the card.
8. Show feedback on the next card, not 12 weeks later: one prospect that got away, and how your last trial's first look compared with what it found.
9. Wire one screen to `KnowWire`, so players can actually see the ranges.
10. Re-run the probe with shared dice and the measures above.

The page below shows the signing card at 10/10, with gold on START THE TRIAL WEEK and green only on Continue. Everything on it is example state, not engine output.

```html
<!doctype html><html><head><meta charset="utf-8"><title>KNOW_STAKES1 v8 - the signing decision at 10/10 (critic)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#c9b08a;font-family:'IBM Plex Mono',monospace;font-size:15px;color:#2b2620;position:relative}
.d{font-family:'Bebas Neue',sans-serif;letter-spacing:1px}
#top{height:64px;background:#15181c;color:#d9dde3;display:flex;align-items:center;padding:0 28px;gap:28px;font-size:14px}
#top .gym{font-size:28px;color:#fff}#top .sp{flex:1}
#top .cont{background:#2f7d4a;color:#fff;padding:8px 18px;font-size:22px}
#board{position:absolute;left:40px;top:88px;width:1840px;height:970px;background:#f3efe6;border:14px solid #b9bec4;box-shadow:0 6px 0 #8a7a62}
#hdr{position:absolute;left:32px;top:16px;right:32px;display:flex;align-items:flex-end;gap:22px}
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
.cal{display:flex;gap:3px;margin:8px 0 6px}
.cal i{flex:1;height:44px;border:1px solid #cfc5b3;background:#fbf8f1;font-style:normal;font-size:12px;text-align:center;padding-top:4px;line-height:16px}
.cal i.w{background:#e8c9bf;border-color:#b5412f}.cal i.t{border:2px solid #2b2620;background:#ece6d8}
.opt{top:432px;width:344px;height:352px;display:flex;flex-direction:column}
.opt h3{margin-bottom:4px}
.opt .cost{font-size:14px;font-weight:600;margin-bottom:6px}
.opt p{font-size:13px;line-height:18px;margin-bottom:6px}
.opt .odds{margin-top:auto;font-size:13px;border-top:1px dashed #b9b0a0;padding-top:8px;margin-bottom:8px}
.btn{border:2px solid #2b2620;background:#f3efe6;padding:7px 0;font-size:22px;text-align:center}
.btn.gold{background:#c9971f;border-color:#8f6a12;color:#1f1a10}
#last{left:32px;top:800px;width:1776px;height:104px;background:#fbf8f1}
#last div{font-size:14px;margin:3px 0}
#foot{position:absolute;left:32px;bottom:12px;font-size:12px;color:#7b7266}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 11 Jan 2027 · Week 54</span><span class="sp"></span><span>$7,860 · running +$95 a week</span><span class="cont d">CONTINUE ▸ TO MON 18 JAN, LYNN AC DECIDE FROM THEN</span></div>
<div id="board">
 <div id="hdr"><span class="nm d">NIA OKAFOR</span><span class="role d">PROSPECT · 19 · 60 KG · ORTHODOX · 3-1</span><span class="sub">Fighters › Find a fighter · brought by the scout · places 2 of 3 used · example state, not engine output</span></div>

 <div class="card" style="left:32px;top:84px;width:900px;height:334px">
  <h3 class="d">YOUR LOOK AGAINST LYNN AC'S LOOK · THE LEVEL HERE IS 60</h3>
  <div class="mut" style="margin-bottom:4px">Solid bar: your look. Hatched bar: Lynn AC's look, with its own misread. Red line: the region's level.</div>
  <div class="g"><span class="lab d">BODY</span><div class="ax"><div class="b you" style="left:149px;width:149px"></div><div class="b riv" style="left:168px;width:112px"></div><div class="lv"></div></div><span class="v">yours 56-72 · theirs 58-70</span></div>
  <div class="g"><span class="lab d">SKILLS</span><div class="ax"><div class="b you" style="left:93px;width:224px"></div><div class="b riv" style="left:112px;width:131px"></div><div class="lv"></div></div><span class="v">yours 50-74 · theirs 52-66</span></div>
  <div class="g"><span class="lab d">UNDER FIRE</span><div class="ax"><div class="b unk" style="left:0;width:560px"></div><div class="lv"></div></div><span class="v">not seen yet</span></div>
  <div class="g"><span class="lab d">CEILING</span><div class="ax"><div class="b you" style="left:280px;width:261px"></div><div class="lv"></div></div><span class="v">up to 70-98 · theirs not shown</span></div>
  <div class="scale"><span>40</span><span>50</span><span>60</span><span>70</span><span>80</span><span>90</span><span>100</span></div>
  <div style="font-size:14px;margin-top:6px">Body straddles the level: a read can settle it. Skills straddles it too, and wider.</div>
 </div>

 <div class="card" style="left:952px;top:84px;width:856px;height:166px">
  <h3 class="d">RIVAL WINDOW · LYNN AC DECIDE BETWEEN MON 18 AND SUN 24 JAN</h3>
  <div class="cal"><i class="t">M11<br>today</i><i>T12</i><i>W13</i><i>T14</i><i>F15</i><i>S16</i><i>S17</i><i class="w">M18</i><i class="w">T19</i><i class="w">W20</i><i class="w">T21</i><i class="w">F22</i><i class="w">S23<br>bout</i><i class="w">S24</i><i>M25</i><i>T26</i><i>W27</i><i>T28</i><i>F29</i><i>S30</i><i>S31</i></div>
  <div class="mut">Any one day of the red seven. They box Sat 23 Jan at the Lynn show, free to watch. ▸ Next name due: about Mon 1 Feb, one place free.</div>
 </div>

 <div class="card" style="left:952px;top:262px;width:856px;height:156px">
  <h3 class="d">WHAT YOUR READS CAN STILL CHANGE</h3>
  <div style="font-size:14px;line-height:22px">Body: test day or trial.<br>Skills: trial.<br>Under fire: hard spar, or their bout Sat 23 Jan (free to watch, inside the window).<br>Ceiling: trial pad test only.</div>
 </div>

 <div class="card opt" style="left:32px"><h3 class="d">SIGN NOW</h3><div class="cost">$250 a week · 0 days</div>
  <p>Bound 12 weeks: letting go sooner pays the weeks left, up to $3,000.</p><p>Reads nothing more. The ranges stay as they are.</p>
  <div class="odds">About 1 in 3 first looks like this end under the level.</div><div class="btn d">SIGN NOW</div></div>
 <div class="card opt" style="left:390px"><h3 class="d">TEST DAY</h3><div class="cost">$60 · 1 day (Tue 12)</div>
  <p>Body 16 wide to about 7.</p><p>Skills, under fire and the ceiling stay as they are.</p>
  <div class="odds">0 in 7 they sign tomorrow: the window opens Mon 18.</div><div class="btn d">BOOK THE TEST DAY</div></div>
 <div class="card opt" style="left:748px"><h3 class="d">TRIAL WEEK</h3><div class="cost">$125, refunded if Lynn AC sign during it · 7 days (Wed 13 to Tue 19) · a place held</div>
  <p>Skills to about 9 wide, body to about 8.5. The pad test halves the ceiling: 28 wide to 14.</p><p>Hard spar on day 7, optional: opens under fire. Injury x2 that night, +15 tiredness.</p>
  <div class="odds">Lynn AC may sign during the week: 2 in 7 (Mon 18, Tue 19).</div><div class="btn gold d">START THE TRIAL WEEK</div></div>
 <div class="card opt" style="left:1106px"><h3 class="d">WAIT A WEEK</h3><div class="cost">$0 · 7 days</div>
  <p>The open session reads body and skills a little.</p><p>You decide on Mon 18 before Lynn AC can.</p>
  <div class="odds">0 in 7 they sign: the window opens Mon 18.</div><div class="btn d">WAIT</div></div>
 <div class="card opt" style="left:1464px"><h3 class="d">PASS</h3><div class="cost">$0 · frees the slot today</div>
  <p>The next name can arrive sooner.</p><p>They box on at Lynn AC and can be offered against your boxer within 26 weeks.</p>
  <div class="odds">Kept on the got-away list with your look.</div><div class="btn d">PASS</div></div>

 <div class="card" id="last"><h3 class="d" style="font-size:22px;margin-bottom:4px">LAST TIME</h3>
  <div>Passed in March: your first look body 56-72. They box at 66 now, 4-1 at Lynn AC.</div>
  <div>Your last trial: body 56-72 → 61-69, your first look had the middle at 64.</div></div>
 <div id="foot">Kalli · critic page · KNOW_STAKES1 v8 · example state, not engine output · names in headers only · gold on one thing, green on Continue only</div>
</div>
</body></html>
```

I've finished the KNOW_STAKES1 v8 critique, and it scores 6 for depth, 6 for play and 7 overall. That's below the bar, so my verdict is to keep it but change it first. Hunch dominates the decisions that matter, and only 18% of decisions matter at all. The scout filter is doing the work, and the deadline's stacked subtractions leave little room for waiting.

The code check is on the 21 Nov copy because the fetch failed again. The trial's dice isn't in that copy, the trial costs $500 there against $125 on the map, and no screen shows any of the knowledge code. The probe files aren't in my copy either, so I judged the probe from its result text alone.

The 10/10 page is in `/workspace/knowstakes8/`.

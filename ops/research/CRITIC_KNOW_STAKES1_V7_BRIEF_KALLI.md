# CRITIC_KNOW_STAKES1_V7_BRIEF_KALLI - Kalli answer (seat queue SQ300)

Brief: research/CRITIC_KNOW_STAKES1_V7_BRIEF.md
Sent: 2026-11-23 03:22 | collected: 2026-11-23 04:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring KNOW_STAKES1 v7 now. First I'm trying to fetch today's code to check the map's claims.

**SCORE depth=7 play=6 general=6**

That's a clear step up from v6, but still under the 8/8 bar. My verdict is keep it, with three changes before it's built.

**DEPTH 7.** The rival's clock does what it was meant to: the reads now compete for days as well as cash. And "watch them box" is a real, cheap, situational read. But the central claim doesn't hold yet, because two things stay lopsided:
- **Signing is the best read.** Letting a signed amateur go is free in cash (`Leaving.let_go`, reputation only), and training narrows every range every week. So "sign now, cut in week 8 if wrong" beats paying to look.
- **The biggest unknown has no read.** The ceiling is what decides top-10 boxers (the +12.1 % in K5). The map says no read before signing moves it, so that call stays a pure hunch unless you have the Amateur coach.

**PLAY 6.** A name arriving every few weeks with a date on the Continue button gives you a reason to come back. The got-away list is the best new idea here: a pass finally teaches you something. Two things pull it down:
- Losing the prospect 1 time in 4 during a paid trial week feels like a coin flip punishing you for being careful.
- The new numbers rule (a number prints only when the range is 1 wide) means a signed boxer's attributes never show a number again, because the width floor is 1 wide and is never quite reached. That hides the weekly gains, which are the core reward of the Week. Real stats staying visible is a standing owner rule.

**GENERAL 6.** It's well grounded: it reuses `TellWorth`, `rival_row`, `Newcomers` and the visitor's deadline, the pronouns are fixed, and the habits are split off. The minuses:
- The numbers rule clashes with the attribute board, the weekly deltas and the perk thresholds ("Chin 70"), and the map never says what those screens show.
- The clock's length leaks a second, free read of the truth (more below).
- Rationing the five day-one prospects changes the first hour without saying how.

**Which call dominates, and when**
- **A place is free (most of the early game: 3 places, 1–2 boxers):** sign now dominates, because a flop costs a few stipend weeks and some reputation.
- **The clock is 7 days:** sign now again. The short clock already told you the rival rates them, and there's no time for a trial.
- **Every place is full:** pass or wait dominates, because signing needs a release first.

Looking again wins only in the narrow middle: a free place, a clock of 14 days or more, and one group sitting right on the line. P-B's "no pure call best in over 60 %" will probably fail on sign now.

**Missing**
- **A cost for signing.** A minimum term (for example 12 weeks of stipend owed if you let them go early) is what makes the hunch a real bet.
- **A read for the ceiling before signing.** For example, a pad test in the trial week: how fast a new move sticks. Real coaches judge a kid by how quickly they pick things up.
- **Something you get for waiting.** Today waiting gives no information. One slow free read a week (they train at the open session) would make Wait more than a pause.
- **What the attribute board, the weekly gains and the perk thresholds show** once a boxer is signed.
- **A sign-and-cut bot arm in P-B.** It's the arm I expect to win, and the probe doesn't test it.

**Useless or weak**
- **"Watch them box" when no bout falls inside the clock.** Fine as long as the button only appears when there is one, which the map seems to intend. Show the bout date when the prospect arrives.
- **The 3-days-sooner rule** (the rival moves faster after a win you watched). It's a small knob nobody will notice. Cut it or show it.
- **Pass as its own button.** It now does exactly what letting the clock run out does, a day sooner. Keep it for clarity, but it isn't a separate choice.

**What each option changes**
- **Sign now.** No cash and no days, but the ranges stay rough. With a free let-go, it's close to risk-free.
- **Test day ($60, 1 day).** Body only, to about 7 wide. The best buy when body sits on the line.
- **Trial week ($125, 7 days, a place held, a 1-in-4 loss).** Skills to about 9 wide; the hard spar opens under fire and the pressure trait. It's the only read of skills and heart, and it's the one the clock punishes most.
- **Watch them box (free, your evening).** Under fire opens rough and the record moves. Only possible when there's a bout.
- **Wait.** Days off the clock in exchange for the next name, Friday's dues, or a bout.
- **Pass.** The prospect goes to the rival and onto the got-away list, and may be offered against your boxer later.

**Code check.** I couldn't open main as of 23 Nov: the fetch failed on credentials, and the GitHub connector returned 404 for the repository. So I checked against my copy from 21 Nov (`origin/main` 8d34d5c4, two days older than the map), plus the excerpts in the brief.

Files read in that copy: `Fighters.gd` 214-224, `Roster.gd` 86-146, `Knowledge.gd` and `KnowReads.gd` in full, `KnowWire.gd` 14-80, `CardAsk.gd` 20-28 and 145-166, `VisitWire.gd` 140-160, `Leaving.gd` 55-64 and 96-114, `Region.gd` 136-144 and 186-194, `Newcomers.gd` 50-82, `Clock.gd` 58-64, `HeadCoach.gd` 34-38 and 67-71, `Data.gd` 222-232, `HomeJuniors.gd` 72-76, `RecruitPanel.gd` 40-48, 96-114 and 111-114, `Interview.gd` 68-73, `BoutRead.gd` 112-135, `Matchmaking.gd` 36-44 and 120-140, `TellWorth.gd` 1-12.

**Confirmed:**
- L1 (the list prints the truth plus or minus the spread; `scouted_range` has no caller; the junior's potential prints the truth plus or minus 5; the card prints the exact cap and both traits).
- L2 and L3.
- K1–K4.
- D2 (`rival_row`, Region booking and moving the record, a free cash let-go with a reputation cost at :59-61).
- D3 (`sees_potential`, the star range).
- The visitor's 7-day wait (`CardAsk.gd:23`) and the visitor's last-day stop (`Clock.gd:63`).
- `Newcomers` collecting the clubs and the division's level (:62-70).
- `BoutRead.stat_ranges` built from the rating span.

**Couldn't verify (newer than my copy):**
- `CardAsk.TRIAL_LOSS 0.25` at :26. My copy has `REPEAT_MIN` on that line and no visitor trial in `VisitWire`.
- The "1 in 4" line in `Interview.gd:71`.
- `Data.gd:224 SCOUT_SPREAD`, which sits on a different line in my copy.

**On c10:** the map is right. `Matchmaking.gd` moved by a line between the two copies, so my off-by-one was true only for my older copy. I withdraw it.

**Wrong or unstated in the map:**
1. **The trial's numbers quietly change the code.** The trial week as written (skills exposure 24, body 12, giving body about 8.5) changes `_apply_trial`, which today gives body 24 too (body about 6 wide). The map calls this an ESTIMATE but doesn't say it lowers the body read. Say so.
2. **Nothing ever prints a number again.** The width floor (`FLOOR 0.5` half-width, so 1 wide) is only reached in the limit and staleness adds on top. So with "a number only at 1 wide", no signed boxer ever shows one. That's a consequence the map doesn't state, and it touches every board, the radar, the deltas and the perk thresholds.
3. **"Letting go keeps the price the game charges today" is the hole, not a neutral choice.** The code makes that price zero cash (`Leaving.gd:59-61`).
4. **The arrival rule replaces something real.** The five named prospects are real data (`Data.gd`). Spacing them out changes the "Scouted for you" cards and the first hour, and section 3 doesn't list that.

**The probes**
- **P-A passes by construction.** Offsets run −0.6 to +0.6, so a middle-of-range guesser already misses by about 0.3 of the half-width on average. It's a fine leak check but says nothing about depth.
- **P-B is the right test, with gaps.**
  - Bar (1), "best per decision", needs every branch replayed on the same world for every decision. Say so, or it will be read off the arms' totals.
  - It lacks the two arms most likely to win. One is **sign-and-cut**: sign everyone with a free place, let go in week 8 when a group's middle is under the level. The other is **clock-only**: sign when the clock is 7 days, otherwise pass. If either beats the selective arm, the reads are decoration.
  - Bar (4) makes buy-everything lose 1.5× as many prospects, which the 1-in-4 rule guarantees. Drop it, since it passes by construction.
- **P-F measures the right feelings.** Also count how often the got-away boxer is actually offered against your boxer (target at least 1 a year), and how often a player meets a 7-day clock with nothing affordable.
- **P-C is fine as a gate.**
- **One new measure:** how much the clock's length predicts the truth. If the clock alone explains more of the outcome than the test day, it's the real read and the paid reads are noise.

**To reach 10/10** (most important first)
1. **Make signing a bet.** The club stipend binds 12 weeks: letting go before week 12 pays the weeks left (up to $3,000) plus today's reputation cost. Show it on the stake line. Add the sign-and-cut arm to P-B. This alone breaks the sign-now dominance.
2. **Give the ceiling a pre-signing read.** In the trial week the coach drills one new move. The mastery it gains, from the true learning rate, narrows the ceiling range by a third. Test day doesn't touch it, and the Amateur coach still sees it exact.
3. **Fix the numbers rule for signed boxers.** A group shows a single number once it's a good read and the boxer has had 12 weeks in training or 3 bouts. Until then the board shows the middle with the range on hover, and the weekly gain moves the middle. Prospects keep ranges only.
4. **Make the clock's tell explicit and noisy, not hidden.** Show the rival's own look as its range ("Lynn AC's look: 58–70"), and cap the clock's shortening at 7 days with a random part. The player then weighs two honest, noisy reads instead of decoding a timer.
5. **Make the trial loss fair.** Refund the $125 when the rival takes the prospect, and scale the risk with the clock: 1 in 8 with 3 or more weeks left, 1 in 3 under 10 days. Show the odds on the button.
6. **Give waiting a slow free read.** Each 7 days waited, the prospect trains at the open session (body exposure +4, about a quarter of a test day). Show it on the Wait button.
7. **Fix the probes.** Add the sign-and-cut and clock-only arms, replay every decision's branches, drop the 1.5× loss bar, and report how much the clock predicts the truth.
8. **Make sure the one that got away comes back.** Within 26 weeks, if the division matches, the sheet offers that boxer against yours, tagged "you passed".
9. **Keep the first hour.** Two named prospects stay on the list from day 0 for the guide, and spacing starts with the third. List this in section 3.
10. **Show the bout date for "watch them box" when the prospect arrives,** and cut the 3-days-sooner rule.
11. **List the trial's changed exposure as a code change** (body 24 down to 12), with its reason.

At 10/10 this is the prospect's signing card. The ranges include the ceiling, which the trial's pad test can narrow. The rival's own look and their date sit on the card, and signing shows its 12-week bond. Each read says what it could change and what it costs in days. Sign now, Wait and Pass sit side by side. Gold is on the one read that decides this case, and green only on Continue.

```html
<!doctype html><html><head><meta charset="utf-8"><title>KNOW_STAKES1 v7 - signing card at 10/10 (critic)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#c9b08a;font-family:'IBM Plex Mono',monospace;font-size:16px;color:#2b2620}
.d{font-family:'Bebas Neue',sans-serif;letter-spacing:1px}
#top{height:64px;background:#15181c;color:#d9dde3;display:flex;align-items:center;padding:0 28px;gap:28px;font-size:14px}
#top .gym{font-size:28px;color:#fff}#top .sp{flex:1}
#top .cont{background:#2f7d4a;color:#fff;padding:8px 18px;font-size:22px}
#board{position:absolute;left:60px;top:96px;width:1800px;height:950px;background:#f3efe6;border:14px solid #b9bec4;box-shadow:0 6px 0 #8a7a62}
#hdr{position:absolute;left:40px;top:28px;right:40px;display:flex;align-items:flex-end;gap:24px}
#hdr .nm{font-size:64px;line-height:56px}
#hdr .sub{font-size:15px;color:#5b5348;padding-bottom:6px}
.tag{border:2px solid #2b2620;padding:2px 10px;font-size:14px;margin-left:8px}
#fig{position:absolute;left:40px;top:120px;width:300px;height:520px;background:#e6dfd1;border:1px solid #cfc5b3;display:flex;align-items:flex-end;justify-content:center}
#ranges{position:absolute;left:370px;top:120px;width:820px}
h2{font-size:30px;line-height:30px;margin-bottom:10px}
.grp{background:#fff;border:1px solid #d8cfbf;padding:12px 16px;margin-bottom:12px}
.row{display:grid;grid-template-columns:200px 1fr 150px;align-items:center;gap:14px}
.lab{font-size:24px}
.axis{position:relative;height:26px;background:repeating-linear-gradient(90deg,#efe9dd 0 1px,transparent 1px 10%);border-bottom:2px solid #b9b0a0}
.band{position:absolute;top:4px;height:18px;background:#9aa7b4}
.band.rough{background:repeating-linear-gradient(45deg,#9aa7b4 0 6px,#b8c2cc 6px 12px)}
.band.unk{background:repeating-linear-gradient(45deg,#d6cfc2 0 6px,#ebe5da 6px 12px)}
.mark{position:absolute;top:-6px;width:2px;height:38px;background:#b5412f}
.word{font-size:14px;text-align:right}
.why{font-size:13px;color:#5b5348;margin-top:6px}
.scale{display:flex;justify-content:space-between;font-size:12px;color:#7b7266;margin:2px 0 0 214px;width:446px}
#stake{position:absolute;left:370px;top:760px;width:820px;background:#fff7d6;border:1px solid #d8c98f;padding:14px 18px;transform:rotate(-0.6deg)}
#stake .big{font-size:34px}
#reads{position:absolute;left:1230px;top:120px;width:520px}
.read{background:#fff;border:1px solid #d8cfbf;padding:12px 16px;margin-bottom:12px;display:grid;grid-template-columns:1fr 120px;gap:6px 12px}
.read .t{font-size:28px;line-height:28px}
.read .c{font-size:15px;text-align:right}
.read .f{grid-column:1/3;font-size:13px;line-height:18px;color:#3d372f}
.read.gold{border:3px solid #c9971f;background:#fffaf0}
.read .btn{grid-column:1/3;border:2px solid #2b2620;text-align:center;padding:6px 0;font-size:22px}
.read.gold .btn{background:#c9971f;color:#1d1a15;border-color:#8f6a12}
#decide{position:absolute;left:1230px;top:760px;width:520px;display:grid;grid-template-columns:1fr 1fr 1fr;gap:12px}
.act{border:2px solid #2b2620;background:#fff;text-align:center;padding:14px 0;font-size:30px}
.act small{display:block;font-family:'IBM Plex Mono',monospace;font-size:12px;letter-spacing:0;color:#5b5348}
#rival{position:absolute;left:40px;top:660px;width:300px;background:#fde3dc;border:1px solid #e2a99b;padding:12px 14px;transform:rotate(0.8deg)}
#foot{position:absolute;left:40px;bottom:18px;font-size:12px;color:#7b7266}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 12 Jan · Week 2</span><span class="sp"></span><span>$9,420 · running −$310 a week</span><span class="cont d">CONTINUE ▸ TO TUE 13 JAN</span></div>
<div id="board">
 <div id="hdr"><div class="nm d">MAYA OKONJO</div><div class="sub">Walk-in · 19 · women's 60 kg · orthodox · 0 bouts</div><span class="tag d">FIRST SEEN: SUN 11 JAN</span><span class="tag d">READ SO FAR: DAY ONE</span></div>
 <div id="fig"><svg width="200" height="460" viewBox="0 0 200 460"><circle cx="100" cy="60" r="42" fill="#3b3631"/><path d="M40 120 Q100 96 160 120 L150 300 L50 300 Z" fill="#3b3631"/><rect x="58" y="300" width="34" height="150" fill="#3b3631"/><rect x="108" y="300" width="34" height="150" fill="#3b3631"/><circle cx="160" cy="130" r="22" fill="#57504a"/><circle cx="44" cy="146" r="22" fill="#57504a"/></svg></div>
 <div id="ranges">
  <h2 class="d">WHAT THE COACH SEES · RANGES, NOT NUMBERS</h2>
  <div class="grp"><div class="row"><div class="lab d">BODY</div><div class="axis"><div class="band rough" style="left:50%;width:16%"></div></div><div class="word">58–74 · rough</div></div><div class="why">Strength, speed, stamina. Test day reads it to about 7 wide.</div></div>
  <div class="grp"><div class="row"><div class="lab d">SKILLS</div><div class="axis"><div class="band rough" style="left:44%;width:24%"></div></div><div class="word">52–76 · rough</div></div><div class="why">Accuracy, timing, defence. A trial week reads it to about 9 wide.</div></div>
  <div class="grp"><div class="row"><div class="lab d">UNDER FIRE</div><div class="axis"><div class="band unk" style="left:20%;width:62%"></div></div><div class="word">unknown</div></div><div class="why">Durability, composure. Only a hard spar or a first bout shows it.</div></div>
  <div class="grp"><div class="row"><div class="lab d">WHEN HURT</div><div class="axis"><div class="band unk" style="left:25%;width:55%"></div></div><div class="word">not seen yet</div></div><div class="why">The pressure trait. Shown by the trial's hard spar or the first bout.</div></div>
  <div class="grp"><div class="row"><div class="lab d">CEILING</div><div class="axis"><div class="band rough" style="left:66%;width:18%"></div><div class="mark" style="left:72%"></div></div><div class="word">up to 70–88</div></div><div class="why">Red line: your best boxer peaks at 72. The trial's pad test (how fast a new move sticks) narrows this by a third.</div></div>
  <div class="scale"><span>0</span><span>25</span><span>50</span><span>75</span><span>100</span></div>
 </div>
 <div id="rival"><div class="d" style="font-size:24px">LYNN AC SIGN ON MON 26 JAN</div><div style="font-size:13px;margin-top:4px">14 days left. Lynn AC's own look: 58–70, as rough as yours and as likely to be wrong.</div></div>
 <div id="stake"><div class="big d">A PLACE AND $250 A WEEK</div><div style="font-size:14px;margin-top:4px">Places 3 of 3 after signing. Signing binds 12 weeks: letting go before week 12 pays the weeks left, up to $3,000. After that, free.</div></div>
 <div id="reads">
  <h2 class="d">LOOK AGAIN, OR NOT</h2>
  <div class="read gold"><div class="t d">TEST DAY</div><div class="c">$60 · 1 day</div><div class="f">Body to about 7 wide. The region's level is 60: about 1 time in 4 this puts the prospect under it.</div><div class="btn d">BOOK THE TEST DAY</div></div>
  <div class="read"><div class="t d">TRIAL WEEK + PAD TEST</div><div class="c">$125 · 7 days</div><div class="f">Skills to about 9 wide, the ceiling narrowed by a third; hard spar on the last day opens when-hurt (injury ×2). Lynn AC may talk them round: 1 in 6 now, $125 back if so.</div><div class="btn d">START THE TRIAL WEEK</div></div>
  <div class="read"><div class="t d">WATCH THEM BOX</div><div class="c">$0 · Sat 17 Jan</div><div class="f">A region show inside the clock: under fire opens rough. Costs your evening at the club that night.</div><div class="btn d">GO ON SATURDAY</div></div>
 </div>
 <div id="decide"><div class="act d">SIGN NOW<small>12 weeks bound · rough</small></div><div class="act d">WAIT<small>next name in about 2 weeks</small></div><div class="act d">PASS<small>goes on the got-away list</small></div></div>
 <div id="foot">Kalli · critic page · KNOW_STAKES1 v7 · example state, not engine output · gold on one thing, green on Continue only</div>
</div>
</body></html>
```

I scored KNOW_STAKES1 v7 at depth 7, play 6, general 6. That's better than v6 but still under the 8/8 bar, so my verdict is to keep it and make changes before it's built. I changed nothing in the repository.

Signing now wins whenever a place is free, because letting a boxer go costs no cash. The three changes that would fix it are a 12-week bond on signing, a way to read the ceiling before signing, and a numbers rule that lets a signed boxer's gains show again.

I couldn't open the 23 Nov code: fetching it failed, and the GitHub connector couldn't find the repository. So I checked the map against my copy from 21 Nov plus your excerpts, and I withdrew my earlier line-number point (c10), because the file had shifted by a line.

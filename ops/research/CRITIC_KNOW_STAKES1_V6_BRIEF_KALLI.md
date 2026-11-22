# CRITIC_KNOW_STAKES1_V6_BRIEF_KALLI - Kalli answer (seat queue SQ296)

Brief: research/CRITIC_KNOW_STAKES1_V6_BRIEF.md
Sent: 2026-11-23 00:50 | collected: 2026-11-23 01:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring KNOW_STAKES1 v6 now, as a fresh critic. I'll check the code claims against the excerpts and draw the 10/10 page.

I found a copy of the repository on my computer from 21 Nov, so I'm checking the code claims against it. Two of them already look wrong: nothing in the game ever marks a prospect Hyped, and the trial read makes body and skills exact, not a "good read".

**SCORE depth=6 play=4 general=5**

That's below the 8/8 bar. My verdict is keep, but change it: keep the prospect half (A and B) and rebuild it, rebuild C on a real cause, and move D out into its own map.

**DEPTH 6.** The idea is right. You're wrong about a whole person, and you pay to be less wrong before you put a place and a stipend on them. The measured prize is real too: knowing the truth gives +12.1 % top-10 boxers. But three things keep it shallow:
- The misread covers today's numbers only. It doesn't cover the two things a coach is most wrong about, which are the ceiling and the heart. Mind is exact from day one.
- Nothing pushes you to decide now. A careful player always takes the trial whenever cash allows, so B has a winning pick and becomes a cash check.
- The bout-side value (+1.0 %) can't be told from zero. So C's lean is a problem built so the scout has a cure, unless it comes from the opponent's real record.

**PLAY 4.** You find out you were wrong weeks later, as a bar that quietly narrows. The only moment of feeling is one line on debut night. Buying a read gets you a thinner bar, not a surprise. Passing teaches nothing, because you never see what the one you passed on became. A weekly Monday "known" report you can't act on is reading, not play.

**GENERAL 5.** The direction is sound: one range rule used on both your prospects and the opponent's file, priced reads, and a real job for the scout. But almost none of it is wired. Two of the map's key reads do something different in the code (below). Bundling the habits in D makes it two mechanics in one score. The map also says "he" for the prospect in several lines, which breaks the no-fixed-he-or-she rule.

**Missing**
- **A rival gym's deadline on each prospect.** Without one, waiting costs nothing and the trial always wins. With a 7–21 day deadline, "four weeks of trial or sign now" becomes a real choice. That's an owner call, because it brings back a held-back deadline.
- **A range on the ceiling** ("up to 70–88"). That's the unknown that decides a signing. It would also give the Amateur coach's "exact potential" edge a job.
- **A range on heart and head** (heart, coachability, temper), opened only by a hard spar or the first bout. In real boxing, that's what a trial spar is for.
- **Feedback when you pass.** A prospect you passed on should turn up in the region's results with their record ("you passed on…").
- **A price for letting a flop go** (for example, one week's stipend). A misread only hurts as much as the cost of fixing it.
- **One of the two range systems has to go.** The prospect list already shows its own range (more on that in the code check).

**Useless**
- **"Call the old gym" as the code stands.** Nothing in the game ever makes a prospect Hyped, so this read removes nothing.
- **Recheck at $40.** It halves a staleness widening that's already small, and it never changes an answer.
- **The 0–5 pip row on the Roster.** It's a number with no action behind it.
- **Monday "narrowed" lines.** They're fine once a range crosses a decision line (for example, falls below the step-up level). Otherwise they're noise.

**What each option changes**
- **Sign on the first look.** You keep the cash and the deadline but take the whole risk.
- **Call the old gym ($120).** It moves the answer only on a hyped prospect, and only when clearing the hype drops the body range below the line you care about.
- **Test day ($60).** Body goes to about 7 wide. It's the cheapest read and the one that settles most yes-or-no calls.
- **Trial ($500 and 4 weeks).** It reads skills and under fire, but it eats the deadline.
- **Pass.** No cost, and today no information either.
- **Scout ($250, opponent).** It opens every hidden note and shows the real opposition behind the record. That's only worth paying for if the record can mislead.

**Code check.** I read the repository as it stood on 21 Nov (`origin/main` 8d34d5c4), because fetching anything newer failed. `tools/knowmisread2_probe.gd` and `docs/KNOWMISREAD2_RESULT.md` aren't in that copy, so I couldn't check them. I didn't open the habit rows in D either.

Files I read: `scripts/rules/Knowledge.gd` and `scripts/rules/KnowReads.gd` in full, plus the cited lines of `KnowWire.gd`, `BoutRead.gd`, `ProLadder.gd`, `Roster.gd`, `RecruitPanel.gd`, `modals/Trial.gd`, `GymSpend.gd`, `Matchmaking.gd` and `TellWorth.gd`, and searches for every caller.

**Correct:**
- K1 and K2: the groups, the widths, and the truth always sitting inside the range.
- K4: no screen uses Knowledge, and KnowReads is called by nothing.
- K5: the prices.
- Look closer picks the widest group, and hard-spar risk is screen data only.
- The ProLadder scout: $250, opens every hidden note, keeps the read it had before.
- `GymSpend.place_blocked` at :218 and BoutRead's 12 / 3 / 20 % widths.

**Wrong or misleading:**
1. **A can't wire anything, because there's no record before signing.** `KnowWire.start` runs inside `sign_fighter` (`Roster.gd:143`), so a prospect has no record to show. One has to be created the first time a prospect is seen.
2. **The prospect list already shows a range, and its middle is the truth.** `Roster.scouted_range` (:103-105) prints the true stat plus or minus a fixed spread, so the answer leaks. The map never mentions it.
3. **Hype isn't wired.** Nothing in `scripts/` calls `set_hyped`, and no game code passes the hype value into `range_of`. `hyped_centre_offset` is used only by tests. Even `clear_hype` wouldn't change the range shown, because `range_of` reads the value it's given, not the record's Hyped flag.
4. **The trial makes body and skills exact, not a "good read".** +24 exposure takes both to 67 % known, which is over the 60 % known line (`KNOWN_SHARE`), and `shown()` then gives the exact truth (:251-261). Every group jumps from a range to the exact number at 60 %, so the misread vanishes all at once.
5. **Test day comes out about 7.4 wide, not "about 6"** (exposure 16 for under-5-bout boxers). With 5 or more bouts it's about 10 wide.
6. **`KnowReads.apply` returns a cost only for the trial.** The other prices need charging code that doesn't exist yet.
7. **The opponent's stat ranges already move with the rating range.** `BoutRead.stat_ranges` builds them from the rating span (:119, :133), so only the record is independent. O1 says the opposite.
8. **C goes against a standing ruling.** `Matchmaking.gd:138` records S416: "the read never leans". The map has to say it overturns S416.
9. **The trial change isn't marked as a change.** Today the trial is one free day (the coming Monday). The map's $500, four-week trial is a change it doesn't flag.
10. **Two line numbers are off by one in `Matchmaking.gd`.** `SCOUT_COST` is at :39, not :40, and `scout` runs :125-135.
11. **The map misses a pattern that already exists.** `TellWorth.gd` already shows "what the next film could be worth" as a range, and it's wired on Camp. That's the pattern for "what this read could change".

**The probes**
- **P-A only checks the wiring** (the card shows what `range_of` returns). A shallow mechanic passes it.
- **P-B is the right question, but "half of +12.1 %" is noisy.** That number's own spread runs +5.3 to +19.6. Add a test that counts decisions: how often each read flips sign-or-pass, with a target of 25–60 %. If a read never flips anything, it's dead.
- **P-C will pass by construction.** The lean is rolled dice, and the scouting bot is the one that gets to see past it. The share-0.0 control is good. Rerun it with the lean computed from the opponent's real opposition, and report how many scouted fights each world had, because bout counts per world are small.
- **P-D is fine, but it belongs to a different mechanic.**
- **Two probes are missing, and they're about how it feels to a player:**
  - How often the top two prospects' ranges overlap. Aim for 30–60 %: at 0 the reads never matter, at 100 they're noise.
  - How often a signed boxer turns out visibly wrong (the middle of a range moves 5 or more by week 10). Aim for about 1 signing in 3.

**To reach 10/10** (most important first, all buildable)
1. **One range system, created at first sight.** Build the record when a walk-in arrives or a prospect hits the list, and delete `Roster.scouted_range`.
2. **Put the ceiling under a range** ("up to 70–88"), drawn against your best boxer's peak. The Amateur coach's edge shows it exactly.
3. **Put heart and head under a range.** Only a hard spar or the first bout opens it.
4. **Make hype real.** Set it from a real cause (a regional medal, a big gym letting the prospect go, a loud parent) on about 1 prospect in 4. "Call the old gym" clears it, and `range_of` reads the record's Hyped flag.
5. **Drop the jump to exact at 60 %.** The range keeps narrowing down to its floor, and it only becomes exact after about 10 bouts.
6. **A rival gym's deadline on every prospect,** shown on the card. That's what makes the trial cost something besides cash.
7. **Feedback both ways.** Let a flop go for one week's stipend. Show "you passed on…" news with the record of the one that got away.
8. **The reveal as a moment.** The first bout's "why" prints something like "Composure came in at 48; the read said 55–70", with a coach line. Monday lines appear only when a range crosses a decision line.
9. **C from real data.** Build the lean from the record's real opposition, for example 5 of 7 wins against boxers with losing records. A real case: Peter McNeeley went into the 1995 Tyson fight 36-1 against a soft schedule. The record is free and can mislead, and the scout shows who was actually beaten. State plainly that this overturns S416.
10. **Every read button says what it could change,** in the TellWorth style: "Changes the answer only if body drops under 62: 1 time in 3."
11. **Split D off into its own HABITS map** and score it separately.
12. **Fix the probes:** decision flips, overlap share, visibly-wrong share, and P-C with the computed lean.
13. **Cut the pip row and recheck,** and fix the fixed "he" lines.

At 10/10 this is the signing card for a walk-in. Every group shows a range with a word for its width, and the ceiling is drawn against your best boxer. Hyped shows with its cause, and the rival gym's deadline is on the card. Each of the three reads says what it could change. Gold sits on the one read that decides this case, and green is only on Continue.

```html
<!doctype html><html><head><meta charset="utf-8"><title>KNOW_STAKES1 v6 - signing card at 10/10 (critic)</title>
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
.tag.hype{background:#f6d7a6}
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
#decide{position:absolute;left:1230px;top:760px;width:520px;display:grid;grid-template-columns:1fr 1fr;gap:12px}
.act{border:2px solid #2b2620;background:#fff;text-align:center;padding:14px 0;font-size:30px}
.act small{display:block;font-family:'IBM Plex Mono',monospace;font-size:12px;letter-spacing:0;color:#5b5348}
#rival{position:absolute;left:40px;top:660px;width:300px;background:#fde3dc;border:1px solid #e2a99b;padding:12px 14px;transform:rotate(0.8deg)}
#foot{position:absolute;left:40px;bottom:18px;font-size:12px;color:#7b7266}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 12 Jan · Week 2</span><span class="sp"></span><span>$9,420 · running −$310 a week</span><span class="cont d">CONTINUE ▸ TO TUE 13 JAN</span></div>
<div id="board">
 <div id="hdr"><div class="nm d">MAYA OKONJO</div><div class="sub">Walk-in · 19 · women's 60 kg · orthodox · 0 bouts</div><span class="tag hype d">HYPED · THE OLD GYM TALKS IT UP</span><span class="tag d">READ SO FAR: DAY ONE</span></div>
 <div id="fig"><svg width="200" height="460" viewBox="0 0 200 460"><circle cx="100" cy="60" r="42" fill="#3b3631"/><path d="M40 120 Q100 96 160 120 L150 300 L50 300 Z" fill="#3b3631"/><rect x="58" y="300" width="34" height="150" fill="#3b3631"/><rect x="108" y="300" width="34" height="150" fill="#3b3631"/><circle cx="160" cy="130" r="22" fill="#57504a"/><circle cx="44" cy="146" r="22" fill="#57504a"/></svg></div>
 <div id="ranges">
  <h2 class="d">WHAT THE COACH SEES · RANGES, NOT NUMBERS</h2>
  <div class="grp"><div class="row"><div class="lab d">BODY</div><div class="axis"><div class="band rough" style="left:50%;width:16%"></div></div><div class="word">58–74 · rough</div></div><div class="why">Strength, speed, stamina. Hyped: the whole range may sit high.</div></div>
  <div class="grp"><div class="row"><div class="lab d">SKILLS</div><div class="axis"><div class="band rough" style="left:44%;width:24%"></div></div><div class="word">52–76 · rough</div></div><div class="why">Accuracy, timing, defence. Pads show it; four weeks of pads read it.</div></div>
  <div class="grp"><div class="row"><div class="lab d">UNDER FIRE</div><div class="axis"><div class="band unk" style="left:20%;width:62%"></div></div><div class="word">unknown</div></div><div class="why">Durability, composure. Only a hard spar or a first bout shows it.</div></div>
  <div class="grp"><div class="row"><div class="lab d">HEART AND HEAD</div><div class="axis"><div class="band unk" style="left:25%;width:55%"></div></div><div class="word">unknown</div></div><div class="why">Heart, coachability, temper. Shown when the round goes wrong, not before.</div></div>
  <div class="grp"><div class="row"><div class="lab d">CEILING</div><div class="axis"><div class="band rough" style="left:66%;width:18%"></div><div class="mark" style="left:72%"></div></div><div class="word">up to 70–88</div></div><div class="why">Red line: your sheet's best boxer peaks at 72. Most of this range is above that.</div></div>
  <div class="scale"><span>0</span><span>25</span><span>50</span><span>75</span><span>100</span></div>
 </div>
 <div id="rival"><div class="d" style="font-size:24px">EASTSIDE ABC IS ASKING TOO</div><div style="font-size:13px;margin-top:4px">An answer is needed by Mon 26 Jan (14 days). A four-week trial runs past it.</div></div>
 <div id="stake"><div class="big d">A PLACE AND $250 A WEEK</div><div style="font-size:14px;margin-top:4px">Places 3 of 3 after signing. A flop found in week 10 has cost $2,500 and the place. Letting a boxer go costs one week's stipend.</div></div>
 <div id="reads">
  <h2 class="d">PAY TO BE LESS WRONG</h2>
  <div class="read"><div class="t d">CALL THE OLD GYM</div><div class="c">$120 · today</div><div class="f">Clears the hype lift. Changes the answer only if the body range drops under 62: 1 time in 3 for a hyped walk-in.</div><div class="btn d">CALL</div></div>
  <div class="read gold"><div class="t d">TEST DAY</div><div class="c">$60 · tomorrow</div><div class="f">Body to about 7 wide, done before the rival's deadline. Body is the range that decides yes or no here.</div><div class="btn d">BOOK THE TEST DAY</div></div>
  <div class="read"><div class="t d">TRIAL WEEKS + HARD SPAR</div><div class="c">$500 · 4 weeks</div><div class="f">Skills and under fire to a good read; spar night injury ×2, tiredness +15. Runs past the rival's deadline: the prospect may sign there.</div><div class="btn d">START THE TRIAL</div></div>
 </div>
 <div id="decide"><div class="act d">SIGN ON THE FIRST LOOK<small>no cost · ranges stay rough</small></div><div class="act d">PASS<small>may turn up in the region's results</small></div></div>
 <div id="foot">Kalli · critic page · KNOW_STAKES1 v6 · example state, not engine output · gold on one thing, green on Continue only</div>
</div>
</body></html>
```

My score for KNOW_STAKES1 v6 is depth 6, play 4, general 5, which is below the 8/8 bar. My verdict is to keep the prospect half and rebuild it, not cut it. I changed nothing in the repository.

The biggest problems in the code:
- **No record before signing.** A prospect only gets a knowledge record once signed, so the signing card has nothing to show.
- **The answer leaks.** The prospect list already shows its own range, and the middle of it is the true number.
- **"Call the old gym" does nothing yet.** Nothing in the game ever makes a prospect Hyped.
- **The trial gives exact numbers.** It makes body and skills exact instead of leaving a good range, because a group jumps to exact once it's 60 % known.

Section C, the lean on the opponent's file, overturns your S416 ruling that the read never leans. The map doesn't say so.

I checked against the copy of the repository from 21 Nov, because fetching a newer one failed. That copy doesn't have the new probe file or its results doc, so I couldn't check those.

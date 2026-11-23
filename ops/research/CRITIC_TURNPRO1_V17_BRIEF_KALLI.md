# CRITIC_TURNPRO1_V17_BRIEF_KALLI - Kalli answer (seat queue SQ314)

Brief: research/CRITIC_TURNPRO1_V17_BRIEF.md
Sent: 2026-11-23 20:40 | collected: 2026-11-23 21:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking the map's code claims against my repo copy first, then I'll score the design.

**TURNPRO1 v17: turning pro, WHEN and HOW**

`SCORE depth=5 play=6 general=6`

It's below the bar on both depth and play. My verdict is to keep the shape but change the decision. The cuts are right, the timing ("Not yet") is clear, and splitting tune-up from step up is a real boxing choice. But in the version you sent, each fight is one expected-value sum, and the result depends on the purse.

**The central claim: the player reads the boxer and picks well across six fights.** The probe shows the reading is worth very little. The reader beats the best habit by 1.2 to 3.7 points on a score of about 90 to 104, about 2 to 3%, and the map says so itself. Among the habits, always taking the safe bout is best in 7 of 10 boxer types. The mix also swings on one number: at x1.5 the safe bout is taken 90% of the time, at x2 the risky bout 81%. When a 0.25 change in the purse multiple flips most picks, the player isn't reading a fight; they're comparing two prices. Nothing about the opponent goes into the choice. The two bouts are only a chance band and a purse, so the matchup, which is what this game is about (the plan, the tells, the Why), plays no part.

**What each option changes**
- **Turn pro now.** This starts the six fights. It's clear and good.
- **Not yet.** It costs a mark and 15 hunger, and the offer returns in 4 weeks. It buys only about two amateur bouts of training. The probe shows waiting every time loses the boxer in 10 of 10 types, and the reader waits for only 2 types. So it's nearly a trap, with no positive reason given. The real reason boxers wait (a national title, or finishing a tournament) is not part of it.
- **The rival gym's call the third time.** This is good drama, the boxer walking out. Keep it.
- **SAFE.** It gives a likely win, +1 name, -10 hunger and the base purse.
- **RISKY.** It gives a coin flip, x1.75 purse, +3 name, +10 hunger and a bigger stoppage risk.
- **Useless as written:** the name. In fights 1 to 6 it changes no offer (the map says so in section 5), and after fight 6, ProLadder reads the boxer's rank, not the name. So +1 or +3 only feeds the probe's score, not the game. The score's 2 points per name point is a weight the game never pays out.
- **Duplicated:** the two bars. CONFIDENCE is already a personality trait in the game (`FighterProfile.TRAITS`, and Recruit's Fragile or Confident). HUNGER sits beside morale and loyalty, which already move on the pro decision (`Loyalty` `decline_pro` -8). That's two words for one idea, which breaks the one-word-per-concept rule.
- **Missing:** using the bout itself (the opponent's style and tell against the boxer's plan), a reason to say "Not yet", and a pay-off for the name after fight 6.

**The words:** SAFE and RISKY replace the game's own TUNE-UP and STEP UP, which ProLadder uses from fight 7 on. The map's section 4 also says "him", "his" and "safe man", and the sandbox rule bans any fixed he or she.

**Code check**

The fetch failed again on the GitHub login, so I read origin/main `8d34d5c4` (21 Nov, 10:03 Cyprus time, UTC+2). That's older than the map's 23 Nov. I used only read-only git and opened neither GameState.gd nor FightRealtime.gd.

Files read: `Roster.gd` (:30-52, :186-232, :300-335), `ProLadder.gd` (:18-30, :130-216), `ProLean.gd` (:1-25), `DebutRead.gd`, `TrainingPreview.gd`, `ProDebut.gd`, `ProCall.gd` and `ProOfferWire.gd` (lists of their functions and constants), and `Matchmaking.gd` (:30-33, :281-282), plus searches across `scripts/`.

**True in my copy**
- `PRO_WINS` 7, `PRO_RANK` 3, `PRO_WINS_ANY_RANK` 9.
- `PRO_PURSE` 1500, with +500 a win up to 3000.
- `PRO_DEBUT_WEEKS` 4, `PRO_RETURN_WINS` 2, `PRO_SECOND_TERMS` 0.9 (mirrored at `ProCall.SECOND_TERMS`).
- `pro_ready` limits a boxer to rank 1 after two declines.
- `TUNE_READ` 0.70-0.93, `TUNE_AIM` 0.82, `STEP_READ` 0.5.
- `_make_offers` at :175.
- `promoters()` and `who_calls()`.
- `LEAN_KIND` and `LEAN_WORD`.
- `GYM_SHARE` = `ProDebut.MANAGER` 0.15 + `TRAINER` 0.10.
- `BoutRules.WIN_REPUTATION` 5.
- `StarDeal`.
- `DebutRead.card`, which the pro offer prints (`ProOffer.gd` :125).

**Wrong or incomplete**
- **The trainer's four-weeks-on read doesn't exist.** `TrainingPreview` only does stat-gain maths (`headroom`, `plan_gain`, `fractions_gain` and others) and reads no bout chance. "The game's own training read" has to be built by combining four weeks of `plan_gain` with `DebutRead`.
- **The national finalist rule is narrower than the map says.** The map has a finalist "called whatever the record". In `Roster.gd` :189 that holds only with 0 declines. With v17 removing the declines, the map should say which way it goes.
- **Fights are not always 8 weeks apart.** `Matchmaking` :281 gives `QUICK_WEEKS` or `HARD_WEEKS` depending on the gap, and `NEXT_WEEKS` 8 only otherwise. The map's "8 apart" also leaves the hunger rule unclear: an 8-week gap is two lots of four weeks without a fight.
- **The gym's share isn't flat.** `Roster.signing_share` drops to the trainer's 10% when loyalty is under 50 (`Loyalty.pro_share`), and `StarDeal` changes it later. The score's "gym's purse cut" moves with loyalty, which the map doesn't count.
- **"Real men of a fixed level for the division" is a new builder.** `_make_offers` picks from the live division table, ranked or unranked, and a step up needs a ranked name inside the boxer's band and that `MM.ask` allows. That fails for an unranked debutant when nobody ranked fits, and the map doesn't say what happens then.
- **The map misses some code on the decline path.** `decline_pro` also changes morale (`ProOfferWire.apply_morale`) and loyalty (`Loyalty.apply` -8), and `Roster.gd` :187 closes the door after 3 declines. Replacing the decline rule has to remove or rewire these, or a "Not yet" would cost hunger, morale and loyalty at once.

**Not in my copy:** `DebutPick.gd`, `pro17` state, `tools/turnprobe17_rules.gd` and `docs/TURNPROBE17_RESULT.md`. They may have landed after 21 Nov, but I can't confirm that.

**The probe**

These bars can pass while the mechanic is shallow:
- **Bar 1 passes because the reader counts as an arm.** The reader is best in 9 types, so no habit is best, but among the habits, always-safe leads in 7. The question that matters is whether always-safe comes close to the reader, and it does: within 1 to 4 points.
- **Bar 2 is about statistical significance, not something a player would notice.** With 2,000 careers, a 2-point edge clears 2 standard errors. A player won't feel 2%. Measure it as a share of the score, with at least 8 to 10% as the bar.
- **Bar 3 passes at one tuned price.** At x1.5 and at x2 it fails. Any bar that passes at only one value of the multiple is measuring the tuning, not the choice.
- **Bar 4 ("Not yet" is a real question) passes on 2 types exactly at the minimum,** while waiting every time loses the boxer in all 10. That tells me "Not yet" is a penalty with a rare exception, not a question.
- **Bar 5's knockout effect (-3.3 points) is real.** Keep that bar.
- **Bar 6 checks the caps.** Fine.

What I'd measure instead:
1. **A purse sweep from x1.5 to x2 in 0.1 steps.** Both bouts should each be taken in 25% or more of fights at every value.
2. **A chance-only bot** that picks on the printed chance and purse and ignores the boxer. If it scores within 2% of the reader, the reading adds nothing.
3. **The share of fights where the best pick beats the second by a set margin,** like the KNOW_STAKES B5 bar, with 30% or more as the target.
4. **How often a career's fight 6 standing differs** between the reader's choices and always-safe, for the same boxer and the same dice.

**To reach 10/10, most important first**
1. **Let the matchup decide, not the price.** Each card shows the opponent's style, stance and one tell from public tape; camp tape study opens the step-up's weakness. A plan line written against the tell moves the chance by up to 6 points, inside what the existing plan grading allows. A matchup that suits the boxer turns a step up into the right call. Target: the reader beats always-safe by 8% or more.
2. **Give the name a pay-off after fight 6.** It should set where the normal promoter booking starts. For example, under 6 the boxer starts at unranked reach, 6 to 11 reaches five places up, and 12 or more starts inside the ranked band with a step up on the first card. Then a step up buys position, not just a probe score.
3. **Use the bars the game already has.** Drop the new CONFIDENCE word. Let the existing confidence trait set the size of the knockout hit (Fragile -40, Confident -20; my numbers). Let hunger be shown as morale and loyalty, or rename it, and wire the signing card's ambition to it: a title-chaser gains from step ups, and a steady earner loses less on tune-ups. The ambition finally does something.
4. **Give "Not yet" a reason.** It should hold the offer through a nationals run (`Champs.active` already blocks the call) and print what four more weeks gives: the stat gain plus the changed chance for fight 1. Target: "Not yet" is the right call for 3 or more types, and always waiting no longer loses every boxer.
5. **Use the game's own words, TUNE-UP and STEP UP,** and fix "him", "his" and "safe man" in the map to "the boxer" and "the opponent".
6. **Build the four-weeks-on read** from `TrainingPreview.plan_gain` over four weeks fed into `DebutRead.card`, and print it as a range.
7. **Rewrite the decline path.** Remove the morale and loyalty hits in `decline_pro` (or say they stay), say how a national finalist is treated, and remove the 3-declines door, since patience replaces it.
8. **Make the hunger clock unambiguous:** -5 for each 4 weeks without a fight, counted from fight night to fight night, so an 8-week gap is -10. Say whether `QUICK_WEEKS` and `HARD_WEEKS` apply in fights 1 to 6.
9. **Say what happens when no step-up name fits** an unranked boxer: the card shows the tune-up only, with the reason.
10. **Re-run the probe** with the four measures above, plus women's and men's divisions, and a gym short of cash.

The page shows pro fight 3 at 10/10: the TUNE-UP and STEP UP cards, each with the opponent's style and tell, what the name buys after fight 6, and the bars. Gold is only on the step up and green only on Continue. Everything on it is example state, and the parts I added are tagged as critic proposals. The ambition line is also my proposal (item 3).

```html
<!doctype html><html><head><meta charset="utf-8"><title>TURNPRO1 v17 - pro fight 3 booking at 10/10 (critic)</title>
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
.card{position:absolute;background:#fff;border:1px solid #d8cfbf;padding:14px 18px}
.card h3{font-size:28px;line-height:28px;margin-bottom:8px}
.mut{font-size:13px;color:#5b5348}
.row{display:grid;grid-template-columns:170px 1fr;font-size:14px;line-height:22px;border-bottom:1px dotted #d8cfbf}
.bar{height:16px;background:#ece6d8;position:relative;margin:4px 0 2px}
.bar i{position:absolute;left:0;top:0;bottom:0;background:#4a5360}
.bar b{position:absolute;top:-4px;width:2px;height:24px;background:#b5412f}
.big{font-size:54px;line-height:52px}
.btn{border:2px solid #2b2620;background:#f3efe6;padding:9px 0;font-size:24px;text-align:center;margin-top:10px}
.btn.gold{background:#c9971f;border-color:#8f6a12;color:#1f1a10}
.tag{display:inline-block;font-size:12px;background:#ece6d8;border:1px dashed #8a7a62;padding:2px 6px}
.lad{display:flex;gap:6px;margin-top:8px}
.lad div{flex:1;border:1px solid #cfc5b3;padding:6px;font-size:13px;line-height:18px;background:#fbf8f1;text-align:center}
.lad .now{border:2px solid #2b2620;background:#fff}
#foot{position:absolute;left:32px;bottom:10px;font-size:12px;color:#7b7266}
</style></head><body>
<div id="top"><span class="gym d">IRON LANE ABC</span><span>Mon 7 Jun 2027 · Week 75</span><span class="sp"></span><span>$9,240 · running +$110 a week</span><span class="cont d">CONTINUE ▸ TO SAT 3 JUL, PRO FIGHT 3</span></div>
<div id="board">
 <div id="hdr"><span class="nm d">DANI REYES</span><span class="role d">PRO · 2-0 · LIGHTWEIGHT · ORTHODOX · PRO FIGHT 3 OF 6</span><span class="sub">Fights › Pro fights 1 to 6 · example state, not engine output</span></div>

 <div class="card" style="left:32px;top:80px;width:520px;height:420px">
  <h3 class="d">THE BOXER, BEFORE THE PICK</h3>
  <div class="row"><span>Confidence</span><span>66 · moves the chance +1.6 points</span></div>
  <div class="bar"><i style="width:66%"></i><b style="left:50%"></b></div>
  <div class="mut">The trait reads Fragile: a stoppage loss costs 40, not 30. <span class="tag">critic proposal</span></div>
  <div class="row" style="margin-top:8px"><span>Hunger</span><span>70 · warning at 0</span></div>
  <div class="bar"><i style="width:70%;background:#8a6a3a"></i></div>
  <div class="mut">Ambition: a title shot. A step up raises it 10; a tune-up win lowers it 10.</div>
  <div class="row" style="margin-top:8px"><span>Name</span><span>4 · a road starts at 12</span></div>
  <div class="bar"><i style="width:33%;background:#4a5360"></i></div>
  <div class="mut">At 12 by fight 6, the ladder starts in the ranked band; under 6, unranked reach.</div>
  <div class="lad"><div>F1<br>tune-up<br>won</div><div>F2<br>step up<br>won</div><div class="now">F3<br>pick<br>now</div><div>F4</div><div>F5</div><div>F6</div></div>
 </div>

 <div class="card" style="left:572px;top:80px;width:600px;height:740px">
  <h3 class="d">TUNE-UP</h3><span class="tag">read 0.82 · the promoter's tune-up</span>
  <div style="margin:12px 0" class="big d">84%</div>
  <div class="mut">Chance to win, the number the fight uses. Confidence is already in it.</div>
  <div style="margin-top:14px">
   <div class="row"><span>Opponent</span><span>6-9 · volume puncher · southpaw</span></div>
   <div class="row"><span>Tell on file</span><span>fades late (public tape)</span></div>
   <div class="row"><span>Rounds</span><span>4</span></div>
   <div class="row"><span>Purse</span><span>$2,500 · gym's cut $625</span></div>
   <div class="row"><span>Name on a win</span><span>+1</span></div>
   <div class="row"><span>Stoppage risk</span><span>about 3 in 10 of a loss</span></div>
   <div class="row"><span>Win</span><span>confidence +4 · hunger -10</span></div>
   <div class="row"><span>Loss</span><span>confidence -10 · hunger no change</span></div>
  </div>
  <p style="margin-top:14px;font-size:14px;line-height:20px">The southpaw lead costs round 1 unless the camp brings a southpaw partner ($160).</p>
  <div class="btn d" style="margin-top:120px">TAKE THE TUNE-UP</div>
 </div>

 <div class="card" style="left:1192px;top:80px;width:616px;height:740px">
  <h3 class="d">STEP UP</h3><span class="tag">read 0.50 · the promoter's step up</span>
  <div style="margin:12px 0" class="big d">49%</div>
  <div class="mut">Chance to win, the number the fight uses. Range 44-54 until the tape is studied.</div>
  <div style="margin-top:14px">
   <div class="row"><span>Opponent</span><span>8-0 · pressure fighter · orthodox</span></div>
   <div class="row"><span>Tell on file</span><span>best weapon: body hook (public tape)</span></div>
   <div class="row"><span>Hidden</span><span>weakness: opens with camp tape study</span></div>
   <div class="row"><span>Rounds</span><span>4</span></div>
   <div class="row"><span>Purse</span><span>$4,375 · gym's cut $1,094</span></div>
   <div class="row"><span>Name on a win</span><span>+3 · reaches 7</span></div>
   <div class="row"><span>Stoppage risk</span><span>about 4 in 10 of a loss</span></div>
   <div class="row"><span>Win</span><span>confidence +12 · hunger +10</span></div>
   <div class="row"><span>Loss</span><span>confidence -10, or -40 if stopped · hunger +10</span></div>
  </div>
  <p style="margin-top:14px;font-size:14px;line-height:20px">The plan can answer the body hook: a line written against it moves the chance about 6 points. That matchup is the part worth reading. <span class="tag">critic proposal</span></p>
  <div class="btn gold d" style="margin-top:100px">TAKE THE STEP UP</div>
 </div>

 <div class="card" style="left:32px;top:520px;width:520px;height:300px">
  <h3 class="d">WHAT EACH PICK CHANGES AFTER FIGHT 6</h3><span class="tag">critic proposal, not in the map</span>
  <p style="font-size:14px;line-height:21px">Name sets where the normal promoter booking starts: under 6 at unranked reach, 6-11 five places above the boxer, 12 or more inside the ranked band with a step up on the first card.</p>
  <p style="font-size:14px;line-height:21px;margin-top:8px">Hunger at 0 means a warning at the next booking. A second warning, then the boxer leaves for a rival gym at the third.</p>
 </div>

 <div class="card" style="left:32px;top:840px;width:1776px;height:96px;background:#fbf8f1">
  <h3 class="d" style="font-size:22px;margin-bottom:4px">LAST TIME</h3>
  <div style="font-size:14px">Fight 2: the step up, won on points 39-37. Confidence 54 → 66, hunger 60 → 70, name 1 → 4. The plan's line against pressure won 4 of 6 exchanges.</div>
 </div>
 <div id="foot">Kalli · critic page · TURNPRO1 v17 · example state, not engine output · name in the header only · gold on one thing, green on Continue only</div>
</div>
</body></html>
```

I scored TURNPRO1 v17 at 5 for depth, 6 for play and 6 overall, so it's below the bar. It needs changing before it stays.

The choice between the two bouts mostly depends on the purse. Reading the boxer gains only 1 to 4 points on a score of about 100, and a small change in the purse multiple flips most picks. The name changes nothing in the game, and the CONFIDENCE bar repeats a trait the game already has. The fix that matters most is letting the opponent's style and tell decide each fight, ahead of fixing the purse.

The code check is on my 21 Nov copy because the fetch failed. The trainer's four-weeks-on read doesn't exist in the code yet, so it has to be built. My copy of the page is at `/workspace/turnpro17/`. I didn't put the preview on your computer because it's offline right now.

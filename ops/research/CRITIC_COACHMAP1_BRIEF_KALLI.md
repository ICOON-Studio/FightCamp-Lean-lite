# CRITIC_COACHMAP1_BRIEF_KALLI - Kalli answer (seat queue SQ323)

Brief: research/CRITIC_COACHMAP1_BRIEF.md
Sent: 2026-11-24 12:10 | collected: 2026-11-24 12:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm on the COACHMAP1 critique; first I'm checking whether I can reach the repository to verify the code lines in section 6.

`SCORE depth=5 play=5 general=6` — below the bar on both counts. **Keep it, but change it:** the corner and the simmed bout must give the coach's ratings a job, and the hire needs a limit that makes the chemistry word bite. Without those, cut it back to today's two hire cards.

- **Depth, 5.** Two moments are real calls: the raise (6 / 4) and the style push (6 / 4). The rest is one rule or nothing:
  - **The hire** comes down to one test: with a pro, the known name; without, the film-room coach.
  - **Free pairing:** with "Change" free, a clash routes around itself.
  - **The course** has no trade.
  - **The corner pick** is undefined now that the player calls the fight live.

  Worse, the style push's 6 / 4 comes from a probe policy ("allow if he coaches half the gym"), which is itself a rule a player learns once.
- **Play, 5.** A few decisions a season is the right rhythm for Football Manager-style staff, but the game shows no reward for them. Nothing tells the player "your coach did that": the hire card's season line can't be computed yet, the corner read ignores the coach, and the falling-out happens offscreen. The fun part of Football Manager staff (watching a coach build a player) has no screen line here.
- **General, 6.** The map is clear and honest about its holes, and the wage formula is one rule. Against that:
  - Four of the eight ratings (film, weight, cutman, teaching beginners) are wired to nothing in a bout.
  - The four existing staff jobs have no replacement map.
  - The map writes boxers as "her" and coaches as "his", which breaks the rule that no text fixes he or she (S412).
  - The news line names two people in body text, which breaks the names-in-headers rule (S448).

**THE CODE:** I can't check section 6. My repository copy is `a08b474e` from 16 Nov, older than the 24 Nov you asked for. `git fetch` fails on the GitHub login, and `StaffDesk.gd`, `StaffDeskCard.gd`, `HireRunway.gd` and `CoachRoles.gd` aren't in that copy. I'm not stating any code fact.

**THE FIVE HOLES**
1. **The hire.** Chemistry on the card makes the hire a choice only if a clash can't be routed away. With up to four coaches and free pairing, the week sends a clashing boxer to someone else, so the word changes nothing. Make it bite with a capacity rule: a coach is the main coach of at most two boxers (three for teaching 15+). Then a clash with your best boxer means a real cost. To make sure, re-run bar 1 with the word visible on 10 rosters per gym type, varying temper. Pass only if a simple rule (pro means the known name, else the film-room coach) is wrong in at least 3 of 10 rosters inside the same gym type.
2. **The corner pick against the live corner.** The player calls; the coach supplies three things:
   - **Information:** tactics sets how often the opponent's mode clue is right (from 3 in 5 at tactics 5 to 9 in 10 at 20) and whether the 3 calls offered include the best one.
   - **Hearing:** the bond sets how much of the player's call she takes in (×(1 + 0.4 × chemistry)), and a clash loses one call a fight.
   - **The minute:** the cutman rating sets RECOVER points (2 / 3 / 4).

   Each pick trades one of these for the others, and none of them takes the call away from the player.
3. **The simmed bout.** The coach makes the shouts the player would. Tactics sets the chance his call is best, ok or wrong against the opponent's mode, using the existing `Exchanges.EDGE`. Motivation decides whether he rests her when tired and says "hands up" when she's hurt, the +2.6 to +6.2 that research found. Cap it: the best coach simmed should stay at least 4 wins in 100 under a good live player, so calling it yourself always pays.
4. **The falling-out is dead under best-fit pairing.** With the capacity rule above it comes back as a risk the player chose: he kept the pair because nobody else had room. Keep it as a news line, without names in the text.
5. **The four jobs.** Write the map: the second club coach becomes teaching beginners, strength and conditioning becomes conditioning, the cutman becomes the cutman rating, and the physio stays a job with no coach rating.

**THE MOMENTS**
- **Raise: keep.** Merge the rival's offer into it: refusing a coach with loyalty 8 or less brings the rival's offer two weeks later.
- **Rival's offer: cut** as a separate moment. It's the raise again, and it wasn't measured apart from it.
- **Style push: keep, but change it.** Show what's at stake on the card: her next two bouts at 0.6 of the plan, and the learning speed-up in weeks. Then make sure the right answer depends on the coming fight date, not on a head count: refuse in camp, allow in the base phase.
- **Course: change it.** The player picks which rating (pads, tactics or teaching) and when. The 3 weeks of lost evenings cost that coach's boxers their pad nights, so a course during camp hurts. Then measure it. If it still has no trade, cut it.

**MISSING OPTIONS**
- **Let a coach go:** a week's pay, plus a loyalty hit to his bonded boxers. Football Manager's most-used staff decision isn't on the list.
- **Contract length** on the hire card (6, 12 or 24 months). A longer contract is cheaper but harder to end, which gives the hire a second axis that isn't chemistry.
- **The coach's word on a prospect.** His teaching rating narrows the prospect's ranges on Find a fighter. This joins coaches to signing.
- **A departing coach takes a bonded boxer** when the boxer's loyalty is under 40. That's the cost of losing a coach.
- **The coach's ratings rise with results** (+1 to tactics after 3 corner wins in a season). That gives the player the reward of watching his staff grow.
- **The Why credits the coach,** in one line: "The corner's read was right 4 times in 6".

**USELESS AS WRITTEN**
- **Overrule a pairing:** best-fit pairing already avoids clashes, so "Change" does nothing until coaches have a limit on how many boxers they take.
- **Ceilings in words beside exact numbers:** pick one.
- **Film and weight management:** they count on the wage and do nothing until film opens tells faster and weight lowers the weigh-in miss chance.
- **The falling-out news line:** under best-fit pairing it never shows.
- **"About X%" on the corner pick:** every coach shows the same number until the read is wired.

**WHAT EACH OPTION CHANGES**
- **Hire:** the wage, the class nights, each boxer's learning (up to about 4.5% from chemistry) and, for the known name, pro fees and reputation.
- **Raise:** +25% wage for good, against 26 weeks of the coach working 10% worse.
- **Rival offer:** the wage, or a coach gone in two weeks.
- **Style push:** two shaky bouts and her own combination restarted at half, against learning up to 15% faster later.
- **Course:** $600 and his evenings, against +2 in one rating.
- **Corner pick (my proposal):** how often the clue is right, how much of the player's call she hears, and recovery points between rounds.
- **Change pairing:** the chemistry word only.

**THE PROBE: bars that pass while the mechanic is still shallow**
- **Bar 1** passes with two answers set by one visible fact. Measure instead how much a one-fact rule loses: the regret of "pro means the known name, else the film-room coach" across varied rosters should be at least 10 lines in at least 3 cells.
- **Bar 3** is 6 / 4 across cells that differ mainly by gym type. Fit a one-split decision tree on visible state per moment; fail if a single split predicts the right answer more than 80% of the time.
- **Bar 4's** 45 / 55 was measured on a probe-priced corner that isn't in the game, from before the live corner. Re-run it with the player bot calling live: the bonded coach should be right 25% or more against the player's call.
- **Bar 5's** careless owner hired blind; with the word on the card, that test is too easy. Make the careless bot ignore the word and capacity instead.
- **For play, there's no bar.** Count the moments that actually reach the player each season in each gym (the target is 2 to 4), and the share of the Why screens that credit a coach.

**To reach 10/10**, most important first:
1. **Wire the corner coach.** Build (a) to (d) from section 7 of the probe result. Then live, tactics sets how often the clue is right and which 3 calls are offered, the bond sets how much of the call she hears, and the cutman rating sets RECOVER points. Simmed, the coach makes the calls, priced by `Exchanges.EDGE`, and motivation covers the rest and "hands up". Cap the best simmed coach at 4 or more wins in 100 below a good live player.
2. **A coach limit.** A coach is the main coach of at most 2 boxers, 3 at teaching 15+. Show it on the week plan. Chemistry then forces trade-offs, and "Change" and the falling-out come back to life.
3. **Re-run bar 1 with the word visible,** on 10 rosters per gym type with varied tempers. Pass only if the one-fact rule loses 10 or more lines in 3 or more cells.
4. **Fill the "about X more" line** from a training-only measure, or show NOT COMPUTED, never the corner.
5. **Merge the rival's offer into the raise;** gate the style push on the camp phase; give the course a rating pick and a camp cost, then measure it or cut it.
6. **Add letting a coach go, contract length, coach-led prospect reads, and coaches who grow** (+1 tactics after 3 corner wins a season).
7. **One coach line in the Why** after every fight.
8. **Map the four jobs to ratings** and wire film (tape study opens tells faster) and weight (lower weigh-in miss chance), or drop both from the wage formula.
9. **Wording fixes:** no fixed he or she; no names in news text ("Your coach and the welterweight fell out").
10. **Re-run all bars with the new bars for bar 3 and play,** and the live player bot in the corner.

The 10/10 hire card is one candidate as the scene, and gold sits only on Hire.
- **The candidate:** a silhouette, the job as the header, and four facts: wage, pays at about N members, what the coach does in the corner, and the season line marked NOT COMPUTED.
- **The chemistry chips:** bond, fine or clash with each boxer, the reasons on hover. The pro's clash says the week can't move that pairing.
- **The other two this month:** the known name and the engine room, as small cards.
- **The trade:** one sentence on what this month's choice costs.

Everything shown is example state, and the parts I added are tagged.

```html
<!doctype html><html><head><meta charset="utf-8"><title>COACHMAP1 - the hire card at 10/10 (critic page)</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;background:#15181c;color:#e6e2d8;font-family:'IBM Plex Mono',monospace;font-size:15px;position:relative}
.d{font-family:'Bebas Neue',sans-serif;letter-spacing:1px;font-weight:400}
.mut{color:#a59d8e;font-size:13px}
.tag{display:inline-block;font-size:12px;border:1px dashed #8a7a62;color:#c8bba3;padding:1px 6px}
#top{height:64px;background:#0d0f12;display:flex;align-items:center;gap:26px;padding:0 30px;border-bottom:1px solid #2a2f36}
#top .t{font-size:34px}#top .sp{flex:1}
#scene{position:absolute;top:84px;left:24px;width:1872px;height:860px}
#lead{position:absolute;left:0;top:0;width:1060px;height:860px;background:#1d2127;border:1px solid #2f353d}
#fig{position:absolute;left:30px;top:116px;width:300px;height:460px;background:#22272e}
#lead h1{position:absolute;left:30px;top:22px;font-size:54px;line-height:54px}
#lead .sub{position:absolute;left:32px;top:84px}
#facts{position:absolute;left:360px;top:116px;width:670px}
.fact{background:#262b32;padding:12px 16px;margin-bottom:12px;position:relative}
.fact .v{font-family:'Bebas Neue';font-size:38px;line-height:38px}
.fact .hov{display:none;position:absolute;left:0;top:100%;z-index:5;width:670px;background:#0d0f12;border:1px solid #4a525d;padding:10px 14px;font-size:13px;line-height:19px}
.fact:hover .hov{display:block}
#chem{position:absolute;left:30px;top:596px;width:1000px}
.chips{display:flex;gap:12px;margin-top:8px}
.chip{flex:1;background:#262b32;border-left:8px solid #6d7784;padding:10px 12px;position:relative}
.chip .w{font-family:'Bebas Neue';font-size:34px;line-height:34px}
.chip.bond{border-left-color:#8fb4d8}.chip.clash{border-left-color:#b5534a}
.chip .hov{display:none;position:absolute;left:0;bottom:100%;width:330px;background:#0d0f12;border:1px solid #4a525d;padding:10px 12px;font-size:13px;line-height:19px;z-index:5}
.chip:hover .hov{display:block}
#hire{position:absolute;right:30px;bottom:24px;width:300px;height:76px;border:3px solid #c9971f;color:#f0d79a;font-size:36px;display:flex;align-items:center;justify-content:center;background:#2a2418}
#others{position:absolute;left:1084px;top:0;width:788px;height:860px}
.oc{background:#1d2127;border:1px solid #2f353d;padding:18px 22px;margin-bottom:16px;height:250px;position:relative}
.oc h2{font-size:38px;line-height:38px}
.oc ul{list-style:none;margin-top:10px}.oc li{padding:5px 0;border-bottom:1px solid #2a2f36;font-size:14px}
.oc .b{position:absolute;right:22px;bottom:18px;border:1px solid #6d7784;padding:8px 18px;font-family:'Bebas Neue';font-size:24px}
#trade{background:#1a1e23;border:1px dashed #4a525d;padding:14px 18px;height:310px;font-size:14px;line-height:21px}
#foot{position:absolute;left:24px;bottom:16px;width:1872px;font-size:12px;color:#8f877a}
</style></head><body>
<div id="top"><span class="t d">THE HIRE LIST · NOVEMBER</span><span>3 coaches this month · 1 place left on your staff (of 4)</span><span class="sp"></span><span class="tag">example state, not engine output</span><span>Cash $14,200 · runway 11 weeks</span></div>
<div id="scene">
 <div id="lead">
  <h1 class="d">THE FILM-ROOM COACH</h1>
  <div class="sub mut">Counter-puncher playbook · film 17 · tactics 15 · wants more (ambition 14)</div>
  <svg id="fig" viewBox="0 0 300 520"><rect width="300" height="520" fill="#22272e"/>
   <g fill="#6d7784"><circle cx="150" cy="110" r="52"/><path d="M60 520 L72 260 Q150 190 228 260 L240 520 Z"/><rect x="104" y="300" width="92" height="10" fill="#3a414b"/></g>
   <text x="150" y="500" fill="#a59d8e" font-size="13" text-anchor="middle" font-family="IBM Plex Mono">silhouette until portrait</text></svg>
  <div id="facts">
   <div class="fact"><div class="mut">WAGE</div><div class="v">$440 A WEEK</div><div class="mut">one wage rule: ratings set it</div>
    <div class="hov">P = (4 teaching + 3 pads + 2 tactics + 2 conditioning + motivation + film + 0.5 cutman + 0.5 weight) / 14. Wage $150 + $125 a point over 9. Wage bill after hiring: $1,530 a week.</div></div>
   <div class="fact"><div class="mut">PAYS FOR ITSELF</div><div class="v">AT ABOUT 48 MEMBERS</div><div class="mut">you have 61 · pays today</div>
    <div class="hov">Class nights the coach can run plus the dues of the members the coaching lets the gym carry, against the wage.</div></div>
   <div class="fact"><div class="mut">IN THE CORNER</div><div class="v">READS THE OPPONENT</div><div class="mut">the opponent's mode clue right 4 times in 5 <span class="tag">critic proposal</span></div>
    <div class="hov">Live: the coach's tactics set how often the opponent's mode clue is right and which 3 calls are offered. Simmed: the coach makes the calls, best 3 times in 5. A bonded coach is heard more; a clashing coach has one call ignored a fight.</div></div>
   <div class="fact"><div class="mut">WHAT THIS COACH CHANGES IN A SEASON</div><div class="v">NOT COMPUTED</div><div class="mut">"wins about X more" waits for a training-only measure</div>
    <div class="hov">The X must come from training (the coach's ratings on each boxer's learning over a season), never from the corner, until the corner rule is wired. Shown NOT COMPUTED rather than a guess.</div></div>
  </div>
  <div id="chem">
   <div class="d" style="font-size:26px">HOW THIS COACH GETS ON WITH YOUR BOXERS · hover for why</div>
   <div class="chips">
    <div class="chip bond"><div class="mut">Women's lightweight · out-boxer</div><div class="w">BOND</div><div class="mut">learns faster</div><div class="hov">A patient coach with an unsure boxer. Up to 4.5% faster learning, more trust in the corner.</div></div>
    <div class="chip"><div class="mut">Women's featherweight · out-boxer</div><div class="w">FINE</div><div class="mut">no effect either way</div><div class="hov">No trait pulls either way. Weeks together nudge it towards bond (cap +0.25).</div></div>
    <div class="chip clash"><div class="mut">Men's welterweight · pressure fighter · your pro</div><div class="w">CLASH</div><div class="mut">your best boxer · the week cannot move this pairing</div><div class="hov">Two hot tempers. If the two work together 4+ weeks they may fall out: the boxer takes a warning. Your current coach already carries the most boxers a coach can take, so the week cannot move this pro away.</div></div>
   </div>
  </div>
  <div id="hire" class="d">HIRE</div>
 </div>
 <div id="others">
  <div class="oc"><div class="mut">ALSO THIS MONTH</div><h2 class="d">THE KNOWN NAME</h2><ul>
   <li>$960 a week</li><li>Pays only with a pro or a title boxer in the corner</li><li>Bond with your pro · clash with no one</li><li>Name fee: 60% of a pro purse, up to $4,000 a bout</li></ul><div class="b">SEE THE CARD</div></div>
  <div class="oc"><div class="mut">ALSO THIS MONTH</div><h2 class="d">THE ENGINE ROOM</h2><ul>
   <li>$420 a week</li><li>Pays for itself at about 48 members</li><li>Fine with all three</li><li>Conditioning best; tactics low</li></ul><div class="b">SEE THE CARD</div></div>
  <div id="trade"><div class="d" style="font-size:26px">THE TRADE THIS MONTH <span class="tag">critic proposal</span></div>
   The film-room coach is the best on paper for a gym your size, and clashes with your pro.<br><br>
   The known name bonds with your pro and earns the fee in the corner, at more than twice the wage.<br><br>
   The engine room clashes with no one and costs least, but reads the opponent worst in the corner.<br><br>
   <span class="mut">Unchosen candidates leave at month end. Next list: 1 December.</span></div>
 </div>
</div>
<div id="foot">Kalli · critic page · COACHMAP1 · example state, not engine output · names: candidate's job in the header, boxers by class and style · gold on Hire only · no green (no Continue on this screen) · kit gaps: a coach portrait set (silhouette here), a chemistry chip with three states and a hover card, a coach-capacity fact on the week plan</div>
</body></html>
```

I scored the coaches mechanic 5 for depth, 5 for play and 6 for general design, so it's below the bar of 8 on both counts. I'd keep it only if it changes.

Only the raise and the style push are real calls today. Four changes would fix the rest:
- **Give the corner coach a job while you call the fight live:** how often the opponent's mode clue is right, how much of your call the boxer hears, and recovery points between rounds.
- **Let the coach make the calls in a simmed bout,** capped so calling it yourself always pays.
- **Limit how many boxers each coach can take,** so a clash on the hire card can't just be paired away.
- **Re-run the hire test with the chemistry word showing,** across varied rosters.

I couldn't check the code lines: my copy of the repository is from 16 Nov and fetching fails on the GitHub login. The page and its PNG are in `/workspace/coachmap1/`, but your computer is offline, so I couldn't copy them over.

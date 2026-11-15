You are the screen designer for FightCamp, a boxing gym management game (Godot, 1920x1080, Look B: dark wood shell, slate
board, cream cards, marker fonts for titles only, the ONE gold frame marks the recommended choice, red buttons for actions).
Rules from the owner: names appear ONLY in headers (rows, options, buttons say "her", "the opponent", "your coach"); game words,
not jargon; only information the player can act on; every number on the page must agree with every other number on it.

Return ONE complete HTML page, from <!doctype html> to </html>, in ONE reply, UNDER 20 KB, 1920x1080, self-contained (inline CSS,
Google Fonts Barlow + Permanent Marker only, photo slots as grey boxes with the word "photo"). Reuse the look of the TEMPLATE below
(its frame, header, card and button classes) so the new page sits beside it. Nothing before or after the HTML except, at the end,
a list "SCORE YOURSELF: depth x/10, design x/10" and "TO REACH 10/10:" (most important first).

# DRAW: WEIGHT M1 - Fight prep, CAMP AND WEIGHT (S480)
The owner approved the weight design (his answers: a boxer at fault keeps today's rule - bout off, $300 to the club; men's
featherweight is 55 kg; a women's 70 kg class is added). Draw the screen section 9 describes, filled with the worked example 8.1
(Samira Khan, 65 kg, London regional, 12 days out), so every number is the map's. A SECOND small panel in the bottom-right corner
(about 520x260) shows the same block when nothing is at stake: one line, "Weight is safe: nothing to decide".

## The map's section 9 (the layout)
## 9. M1 for the owner's mockup: Fight prep, CAMP AND WEIGHT (1920×1080, Look B whiteboard)
- **Dark top bar:** CONTINUE ("to Sat 28, the scale at 6 pm"), the only green.
- **Header:** portrait, the name once, the class, the record, the bout circled in marker.
- **Left, THE SCALE:**
  - a marker line from today's weight to the target, with the walk dotted;
  - the room under the cap in words ("0.4 kg room");
  - the miss risk in words;
  - at a club show, the declared weight and the opponent's declared weight with the fog band.
- **Centre, THE PLAN:**
  - the coach's row in the one gold frame;
  - three magnets: Burn mornings, If the fighter asks, Monday check, each with its price;
  - one pencil alternative;
  - "All plans" greyed until needed.
- **Right, FIGHT NIGHT:**
  - Energy at the bell, stacked, for both corners;
  - the window shaded across 18 exchanges with its round split;
  - the "when the opponent tires" line with its fires, Drill it / Write it, and a link to round pace.
- **Bottom strip:** the deciding costs in words, and "Too close to call on WIN" when it is.
- **When nothing is at stake,** the whole block is one line: "Weight is safe: nothing to decide".

Part 5 of 5

## The map's sections 5.1-5.6 (the levers and their prices)
### 5.1 The price of a kilo (one rate; ESTIMATE, B1)
- **The rate:** 7,700 kcal a kg, the stand-in until Claude reads the code's rate (CHECK Claude). If the code differs, every kg below is re-printed from it.
  - Lean −250 kcal a day = −0.032 kg a day.
  - Cut −500 a day = −0.065 kg a day, so **Cut 5 days = −0.32 kg**.
  - The Old hand's −620 = −0.08 kg a day.
- **Trim:** −1 Energy a 0.1 kg up to 0.5, −2 a 0.1 kg from 0.5 to 1.0, −3 a 0.1 kg past 1.0. The cap is 2% of the target in 3 days (REAL.md 7).
- **Diet tiredness (ESTIMATE):** Lean +0.5 a day, Cut +1.5 a day. That's the price of a diet before the trim.
- **What a point of Energy buys:** the window (5.8) and the round's power (CODE tired_penalty). As a win chance, 0.4 in 100 a point (ESTIMATE, P10).

### 5.2 D1. Burn mornings (pick 0 to 3)
- **What's offered:** mornings from the coach's real PEAK week (CODE) that don't already burn. A picked morning becomes Hard roadwork, priced by WeekPlan.day (CODE). The fight week stays the coach's taper.
- **Each magnet prints** the kg it burns, the Energy it saves at the bell, and the ability it no longer trains, by its Attrs name ("Shadow: Accuracy −0.12"; the session-to-ability list is CHECK Claude).
- **A morning that feeds the goal** also prints the goal's forecast against its line, and the goal-missed mood: the CODE MORALE_EVENTS value, printed as the code holds it (CHECK Claude; round 4's −19.9 is withdrawn).
- **The coach never pre-picks a goal morning.** If the code's goal-missed value turns out bigger than a bout loss (−12), P14 tests whether D1 has become a lookup ("never burn a goal morning"). If it has, goal mornings are simply not offered and D1 keeps the other mornings.

### 5.3 Tiredness at the bell, as a function
- **The rule:** Energy price = 2 × (tiredness at the first bell − 50), at least 0, at most 20. That's CODE stale_energy, extended from "after a camp" to every booked bout (NEW, B6). **B6 ships with B0 under one 59/45/41 re-measure**, because both move every amateur bout.
- **Tiredness at the bell** = tiredness on the fight-week Monday + the fight week's sessions and diet − the TAPER's rest days (CODE recovery; the per-day value is CHECK Claude).

| Fight-week Monday | Trust the trim | Cut 5 days | One burn morning in PEAK, then trust |
|---|---|---|---|
| 40 (fresh) | 0 | 0 | 0 |
| 55 | 0 | 0 if the taper drains 8+, else 2–4 | 0 |
| 70 (worn) | 6–10 | 14–18 | 8–12 |

All ESTIMATE until the rest-day value is read. A Cut is cheap for a fresh boxer and dear for a worn one; the tiredness bar on the plan row shows which applies.

### 5.4 D2. If the fighter asks to eat (a standing answer); meal prep; the nutritionist
- **The ask (NEW, B7):** a weekend ask beside the weekly card, built on CODE PushBack.
  - It comes when a diet runs and discipline is under 50, at lerp(0.6, 0.2, coachability ÷ 100) of those weekends.
  - Discipline 50+ never asks, so that boxer's panel has no D2.

| Answer | kg (ESTIMATE) | Mood | Best when |
|---|---|---|---|
| **Let the fighter eat** | +0.5 | heard, +5 (CODE) | Flat near Steady, and the trim has room |
| **Half a plate** | +0.2 | 0; −2 under discipline 40 (NEW, ESTIMATE) | the trim near a tier, and mood with room above a band edge |
| **No** (the coach's) | 0, but under discipline 50 the fighter eats anyway (50 − discipline) in 100 (ESTIMATE) | overruled, −5 (CODE) | mood well inside a band, trim near the cap |

- **Meal prep:** $10 a day for this bout's days (ESTIMATE, TO SOURCE B13), printed as "−$120 from the club's cash, 12 days". **One effect: a No always holds.** It's offered only beside a No; the Let-eat-plus-meal-prep row is cut.
- **Nutritionist for this cut:** $60 a cut (ESTIMATE, TO SOURCE B13), bought on Fight prep for one cutting boxer. **One effect:** that boxer's asks × 0.5 for this cut. Nobody pays for an idle week. The Club > People staff job is withdrawn.

### 5.5 What the player sees: costs first, folded
- **The coach's row,** in the page's one gold frame:
  - Energy at the bell as a stacked bar (tiredness, trim, sweat);
  - the miss risk in words ("1 in 100");
  - then **the deciding costs**: "Flat on the night 2 in 5", "Goal: on track", "Cash: no cost";
  - the hover "the coach's row was best in n of your last m bouts" (NEW, from the Why history).
- **WIN:** it's a column only when the spread between sensible plans is 3+ in 100 (P1). Otherwise it reads **"Too close to call on WIN"**.
- **One alternative row** in pencil: the best row that differs in one lever.
- **"All plans"** stays greyed until the miss risk is 5 in 100+ or the WIN spread is 3+.

### 5.6 D3. If the Monday check reads over (Monday of the fight week; a standing answer)
| Answer | Price | Best when |
|---|---|---|
| **Trust the trim** (the coach's) | the trim's Energy price | the trim stays under 1.0 |
| **Cut 5 days** | −0.32 kg; tiredness +7.5, priced by 5.3 | the trim passes 1.0 and the boxer is fresh |
| **Pull out now** | 5.7 | the forecast trim is near the cap |

**Miss chance by room under the cap** (ESTIMATE, B1): 1 in 100 at 0.4 kg, 4 at 0.27, 8 at 0.2, 20 at 0.1.

## The worked example 8.1 (fill the page with these numbers)
### 8.1 Example: Samira Khan (Data.gd:210-213), London regional, 65 kg, 12 days out
**The boxer**
- 65.9 kg now, walks 66.8; discipline 34, coachability 52; mood 54 Steady.
- Goal Defence (the skill) 50.8, example. Tiredness 45 on the fight-week Monday, so 0 Energy price.
- The scale is 1 hour before; the target is 65.05. That's 0.85 kg to lose.

**The coach's row:** Lean for 9 days −0.29, then a trim of 0.56. Price 5 + 1.2 = 6.2, so **Energy 94 at the bell**. Only the meal comes back; there's no refuel.

**D1:**
- Tue and Thu feed the goal. Burning them puts Defence under its line, and the goal-missed value (CODE, CHECK Claude) shows on the magnet.
- Sat (Shadow) costs Accuracy −0.12 and burns 0.06 kg, so the trim is 0.50 and **Energy 95**. The player burns Sat.

**D2:** the ask comes about 2 weekends in 5 (lerp at coachability 52 = 0.39).
- "No" drops mood to 49, Flat, and the fighter still eats 16 times in 100.
- "Half a plate" costs −2 (discipline under 40), so mood 52, still Steady. Trim 0.70, **Energy 91**.
- The player sets Half a plate. Meal prep would make a No hold for $120, but No itself makes the boxer Flat, so it's the wrong buy for this boxer.

**D3:** Trust the trim. Miss 2 in 100, so "All plans" stays greyed.

| Plan | Energy at the bell, clean / if asked | Mood on the night if asked | Deciding cost |
|---|---|---|---|
| Coach's (no burn, No) | 94 / 94 (83 if the fighter eats anyway) | Flat 49 | Flat 2 in 5 |
| **Yours: Sat burned, Half a plate** | 95 / 91 | Steady 52 | Accuracy −0.12 |
| Sat burned, Let eat | 95 / 85 | Steady 59 | 10 Energy if asked |
| Sat burned, No + meal prep | 95 / 95 | Flat 49 | −$120 from the club, Flat 2 in 5 |
| All three burned, Half a plate | 96 / 93 | Steady 52 | goal at risk (CODE value) |

**WIN:** too close to call. The spread is under 3, so the choice rests on the right-hand column.

**The window:** the opponent is 86 at the bell (OPPWEIGHT, B2). The window is 5 exchanges, split R2: 1 · R3: 4.

**D5,** with both BUILT systems:
- **Usable, undrilled 1-2-3:** (1 × ¾ × ½) + (4 × ¾ × ½) = 1.9 fires, all inside PlanRead's full 2 a round. × 9 × 0.8 = **13.5**.
- **The pressing line it would replace** ("When the opponent presses → Step back", Works 3, Sharp): 2 pressing exchanges a round × ¾ = 4.5 fires × 3 = **13.5**.
- **A tie, so don't write it yet.** The 1-2-3 is at 52 (example), and two pad nights take it past Sharp 60. Then R3 has 2.25 fires (2 full + 0.25 at ½), and the total is (0.56 + 2.13) × 9 = **24**.
- **Fight prep says "Drill it on the pads, then Write it".** Round 4's "write it now" verdict is reversed.

## TEMPLATE (the S479 sparring partner screen the owner approved - copy its look)
<!doctype html>
<html><head><meta charset="utf-8"><title>Sparring partner v1 (S479)</title>
<link href="https://fonts.googleapis.com/css2?family=Barlow:wght@500;600;700;800&family=Permanent+Marker&display=swap" rel="stylesheet">
<style>
:root{--ink:#ece7dc;--dim:#a9b0b8;--line:#4a5560;--gold:#f2c14b;--red:#d9463a;--green:#58c27a;--blue:#4f8fe0;--board:#2c3236}
*{box-sizing:border-box;margin:0;padding:0}
body{width:1920px;height:1080px;overflow:hidden;font-family:Barlow,Arial,sans-serif;color:var(--ink);
 background:#3a2c1f radial-gradient(900px 500px at 50% 40%,#4a3826,#2a1f15)}
.frame{position:absolute;left:150px;top:14px;width:1620px;height:1052px;border:16px solid #6b4a2b;border-radius:8px;
 box-shadow:inset 0 0 0 3px #3a2816,0 10px 40px rgba(0,0,0,.7);
 background:var(--board) radial-gradient(1200px 700px at 40% 30%,#3a4146,#24292c)}
.m{font-family:"Permanent Marker",cursive}
.inner{position:absolute;inset:18px 26px}
/* header 96 */
.hd{height:96px;display:flex;align-items:center;gap:22px;border-bottom:2px solid #55606a}
.por{width:74px;height:74px;border-radius:6px;background:#6b7a88;border:2px solid #cfd6dd;display:flex;align-items:center;justify-content:center;font-size:12px;color:#223}
.hd .nm{font-size:30px;line-height:1}.hd .sub{font-size:17px;color:var(--dim);margin-top:6px}
.vs{font-size:24px;color:var(--dim)}
.tags{margin-left:auto;display:flex;gap:10px;align-items:center}
.tag{border:2px solid #6d7882;border-radius:7px;padding:6px 10px;font-weight:700;font-size:17px;white-space:nowrap}
.tag.g{border-color:var(--gold);color:var(--gold)}.tag.b{border-color:var(--blue);color:#9cc3ff}
.days{font-size:44px;color:var(--gold);line-height:1;text-align:center}.days small{display:block;font-family:Barlow;font-size:14px;color:var(--dim)}
/* week-before strip 84 */
.strip{height:84px;margin-top:10px;display:flex;align-items:center;gap:16px;border:2px dashed #7d8790;border-radius:8px;padding:0 16px;background:rgba(255,255,255,.03)}
.strip .lbl{font-size:24px;color:#d9dee3;width:200px}
.pill{border:2px solid #6d7882;border-radius:20px;padding:7px 14px;font-weight:700;font-size:17px}
.pill.on{border-color:var(--gold);background:rgba(242,193,75,.12);color:var(--gold)}
.mag{width:52px;height:52px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:13px;color:#fff;box-shadow:0 3px 6px rgba(0,0,0,.5)}
.mag.spar{background:var(--red)}.mag.film{background:#2b2b2b;border:3px solid #ddd}.mag.pads{background:var(--blue)}
.note{font-size:16px;color:var(--dim)}
/* body columns */
.body{position:absolute;top:212px;left:0;right:0;height:676px;display:flex;gap:18px}
.col{display:flex;flex-direction:column;gap:9px}
.card{border:2px solid #5c6670;border-radius:9px;padding:12px 14px;background:rgba(0,0,0,.18)}
.card.on{border-color:var(--gold);box-shadow:0 0 0 2px rgba(242,193,75,.25)}
.card.red{border-color:var(--red)}
.ttl{font-size:22px;margin-bottom:6px}
.row{display:flex;justify-content:space-between;font-size:16px;margin:3px 0}
.row b{font-weight:800}.up{color:var(--green)}.dn{color:#ff8a7a}.gold{color:var(--gold)}
.sec{font-size:22px;color:#d9dee3;margin:2px 0 2px}
/* centre */
.daysrow{display:flex;gap:8px}
.day{flex:1;height:132px;border:2px solid #56616b;border-radius:8px;padding:6px;display:flex;flex-direction:column;align-items:center;gap:6px;background:rgba(255,255,255,.03)}
.day .d{font-weight:800;font-size:16px}.day .t{font-size:13px;color:var(--dim);text-align:center}
.day.bell{border-color:var(--gold);background:rgba(242,193,75,.08)}
.load{display:flex;gap:10px}
.stop{flex:1;border:2px solid #5c6670;border-radius:9px;padding:7px 12px;background:rgba(0,0,0,.18);position:relative}
.stop.on{border-color:var(--gold);background:rgba(242,193,75,.08)}
.stop .n{font-size:21px}.stop .best{font-size:14px;color:var(--dim);margin-top:4px;font-style:italic}
.hov{position:absolute;left:104%;top:auto;bottom:-10px;width:250px;width:330px;background:#14181b;border:2px solid var(--gold);border-radius:8px;padding:8px 10px;font-size:15px;z-index:5;box-shadow:0 8px 24px rgba(0,0,0,.6)}
.chips{display:flex;gap:8px;flex-wrap:wrap}
.chip{border:2px solid #6d7882;border-radius:7px;padding:5px 10px;font-weight:700;font-size:15px}
.chip.uns{border-color:var(--red);color:#ff9a8a}.chip.rdy{border-color:var(--green);color:#8fe0a8}
.wt{display:flex;gap:10px}
.wp{flex:1;border:2px solid #5c6670;border-radius:9px;padding:6px 12px;font-size:15px}
.wp.off{opacity:.45}
/* right gold frame */
.gold-frame{border:4px solid var(--gold);border-radius:10px;padding:14px 16px;background:rgba(242,193,75,.05);height:100%;display:flex;flex-direction:column;gap:10px}
.ready{font-size:22px;color:var(--gold)}
.tank{height:30px;display:flex;border:2px solid #6d7882;border-radius:6px;overflow:hidden}
.tank div{height:100%}
.band{font-size:15px;color:var(--dim)}
.big{font-size:34px;font-weight:800}
.ln{display:flex;justify-content:space-between;align-items:center;font-size:16px;padding:4px 0;border-bottom:1px solid #46505a}
.tg{font-size:12px;font-weight:800;border-radius:4px;padding:2px 6px;margin-left:6px}
.tg.r{background:#2f6b45}.tg.u{background:#8a2c24}.tg.s{background:#5a4a12;color:var(--gold)}
/* bottom 120 */
.bot{position:absolute;bottom:0;left:0;right:0;height:112px;border-top:2px solid #55606a;display:flex;align-items:center;gap:18px}
.asst{display:flex;gap:12px;align-items:center;flex:1}
.asst .por{width:64px;height:64px}
.asst .say{font-size:24px;line-height:1.2}.asst .why{font-size:16px;color:var(--dim)}
.btn{border-radius:8px;padding:14px 22px;font-weight:800;font-size:20px;border:2px solid #7a6a55;background:#3b2f24}
.btn.red{background:#b2352b;border-color:#e2675c}

.cols{position:absolute;top:110px;left:0;right:0;height:800px;display:flex;gap:20px}
.side{flex:0 0 400px;width:400px;display:flex;flex-direction:column;gap:10px}
.mid{flex:1;min-width:0;display:flex;flex-direction:column;gap:7px}
.sec{white-space:nowrap}
.pol{width:112px;height:134px;background:#efe9dc;padding:8px 8px 26px;transform:rotate(-2deg);box-shadow:0 6px 14px rgba(0,0,0,.5)}
.pol div{width:100%;height:100%;background:#6b7a88;display:flex;align-items:center;justify-content:center;color:#223;font-size:13px}
.ptop{display:flex;gap:16px;align-items:flex-start}
.facts .row{font-size:17px;gap:10px}
.prow{display:grid;grid-template-columns:48px minmax(0,1fr) 130px 168px;gap:10px;align-items:center;background:#efe9dc;color:#2a2622;border-radius:8px;padding:6px 10px;box-shadow:0 3px 8px rgba(0,0,0,.4)}
.prow.off{opacity:.5}
.prow .sil{width:48px;height:48px;border-radius:6px;background:#b9b2a5;display:flex;align-items:center;justify-content:center;font-size:11px;color:#444}
.prow .who{font-weight:800;font-size:18px}
.prow .what{font-size:14px;white-space:nowrap;color:#4d4740;margin-top:2px}
.prow .rd{font-size:13px;white-space:nowrap;color:#6a6258;margin-top:3px;font-style:italic}
.mw{text-align:center;font-weight:800;font-size:22px;border:2px solid #8a8175;border-radius:8px;padding:4px 0}
.mw small{display:block;font-size:13px;font-weight:600;color:#5d564d}
.mw.close{color:#1f6b3a;border-color:#2f8a4f}.mw.part{color:#7a5a12;border-color:#b08a2e}.mw.loose{color:#7a2c24;border-color:#a8473c}
.mw.pick{border:4px solid var(--gold);box-shadow:0 0 0 3px rgba(242,193,75,.45)}
.cost{font-size:15px;text-align:right;font-weight:700}
.sb{display:block;margin-top:3px;border-radius:7px;padding:7px 8px;font-weight:800;font-size:15px;text-align:center;background:#b2352b;color:#fff;border:2px solid #e2675c}
.sb.done{background:#2f6b45;border-color:#58c27a}
.sb.grey{background:#8f877c;border-color:#8f877c;font-size:13px}
.asstnote{font-size:13px;font-weight:800;color:#7a5a12;background:#f6dd8f;border-radius:4px;padding:2px 6px;display:inline-block;margin-top:4px}
.mh{display:flex;justify-content:space-between;align-items:baseline}
.key{font-size:15px;color:var(--dim)}
.q{color:var(--dim)}
.tell{border-left:4px solid var(--green);padding-left:8px;font-size:16px;margin:4px 0}
.tell .tw{font-size:13px;color:var(--dim)}
</style></head><body>
<div class="frame"><div class="inner">

<div class="hd">
 <div class="por">photo</div>
 <div><div class="nm m">Sparring, Tue, 4 days out</div><div class="sub">Lucy &nbsp;&middot;&nbsp; pick one partner &nbsp;&middot;&nbsp; a closer partner readies more plan lines</div></div>
 <div class="tags"><div class="tag">Favours with the host &#9679;&#9675;&#9675;</div><div class="tag">Cash $1,240</div><div class="tag b">AWAY at Fitzroy Lodge</div></div>
</div>

<div class="cols">
 <div class="side">
  <div class="sec m">Your boxer</div>
  <div class="card"><div class="ptop">
   <div class="pol"><div>photo</div></div>
   <div class="facts" style="flex:1">
    <div class="row"><span>Class</span><b>60 kg</b></div>
    <div class="row"><span>Stance</span><b>orthodox</b></div>
    <div class="row"><span>Height</span><b>168 cm</b></div>
    <div class="row"><span>Reach</span><b>172 cm</b></div>
    <div class="row"><span>Style</span><b>Pressure</b></div>
   </div></div></div>
  <div class="card">
   <div class="ttl">What matters against a counterpuncher</div>
   <div class="row"><span>Feints - draw the counter early</span><b>58</b></div>
   <div class="row"><span>Defence - take it on the gloves</span><b>61</b></div>
   <div class="row"><span>Ring IQ - stop walking straight in</span><b>49</b></div>
  </div>
  <div class="card on">
   <div class="ttl">Lines this night readies</div>
   <div class="row"><span>&#10003; Waits &rarr; feint, body hook</span><span class="tg r">READIED</span></div>
   <div class="row"><span>&#10003; Pressed &rarr; step back</span><span class="tg r">READIED</span></div>
   <div class="row"><span>&#10003; Loads up &rarr; check hook</span><span class="tg r">READIED</span></div>
   <div class="row q" style="font-size:14px"><span>CLOSE readies all 3 &middot; PART 2 &middot; LOOSE 1</span></div>
  </div>
  <div class="card"><div class="row"><span>Tiredness now</span><b>34</b></div><div class="row"><span>This night</span><b class="dn">-3 tank</b></div></div>
 </div>

 <div class="mid">
  <div class="mh"><div class="sec m">Sparring partners</div><div class="key">R1 = round-1 edge &middot; points: style 2 &middot; stance 1 &middot; reach &plusmn;5 cm 1 &middot; each filmed tell 1</div></div>

  <div class="prow">
   <div class="sil">photo</div>
   <div><div class="who">Club boxer &middot; 57 kg</div>
    <div class="what">Counter &middot; orthodox &middot; reach 2 cm shorter &middot; level</div>
    <div class="rd">also drops the right after the jab (your coach's notes)</div><div><span class="asstnote">your assistant's pick: counters like her and shares her tell</span></div></div>
   <div class="mw close pick">CLOSE<small>5 pts &middot; 3 lines &middot; R1 +1.0</small></div>
   <div><div class="cost">free</div><span class="sb done">Picked</span></div>
  </div>

  <div class="prow">
   <div class="sil">photo</div>
   <div><div class="who">Boxer at Fitzroy Lodge</div>
    <div class="what">Counter &middot; orthodox &middot; reach 1 cm longer &middot; above</div>
    <div class="rd">no tell of theirs found yet &middot; injury that night x1.15</div></div>
   <div class="mw part">PART<small>4 pts &middot; 2 lines &middot; R1 +0.5</small></div>
   <div><div class="cost">$160 or 1 favour</div><span class="sb">Spar with this partner</span></div>
  </div>

  <div class="prow">
   <div class="sil">photo</div>
   <div><div class="who">Boxer at St Anne's ABC</div>
    <div class="what">Counter &middot; southpaw &middot; reach 4 cm shorter &middot; level</div>
    <div class="rd">the test is marked "likely"</div></div>
   <div class="mw part">PART<small>3 pts &middot; 2 lines &middot; R1 +0.5</small></div>
   <div><div class="cost">$160</div><span class="sb">Spar with this partner</span></div>
  </div>

  <div class="prow">
   <div class="sil">photo</div>
   <div><div class="who">Club boxer &middot; 63 kg</div>
    <div class="what">Pressure &middot; southpaw &middot; reach 6 cm longer &middot; above</div>
    <div class="rd">test: Works / Walks into it only &middot; injury that night x1.15</div></div>
   <div class="mw loose">LOOSE<small>0 pts &middot; 1 line &middot; R1 +0</small></div>
   <div><div class="cost">free</div><span class="sb">Spar with this partner</span></div>
  </div>

  <div class="prow">
   <div class="sil">photo</div>
   <div><div class="who">Club member</div>
    <div class="what">orthodox &middot; style unknown &middot; below</div>
    <div class="rd">Beats it reads "?" &middot; the test may flatter</div></div>
   <div class="mw loose">LOOSE<small>1 pt &middot; 1 line &middot; R1 +0</small></div>
   <div><div class="cost">free</div><span class="sb">Spar with this partner</span></div>
  </div>

  <div class="prow off">
   <div class="sil">photo</div>
   <div><div class="who">Boxer at Repton</div>
    <div class="what">Counter &middot; orthodox &middot; reach 3 cm longer &middot; above</div>
    <div class="rd">no tell of theirs found yet</div></div>
   <div class="mw part">PART<small>4 pts &middot; 2 lines &middot; R1 +0.5</small></div>
   <div><div class="cost">1 favour</div><span class="sb grey">no favours with this host</span></div>
  </div>
 </div>

 <div class="side">
  <div class="sec m">Priya Nair</div>
  <div class="card"><div class="ptop">
   <div class="pol" style="transform:rotate(2deg)"><div>photo</div></div>
   <div class="facts" style="flex:1">
    <div class="row"><span>Record</span><b>4-2</b></div>
    <div class="row"><span>Style</span><b>Counter</b></div>
    <div class="row"><span>Stance</span><b>orthodox</b></div>
    <div class="row"><span>Height</span><b>170 cm</b></div>
    <div class="row"><span>Reach</span><b>174 cm</b></div>
   </div></div></div>
  <div class="card">
   <div class="ttl">Filmed tells</div>
   <div class="tell">Drops the right after her jab<div class="tw">seen twice on film &middot; true about 7 in 10</div></div>
  </div>
  <div class="card">
   <div class="ttl">Not found yet</div>
   <div class="row q"><span>When pressed: ?</span><span>film night: next group</span></div>
   <div class="row q"><span>Round 3 habit: ?</span><span>film night: next group</span></div>
   <div class="row q"><span>Body work: ?</span><span>look again</span></div>
  </div>
 </div>
</div>

<div class="bot">
 <div class="asst"><div class="por">coach</div><div><div class="say m">"The club boxer at 57 - counters like her, drops the right like her."</div><div class="why">Your assistant's pick - what drove it: the filmed tell. A film night finds the next group of tells.</div></div></div>
 <div class="btn">Back to the week</div>
</div>

</div></div>
</body></html>

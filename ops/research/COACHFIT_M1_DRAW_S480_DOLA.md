You are the screen designer for FightCamp, a boxing gym management game (Godot, 1920x1080, Look B: dark wood shell, slate
board, cream cards, marker fonts for titles only, the ONE gold frame marks the recommended choice, red buttons for actions).
Rules from the owner: names appear ONLY in headers (rows, options, buttons say "her", "the opponent", "your coach"); game words,
not jargon; only information the player can act on; every number on the page must agree with every other number on it.

Return ONE complete HTML page, from <!doctype html> to </html>, in ONE reply, UNDER 20 KB, 1920x1080, self-contained (inline CSS,
Google Fonts Barlow + Permanent Marker only, photo slots as grey boxes with the word "photo"). Reuse the look of the TEMPLATE below
(its frame, header, card and button classes) so the new page sits beside it. Nothing before or after the HTML except, at the end,
a list "SCORE YOURSELF: depth x/10, design x/10" and "TO REACH 10/10:" (most important first).

# DRAW: COACH FIT M1 - "Coaches this week" (Club > People) (S480)
The owner approved the coach fit design (board: "Yes, approve"). Draw the board its section 10.1 describes, filled with the
worked week 10.3 (week 12, the sessional assistant and the head coach), so every number is the map's. Three coach cards on the
left (sessional assistant, head coach = you, promoted club coach with "NO SPARRING: LEVEL 1"), two or three boxers in the centre
grid (five area cells each: Pads, Sparring, Conditioning, Strength, Bag), the Monday column on the right, the fight-week corner
strip at the bottom (one boxer has a bout within 14 days). Staff are named by ROLE ("Assistant coach", "Club coach"), never a
nickname. Fit words: TOP FIT / GOOD / MIXED / RISKY, always printed as words (colour only backs them).

## The map's section 10.1 (the board) and 10.3 (the worked week)
## 10. The weekly decision

### 10.1 "Coaches this week": Club > People in release 1 (moves to the Office Staff app when that app is built); Look B; owner-agreed mockup first
| Zone | Shows | Actions |
|---|---|---|
| Dark top bar (shell) | week, the next bout circled, "Coach time: 9.5 of 10 · 2 of 4 · 8 of 8" | the big CONTINUE only; the board saves as you edit |
| Left: coach cards | name in the card header; portrait and role; temper, and mode as a word with its price; coach time pips with "borrowed 1" in text; ceilings per area; "next +1 pads in 6 sessions"; school chips; wage; a raise sticky when asked; "NO SPARRING: LEVEL 1" on the club coach | mode switch; Rest this week; Pay / Give a day off / Say no; Let go (a week's pay); Promote; Send on the Level 2 course |
| Centre: who runs what | one row per boxer: portrait, class in kg, record, FOCUS pill (locked in camp; the coach's suggestion outlined). Five area cells, each with the coach magnet, fit word and bar, gain in its unit ("Jab +2.4" or "Speed +0.4"), bond pips, at most one tag in words. The Coach's pad nights row on top when two boxers are in camp | drag a coach onto a cell (This week / For good); set FOCUS; leave a morning uncoached; pick the 60 side |
| Right: on Monday | each boxer's FOCUS stat now and after the week; bonds crossing a step; next week's coach time; risks in red with their word; "Your board this week: +0.3 Speed, +2 Jab over the coach's"; one gold frame on the week's best gain | none |
| Fight week strip (a bout within 14 days) | corner magnets: word taken in, coach time cost, bond step, what moves to cover it; the cutman line on pro nights | pick the corner |

### 10.2 The Monday page (the week review; never a pop-up)
- "Jab 41 to 47: good fit with the pads coach."
- "Speed 62 to 63: FOCUS morning with the head coach."
- "Next week: 9 of 10 coach time (1 borrowed)."
- "The pads coach asks for $50 a week. Pay / Give a day off / Say no."
- "Your board this week: +0.3 Speed, +2 Jab over the coach's."
- "Your 65 kg boxer's Jab is near the pads coach's limit: about 5 weeks."
- First Monday after a signing: "Best fit for your new boxer: the pads coach." (moved from the Interview)
- **Last line, when it happens:** "Trusted with your 60 kg boxer: one more plan line in camp. Write it" (it opens the Game plan).

### 10.3 A worked bout week (week 12; the sessional assistant and the head coach with the Strength coach edge)
**The roster**
- **Your 60 kg boxer fights Saturday.** TAPER: 2 light pad nights, no sparring. Morale Flat (47, ESTIMATE), coachability 52. Trusted with the assistant, Working with the head coach.
- **Your 65 kg boxer is in PEAK:** 3 pad nights and 2 sparring nights. Morale Steady, Trusted with the assistant.

**The coach's default** (everything on the assistant, nothing shared): 2.0 + 3.0 + 3.0 + corner 3.0 = **11.0 of 10**, 1 over.

**The 65 kg boxer's pads cell:**
- On budget it's fit 56: Trusted +6, SHIELD 0, no suit. That's MIXED, gain ×1.06.
- At 1 over it's 48: still MIXED, ×0.98.

**Word taken in:**
- With the assistant: 0.85 × 1.004 × 1.05 = **90%**.
- With the head coach: 0.85 × 1.004 × 1.00 = **85%**.

| Answer | Assistant | Head coach | What changes (ESTIMATE) |
|---|---|---|---|
| **A. Leave it** | 11 of 10, −8 fit on all its cells | 0 of 4 | The 65 kg boxer's 1,080 units (720 pads + 360 sparring) drop from ×1.06 to ×0.98: −86 units, about −1 mastery point. Next week starts at 9 of 10, still in PEAK. Word taken in 90% |
| **B. Share two pad nights, the 65 kg boxer takes the 60** | 1.5 + 1.5 + 1.0 + 3.0 + 3.0 = 10.0 of 10 | 0 of 4 | On budget, but the 65 kg boxer gets 144 instead of 240 on two nights: −192 units, ×1.06 = about −204. The 60 kg boxer gets 96 instead of 240 on two light nights. **The worst answer in PEAK** |
| **C. The head coach takes the 60 kg boxer's two pad nights; the assistant corners** | 9.0 of 10 | 2.0 of 4 | 65 kg on budget at fit 56. The 60 kg boxer's two light nights run at 0.9 × the assistant's factor: about −10% of those units. The Trusted pair misses 2 bond. Word taken in 90% |
| **D. The head coach corners** | 8.0 of 10 | 3.0 of 4 | 65 kg on budget. The 60 kg boxer keeps the assistant on pads. Word taken in 85% |

**Add LIFT (+0.5):**
- **C plus LIFT** is 9.5 of 10. The Flat boxer gets +3 morale by Saturday: 47 to 50, which is Steady. LIFT is the right mode for that boxer (+4 fit on the assistant's cells for the 60 kg boxer only). Word taken in 1.00 × 1.004 × 1.05 = **105%**. The 65 kg boxer loses the SHIELD loss cushion, which costs nothing in a week with no bout.
- **D plus LIFT:** 1.00 × 1.004 × 1.00 = **100%**.

**The answer:** C plus LIFT. A is the borrowing trap, because next week's PEAK starts short. B shows that sharing costs most in a camp. D is right when the head coach has the stronger bond.

Part 5 of 5

One correction to 10.3: a mode covers every boxer that coach runs, **corner included**. Under C the assistant runs none of the 60 kg boxer's sessions, so LIFT gives that boxer the +3 morale through the corner but no +4 fit. The sums and the 105% stand.

## Fit, coach time and ceilings (sections 2.1-2.2, 3.3-3.4, 4.1)
## 2. Fit

### 2.1 Formula
**Fit = 50 + temper and mode + coach time + bond + taught out + focus, clamped 10–90.** At 50 a session runs exactly as today.

| Part | Values | Notes |
|---|---|---|
| Temper and mode | −12 to +10 | 5.2 |
| Coach time | 0 up to 0.5 over; −8 over 0.5 up to 1.5; −18 over 1.5 (2 at most) | on every cell that coach runs that week (ESTIMATE) |
| Bond | Stranger −4 (evenings only); Working 0; Trusted +6; Corner +12 | 6.1 |
| Taught out | 0, or −6 within 5 of that coach's ceiling | at or above the ceiling, ×0.5 (4.1) replaces this |
| Focus | +10 on the morning area that trains the FOCUS stat; −3 on the boxer's other coached mornings | mornings only (2.3) |

- **Gain multiplier = 0.5 + fit ÷ 100:** ×0.60 at 10, ×1.00 at 50, ×1.32 at 82.
  - **Evenings:** the multiplier applies to the drill units of every card that evening: 240 a pad night, the sparring night's 180 share, and the step study slot (CODE units).
  - **Mornings:** it applies to the stat gain.
- **Tiredness multiplier = 1.125 − 0.0025 × fit:** ×1.10 at 10, ×1.00 at 50, ×0.92 at 82.
- **Gain chain:** fit multiplies on top of the CODE gain (pace × coach factor × headroom clamp × Light/Normal/Hard, and the units-to-mastery maths). It replaces nothing.
- **Stack cap (NEW, ESTIMATE):** fit × the camp focus multiplier (1.1 / 1.2 / 1.35, CODE) never goes past ×1.6. The hover says "capped".
- **Reachable range:** about 10 to 82.

### 2.2 Fit words (every word printed; colour only backs the word)
| Word | Fit | Gain | Usually means |
|---|---|---|---|
| TOP FIT | 75+ | ×1.25+ | Corner or Trusted bond, a suiting temper, the right mode, on budget |
| GOOD | 58–74 | ×1.08–1.24 | Trusted, or FOCUS on a morning |
| MIXED | 40–57 | ×0.90–1.07 | Working bond, small mismatch, slightly over |
| RISKY | under 40 | under ×0.90 | 2 over, a clash, or near the ceiling |

**Each cell shows** the gain in its real unit:
- evenings: "Jab +2.4 · GOOD", in mastery points from the units;
- mornings: "Speed +0.4 · MIXED".

Hover lists every part and names the ceiling that binds.

### 2.3 One focus
- **FOCUS is one stat per boxer,** set on the pill. The coach's suggestion (the weakest stat with headroom) is outlined, never set for you.
- **In camp the pill is the camp focus,** locked to it. The camp modal's focus list moves onto Attrs names: Stamina, Strength, Accuracy, Defence, Speed (was Conditioning, Power, Technique, Defence, Speed). This is NEW and CHECK (Claude) against what each old focus trains.
- **The signing card's "one starting focus" is renamed "Start with"** (NEW label), so "focus" means one thing.
- **Mode tests read this week's drill cards,** not FOCUS (5.2).

### 3.3 Coach time a week (ESTIMATE)
| Coach | Coach time | Corner | Note |
|---|---|---|---|
| Sessional assistant ($450) | 10 | 3 | on budget in any BASE week; tight in camp |
| Full-time assistant ($1,090) | 14 | 3 | a camp plus a corner fits |
| Head coach (you) | 4 | 3 | the office takes the rest |
| Second club coach ($280) | 2 | none | coached conditioning mornings only |
| Promoted club coach ($450) | 8, then 10 at Level 2 | 3 | no sparring nights until Level 2 (9.1) |

**Evening costs:**
- pad night 1.0, or shared 1.5;
- sparring 1.5, or two boxers 2.0;
- film 0;
- corner 3.

**Everyday check** (BASE: 3 pad nights and 1 sparring night a boxer; CHECK Claude that this is the coach's BASE week):

| Week | Cost | Sessional (10) | Full-time (14) |
|---|---|---|---|
| One boxer, BASE | 3.0 + 1.5 = 4.5 | on budget | on budget |
| Two boxers, BASE | 9.0 | on budget, 1 spare | on budget |
| One BUILD (3 pad + 2 spar) and one BASE | 6.0 + 4.5 = 10.5 | 0.5 over, free | on budget |
| One PEAK (3 pad + 2 spar) and one fighting (2 pads + corner) | 6.0 + 5.0 = 11.0 | 1 over, −8 | on budget |

**Rest this week** (coach card): no sessions, bond paused, +3 coach time next week (it wipes any borrowing). The coach's cells go to cover (3.6).

### 3.4 Over budget, one rule
- **Over is allowed, up to 2.** The board refuses a drag past 2 over and says why. The overage comes off next week ("next week 9 of 10").
- **Fit penalty** on every cell that coach runs: 0 up to 0.5 over, −8 over 0.5 up to 1.5, −18 over 1.5.
- **Warnings:** an amber need on Home, "OVER BUDGET: sessional assistant 11 of 10", with a **Rest next week** button, and a Monday line.
- **Nothing is moved for you.**

### 4.1 Ceilings (NEW; always round down)
| Area kind | Ceiling | Above it |
|---|---|---|
| Morning (stats) | 55 + area rating × 0.35 | that stat's gain ×0.5, never a hard stop |
| Evening (moves and steps) | mastery up to the area rating | that card's units ×0.5, never a hard stop |

- **No rating in an area:** the area uses the coach's overall rating (ESTIMATE).
- **The head coach** uses the best assistant's ceiling in that area, or 60 for moves and 70 for stats with no assistant (ESTIMATE).

| Coach | Code stats | Pads (moves) | Sparring (moves) | Conditioning | Strength and Bag |
|---|---|---|---|---|---|
| Sessional assistant | pads 74, rating 58 | 74 | 58 | 75 | 75 |
| Full-time assistant | pads 58, conditioning 90, rating 74 | 58 | 74 | 86 | 80 |
| Promoted club coach | rating 45 (ESTIMATE) | 45 | none (no sparring until Level 2) | 70 | 70 |

**This is the real choice between the two hires:**
- The sessional assistant takes moves past Sharp on pads.
- The full-time assistant slows on pads above 58, just under Sharp 60, but carries conditioning to 86 and sparring to 74.
- Signature (85) on pads needs a coach grown to 85, or ×0.5 above the ceiling. Never a gate.

**More rules**
- **Near the ceiling:** within 5 of it, the tag "AT THE COACH'S LIMIT IN ABOUT n WEEKS" and −6 fit.
- **Which ceiling binds:** the boxer's potential (CODE headroom) or the coach's ceiling, whichever is lower. The hover names it ("slowed by the coach's limit" or "slowed by potential").
- **Week 1:** boxers sit at 55–65 and most moves are New or Raw, so under 15% of cells should carry the tag (probe TAUGHTOUT1).

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

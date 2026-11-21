# DESIGN_WEIGHT2_V2_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ279)

Brief: research/DESIGN_WEIGHT2_V2_CRITIC_KALLI.md
Sent: 2026-11-21 21:10 | collected: 2026-11-21 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring WEIGHT2 v2 now, judged against the 8/8 bar.

# WEIGHT2 v2: critic score (S459, fresh critic, 2026-11-21)

**Depth 6 · General design 7 · Play 5.** It fails the S534 bar, which needs 8 on Depth and 8 on Play.

It's the most honest weight design so far. It found the dead `eat_kg`, removed the automatic cut and the weight cage, and uses counted evidence for size and regain. But the probe it ran shows that the choices mostly collapse into one rule per scale. The one option that wins everywhere costs almost nothing, and the week to week part is a setting the player picks once and forgets.

## Depth: 6 / 10
**What works**
- **The scale type really changes the right answer.** On a same-day scale, cutting down loses. On a day-before scale, cutting is required. This held in all three probe rounds, and real boxing agrees: pros regain about 7 % (Murugappan and Reale 2022), while elite amateurs given 3 to 12 hours regain about 2 % and the regain doesn't predict who wins (Reale 2017). It's the strongest lever in the map.
- **Size is a counted lever**, about 3 wins in 100 per 1 % heavier (Baribeau 2023, 1,392 boxers). It's read where reach and height already are, and it adds no new "power carries up" number.
- **The refusal is shown before the player commits**, with three real answers (insist, wait, promise) that reuse existing mood, loyalty and promise prices.
- **A weight arc over a career** (filling out while young, a move that is eventually forced) is the right long-term shape.

**Why it stops at 6**
1. **CUT harder is in the leading group of all 10 cells**, and the map says so itself in finding 3. On a same-day scale it's free, because 2 kg is about 2 % water, inside the free zone. On a day-before scale it's simply right. A choice that never loses is a dominant pick, and the 4 / 2 / 2 / 2 split is noise: 0 of 10 cells have a clear winner.
2. **Once the bout type is known, the class decision is solved**: amateur stays or moves up, pro cuts or moves down. That's one rule, not a weekly trade-off.
3. **The water setting is nearly always Light.** Light is free up to 2 %, the drain past it is worth 0.9 points of win share, and an amateur can only ever be 1 to 3 % past the line before the scale catches them. So Hard only shows up when the player is forced into it, and at that point it isn't a choice.
4. **Refusing barely matters** (0.6 points, no cell changes its best), because waiting three bouts costs nothing.
5. **The deep parts aren't probed**: growth, the tolerance shrinking with age, the diet's coach slot, the Knowledge read and the ask. The club's own boxers don't even age yet (1.1). The career arc is where the depth would be, and none of it is measured.
6. **What's missing is the real amateur cutting dilemma**: a tournament weighs in every boxing day (World Boxing, in the map's own section 2). A hard cut for day 1 has to be made again on day 2 and day 3. The nationals draw already exists in the game, and the map doesn't use it.

## General design: 7 / 10
**What works**
- The CODE tables are exact, with five v1 errors corrected in the open.
- John's tags are kept, and the speculative chin and hand-speed drain from v1 was removed because no study carries it (Wittbrodt 2018).
- It's buildable: six numbers and three decisions, with section 3.8 listing what gets removed alongside what gets added. The menu table names every file.
- The miss rules by bout type follow real rules: a walkover at championships, 20 % of the purse for a pro (Oregon, California), and a belt lost on the scale under the IBF.
- It's easy to check against a real case: Ryan Garcia missed weight against Devin Haney in 2024, the bout went on, and Garcia paid. That's exactly the pro rule in 3.6.

**What it loses points on**
1. **The words break the sandbox rules.** The map uses a fixed "he" throughout ("his limit", "he asks") and boxer names in body text (Kira, Samira, Lucy). S412 and S448 apply to the design too, because these lines become tooltips. Every row needs "your boxer" and her / him.
2. **The class list.** It gives men's classes as 55 / 60 / 65 / 70 / 75. The owner's standing list is men's 57.5 / 60 / 70 / 75, and Q-292 now adds 65. The 55 against 57.5 question is still open from DMGCLASS1, and the same class lookup reads it.
3. **The probe fudges the pro field**: an offset of -10.9 is there because our boxers walk only 1.5 to 2.3 % over (risk 7). That should be fixed in the data (real walking weights of 3 to 5 %), not with an offset.
4. **Size may be counted twice** through frame (reach and height follow the limit) and mass (risk 6). The probe stripped the opponent's height and reach to dodge this, but a build won't.
5. **The Lean price is steep and unmeasured**: 12 % of training gain per 1 % under natural means -30 % gains at the 2.5 % line. It sits on 3 seeds with no evidence behind the slope, and that one number decides whether anyone ever picks Lean.
6. **The tolerance shrinking with age** has no evidence (NOT FOUND). Keep it as a labelled DESIGN number or cut it. Don't leave it as an ESTIMATE.

## Play: 5 / 10
- **Good moments**: the weigh-in, the tape row "walks 4 kg over: cuts hard", the Why line "outweighed by 3 kg in the ring", and hearing a no on the class card.
- **Week to week**, the diet is set once and kept. Water is one click in a fight week and almost always Light. The class card shows up a few times in a career. Nothing pulls the player back on a Monday.
- **The rewards are hard to feel.** The size edge comes out at 1.2 wins in 100 per 1 % on the ladder, so the player won't feel a cut working. The drain is small enough that a late-round fade rarely traces back to the scale.
- **The career weight arc** could be the reason to come back, a body that grows out of its class, but it isn't measured and needs boxers who age.

## Options: what each changes, what's missing, what's useless (S403)

### What each option changes
| Option | Changes | Verdict |
|---|---|---|
| Diet: Eat free / Hold / Lean / Strip | Walking weight against natural; Lean and Strip cost training gain | Keep, but the Lean slope has to be measured. Eat free only matters on a move up |
| Water: None / Light / Hard | Regain by the bell; Stamina, the tank, power and reading past 2 % | Near useless as a pick: Light dominates. Make it a forecast, and ask only past 2 % |
| Class move (stay, cut harder, up, down) | Ring size, ladder rung, the miss risk | Keep. CUT harder needs a price |
| The boxer's answer (insist, wait, promise) | Morale, loyalty, trust in the corner | Keep insist and promise. Wait needs a cost |
| Nutrition plan (a coach's slot, or bought) | Halves the diet's price | Keep, as one button |
| Same-day amateur scale | Drives the whole "amateurs shouldn't cut" result | Keep: it's the England Boxing club rule |
| Miss rules by bout type | Walkover, 20 % of the purse, belt, reputation -1, two misses force a move up | Keep |
| Size in the ring | Count odds plus the exchange edge | Keep. Fit it together with reach |
| Natural growth, tolerance with age | The career arc | Keep growth. Tolerance with age stays labelled DESIGN |
| 3D body read | Shows the class and filling out, never water | Keep, and gate it behind the still-pair test as written |

### Missing
1. **Weigh-ins every day at the nationals**: the real amateur cut dilemma.
2. **A price for walking heavier**: the Lean weeks needed to come back down, counted in the probe.
3. **A rehydration limit on title-level pro bouts.** The IBF checks again on fight morning and allows at most 10 lb over. A cap on regain is the one rule that stops "pro must cut" winning every time at title level.
4. **A clock on waiting**, so a refusal costs something.
5. **A probe over seasons** for growth and tolerance, which needs birthdays for the club's own boxers.
6. **Real walking weights** for the Data boxers instead of the field offset.

### Useless
- Water as a three-way pick when Light is free and Hard is forced.
- CUT harder on a same-day scale as a separate choice, since it's the same as STAY.
- Tolerance shrinking with age as an ESTIMATE with no source.

## To reach 10/10 (most important first; sizes are ESTIMATES for the probe)

1. **Give CUT harder a real price.** Walking 2 kg heavier means the diet has to bring it down in the final 3 to 5 weeks at Lean, at most 0.7 % a week (Garthe 2011). The probe runs whole camps, diet weeks included, so the gain lost is counted. Bar: CUT harder in the leading group of at most 6 of 10 cells.
2. **Weigh-ins every day at the nationals.** The regional and national draws weigh in each boxing day (World Boxing rule, 3 hours or more before, no tolerance). Regain is capped by the next scale, and water past the free 2 % carries over into the next day's Stamina. That gives the amateur a real choice: cut to the class below for a better draw, and pay for it on day 3.
3. **Fold the water into the diet.** The fight-week water setting appears only when the forecast needs more than 2 %. Otherwise it reads "Makes 60 with 1.1 % water, free". That leaves two real decisions, the diet and the class, plus one forced moment that names its price.
4. **A rehydration check on pro title bouts.** On title and eliminator bouts, a fight-morning scale allows at most 10 lb over (IBF). Regain is capped, so the "pro must cut" rule has an upper end, and a top-10 boxer has to choose between a hard cut and a move up.
5. **A clock on waiting.** Each bout spent waiting costs one Hard water's worth of tolerance read, plus loyalty -2. After the third wait he asks to leave the class or the club (the Loyalty "leaves" path). Probe bar: the refusal lever is worth 1.5 or more points of win share, or loyalty differs at season's end.
6. **Run 100 seeds a cell**, with real walking weights of 3 to 5 % over and no field offset, and mass fitted together with reach. Bar: at least 6 of 10 cells have a best clear of two standard errors, and no choice leads more than 6.
7. **A three-season probe** for growth, tolerance and the class arc, after AGE1 (birthdays for the club's own boxers). Bar: a 16 to 18 year old's forced move comes within the season the curve predicts, and an early planned move beats a forced one.
8. **Measure the Lean slope** in that probe: Lean must be the best diet for at least 1 in 4 boxers over a season, or the slope comes down.
9. **Rewrite the words**: "your boxer", her / him, no names outside headers, across every row in sections 3 and 5.
10. **Settle the class list**: men's lightest 55 or 57.5, plus Q-292's 65, before the class lookup reads `limit`.
11. **Make the reward visible**: the Why always names the size gap in kilos and its share of the chance, and the tape row for the opponent shows the regain forecast.

Everything except step 7 builds from code the map already names. Step 7 needs ageing for the club's own boxers.

## The 10/10 page at 1920×1080: fight week at the nationals
It's in the Look B gym: the whiteboard on the warm plaster wall, Kalam marker notes, numbers in IBM Plex Mono, Bebas Neue heads, nothing under 12 px. There's one figure, your boxer's existing comic portrait, head to feet, as a polaroid. Gold on one thing, the coach's pick. No green except Continue. All figures are **example data**.

- **Header** (0–90 px): "FIGHT WEEK: NATIONALS", the boxer's name once, women's 60 kg, walking 61.8, natural 63.0.
- **Left third:** the polaroid, and under it the read on the cut limit as a range ("can make about 3 to 4 % dry, read from 2 cuts"), the diet chip (Lean, week 4 of 4) and the gain it cost this camp ("−14 % on what she learned").
- **Centre, the whiteboard:** three scale days drawn as magnets, Fri / Sat / Sun, each with "weigh 60.0 · 3 h before · back by the bell +1.1 kg". Under them are two paths in marker:
  1. **Box at 60:** "Water 1.8 %, free, all three days. Ring weight about 61.1. Size against the field −1 %."
  2. **Box at 57:** "Water 4.9 % on Friday, past the safe line. Stamina −11 % on Friday and −6 % carried into Saturday. The draw is softer, with the #2 seed on the other side." Missing the scale on Saturday is shown as a range, 8 to 20 in 100.
  The gold box goes around path 1, with the coach's note "She's a 60 now. Don't fight the body."
- **Right third:** the opponent's tape row ("walks 64, cuts hard on day 1, fades by Sunday") and the size gap for each round of the draw as a short bar row.
- **Foot strip:** "A miss here is a walkover loss and goes on her file. Two misses move her up." Then the button "Lock the weight plan", in slate.
- **Motion:** the bars tween when the mouse moves between the paths. Hovering a number breaks it into parts: water, regain hours, size. Nothing opens by itself.

WEIGHT2 v2 scores Depth 6, General design 7 and Play 5, so it fails the 8/8 bar. The evidence and the reading of the code are the best so far.

The trouble is in its own probe. Cutting harder never loses, the bout type decides the class choice on its own, the water setting is almost always Light, and refusing a class move costs nothing.

The fixes that matter most:
- Price walking heavier through the diet weeks it takes to come back down.
- Weigh in every day at the nationals.
- Cap regain on pro title bouts with a fight-morning check.
- Put a clock on waiting out a refusal.

I've now read `CRITIC_ACCESS.md` too. It's a general list of where things are, with nothing on weight, so the scores stand.

One correction: please ignore my earlier flag about men's 55 against 57.5 kg, both here and in DMGCLASS1. You chose 55 kg on 15 November (Q-S294-234), so the map and the code are right. I've noted it.

One flag still stands: the map uses a fixed "he" and names boxers in body text, which breaks the sandbox and names-in-headers rules.

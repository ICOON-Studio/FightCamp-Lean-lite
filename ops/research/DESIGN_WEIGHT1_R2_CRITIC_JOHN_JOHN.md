# DESIGN_WEIGHT1_R2_CRITIC_JOHN_JOHN - John answer (seat queue SQ104)

Brief: research/DESIGN_WEIGHT1_R2_CRITIC_JOHN.md
Sent: 2026-11-14 13:10 | collected: 2026-11-14 13:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading WEIGHT1 round 2 against the pack now. Logic first, then the scores, options, To reach 10/10 and the page.

# WEIGHT1 round 2: critic

Scores: **depth 7/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

The class choice is a real career decision, and the plan table's arithmetic holds. I rebuilt every ENERGY and WIN number in section 3, part 7 and they all match. What holds design down: the map writes names into rows as a rule, uses one stat the game no longer has, models the most common amateur bout wrongly, and gives one staff job four effects.

- I couldn't open `CRITIC_ACCESS.md`, the two r2 drawings or the board, because your computer is offline, so I judged from the map and the pack.

## Logic check

**1. Names and fixed gender are written in as the rule.**
- Section 1 says "Names, never he/she, also in the drawings". That's the opposite of S448: names go in the header once, and rows, buttons, lines and tooltips say her or him for that fighter, or "the opponent".
- Leaks in rows, labels and lines:
  - "If Samira slips" and "IF SAMIRA MISSES" (box labels).
  - "Samira asks" and "Samira's own ask" (the CLASS card).
  - "Kayleigh starts 5 ENERGY under Samira" (the fade line).
  - "Kayleigh's coach: no, Kayleigh walks 67.6" (the refusal reason).
  - "Lucy Jackson boxes at 60.0" (the roster row).
  - "Scale at the mat" row for Ana (M18).
  - The news "Samira: +0.5 kg" is fine only if news counts as a header line. Say which.
- S412: "Her way = heard" (part 1) sets her for every fighter. Use "the fighter's way".
- **Fix:** "If the fighter slips", "The opponent starts 5 ENERGY under", "The other coach: no, the opponent walks 67.6", "A team-mate boxes at 60.0".

**2. Most amateur bouts aren't fought at a class limit.**
- In real club boxing there are no weight classes at club shows. Boxers are matched by weight with an allowance, about 2 kg in usual practice (Stevenage ABC). EB 2.7.8 caps the gap at the width of the smaller category. The class limit is the championship case.
- The map treats every club show as "at the limit, 1 kg grace, ask a kilo". That makes amateurs cut for club shows when real ones mostly don't, which is the code's mistake carried forward.
- **Fix:** split the amateur column in two.
  - **Club show:** MATCHED WEIGHT is the default. Both corners agree a weight on the offer, within the allowance (the same number AMATEURWEEK1 uses). A cut is rare, and the size gap comes from the matching, not the cut.
  - **Championships** (the regional and the nationals): the class limit, a weigh-in at 9 am on the day, and cutting matters.
- This also kills the claim that "the size edge is dead at a same-day scale". At a club show a 2 kg matching gap is the size edge.

**3. What comes back by the bell can't be one number for both amateur scales.**
- The map gives every amateur up to 1.5% (women) or 2.1% (men) back plus 0.3 kg, citing a championship study.
- A club show scale is 1 hour before the bell. Glycogen and gut content don't come back in an hour.
- **Fix:** club show, the meal only (+0.3 kg at most); championships at 9 am, the map's numbers.
- This matters because the amateur trim's ENERGY price assumes nothing comes back, while the size number assumes it does. The same kilos are counted on both sides.

**4. "Power" isn't a number any more.**
- The size edge gives "+0.6 Power and +0.6 Durability per kg". Since S448, `Attrs.gd` holds 14 abilities. Power is a summary read from Strength, Explosiveness and skill, so nothing can be added to it.
- **Fix:** put the edge on Strength and Durability for the bout, or as a flat edge on the exchange dice in clinch and inside places only. The second is closer to how size works, and the Why can name it.

**5. The diet's Fatigue share can't be rebuilt from the stated rule.**
- The rule is that carried Fatigue costs 2 ENERGY a point over 50, at most 20 (`stale_energy`).
- LEAN adds +0.5 Fatigue a day. Over 12 days that's 6 points, so the cost is 12 ENERGY if the fighter is already over 50, or 0 if under. The map prints −3.
- CUT adds +1.5 a day, which is 18 points: 36 capped to 20, or 0. The map prints −8.
- Fight week is TAPER (three rest days, light), which drains Fatigue before the bell.
- **Fix:** write the share as a function: the Fatigue still carried at the bell after taper, × 2 over 50. Re-print the table from it. Every WIN in part 7 moves with it.

**6. The money side of a pro penalty isn't the club's money.**
- The gym takes 25% of the purse (CODE). "10% of the asker's purse", "25% of the purse to the opponent" and "+25% of their purse" don't say what lands in the cash tin.
- **Fix:** every price line prints the club's change, e.g. "Catchweight +1: −$95 to the club (10% of a $3,800 purse × your 25%)".

**7. A UK game borrows American rules.**
- "3 misses = forced up a class (California's rule)" and the 25% penalty (Nevada NAC 467.522) come from US commissions.
- The pros here are licensed by the BBBofC (the pack's licence and medicals).
- **Fix:** use BBBofC rules where they exist (the map already cites 3.2.2 and 3.2.4). Tag anything else as a GAME VALUE, not REAL with a foreign source behind it.

**8. Amateur "box them" breaks the amateur rule.**
- D9's amateur BOX THEM for a corner over the allowance contradicts EB 10.7.2, which the map itself cites: over the allowance is a walkover, and the bout is called off.
- **Fix:** for amateurs, the standing order only covers the ask-a-kilo case: "accept their kilo request: they owe you a favour" or "refuse: walkover win".

**9. The nutritionist breaks the staff rule.**
- The pack says each staff job changes one number. The nutritionist changes four: the trim price, the forecast, slips and the refuel.
- **Fix:** one effect. Slips ×0.5 for every fighter on a diet is the one real practice backs (support, not chemistry). The forecast band narrows as a consequence. Drop the trim and refuel effects.
- The Old hand's added trim ×0.75 changes an approved head-coach edge. That needs the owner's OK, so list it under section 9.

**10. The fog leaks, and the amateur contract is decided blind.**
- The refusal reason "the opponent walks 67.6" gives away the exact walk that scouting is meant to sell.
- An amateur can't scout before accepting (S410). So D2 at the offer is chosen with the walk at a 2 kg range, and the WIN printed there must be a band, not 54.
- **Fix:** the refusal says "we'd give away size", with no number. Every WIN on an offer shows the band (the pack's rule: the win chance is a band that widens when unscouted).

**11. The per-camp plan table decides very little.**
- In the worked camp the rows are 52, 54, 52 and 56. Leaving out the gamble, the spread is 2 in 100, below the map's own bar (P10: 3+ in 60 of 100 camps).
- The coach marks the cheapest row that makes weight, so the player learns to press the coach's row. The depth then lives on the CLASS card and the contract, not in the camp.
- The GAMBLE shows the top WIN whenever a favour is held, and its real price (a favour from a shared pool) isn't in the WIN. On screen it looks dominant.
- **Fix:** price the favour in the row ("uses 1 of 2 favours: the next ask a kilo would be a walkover"). Accept that the table is a check more than a choice: hide it behind the coach's row and open it only when the MISS RISK is 5 in 100 or more, or the WIN spread is 3 or more.

**12. REFUEL AGGRESSIVE is free for pros.**
- Its only cost applies when the scale-to-bell time is under 24 hours. The pro scale is about 30 hours out, so AGGRESSIVE always wins unless the second-day clause blocks it.
- **Fix:** price it on the night: ENERGY −2 for the first round (gut weight), and a stoppage or injury roll ×1.1. Or cut STANDARD and leave the clause as the only lever.

**13. It leans on numbers the pack doesn't have.**
- "Promoter trust −1" (the pack only has "refuses if you duck twice").
- "Mood Good+" (the mood words are Fired up, Steady, Flat and Low).
- "Favours" (in CLUBWEEK1 and AMATEURWEEK1, not built).
- Either name the map that owns each, or swap to what exists. For trust: a missed check counts as one duck.

**14. One word list, held to.**
- FATIGUE (the map) against "Week tiredness" (the code's label), "tank" (CLUBWEEK1) and ENERGY. Pick one per idea across all three maps: tiredness for the week, ENERGY for the bell.
- STAMINA is fine; `Attrs.gd` has it.

**15. Scope.**
- The map has 5 new modules, 18 menus, 14 builds, 14 probes and two new classes needing the owner's scope call.
- The two classes are a precondition for UP and DOWN being real for a 65 kg woman (the next step up is 75). Ask that first. Without them, D1 is half a decision.

## Scores, with reasons

**Depth 7.**
- The CLASS card is a career-long trade that reaches the ladder, the business, a team-mate's slots, the pro limit and the fighter's asks. TEST THE WEIGHT and MOVE AFTER THE NEXT BOUT make it a timed decision.
- Contract weight, house rules, the standing order and the Monday check each move a different currency: favours, cash, mood, the ladder.
- The opponent's cut feeding a written plan line ("Write it") ties weight to the plan, the game's star.
- Short of 8: the per-camp table spreads 2 in 100, the coach's row is nearly always the answer, AGGRESSIVE is free for pros, and the gamble looks dominant.

**General design 5.**
- It's well sourced, the numbers rebuild, the menus are wired file by file, and the probes gate the pixels.
- What keeps it at 5:
  - Names and fixed gender are written in as the rule.
  - Power is used as a stat.
  - Club shows are modelled as class-limit bouts.
  - What comes back by the bell is wrong for a 1-hour scale.
  - The Fatigue shares can't be derived.
  - The nutritionist has four effects.
  - US rules sit in a UK game.
  - Favours and trust depend on things the pack doesn't have.
- Points 1 to 5 would lift it to 6 or 7.

**Play 6.**
- Each camp has a line to the scale with a Monday check, slips that land as news with a cause, a MISS RISK to watch fall, and the Why naming what weight cost in round 3. A class move debuting after the next bout gives a reason to come back.
- What drags it down: with four fighters, the WEIGHT PLAN panel is a lot to read every camp for a 2 in 100 choice. And at club shows, where most amateur bouts happen, real boxers rarely cut at all, so the drama belongs to championships and pros.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| CLASS: DOWN / STAY / UP | Cut size each camp, size on the night, ladder, offers, roster clash, pro limit | Keep. Needs the two new classes |
| Move now / after the next bout | Bouts lost while getting down against one more bout at the old weight | Keep |
| TEST THE WEIGHT | One catchweight bout that reveals the real cut, at half ladder credit | Keep, championships and pros only (club shows are matched anyway) |
| Class ask: HEAR / OVERRULE | Morale ±5/−4, loyalty −3 past 8% | Keep |
| Contract: AT THE LIMIT | Full ladder credit | Keep (pro, championships) |
| Contract: CATCHWEIGHT +1 / +2 | Smaller cut, half or no ladder credit, a share of the purse | Keep for pros. **Useless for amateurs** as written: club shows match by weight already |
| Contract: MATCHED | Both at one agreed weight | Make it the **club show default** |
| SECOND-DAY LIMIT | Caps the other corner's refuel | Keep (pro) |
| SHORT NOTICE at +2 kg or the walk | Size and ENERGY now against a camp later | Keep |
| THE PLAN rows: HOLD / LEAN / CUT + trim | Gains, Fatigue, ENERGY, a 2 in 100 spread | Keep, behind the coach's row (point 11) |
| The GAMBLE row | A favour against ENERGY | Keep, with the favour priced in the row |
| Trim stepper | ENERGY against the miss | Keep |
| WATER 0–3% (pro) | Size against ENERGY | Keep |
| REFUEL STANDARD / AGGRESSIVE | Nothing at a 30-hour scale | **Useless** (AGGRESSIVE dominant). Price it or cut it |
| HOUSE RULES: Free / Meal prep / + Monday weigh-in | Slips against $70 a week against mood | Keep |
| NUTRITIONIST | Four effects | Keep, with one effect |
| Monday check: SWITCH THE DIET / MOVE THE DATE | Saves the camp | Keep |
| Standing order: BOX / REFUSE | Purse share or walkover | Keep for pros. Amateur version per point 8 |
| WRITE IT (the fade line) | A plan line from the opponent's cut | Keep. The best link in the map |
| At the scale: SWEAT / PAY (pro) | ENERGY against purse | Keep |
| At the scale: ASK A KILO / WALKOVER | Favour against a loss | Keep |

**Missing options:**
- **Withdraw from the bout** at a failed Monday check, with the $300 slot (CODE) and no miss on the record. Today, past a switch or a date move, the only way out is to miss on the scale.
- **Starting class at signing:** the Interview and Trial card should show the walk and let you pick the class there. Today the class is fixed until the CLASS card.
- **Refuel for amateur championships** (9 am scale, 3 hours or more out): Standard or Light. It's the one amateur case where a refuel is real.
- **No-gi: enter a class up.** The bracket's class is given, and a bracket a class up should be a choice for a fighter at the top of her class. Tag it TO SOURCE (IBJJF and ADCC weigh-in rules are on my B14 list, not yet checked).

## To reach 10/10

1. **Names out of every row.** Rewrite section 1's rule to S448 ("names in the header once; rows say the fighter or the opponent") and fix every label listed in point 1, the drawings included. Replace "Her way" with "the fighter's way".
2. **Split amateur weight into club show and championship.**
   - Club show: MATCHED WEIGHT on the offer within the allowance (one number shared with AMATEURWEEK1 and CLUBWEEK1), scale 1 hour before, the meal only back by the bell, and the size edge from the matching gap.
   - Championship: the class limit, a 9 am scale, the map's regain numbers, and the refuel choice.
3. **The size edge on real stats.** Use Strength and Durability, or a flat dice edge in clinch and inside places only. Re-run P2.
4. **The Fatigue share as a function** of the tiredness left at the bell after the TAPER week. Re-print part 7's table and the drawings from one run.
5. **The club's cash on every money line:** the purse share already times 25%, the $300 slot, the $450 ticket cut.
6. **BBBofC for pros.** Replace the California forced move and the Nevada 25% with a GAME VALUE or a sourced BBBofC rule.
7. **The nutritionist does one thing:** slips ×0.5, $100 a week. Put the Old hand's trim change on the owner's list.
8. **Fog holds:** refusals give no number, and every WIN on an offer is a band.
9. **Price AGGRESSIVE**, at ENERGY −2 in round 1 and an injury roll ×1.1, or cut it.
10. **The plan table opens on need:** the coach's row by default, the table when the MISS RISK is 5 in 100 or more or the WIN spread is 3 or more. The gamble row prints its favour.
11. **Add the missing options:** withdraw at a check, the class at signing, the championship refuel, and the no-gi class up.
12. **One word list across WEIGHT1, CLUBWEEK1 and AMATEURWEEK1:** ENERGY (the bell), tiredness (the week), Stamina (the ability); mood words from the pack only; favours and trust owned by one named map.
13. **Ask the owner first** for the two classes (women 70, men 65). While there, also check the code's men's 57.5 kg class, which isn't a World Boxing class (the nearest is 55).
14. **Me (B14):** I source the no-gi scale rules, UK meal-prep and nutritionist prices, the cycle-week water, and the EB club allowance before the build, each with a tag.

## The 1920×1080 page (Fighter > Week, the WEIGHT PLAN, Look B)

**Shell:** the dark top bar, with CONTINUE reading "to Mon 23 Feb, weight check". Then the left rail, then the header strip: portrait, name (the only name), "Welterweight · 65.0 kg", "Walks 66.8".

**Whiteboard (1640×900), three columns:**

- **Left (560), THE LINE TO THE SCALE:**
  - A marker line from today to the scale chip "Scale Sat 28 · 4 pm · on the day, no water", with the slip band in pale red.
  - Monday checks as magnets ("Mon 23: 65.7 or under").
  - The trim's three days hatched, and the limit as a red tape line.
  - Below: THIS WEEK BY CAUSE in one line, plus the coach's one swap as a sticky with **Do it**.

- **Centre (620), THE PLAN:**
  - The coach's row large: "Lean + trim 0.6 · made, 0.1 to spare · ENERGY 86 · WIN 50–58".
  - Under it, the ENERGY bar split into its parts (tiredness at the bell, diet share, trim).
  - "Other plans" opens the table as a fold, and only opens itself when the miss risk is 5 or more.
  - The MISS badge "2 in 100" with a hover: "if the fighter misses: walkover, −$450, mood −6".
  - The trim stepper with the made, favour and cap steps marked.

- **Right (460), as cards:**
  - THE OTHER CORNER: "Walk 67–69 (tape 1 of 3)"; "Starts about 5 ENERGY under"; **Write it** (+2 in 100); and the standing order magnet "If the opponent misses: box / refuse".
  - HOUSE RULES: three magnets, "Meal prep · $70 a week in diet weeks · slips 1 in 4", and "Clean camps 1 of 3".
  - Staff line: "Nutritionist: slips halved · $100 a week" (Hire, or Hired).
  - Bottom ledge: the red **Withdraw ($300)** sits behind a divider, and only shows after a failed check.

**A second view: the fighter's CLASS card** (Overview), the same board:
- The walk line over 18 months, with "STAY stops being cheap: Apr 2027".
- Three columns DOWN, STAY and UP with the labelled rows (the cut, camp weeks, ENERGY, WIN band against the likely three, size against the top five, ladder place, offers in the last 8 weeks, a team-mate in the class, as a pro).
- The fighter's ask as a sticky with **Hear** and **Overrule**.
- **Test the weight**, then **Move now** and **Move after the next bout**.

## Sources (read 2026-11-14)
- [EB Technical and Competition Rules 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf): 2.7.8 (the weight gap in matched bouts), 7.1.3 (weigh-in 1 hour before boxing) (OFFICIAL).
- [Stevenage ABC, weight and amateur boxing](https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing) (undated): no weight classes at club shows, about 2 kg usual allowance, a bout called off on a miss (club practice).
- Everything else above is checked against the critic pack and the map's own numbers. I haven't re-read the map's other sources (Reale 2017, BBBofC, IBF, Nevada) this pass.

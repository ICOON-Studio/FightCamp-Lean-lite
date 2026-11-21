# DESIGN_DMGCLASS1_V3_CRITIC_JOHN_JOHN - John answer (seat queue SQ276)

Brief: research/DESIGN_DMGCLASS1_V3_CRITIC_JOHN.md
Sent: 2026-11-21 16:10 | collected: 2026-11-21 16:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): dmgclass_v3_10.html
Verify the sources before using it.

---

On it. First I'm checking DMGCLASS1 v3's numbers, mainly the 12·ln(count_mult) shift, the 0.28 chin saving and the fit targets. I'm also checking the real stoppage rates it cites (AAN 2025, John's counts). Then I'll score the design. Beast is still offline, so this will be a reading of the pack and map.

The DMGCLASS1 v3 critic is underway. When it's done I'll post the logic check, then the full return with the page image, then the HTML file.

**Logic check on DMGCLASS1 v3.** The maths in the rules holds, but the fit plan and four of the bounds don't. The levels below come from my rough copy of the stoppage rules, tuned to the measured 9 in 100, so trust their ratios rather than their exact values.

- **The rules' maths is right.** The shift of 12 × ln k gives 3.1 points at 1.3, 5.6 at 1.6 and 8.3 at 2.0. Four points of chin cut the count chance by 28%, and six points make it 1.65 times as likely.
- **"Stoppages follow the count chance in proportion" only holds over 3 rounds.** Doubling the count chance gives ×2.11 stoppages over 3 rounds, ×1.91 over 6 and ×1.56 over 10. So the pro fit of "target ÷ control" will undershoot.
- **Rounds alone already reach the pro targets.** With damage building up, 9 in 100 over 3 rounds becomes about 27, 40 and 54 over 6, 8 and 10 rounds. So women's 29 needs a factor of about 0.8, below the amateur control, and men's 47 needs about 1.3. Without a label, the women's factor reads as "women hit softer", when it's really 2-minute rounds.
- **A pro's cell uses the wrong weight.** Your boxer is looked up by the amateur limit, but world rivals by the pro table's top weight (65 against 66.7, 75 against 72.6). The watched bout and the world bout then disagree by construction.
- **The towel lines barely change when the card comes.** The card already comes on any count, so Careful, Normal and Brave each bring it in 22.5 of 100 amateur bouts. The proposed "1 fight in N" tails would print the same N three times.
- **The mutant check is half blind.** Doubling an anchor is caught. Doubling one division inside a pooled bound passes (about 11 → 14 against 6 to 16), so every bound has to be per division.
- **The real numbers break two bounds.**
  - Men's pro KO share is 32% (15 of 47), outside the map's 8 to 30.
  - New count from the men's elite world championships 2019 to 2023: 8.4 in 100 stopped (113 of 1,341). It runs 5.4 at 57 kg and under, up to 10.5 at 71 to 75 kg, so middle over feather is about 1.95. The map's slope gives 1.19.
- **The sources check out.** I opened AAN 2025 and BJSM 2013: women's pro 29 in 100 and men's 47, about equal per minute fought.

# DMGCLASS1 V3 critic: stoppages by weight class and sex
This is a static reading: Beast is offline, so I couldn't open `CRITIC_ACCESS.md`, the code or the mockups. I changed nothing.

**DEPTH 5 · GENERAL DESIGN 6 · PLAY 5. Not designed yet: DEPTH is two points short and GENERAL DESIGN one.**

v3 is a big clean-up of v2. It uses one knob in one place, withdraws the false table, makes women's amateur the control so the normal start doesn't move, and lists every false claim. But the mechanic is still mostly a set of correct reads, not decisions. The evidence says weight barely matters for women and sex barely matters per minute. Only turning pro is a big step, and the one decision that would make the class a choice (moving class) is deferred.

**DEPTH 5**
- **For:**
  - The turn-pro row puts a real 3 to 6 times step on a button that already exists.
  - Reading the chin against the field moves whom the player signs and which starting focus they pick.
  - Men's pro cells give more weight to Finisher, Iron chin, the towel and the plan's defence lines.
- **Against:**
  - The class comes with the boxer, and the class part of the signing row is nearly flat (5 to 12 in every amateur cell).
  - Moving class is deferred.
  - Four of the six "decision" lines are reads.

**GENERAL DESIGN 6**
- **For:**
  - One knob, the caps kept, and damage and the hurt roll untouched.
  - One cell per bout, with a test that fails on an empty cell.
  - Control and mutant arms, every v2 claim corrected, and one `StopWord` signature.
- **Against:**
  1. Pro cells are keyed on the amateur limit.
  2. The bounds mix populations: level pairs are tested against counts of every bout, mismatches included.
  3. The men's slope bound and the KO-share bound exclude the counted numbers (1.95 and 32%).
  4. The camp line asks for chin training the camp can't give: the camp has no chin focus, and X has no number behind it.
  5. The towel tails will likely read the same three times.
  6. Pooled bounds let a one-division mutant pass, and the women's three weight rows map onto only two game rows.
  7. The towel's pull-out is still priced as a stopped loss in five places: members −2, reputation −4, +8 pro weeks, the lesson cut, loyalty −3. That must be decided before the towel row ships.
  8. Nine screens get new lines.
- Names are clean in every proposed line.

**PLAY 5**
- **For:** "is this chin ready for the pros?" gives the player something to work toward for weeks, and the Why's sentence ties a stoppage to a cause.
- **Against:** nothing changes week to week, and the one moment it creates comes once for each boxer.

**Options**

| Option | Verdict | What it changes |
|---|---|---|
| `count_mult` per cell (one knob) | Keep | How often a clean shot brings a count in that cell |
| Women's amateur control 1.00 | Keep | Nothing for the normal start |
| Men's amateur anchor 1.2–1.6 | Change to about 1.0–1.1, slope ≈ 0.46 | Feather stopped less and middle more, matching the counts |
| Women's pro anchor | Change: call it a round-length factor in the hover | Expect about 0.8; without the label it reads as "women hit softer" |
| Men's pro anchor | Keep, fitted on the log scale | About 1.3 |
| Weight slopes | Change | Men: middle over feather 1.2 to 2.5. Women's amateur: 0. Women's pro: CHECK |
| THIS DIVISION row at signing | Keep, 2 lines | Whom to sign, and which starting focus |
| Prospect-card line | Move to the hover | It has no decision of its own |
| Turn-pro row | **Keep, and make it the core** | When to turn pro, which house, whether to ask for the softer opponent |
| Towel-row tails | Cut, unless the probe shows the lines 3+ points apart | They likely print the same N three times |
| "A usual round here: U in 100" | Keep | Lets the corner judge the strip's number |
| Camp line "four more chin" | Move to the Week, as neck-work mornings | Today it points at a camp focus that doesn't exist |
| Perk-road tails | Move to the hover | A small nudge toward Iron chin or Finisher |
| The Why's sentence | Keep | Explains a stoppage |
| Colour lines on the pro rows set per cell | Keep | Red and amber stay meaningful in every cell |
| `ko_share` fallbacks | Keep; split the KO bound by sex | Day-one records agree with the world |
| **Missing:** moving class at the pro call | Add | Trades a weight cut against the field's punch |
| **Missing:** the pull-out price | Add | A pull-out costs like a points loss |
| **Missing:** level amateur pools | Add | The men's rivals are rated 53–62 against the women's 58–65, which fakes a class effect |
| **Missing:** a championship row | Add, in the probe only | The nationals printed as their own row |
| Headguard | Not an option | Fixed by sex; name it in the hover |

**The map's open points**
1. **Men's amateur rates:** counted at 8.4 in 100, about level with the women's, with middle about 1.95 times feather. The official results books still need checking.
2. **Club against elite:** club is fine, because the elite rates of 5 to 11 sit inside the club band.
3. **KO share as a second number:** not needed. Split the bound by sex instead.
4. **The pull-out price:** decide it now.
5. **Refusing the week board:** agreed. The chin advice goes on the Week as neck-work mornings.
6. **The pro control:** expect anchors of about 0.8 for women and 1.3 for men (ESTIMATE).

**Evidence**
- Women's pro stoppages are 29 in 100 (5 KO, 24 TKO) and men's 47 in 100 (15 KO, 32 TKO), from BoxRec 2014 to 2024. Per minute fought the sexes are about equal, and women's pro rounds are 2 minutes against 3: **SOURCED**, AAN 2025.
- Amateur early endings rose from 17.3 to 21.8 in 100 after headguards, across 198 tournaments from 1952 to 2011: **SOURCED**, BJSM 2013.
- Men's elite world championships 2019 to 2023: 8.4 in 100 stopped. By weight it was 5.4 at 57 kg and under, 7.7 at 60 to 69 kg, 10.5 at 71 to 75 kg and 10.7 at 80 kg and up: **DERIVED**, my count from the Wikipedia brackets.
- Women's elite world championships 2018 to 2023: 7.9 in 100, with no slope by weight: **DERIVED**, John's earlier count.
- Senior men box without headguards (England Boxing 8.1.1): **CHECK**.
- Men's pro stoppage rates by weight: **NOT FOUND**.

**To reach 10/10 (most important first)**
1. **Make the pro call the core and give it the class choice.** Offer the natural pro table, or one up or down, each with its weight cut, the field's punch against your boxer's chin, and the early-ending rate. Store `pro_div` on the boxer and have `ProLadder.division_for` read it first. This needs a minimal MOVECLASS1, at the pro call only.
2. **Key the pro cell on the pro table.** On both paths, use the table's top weight. The lookup test checks that your boxer and a world rival in one table give one cell.
3. **Fit the anchors on matched populations.** Use the real pools and world tables with their real gap spread. Keep level pairs only to check the rule. Fit on the log scale, with up to 5 reruns.
4. **Use the counted numbers.** Men's amateur anchor 0.9 to 1.2, with a slope bound of 1.2 to 2.5. Women's amateur slope 0, with two weight rows. Every bound per division.
5. **Name the women's pro factor.** The hover reads "Pro rounds here are 2 minutes". Later, give those rounds 4 exchanges instead of 6; the game can't vary the number of exchanges yet.
6. **Decide the pull-out price in `BoutFinish.run`.** Members −1, reputation −2, no +8 pro weeks, the lesson kept, no loyalty −3.
7. **Move the camp line to the Week.** Put it beside neck-work mornings, with its number taken from a per-cell table the probe writes.
8. **Towel.** Ship "A usual round here". Ship the "1 fight in N" tails only where the probe shows the lines 3+ points apart; otherwise give that cell its own lines at 0.6 / 1.0 / 1.6 of the usual.
9. **Split the KO-share bound by sex:** women 10 to 25, men 25 to 40.
10. **Level the amateur pools,** or name the pool in the read.
11. **Cut the screen load to four places:** signing, the pro call, the towel strip and the Why.
12. **Check the counts** against the official results books, and run one BoxRec query by division and level.

**The 10/10 page** (1920×1080, Look B, image below) is the turn-pro call with a THIS DIVISION panel.
- **Header (the only name):** a fictional 9-1 women's 60 kg amateur, 11 days left, 2 declines left.
- **Left:** four bars of early endings per 100 bouts.
  - 9 as an amateur here;
  - 18 in the first two pro tune-ups;
  - 29 as a pro here, in red;
  - 47 for men's pros, faint, for scale.
  - Under the bars, the chin (57, amber) sits against the field's punch band of 60 to 68, read as "protect early". Four more chin, from neck work on 3 mornings for about 5 weeks, means about 2 fewer stoppages in 100.
- **Centre, where to turn pro:**
  - Lightweight, picked: about 29 in 100.
  - Featherweight: a 4.4 kg cut before every bout, about 24 in 100.
  - Below them, what each kind of ending costs.
- **Right, the offers:**
  - Harrow & Finch, tune-ups, about 18 in 100. **SIGN WITH HARROW & FINCH** is the only pulsing button.
  - Bow Lane, a step up, about 33 in 100.
  - Stay amateur, about 9 in 100.

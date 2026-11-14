# DESIGN_WEIGHT1_R3_CRITIC_JOHN_JOHN - John answer (seat queue SQ127)

Brief: research/DESIGN_WEIGHT1_R3_CRITIC_JOHN.md
Sent: 2026-11-14 19:40 | collected: 2026-11-14 20:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading WEIGHT1 round 4 against the pack now, and checking the England Boxing weigh-in rules it leans on. Logic comes first, then the scores, options, To reach 10/10 and the page.

# WEIGHT1 round 4: critic

Scores: **depth 6/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

Round 4 fixes what round 2 asked for:
- names are in headers only;
- money lines show what lands in the club's cash;
- the BBBofC rules are used for pros;
- the plan table folds;
- there's a release cut;
- weight risk is shown as a band.

The arithmetic for the trim in 8.1 checks out: trim 0.59 costs 6.8, so Energy is 93 at the scale and 95 after a Light refuel. What still holds design at 5 are three rules at the heart of the mechanic:
- who loses when two boxers are outside the gap;
- the hour of the championship weigh-in, which the map's own source contradicts;
- the size edge, which the map's own refuel study found makes no difference.

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the map and the pack, and checked the England Boxing rule book and the Reale study myself.

Names: Samira Khan and Kira Mensah appear only in example headers, which is fine. Rows, news and asks say "your boxer" or "your 65 kg boxer". I found no fixed he or she outside the code's own "she tires", which the map flags.

## Logic check

**1. "Outside the gap" has no loser, and the map gives the loss to your boxer.**
- The gap is between two boxers, so when they're 2.3 kg apart, both are outside it. 4.2 says the boxer outside the gap takes a walkover loss, and 8.2 prices "Box near the walk" as outside the gap if the opponent comes in light. So your boxer takes a record loss, −12 mood, −1 member and −2 reputation because the **opponent** came in under their own declared weight.
- That's neither fair nor real. The real check is each boxer against their **own declared weight**, and a mismatch is matched again or called off.
- **Fix:** each corner declares a weight on the offer. The boxer further from their own declared weight is the one at fault. If neither is out by more than the scale tolerance, the bout is off with no fault: no slot fee, no loss.
- The walkover-as-loss question (EB 10.7.2) should stay a CHECK until the text is read. The map's own risk 13 already doubts it.

**2. The championship scale contradicts the rule the map cites.**
- EB rule 7.1.3 says "For domestic boxing, the weigh in should be completed 1 hour prior to boxing commencing", and it doesn't carve out championships.
- The map tags a championship "morning scale and refuel" as EB 7.1.3 REAL. That's the opposite of what the rule says. The Reale numbers (+1.49% women, +2.12% men) come from the **Australian** nationals, which weighed in each morning.
- If England Boxing championships also weigh in 1 hour before, the whole refuel lever (D-R, 4.3, P20) has no basis in release 1.
- **Fix:** find a championship-specific England Boxing rule before building D-R. Without one, release 1 has one amateur scale (1 hour before, the meal only) and refuel moves to release 2 with the pros.

**3. The size edge goes against the study the map uses for the regain.**
- Reale 2017 found regain had "no link to success". In 41 of 85 bouts the heavier boxer won, and in 40 the lighter one did.
- The map uses that paper for the Full refuel weight and then pays +1 a kg inside the ring for it. P2's target of "1–3 in 100 for an inside style" sets the edge to win.
- **Fix:** set P2 to accept about 0. Keep the edge only if the bout model shows a tie-up or clinch effect worth printing. Otherwise cut the size edge, and D0 has to stand on Energy and risk alone (point 4).

**4. D0 collapses to one answer.**
- In 8.2, "Meet the declared weight" is 1 in 100 outside the gap at Energy 100.
- "Come in light" costs 5 Energy and gives away size. It's worse in every way, and the map says so: "Rarely right".
- "Box near the walk" adds a 5–12 in 100 chance of a walkover loss to buy +0 to +1 inside, and point 3 says that's worth about nothing.
- So P3's target, "each D0 answer best in 20–60 in 100", can't pass as the answers are written.
- **Fix:** make the real club-show lever **what your corner declares**. Declare low, and the matchmaker finds a smaller opponent (lower win risk, but a cut). Declare your walk, and you get no cut but a bigger opponent. That's what real club coaches trade, and it uses the code's weight and Energy, not a size edge.

**5. The Write it maths (D5) leaves out two systems that are BUILT.**
- 5 × 3/4 × 9 × 0.8 = 27 counts every fire in the window at full value.
- `PlanRead` pays a line in full only for its first 2 uses in a round. A tiring opponent's window sits mostly in round 3, so 5 fires in one round drop after the second.
- FireLevel fires a line 1 use in 2 at Usable. An undrilled 1-2-3 is Raw, so its moves may not be weapons at all, and the line may not exist.
- With both, 27 falls to about 11–14, below the pressing line's 21. The example's "the player writes it" turns around.
- **Fix:** the D5 unit is fires × FireLevel × the PlanRead taper per round × edge. Print the round split of the window.

**6. The kilo maths uses two different rates.**
- Lean −250 kcal a day becomes "about 0.03 kg a day", which is about 7,700 kcal a kg.
- At that rate, Cut 5 days (5 × 500 kcal) is about 0.32 kg, not the −0.16 kg the map tags CODE.
- **Fix:** read the code's kcal per kg and use one rate. Then re-print D3 and the miss table.

**7. A goal miss is a cliff that decides D1.**
- 8.1 has Defence forecast at 50.64 against a goal of 50.8, which means "missed, −19.9 mood". That's a bigger hit than losing the bout (−12).
- The pack doesn't give the size of a goal miss. If it's about −20, D1 becomes a lookup: never burn a morning that feeds the goal.
- The same example still uses the old summary stat "Technique". Mornings train Attrs abilities since S448.
- **Fix:** print the goal-miss value with its code tag, and state the cost of a burn morning in Attrs abilities.

**8. Tiredness and Energy: a rule change for every bout, priced as a weight detail.**
- Extending `stale_energy` from camps to every booked bout, plus "+1.5 tiredness a day on a Cut", changes every amateur bout, including bouts with no cut.
- The map lists B0 as the reason to re-measure 59/45/41. B6 is just as big.
- **Fix:** run B6 with B0 under one balance re-measure, and tag it in risks.

**9. The fog may never clear.**
- The opponent's weight range clears "after tape 2". An opponent with no bouts has no tape (4.6), and novice club bouts are common.
- Amateur bouts within a week have no camp (S428), so tape days may not exist.
- **Fix:** the declared weight is the fog's centre. With no tape, the band stays wide and says why ("no tape: first bout").

**10. Some options with nothing behind them.**
- **Roster clash (Share shows / One moves):** offers are per fighter, one at a time (4.5). Nothing in the code takes an offer from a second boxer in the same class, and club shows ignore class. Nothing to solve.
- **Test the weight:** no effect is defined.
- **"Let the fighter eat" plus meal prep** (8.1 row 3): meal prep only makes a No hold, so paying $300 and then saying yes buys nothing.
- **D4 round pace:** the Playbook already sets round-by-round pace (4.7). It's a link, not a weight option.

**11. Screens and words.**
- The fighter page gets a new "Body and class" tab (M2) and a "THE WEIGHT" panel (M1). Neither is in an agreed mockup, and pack 7 says screens come only from agreed mockups.
- M3 "Week (renamed)": it's already called Week.
- A walkover win gives +8 members and +5 reputation, the full win. Nobody watched it, so half seems fairer, as a GAME VALUE.
- Two Pull out entries (the Home need, and D3 on the fight-week Monday) plus past the cap is three doors to one action. That's fine if they all go to one screen.

**12. What the real rule book adds.**
- England Boxing matches boxers within the smaller of the two boxers' category widths (2.5 kg when one is in a 2.5 kg category). Use that instead of a flat 2 kg from one club.
- EB 7.1.14's limit on weight change at the weigh-in covers minors, schools, juniors and youth only. Nothing found covers a senior re-weigh, so the 30-minute re-weigh stays a CHECK.
- Reale also found 0.37% more regain before an afternoon bout than a morning one. That's a free real detail if refuel survives point 2.

## Scores, with reasons

**Depth 6.**
- The cut levers carry real, competing tails:
  - a burn morning against the goal and the stat it would have trained;
  - the ask to eat against the mood band edge (Steady to Flat changes how much of the corner's word is taken in);
  - meal prep against cash;
  - a Cut against how tired your boxer is on the fight-week Monday;
  - pulling out against a walkover.
- Energy then feeds the window and the plan's "when the opponent tires" line, so weight touches training, mood, money and the plan.
- Held to 6:
  - D0 collapses to Meet (point 4);
  - the size edge has no real support (point 3);
  - the D5 trade turns around once FireLevel and PlanRead count (point 5);
  - the goal cliff decides D1 (point 7).
- The map's own WIN bands differ by only 1 or 2 in 100, so the depth lives in the tails, not in win chance.

**General design 5.**
- Good: one word list, CODE and REAL tags, menus wired to file lines, a release cut, probes with pass lines, and 26 of 28 critic points answered.
- Held to 5:
  - the gap rule punishes the wrong boxer (point 1);
  - the championship scale contradicts its own source (point 2);
  - the size edge contradicts its own source (point 3);
  - two kilo rates (point 6);
  - D5 leaves out BUILT systems (point 5);
  - an old stat name;
  - options with nothing behind them (point 10);
  - two screens with no mockup (point 11).
- Fixing points 1 to 3 would take it to 6.

**Play 6.**
- The weigh-in is the best moment in the map: the reading, one re-weigh, and finding another name. The scale is real fight-week drama, and the Monday check gives a reason to come back.
- The Why line ("Energy 92 at the bell; the window 4; your tires line fired 3 times") ties a quiet week of choices to fight night.
- But most weeks the coach's row is right within the band, so many players will just accept it.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| D0 Box near the walk | Size (+0 to +1 inside), 5–12 in 100 outside the gap | **Useless** as written (points 3 and 4). Replace with what your corner declares |
| D0 Meet the declared weight | Small cut, about 1 in 100 risk | Keep, as the default |
| D0 Come in light | Costs 5 Energy and gives size away | **Useless**, worse in every way |
| Re-weigh, sweating up to 0.3 kg | −2 Energy per 0.1 kg against a walkover | Keep, as an automatic step. Never refused, so it's not a choice |
| Ask the matchmaker for another name | 1 favour for about 1 in 2 to save the bout | Keep |
| D1 burn mornings | Trim tier and Energy against a stat or the goal | Keep. Print the goal cliff honestly (point 7) |
| D2 Let eat / Half a plate / No | Kilos, mood (+5 / 0 / −5), and eating anyway | Keep. The best of the cut levers |
| Meal prep | $25 a day, a No always holds | Keep. Combining it with Let eat is useless |
| Nutritionist | Asks × 0.5, $100 a week | Keep, for a club with several cutting fighters |
| D3 Trust the trim / Cut 5 days / Pull out | Energy, tiredness, $300 | Keep. Fix the kilo rate |
| Refuel Light / Full | Energy and weight back, −2 in round 1 | **Hold** until a championship scale is sourced (point 2) |
| D4 round pace | Energy across rounds | Already in the Playbook. Link it, don't duplicate it |
| D5 Write it | One plan line | Keep. Fix the maths (point 5) |
| CLASS card: Move now / after the next bout; Hear / Overrule | Class, ladder place, cut per camp | Keep |
| Test the weight | Not defined | **Useless** until it does something |
| Share shows / One moves | Nothing in the code | **Useless** |
| The class at signing | Sets the class for championships | Keep |

**Missing options:**
- **What your corner declares to the matchmaker:** your boxer's own declared weight, which picks who the matchmaker can pair you with. That's the real club-show lever.
- **No-fault call-off when both boxers are off** (point 1).
- **A weight test on a set date** (S370's test system): "65.4 kg by Monday the 9th", a weekly check-in and a personal best for the leanest healthy walk. It turns the long walk into a goal the player can chase without a bout.
- **Ask the opponent's corner to come up 0.5 kg** at a club show, for a favour. It's real club-show haggling, and it's the amateur's only way to change the declared weight after accepting.

## To reach 10/10

1. **The gap rule:** each corner declares a weight on the offer. The boxer further from their own declared weight is at fault. If both are within the scale tolerance but outside the gap, the bout is off with no fault. Read EB 10.7.2 before printing "walkover loss".
2. **One amateur scale for release 1:** 1 hour before, the meal only (EB 7.1.3), unless a championship-specific England Boxing weigh-in time is found. Refuel moves to release 2 with the pros, with Reale's 1.49% / 2.12% and the +0.37% for afternoon bouts.
3. **Size edge:** P2 accepts about 0 (Reale: no link). Drop the edge unless the bout model shows a tie-up or clinch gain worth printing.
4. **Replace D0** with what your corner declares: walk, walk −1 kg, walk −2 kg. Each shifts the matched opponent band and the cut. P3 checks each is best in 20–60 in 100.
5. **The D5 unit** counts FireLevel and the PlanRead taper per round. Print the window's round split.
6. **One kcal per kg rate** from the code. Re-print Cut 5 days and the miss table.
7. **The goal-miss value with its code tag.** Burn-morning costs in Attrs abilities, not Technique.
8. **Run B6** (stale for every bout, Cut tiredness) **with B0** under one 59/45/41 re-measure.
9. **Cut** Share shows / One moves, Test the weight, and the Let eat plus meal prep row. Link D4 to the Playbook instead of duplicating it.
10. **The match gap** is the smaller of the two boxers' EB category widths, not a flat 2 kg.
11. **The weight test** (S370): a target kilo on a set date, a weekly check-in and a personal best on the Body card.
12. **The fog** centres on the declared weight. With no tape, it stays wide and says "no tape: first bout".
13. **The owner OKs mockups** of M1 and the Body and class tab before build, or the weight lives as a block inside Fight prep and Overview's BODY.
14. **Half members and reputation** on a walkover win.

## The 1920×1080 page (Fighter > Fight prep > THE WEIGHT, Look B whiteboard)

**Header (0–120):** the portrait and the fighter's name once, then "65 kg · scale Sat 28, 4 pm (1 hour before) · 12 days". The dark top bar holds CONTINUE, the only green on the page.

**Left third (32–640), the scale line:**
- A marker line on cream paper from today's 65.9 kg to the scale, with the walk as a dotted line at 66.8 and the declared weight as a magnet you can drag (walk / −1 / −2).
- Under the magnet, a polaroid card of the matched opponent band ("declared 65.0 · range 64.5–66.5 · tape opens ±0.5").
- At the bottom, the risk in one row: "Outside your declared weight: 1 in 100 · no-fault call-off if both off".

**Centre (672–1248), the coach's row in the one gold frame:**
- A stacked Energy bar: tiredness at the bell 0, trim −7, meal +0. Below it, "Energy 93 at the bell · miss 2 in 100 · WIN 47–61", with the hover "the coach's row was best in 4 of your last 6 bouts".
- One alternative row underneath ("Sat burned: 94 · costs Speed +0.1"), and "All plans" greyed until the miss risk passes 5 in 100.
- Three sticky notes in a row for the standing answers:
  - **If your boxer asks to eat:** Let eat / Half a plate / No, with each answer's mood and kilos;
  - **If Monday reads over:** Trust the trim / Cut 5 days / Pull out ($300);
  - **Meal prep:** "−$300 from the club, a No always holds".

**Right third (1280–1888), fight night:**
- An Energy curve by exchange (18 dots, rounds 1–3) for both corners, in blue and red.
- The window shaded, with the round split under it ("R2: 1 · R3: 3").
- Your "when the opponent tires" line with its real count: "fires about 2 in R3 after the opponent adjusts (Usable: 1 in 2)", with Write it beside it.
- A weight test card at the bottom: "Target 65.4 kg by Mon 9 · check-ins 3 of 4 · best 65.6".

**Bottom strip (980–1040):** the Monday check as a marker tick box with the date, and the walk drifting back after the bout as a ghost line.

## Sources
- England Boxing, [Rule Book 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final.pdf), read 2026-11-14. OFFICIAL:
  - 7.1.3: "For domestic boxing, the weigh in should be completed 1 hour prior to boxing commencing";
  - 7.1.14: the limit on weight change at the weigh-in is for minors, schools, juniors and youth only;
  - weight matching uses the smaller of the two boxers' category widths;
  - For One Night Only bouts allow 2.5–3 kg differences.
- England Boxing, [Rule Book page](https://www.englandboxing.org/rules-regs-resources/rule-book/), read 2026-11-14. OFFICIAL: the 2026 edition is current.
- Reale, Cox, Slater and Burke, [Weight Regain: No Link to Success in a Real-Life Multiday Boxing Tournament](https://doi.org/10.1123/ijspp.2016-0311) (IJSPP 2017), read 2026-11-14. MEASURED:
  - 100 elite boxers at the Australian nationals, weighed in each morning;
  - regain 1 hour before the bout was 2.12% (men) and 1.49% (women);
  - 0.37% more before afternoon bouts;
  - no link between regain and winning (41 to 40 bouts).
- England Boxing championship weigh-in hour, senior re-weigh window, and EB 10.7.2 walkover wording: NOT FOUND this pass.
- All other figures are DERIVED from the critic pack and the map's own formulas.

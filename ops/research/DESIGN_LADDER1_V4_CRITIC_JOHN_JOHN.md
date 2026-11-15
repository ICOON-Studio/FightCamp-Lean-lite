# DESIGN_LADDER1_V4_CRITIC_JOHN_JOHN - John answer (seat queue SQ189)

Brief: research/DESIGN_LADDER1_V4_CRITIC_JOHN.md
Sent: 2026-11-15 21:10 | collected: 2026-11-15 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score LADDER1 v4 as a fresh critic, starting by rechecking the reputation formula, the three worked cases and the refusal rules against the pack. The owner's computer is still offline, so `CRITIC_ACCESS.md` and the mockups aren't open to me.

**Logic check.** I recomputed the map's numbers from its own formulas.

**These hold:**
- **The R3 table** checks out at every gap: −40 is 0 / −16, −20 is +2 / −14, −10 is +5 / −11, 0 is ±8, +10 is +11 / −5, and +20 is +14 / −2.
- **All nine case rows** match their win, loss and EV figures, for example gap +14 at 21.6% expected gives +13 / −3, and gap −26 at 91.6% gives +1 / −15.
- **Case 3's TOO RISKY row is correct:** gap +4 gives an expected of 40.9%, and 54 is within 3 of 55.

**What doesn't hold:**
1. **Two different things are both called reputation.** In the pack, reputation is the gym's number: a win adds +5 and a loss takes 2, and it drives the member target. The map uses the same word for each boxer's 0–100 ladder number. That breaks the one-word-per-concept rule, and every line of section 4 becomes unclear about which number moves.
2. **Places or points?** R2 says "16 above", and the dotted line repeats it. A table sorted by position reads that as 16 places. The cases use points ("rep 30, reach up to 46"). DUCKED ("up to 8 above") and the "20+ below" clock rule have the same problem.
3. **Case 3 doesn't play out as written.** At 50, a unanimous win over the 5th is +5, which is already 55 and the pro offer. The mandatory argument is moot. Also, a boxer ranked 2nd is already the mandatory under R6 if they held 2nd on the quarter Monday, and the eliminator winner can jump ahead of them. The case uses neither rule.
4. **The EVs count only ladder points.** In the code, every win adds +8 members, a $450 ticket cut and +8 morale, whoever the opponent is. A loss takes 1 member and 12 morale. So EASIEST at 97% is the best route for money and members, which isn't "earns about nothing". Also, every booked bout makes its week TAPER (light, three rest days, no sparring). Asking every 1–2 weeks halves training, and training is the stronger lever (5 stat points is about 72%). None of this is on the card or in the cases.
5. **Some chance estimates are larger than the measured anchors.** Case 1's "Beats it" lifts 28% expected to 50%, a +22 swing. The pack measured +14 for a good plan over no plan (59 against 45). Unless the stats differ too, the cases overstate how much the plan matters.
6. **The rematch rule contradicts itself.** R4 says TWICE THIS SEASON blocks a third bout. R9 says "rematch: twice a season", which allows three.
7. **The reach line contradicts itself at the bottom.** R2 says asking down has no limit, but CHECK 3's NOT SAFE rule blocks many low rows. Case 1's "ranked 12th, novice" reads NOT SAFE if your boxer is open, and the case doesn't give your boxer's bout count.
8. **Passing now costs reputation, but nothing says so.** Today Pass is free (pack 4.5). The map makes it −2, and Not this show −1, with no exception for an injured, resting or overweight boxer. It also doesn't say where those points go, which breaks the zero-sum claim.
9. **The TOO HEAVY line is looser than the code's weight forecast.** It refuses only above 1 kg a week. A 500 kcal a day cut is slower than that: the pack's 1.4 kg needs about 3 weeks. So rows between the two show YES and then miss weight, which costs $300.
10. **Classes and caps don't match the pack.**
    - The **18-bout season cap**, tagged CODE, isn't in the pack: NOT FOUND.
    - **Women's 70 kg** isn't in the pack's classes, which are 57/60/65/75 (CHECK Q-S294-233).
11. **The page breaks Look B.** Bebas Neue, IBM Plex Mono, slate rows and green aren't Look B, which uses Permanent Marker and Kalam on cream paper, with colour meaning risk only.

I score LADDER1 v4 at depth 6, general design 6 and play 7, so it doesn't reach the owner's 7 and 7 bar yet. The core is right: the player picks, every no has a reason and a way to a yes, and there's no script. But the pick is priced in only one currency, and the card shows that price. That turns choosing an opponent into "take the highest number on the screen", while the costs that would make it a real trade (training weeks lost, money, morale, layoffs) aren't shown. As in the last round, I recomputed the numbers by hand from the pack and the map, because the owner's computer is offline.

## Scores

**Depth 6.**
- **What earns it:**
  - Plan rating against style genuinely changes the best row; all three cases pick a different row.
  - The other side's rules (TOO RISKY, DUCKED, OWED) cost real calendar time.
  - The clock punishes waiting.
  - The open offer cancelling your ask is a nice collision.
- **What stops it at 7:**
  - Every case is solved by one procedure: the highest of chance × win − (1 − chance) × loss. The screen shows the chance, the win and the loss, so once tape narrows the band the pick is arithmetic.
  - The game already has the counter-pressures that would make it a judgment call, and the map ignores all of them:
    - each bout's TAPER week costs training, and training beats planning (5 points ≈ 72%);
    - easy wins pay the same $450 and +8 members as hard ones;
    - a stoppage loss means 30 days out plus 8 weeks before the next offer;
    - morale moves +8 / −12.

**General design 6.**
- **What's good:**
  - Refusals are deterministic and shown before you ask.
  - The formula is simple and its hover sum is honest.
  - The menu table is complete.
  - The build order is sensible.
  - Cutting the coach's star was right.
- **What costs points:**
  - two meanings of reputation;
  - places against points;
  - the rematch contradiction;
  - a free Pass silently becoming −2 with no injury exception and no zero-sum destination;
  - TOO HEAVY looser than the weight forecast;
  - an unsourced 18-bout cap;
  - the women's 70 kg class;
  - Case 3's arithmetic;
  - fonts and colours that aren't Look B.

**Play 7.** Choosing who your boxer fights is the core fantasy of a fight manager, and this delivers it. You get a target to pin, a mandatory flag on the top bar, a ducker who now owes you, a table that moves without you, and "+11, now ranked 5th" after every result. It's held back by a 12–30 row table to read every fortnight, and by a reward that's only points while the money and training effects stay hidden.

**Real boxing.** Mandatory challengers and eliminators are pro sanctioning-body rules (CHECK the WBC and IBF rules). Amateur bouts are made by club coaches and show matchmakers agreeing a match. So "ask, and their coach says yes or no with a reason" is true to amateur boxing, and a quarterly mandatory isn't.

## What each option changes
| Option | What it changes | Verdict |
|---|---|---|
| Ask: next show / the one after | Bout in 7–14 or 21–28 days; that week turns TAPER | Keep; **show the training cost** |
| Reach line | Caps how far up you can ask | Keep; **one unit (points)** |
| Answer words (R4) | Deterministic no with a way to yes | Keep all except as below |
| TOO HEAVY at 1 kg a week | Refuses impossible cuts | **Wrong threshold**; use the code's weight forecast |
| DUCKED + OWED | Prices ducking, rewards a hot boxer | Keep; it's the best new rule |
| Mandatory / eliminator for amateurs | Moves the top of the table | **Not real for amateurs**; keep for pro tables |
| Not this show (−1) / Pass (−2) | Price for refusing an ask | Keep; **say who gets the points**; free when injured, resting or TOO HEAVY |
| Rest until (4 weeks, once a season) | Pauses the clock | Keep |
| Pin as target | One row shown in NEXT STEP | Keep, low value |
| Show: same stance / same style | Filters the table | Keep |
| Ask for a rematch | After a loss | Keep; **fix the twice-a-season count** |
| **Missing:** training weeks lost, money and members per row, stoppage risk and layoff, morale | The other side of every pick | **Add**: these are what make it a decision |

## To reach 10/10
1. **Price every pick in everything it costs, on the card and in the probes.** Add a row to the card: "Training: 1 TAPER week (−0.6 stat points)", "Money: +$450, members +8 on a win / −1 on a loss", "Stoppage risk 6% → out 12 weeks", "Morale +8 / −12". Then make the gym's member gain from a win scale with the gap (for example +8 × win points ÷ 8, at least +2), so easy wins don't farm the gym. Re-run the three cases on the full value; if the best row is the same with and without these lines, depth hasn't improved.
2. **Give the two numbers two names.** Keep "reputation" for the gym (the code's meaning). Call the boxer's 0–100 number something else, for example "standing", and use it everywhere: R2–R9, the strip, the result line and the week review.
3. **Use one unit.** Reach, DUCKED, the "20+ below" clock rule and every chip use points, and the dotted line reads "Your reach: up to 46".
4. **Redo Case 3.** The boxer at 50 crosses 55 by beating the 5th. Rebuild it from 44 or 45, and walk through the mandatory and eliminator timing.
5. **Mandatory and eliminator for pro tables only.** At amateur level, the top moves through the regional stage and the nationals seeding the code already has. That answers the map's owner question 1, pending the owner.
6. **Set the Pass rules.** Not this show −1 and Pass −2 go to the challenger (zero-sum). Both are free when your boxer is injured, resting, TOO HEAVY or already booked. State that this changes today's free Pass.
7. **Replace TOO HEAVY's 1 kg a week with the code's weight forecast for that date.** If the forecast says a miss, show TOO HEAVY with "Start a cut: makes it by 11 Apr".
8. **Write one rematch rule:** at most 2 bouts against one opponent per season.
9. **Source the 18-bout cap or mark it (P).** Add England Boxing's rest days between bouts as the bout-frequency floor (CHECK).
10. **Follow Look B:**
    - Permanent Marker for headings and Kalam for notes, on cream paper;
    - one pulsing button (the selected Ask);
    - colour only for risk, so no slate or green.
11. **Follow S448 on rows.** Rows show portrait, club and record, and the name appears once in the card header. That answers owner question 3, pending the owner.
12. **Add three probes:**
    - **13:** a FARM bot that books the easiest YES every show must not beat THINK in money plus standing over 2 seasons.
    - **14:** THINK's training weeks lost to TAPER per season are reported.
    - **15:** the boxer's stats at 55 are within ±5 of today's pro-offer stats.
13. Close the women's 70 kg CHECK.
14. Re-probe, then send it to two fresh critics.

## The 10/10 page (1920×1080, Look B: Fights > "Who do we fight?")
**Shell (0–64):** dark top bar, with an OFFER flag and CONTINUE.

**Header (64–150):** the boxer's comic portrait, name once, class, record and "Standing 38 · 8th".

**Strip (150–220)** as five sticky notes:
- "Clock: free 5 wk, falls from wk 8";
- "Pro offer at 55: needs 17";
- "Season: 7 bouts, ends 4 Jan";
- "Pinned: the southpaw, 4th";
- "Training: 3 TAPER weeks this season".

**Open offer (220–290):** a red-edged note with Accept / Not this show (−1 to them) / Pass (−2 to them), and "Accepting cancels your ask for 28 Mar".

**Left whiteboard (40–1180): the table,** 14 rows on cream paper.
- Each row: rank and arrow, portrait, club, record, stance and style, the plan magnet (Beats it / Works / Walks into it), chance band, win and loss with the place after, the answer word, the next show and a risk chip.
- Marker lines: "your reach: up to 46" and "not ranked yet: 4 wins".
- Stress state:
  - your boxer 8th;
  - a TOO RISKY row near 55;
  - a NOT SAFE novice;
  - a Weight at risk chip;
  - an OWED tag on a ducker;
  - a WON'T STOP THE CLOCK row.

**Right panel (1220–1880): the card,** with the opponent's name in its header only. Four blocks:
- **IF WE WIN / IF WE LOSE:** standing, place, members, money and morale.
- **WHAT IT COSTS:** TAPER week, stoppage risk and layoff.
- **YOUR PLAN AGAINST THIS STYLE.**
- **WHAT WE KNOW**, with locked tells.

The answer line sits under them, then Ask: 28 Mar (the only pulsing button) and Ask: 11 Apr. Every number opens its sum on hover.

**Sources:** every game number above is DERIVED from the pack and the map. The amateur-matchmaking and pro-mandatory points are CHECK, from memory, and no web sources were used this round.

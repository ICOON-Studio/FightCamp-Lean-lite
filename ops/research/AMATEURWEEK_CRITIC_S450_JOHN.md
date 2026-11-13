# AMATEURWEEK_CRITIC_S450_JOHN - John answer (seat queue SQ62)

Brief: research/AMATEURWEEK_CRITIC_S450_BRIEF.md
Sent: 2026-11-13 14:40 | collected: 2026-11-13 15:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Reading AMATEURWEEK1 v4 against the pack and my S449 numbers now. The full critic return follows.

# AMATEURWEEK1 v4 (S450): critic

Depth **6/10**, play **7/10**. v4 fixed the prices, the morale scale, the weigh-in, the pull-out rate and favours. Depth stays at 6 for four reasons:
- Trips cost hundreds of dollars and buy a fraction of one stat point.
- Nobody covers the club while the coach is away.
- Rank (and so away shows) barely matters, because the pro offer also comes at 9 wins at any rank.
- Tick over's only fight-night credit does nothing until FIRELEVEL3.

I couldn't open `camp_plan_v3.png` because your computer is offline, so I judged from the text.

## 1. Logic check

- **The stoppage rest contradicts the pack.** Sections 2 and 9 say a stoppage rests 8 weeks (`Matchmaking.STOP_REST_WEEKS`) and call it "unchanged". Pack 4.10 says a stoppage loss means a 30-day suspension, longer for repeats. One of the two is wrong. Quote the code, or name the change.
- **The pro offer makes the climb nearly worthless.** The pack's pro offer comes at 7 wins with a top-3 regional rank, or 9 wins at any rank. Nationals entry needs 5 bouts and no rank. A boxer who boxes only at home reaches a pro offer at 9 wins and banks 9 × $450. Away shows save at most two bouts, so "away is where you climb" buys almost nothing.
- **Tick over's "+1 plan line ready" does nothing today.** With FireLevel off, every line fires every time (4.2). The map admits the 90% line waits for FIRELEVEL3, but Tick over's credit depends on the same switch. Until then, Tick over is just Rest up without the flat round 1.
- **Trips are priced on the wrong scale.**
  - The cap is "4 in 100 on fight night", but the buffs only multiply gains: Cardio gains ×1.25 and Legs gains ×1.2, applied to at most one banked week.
  - A focused week is about 1.0 point of pace (4.1), so a $575–1,150 cottage or seaside week buys about 0.2 of a stat point.
  - Only the seaside's mood +3 and recovery +15% show up on the night.
- **Nobody covers the club during a trip.** The map prices "the boxer plus one coach", but never says who runs pad nights for the other three boxers that week. Two shows on one night is handled; a trip isn't.
- **What happens to pad nights away is unstated.** If the cottage has no pads, film can't happen that week. The map doesn't say.
- **Food is missing from trip prices.** I measured about £95 for two a week plus £30–50 of extras, so about $120 plus $40–60. Peak at the cottages I checked was the summer school holidays, about late July to August. "June to August" is a fair rounding, but label it ESTIMATE.
- **The 0-favour penalty is almost empty.** Ranked names only ever appear on away cards, so "at 0, ranked names only on away cards" changes nothing. At 0 the only real loss is the kilo ask.
- **The boxer's savings are club money with a delay.** They fill from the stipend's leftover, and the club pays the stipend. That isn't what I found: club boxers get no stipend and pay from their own job wages. And if the stipend is stopped, savings never fill.
- **Who pays is still settled by cash alone.**
  - At a 50% win chance, the boxer paying averages −0.5 morale, against +3 when the club pays. Half each is +1.
  - Loyalty +1 on a hidden trait does nothing you can see.
  - So the club pays whenever it has the money, and the fundraiser option is still missing.
- **"Season" is never defined**, so "bouts this season 7 of 11" has no start date.
- **"Go home: the week spent" is unclear.** Does the banked work still count?
- **Sparring's plan test changes nothing on the night.** The map never says what a test changes on fight night.
- **Names and pronouns:** no names or fixed he or she in the map text. The rows use roles. I couldn't check the PNG.
- **Real numbers carried over correctly:** the weigh-in, the gaps (rule 2.7.8), no $300 fee, pull-outs at 25%, and the city and cottage prices.

## 2. Depth: 6/10

- **Load is now a real choice.** Train through costs about 2 more wins than Tick over on the night and banks half a week more. Rest up wins only when tiredness is over 50. That holds up across four boxers.
- **The film trade is real:** one of the boxer's own pad nights for one habit group. But a confirmed tell's worth was never measured, so the trade can't be judged yet.
- **Home or away is a lookup:**
  - Home brings money.
  - Away brings rank, and rank buys little (see the pro offer above).
  - Home draws only names below, so a home bout can never climb.
- **Trips are an option nobody takes,** except the seaside for mood. The city commute ($150, Fight IQ ×1.3) is the only trip worth its price.
- **Section 4b is honest, and moving the weight to the season is true to boxing.** But it isn't convincing yet:
  - FIGHTWEEKPROBE3 hasn't been run.
  - Train through's season price ("2–5 more stoppages or injuries") has no mechanism. "+1 tiredness carried" can't produce it.
  - On the night the box moves by 1–3 wins, which is inside the noise. Unless the season cost is on screen, the week becomes a formality: the player clicks "The coach runs this week" by the tenth bout.

## 3. Play: 7/10

What keeps it moving:
- The sheet comes back every 3 weeks.
- 1 bout in 4 falls through, and a replacement is offered.
- Two shows on one night.
- The confirmed tell is read in the round-1 corner, once FIRELEVEL3 lands.

All of these make Continue tense. The season line ("home 5, away 3, $2,250, 2 places") is a good reason to come back. It doesn't reach 8 because the levers in the week barely show on the night.

## 4. Options and menus

| Menu | Verdict |
|---|---|
| Boxer's Fights tab | Keep. Coach picks the bout is right. **Add:** what a win does for the pro offer ("pro offer: top-3 needs 2 more ranked wins / 9 wins needs 4"). That's the number that makes home or away a real choice. |
| Fights rail list | Keep. |
| Bout card | Keep. The risk row must use the stoppage rest the code really has. |
| Fight week, locations | Cottage and seaside are useless as they're priced now. City commute is the only live trip. **Missing:** who covers the other boxers during a trip, and food in the price. |
| Fight week, load | Keep. Tick over's credit has to be real today. |
| Fight week, sparring | Missing: what the test reveals, and a cut risk in the final 7 days. |
| Fight week, who pays | Half each is useless (strictly worse than the club paying). The boxer paying is useless unless there's no cash. **Missing:** Fundraiser. |
| ON FIGHT NIGHT | **Missing:** a season row showing banked work. Without it the week reads as noise. |
| Week board, Office, Roster card | Keep. |
| Tape room | Keep. Free facts at away shows are the best part of the away side. |
| Region favours | Weak, because the 0 penalty does nothing. |
| Continue stops | Keep. |
| Result page | Keep the sizes. Add the banked weeks to the season line. |
| Money | Keep. |

## 5. To reach 10/10 (mechanics, most important first)

1. **Make rank buy something real, so home or away is a real trade.**
   - Pro offers read rank: a top-3 boxer gets STEP UP and TUNE-UP offers and the purse at +$400 a place. An unranked boxer at 9 wins gets TUNE-UP only, unranked pay.
   - Nationals seeding reads rank: the top-2 seed skips the regional's first round.
   - Draw home opponents, not fix them: 1 in 3 home cards carry a name above, 2 in 3 away cards do.
2. **Price the coach's absence on every trip.** Pick one of three:
   - The head coach goes, and the other boxers' pad nights run at the assistant's pads rating.
   - The assistant goes, and the other boxers lose those pad nights.
   - The boxer goes alone, at half the buff and no pads.
   - Show the cost by role on the week board.
3. **Make trips buy fight-night value, or cut them.**
   - City commute: a partner matched to the opponent's style or stance, which removes the round-1 style penalty, like the $160 outside partner.
   - Cottage: clears 20 tiredness and gives the Cardio gain.
   - Seaside: clears 15 tiredness and mood +3.
   - Add $120 plus $40–60 for food to every stay.
   - CAMPPLACE1 measures each one on the night and over the season. Cut any trip that loses money at every price.
4. **Run FIGHTWEEKPROBE3 before the build, and give Train through a real downside.** Train through carries +8 tiredness, not +1, and doubles training injury risk that week (1.3% → 2.6%). The probe has to show the 8–12 in 100 season gap. If it can't, cut the load slider to two stops.
5. **Put the season on ON FIGHT NIGHT.** Add a sixth row, "banked this season: 4.5 of 6 fight weeks", plus its measured worth in wins. Show the same line on the result page.
6. **Give Tick over a real credit with FireLevel off.** For example, a round-1 plan edge of +0.3, measured in FIGHTWEEKPROBE2's harness. Otherwise ship it without the +1 line until FIRELEVEL3.
7. **Make sparring's test reveal something.**
   - Each night confirms one plan line's rating (Beats it, Works or Walks into it) against the opponent's style.
   - In the final 7 days each night carries a cut chance (1 in 30, ESTIMATE) that pulls the boxer out.
8. **Rebuild who pays.**
   - Savings fill from the boxer's own job ($25–75 a week by boxer) whether or not the stipend is paid.
   - The boxer offering to pay arrives as one of the existing asks (heard +5, overruled −5).
   - Add a Fundraiser: one week's lead, covers up to $600, uses one club evening, +2 reputation.
   - Drop Half each.
9. **Give 0 favours a real cost.** At 0, the club offers no ranked names for 8 weeks and no kilo. The return to 1 after 12 weeks stays.
10. **Settle the stoppage rest** (30 days per pack 4.10, or 8 weeks with the change named), and date the sheet from it.
11. **Measure film's worth:** a confirmed tell's wins against one pad night's mastery. If the tell is worth less, film is an option nobody takes.
12. **Define the season** as the regional season start to end, so the 11-bout cap has a start date.

## The 10/10 fight-week screen at 1920×1080

- **Dark top bar (64 px) and left rail (96 px):** as they are now.
- **Header, 120 px:** the boxer's name appears once here, with the portrait.
  - Class, walking weight against the agreed weight, and the gap in kilograms.
  - The versus strip: opponent portrait, record, style word, home or away, favours with that club, and the date circled.
  - On the right, the season chip: "bouts 7 of 11, home 4 away 3, $1,800, 2 places, pro offer: 2 ranked wins away".
- **Left column, 560 px: WHERE.**
  - Four location polaroids: Home, City commute, City stay, Hills or Seaside by season. Each shows its full price with food, its fight-night effect, its season effect, and the cover line ("other boxers: pads at 58 this week").
  - Cards that can't be used now are greyed, with the reason.
  - Under them, WHO PAYS: three buttons (Club, Boxer's savings, Fundraiser), each with its cash, mood and loyalty effect.
- **Centre, 720 px: HOW HARD.**
  - Three sliders with picture stops: Load, Sparring nights (each showing what it reveals and its cut risk), and Weight (only outside the gap).
  - The shares bar.
  - The seven-evening strip with magnets for pads, film, sparring and travel. The pad nights other boxers lose are marked by role.
- **Right column, 560 px.**
  - The coach's pinned note: face, one-line reason, how sure, "Use coach's pick".
  - The opponent's file: five habit groups, each SEEN, CONFIRMED or UNKNOWN, with "film costs one pad night".
  - ON FIGHT NIGHT in chalk: tank, sharp or flat, lines ready, scale margin, win band, and banked this season. Each row is tweened and shows its change from the coach's week.
- **Bottom strip, 90 px:** fall-through risk this week ("1 in 4: replacement offered") and the Confirm the week button.

# AMATEURWEEK_CRITIC_S455_BRIEF_JOHN - John answer (seat queue SQ72)

Brief: research/AMATEURWEEK_CRITIC_S455_BRIEF.md
Sent: 2026-11-13 18:40 | collected: 2026-11-13 19:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading the AMATEURWEEK v6 map against the pack now. The full critic return comes next.

# AMATEURWEEK v6 (S455): critic

Depth **6/10**, play **7/10**. v6 fixes a lot of v5: the trips are priced, the tank is capped, the pick can be wrong, savings come from the boxer's job, and there's a fundraiser. But it has new problems:

- The SEASON line now prints which stop is best, so the fallible pick changes nothing.
- The tank cap makes the most tired boxers pay the least for the choices they make.
- Two of the new trades are dominated: half-each paying, and late sparring.

I couldn't open `camp_plan_v3.png` (it's on your computer, which is offline), so I judged from the text.

## 1. Logic check

**The SEASON line gives away the answer.** Part A has it compare each stop "with the best stop for this boxer this week". The stop showing 0 is the answer, so the 13–21% error built into the pick does nothing. Sureness is 0.79 for the 58-rated coach and 0.87 for the 74-rated one; the player just reads the zero. The PROBE TARGET (a reader beats the pick by 2+) passes trivially, and the load slider becomes "press the zero".

**The tank cap's order makes choices free when the boxer is tired.** Tiredness stacks first and the weight last, all stopping at 25. A boxer at 70 tiredness at the bell already has 20 off. Train through then adds 5 of its 12, and a 1 kg Eat less adds nothing. The most tired boxer pays least for loading and cutting, which is the reverse of the intent.

**Train through's "best when" state almost never happens.**
- "The next sheet is 4+ weeks away" can't happen after a points bout, because the sheet comes 21 days later. It happens only after a stoppage suspension or a club lock.
- "Opponent rated 5+ below" is already about 72% to win (the pack's measure).
- So Train through is right in maybe 1 fight week in 15. That misses the build target of each stop being best in 1 week in 5.

**Rest up between 40 and 64 tiredness.** It starts sharp with a full tank, and tiredness carries down to 30. Tick over's only answers are a 6-off tank (inside the noise), half against a fifth of the banked week (about 0.3 stat points), and one line a level up in round 1. Those are close, but it's undefined whether Rest up's "full tank" clears tiredness over 50 or just adds no load part. That decides the 65+ case the map calls Rest up's best.

**Sparring buys almost nothing.**
- "Confirms one plan line: fires at its full share from round 1 (as a CONFIRMED tell)." By Part B section 5, an unconfirmed SEEN line runs at 90% of its share in round 1 only, and a line not built on a tell already runs at 100%.
- So confirming is worth a tenth of one line's share for at most six exchanges, and only for tell-based lines.
- 5 and 3 days out pay 3 off the tank and ×1.5 injury for two such confirmations. Nobody takes them.
- The night count is also unclear: "5 or 3 days out" confirming "TWO lines (the second night)" means two nights, but which two?

**The cottage's two effects overlap.** The week before "runs as Train through with no load-ratio cost". But that week is a normal BUILD/PEAK week on the week board with no load slider, so this adds nothing defined. "Tiredness −6" matters only above 50, and "Tick over then costs 3, not 6" is a second, separate discount. Pick one.

**The pay options: half each is dominated.** At the measured 61% wins:
- The boxer paying is worth 0.61 × 6 − 0.39 × 3 = +2.5 mood at $0 to the club.
- Half each is worth +0.8 mood at half the cost.
- The club paying is +3 at full cost.

Half each is never right while savings cover the trip. Any trip also adds mood just by being taken, so a boxer-paid commute is free mood plus a round-1 edge. Its only cost is the coach going too.

**The weight contradicts itself.** Part B matches "at actual weight plus a gap, never the class limit". Part A keeps "the career's first-hour cut" for walk-ins 2–4 kg over. If matching uses walking weight, nothing forces a cut. Say which number the match uses and what a cut buys: a lighter class, other names, a slot.

**The nationals can't be entered in the first season.** The first bout is day 26. The next sheet comes 21 days after it, with bouts at least 1 week out, so the cycle is at least 28 days: bouts on days 26, 54, 82. Entry closes in week 10 (day 70) and needs 5 bouts and 3 months registered. "Bouts to entry n of 5" counts toward a closed door in year 1. The card has to say "next year's entry".

**Pass still cascades.** "Only the pressed PASS button counts, declining the whole sheet", and the count is kept per club. A sheet of three cards from three clubs puts a pass on all three, so two whole-sheet passes lock three clubs for 8 weeks.

**Tells: the show rate is undefined.** "A tell whose mode came up and did not show drops a level." OppFile tells are facts of the opponent, so does one ever not show? Without a rate for a tape read being wrong, SEEN to CONFIRMED is a ritual.

**Stat names.**
- The code facts map Heavy bag and Strength circuit to Power, and Shadow and Pads to Technique. Both are summary stats since S448.
- "What the week builds: Technique, Strength, Stamina" mixes summary and Attrs names, and Strength isn't a Data.LABEL output.
- BANKED "+0.5 stat points" needs to say which Attrs number.

**Tick over against the evidence.** WeekPhase's taper has three rest days. The evidence (my S449 note) is one rest day with volume cut 40–60%. "Tick over = today's taper" is therefore not "the evidence".

**Code rules changed without the owner.** Part B drops `Matchmaking.STOP_REST_WEEKS` for amateurs, replacing a rule the S451 code check confirms. That's a decided rule change missing from section 13.

**Fall-throughs.** At 35 in 100 a bout, 4 boxers at about 10 bouts each get about 14 fall-through stops a season. Nothing says whether a paid trip or the coach's week away is refunded.

**Names:** none outside headers. Roles and "the boxer" are used throughout, and the club names on cards are clubs, not people.

## 2. Depth: 6/10

**Real decisions:**
- **Which card:** home money against an away place, set by the goal and the favours.
- **Whether the coach goes:** a commute or the cottage costs the other three boxers a week at 60% and the class's $350. With four boxers that's a real Monday trade.
- **The weight route:** Eat less against Train it off depends on tiredness. Train it off is better only below about 42 at the bell.
- **Favours:** a late replacement now for a ranked name later.

**Where it breaks:**
- **The printed best stop.** The load decision is read off the screen.
- **Sizes inside the noise.**
  - A whole fight week's best-to-worst gap is under 5 in 100 (PROBE1).
  - Banked is about 0.5 of a stat point.
  - The commute's 1.0 round-1 edge is worth about 1–1.5 in 100, DERIVED as half of the flat 2.0's 2–3.
  - Sparring confirmation is worth a fraction of one line in one round.
  - By the tenth bout the player trusts "Your assistant runs this week", which is wrong about 1 week in 5 at a cost nobody can see. Every fight week across four boxers (about 40 a season) becomes one click.
- **Always-right picks:**
  - The boxer pays (or the club), never half.
  - Sparring at 9 days when allowed, never 5 or 3.
  - Tick over unless tired.
  - Train through almost never.
  - The fundraiser whenever reputation is middling: −$350 against $300–600 is about +$100 on average.
- **Nobody takes:** half each, late sparring, Train through.
- **Chores:** fall-throughs at 14 a season, and favour asks at about 11 a year across the region, each stopping the clock.

## 3. Play: 7/10

The bout sheet carries the season: home or away, the climb, favours, a slot lost to your other welter, a late replacement. Those make you want to see next Monday. The fight week screen itself is a confirmation page with one real lever, the coach away.

## 4. Options and menus

| Menu or option | Verdict |
|---|---|
| Fights tab bout cards | Keep. Add "next year's entry" when the nationals are out of reach. |
| "Your assistant picks the bout" | Keep. It reads the goals now. Under 4 wins a rank goal has no table, so grey it with the reason. |
| PASS (whole sheet) | Change it. Passing a sheet should cost nothing. Only refusing a card a club offered by name counts against that club. |
| Trips: home, commute, cottage | Keep. Add **Boxer goes alone** (the partner with no coach: half the edge, no coach-away cost). That's the missing option. |
| Coach-away cost line | Keep. It's the best line on the screen. |
| Load stops | Keep three. Fix Train through's state and stop printing the best stop. |
| Last sparring 9/7/5/3/none | Too many stops for one value. Make it 9, 7 and none, or give late sparring a real price. |
| Weight: Eat less, Train it off, Ask for a kilo | Keep. Fix which weight the match reads. |
| Who pays (three choices) | Half each is dominated. Rework the mood or cut it. |
| Fundraiser | Keep. Its payout needs to go negative at low reputation. |
| ON FIGHT NIGHT, SEASON line | Change it: show the price against Tick over for the boxer's state band, not against the best stop. |
| Fall-through card | Missing: what happens to money already spent on a trip. |
| Boxer card "can take a bout in 7 days" | Keep. |
| Corner minute CONFIRMED / Not seen | Keep, once a tell has a chance of being wrong. |
| Money: trips by payer, fundraiser nights | Keep. |

## 5. To reach 10/10 (mechanics, most important first)

1. **Stop printing the answer.** The SEASON line shows each stop's measured price against Tick over, a fixed baseline, for the boxer's start-tiredness band only ("Rest up here: −1 to +2 in 100"). Opponent gap, weight and next-sheet date stay out of the line. The pick reads all of them, so a player who weighs them beats the pick. FIGHTWEEKPROBE4 tests that; otherwise the slider is cut to Tick over or Rest up.
2. **Make sparring the thing that gets a plan ready.** A plan line written or changed since the boxer last sparred fires one level down in rounds 1–2 (Usable to Raw: does not fire). A spar at 9 or 7 days readies two lines; a late spar at 5 or 3 readies all of them at ×1.5 injury and 3 off the tank. A new plan written for this opponent then has to be sparred. Measure it, target 2–5 in 100 a bout.
3. **Charge the boxer's choices first.** Load, sparring and weight stack before tiredness, and the cap cuts tiredness last. The greyed overflow is then always "tiredness already lost". A tired boxer still pays for Train through and a cut.
4. **Bank in mastery, so Train through has a real state.** A full banked week adds the week's pad units (720 for 3 pad nights) to the plan's moves. Half and a fifth scale down. The card shows "Train through: Uppercut Usable by the bell", which with FireLevel on fires 1 in 2. Train through is right when a move sits within one week of a tier. That state is common and readable, unlike "next sheet 4+ weeks away".
5. **Let the player set the rest window.** On the Fights tab: "next bout no sooner than 3 / 5 / 8 weeks". It moves the next sheet, Train through's load-ratio risk, and ring rust at 6+. It replaces the fixed 21 days, so a planned build block exists for a boxer who only wants to learn.
6. **Mood by payer, so each payer wins somewhere.**
   - **The club pays:** +3, but −2 with each other boxer if the club paid for this one more often in the last 8 weeks (fairness).
   - **Half each:** +3 on a win, 0 on a loss.
   - **The boxer pays:** +6 on a win, −6 on a loss. Savings under $100 put the boxer at "skint", −2 a week until refilled.
7. **One weight rule.** The match reads walking weight plus the gap. A cut is a choice to box down a class for that class's slots and ranked names. The first-hour cut becomes "box at 60 against a ranked name in 3 weeks, or at 65 now". The miss rule stays.
8. **The nationals entry on a rolling year.** Five bouts in the last 12 months and 3 months registered. Year 1 shows "next entry: week 10, 2027". Not built today: the nationals screen has no next-year state.
9. **Price passing per card.** Passing a whole sheet is free. Refusing a club's named call counts (2 in 8 weeks = its lock). No cascade across clubs.
10. **Tells can be wrong.** A SEEN tell is true at 70% after one film night and 90% after two. Not shown drops the line a level. That gives a second film night a price and CONFIRMED a meaning.
11. **Rules for a fall-through.** The cottage refunds half, the commute nothing, the banked week stays. The replacement card has three answers: take it, go home (+2 rest, mood −6), or ask the host for next month's slot (−1 favour, booked).
12. **Boxer goes alone** on the commute: half the partner's edge, no coach away, +1 tiredness.
13. **Fundraiser** at reputation odds: under "Known locally" it nets −$150 on average; at "Respected" and above +$150.
14. **Small fixes:** Attrs names for the sessions and the banked row; Tick over at 1 rest day with the volume cut, matching the evidence; the amateur STOP_REST_WEEKS removal added to section 13.

## The 10/10 fight week at 1920×1080

- **Header strip, 96 px:** the boxer's portrait and name once, class, and the bout (days to the bell, home or away club, weigh-in on the day, scale margin now and on the day). At the right, back to Fights.
- **Left column, 440 px: WHERE AND WHO.**
  - Three trip cards and Boxer goes alone. Each shows its cost, its one number on tonight, and its fall-through refund.
  - Under them, a red-edged COACH AWAY card: "3 boxers at 60% this week, evening class off: −$350".
  - The payer row: Club, Half, Boxer, with savings left and each choice's mood on a win and a loss.
  - The week-before strip sits above when the bout is 2+ weeks out.
- **Centre, 920 px: THE WEEK.**
  - Seven day columns of morning and evening magnets, with the sparring day pinned as a red magnet and the film night as a tape magnet.
  - Under them, three sliders with picture stops: LOAD (with the tiredness band printed), LAST SPARRING ("readies 2 lines"), and WEIGHT (Hold, Eat less, Train it off, Ask for a kilo, each greyed with its reason when unusable).
  - Plan lines below as chips: green "ready", amber "not sparred: fires a level down in rounds 1–2", and a SEEN or CONFIRMED tag.
- **Right column, 560 px: ON FIGHT NIGHT (gold frame).**
  - TONIGHT: the stacked tank, with the player's choices in colour, tiredness in grey, the overflow hatched, and its price in wins. Round 1 sharp or flat. Each line's fire per cent. The win band.
  - BANKED: the moves crossing a tier by the bell, Attrs points, tiredness carried.
  - SEASON: this stop against Tick over for the tiredness band, with its range.
- **Bottom strip, 120 px:** your assistant's note (portrait, reason, sureness word, no name in the text), Use the pick, Back to the coach's week, and the one pulsing button, Lock the week.

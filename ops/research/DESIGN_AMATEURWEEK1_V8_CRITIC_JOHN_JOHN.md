# DESIGN_AMATEURWEEK1_V8_CRITIC_JOHN_JOHN - John answer (seat queue SQ96)

Brief: research/DESIGN_AMATEURWEEK1_V8_CRITIC_JOHN.md
Sent: 2026-11-14 11:12 | collected: 2026-11-14 11:42 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading AMATEURWEEK1 v8 against the pack and my v7 faults now. The full critic return comes next, including the check on whether a host can re-match a boxer on the night.

# AMATEURWEEK1 v8 (SQ88): critic

Scores: **depth 7/10, general design 6/10, play 6/10**. That **passes the owner's bar**, with general design at the floor.
- I couldn't open `CRITIC_ACCESS.md`, the board or the mockups, because your computer is offline, so I judged from the map and the pack.
- Names and pronouns pass: the screen text says "the boxer", "your assistant" and "your other 65 kg boxer". Luke Reid and Marcus Hale appear only in the design reasoning, not on any screen line.

**What v8 fixed from my v7 list:**
- The tank now charges a tired boxer for every choice.
- Eat less has a price.
- The pull-out roll comes before the bout.
- The cottage refund is gone.
- The player picks which plan lines get readied.
- The shared slot has Swap.
- The fundraiser is cut, film is locked against a debutant, and the second film night is a real choice.
- The pack changes are listed.

## Answer to `CHECK (John)`: can a host re-match a boxer who missed weight on the night?

**I found no EB rule that allows it, and the evidence points the other way.**
- **Rule book:** the [EB 2026 rule book](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf) (read 2026-11-14) puts the weigh-in 1 hour before boxing (7.1.3). The Supervisor "shall have complete charge of the club tournament" (6.6.1), and a boxer "cannot box twice on the same calendar day" (6.6.8), so a missed boxer can't be held over as a spare for later. A clause on re-matching on the night: NOT FOUND.
- **A club's account:** [Stevenage ABC](https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing) (undated; read 2026-11-14) says bouts are matched "weeks before any club show" against an agreed weight. If a boxer weighs in "lighter or heavier than the agreed weight the bout will be called off" by the Officer in Charge.

So **cut the 1 in 3 re-match**. A miss means the bout is off and the club pays its $300. Keep the favour cost as the host's goodwill (GAME).

The same Stevenage page says **"There are no weight classes in Club boxing"**. That backs v8's move to matching on a gap. It also means the map's class choice at club shows ("box at 60 kg in 3 weeks or at 65 kg now") is wrong (point 2 below).

## Logic check

**1. The tank charges by two different clocks.**
- Rest up charges by tiredness at the bell (brought to 30, so 0 off).
- Tick over and Train through charge by tiredness at the start (25 off at 75).
- Tick over has a rest day and half the volume, so its tiredness at the bell is lower than at the start, but the table charges it as if nothing changed.
- At 75, that makes the gap between Rest up (0 off, and still Sharp at 65+) and Tick over (31 off) far bigger than the real difference.
- **Fix:** every stop states its tiredness at the bell, and the tiredness layer reads that number.

**2. The weight rule still mixes class and gap.**
- If club shows match only on the gap (EB 2.7.8, and "no weight classes in club boxing"), then no one cuts to enter a class at a club show. The cut only serves the agreed weight against one opponent.
- The "60 kg in 3 weeks or 65 kg now" choice belongs to the championships only, where the class limit applies the day before.
- **The rule should read:**
  - At a club show, the class shown is the class the boxer's walking weight falls in. It sets the ladder table only.
  - A miss is measured against the agreed weight plus or minus the gap.
- **Two smaller gaps in the weight rule:**
  - The card has to show the opponent's agreed weight, or "the margin against the gap" can't be printed. Opponents need a walking weight.
  - Stevenage reports 2 kg as its usual allowance, while the map has 2.5 kg up to 65 kg and 5 kg above. Those are the rule-book ceilings. Clubs often match tighter, so a 2 kg default with the ceiling as the limit is closer to real practice.

**3. A trip is priced in wins but paid for in cash.**
- The commute with the assistant costs $270 for about 1 to 1.5 wins in 100. On a club-show bout worth $450 plus +8 members, that buys about $10–15 of expected value, so the home gym wins every club-show week.
- CAMPPLACE1's target ("1 to 4 in 100") measures wins, not money.
- Either price a win in dollars for each kind of bout and probe that, or gate the commute to ranked or championship bouts the way the cottage is gated.

**4. Home and away don't add up.**
- The map puts "$450, +8 members, +5 reputation" under Home, but in the pack those are what a win gives at any bout ($450 is the club's ticket cut).
- "Home" is undefined: the player's own hosted show (every 16 weeks, $3,500) or a show nearby?
- If an away win gives no members and no reputation, home dominates unless the boxer has a rank goal.
- Say what an away win gives, and what home means.

**5. The 8-week rest window always triggers ring rust.** Rust comes after 6 weeks READY without a bout, but an 8-week window can't get a bout before week 8. Either count rust from the end of the window, or make 8 weeks a choice that costs rust on purpose and print that on the pill.

**6. UNSPARRED has holes.**
- Step and defence answers (`StrikeMap` arrows: step back, tie up and the rest) have no mastery and "always work in full" (S448), so "one level down" means nothing for them. Say whether an unsparred arrow fires 1 in 2, or isn't affected.
- Tick over's "one line one level up" and UNSPARRED's "one level down" can land on the same line. The map doesn't say they cancel.

**7. Savings make stopping the stipend free.** Savings grow only with the stipend Off, and the pack lists no price for Off. Switching it off saves the club $250 a week and fills the boxer's savings, so it's a dominant pick unless Off already costs mood or loyalty. Print that price, or give Off one (for example −1 mood a week while savings are under $200).

**8. A false tell has no price.** A SEEN tell is true 70 in 100, but the map never says what happens to a plan line built on a false tell: Works, Walks into it, or nothing. Without a price, "Look again" (70 to 90) buys nothing you can see. My suggestion: a line answering a false tell rates "Walks into it" when the mode it was meant for comes up.

**9. Favours need a pool.** "Favours with the host" works only if there's one host. With RegionShows there are many, so favours per host rarely build up. Use one regional pool of 0 to 3, or say favours are per host and show the top host's count.

**10. One fight week in three falls through.**
- A 35 in 100 rate per own bout matches the 25–50% card attrition I sourced. Those were whole-card losses, though: the source didn't say whether our side or the other side pulled out.
- In play, one prepared week in three won't happen, and the week-before trip and sparring are already paid by Monday.
- Keep it, but make "Take the replacement" the default on the card, and say on the card that the week before still banks.

**Smaller points:**
- Section 3 is missing (the numbering goes 2, then 4).
- The COACH AWAY card says the evening class stops, but the commute says "the evening class still runs". Make the card show only for a full week away.

## Scores, with reasons

**Depth 7.** Load, sparring, weight, trips, film and who pays now each pull against the tank, mastery, mood or cash. Each load stop has a state where it's the right pick, printed on the stop. Choices land on TONIGHT, BANKED and SEASON, so they touch the plan, the Playbook tiers and the season. It falls short of 8 for two reasons:
- Trips at club shows have no winning state (point 3).
- Stopping the stipend is free (point 7).

**General design 6.** Most of the rules are now consistent and buildable, and the build order and pack changes are honest. Three things hold it at the floor:
- The tank uses two clocks (point 1).
- The weight rule still runs a class choice at club shows (point 2).
- Home and away aren't defined (point 4).

**Play 6.** Getting a plan ready by sparring night has a real arc: write it, spar it, see it rated, decide whether to change it late. Two things drag it down:
- One fight week in three falls through.
- The screen asks for about nine decisions a week, so it needs the assistant's pick to be a trusted one-click.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Swap slot | Which of two same-class boxers gets the slot | Keep |
| Pass sheet, refuse a named card | Nothing, or that club's lockout count | Keep |
| Rest window 3 / 5 / 8 weeks | Next sheet date and ring rust | Keep. 8 weeks is a hidden trap (point 5) |
| Home gym | Nothing | Keep (the baseline) |
| Commute with assistant or alone | Round-1 edge against cash, injury, tiredness and the coach at home | **Useless at club shows** as priced. Gate or reprice it |
| Hill cottage | Full banked week, −10 tiredness | Keep for championships only, as mapped |
| Rest up, Tick over, Train through | Tank, round 1, banked mastery, tiredness after | Keep. Fix the bell clock first |
| Line picker under Tick over | One line one level up in rounds 1–2 | Keep. Define how it stacks with UNSPARRED |
| Sparring: week before, 7–6 days, 5 or fewer days | Lines readied and plan test, against tank, injury and cut | Keep. The best new choice in the map |
| Eat less, Train it off | Weight against 4 tank or +8 tiredness | Keep |
| Ask for a kilo | 1 kg of gap for 1 favour | Keep |
| Who pays: club, half each, boxer | Cash, savings, mood, fairness | Keep. The boxer row is worth taking only when cash is tight |
| Film: look again or next group | Tell sureness or tell count | Useless until a false tell has a price (point 8) |
| Fall-through: replacement, go home, next month's slot | Tonight's bout, mood, a favour | Keep |
| Re-match on a miss | Bout saved 1 in 3 | **Cut** (no EB basis) |
| Use the pick | The assistant's settings with its reason | Keep |

**Missing options:**
- **An agreed weight with the host:** a club show pairs boxers weeks out at a stated weight. The card should show that weight and allow one "Ask to move the agreed weight" before fight week for a favour. That's how real matchmaking softens a weight problem.
- **Withdraw your own boxer:** for illness or a bad week, before Monday's roll, with a favour or reputation price. Only the opponent can pull out today.
- **What-if with no plan change:** a one-click "Keep last bout's plan" that skips sparring, for a rematch.

## To reach 10/10

1. **One clock for the tank.** Each stop prints tiredness at the bell:
   - Rest up: 30.
   - Tick over: start − 15 (ESTIMATE).
   - Train through: start + 6.
   The tiredness layer charges 1 off for each point over 50 at the bell, capped at 25. Re-run the 75 example.
2. **Club shows match on an agreed weight.** The host sets each pair's agreed weight weeks out (gap default 2 kg, EB ceiling 2.5 kg up to 65 kg and 5 kg above). The weigh-in is on bout day, 1 hour before. A miss is outside agreed ± gap: the bout is off, $300, and −1 favour. No re-match. Classes at club shows are a ladder label only. Class cuts stay for championships.
3. **Price a win in money for each bout type and probe trips in dollars.** Either the commute shows "worth it from a ranked or championship bout", or it's gated there. CAMPPLACE1 reports net value, not just wins.
4. **Define home and away.**
   - **Home** means the club's own show (the existing $3,500 show) or a show within the region.
   - An **away** win gives the ticket cut? (state yes or no), +4 members and +5 reputation, plus a ranking place.
   - Print both on the card.
5. **Ring rust counts from the end of the rest window.** The 8-week pill says "no bouts for 8 weeks: more training, no rust".
6. **UNSPARRED for arrows:** an unsparred `StrikeMap` arrow fires 1 in 2 in rounds 1–2. Tick over's line boost and UNSPARRED cancel on the same line, and the picker shows that.
7. **Give the stipend Off a price.** −1 mood a week while savings are under $200, and print it on the stipend toggle.
8. **A false tell's line rates "Walks into it"** when its mode comes up. The film choice then has a visible payoff.
9. **One regional favour pool** of 0 to 3, shown in the header.
10. **Fall-through card:** "Take the replacement" is the default, and the card lists what still banks.
11. **Add "Ask to move the agreed weight"** (1 favour, before fight week) and "Withdraw my boxer" (−1 favour, −2 reputation, before Monday).
12. **Renumber the sections, and show COACH AWAY only for a full week away.**

## The 1920×1080 page (Look B)

**Shell:** a dark top bar (CONTINUE reads "to Mon, fight-week check") and the left rail (Fights lit) around a tan wall with a whiteboard 1640×960.

**Header strip (96):**
- Both portraits with names once, each record, "65 kg ladder", and "Agreed 63.0 kg, gap 2 kg".
- The scale now at 63.8 and on the day at 63.3, with a green tick inside the gap.
- "6 days to the bell", HOME or AWAY with what a win gives, the favours pool as 2 magnets of 3, and a link to the next four weeks on the Office desktop.

**WEEK BEFORE row (84, only 2+ weeks out):** the trip pill (Home gym is the default; a greyed commute says "worth it from ranked bouts") and a sparring magnet for the week before.

**Left column (440):**
- Trip cards.
- The payer row: club, half each, or boxer, with savings $340 and the Confidence gate.
- The stipend line with its mood price.

**Centre (920):**
- Seven day columns, Mon to Sun, with magnets: red sparring, film tape, rest.
- The LOAD pill with three stops. Each stop shows "Tiredness at the bell: 30 / 52 / 81", and hovering shows the next stop's prices.
- The line picker under Tick over shows a chip that says "cancels UNSPARRED" when that applies.
- WEIGHT pills: Eat less (4 off), Train it off (+8 tiredness), Ask to move the agreed weight (1 favour).
- Plan line chips tagged READY, UNSPARRED, or SEEN 70 or 90.

**Right column (560), ON FIGHT NIGHT in the gold frame:**
- On top: "4 ready, 1 UNSPARRED, 2 SEEN".
- **TONIGHT:** the tank bar (grey tiredness at the bell, then coloured choices), round 1 Sharp, fire shares by line, the scale margin, and the win band 48–60.
- **BANKED:** "Strength +0.4; Uppercut 27 to 31, Usable by the bell; tiredness after 58".
- **SEASON:** "Tick over here: baseline; Train through: −1 to +2 in 100".

**Bottom strip (120):**
- Your assistant's note: "Tick over: tiredness 62 drove it".
- **Use the pick**.
- **Withdraw my boxer** (small, on the left).
- The red **Lock the week**.

## Sources (read 2026-11-14)
- [EB Technical and Competition Rules 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf): 6.6.1 Supervisor in charge; 6.6.8 no two bouts in one day; 7.1.3 weigh-in 1 hour before (OFFICIAL).
- [Stevenage ABC, Between the Ropes: weight and amateur boxing](https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing) (undated): "There are no weight classes in Club boxing", 2 kg usual variance, a bout called off on a miss (club practice, not a rule).

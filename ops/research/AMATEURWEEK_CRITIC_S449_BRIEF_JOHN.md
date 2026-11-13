# AMATEURWEEK_CRITIC_S449_BRIEF_JOHN - John answer (seat queue SQ59)

Brief: research/AMATEURWEEK_CRITIC_S449_BRIEF.md
Sent: 2026-11-13 13:40 | collected: 2026-11-13 14:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading AMATEURWEEK1 v3 against the pack and the real numbers from S449. The full critic return follows.

# AMATEURWEEK1 v3 (S449): critic

Depth **6/10**, play **7/10**. Play is defensible to the owner, depth isn't yet.

Short-notice bouts, a later date that buys something, pull-outs and the live ON FIGHT NIGHT box make Continue worth pressing. Depth is held back by three things. The trips never price the coach's absence. "Who pays" moves morale by a point or two on a 0–100 scale. And home against away is decided by a fixed rule rather than a draw.

I couldn't open `camp_plan_v3.png` because your computer is offline, so I judged the map from its text only.

## 1. Logic check

**Against the real rules (S449 research, England Boxing rule book 2026):**
- **The weigh-in is on the day of the bout, 1 hour before boxing starts** (rule 7.1.3). The pack's code weighs in the day before. The map's "Fight night: the weigh-in first" is right, but it has to name this as a change to the code.
- **The rule book has no $300 fee for missing weight.** The map drops it without saying so; it should say so. A miss inside the allowed gap can still be rematched on the night.
- **The allowed gaps are real and printed.** A boxer can be at most one weight category apart from the opponent: 2.5 kg at 57–65 kg and 5 kg at 65–75 kg (rule 2.7.8). Skills bouts allow 2 kg. The map can drop its (J) marks on the gap, and Eat less (up to 1 kg) fits the real 0–1 kg club cut.
- **Pull-outs are 15 in 100 in the map.** At the two shows I found, 25–50% of matched bouts fell through in the final 4–5 days.
- **The trip prices (J) are wrong both ways:**

  | Trip | Map | Real (per week) |
  |---|---|---|
  | City club | $400 | $100–195 commuting, or $670–1,525 staying over |
  | Cottage | $875 | $500–645 off-season, $960–1,040 peak |
  | Seaside | $1,000 | $570–605 off-season, $1,050–1,250 peak |

  A flat price is wrong for both cottages and seaside.
- **Who pays:** club boxers get no stipend and have about $25–75 a week to spare. Real trips are paid by crowdfunding or the club.
- **Sparring in the last week:** the real advice is none in the final week (Buglioni 2016). The map allows 2 nights with no injury or cut risk.

**Against the pack and the code:**
- **The nationals have no "selection line".** The pack's entry is 5 bouts, 3 months registered and age 19–40, with no win share read, and the real rules don't have one either. The price of a loss to a name above rests on a rule that doesn't exist.
- **The ticket cut changes.** The code pays $450 for every bout; the map pays it at home only. That's a code change, so name it.
- **Morale units don't match.** Morale runs 0–100, and a win is +8 or a loss −12. Against that, the map's "mood −1", "+1", "−2" and "−3" are noise, so "who pays" and "pass" have almost no price. "Bond" isn't a number in the pack; loyalty is a trait, and it isn't on the board.
- **Pad nights don't match.** "PadWeek's 3 a boxer a week" plus "both pad places that night" counts per fighter. The agreed PADPOOL1 has 8 club nights shared out. The two maps have to use the same unit.
- **Suspension overlaps the next sheet.** After a stoppage the next sheet comes 28 days later, but the pack's suspension is 30 days. Bouts on that sheet must be dated after the suspension ends.
- **Favours have no starting value**, and passing is punished twice: "two passes and they stop calling for 8 weeks" and "0 favours and they stop for 8 weeks".

**Names and pronouns:**
- These lines describe screen strings that use the assistant's name: "Reid's evenings", "Film takes Reid's whole evening", "Reid takes the other", and the menu wiring ("Reid's purse"). On screen they must read "your coach" or "the assistant".
- "How sure he is" on the coach's pick fixes a he, which breaks S412.
- Screen strings in the "she" voice ("She is inside the gap") need the fighter's own her or him.

## 2. Depth: 6/10

**Choices that hold up:**
- The three bout cards.
- Film costs another boxer that night's pads, and the tell has to be confirmed in round 1. That's the best mechanic here.
- The second week buys a trip.
- A pull-out with one replacement offered.

**Where it breaks:**
- **Home or away is decided by a rule.** Home always draws names below, so the choice comes down to the season's goal: money means home, climbing means away. Draw the opponents instead, with away more likely to bring a name above.
- **Trips are always right.** No trip says who runs the pad nights for the other three while the coach is away, so a trip looks like a free buff. With real prices, commuting is cheap and would be taken every time.
- **Who pays is a lookup.** At ±1 to 3 morale, the club pays whenever it has the cash.
- **The load slider defaults to Tick over.** It is sharp and costs 8 off the tank. Rest up only makes sense for an overreached boxer, and Train through only when the tank doesn't matter. The probe has to show each stop wins somewhere.
- **The weight slider rarely appears.** That's correct with the real allowed gap; leave it.
- **Chore risk is low:** "The coach runs this week" handles the tenth bout in one click.

**Numbers the player sees:** tank, sharp or flat, lines ready, scale, win band, and the result's sizes. Every choice shows up on fight night.

## 3. Play: 7/10

The player waits for a sheet, picks one of three, maybe has a pull-out drama, then fights within 1–2 weeks. That makes Continue worth pressing every week. A later date buying a trip or a finished punch is real.

What stops an 8:
- The season line points at a nationals rule that doesn't exist.
- Favours could easily become noise unless the region screen gives them a job each month.

## 4. Options and menus

| Place | Verdict |
|---|---|
| Fights tab, Find a fight | Right place. Cut the win share against "the nationals line", which doesn't exist. Show the real season line instead: bouts needed for nationals entry and the entry close date. |
| Bout card | Keep ON FIGHT NIGHT before the yes. **Missing:** the weight gap shown as real kilograms ("inside the 2.5 kg gap"). |
| Fight week screen | **Missing:** who coaches the others while the coach is away, a fundraising option under Who pays, and seasonal prices on locations. |
| Week board | Keep. Film by role. Add the trip's lost pad nights by role. |
| Home | Keep, by role. |
| Roster card, "can take a bout in 7 days" | Keep. |
| Tape room, five groups | Keep. |
| Game plan, 90% on a seen tell | Keep. |
| Region favours | Useful only if favours get a start value and one job a month. |
| Continue stops | Keep. Use a real pull-out rate. |
| Corner minute confirm line | Keep. This is the hook. |
| Result sizes | Keep. |
| Money | Ticket cut at home only is a code change. Name it. |

## 5. To reach 10/10 (mechanics, most important first)

1. **Price the coach's absence.** On a trip, either the assistant goes and the other boxers lose those pad nights (shown by role), or you hire cover at $X a night, or the boxer goes alone and gets half the location buff. Without this, trips are free buffs.
2. **Give "who pays" real weight on the 0–100 morale scale.**
   - The club pays: +3 morale and +5 loyalty.
   - Split: 0.
   - The boxer pays and wins: +2. The boxer pays and loses: −6.
   - Add a fourth option that is true to club boxing, a fundraiser: one week's lead, covers up to $600, costs a club evening.
   - Use loyalty, which is a built trait, instead of a new "bond".
3. **Use real, seasonal prices.**
   - City commuting $100–195, or staying over $670–1,525.
   - Cottage $500–645 off-season, $960–1,040 peak.
   - Seaside $570–605 off-season, $1,050–1,250 peak.
   - Food $120 plus $40–60 of extras.
4. **Use the real weigh-in and gaps.** Bout day, 1 hour before boxing starts. The gap is one weight category (2.5 or 5 kg by class). A miss inside the gap can be rematched on the night. Drop the $300.
5. **Raise pull-outs to about 25 in 100 per bout in the final 5 days**, with one replacement offered. Make "take the late replacement" the main way to earn favours.
6. **Draw home and away from the region.** Away gets a name above with about a 2 in 3 chance, home about 1 in 3, so either can climb or pay. The probe sets the odds so neither wins on both money and rank.
7. **Replace the nationals selection line with the real entry rule** (5 bouts, 3 months, age 19–40, entries close week 10). Price a loss to a name above in morale (−12, from the code) and in the next sheet's quality.
8. **Give final-week sparring a price.** Each sparring night carries a 1 in 30 chance of a cut that pulls the boxer out of the bout, as an ESTIMATE until the probe sets it. This matches the real advice against sparring in the final week.
9. **Make each load stop win somewhere.** Rest up clears 20 fatigue (the overreached boxer's pick). Train through counts the week toward the next PROGRESSION pick. The probe shows each stop is best in at least 1 of 4 boxer states.
10. **Fix favours.** Every club starts at 1. Drop the "two passes" rule, so a pass costs only ring rust and a favour after the second.
11. **Use one pad unit across both maps** (PADPOOL1's 8 club nights), and date bouts after any suspension ends.
12. **Apply the names rule.** "Your coach" or "the assistant" in every row, and no fixed he for the coach.

## The 10/10 fight-week screen at 1920×1080

- **Dark top bar (64 px) and rail (96 px):** as they are now.
- **Header, 110 px:** the fighter's name appears once here, beside the comic portrait. Then class, walking weight against the agreed weight, and the gap in kilograms. A versus strip shows the opponent's portrait, record and style word, with the show, home or away, and the date circled.
- **Left column, 560 px: Where.**
  - Four location cards with photos: Home, City (commuting or staying over), Cottage, Seaside.
  - Each card shows its seasonal price, its buffs as numbers, and who coaches the others while it runs. Cottage and Seaside are greyed with a reason when the bout is one week out.
  - Under the cards, Who pays: four buttons (Club, Split, The boxer's savings, Fundraiser), each showing its morale and loyalty effect. The boxer's button is greyed with the amount short.
- **Centre, 700 px: How hard.**
  - Three picture sliders: Load, Sparring nights (each with its cut risk), and Weight (shown only outside the gap).
  - Below them, the shares bar (Technique, Power and Cardio, labelled "applies to the banked part").
  - Then the week strip: seven evenings with magnets for pads, film, sparring and travel. The pad nights other boxers lose are marked by role.
- **Right column, 560 px.**
  - The coach's pick (the coach's face, one line, how sure, "Use coach's pick").
  - The opponent's file: five habit groups, each SEEN, CONFIRMED or UNKNOWN, with "Film tonight: costs one boxer's pads".
  - ON FIGHT NIGHT, a big chalk box: tank 0–100, sharp or flat, lines ready (n of m, with seen tells marked 90%), scale margin, and the win band moving live.
- **Bottom strip, 90 px:** the season line (home and away, $ earned, places climbed, nationals bouts against 5 with the entry close date), plus Confirm the week.

**Bottom line:** price the coach being away, give "who pays" real weight, and switch to the real weigh-in, gaps, prices and pull-out rate. Then this is a 7 on depth I'd defend.

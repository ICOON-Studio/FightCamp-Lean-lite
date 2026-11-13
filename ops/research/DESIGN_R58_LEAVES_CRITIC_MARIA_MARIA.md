# DESIGN_R58_LEAVES_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ76)

Brief: research/DESIGN_R58_LEAVES_CRITIC_MARIA.md
Sent: 2026-11-13 21:10 | collected: 2026-11-13 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I couldn't open `screen_r3.png` from here, so this judges the mechanic from the map, not the drawing.

## Scores

**1. DEPTH: 7/10**
This is a real decision with five coins that cost different things: cash, a split, a team-mate, a booked night with the fighter at stake, and the fighter. Because the approach always offers back the largest cause in that fighter's ledger, it's the bill for your own earlier choices. That ties it to stipends, passing offers, overruled asks, goals, signings and the pro offer, so it interacts with most of the game. The hand model shows no answer above 60% in any cash band, and each answer wins somewhere. The talk as a gamble that can make HALF EACH whole or remove it is a good tension.

What holds it back:
- **Most of the depth arrives at one moment.** The weekly loyalty ticks are small (−3 here, +2 there) and come out of choices the player made for other reasons. The decision really only happens at the approach, roughly once every 12 weeks per fighter.
- **MATCH is the "rich club" answer and close to dominant once cash is plentiful.** At 54% in the rich band it's fine by design, but late in the game, when cash is large, it'll be the answer every time.
- **LET GO rarely wins on its merits.** It wins at 12% in every band at the same rate, which suggests it's acting as the "doesn't care" fallback rather than a real choice. The reason to pick it (a better prospect waiting) is hidden behind a trial that comes after the decision.

**2. GENERAL DESIGN: 7/10**
It's careful, built on code constants, and honest about what's NEW and what's ESTIMATE. It finds and fixes a real defect first (NOVICEFLOW1: a novice can't box after beating the class's last novice), which the whole mechanic depends on. It also cuts what bound nothing: "every offer" promises, verdicts, and history chips.

What holds it back:
- **The approach card is heavy:** 5 columns × 12 rows plus a first-in-line table, a timeline, the talk and today's offer. That's 60+ cells for one decision. A deep-sim player can read it, but it's at the edge of "only actionable information". Rows like "Eastside back?" and "Back to Settled" are forecasts, not choices.
- **Names in the body.** The map's own example breaks the names-in-headers rule throughout: "Danny minds Lucy", "Lucy's share", "YOU STAKE DANNY, 9 MAY", "Lucy would mind: −3 every 4 weeks" on the Money page, and "Let <name> go" on the Overview contract line. All of these must say "your boxer", "the team-mate" or "the stipend holder". The column header "LET DANNY GO" should be "LET GO".
- **Fixed pronouns.** "Bouts open to him: N" breaks the sandbox rule (S412: never a fixed he or she). It should be "Bouts open: N".
- **Dependencies stack up.** It needs NOVICEFLOW1, FOURSTART1, HOMEBOUT1, the four-fighter money, a half-stipend state for any fighter, a stipend lock, and the pro-share rule change. The first two aren't built, so the example week can't be played yet.
- **The C28 change from 10% to 12%** is right to flag, but it changes another agreed map. The owner needs to OK it, not just this map.

**3. PLAY: 6/10**
- **What works:** a dated forecast ("−3 on 27 Apr unless...") gives anticipation, the approach is a dramatic moment, and a fighter who leaves boxes on in your region for the rival. That rematch potential is the strongest hook here.
- **What doesn't:** loyalty mostly rewards not doing things. Don't pass offers, don't overrule asks, don't put two fighters in one class. That reads as avoiding penalties, not chasing a reward. The upside (keeping 25% instead of 12% of a pro purse) is real money, but it lands years later and mostly at turning pro. Week to week, the player feels warnings, not rewards.

## Options: missing, useless, and what each changes

**Missing**
- **Earning loyalty on purpose.** The only actions that raise loyalty are the stipend (+6), asks heard (+2), goals met, wins, turning pro and contract talks. There's no deliberate investment. A "give them the evening off / pick the next drill" kind of action, at a training cost, would make loyalty something you build, not just protect.
- **A loyalty-specific perk at Loyal.** "Minds no day job" and "losses halved" are defensive. Add one thing a Loyal fighter does for the club: for example +1 member a month (word of mouth), or helps a new signing (bond with the newcomer).
- **Answering the rival.** Once a fighter leaves, the rematch is the best payoff, but the map doesn't let you ask for that bout, or mark the rival on your fighters' files. Tie it to Ask for a fight (agreed for amateurs) so a "grudge bout" offer can be requested.
- **Preview before signing a second fighter in the same class.** The −4 "a signing in the same class" should show on the trial invite button, not only after signing.
- **Releasing a fighter well.** LET GO and "Let go yourself" have only costs. A "release with a good word" option (no reputation loss, the fighter won't sign with Eastside) at a cash or reputation price would give LET GO a real use.

**Useless or weak**
- **"Eastside back?" row:** the same answer, "only under 35 again", in three of five columns. Cut it and put the line under the table once.
- **"Back to Settled" row:** a forecast with no action. Fold it into the timeline.
- **The first-in-line table** on the approach card. It's already implied by the causes. Keep it on hover.
- **Say nothing at −1:** it exists only to save the talk. That's fine, but make it the default when the card expires, so it isn't a separate button.

**What each answer changes** (for the owner, plainly)
- **MATCH:** you pay $3,000 over 12 weeks; the fighter's cause stops; training back to full.
- **HALF EACH:** no extra cash; both fighters train slightly less; nobody holds a grievance; the leaver sits just above the danger line.
- **MOVE:** no extra cash; the team-mate takes the grievance and the training loss, and risks a lower pro share.
- **PROMISE: OUR SHOW:** $3,500 now on your own show; the fighter tops it in 28 days; if unfit that night, they leave.
- **LET GO:** the place frees; reputation drops; the fighter boxes for the rival.

## To reach 10/10

**Mechanics, most important first**
1. **Remove names and fixed pronouns from every row, column and button.** "LET DANNY GO" becomes "LET GO", "Danny minds Lucy" becomes "the team-mate minds the stipend holder", "Bouts open to him" becomes "Bouts open", and "Let <name> go" becomes "Let go". This is a ruling, not taste.
2. **Add a positive loyalty action the player chooses each week.** One "show them the club believes" action per fighter per 4 weeks, each with a real price and a loyalty gain: "Put them on the poster" (costs the next show's top billing for someone else, +5), "Let them pick the camp focus" (−10% camp edge, +4), "Take them to a pro show" (−$80, −1 training day, +3). Then loyalty is built, not only defended.
3. **Make Loyal pay the club week to week.** At 70+, a Loyal fighter gives +1 member every 4 weeks (word of mouth) and halves a new signing's "same class" grievance. Show it on Home's SINCE LAST MONDAY.
4. **Give LET GO a real reason.** Show the best scouted prospect's range and trial date on the LET GO column. Add "release with a good word" (pay $500 or −2 reputation, and the fighter doesn't join Eastside) as a second way to let go.
5. **Turn the leaver into a payoff.** A fighter who leaves can be asked for as an opponent ("grudge bout") once Ask for a fight is built for amateurs, with +10 morale for your fighter in camp and double reputation for a win. Show "Eastside ABC: <fighter> (left us)" on the rival file, with the tells already open.
6. **Cap MATCH for rich clubs.** MATCH also costs the stipend holder −3 loyalty ("bought, not earned") when another fighter of near-equal potential holds no stipend, so cash doesn't simply buy out every approach late in the game.
7. **Cut the card to what's chosen.** Keep 6 rows per answer: what you give, cash to the end date, the fighter's loyalty at the end, the team-mate's loyalty at the end, the training change, and the bet with its chance. Move the rest to hover or the timeline.
8. **Preview every loyalty price where the choice is made:** on Pass, on a twist ask, on the stipend buttons, on Invite to a trial, and on Decline pro, as a small "−3 loyalty" chip. The map does this for most; add the trial invite.
9. **Run LOYAL1 before showing any number,** as the map says. Make one extra check: in a rich club after 2 years, MATCH may not exceed 60%.

**My 10/10 page: the approach on the fighter's Overview, 1920×1080**
- **Top bar (dark, as built):** a red APPROACHED flag; the big button reads "NEEDS YOU: the rival's offer, by Sun 12 Apr".
- **Header (portrait card, 120 px):** the fighter's name (the only place it appears), weight class, record, potential, loyalty chip "33, Wavering" with a hover of every move, and "Bouts open: 2".
- **Left column (520 px), WHY THIS CAME:**
  - The three largest causes as sticky notes, each with its total and what stops it, linked to the action ("Day job while the stipend holder has fewer wins: −9. Stops when: the stipend moves or halves").
  - Under them, the rival's offer in one marker line: "Full time: the rival's backers pay the keep."
- **Centre (880 px), THE FIVE ANSWERS:** five columns on cream paper, each topped by its coin in large marker ("YOU PAY $3,000", "YOU SPLIT THE STIPEND", "YOU RISK THE TEAM-MATE", "YOU STAKE THE FIGHTER ON 9 MAY", "YOU LOSE THE FIGHTER").
  - Six rows in each column: cash to the end date, this fighter's loyalty on 29 Jun, the team-mate's loyalty on 29 Jun, training change, the bet and its chance, and what's locked.
  - The talk sits above HALF EACH as a coin-flip chip: "Talk first: about 1 in 2. Lands: the split counts in full. Fails: the split is off the table."
  - One button under each column.
- **Right column (520 px), THE NEXT 12 WEEKS:** a timeline with both fighters' loyalty lines, bouts as gloves, the show night circled, the bills as small tins, and the 50 line marked "Settled".
  - Under it, LET GO's alternative: the best scouted prospect's range and trial date.
  - Under that, the positive actions available this month ("Put on the poster: +5, costs top billing").
- **Footer (60 px):** today's offer as one line ("Offer: a legal novice, Sat 25 Apr, answer by Thu 9 Apr"), Open the offer, and the hover key.

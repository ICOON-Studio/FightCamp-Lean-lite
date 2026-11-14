# DESIGN_TURNPRO1_V1_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ107)

Brief: research/DESIGN_TURNPRO1_V1_CRITIC_MARIA.md
Sent: 2026-11-14 08:41 | collected: 2026-11-14 09:12 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give TURNPRO1 v1 **DEPTH 6, GENERAL DESIGN 5, PLAY 5**, so it doesn't reach the owner's bar yet. The core question, turn pro now or win more amateur bouts first, is real and well priced. General design fails for three reasons: several numbers tagged CODE aren't in the game as the pack describes it, the debut money mixes up the boxer's money with the gym's, and the choice between the two promoters mostly isn't the player's to make.

## Scores

**1. DEPTH: 6/10**
The decision on timing works:
- **Waiting buys** tickets, members, a title line, and +$450 per amateur bout.
- **Waiting costs** the stipend, risk of losses and suspension, and a promoter call that needs more wins after each decline.
- **Signing costs** the gym $1,245 up front. The pro purses pay back only after a few wins.

That matches real small-hall boxing. In the UK, a debut boxer is often paid in the tickets they sell, and a poor seller can fight for almost nothing. That's why many amateurs wait for a national title before turning pro. Preparation also links to the rest of the game: members, the club show, Strength and conditioning, the regional title and the Five-round engine goal.

What holds it back:
- **The promoter pick isn't a pick.** The ticket forecast decides who calls first, and a decline makes the other promoter call at 0.9× terms. The player never compares the two side by side; the second offer is the first one at a worse price after a decline.
- **The ask is shallow.** Later debut and Softer opponent are always taken, so the player always takes whichever one they need. Better split and Own ticket price only work in narrow cases.
- **Your boxer has no say.** The ambition on the signing card, morale and loyalty play no part. In real boxing, the boxer's wish to turn pro, or to chase a national title first, is often what forces the decision.

**2. GENERAL DESIGN: 5/10**
What works:
- No new screen.
- 16 menus wired.
- No person's name outside headers.
- The closed door is honest: each decline shows the next requirement before it's pressed.
- Probes are set out with pass lines.

What fails:
- **CODE tags the pack doesn't confirm (NOT VERIFIED):**
  - "national finalist: a first call at any win count"
  - "each decline raises the need by 2 wins; 3 declines close the door"
  - "+$500 a win, $3,000 top"
  - "60-ticket break-even, 50% past it"
  - "+0.5 tickets a member"
  - "+10 tickets for an amateur title"
  The pack has the call at 7 wins with a top-3 rank or 9 wins, a pro purse of $1,500 unranked plus $400 a place, and the gym's 25%. If these numbers live in ProDebut and StarDeal, the map should give file:line, as PUSHTANK did.
- **The debut ledger mixes two purses.** The $225 past break-even goes to the boxer, not the gym. The gym's sum is 25% of the purse ($375), possibly 25% of the ticket share, minus $1,245. The $250-a-week stipend the gym stops paying is missing, and that's the biggest number in the gym's favour: four weeks to the debut save $1,000. With it, the "−$814" debut is nearly break-even. Its key line, "pays back from about pro win 3", is a guess until this is fixed.
- **Two options do nothing:**
  - Booking the medicals early ($875).
  - Buying the corner licence early ($140).
  Both cost the same as paying at signing. They only move cash earlier and make the debut ledger look smaller, which hides the real cost.
- **The club show seat loss** (−40 seats, about −$1,000) is new, unsourced and harsh. The map already lists it as an open question.
- **Scope words:**
  - "S428: no belts or world bodies" conflicts with the game, which has a pro ladder and belts. The map should say it stops at the debut, not that belts don't exist.
  - "FIGHT WEEK is the amateur's last week" isn't a game term. Fight week is the TAPER week.
- **No ages.** The pack's amateur entry is 19 to 40. Real promoters weigh age heavily, and the map leaves it out entirely.

**3. PLAY: 5/10**
The ticket forecast climbing toward break-even over weeks gives the player something to look forward to, and the first debut that loses money teaches through a real ledger line. But the moment itself is one modal with one ask. The amateur leaving is a "$75 a week" line rather than something felt. And nothing happens between the call and the debut beyond the existing camp.

## Options: missing, useless, and what each changes

**Missing**
- **Your boxer's voice.** The ambition on the signing card ("turn pro" or "win a national title") gives a morale change for Turn pro or Stay amateur. A boxer kept amateur against their ambition loses morale each month.
- **Both promoters at once when the forecast is near break-even,** so the player really chooses.
- **The stipend saved** in the debut ledger.
- **An age line:** a promoter's interest drops after 28 (EXAMPLE).
- **A reopened door** after a national title (the map's open question 4).

**Useless as written**
- **Early medicals and the early corner licence.** Same cost, no benefit.
- **Softer opponent** when Later debut is always taken and gives a camp. One of them will dominate unless the probe says otherwise.

**What each option changes**
- **Turn pro:** stops the stipend, pays $1,245, books a 4-round debut 4 or 6 weeks out, joins the pro table unranked, and ends amateur ticket cuts and the nationals run.
- **Stay amateur:** keeps the stipend and the amateur bouts. The next call needs 2 more wins; after 3 declines the door is closed.
- **Later debut:** +2 weeks and room for a pro camp.
- **Softer opponent:** the opponent rated 0.5 lower, purse −$250.
- **Better split:** +10 points of the ticket share, only when the forecast is 20+ tickets over break-even.
- **Own ticket price:** $40 instead of $50, +15 tickets, Bow Lane only.
- **Top the club show:** +10 ticket followers, at the show's cost and risk.
- **The Five-round engine goal:** removes the round-4 fade at the debut.
- **Strength and conditioning:** halves the pro camp bill.

## To reach 10/10

1. **Prove every CODE number with file:line,** or retag it ESTIMATE: the national-finalist call, the decline rule, the win bonus, break-even, the 50% share, tickets per member, title tickets.
2. **Fix the debut ledger for the gym.** Gym net = 25% of the purse (plus 25% of the ticket share, if the code includes it) + stipend saved to the debut ($250 × weeks) − $1,245. Print the boxer's money on a separate line. Re-run the worked examples and the "pays back from win N" line.
3. **Let the player choose the promoter.** When the forecast is within 15 tickets of break-even, both promoters call in the same week and both offers are shown side by side. Probe pass line 8 stays: the guarantee house is right in 25%+ of first calls.
4. **Give your boxer a say.**
   - Ambition "turn pro": Stay amateur costs −5 morale and the next call adds a further −5.
   - Ambition "national title": Turn pro before a nationals run costs −5 morale.
   - Loyalty reads both (agreed design, not built).
5. **Make the ask a real trade.**
   - Later debut: +2 weeks, purse −$150.
   - Softer opponent: −0.5 rating, and the next two pro offers are TUNE-UP only.
   - Better split: +10 points, and the debut is against a journeyman rated 0.5 higher.
   - Probe pass line 7 (each ask best in 10%+ of offers) decides the numbers.
6. **Cut early medicals and the early licence,** or give them a reason, such as a 2-week shorter debut wait (EXAMPLE).
7. **Add age.** Calls stop after 30 for a first call (EXAMPLE), and the offer shows "Age 27: the promoter's last calls come before 30."
8. **Source or drop the club show seat loss** (CHECK with John).
9. **Make the leaving felt.**
   - For 4 weeks after signing, the week review prints the amateur ticket cut lost against the stipend saved.
   - The fighter's Records page gets the "turned pro" milestone with the promoter.
   - The gym floor shows the +2 crowd for that week.
10. **Fix the scope words.** The map stops at the debut; the existing pro ladder, belts and ageing carry on after it. Replace "FIGHT WEEK" with TAPER.

**My 10/10: the Pro offer page, 1920×1080 (Look B)**
- **Header (120 px):** your boxer's polaroid, the name, weight class, age, amateur record, rank and ambition.
- **Left (640 px), THE OFFERS:** one paper contract per promoter that called. Two side by side when both called. Each shows the purse, the win bonus, the break-even, the share past it, the debut date, and the opponent's rating and file. One ask per contract appears as a red pen note, with "will take it" or "won't: <reason>" showing before you press it.
- **Centre (640 px), THE MONEY:**
  - The ticket bar against each promoter's break-even.
  - The gym's ledger: share, stipend saved, licence and medicals, net.
  - The boxer's purse on its own line.
  - "Pays back from pro win N".
  - Every number explained on hover.
- **Right (640 px), WHAT STAYING MEANS:**
  - The next call's requirement and declines left.
  - The amateur ticket cut and nationals run kept.
  - Your boxer's morale change from their ambition.
  - The age line.
- **Bottom (120 px):** Turn pro with the chosen promoter, and Stay amateur, each with its price written on the button.

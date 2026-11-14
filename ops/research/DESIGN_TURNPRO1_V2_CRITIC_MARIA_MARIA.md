# DESIGN_TURNPRO1_V2_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ114)

Brief: research/DESIGN_TURNPRO1_V2_CRITIC_MARIA.md
Sent: 2026-11-14 10:11 | collected: 2026-11-14 10:42 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give TURNPRO1 v2 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it reaches the owner's bar, just. It fixes v1's main faults: the two money lines are now apart, both promoters can call in the same week, each ask has a price, your boxer has a say, and the two early buys that did nothing are cut. It stays at 6 on general design because the stipend saving it now counts was always available without turning pro, the "costs from the purse" ask doesn't say who pays, and seven numbers still lean on CODE (S463) tags with no file:line.

## Scores

**1. DEPTH: 7/10**
Timing now turns on four real things: whether the gym pays the stipend, age, your boxer's ambition, and tickets. Near break-even the player picks between the two promoters. Each ask costs something, and one has a counter-offer. The three worked cases show three different shapes, and case B says honestly that without a stipend the gym only gets its money back once your boxer is ranked. That matches real small-hall boxing: a debut is an investment, and the payoff comes from the ranked fights, not the four-rounder.

What holds it back:
- **The stipend lever isn't tied to turning pro.** The pack's Pay or Stop the stipend button works at any time, at no cost. A gym can stop it and keep your boxer amateur. So the "+$250 a week after signing" is a saving the player could take anyway. Turning pro only looks better because staying amateur is credited with a cost the player could avoid. Until stopping the stipend costs something, such as morale or loyalty, the timing argument rests on a fake cost.
- **The promoters split the gym and the boxer, but nobody notices.** In case C (Harrow & Finch), the gym ends +$255 by debut day against −$170 for Bow Lane (case A), and the boxer gets $1,350 either way. When the boxer would earn more with Bow Lane, picking Harrow & Finch for the gym's sake should cost morale. As written, the boxer doesn't care which promoter signs.
- **Softer opponent costs too little.** "The next 2 pro offers TUNE-UP only" is barely a price: Harrow & Finch's offers already lean TUNE-UP. It becomes the obvious pick with Harrow & Finch unless probe line 7 shows otherwise.

**2. GENERAL DESIGN: 6/10**
What works:
- Honest tags, split into CODE (pack) and CODE (S463).
- No new screen, 19 menus wired.
- No person's name outside headers, and the news line has no name.
- Fixed pronouns gone.
- "TAPER" and "gym" used correctly.
- The scope now says it stops at the debut and the code's pro ladder carries on.
- "One more amateur bout after signing" is rightly refused: under real rules, a licensed pro can't box amateur.
- The 14-day window that lets a booked amateur bout finish first is a good real-world fit.

What fails:
- **"Costs from the purse" doesn't say who pays.** The promoter takes $1,345 from a $1,800 guaranteed purse, leaving $455. Is the gym's 25% worked out on $1,800 or on $455? Does the boxer's 75% shrink? If the cost comes out of the purse before the split, the boxer pays three quarters of the gym's licence and medicals. That's a real-world practice, but it needs a morale line and its own row on the boxer line.
- **The CODE (S463) numbers are still unconfirmed:**
  - the national-finalist call,
  - +2 wins per decline and the closed door,
  - 0.9× terms,
  - the +$500 win bonus,
  - the 60-ticket break-even,
  - the 50% share,
  - 0.5 tickets a member, 20 family tickets, +2 tickets a win, +10 for a title.
  Every worked case is built on them. If any is wrong, every case changes.
- **"Members from pro wins" is listed as a CHECK, but the pack answers part of it.** The pack says a win adds +8 members, with no amateur-only condition. What needs confirming is only whether the pro fight path calls that rule.
- **The age 32 cut-off is unsourced.** The pack allows amateurs from 19 to 40. The real British Boxing Board of Control licence age rules weren't checked here (NOT VERIFIED). Until John's CHECK lands, keep it ESTIMATE.
- **"Debut loss: the next three offers TUNE-UP only, for one fight"** contradicts itself: three offers for one fight, or three fights?
- **"Gym floor +2 people for the signing week"** is decoration the player can't act on. It's harmless, but it isn't a felt beat.

**3. PLAY: 6/10**
There's now something to look forward to. The forecast line shows the week it crosses each break-even. Side-by-side offers are a real moment. Your boxer's ambition puts a morale cost on each button. And the 4-week leaving line in the week review makes the loss of the amateur cut a sum the player sees. But the debut is still a normal 4-round fight night with one corner note. And the payoff is far off: the gym's money comes back only once your boxer is ranked, so the reward lands months later, with nothing on the way that says it's working.

## Options: missing, useless, and what each changes

**Missing**
- **A cost for stopping the stipend:** a morale drop, with loyalty once built. Without it the stipend saving is fake.
- **The boxer preferring a promoter:** a ticket seller wants Bow Lane, a poor seller wants the guarantee. The wrong pick costs morale.
- **A pays-back marker after the debut:** each pro fight's week review shows "gym debut cost: $X still to recover".
- **A way back after the third decline:** the map's own owner question 3 (a national title).

**Useless or near-dominant**
- **Softer opponent with Harrow & Finch.** It costs almost nothing there.
- **Own ticket price** if the map's own numbers hold: +15 tickets at $40 against 60 at $50 is about −$600 to the promoter. It's real (£40–45 is common), but check it isn't always taken or never taken.

**What each option changes**
- **Turn pro with Bow Lane:** $1,500 purse, 50% of tickets past 60 go to the boxer, a debut 4 weeks out, a journeyman 1.0 under; after the debut, offers lean STEP UP.
- **Turn pro with Harrow & Finch:** $1,800 guaranteed, 30% past 70, a debut 6 weeks out, a journeyman 1.5 under; after the debut, offers lean TUNE-UP.
- **Stay amateur:** +2 wins needed, 0.9× terms next time, morale −5 if your boxer's ambition is to turn pro; the door closes after 3 declines.
- **Later debut:** +2 or +4 weeks, purse −$150 or −$300.
- **Softer opponent:** −0.5 rating, next 2 offers TUNE-UP only.
- **Better split:** +10 share points but a tougher opponent (counter: +5 points).
- **Own ticket price:** $40, +15 tickets, Bow Lane only.
- **Costs from the purse:** nothing paid now, $1,345 taken from the purse (counter: $1,445 when the runway is short).
- **Prep rows:** members, top of the club show, the stipend, Five-round engine, Strength and conditioning, a title.

## To reach 10/10

1. **Tie the stipend to the decision.** Stopping the stipend for an amateur costs morale −5 and a loyalty note once built. The ledger's "+$250 a week" then counts only for gyms that would really keep paying. Re-run cases A and B.
2. **Write out "costs from the purse".** Costs come off the purse before the split, so the gym gets 25% of $455 (+$114) and the boxer 75% of $455 (+$341). The boxer line shows "your boxer pays $1,009 of the costs", with a morale −5 for a boxer with a turn-pro ambition (EXAMPLE numbers).
3. **file:line for every CODE (S463) number,** or retag ESTIMATE, before the worked cases are trusted. Confirm the pro path calls the +8 members rule.
4. **Give the boxer a promoter preference** from forecast tickets: 15+ over break-even, prefers Bow Lane. Picking the other promoter costs morale −3.
5. **Make Softer opponent cost something** with Harrow & Finch: purse −$200 as well, or a debut 2 weeks later.
6. **Run the probes** on three seed sets, with the stipend tied to morale as in item 1. Print the margins.
7. **A pays-back line after the debut:** "Debut cost: $620 still to recover. Next fight's 25%: about $500." It sits in each pro fight's week review until it reaches $0, then lands last as a surprise: "Your debut has paid for itself."
8. **Fix the debut-loss line** to "the next fight's three offers are all TUNE-UP".
9. **Source the age cut-off** (John), or replace it with "promoters' interest halves after 30" (EXAMPLE) so it isn't one hard wall.
10. **The debut fight night:** once the arena work (M38) lands, members in the seats from the real ticket count, and the walkout as the moment.

**My 10/10: the Pro offer page, 1920×1080, Look B**
- **Header (120 px):** the polaroid, the name once, class in kg, age, record, rank, ambition as a sticky note.
- **Left (640 px), THE OFFERS:** one or two paper contracts with purse, break-even, share, debut date and the opponent's file. The one ask is a red pen note showing "will take it", the counter, or "won't" and why. A small "your boxer prefers this one" tag in words, not colour.
- **Centre (640 px), THE MONEY:**
  - The ticket bar against each break-even, with an 8-week forecast line.
  - The gym line: share, costs, the stipend only if it's really being paid.
  - The boxer line, kept apart.
  - The pays-back line, with gold on that line only.
- **Right (640 px), WHAT STAYING MEANS:** next need in wins, declines left, the age line, the amateur cut kept, the morale change from the boxer's ambition and from stopping the stipend.
- **Bottom (120 px):** Turn pro with the chosen promoter, and Stay amateur, each with its price and morale change written on the button.

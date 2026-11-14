# DESIGN_CLUBWEEK1_V5_CRITIC_JOHN_JOHN - John answer (seat queue SQ98)

Brief: research/DESIGN_CLUBWEEK1_V5_CRITIC_JOHN.md
Sent: 2026-11-14 12:11 | collected: 2026-11-14 12:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading CLUBWEEK1 v5 against the pack now. Scores, options, To reach 10/10 and the page come next.

# CLUBWEEK1 v5 (SQ87): critic

Scores: **depth 7/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

The idea is strong: four people share a coach's evenings, and the money lever (sell an evening as a class) pulls straight against the squad. What holds design down are rules that clash with the code, with real training and with each other.

- I couldn't open `CRITIC_ACCESS.md`, the board or the mockups, because your computer is offline, so I judged from the map and the pack.
- Names: the screens pass. One leak sits in the decision table in section 5 ("Ana's open"), so rename it "the grappler's open" before it reaches a label.

## Logic check

**1. The grappler can't draw from the boxing coach's places.**
- The 8 evening places come from your assistant coach (a boxing pads coach) and you (a boxing head coach, all four head-coach cards are boxing). The pack has a separate no-gi coach, paid by the class, and "who teaches" on the grappler's page.
- A boxing coach giving a coached mat place is not something a real gym does.
- Pooling the grappler is also the only reason "8 Need = 8 owned" works. Take the grappler out and the pool is 3 boxers × 2 = 6 Need against 8 owned.
- **Fix:** boxing places only.
  - Ordinary weeks then have 2 places of slack, while Want is 9 against 8, so one is still always short of its third.
  - One fight week fills the pool (8 against 8), and two fight weeks or a class night make someone short.
  - The grappler's classes come from the no-gi coach (code `NoGi.CLASSES_PER_WEEK`). The grappler competes with the boxers for your mornings, a sponsorship and your Saturday corner.
  - The scarcity survives, now with a reason behind it.

**2. Fight week asks for more evenings, but the code and real training ask for less volume.**
- Code `WeekPhase` makes the week before any booked bout TAPER: light, three rest days, no sparring.
- The best-supported taper keeps the number of sessions and cuts volume by 41–60% (Bosquet et al. 2007 meta-analysis, MEASURED). My S449 evidence matches: no sparring in fight week.
- So "+2 Need" (4 evening places in fight week) is double the work just when the boxer should do less.
- **Fix, same scarcity and true to life:** fight-week places are one-to-one.
  - The boxer keeps 2 sessions, the same frequency, each half the volume.
  - Each session takes the coach's whole second hour, which is 2 pool places.
  - Club Need still rises by 2, and the reason printed is "one-to-one in fight week".

**3. Ordinary weeks have zero slack, so every small event makes someone short, and two loops feed themselves.**
- With Need equal to owned, the "Coach off Wed" twist, a class night, a talk, or a film night each makes someone short.
- **The talk loop:** a talk takes one of your evening places, so loyalty under 50 brings a talk, the talk makes someone short, and that costs −3. The talk that's meant to mend loyalty causes a short.
- **The mood loop:** a Low mood fighter auto-passes the bout sheet (loyalty −2). A month without a fight costs −6 morale (CODE), so the fighter stays Low.
- **Fix:**
  - A talk uses no evening place. It costs your Monday attention: one talk a week for the whole club.
  - Low passes the sheet but doesn't pay the month-without-a-fight penalty while Low.

**4. Sponsorship costs don't add up.**
- A block is $1,000 for 4 weeks, which is $250 a week. Section 7 says "1 sponsorship −$100/wk" and MONEYFOUR2 tests against −$100.
- If the $150 gap is the stipend that sponsorship replaces, say so. Two payments to the same amateur (stipend $250 a week in the pack, plus sponsorship) are otherwise undefined.
- **Fix:** sponsorship replaces the stipend for that fighter, and the card shows "$250 a week instead of the $250 stipend: +$0 if the stipend was on, −$250 if off". MONEYFOUR2 then tests both.

**5. The "re-measured" claim isn't delivered.** Section 0 says the Need/Want split was "re-measured in LOYAL1 rerun", but section 8 lists that rerun as still required. Every Need, Want and loyalty number is an unprobed ESTIMATE.

**6. It clashes with the other S459 map for the same week (AMATEURWEEK1 v8).**

| | CLUBWEEK1 v5 | AMATEURWEEK1 v8 |
|---|---|---|
| Weight gap | 1.0 kg | 2.5 kg up to 65 kg, 5 kg above |
| Fight-week pull-outs | 15 in 100 | 35 in 100 |
| Weigh-in | 4 pm on the day | Code: the day before |

- On the weigh-in, the EB rule book (7.1.3) is with v5, but it's a code change, and the map should list it as one.
- On the gap, real club matching sits nearer 2 kg (Stevenage ABC). 1.0 kg will trip the scale far more than real shows do.
- One rule set has to win, and the other map points to it.

**7. What one "place" is isn't defined.**
- The code counts a pad night as 240 drill units over 75 minutes, one fighter. v5 splits the coach's second hour into 2 places, but never says how many units a place carries, so mastery can't be built or probed.
- Also undefined:
  - "0.7 on 4th, 0.5 on 5th" (4th what?).
  - Whether a pad holder counts as short when it gives up its own evening (+3 holding against −3 short).
  - The pro camp's Light, Standard or Hard nights (3, 4 or 5, CODE) against "Peak +1 Need".

**8. Coached mornings are listed as both a choice and not a choice.**
- Section 3.1 says two fighters on a morning share at 0.8 "automatically (not a choice)". Section 5 lists "Solo 1.0 vs 0.8 auto-shared" as a Monday decision.
- As priced, sharing always wins: 6 mornings shared cover 12 at 0.8, which is 9.6, against 6.0 solo.
- Either cut the line, or make solo worth it, for example solo counts as a Hard morning with no tiredness rise.

**9. The weak spot counts the stat twice.**
- The fight already reads all 14 abilities (`Attrs.gd`), so a low stat already costs.
- An extra +0.25 edge per point under, from round 2, charges it twice. WEAKFIND1 only checks one bot against another, not this.
- Also, the weak spot must come from abilities the fight reads. The pack keeps Explosiveness and Recovery "only if the fight really uses them".

**10. Words drift.**
- The same tired-body idea appears as "Legs", "tank", "tiredness" and Stamina.
- "Fighter > Training" should be "Week", the pack's tab name.
- "Fighters > Club week" is a new screen outside the seven approved menus, so it needs the owner's OK before any build (pack section 7).
- Set one word list: tiredness (0–100), tank (fight-night energy), Stamina (ability). Drop Legs.

**11. The guide overloads week 1.** Six dense money lines on the road to pro come before the player has dealt a single week. Show the road strip when the first amateur reaches 5 wins.

**12. Section 4's pro-against-amateur table is "unchanged from v4.1" but not included.** A fresh critic can't check it.

**13. Home and away is still unclear.** The pack gives the $450 ticket cut for every bout, and +8 members only for a win. v5 lists $450 and +8 members under Home only. Say what an away bout gives.

## Scores, with reasons

**Depth 7.**
- Four currencies pull against each other on one board:
  - evening places against class money;
  - sponsorship cash against loyalty and mornings;
  - home fans against away rank and favours;
  - one pro's camp against three amateurs.
- Choices reach past the week through loyalty, fans, season targets and the pro share (25% or 10%).
- Fight weeks give a rhythm: places are short before a bout and freed during Rest after it.
- Short of 8: shared mornings always win, Body-only sparring is nearly dominated, and the Unknown sheet card has no reward.

**General design 5.**
- It's buildable in modules, the probes come first, and the cut rule is the right discipline.
- What keeps it at 5:
  - It pools a boxing coach with BJJ.
  - Fight week asks for more volume against the code's taper.
  - The sponsorship arithmetic doesn't add up.
  - The re-measurement is claimed but not done.
  - It clashes with AMATEURWEEK1 on the gap, pull-outs and weigh-in day.
  - What a place is, is undefined.
- Points 1, 2 and 4 alone would lift it to 6.

**Play 6.**
- Monday has a real squad puzzle, a 5-week reveal, a trial every 4 weeks, and fans that make a debut feel earned.
- Holding pads, where a senior fighter helps a team-mate, is a gym moment players will remember.
- Two things drag it down. The board asks for about 12 decisions a Monday. The talk and Low-mood loops can make the club feel like it's punishing you.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Pick 1 pro of 2, 2 amateurs of 4 | Classes, sparring pairs, fans, ambition | Keep |
| Deal by hand / Keep my changes / Coach deals it | Who sets the week; the printed gap against Coach's deal | Keep. Make "Coach deals it" the one-click default |
| Coach's evening: training or second class | 2 places, or +$117 and about 1 member every 4 weeks | Keep. The best lever in the map |
| Evening places Need/Want | Loyalty and mastery | Keep. Boxers only (point 1) |
| Hold pads (Loyal 70+) | +1 place at 0.7 for a team-mate; the holder +3 loyalty | Keep. Say whether the holder counts as short |
| Coached mornings, solo or shared | Nothing: sharing always wins | **Useless** as priced |
| Sponsorship: give, Renew, Pass on, Let end | Cash, free mornings, no day job, loyalty | Keep. Fix the cost line |
| Pulls: Weak spot, Weapon, Goal, Ahead | Where mornings and places go | Keep. Remove the double count |
| Sparring: Hard / Technical | Gains, tiredness, cut risk | Keep |
| Sparring: Body only | Lower gain, no cut | **Nearly useless.** Make it the only setting allowed with an open cut or within 10 days of a bout |
| Club twist answers | Places, cash, loyalty, favours | Keep |
| Favours: earn and spend | Bout terms, never wins | Keep. Use one regional pool, as I said in AMATEURWEEK1 |
| Talk: give back / promise / tell it straight | Loyalty | Keep. Show the odds of Tell it straight from the visible Coachability, and use no evening place |
| Bout sheet: Home / Name above | Cash and fans against rank and favours | Keep |
| Bout sheet: Unknown | A wider band and an open file | **Useless:** no reward over Name above. Give it a sooner date or a +1 favour |
| Pass a sheet | Holds the name 7 days, −2 loyalty | Keep |
| Scale: Eat less, Train off, Ask a kilo | Tank, tiredness, a favour | Keep. Say who gets the "+2 tank per 0.5 kg" |
| Season target | Bout window, camp length, loyalty | Keep |
| Camp leave | $120 a week, the pro's last 2 weeks | Keep |
| Grappler: White or Blue first, Enter / Skip, Who corners, teaching | Odds, members, $68 a week | Keep |
| Trial: Watch, Sign or Pass | Exact potential for 2 mornings | Keep |

**Missing options:**
- **Cover for one night:** buy 2 places for $80, the twist's price, in any week. Today the only way to buy places is a second coach at $280 a week. It's the natural valve between cash and places.
- **Does a second coach add evening places?** Not stated. The pack says +1 roster place, +40 members and fitness classes.
- **A chosen rest week:** a "Rest this week" switch for a fighter (0 Need, +4 morale), not only after a bout.
- **Let a fighter go:** "1 leaves" for the 5th fighter has no button or price.
- **The stipend on the Club week:** Pay or Stop, beside sponsorship (point 4).

## To reach 10/10

1. **Boxing places only.**
   - 3 boxers × Need 2 = 6 of 8 owned; Want 9.
   - The grappler's classes come from the no-gi coach (per class, CODE), and its Need shows in its own counter.
   - Re-run LOYAL1 and SHORTWEEK1 on this pool and paste the tables into the map.
2. **Fight-week places are one-to-one.**
   - The boxer gets 2 sessions at half volume (TAPER, Bosquet 41–60%).
   - Each session takes a whole coach second hour (2 places), and the counter prints the reason.
   - No sparring in fight week.
3. **Define a place in code units.** One place is 120 drill units (half of `PAD_NIGHT_MINUTES` 240). A one-to-one fight-week place is 120 units at no sharing. Replace "0.7 on 4th, 0.5 on 5th" with a stated rule.
4. **Sponsorship replaces the stipend.** The card prints both lines, and MONEYFOUR2 tests with the stipend on and off.
5. **Break the loops.**
   - A talk costs no evening place (one talk a week for the club).
   - Low mood stops the month-without-a-fight penalty.
   - A holder isn't counted short while holding.
6. **One rule set shared with AMATEURWEEK1:**
   - weigh-in on the day, 1 hour before (EB 7.1.3), listed as a code change from the day before;
   - agreed weight ± 2 kg at club shows;
   - one pull-out rate, probed.
7. **Mornings:** cut "solo or shared", or make solo a Hard morning with no tiredness cost, and probe it.
8. **Weak spot:** drop the +0.25 per point edge, since the fight already reads the stat. Keep it as a pull that names which opponent style finds it. Use only the abilities the fight reads.
9. **Unknown card:** sooner date (7 days instead of 12), plus 1 favour.
10. **Add four options:** cover a night ($80, 2 places), a chosen rest week, let a fighter go (−1 week's stipend, −5 loyalty to the others), and the stipend switch.
11. **One word list:** tiredness, tank, Stamina. Drop Legs. Rename "Training" to "Week". Get the owner's OK on the Club week tab.
12. **Home and away printed on the sheet:**
    - Both pay $450.
    - Home: +8 members on a win, +4 fans.
    - Away: −$40, +1 favour, rank up to 3 places.
13. **Put the pro-against-amateur table back in, and move the road strip to 5 amateur wins.**

## The 1920×1080 page (Look B: Fighters > Club week)

**Shell:** a dark top bar (CONTINUE reads "to Mon 19 Jan, deal the week") and the left rail with Fighters lit, around a tan plaster wall with a whiteboard 1640×960.

**Counter strip (100) across the top, chalk numbers:**
- BOXING PLACES: Need 6 · Asked 9 · Owned 8 · Short 0.
- MAT CLASSES: 3 of 3 (no-gi coach).
- MORNINGS: 6 coached.
- SPONSORSHIP: 1 of 1, ends in 2 weeks.
- CASH: runway 14 weeks.
- FAVOURS: 2 magnets of 3.

**Left (300), the coach's evenings:**
- Three evening magnets (Tue, Wed, Thu). Each flips between "Pads: 2 places" and "Class: +$117".
- Your own evening magnet below.
- A "Cover a night: $80" sticky.

**Centre (980), four fighter rows of 200 each:**
- The header holds the name (the only place a name appears), the badge, the mood word and the loyalty bar with its last move.
- Seven day cells. Evening cells are red pad magnets, and a fight week shows a one-to-one magnet twice as wide.
- The pull chip with its range, e.g. "Speed to Fast hands: about 4 weeks".
- The sparring pair and setting magnet.
- The row's Need/Want ticks.
- The grappler's row shows mat classes in green, from its own coach.

**Right (360):**
- The club twist card with its two priced answers.
- The talk card ("Wants a word", three answers, with the odds for Tell it straight).
- PROMISES OPEN.
- The bout sheet card, if one is open.

**Bottom strip (110):**
- "Coach's deal: 2 to 3 in 100 below yours" in marker, with the top 3 levers.
- **Coach deals it** (the default), **Keep my changes**, then the red **Start week**.

## Sources (read 2026-11-14)
- [Bosquet et al. 2007, Effects of tapering on performance: a meta-analysis](https://pubmed.ncbi.nlm.nih.gov/17762369/), Med Sci Sports Exerc 39(8). A 2-week taper with volume cut 41–60%, keeping intensity and frequency (MEASURED, 27 studies).
- [EB Technical and Competition Rules 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf): 7.1.3, weigh-in 1 hour before boxing (OFFICIAL).
- [Stevenage ABC, weight and amateur boxing](https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing) (undated): no weight classes in club boxing, about 2 kg usual allowance (club practice).

# AMATEURWEEK_CRITIC_S449_BRIEF_KALLI - Kalli answer (seat queue SQ58)

Brief: research/AMATEURWEEK_CRITIC_S449_BRIEF.md
Sent: 2026-11-13 12:40 | collected: 2026-11-13 13:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring the AMATEUR FIGHT WEEK map on this brief only. The critic will follow as text in parts.

Part 1 of 3

# AMATEURWEEK1 v3, the amateur fight week: critic (S449, Kalli)

Judged on this brief only. I couldn't find `docs/mockups/s449/camp_v3/camp_plan_v3.png` on my computer. The Miro board, the real screens on E: and the files the map cites weren't opened either. The look is judged from the map's description.

**Verdict:** Depth 6/10, Play 7/10.

**What works:**
- Home or away is a real trade between money and climbing.
- A later date buys something you can see.
- Everything lands on one box before the yes.
- Film gets a target, and a tell is only confirmed in the fight.

**What stops it at 7:**
- Favours have no starting value, so the climb can be locked from day 0.
- The mood prices are too small to feel.
- The club paying is nearly always right.
- The map changes several built rules without saying it replaces them: the ticket cut, members per win, TAPER, one offer at a time, nationals entry and the stoppage layoff.

## 1. Logic check

**1. Favours start nowhere.** "At 0, a club stops offering its ranked names for 8 weeks." No starting count is given. If every club starts at 0, away shows offer no ranked names, so section 3's climb never opens until the player has taken late replacements. Earning a favour depends on a pull-out happening at that club (15 in 100) or a kilo ask arriving. Asking for a kilo can drop a club to 0 and close the climb there.

**2. The 28-day sheet clashes with the 30-day suspension.** Code: a stoppage loss means 30 days suspended, with no offers while out. The map sends the next sheet at 28 days after a stoppage. That sheet comes while the fighter can't box, so every card on it is dead for 2 days.

**3. "9 to 11 bouts a year" doesn't follow from the gaps.** A 21-day gap allows up to 17 a year. Either something else limits it (passes, a sheet only on show weeks, fortnightly shows) and the map should say what, or the money line (36 bouts for four boxers) is wrong.

**4. The ticket cut and members per win already exist for every bout.** Code: "a bout adds a $450 ticket cut", and any win adds +8 members and +5 reputation. The map makes both home-only. That can be the right design, but it takes income away from the game as built. The money and members balance (break-even, runway) must be checked again, and the pack must change.

**5. What is a "home show"?** In code, the club hosting its own show costs $3,500, can lose money and comes every 16 weeks (HOSTSHOW1 is named later). A home show every other Saturday that keeps the ticket cut and costs nothing isn't that show. Define it, for example a show in your own town run by the local board, or tie it to hosting.

**6. Home judging.** "Close rounds lean your way 6 in 10" adds a home-judging bias to amateur scoring that the code doesn't have. Real amateur judging is meant to be neutral. CHECK (John): whether there is a measurable home effect in amateur boxing. If there isn't, this line is invented.

**7. Rank before the table.** Code: a fighter enters the regional table at 4 wins. Before that there is no "place" to climb or lose, so for a novice the card's RANK line and the whole home or away trade are empty. Code also says a losing record is never top 10, and that beating someone below moves nothing. "A loss to a name below drops two places" is a new rule and should be listed as one.

**8. The nationals line is new.** Code: entry needs 5 bouts, 3 months registered, age 19-40, and entries close in week 10. There is no win-share selection. The map's "season win share against the nationals line" replaces a built rule. CHECK (John): the real selection for the National Amateur Championships.

**9. One offer at a time and lead times.** Code gives one offer per fighter at a time, with 8 to 12 weeks' lead at clubs. Three cards per fighter, 1 to 2 weeks out, replaces both. That's fine as a new BoutSheet, but the Fights rail page keeps its offers in code. With two places to take a bout, the "one home per job" rule breaks. Say whether the Fights page becomes a list that opens each fighter's tab.

**10. TAPER in code.** The fight week is light in code, with three rest days and no sparring. The map allows 2 sparring nights and Train through in the same week. Section 11 clears the camp rules, but not TAPER. Say that the amateur fight week replaces TAPER.

**11. Pad nights: there's nothing to share.** Section 9 says each boxer gets 3 pad nights a week (`PadWeek.USUAL_PADS`), yet section 1 calls the coach's evenings "the shared money" and the film "takes both places". If every boxer has 3 of their own, film costs that boxer's night, not another boxer's. The "by role, which boxer goes to the bag" line only means something with a pool across the club. Pick one rule. The pack says two fighters sharing the coach's pad nights is AGREED, NOT BUILT.

**12. Mood steps are on the wrong scale.** Morale is stored 0-100, with a win at +8, a loss at -12 and a rest week at +4. The map's mood -1 (pass), +1 (club pays), -2 (paid herself and lost) and -3 (go home) are a twelfth of a loss, and no player will see them. "Bond" isn't a stat in the game (it has morale and a hidden loyalty). That's a second word for one concept.

**13. Weight: walking weight against the class limits.** Code has class limits and a weigh-in the day before, and a miss costs the club $300. The map matches at walking weight in a gap and drops the $300. It doesn't say whether the regional table stays per class, or what the fighter's page shows against the limit. CHECK (John): club-show matching gaps and same-day weigh-ins.

**14. Free facts: away only, or any show?** The table gives free facts at away shows. Section 5 gives them "from shows you are on". Pick one; it changes the home or away trade.

**15. The five habit groups against the code's file.** The code's file opens weapon, habits and weakness, with "an opponent with no bouts has no tape". The map doesn't map its five groups onto those, and doesn't say what film does against a debutant.

**16. Lines at 90% and 80%.** Code: a planned line fires every time once usable (FireLevel off). "Ready or 80%" and "90% in round 1 on a SEEN tell" need FireLevel switched on, or a new rule. Say which.

**17. A named coach in the rules.** "Reid's evenings", "Reid takes the other" and "his calls are right about 6 times in 10" assume Luke Reid is hired. A club with Marcus Hale or no assistant has no rule. Write it as "your assistant", and size the second corner from that coach's rating.

**18. Names and fixed pronouns outside headers (owner S448, SANDBOX S412):**
- "Reid" in the board line, the second-corner line and the money purse. These are rows, so the role must be used.
- The coach's note: "how sure he is". That's a fixed he for every coach.
- The map's rows read "her place", "she walks outside the gap", "her savings", "paying herself". On screen these must be her / him by the fighter's own, or no pronoun.
- Section 10 is clean otherwise ("by role").

Part 2 of 3

## 2. Depth: 6/10

I went through each choice for four fighters over a 36-bout season.

**Which bout (three cards):** a real choice once the fighter is ranked. Money, members and home judging pull against the climb and the free facts, and the season line shows the cost. Below 4 wins it's a lookup: home always wins, because there's no place to climb (logic 7).

**Home or away:** the best pick in the map, if favours start above 0 and away keeps the climb.

**Date, one or two weeks:** real. Two weeks opens the cottage and seaside, and a full tank. But "a finished punch" has no rule. Nothing says how many pad units a second week adds, or whether a move crosses Usable in time.

**Load:** close to a lookup.
- Rest up is FLAT in round 1, and flat is the price the map uses for its harshest penalties. It's only right when tiredness is already well over 50.
- Tick over (8 off, sharp, half banked) against Train through (12 off, sharp, a full week) is the only live pair. Whether it's live depends on the probe's tank price.

  Today the map can't say whether 4 tank points are worth half a week's gains.

**Sparring 0 / 1 / 2:** real. Plan tests against tiredness.

**Where to train:** can't be judged. The cottage and seaside "buffs as in the camp plan" aren't stated here, and neither is the city club's $400 against what +1 plan test and Fight IQ x1.3 are worth in wins.

**Film group:** real, and the best new decision. Five groups, one evening, and the confirm read in round 1.

**Who pays:** a lookup. The club pays whenever there's cash. Half each is dominated (no mood gain, still pays). The boxer paying has no upside, only a -2 risk. It's only right when the club is broke.

**Weight:** mostly hidden (inside the gap). When it does show, Eat less costs at most 1 kg at 1 tank point per 0.1 kg. That's a real choice against Train it off.

**Pass:** -1 mood is invisible (logic 12). Ring rust at 6 weeks is the only real cost, and the next sheet comes in 7 days anyway.

**Ask for a kilo:** the opponent's +5 tank against a favour. Real, if favours are sized.

**Chore check by the tenth bout:**
- Four fighters means about 12 bout cards a month plus four week screens.
- "The coach runs this week" saves the week screen.
- Nothing saves the bout pick: there's no "coach picks the bout" option, so the sheet is a weekly chore for four fighters.
- The pull-out stops (15 in 100) add one stop roughly every other week across the club.

**Does fight night change in numbers you see?**

| Choice | Fight night | Seen before the yes |
|---|---|---|
| Load | tank, sharp or flat | Yes |
| Sparring | lines ready, tiredness | Yes |
| Film | SEEN line 90%, confirm at round 1 | Yes |
| Location | Fight IQ, injury, plan tests | Only if the camp plan's buffs are numbers |
| Home or away | judging 6 in 10, money | Judging no; money yes |
| Weight | tank | Yes |
| Who pays | mood (too small) | No |
| Favour (kilo) | opponent tank +5 | Yes |

## 3. Play: 7/10

**It makes me press Continue:**
- A sheet every three weeks, with three bouts that pull different ways.
- The season line ("home 5, away 3: $2,250, 2 places").
- The round-1 confirm call.
- The result page counting what each choice cost ("Legs: 14 off the tank, round 3 lost").
- Pull-outs with a choice.

The later date now buys a trip or a full tank: yes, that's real.

**What holds it at 7:**
- The novice months (0 to 4 wins) have no climb, so the first hour's bouts are all "home".
- The favour economy can block the climb.
- Who pays doesn't hurt.
- Nothing grows over the season. The fifteenth week screen offers the same four places and sliders as the first.
- There's no reason to visit a club twice except favours, which only reach 3.

## 4. Options

**Missing:**
- **A starting favour count** per club (1), and favours shown on the bout card, not only in the region list.
- **"Coach picks the bout"** beside "Coach runs this week", with the coach's reason.
- **A rule for the second week's "finished punch":** pad units added and which move crosses which line.
- **The rule for an unranked novice** on the card (the climb hidden until 4 wins, or a "wins to the table" line).
- **Who runs the second corner** with no assistant, and the rate tied to the coach's rating.
- **Film against a debutant** (no tape: greyed with a reason).
- **The suspension's link to the sheet** (sheet date = suspension end).

**Useless as written:**
- Half each.
- Mood -1 for a pass.
- Mood +1 when the club pays.
- "Bond".
- The weight slider for a fighter inside the gap. It's hidden, which is correct; keep it hidden.

**The menus:**

| Menu | Right place? | Found? | Can't act on or wrong |
|---|---|---|---|
| Fighter page, Fights tab | Yes | Yes | Duplicates the Fights rail page's offers (logic 9); RANK line empty below 4 wins |
| Bout card | Yes | Yes | Home judging line (CHECK John); favours not shown |
| Fight week screen | Yes | From the card | Who pays mostly fixed; locations' buffs not stated |
| Week board | Yes | Yes | The "by role" bag line needs a shared pad pool (logic 11) |
| Home | Yes | Yes | Nothing |
| Roster card | Yes | Yes | "can take a bout in 7 days" needs the suspension rule |
| Tape room | Yes | Yes | Debutant case missing |
| Playbook, Game plan | Yes | Yes | 80% / 90% needs FireLevel or a new rule (logic 16) |
| Region, favours | Wrong place alone | Hard | Belongs on the bout card too |
| Continue | Yes | Yes | Nothing |
| Fight night, two shows | Yes | Yes | "Reid" in the line; no rule without an assistant |
| Corner minute, confirm | Yes | Yes | Nothing |
| Result | Yes | Yes | Nothing |
| Money | Yes | Yes | The away van $40 isn't shown on the bout card |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Write the favour economy so it can't lock the climb.**
   - Every club starts at 1 favour.
   - A favour comes back +1 every 12 weeks with no ask, up to 1.
   - At 0 the club still offers ranked names, but only on away cards, and never a kilo.
   - Show the favour count on each bout card.
2. **Size mood on the real scale.**
   - Pass: -3.
   - Club pays for a trip: +3.
   - The boxer pays and wins: +4, and loyalty up (the existing hidden trait, not "bond").
   - The boxer pays and loses: -5.
   - Go home after a pull-out: -6.
   - Half each: +1 and half the cost.

   Now each payer has a case: the club pays when cash allows, half each when cash is tight and mood matters, and the boxer pays to build loyalty and take the risk.
3. **Settle the ticket cut, members and home shows.** A "home show" is a show in your own town run by the region (no cost to the club), keeping the code's $450 cut. An away win keeps +8 members and +5 reputation at half (+4 / +3). Re-run the money and break-even with BudgetProbe before freezing it.
4. **Tie the sheet to the suspension.** The next sheet comes the day the suspension ends, or 21 days after a points bout. Fix the yearly count from that rule, or cap it at 11 bouts and state the cap.
5. **A novice road below the table.** Under 4 wins, the bout card shows "wins to the table: n" instead of RANK. Away novices give free facts and +1 favour, home novices give money, so the trade lives from bout 1.
6. **Replace the code rules, listed by name.**
   - TAPER becomes the amateur fight week for amateur bouts.
   - One offer at a time becomes three cards.
   - Nationals entry keeps 5 bouts and 3 months, and adds win share only if John confirms a real selection (CHECK John), otherwise drop it.
   - The $300 miss fee stays at walking weight.
   - The Fights rail page lists each fighter's sheet and opens their tab.
7. **Set the pad-night rule.** Either each boxer keeps their 3 (film costs their own night, and the bag line goes), or the club has a pool of the assistant's nights (pads plus film), shown on the week board by role. Not both.
8. **Price the load stops so all three are live.** Rest up: full tank, FLAT, a fifth banked. Tick over: 6 off, sharp, half. Train through: 12 off, sharp, a full week, and +1 tiredness carried into the next week. The probe must show Rest up winning when tiredness is 60+, and Train through winning when the bout is a clear mismatch.
9. **State every location's numbers here,** not "as in the camp plan": each buff as a multiplier on a stat the fight reads, its cost, and its injury factor. Under the probe target, no location is worth more than 4 wins in 100.
10. **Make the second week's punch a rule.** A two-week bout adds 2 pad nights. If a move on the cards would cross Usable or Sharp in that time, the bout card shows "two weeks: Uppercut Usable". That's the only "finished punch" line.
11. **Add "Coach picks the bout".** The coach takes the card that matches the fighter's goal (climb, money, rest) and says why. The clock still stops for a red need.
12. **Make the second corner a role.** It's your assistant, right on calls at 0.5 + rating/200 (Reid 58 gives about 0.79, Hale 74 about 0.87). With no assistant, a member works the corner: calls are right 1 in 2 and no ONE CHANGE.
13. **Film rules.**
    - A debutant has no tape (film greyed with the reason).
    - The five groups map onto the code's file as entries and range = weapon; pressure and defence = habits; pace = weakness.
    - Free facts come at away shows only.
14. **Remove the home-judging edge** unless John finds a real measured effect. If he does, size it from his source.
15. **Probe order:** the tank price and FLAT first, then BudgetProbe on the new money, the favour lock test (can a new club reach a ranked away name inside 8 weeks), and the season count of bouts.

These need things the game can't do yet: FireLevel on (the 80% / 90% lines), the shared pad pool, savings on the boxer, the CampPlace buffs, and the corner's confirm read.

### The 10/10 fight-week screen at 1920×1080

The shell stays: dark top bar, left rail. The content is the WarmKit whiteboard. The fighter's name appears once, in the header.

- **Header** (full width, about 110 px): comic portrait, name, class, record, the walking weight against the gap, READY / RESTING, and the bout: the opponent's portrait, show, home or away, date, days to the bell, and the favour count with that club.
- **Where to train** (left, about 560 x 520 px): four location cards as polaroids. Each shows its cost, the multipliers it gives on fight night, its injury factor, and why it's locked when it is ("needs a bout two weeks out"). One is ringed.
- **How hard** (centre, about 760 x 520 px): three sliders with picture stops, for load, sparring and weight (weight only when outside the gap). Under each stop, what it does on fight night in numbers. Below them, the Technique / Power / Cardio shares with the banked part written ("Tick over: half banked").
- **ON FIGHT NIGHT** (right, about 560 x 700 px, the one gold frame): the tank at the first bell (bar), sharp or flat, lines ready with each line's per cent, the scale margin, the win band. Each row shows its change from the coach's default week. It moves live.
- **Film and the file** (left, under the locations, about 560 x 300 px): the five habit groups as SEEN / CONFIRMED / UNKNOWN, a Film button for one group (it shows which night it takes), and the free facts waiting at an away show.
- **Who pays and the coach's pick** (centre, under the sliders, about 760 x 300 px): Club / Half each / Boxer, each with its cash and mood numbers, and Boxer greyed with "can't afford it". Next to it, the coach's note with the role, a one-line reason, how sure, and Use coach's pick.
- **Season strip** (full width, bottom, about 120 px): home and away so far, money earned, places climbed, wins to the table or to the nationals entry, the next sheet's date, and Continue's next stop.

There's no score or best-week badge. Hovering any number shows its rule.

CHECK (Claude): `PadWeek.USUAL_PADS` per boxer or per club; whether TAPER runs for amateur bouts today; the sheet date against the 30-day suspension.
CHECK (John): club-show matching gaps and same-day weigh-ins (SQ57); amateur home-judging effect; how the National Amateur Championships select; real trip and camp costs.

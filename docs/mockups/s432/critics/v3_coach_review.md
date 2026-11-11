# CLUBWEEK v3: review by a club head coach and secretary (fresh, blind critic, S432)

Reviewer seat: head coach and club secretary of an English amateur boxing club, 25 years, boxers taken from first bout to a professional licence.
Read: CRITIC_PACK.md, CRITIC_ACCESS.md, CLUBWEEK_MAP_V3_S431.md (whole), the three drawings (clubweek_v3, fightweek_v3, road_v3).
Code checked: `scripts/rules/ProDebut.gd` (debut tickets = 20 family + half a ticket per club member + 2 per amateur win + 10 per title),
`scripts/rules/Matchmaking.gd` (a professional's fans start at 0 and sell their tickets), `scripts/rules/Aftermath.gd` (toll 45 on a full tank, as the map says),
`scripts/rules/AmateurBooking.gd` (novice 0-10 bouts meets only novices), `scripts/rules/FighterProfile.gd` and `Recruit.gd` (a loyalty trait exists: "stays through a bad run").

## 1. Depth: 7 out of 10

The week is now a real club week: one coach, too few pad places, boxers with jobs, a show sheet on Monday and a scale on Saturday, and every choice
takes something from a team-mate. What stops it at 7: going short costs only a little mood, a home crowd built as an amateur never reaches the
professional's ticket money, the season has no target the weeks are built toward, and not one price on the board has been measured.

### What is right, from the gym floor
- **Scarcity that is true.** One assistant, three evenings, two pads each, and the head coach holding pads too: that is my Tuesday night. Asked 11, covered 9 is right.
  "A fourth pad place pays 0.7" is right. Boxers losing a coached morning to shift work is the most real thing in the map.
- **The bout sheet.** A home card that pays the club, a name above that climbs, an unknown with a wide band: that is how a matchmaker's phone call feels.
  The rule that no card wins on every line keeps it a choice.
- **Walking weight with a gap on the day.** Correct for club shows. Nobody cuts to a class limit for a skills bout at York Hall.
- **Favours.** A secretary's real currency. Earned by filling another club's card, spent on a kilo or a named opponent, and they never buy a win. Good.
- **The other corner has a week.** Their tank, the "?" when you have not shared a card, a corner that has seen your one-two: that is how rival coaches talk.
- **Pull-outs with three answers, and the 4-day call.** 15 in 100 is honest. Fifteen bouts a season fall through.
- **Coach's week against yours, two win chances on the bill.** This is the right way to show what the player's work is worth.
- **The road strip side by side (amateur and professional).** The clearest page of the three. A new player learns the whole ladder from it.

### Where the depth is thin
1. **Going short has no lasting cost.** Mood -3, -2, -6 and it recovers. In a real club, the boxer who goes short three weeks running says nothing and then trains
   at another gym. Without that, the best play is to starve whoever is not boxing soon, every week, with no long-term bill. The scarcity bites in the week and is
   forgiven by the month.
2. **Home or away never reaches the professional career.** The code already sells debut tickets from club members and amateur wins, and a professional's fans start at 0.
   So 30 home bouts and 30 away bouts give the same professional. In real small-hall boxing the boxer's own crowd pays for the debut. The biggest long-term decision an
   amateur coach makes (where to box) is cut off from its biggest payoff.
3. **No season.** The map keeps the nationals "as today" and leaves out the season's prize. A real coach plans the year around one or two championships (entries close,
   a run of bouts close together, then rest). Without a target, every Monday is solved again from zero, and the sheet, the BUILDING switch and the seat have no
   date to aim at.
4. **Nothing is measured.** Every price is a guess. The map knows it (section 7), but a 4 to 6 in 100 gain from a perfect week is near the noise a player can feel per bout.
   The payoff has to show over a season (offer reached weeks earlier), not only per bout.
5. **Day-one load.** Pad places, coached mornings, seats, favours, the tank, mood, tiredness, mastery, plan lines, the rota, the twist: eleven things to read in week 1.
   The map turns the twist and trial off until week 3; it needs a full reveal order.
6. **The table tells the answer.** Section 5's "each option is right when" column is good design discipline, but if the guide or the hover prints those thresholds the game
   plays itself. Keep it as the designer's test, never as screen text.

## 2. Options

### Missing options
- **Sparring intensity** (technical, hard, body only): the biggest weekly call a real coach makes. Hard sparring builds more and cuts more; the map has who spars, not how hard.
- **A one-to-one talk** with a fighter, paid with one of your own pad places: the coach's real tool when a boxer goes short.
- **A season target per fighter** (the nationals, the professional offer road, the rank road) that sets the BUILDING date and colours the pulls.
- **Sell tickets** for the professional's night (an evening, or a club mate's evening): small-hall professionals live on it.
- **Ana teaches the members' no-gi class** (club money and members, against Ana's own classes): makes Ana's row a money decision, not only a training row.
- **Enter the nationals from the Club week board**, with its run of fight weeks priced in pad places (entering takes the boxer off sheets for weeks).
- **Rest a fighter for two weeks after a hard night** (a break with a mood and tank gain): real clubs send a boxer home after a war.

### Useless or weak options
- **Overtime: yes or no.** One line of thought (bout inside 14 days or not); the threshold answers it every time. Fold it into the twist deck as a priced card.
- **Same as last week.** The rota moves and the twist lands every week, so the result is red most Mondays. Keep "Coach deals it" and "by hand" only, or rename it "keep my changes".
- **Coach's three extra evenings a quarter.** A fourth resource with a tiny effect. Make them twist answers ("Coach stays late: +2 pad places, $60").
- **Watch a morning** (closes a trial fighter's ranges): it only matters 2 weeks in 4; put it on the trial mat card, not on every morning slot.
- **Two separate kilo requests** (you ask, they ask): one rule, "a kilo for a favour", both ways.
- **Coach's score "3 right, 1 wrong"** is information, not an option; keep it as hover text on "Coach deals it".

## 3. New mechanics (only ones that deepen this scope)

| Mechanic | What the player decides | What it changes | Real-world basis | Needed for this version |
|---|---|---|---|---|
| Standing with you (loyalty) | Whom to short, when to talk, what to promise | Standing 0-100 per fighter, fed by going short, goals, promises, the seat, holding pads; under 40 the fighter asks to talk; under 25 and talked to twice, the fighter leaves (to Eastside ABC, already named). The loyalty trait slows it | Boxers move clubs when they feel second in line; it is the commonest way a club loses a good amateur | Yes (minimal: talk and leave; the rival's approach waits for the living world) |
| Following (the boxer's own crowd) | Home or away on each sheet; club events; ticket-selling evenings for the professional | Local fans per boxer; home wins add most; carried into the professional's fans on turning pro; sells the debut tickets (ProDebut) and later ticket money (Matchmaking) | UK small-hall professionals are paid from the tickets their own supporters buy; amateurs build that crowd at home shows | Yes |
| The season target | One target per fighter per season: the nationals, the professional offer road, the rank road | Sets the BUILDING date, the pull Coach favours, and a season goal (morale and standing); the nationals become a run of fight weeks on the board | Coaches plan the year around entry dates for championships | Yes (uses the nationals that already exist) |
| Sparring intensity | Technical, hard, or body only, per sparring evening | Gain multiplier, tiredness, cut risk, the "sparring cut" line on the bill | The hardest call in a real gym: hard sparring wins camps and loses boxers | Yes (small: three settings on an existing slot) |
| Ana teaches the members' class | Teach or train | Club money and no-gi members against Ana's class count | Fighters coaching the members' classes is how most clubs pay them | No (good, small, after the core) |

## 4. To reach 10 out of 10 (most important first)

1. **Standing with you.** Add a per-fighter Standing 0-100 (start from the loyalty trait). Prices: went short a week -3; two weeks running -6; promise kept +5, broken -12; seat given +5; goal met +6;
   holding pads +3 a week to week 4. Under 40: a "wants a word" card on Club week (give the pad place back, a dated promise, tell it straight, priced by coachability). Under 25 after two talks: the fighter leaves at
   the next Monday. Show it on the Club week row, the fighter page Overview, the Monday review ("who went short") and the Roster card flag. Probe STANDING1: Coach's deal never drives anyone under 40 in a season; a bot that always starves the
   fighter without a bout loses one fighter a season.
2. **Following.** Each boxer gets local fans: home win +8, home loss +2, away win +2, club event +1; turning professional carries them into Matchmaking `fans` and feeds `ProDebut.tickets_sold` (replace the flat member share with
   the boxer's own fans plus a smaller club share). Print "+8 fans" on the home card of the bout sheet, the fan count on the road strip, the ticket forecast on the Pro offer screen, and "48 sold of 100, pays from 60" on the professional's row with a
   "Sell tickets: an evening, +6" pull. Probe FOLLOW1: an always-away amateur reaches the offer sooner but sells under 60 at the debut; a mixed one does both.
3. **The season target.** At week 1 and after each championship, each fighter gets one target: the nationals (no sheets from the entry date; the rounds as back-to-back fight weeks on the board), the professional offer road, or the rank road.
   Draw a season strip on top of Club week with every fighter's dates. The target sets which pull Coach prefers and gives a season goal (met: standing +10).
4. **Measure, then cut.** Run TANKPRICE1, SHORTWEEK1, WEAKFIND1, SHEETDEAL1, MONEYFOUR2 before any screen, and add one season probe: a careful player against Coach-deals-it-always must reach the pro offer at least 6 weeks sooner, or win
   2 more bouts a season. Any mechanic under 2 wins in 100 per bout and no season effect is cut, not drawn.
5. **Sparring intensity.** Three settings on every sparring evening: Hard (gain x1.3, +12 tiredness, cut 4 in 100), Technical (x1.0, +6, 1 in 100), Body only (Cardio only, no cut). The bill's "sparring cut 3 in 100" reads from it.
6. **Cut the weak options.** Overtime into the twist deck; "Same as last week" renamed "keep my changes" (keeps your edits, takes the new rota); Coach's extra evenings into a twist answer; Watch onto the trial card; one kilo rule.
7. **A reveal order for the first five weeks.** Week 1: pad places and the sheet. Week 2: coached mornings. Week 3: the twist and the seat. Week 4: favours (the first one is earned on that sheet). Week 5: the trial mat and standing. The guide names each on the day it arrives.
8. **Never print the "right when" thresholds** on screen or in the guide. Show prices and forecasts; the choice stays the player's.
9. **Ana's row as money.** "Teach the members' class: +$90, one class fewer for Ana" as Ana's second pull, after the core is built.
10. **Wire table.** Add Standing, Following, Season target and Sparring intensity to section 6's menu table (Club week, fighter page Overview, Fights sheet, Pro offer, Monday review, the Why: "Standing: Samira -6, went short"),
    and to the golden-path test (a fighter going short twice, the talk, a home win adding fans, the debut ticket forecast moving).

## 5. Is the mechanic set complete for this version?

Yes, once items 1 to 3 are added. With standing, the boxer's own crowd and a season target, every weekly choice has a cost that lasts past the week
(a fighter who leaves, a debut that does not pay, a championship missed), and the amateur years connect to the first professional fight. Everything else
I would want (a rival club that poaches, a hosted show, belts and TV) is already queued for the small living world or later and should stay out.
Close the set after those three and the sparring setting; after that, measure and cut. Do not add more.

## 6. My 10 out of 10, drawn

`docs/mockups/s432/critics/v3_coach_10.png` (from `v3_coach_10.html`): the Club week board with a season strip on top, the four counters, each fighter's
pull, a short week line with the sparring setting, STANDING WITH YOU and FOLLOWING columns, and three decision cards along the bottom: Samira wants a word,
Tess's season target, and Tuesday's sparring setting.

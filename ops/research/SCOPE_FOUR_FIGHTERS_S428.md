# Scope change S428: four fighters, a fight a week, rank on every fight, host your own show

His words (verbatim, 2026-11-10):
- "what if we add also a building a promotion option to the game ? every fight should display the rank earned the rankings , also i think the approach with a single fighter start is wrong , we sshould force the player to have 4 fighters,different weight classes and bjj so menus shows better and players has more things to do . also make it so amateur fights do not require fight camp and can happen within a week . what do you think of these ?"
- After Claude's opinion and plan (4 fighters yes; amateur without camp yes; rank on every fight yes; promotion only as a small hosted club show now, the full promotion after the small living world): "ok p[roceed with this plan and adjust miro opsboard and everything else"

This REPLACES the "one fighter, one gym, small roster" start in CLAUDE.md item 4 and widens "boxing only" by ONE BJJ fighter in the four. It is his scope call, so it stands over the S294 restart plan. Boxing remains the main game; BJJ is one of the four.

## The decision (what is built, in this order)
1. FOUR FIGHTERS AT THE START (quick start and a new career): four fighters in four different weight classes, three boxers and one BJJ fighter (Ana Ribeiro exists in BjjMatch / the BJJ bout film). Menus (Fighters cards, Training week board, Home, Fight prep) are drawn for four. The player cannot start with fewer. Reid's three pad nights now serve four people: the scarcity the week design needs (HANDSPROBE1 measures it). Starting state is staggered, not four problems at once: one fighter has an offer waiting, one is fresh, one has a goal due; the guide light brings the first week in one thing at a time (GuideLight exists).
2. AMATEUR BOUTS NEED NO CAMP: an amateur offer comes 1 to 2 weeks out (today AmateurBooking LEAD_WEEKS 2 to 4) and the fight is preceded by a light FIGHT WEEK (3 to 7 days: weigh-in, one tape session, one plan line), not a camp. England Boxing: the 8 to 12 weeks is the SHOW's permit, the bout sheet closes 24 h to 3 days before, a senior can box about 18 times a season (J_MATCH1). Pro bouts, title fights and nationals keep the camp (answers owned by taper, the squeeze). The week design v4 is re-based on this: the ordinary week is a BETWEEN-FIGHTS week for four people.
3. RANK ON EVERY FIGHT: before and after each bout the fight card, the result and the Why show the boxer's rank and what moved it. A regional LADDER first (the S425 small living world's first piece): position and points from wins, quality of the opponent, recency; amateurs get a regional list, pros a national one later.
4. HOST YOUR OWN CLUB SHOW (small promotion, after 1 to 3): a permit, a doctor, an MC, a card of about 15 bouts with your fighters and others, ticket money; the show is the unit of R37 (ask against fixtures: host, date, card fullness, bout-sheet close). The FULL promotion (pro cards, belts, TV, sanctioning bodies) is parked until after the small living world.

5. A COMPARE TAB WHILE SEARCHING FOR AN OPPONENT (his later S428 message: "also during searching for opponent add a compare tab like boxing managers"): up to three candidates beside her own boxer, side by side (weight gap, age, record, style, what scouting found, form, club and favour, a win-chance band). It lives in R37 (section 3b of ops/research/R37_ASK_FOR_A_FIGHT_MAP_S428.md) and on every incoming offer.

## What changes in the queue (ids in the roadmap plan)
- FOURSTART1 design map + build: the four starters (weights, a BJJ fighter, staggered start), the menus for four, the money (stipends $250 each, dues, start cash: re-measure with GymBills), the first-week guide. Probe: a coach's default week for four fighters, hands per fighter (HANDSPROBE1 feeds it).
- AMATEURWEEK1 design map + build: the fight week, the shorter lead, what the Fight prep screen shows without a camp, the golden path.
- RANKSHOW1: the ladder module (pure, with tests), then the rank line on the fight card, result and Why.
- HOSTSHOW1 (design map first, after the three above): the club show as the R37 unit.
- WEEK4 (the week design v4) is re-based on four fighters and fight weeks; its old 'answers owned by taper' gates apply to pro camps only.
- R37 (ask for a fight) is re-scoped: the show is the unit (the critics' first ask), favours a two-way ledger.
- BJJ live choices and cutman stay at design stage (critics 5 to 6); the BJJ fighter plays the existing bout film until the live choices are built.
- Every new mechanic: a design map with its menu table, two fresh critics at 7 or more before it reaches his board (the S425 rule stands; the critics cost real money, ask him first).

## Risks said out loud
- Day-one overload: staggered start and the guide light, and a quick start that opens at the first Monday with one question open.
- The BJJ fighter is the thinnest part (live bout has one decision, design 5 to 6 of 10): expect her to feel lighter than the boxers for now.
- Money: the start cash ($14,600 = 3 months of costs for one fighter) and the club's stipend, dues and Reid's wage must be re-measured for four fighters before the first build; do not copy the one-fighter numbers.
- The week design rewrite: the 8 to 12 week camp assumption is gone for amateurs.

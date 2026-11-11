# HYPE1 map (S432 v1): blind review by a systems designer of sports management sims

Read whole: CRITIC_PACK.md, CRITIC_ACCESS.md, HYPE_MAP_S432.md, both drawings (png and html). In the code: `Knowledge.range_of(..., hype)` exists
and nothing passes it in; `ProDebut.TICKETS = 100` and `night(sold, terms)` are there as the map says. No hype rule exists yet, which matches the map's section 0.
My test for every meter: does it lead to a decision that trades one thing for another, now or later?

## Depth score: 7 / 10
**One line:** a real decision system, paid in the club week's own currencies (pad places, loyalty, the record), with a strong cash-in-or-protect choice.
But hype is one-sided, the Entertain pick repeats controls the fight already has, and the coach's best tools (your word, taking the blame) are
automatic penalties when they should be choices.

## What works (why it reaches 7)
- **Two parts with different timing.** Buzz lasts and heat is spent on the night. That timing makes the paper in fight week a different choice from the
  paper three weeks out, and probe HYPEFLOW1 is set to merge them if the timing turns out not to matter. Good discipline.
- **Paid in currencies that already hurt.** The paper costs a pad place that a team-mate's habit fix needed. That is the right kind of cost: no new
  resource, and the price lands on another fighter.
- **Cash it in or protect it** (the pro offer read through hype) is the best decision in the map. It has a clock (cooling), a risk (two win chances
  multiplied) and a lasting price (the crash, the manager, the club's share). The drawing makes it readable.
- **Costs come with answers.** Each cost (the scalp, nerves, ego, the manager, the crash, the pull-out) names the player's answer. That makes every
  cost a decision, not a punishment.
- **The cut rule and nine probes.** A lever below 1.5 wins in 100, $150 or 4 fans a season is cut, not drawn. Few design docs police themselves like this.
- **Wired and shown.** 17 menus each with what they are wired to, and one golden-path step. This meets the owner's "wired and shown" bar on paper.

## What holds it below 10
1. **Hype is one-sided.** Only our fighter has heat. In the real sport the night sells on both names and on how close the fight looks
   (Matchmaking.pay_of already uses closeness). The opponent's hype is missing from the sheet, from the tickets and from the reward for beating them.
   So the matchmaking choice "the hot name or the safe name" does not exist, and that is the deepest hype decision a club has.
2. **Entertain / Box smart / Safe repeats the fight's own controls.** Fight night already has Pace (Push, Steady, Save), Aim and eight shouts. A pre-set
   that changes the default shout and multiplies stoppage chances either gets overridden by the player at the first 30-second call (useless), or
   stops the player using the corner (bad). The show should be READ FROM the settled fight (knockdowns, rounds won at Push, "Let your hands go"
   answered, a stoppage; clinch and Save rounds count against). The bill should only hold what you PROMISED.
3. **The stance will likely have one best pick.** SELL is gains x1.5 against a deeper crash. In a game where 5 points of stats win about 72% of
   bouts and the player picks the bouts, losses are rare and planned, so SELL wins most seasons. QUIET is a third card that means "no choice".
   SHIELD only pays off for a fragile fighter. The map knows this (probe SELLSHIELD1), but SELL has no weekly price, only a risk.
4. **The coach's role is half automatic.** The research names four roles: build, shield, lend your name, take the blame. Build and shield are choices.
   "Your name" is a passive bonus on signings. "Take the blame" is an automatic loyalty -3. The prediction has no memory: Roach's predictions mattered
   because he was usually right. A record of your calls would make every prediction a long-term bet.
5. **The hired Coach's role is thin.** Coach can only "front the paper" as a stand-in that costs two pad places. Nothing about Coach makes them better
   or worse at it, so the choice is just an exchange rate.
6. **Too many small receipts.** Of the ten receipts, three are passive drips or below the map's own cut line: mood +2 a week at Warm, the away slot's
   $40 and +1 favour, and the trial mat's +3 potential. They are not decisions. They add reading, not depth.
7. **The free clip is not a decision.** A clip costs nothing on a pad place you already hold, so it is always taken. Make it happen by itself, or give it a price.
8. **The cash-in screen tilts one way.** In the drawing, NOT YET earns the club more money on every branch ($589 or $250 later, plus two home cuts of
   $761 and $774, against $404 now). The cost that should balance it (the manager call: under loyalty 60 the club keeps 10%) sits as one text row and is
   not priced into either path's total. As drawn, protecting always wins on the club's money.
9. **The fighters do not affect each other.** With four fighters, hype should spill over: the main event lifts the undercard, and a team-mate who wants
   to be the main name notices who you sell.

## Missing options
- The opponent's hype on the bout sheet, and the choice between a hot name and a safe name (two-sided heat).
- Taking a share of the beaten opponent's buzz with a win (the scalp as a prize, not only a cost).
- YOUR WORD: a record of your predictions that sizes every later prediction and call-out.
- A choice after a hyped loss, on the Why: "It was my plan" / Say nothing / "Didn't listen". This is the research's "take the blame" role.
- Coach's press skill (from RPGLAYER1's coach levels), so fronting the paper is a choice about the coach, not just an exchange rate.
- A weekly price on SELL (a media day: camp gain -5% in fight week), so SELL is not free until a loss.
- The undercard riding the main event (+heat to team-mates on the same card); a "main name" ambition that minds who is sold.
- The crowd in the fight itself: at a Hot home night, a knockdown or a big round gives one exchange of crowd lift; a hot opponent's hall does the reverse.
- Each cash-in path's total for the club, with the manager risk priced inside it.

## Useless options (as written)
- ENTERTAIN / BOX SMART / SAFE as a pre-set on the bill: it repeats Pace and the shouts. Replace it with WHAT YOU PROMISE plus the show read from the fight.
- QUIET as a stance card: it is the absence of a stance. Keep SELL and SHIELD as cards; with neither set, the fighter is quiet.
- The free CLIP button: always taken. Make it automatic.
- MOOD +2 a week at Warm: a passive drip with no trade, on a meter that already has many inputs.
- A BETTER SLOT AWAY ($40 travel, +1 favour): below the map's own cut line.
- The Crowd tab's THIS WEEK buttons, if they also sit on Club week and the bill: two homes for one action. The Crowd tab should explain and the other two should act (or make them the same control).

## To reach 10/10 (most important first, each buildable)
1. **Make hype two-sided.** The night's heat = our fighter's hype + the opponent's hype, scaled by how close the fight looks (Matchmaking already has
   closeness). Show the opponent's band on every sheet card and offer ("Holly Brennan, Warm 44"). A win takes a quarter of the opponent's buzz. Tickets
   and fans read the night, not just our fighter. This creates the hot-name-or-safe-name choice on the sheet.
2. **Read the show from the fight; the bill keeps only the promise.** Remove the Entertain/Smart/Safe pre-set. Show score from the settled bout:
   knockdown +6, round won at Push +2, "Let your hands go" answered with a won exchange +1, stoppage win +8, a round at Save or mostly tied up -2. The bill
   offers WHAT YOU PROMISE: A war (show x1.5, a dull fight -6 buzz), A clean win (x1.0), Nothing (x0.6). Your corner calls become the hype lever, and the
   promise is a risk you take on yourself. Show it on the Why ("Show +14: 1 knockdown, 3 rounds at Push").
3. **YOUR WORD: give predictions a memory.** Keep a count of calls landed ("5 of 7"). Every call adds +1 heat for each landed call above half (at most +5).
   A miss lowers the count. A good word raises the call-out's acceptance (8 to 9 in 10). Show it on your card in Club > People and on the bill.
4. **TAKE THE BLAME as a choice.** On the Why after a hyped loss: "It was my plan" (your reputation -2; the fighter's mood and loyalty crash cancelled),
   Say nothing (as now: mood -6, loyalty -3), "Didn't listen" (reputation kept; loyalty -6, coachability -2). Wire it to Loyalty and RPGLAYER1's bond.
5. **Give SELL a weekly price and drop QUIET as a card.** SELL: a media day each fight week (camp gain -5%), plus the deeper crash. SHIELD: +1 confidence a
   week while held, plus no nerves and no scalp, with PROTECTED as written. Gate both on SELLSHIELD1: each best in at least 1 of 3 line-ups.
6. **Price the cash-in screen in one currency.** Each path gets one line: the club's expected money (win chances x each branch) with the manager risk
   inside it ("Not yet: club about $1,640 expected; 35% chance a manager signs Tess: then 10%, about -$900"). CASHIN1 must show cash-in winning in at least
   1 line-up in 3. As drawn, protecting always wins.
7. **Give Coach a press skill.** In RPGLAYER1's coach levels, add Coach's press rating 1-5. Coach fronting the paper gives +6 / +8 / +10 / +12 / +14 heat by
   rating. Fronting four times a season raises it by one. Coach's choice of growth path then touches hype.
8. **Let fighters affect each other.** A team-mate on the same card as a Hot main event gets +3 heat. A fighter whose ambition is "the main name" loses
   loyalty -1 a week while a team-mate on SELL tops a card above them (ambition-gated, at most 4 weeks running count).
9. **Put the crowd in the fight.** At a Hot or On fire home night, the first knockdown scored or a won round at Push gives the next exchange +0.25. Away
   at a Hot opponent's hall, the same goes to them. Measure it with NERVES1's rule (at least 1.5 in 100, or cut).
10. **Cut the passive receipts and make the clip automatic.** Remove mood +2 a week, the away slot and the trial mat's +3 potential unless a probe keeps
    them. The clip happens by itself on your pads (+4 heat, no button).
11. **One home per action.** The Crowd tab shows the gauge, the line, the receipts and the costs. The stance lives on Club week's row, and the press, the
    promise and the prediction live on the bill. The Crowd tab links to them and does not repeat their buttons.

## Complete?
**Yes, with the list applied, hype is complete for this version** (amateur club week to the debut and the first professional offers). The two-sided
night and the show read from the fight tie hype to matchmaking and to the corner, the two core loops it currently misses. Your word and the blame choice
give the coach the four roles the research found. Everything in LEFT FOR LATER (rematch heat, a rival coach's feud, club-v-club nights, the two-week
sales read on our own show) needs the small living world or HOSTSHOW1, and deferring it is right.

## My 10/10, drawn
`docs/mockups/s432/critics/hype_designer_10.png` (from `hype_designer_10.html`): the bill in fight week. Across the top, the night's heat from both
corners. Below it, three columns: WHAT YOU PROMISE (with the show read from the fight), YOUR PREDICTION (with YOUR WORD 5 of 7), and THE WEEK'S PRESS
(paid in pad places, with the named team-mate who pays). The bottom shows what a win pays and, on a loss, the three blame answers.

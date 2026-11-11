# HYPE1 map v1: the promoter's review (fresh, blind critic, S432)

Seat: a boxing promoter who has built local amateurs into sold-out small-hall professional debuts.
Read whole: CRITIC_PACK.md, CRITIC_ACCESS.md, HYPE_MAP_S432.md, both drawings (PNG and HTML). Checked against the code: `scripts/rules/ProDebut.gd`
(TICKETS 100, BREAK_EVEN 60, `night(sold, terms)`) and `Knowledge.range_of(..., hype)`. Skimmed sections 1-4 of HYPE_RESEARCH_S432.md.
The drawings' sums are right (ticket cut 450 x 1.73 = $779; fans 4 + 73 x 0.15 = 15; debut 20+41+13+35 = 109; Tess's terms 1 + 64/200 = 1.32;
club $404 and Tess $1,213 come out of `ProDebut.night`).

**Depth: 7 / 10.** Real choices with real prices, wired to the week, the bout sheet and the pro offer, and the coach has a real hand in it. What
holds it under 8 is the thing every promoter lives by: tickets sold by people. Hype here is a percentage on a $450 cut. At club scale the house is
counted seat by seat, the boxer sells most of it by hand, and a third of it sells in fight week. The map knows this (its research says it plainly) but
draws a multiplier instead of a house.

## What is good
- Two numbers, never one: buzz that lasts and cools, heat that belongs to one bout and is spent on the night, beside fans that stay. That is how a
  promoter thinks of a fighter: the people who always come, and what this card adds.
- The coach's hand is real and paid in the club week's own coin: a pad place for the paper, Coach's evening as the cheaper version, the stance,
  the prediction, the call-out, talking a fighter down, the manager's call. No new currency.
- Costs that bite and that a player will feel: the crash after a sold loss, nerves for a fragile fighter, ego eating coachability, the manager who
  calls a hot amateur, the pull-out refund.
- The pro offer screen is the best page in the set: cash it in now against protect it, two paths with chances, tickets, terms, the club's take and
  the loss path drawn as a line. That is the real conversation in a promoter's office.
- Every menu named with what it is wired to, a golden-path step, and probes with cut rules before anything is built.

## Missing options (what each would change)
1. THE HOUSE, counted in seats. For a home bout: seats in the hall, sold so far, a forecast to the bell, break-even, and who sold them (the fighter's
   own people, the other corner's people, club members, the door that hype brings). Changes: hype becomes something a player can read and chase;
   the ticket cut falls out of seats sold instead of a flat multiplier; the paper's timing (fight week is worth twice) becomes visible.
2. A TICKET NIGHT for the fighter. Real club boxers sell their own tickets. Give one evening of the fighter's own (not yours) to selling: +seats, minus
   that night's pads and a little tiredness relief. Changes: a second hype lever that costs the FIGHTER's week, not only the coach's pad places, and
   ties hype straight to the training plan.
3. THE OTHER CORNER'S CROWD, and the derby. The best small-hall nights are two sellers. Show what the opponent brings; when the other coach talks
   back (or a call-out is accepted), let the player answer and turn it into a derby: heat for both, more seats, a deeper crash if the home name loses
   to a named rival. Changes: matchmaking reads the house, not only the win chance.
4. WHO CARRIES A LOSS. The research names four coach roles: build, shield, lend your name, take the blame. The map builds three; the fourth is only a
   passive loyalty cut. Add an after-loss choice in the Why: ON ME (the club's name -2, the fighter's mood and confidence kept, loyalty +2) or ON THE
   FIGHTER (name kept, mood -6, confidence -3, loyalty -3 under SELL). Changes: the crash becomes a coach's decision with a price either way, and
   links to RPGLAYER1's bond.
5. YOUR WORD, a record of your predictions. Roach's calls worked because they landed. Show calls landed this year; two misses in a row halve the heat
   your next prediction and your next paper piece give, until one lands. Changes: the prediction stops being a free +4/+10 button and becomes a
   reputation the coach builds over a season.
6. STRIKE WHILE HOT. Activity is the research's third lever. On the sheet, ask for the next bout soon after this one (amateur bouts need no camp,
   S428): buzz cools one week instead of four, but tiredness and damage carry in. Changes: hype meets the week's fatigue and injury load directly.
7. THE COMEBACK. The home base forgives (Buglioni sold 400+ after losing the 0). The first home bout after a crash gets +10 heat. Changes: a crash has
   a road back that the player plans, not only a wait.

## Useless or doubtful options
- A CLIP: free and riding on a pad place you already hold, so it is always taken; the research says clips bring viewers, not buyers. Cut it, or make
  it automatic and fold its +4 into the poster.
- ENTERTAIN / BOX SMART / SAFE as its own toggle on the bill: it is the fight plan's Push / Steady / Save pace under another name. Two controls for one
  thing. Keep the hype effect, but read it from the plan's round-by-round pace (Push in rounds 1-2 = entertain) and show the hype line there.
- MOOD +2 a week at Warm and the trial mat's +3 potential: passive, tiny, nothing to decide. Keep them off the Crowd tab's tiles (a hover line at most);
  they also fail the map's own cut rule unless probes say otherwise.
- The SCALP as an automatic tax: a promoter protects a seller, the opponent does not pick the fight. Keep it, but only as the sheet's visible choice
  (the money fight: bigger cut, harder name, beside the normal card), which the decision table already half says.
- PROTECTED under SHIELD (buzz -3 a week and one more win for the offer after 8 weeks): a rule inside a rule. Fine in the code, but it needs one plain
  line on the stance card or it will read as a bug.

## To reach 10/10 (most important first, buildable)
1. Replace the flat ticket-cut multiplier with THE HOUSE for every home bout: hall size (club show 220, York Hall larger), sold so far, forecast
   to the bell, break-even line, four sources (fighter's own up to 40, the other corner's, members, hype at the door: about +6 seats per 10 hype on the
   night). The club's cut = seats sold above break-even x the ticket share. Draw it as the top panel of the Crowd tab and as one line on the bout sheet card.
2. Sales curve: a third of the seats sell in fight week; heat added in fight week converts at full rate, three weeks out at half. Show the curve with
   the forecast dashed. This also makes the map's own HYPEFLOW1 test ("the paper in fight week sells twice") visible to the player.
3. TICKET NIGHT: one of the fighter's evenings (Pads or Sparring replaced) sells up to the fighter's 40; costs that night's drill mastery, gives back a
   little tiredness. One per bout. Lives on the Week board as an evening card and on the Crowd tab's THIS WEEK.
4. WHO CARRIES A LOSS: two answers in the Why after a hyped loss (On me / On the fighter) with the prices above; pre-selects nothing; feeds loyalty and
   confidence (RPGLAYER1).
5. YOUR WORD: calls landed / made this season on the Crowd tab; two misses in a row halve prediction and paper heat until one lands. Prediction chips
   (None / A win / The stoppage) show the opponent's chin on file and the win chance beside them.
6. THE OTHER CORNER'S CROWD on every sheet card and the bout page; ANSWER BACK when their coach talks (or a call-out is accepted) turns the bout into a
   derby: +8 heat both sides, +12 seats from their side, a loss to the named rival crashes one step deeper.
7. STRIKE WHILE HOT on the sheet: "ask for a bout 2 weeks after this one" with the cooling saved and the tiredness that carries in.
8. THE COMEBACK: +10 heat on the first home bout after a crash; the Crowd tab names it after a loss so the player can plan for it.
9. Fold ENTERTAIN / SAFE into the fight plan's pace; cut the clip; move mood +2 and the trial mat bonus to hover lines.
10. One golden-path step that walks the house: fight week, ticket night on Tuesday, the paper on Thursday, the forecast crossing break-even, the cut on
    Money equal to seats above break-even, then a loss with ON ME chosen and the comeback heat on the next sheet.

## Complete?
Yes, with the list applied, hype is complete for this version (one club, amateur to the first professional fights). The house, the ticket night and
the derby give a promoter's real levers at club scale; the coach owns build, shield, word and blame. What is left for later is right to wait: club v
club nights and a show's main event belong to HOSTSHOW1, rematch heat to judges with taste in the small living world, a rival coach as a storyline to
the rival club.

Drawing (my 10/10, the Crowd tab in fight week): `docs/mockups/s432/critics/hype_promoter_10.png` (HTML beside it).

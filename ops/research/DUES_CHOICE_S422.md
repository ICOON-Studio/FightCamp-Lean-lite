# The dues choice made real (S422, Claude; John's seat unreachable, researched in-session)

## The fault
Membership.DUES: cheap $25 x 1.15 draw = 28.75 a member-slot, standard $35, premium $45 x 0.85 = 38.25, and premium's gap
closes as reputation rises. Premium always earns most, cheap never wins: a fake choice (S421, the operator's "Fix the fake dues
choice" row).

## What real clubs show (sources at the bottom)
1. Community amateur boxing clubs charge almost nothing: a yearly fee of GBP 30-50 plus GBP 3-6 a session (about GBP 8-12 a
   week). Islington BC: juniors GBP 30 a year + GBP 4 a session; Thames Valley ABC GBP 5 a class; Hanwell GBP 50 a year +
   GBP 3-5 an hour. They are cheap ON PURPOSE: they exist to bring juniors in, and juniors are where boxers come from.
2. Premium boxing gyms (GBP 50-80 a month) sell fitness classes to adults; their members rarely compete.
3. Price rises lose members, but fewer than owners fear (UK Leisure-net survey: about 4 in 10 independent-gym members would
   accept 20% more; about a third would accept no rise). Monthly churn is 3-6% in the industry, under 3% at the best clubs.
   No reliable UK split between budget and premium churn was found: we do not model one.

## The rule (proposal)
The band changes WHO walks in, not only how many:
- Cheap ($25, draws 15% more): the youth section's intake chance 0.35 -> 0.50 a term (about 75% a year for a home-grown
  prospect instead of 58%).
- Standard ($35): unchanged.
- Premium ($45, draws 15% fewer, the gap closing with reputation as now): intake chance 0.35 -> 0.20 (about 36% a year).
- The Club > Money dues buttons say it in plain words: "Cheap: more juniors, more home-grown boxers" / "Premium: more money,
  fewer juniors".

## The sums (40 members, youth section open)
- Premium over standard: +$130 a month (+$1,560 a year), about one home-grown boxer fewer every 4-5 years.
- Cheap under standard: -$250 a month (-$3,000 a year), about one more home-grown boxer every 6 years. A home-grown prospect
  is on half the stipend for a year ($6,500 saved) and has a few more points of potential.
- So: premium is the money play for a club that buys its talent; cheap is the club that grows its own. Both are real. If the
  money test shows cheap still never pays, the next lever is cheap's draw (1.15 -> 1.25), measured, not guessed.

## Build (after his yes)
HomeJuniors.INTAKE_CHANCE reads the band (one pure function in Membership: intake_chance(band)), Club > Money's dues buttons
take the two short lines, tests: membership_test + home_juniors test extended. Qwen seat, one brief.

Sources: Islington Boxing Club membership page (islingtonboxingclub.org/?p=386), Thames Valley ABC (thamesvalleyabc.netlify.app),
Hanwell School of Boxing (playsport.com), Leisure-net research via leisureopportunities.co.uk, Gymdesk churn benchmarks,
Which? 2024 gym price survey.

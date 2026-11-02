# Make it a game: stakes, weekly trade-offs, the fight teaches the gym (plan S323, 2026-10-31)

Operator S323: "what do we need to turn this more to a game now?" -> Claude's rating (fight view 7, decisions 6, booking 5,
training 4, roster 3, gym/money 3, season 3, stakes 2) and five fixes -> operator: "i agree". This plan needs his OK on the
board before anything is built (it changes settled numbers: dues, start cash, debut purse).

## The idea in one line
Every week you choose between money, her progress and her health - and you can lose: the gym can close, she can get hurt,
a loss costs her ranking. The body track you see in the fight is the same body you train in the gym.

## Real-world numbers it stands on (research S323, sources in the research note; "derived" = worked out from them)
| What | Real number | Source |
| --- | --- | --- |
| Members of an England Boxing club | ~33 a club (35,831 in 1,084 clubs) | England Boxing 2024/25 deck |
| Monthly fee | £25-30/month, or £6 a session | club price pages |
| Rent, small unit (1,500 sq ft) | ~£1,250-1,650/month (derived) | listings |
| Coach pay | £20-25/h (Level 1), up to £40/h (Level 2) | job adverts |
| Club / boxer / coach registration | £250 / £14 / £28 a year | England Boxing |
| Competition injury | 6.8 per 1000 bout-minutes -> ~6 % a 3x3 bout (derived); 72 % head/neck; cuts 20 % | Alevras 2022 meta-analysis |
| Training injury | 1.3 per 1000 h -> ~1.3 % a week at 10 h (derived) | same |
| Time lost | ~33 days per injury on average (GB squad; verify); hand/wrist slowest | Loosemore 2015 |
| Load spike | this week vs 4-week average 0.8-1.3 = safe; >= 1.5 = 2-4x injury risk | Gabbett 2016 |
| KO / concussion | 30 days out, then return steps; two in 3 months = 30 days after the 2nd; three in 12 months = 1 year | England Boxing rule 4.1.2 |
| Season goal | National Amateur Championships: 5 bouts + 3 months' membership; regional entry, then up to 4 bouts; entering = "Elite" for life | England Boxing 2026 guidance |
| First pro fight | licence £184/yr + MRI; the boxer often PAYS the opponent ~£1,500 and sells tickets | BBBofC 2025; industry articles |
| Small businesses | ~39 % still trading after 5 years | ONS 2024 |

## The decisions (Claude, developer - for his approval)
1. MONEY THAT BITES. Dues to the real monthly fee (members pay monthly; the game keeps $), the gym's rent billed monthly,
   coach pay per session hour, registration fees yearly. Start cash = about 3 months of costs, not $25,000. Below $0 a
   red NEEDS YOU flag; 4 weeks below $0 = the gym closes (a career summary, then load or new career). A careless player
   should run out in ~6 months; a sensible one never.
2. INJURIES AND SUSPENSIONS. Each bout rolls injury from the bout's own damage (BodyMap) around the real ~6 %: cuts, a
   hand, the head. Weeks out per type; a KO/stoppage to the head = 30 days, England Boxing's ladder after that. Training
   injuries from the weekly load (below). The fighter page shows them (today it prints "Injuries: None" always).
3. A WEEKLY TRADE-OFF: TRAINING LOAD. Each fighter's week: Light / Normal / Hard. Hard = bigger gains, but this week's load
   against her 4-week average is shown as a gauge; above 1.5 the injury risk shows 2-4x on the body track (the burning part
   is where it goes). A rest week brings the ratio down. Camp weeks are Hard by default - the risk is the point.
4. LOSSES COST. A loss: ranking down, fewer members join after the news, morale; a stoppage loss also the suspension.
   Wins still bring members and the ticket cut.
5. THE FIGHT TEACHES THE GYM. After each bout a body report: the part that burned first ("her legs went in round 2") with
   one click to set next week's training focus there; the next fight's body track shows the difference.
6. THE FIRST SEASON GOAL (after 1-5): the road to the National Amateur Championships - 5 bouts and 3 months' membership,
   the regional entry, up to 4 bouts at the nationals; reaching them makes her "Elite". The pro debut then COSTS money
   (licence, the opponent's fee, tickets to sell) - a real reason to keep the gym healthy.

## Build order (one update each, his play is the gate)
| Update | What he gets | Pure rules (agent) | Claude |
| --- | --- | --- | --- |
| 27 | Money that bites + losses cost | GymBills (monthly costs, runway, close rule) - Qwen | MONEY page, red flag, the close screen, numbers into Data |
| 28 | Injuries and suspensions | InjuryRoll (bout + training, weeks out, EB ladder) - Qwen | fighter page, booking blocks a suspended fighter, news |
| 29 | Training load trade-off + post-fight body report | TrainingLoad (ratio, risk x, gains x) - Qwen | Light/Normal/Hard on Training, gauge, body report page |
| 30 | Road to the nationals (season goal) | SeasonPath (eligibility, regional, bracket) - Arena | calendar, World page, the goal on HOME |

## How each is checked (balance-check skill, before he plays it)
- A 26-week career harness for each update: a careless player (always Hard, fights every offer, no rest) vs a sensible one.
  Bounds: careless - the gym closes in 15-40 % of careers by week 26, at least one injury in 50-80 %; sensible - closes
  in under 5 %, injury in 10-35 %. No single setting wins every time (the S323 pace check is the model).
- Tests first for every rule module; one golden-path test plays the update's path; the .exe gate as always.

## Design review (design-review skill, lean mode)
- Complete: overview, rules, numbers, edge cases below, dependencies, acceptance (the bounds above).
- Edge cases: two fighters injured at once (the coach's sessions still billed); a fighter suspended with a bout booked
  (the bout is withdrawn, no fee, a news line); cash below 0 during a camp (the camp continues - the close rule counts
  weeks); a career loaded from an old save (missing fields default to "no injury", load 1.0).
- Dependencies: Data numbers (settled - his OK), Bouts (result -> injury), BodyMap/BodyLoad (where it hurts), Training
  (load), Money (bills), HOME (flags). The 3D fight is unchanged.
- Risk: money pressure can make the early game a "waiting simulator" - quick start keeps a first bout offer in week 2.

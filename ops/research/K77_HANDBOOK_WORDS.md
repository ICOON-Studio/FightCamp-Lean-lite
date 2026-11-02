# K77 - THE WORDS: HANDBOOK LINES AND COACH LINES IN ONE HOUSE VOICE

Kalli, S78, 2026-09-25. Words only. Claude applies. Sources read whole: `Godot/scripts/Glossary.gd` (46 terms) and `Godot/scripts/CoachMarks.gd` (`STEPS`, 19 lines), both at origin/master `f5a7e14b`.

Every proposed string below was checked in code: Handbook `short` <= 15 words, `why` <= 12 words, exactly one sentence each, sentence case; coach lines <= 2 sentences; none contains a banned item. Word counts are `len(text.split())`.

## 1. Voice sheet

### The Handbook (tooltips, the Handbook, the tutorial's hover demos)
- **Who is talking:** nobody. It is the gym's reference book. It never says I or we.
- **Who it talks to:** the owner, as `you` / `your gym`. The fighter is always `the fighter`, `a fighter` or `they`.
- **How:** present tense, plain everyday words, one sentence per field. `short` says what the thing is. `why` says what it changes in play and starts with the effect or the subject, never with a fragment.
- **Examples:** name at most three, introduced with `such as`.
- **Numbers:** only ranges the game really uses (`0 to 100`, `100% when new`).

### The coach (tutorial coach marks)
- **Who is talking:** your senior head coach. Has seen a hundred first careers, likes you, wastes no words.
- **How:** warm through care, blunt through brevity. Sentence 1 is the one thing to do, naming the control exactly as it appears on screen in capitals (`CONTINUE`, `THE DAY`, `ENTER THE CARD`). Sentence 2, if any, is the reason or the risk. Never a third sentence.
- **Approval:** the coach approves by moving on. No praise lines.
- **Never defines a stat by number.** That is the Handbook's job; the coach points you at it.

### Five banned words and constructions (both voices)
1. **`he` / `his` / `him` for a fighter.** The roster has women and men, and these strings are static. Use `the fighter`, `your fighter`, `they`.
2. **Semicolons, colons and ` - ` dash joins inside a line.** They glue two thoughts into one field. Write one sentence, or two in the coach's case.
3. **Open list tails:** `and so on`, `and others`, `etc.` Give up to three examples with `such as`.
4. **Filler words:** `just`, `simply`, `actually`, `really`, `very`, `basically`.
5. **Cheer and hype:** `!`, `great`, `awesome`, `amazing`, `let's`, `you've got this`.

### Argued against my strongest ruling (ban 1, no `he`)
The case against it: the old lines read faster, `the fighter` repeated across 46 tooltips is heavy, and singular `they` can read as plural in a terse line (`pull them away`). The better fix would be runtime pronouns from the fighter's sex. **I keep the ban.** These strings are static data with no fighter attached, the product rules put women on the roster, and runtime pronouns are code (out of scope). Where `they` could be misread I wrote `the fighter` instead, which is why that phrase repeats.

Second ruling I argued against: capitals for controls inside coach sentences. The case against it is that caps shout in an 18px sans card. I keep them, because the old lines mixed `The Day`, `the gym` and `Continue`, and the player is scanning for an exact label. The caps match what `find_button` looks for.

## 2. Handbook - every `short` and `why`

Columns: id | current | proposed | words (proposed / budget). Rows where proposed equals current are kept on purpose.

| id | current | proposed | words |
|---|---|---|---|
| `proficiency.short` | Skill in one discipline, 0 to 100. | Skill in one discipline, from 0 to 100. | 8/15 |
| `proficiency.why` | Unlocks that discipline's techniques and how well he uses them. | Unlocks that discipline's techniques and how well the fighter uses them. | 11/12 |
| `condition.short` | How worn a piece of equipment is; 100% is new. | How worn a piece of equipment is, from 100% when new. | 11/15 |
| `condition.why` | Worn kit trains less and needs repair money. | Worn equipment trains less and costs money to repair. | 9/12 |
| `conditioning.short` | The fighter's engine: how long he keeps his output in a fight. | How long the fighter can keep up their output in a fight. | 12/15 |
| `conditioning.why` | Low conditioning fades in late rounds. | Fighters with low conditioning fade in late rounds. | 8/12 |
| `fatigue.short` | Tiredness from training that rest clears day by day. | Tiredness from training, cleared a little by each day of rest. | 11/15 |
| `fatigue.why` | High fatigue cuts training gains and raises injury risk. | High fatigue cuts training gains and raises injury risk. | 9/12 |
| `morale.short` | How the fighter feels about the gym and his career right now. | How the fighter feels about your gym and their career right now. | 12/15 |
| `morale.why` | Low morale slows training and pushes him toward leaving. | Low morale slows training and pushes the fighter toward leaving. | 10/12 |
| `loyalty.short` | How tied the fighter is to your gym. | How strongly the fighter is tied to your gym. | 9/15 |
| `loyalty.why` | Low loyalty lets rival gyms and offers pull him away. | Low loyalty lets rival gyms and offers pull the fighter away. | 11/12 |
| `record.short` | Wins, losses and draws, written W-L-D. | Wins, losses and draws, written as W-L-D. | 7/15 |
| `record.why` | Promoters and matchmakers book on the record. | Promoters and matchmakers book fights on the record. | 8/12 |
| `roster.short` | The fighters signed to your gym. | The fighters signed to your gym. | 6/15 |
| `roster.why` | Each one trains, fights and draws a share of costs. | Each fighter trains, fights and adds to your costs. | 9/12 |
| `starting_cash.short` | The money the gym opens with. | The money your gym opens with. | 6/15 |
| `starting_cash.why` | Upkeep and wages come out of it until purses arrive. | Upkeep and wages come out of it until purses arrive. | 10/12 |
| `cash.short` | Money in the gym's account today. | Money in your gym's account today. | 6/15 |
| `cash.why` | Below zero you cannot sign, repair or expand. | Below zero, you cannot sign, repair or expand. | 8/12 |
| `upkeep.short` | Weekly running cost of the building and its equipment. | The weekly running cost of the building and its equipment. | 10/15 |
| `upkeep.why` | Paid every week whether anyone fights or not. | Paid every week, whether anyone fights or not. | 8/12 |
| `floor_space.short` | Grid cells on the gym floor; every station takes some. | Grid cells on your gym floor, and every station takes some. | 11/15 |
| `floor_space.why` | No free space, no new equipment until you expand. | With no free space, you cannot add equipment until you expand. | 11/12 |
| `repair_cost.short` | What it costs to bring a worn station back to full condition. | What it costs to bring a worn station back to full condition. | 12/15 |
| `repair_cost.why` | Repairing restores the training it gives. | Repairing a station restores the training it gives. | 8/12 |
| `tier.short` | Your gym's standing, from a small club upward. | Your gym's standing, starting from a small club. | 8/15 |
| `tier.why` | Higher tiers draw better recruits and offers. | Higher tiers draw better recruits and better offers. | 8/12 |
| `market.short` | The country your gym works in: its fighters, shows and prices. | The country your gym works in, with its own fighters, shows and prices. | 13/15 |
| `market.why` | Sets who you can recruit and which shows book you. | Sets who you can recruit and which shows book you. | 10/12 |
| `city.short` | Where the gym stands inside its market. | Where your gym stands inside its market. | 7/15 |
| `city.why` | Sets local rent, rivals and the talent nearby. | Sets local rent, rival gyms and the talent nearby. | 9/12 |
| `gym_heat.short` | Rivalry between your gym and another, built by fights and words. | Rivalry between your gym and another, built up by fights and talk. | 12/15 |
| `gym_heat.why` | Hot rivalries sell tickets and make fights harder to refuse. | Hot rivalries sell tickets and make fights harder to refuse. | 10/12 |
| `hype.short` | How much the public wants to see this fighter or bout. | How much the public wants to see this fighter or bout. | 11/15 |
| `hype.why` | Hype raises purses and the seats a show sells. | Hype raises purses and the number of seats a show sells. | 11/12 |
| `offer.short` | A promoter's invitation to fight on a dated card. | A promoter's invitation to fight on a dated card. | 9/15 |
| `offer.why` | Accept to book the bout; each expires on its date. | Accept it to book the bout before the offer expires. | 10/12 |
| `purse.short` | What the fighter is paid for the bout; the gym takes its cut. | What the fighter is paid for the bout, before your gym takes its cut. | 14/15 |
| `purse.why` | The gym's main income. | This is your gym's main source of income. | 8/12 |
| `pay_vs_market.short` | This pay compared with what fighters like him usually get. | This pay compared with what similar fighters usually get. | 9/15 |
| `pay_vs_market.why` | Pay far under market is refused or kills morale. | Pay far under market gets refused or hurts morale. | 9/12 |
| `weight_class.short` | The weight limit a fighter must make to fight in a division. | The weight limit a fighter must make to fight in a division. | 12/15 |
| `weight_class.why` | Bouts are booked by class; missing weight can cancel them. | Bouts are booked by class, and missing weight can cancel them. | 11/12 |
| `weigh_in.short` | The official scale check before a bout. | The official scale check before a bout. | 7/15 |
| `weigh_in.why` | Over the limit means a fine or the bout is off. | Over the limit means a fine or no bout. | 9/12 |
| `walk_weight.short` | What the fighter weighs day to day, away from the scale. | What the fighter weighs day to day, away from the scale. | 11/15 |
| `walk_weight.why` | The gap to the limit is the cut he has to make. | The gap to the limit is the weight the fighter must cut. | 12/12 |
| `weight_cut.short` | Losing weight in the final days to make the limit. | Losing weight in the final days to make the limit. | 10/15 |
| `weight_cut.why` | Big cuts drain condition before the fight. | Big cuts wear the fighter down before the fight. | 9/12 |
| `fight_week.short` | The final days before a bout: taper, media and the weigh-in. | The final days before a bout, with the taper, media and weigh-in. | 12/15 |
| `fight_week.why` | Hard training here costs freshness on the night. | Hard training this week leaves the fighter tired on the night. | 11/12 |
| `fight_camp.short` | The weeks of preparation aimed at one bout. | The weeks of preparation aimed at one bout. | 8/15 |
| `fight_camp.why` | A focused camp raises readiness for that opponent. | A focused camp raises readiness for that opponent. | 8/12 |
| `readiness.short` | How prepared the fighter is for this bout today. | How prepared the fighter is for this bout today. | 9/15 |
| `readiness.why` | Low readiness shows as slower output and defence. | Low readiness shows as slower output and defence. | 8/12 |
| `injury.short` | Damage that keeps a body part from full use until healed. | Damage that keeps a body part from full use until it heals. | 12/15 |
| `injury.why` | Injured fighters train less and should not fight. | Injured fighters train less and should not fight. | 8/12 |
| `suspension.short` | Days a fighter may not compete after a bout or knockout. | Days a fighter may not compete after a bout or knockout. | 11/15 |
| `suspension.why` | He cannot be booked until it ends. | The fighter cannot be booked until it ends. | 8/12 |
| `sanctioning.short` | The body that licenses fighters and approves bouts in a market. | The body that licenses fighters and approves bouts in a market. | 11/15 |
| `sanctioning.why` | Unsanctioned bouts are refused or carry penalties. | Unsanctioned bouts get refused or carry penalties. | 7/12 |
| `ruleset.short` | The sport a bout is fought under: boxing, kickboxing, MMA and so on. | The sport a bout is fought under, such as boxing, kickboxing or MMA. | 13/15 |
| `ruleset.why` | Decides which techniques are legal. | Decides which techniques are legal in the bout. | 8/12 |
| `discipline.short` | A fighting art the fighter trains: boxing, wrestling, BJJ and others. | A fighting art the fighter trains, such as boxing, wrestling or BJJ. | 12/15 |
| `discipline.why` | Each has its own proficiency and techniques. | Each discipline has its own proficiency and techniques. | 8/12 |
| `technique.short` | A single move the fighter can learn and use in bouts. | A single move the fighter can learn and use in bouts. | 11/15 |
| `technique.why` | Learned techniques are what he actually throws. | Only learned techniques get thrown in a fight. | 8/12 |
| `training_plan.short` | What the fighter works on this week, set per fighter. | What each fighter works on this week, set one fighter at a time. | 13/15 |
| `training_plan.why` | Sets which stats grow and how tired he gets. | Sets which stats grow and how tired the fighter gets. | 10/12 |
| `fight_iq.short` | Decision-making in the fight, built from experience and coaching. | Decision-making in a fight, built from experience and coaching. | 9/15 |
| `fight_iq.why` | Better choices of when to attack, defend and clinch. | Higher fight IQ means better timing on attack, defence and clinch. | 11/12 |
| `potential.short` | The ceiling the fighter can grow to with good training. | The ceiling the fighter can grow to with good training. | 10/15 |
| `potential.why` | Young, high-potential fighters are worth the time. | Young, high-potential fighters repay the training time. | 7/12 |
| `age.short` | Young fighters grow fastest; past the early thirties bodies decline. | The fighter's age in years, which shapes growth and recovery. | 10/15 |
| `age.why` | Shapes growth, recovery and how long a career lasts. | Bodies grow fastest when young and decline after the early thirties. | 11/12 |
| `ranking.short` | Where the fighter stands in his division's table. | Where the fighter stands in their division's table. | 8/15 |
| `ranking.why` | Higher rank brings bigger offers and title shots. | Higher rank brings bigger offers and title shots. | 8/12 |
| `corner.short` | Your instructions to the fighter in the minute between rounds. | Your instruction to the fighter in the minute between rounds. | 10/15 |
| `corner.why` | Changes his plan for the next round. | Sets the fighter's plan for the next round. | 8/12 |
| `scouting.short` | What you know about an opponent or a prospect. | What you know about an opponent or a prospect. | 9/15 |
| `scouting.why` | Unscouted numbers are estimates, not facts. | Unscouted numbers are estimates, not facts. | 6/12 |
| `staff.short` | Coaches and support people you employ. | The coaches and support people you employ. | 7/15 |
| `staff.why` | Good coaches raise training gains and fight-night advice. | Good coaches raise training gains and improve fight-night advice. | 9/12 |
| `wage.short` | What you pay a staff member or fighter each period. | What you pay a staff member or fighter each period. | 10/15 |
| `wage.why` | Wages are paid whether or not anyone fights. | Wages are paid whether anyone fights or not. | 8/12 |
| `goodwill.short` | How promoters feel about working with your gym. | How promoters feel about working with your gym. | 8/15 |
| `goodwill.why` | Pulling out of bouts burns it; more goodwill, more offers. | Pulling out of bouts burns it, and more goodwill brings more offers. | 12/12 |
| `must_answer.short` | Decisions waiting on you before the day can move on. | Decisions waiting on you before the day can move on. | 10/15 |
| `must_answer.why` | Continue stays blocked until each is answered. | CONTINUE stays locked until each one is answered. | 8/12 |
| `continue.short` | Advance time one day; training, costs and news run. | Moves time forward one day while training, costs and news run. | 11/15 |
| `continue.why` | The only way time passes. | It is the only way time passes. | 7/12 |

## 3. Coach lines - `STEPS[].say`

One action per step: the named control is the action; the second sentence is the reason or the risk.

| id | current | proposed | words |
|---|---|---|---|
| `new_career` | I'm your head coach. Let's open a gym and get a fighter to his first bout. | I'm your head coach. Press NEW CAREER and we'll get one fighter to a first bout. | 16 |
| `country` | Pick the country your gym works in. It sets the money, the talent and the shows. | Pick the country your gym works in. It sets the money, the talent and the shows you can get. | 19 |
| `city` | Pick a city. The gyms already there are the ones you will fight. | Pick a city. The gyms already there are your rivals. | 10 |
| `gym` | Name your gym - the name also draws your floor and first fighters. Rest the mouse on any word to see what it means. | Name your gym and press OPEN GYM. The name also decides your starting floor and first fighters. | 17 |
| `the_day` | This is The Day, your home screen. Cash, news and anything dated today live here. | This is THE DAY, your home for cash, news and anything due today. Rest the mouse on any word to see what it means. | 24 |
| `gym_floor` | Open the gym to see your floor and your fighters. | Open GYM to see your floor and your fighters. | 9 |
| `fighters` | Every fighter shows his record, condition and weight. Hover a number to learn what it does. | Read each fighter's card before you plan the week. Rest the mouse on any number to see what it changes. | 20 |
| `training` | Training sets what each fighter works on this week. Hard weeks build skill but tire him. | Open TRAINING and set each fighter's week. Hard weeks build skill and wear them down. | 15 |
| `schedule` | Fights are booked on the schedule. Promoters send offers for dated cards. | Open SCHEDULE. That's where promoters send offers for dated cards. | 10 |
| `offers` | Open the offers. | Open OFFERS and see who wants your fighter. | 8 |
| `fair_match` | For a first bout pick an even match: similar weight, age and experience. | For a first bout, take an EVEN match. That means similar weight, age and experience. | 15 |
| `enter_card` | Accept to book it. He has to make the weight limit on weigh-in day. | Press ENTER THE CARD to book it. Your fighter has to make the limit on weigh-in day. | 17 |
| `back_day` | Back to The Day. Time only moves when you press Continue. | Go back to THE DAY. Nothing moves until you press CONTINUE. | 11 |
| `to_fight_week` | Press Continue to move day by day. Training, costs and news run each day. | Press CONTINUE to move one day at a time. Training, costs and news run every day. | 16 |
| `fight_week` | Fight week: the last days before the bout. Keep it light so he arrives fresh. | Press ENTER FIGHT WEEK. Keep training light now so your fighter arrives fresh. | 13 |
| `weigh_in` | The weigh-in. Over the limit means a fine, or no fight at all. | Take your fighter to the weigh-in. Over the limit means a fine or no fight at all. | 17 |
| `fight_night` | He made weight. On to fight night. | Your fighter made weight. Take them to fight night. | 9 |
| `begin_fight` | Watch the bout. Between rounds you get one instruction for his corner. | Press BEGIN FIGHT and watch. Between rounds you get one instruction for the corner. | 14 |
| `result` | That is the loop: train, book, make weight, fight. The result and any medical suspension are on his card. | That's the whole job, from the gym to the fight. Read the result and any medical suspension, then press BACK TO THE DAY. | 23 |

Step notes:
- `gym`: the old line held two actions (name the gym, hover a word). The hover lesson moves to `the_day`, which already demos a tooltip (`show_tip: "$"`). **Claude:** drop `show_tip: "FLOOR SPACE"` from `gym`, or the tooltip pops up with no line explaining it.
- `fighters`: the old line promised `record, condition and weight` on the card. I can't see the card's fields, and `condition` collides (see below), so the new line names no fields.

## 4. NOT COMPUTED (claims carried over, not checked against the sim)
I kept the meaning of every current `why`. I did not verify these against code, and each one needs checking before it ships:
- `cash.why`: below zero blocks signing, repairs and expansion. Settle by checking the spend gates.
- `pay_vs_market.why`: underpaid offers get refused or hurt morale.
- `sanctioning.why`: unsanctioned bouts get refused or carry penalties.
- `corner.why`: `Sets the fighter's plan for the next round.` K72 found CornerAdvice is speech only, with only `FightPlans.PACES` wired. If the chosen instruction does not reach the next round, use `What you tell the fighter between rounds.` instead (8 words).
- `weight_cut.why`: the old line said cuts `drain condition`. Which stat a cut really costs is NOT COMPUTED, so the new line says `wear the fighter down` without naming one.
- `fair_match`: that `EVEN` means similar weight, age and experience.
- `gym`: that the gym name decides the starting floor and first fighters.
- `fight_night`: the line assumes the fighter made weight. There is no coach line for a missed weigh-in.

## 5. Kit gaps and term clashes
- **`condition` means two things.** The Handbook entry is equipment wear (alias `COND`), `AthleteStatModel.gd` agrees, but `FightRealtime.gd` and K73's region lines use condition for body regions in a fight. Any fighter caption reading `COND 64%` will show the equipment tooltip. Recommendation: rename the term `Equipment condition` (name field, outside this task's scope) and give body condition its own entry.
- `must_answer.why` and `continue` now write the control as `CONTINUE`, matching the button.

## WHAT IS STILL WRONG
1. Everything in section 4 is still NOT COMPUTED.
2. The `condition` clash is unresolved.
3. The miss-weight branch has no coach line.
4. The coach card has no character budget. The longest new line is 24 words; I did not render it at 380px.
5. Nobody has yet checked that the `MOOD` alias for `morale` and the `CLASS` alias for `weight_class` match only the captions they are meant to.

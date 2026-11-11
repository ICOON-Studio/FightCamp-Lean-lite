# HYPE1: the heat around a fighter right now, and the coach's hand in it (S432, v1)

Owner, S432: "is there a hype mechanic for the fighter ? if not can you add a deep one", then "maybe do a research ... about how hype builds
around a fight and a fighter , what role the coach can play into that". Built on `ops/research/HYPE_RESEARCH_S432.md` and its three notes
(`hype_notes/angle1_fighter.md`, `angle2_coach.md`, `angle3_fight_and_games.md`). In this map **[R]** = a number or shape taken from that research,
**[E]** = our estimate, a first guess for the probes in section 9. Every [E] is measured before a screen is drawn.
Drawn: `docs/mockups/s432/hype_fighter.png` (a fighter's Crowd tab) and `docs/mockups/s432/hype_offer.png` (the pro offer read through hype).
Game text never says he, she, her or him. "You" is the head coach (the player); "Coach" is the hired assistant coach.

## 0. Is there a hype mechanic today? (read in the code, S432)
No. What exists:
- FANS for professionals only: `Matchmaking.gd` keeps `fans` from -5 to 12; a win +1 (+1 a step up, +1 a stoppage, -1 a mismatch), a loss -0 to -2;
  `pay_of` sells tickets on fans and how close the fight looks; a top-5 ask needs 3 fans. They never cool.
- The debut's tickets: `ProDebut.tickets_sold` = 20 family + half a ticket a member + 2 an amateur win + 10 a title, at most 100; 60 to break even.
  `ProDebut.night(sold, terms)` already takes a `terms` number nobody varies.
- `ClubShow.draw`: our own show sells on members, reputation, juniors and 25 tickets for each of our boxers on the card.
- `Knowledge.range_of(..., hype)`: a `hype` input that lifts a scouted range's centre (up to 0.3 of its width). Nothing passes it. RPGLAYER1 left it to HYPE1.
- `WeekTwist` card "Rival talks trash": Fire back = +3 members, the corner's fixes land half as well. The club twist (CLUBWEEK v4 3.4) retires WeekTwist;
  this card's idea moves into the call-out (section 4.3).
- CLUBWEEK v4 3.10 (agreed, not built): every boxer gets FANS (people who buy a ticket): +4 a home win, +1 a home loss, +10 a title; they carry into
  the debut and the professional's tickets.
So the game has a LASTING crowd (fans) and nothing for the heat of right now. This map adds that heat, and only that.

## 1. The idea in seven lines
- TWO NUMBERS, NEVER ONE [R: "a single hype meter hides the most useful split"]: FANS last (v4); HYPE is the heat around one fighter right now.
  Fans stay after a loss; hype does not (Buglioni and Simpson kept their crowds; Fisher's buzz went [R]).
- HYPE (0 to 100) has two parts drawn as one bar: BUZZ, the fighter's own talk, built by how they win and cooling every week; and HEAT, this bout's
  build-up (the poster, the paper, a call-out, your prediction), spent on the night.
- Hype SELLS THE NIGHT and TURNS INTO FANS at a rate: that is its receipt [R: "a hype number with no receipt" is the thing to avoid].
- YOU ARE THE COACH IN IT [R: build, shield, lend your name, take the blame]: one STANCE per fighter (SELL, QUIET, SHIELD), the paper or a clip from
  your own pad places, a call-out, your prediction in fight week, and TALK THEM DOWN when it goes to their head.
- It BUYS: a bigger ticket cut, fans, members and the club's name, the pro offer sooner and on better terms, a bigger debut card, a sponsor, mood.
- It COSTS: tougher matching (the scalp), nerves, ego turning a trait, a manager calling a hot amateur, and the crash after a hyped loss.
- Every hype choice is paid in the club week's own coin: pad places, loyalty, mood, favours, the record. Nothing new to manage weekly: no upkeep
  grind [R: Punch Club's fame jobs are the warning]; hype cools by itself and only matters near a bout.

## 2. The numbers: what builds it, what cools it
BANDS (one word everywhere): COLD 0-19, TALKED ABOUT 20-39, WARM 40-59, HOT 60-79, ON FIRE 80-100. The bar shows buzz solid and heat striped.

### 2.1 Buzz: the fighter's own talk (lasts weeks)
| Event | Buzz | Basis |
|---|---|---|
| A win at home | +8 | [E]; [R] the home crowd is the base of everything |
| A win away | +5 | [E] |
| ...over a name above on the ladder | +4 more | [R] competitive matches sell; [E] size |
| ...by stoppage | +6 more | [R] knockouts draw (Ennis); [E] size |
| A win over a name 6 or more points weaker | +1 in all (replaces the above) | [R] the dull win bores the base even while the record stays perfect |
| A regional title or a national medal | +20 | [E]; [R] titles alone fill no hall, so a title is a buzz event, not a ticket event |
| FOUGHT TO ENTERTAIN (section 4.4), any result but a wide points loss | +6 | [R] a loser with a show can out-gain the winner (118K v 53K) |
| FOUGHT SAFE, on a win | -3 | [R] the dull win |
| A loss | buzz x0.5 | [R] shape: demand turns down within days of a loss (Parrot); [E] size |
| A stoppage loss | buzz x0.3 | [R] Fisher stopped: slow rebuild; [E] |
| A loss to a name 6 or more points weaker | buzz x0.2 | [R] hype without pedigree collapses (Parrot, WMMA) |
| Missed weight | -15 | [R] the documented fight-week shock (G89) |
| You pull the fighter out | -10 | [R] pull-outs crash the night (Greaves, Chester) |
| A call-out made and then passed by you | -10 | [E]: talk with no fight |
COOLING, each Monday: buzz x0.85 with no bout booked, x0.93 with one booked (the build-up keeps the name in the paper) [R shape: buzz holds for a
fighter who stays visible, drains when idle (Parrot, Thurman); [E] rates: about 4 weeks to half when idle, 10 when booked].

### 2.2 Heat: this bout's build-up (spent on the night)
Heat belongs to the next booked bout. It sells that night and turns into fans that night, then it is cleared the Monday after.
| Source | Heat | Cost | Basis |
|---|---|---|---|
| The poster: a bout is booked | +3 | none | [R] the two-name poster is the one marketing act with a measured lift (Watanabe 2017, G89) |
| THE PAPER: a piece in the local paper | +10 | one of YOUR pad places that week, or COACH FRONTS IT: one of Coach's evenings (2 pad places) | [R] local papers write up every club show; most quotes come from the coach (angle 3, A3) |
| A CLIP for the club's page | +4, once a week | free, but only on a pad place you hold with that fighter this week | [R] clips bring viewers, not buyers (Hull): small, and heat only |
| YOUR PREDICTION, on the bill | a win +4; the stoppage +10 | landed or missed, section 4.5 | [R] Roach's predictions (De La Hoya in 9, Hatton in 3) |
| A CALL-OUT | +12 | section 4.3 | [R] a rivalry with a story sells (Fisher-Allen, derbies) |
| On our own show's card | +5; the main event +10 | HOSTSHOW1 owns the show | [R] club home shows sell out on local boxers |
| Being called out by a rival (RPGLAYER1 moment 2) | +8 | RPGLAYER1 owns the card | hook only |
With no bout booked, the paper and a clip go to BUZZ at half and cool as buzz does, so the paper is worth most in fight week [R: about 31% of sports
tickets sell in the final week; a promoter reads the curve two weeks out].
TOTAL HYPE = buzz + heat, at most 100. The stance (section 4.1) scales every gain.

## 3. What hype buys (each is a receipt the player can see)
| Receipt | Rule | Basis |
|---|---|---|
| THE TICKET CUT AT HOME | the club's $450 ticket cut becomes $450 x (1 + hype on the night / 100): Warm 50 = $675, On fire 90 = $855 | [R] an amateur sells 20-40 tickets at GBP 12-20 and the boxers' sales are the show's income; [E] size |
| FANS ON THE NIGHT | a win adds hype x 0.15 fans at home, x 0.05 away, on top of v4's +4 a home win; a loss FOUGHT TO ENTERTAIN adds hype x 0.05 at home. Hot 60 and a home win: +9 + 4 = +13 fans | [R] attendance is habit: people who come keep coming; the lift lasts if the new fans are loyal; [E] rates |
| MEMBERS AND THE CLUB'S NAME | a home win while Hot: +2 members and reputation +1 more than today (BoutRules +5); a title or medal while Hot: members +10% over 4 weeks, capped by the premises | [R] Bolton +83 young people in a week after Khan's medal; Ludlow 26 to 70; Harrington's club full at 45-60 |
| THE DEBUT'S TICKETS | ProDebut.tickets_sold adds hype on the night / 2 | [R] a decorated, talked-about amateur sells 300+ at a debut (Sahil Khan) |
| A BIGGER DEBUT CARD | the offer taken while Hot: the debut goes on a bigger card: 150 tickets, not 100 (ProDebut.TICKETS); the boxer's half above break-even x (1 + hype at signing / 200) (ProDebut.night terms: Hot 64 = x1.32) | [R] terms change for big sellers (Irish example); [E] sizes |
| THE OFFER SOONER | Hot at the Monday check: the pro offer comes one win sooner (6 wins and a top-3 rank, or 8 wins) | [R] promoters sign the fighters who sell (Fisher signed after two amateur bouts) |
| PROFESSIONAL BOUTS | Matchmaking.pay_of sells tickets on fans + hype / 2; a top-5 ask needs 30 fans OR Hot | [R] tickets follow the name; [E] |
| A BETTER SLOT AWAY | a Hot amateur on an away card tops the bill: the host pays the $40 travel (verdict change 6) and the club earns +1 favour more | [E]; [R] the coach builds the card at club scale |
| THE FIGHTER'S SPONSOR | the first time a fighter reaches Hot, a local sponsor offers $150 a week for 12 weeks; the deal asks hype 40 or more at each home bout (else it ends) and one of the fighter's pad places a month for photos | [R] trainer Hull ties a sponsor to a fighter selling about 20 tickets; Money's Bow Road Physio pays $150 |
| MOOD | hype 40 or more: mood +2 a week | [E]; [R] fighters say the home crowd lifts them |
| YOUR NAME (the club's) | a fighter you sign starts with buzz = the club's reputation / 5 (at most 20): "trained at Anvil Street"; a month in which a club fighter is Hot, the trial mat's prospect is +3 potential | [R] Wild Card, Kronk and Reynoso drew fighters on the star's name |

## 4. The player's decisions
### 4.1 YOUR STANCE on each fighter: SELL, QUIET or SHIELD (the coach's role, from the research)
One per fighter, on the fighter's Crowd tab and on the Club week row. Changed at most once every 4 weeks. QUIET is the default.
| Stance | What it does (all [E]) | The real coach behind it [R] |
|---|---|---|
| SELL | every buzz and heat gain x1.5; a loss crashes one step deeper (x0.5 becomes x0.3, x0.3 becomes x0.15, x0.2 becomes x0.1); a crash with SELL costs loyalty -3 ("you sold me", not at Trusts you, RPGLAYER1); ego can turn (4.6) | Ingle predicting a world champion for years and parading Hamed before the debut; Tyson's team sending tapes of early knockouts to TV |
| QUIET | as the tables above | most club coaches; Lomachenko's silence |
| SHIELD | gains x0.5, hype held under 50; a loss one step softer (x0.5 becomes x0.7); no nerves; no scalp (4.7); the paper and the call-out cannot be used. PROTECTED: after 8 weeks shielded with 3 or more wins in them, buzz -3 a week and the pro offer needs one win more | D'Amato keeping Patterson from Liston; Hunter's closed camp: Ward great in the ring, weak at the box office |
RPGLAYER1 hook: your coaching style may colour the stances (for example a Family club price on SELL); RPGLAYER1 decides, this map does not.

### 4.2 The paper or a clip (Club week, each fighter's row)
A CROWD cell on each row: NOTHING, A CLIP (free, on one of your pad places with them), THE PAPER (one of your pad places, or Coach fronts it: one of
Coach's evenings, 2 pad places). The cell prints the heat it adds and for which bout ("+15 heat for Sat 11 Apr, SELL"), or "no bout booked: +5 buzz".
The trade is the club week's own: your pad places train the habits only you can fix (v4 3.1), so the paper takes one from a team-mate or a habit.
The club twist "The local paper wants a picture" (v4 3.4) becomes a free paper piece for the fighter you name.

### 4.3 A CALL-OUT (the Crowd tab, or a name on World > Rankings)
- WHO: one name 1 to 5 places above on the regional ladder (the professional table for a professional), same weight. One open call-out a fighter.
  Not under SHIELD, not with a bout inside 7 days.
- AT ONCE: +12 heat, tied to that name. The other corner answers on Monday: 8 in 10 they accept and the name comes on the next sheet as THE NAME ABOVE,
  tagged CALLED OUT; 2 in 10 they ignore it: buzz +3 ("they ducked you"), the heat goes. [E]
- THE BOUT: the called name has trained for you: their tank +4 at the first bell (v4's other corner's week). A win takes their rank even from 5 places
  up (v4: at most 3), +12 buzz more, and fans on the night x1.5. A loss crashes one step deeper and confidence -4 (RPGLAYER1's trait drift), the club's
  reputation -1. Passed by you: buzz -10, reputation -1.
- REAL BASIS: a named rivalry sells (Crawley v Horsham sold out a social club; Fisher-Allen II); the WeekTwist trash-talk card is its seed.

### 4.4 FIGHT TO ENTERTAIN, BOX SMART or FIGHT SAFE (the bout's bill, the corner's word for the night)
| Choice | In the fight (ESTIMATE, CornerJobs and Exchanges) | Hype |
|---|---|---|
| ENTERTAIN | pace starts at Push for rounds 1 and 2; "Let your hands go" is the default shout; both sides' stoppage chances x1.3 | +6 buzz on any result but a wide points loss; fans on a loss at home |
| BOX SMART (default) | as the fight plan says | none |
| SAFE | pace Save; "Jab and move" is the default shout; both sides' stoppage chances x0.7 | -3 buzz on a win |
The bill shows its price on THIS bout: "Entertain: about -2 in 100 to win, +6 buzz, stoppage either way 9 to 12 in 100" (measured by ENTERTAIN1; a
puncher pays little, an out-boxer more). [R] knockouts and wars draw; promoters say fans will not pay for safe wins.

### 4.5 YOUR PREDICTION in fight week (the bill; Roach's lever)
NONE; A WIN (+4 heat; a loss: reputation -1); THE STOPPAGE (+10 heat; landed: reputation +2 and buzz +10; won on points: buzz -4; a loss:
reputation -2 and the crash one step deeper). A Confident fighter (RPGLAYER1 traits) takes confidence +2 from a called stoppage that lands; a fighter
under 45 confidence feels it: nerves at Warm, not only at Hot. [R] predictions and coach feuds became the storyline (Roach v Mayweather Sr).

### 4.6 TALK THEM DOWN (deflate; from Hot)
One of your pad places that week: buzz -15, heat cleared, no nerves at the next bout, the ego roll stops for 4 weeks, mood -4. Shown only at Hot or
On fire. EGO: each Monday at On fire, 1 in 4 that coachability drops 3 (RPGLAYER1's trait drift owns the limit: 10 a season); the Monday review says
it ("Samira: coachability 45 to 42, stopped listening"). [R] Ingle warned that Hamed had stopped listening; coaches warn a prospect off in public.

### 4.7 What hype costs, and the answers to each
| Cost | Rule (all [E]) | The answer the player has | Basis |
|---|---|---|---|
| THE SCALP (tougher matching) | at Hot, the sheet's HOME card opponent is drawn 2 points stronger and trained for you (+4 tank); the NAME ABOVE can come from 4 places up, not 3 | SHIELD removes both; QUIET keeps both; it is also a chance to climb | [R] Fisher built fast and stopped; the other corner wants the local hero |
| NERVES | on the night, hype 60 or more and confidence under 60: round 1 at -0.5 points (Big heart: -0.25) | SHIELD, TALK THEM DOWN, or the RPGLAYER1 traits | [R] Benn, Orie, Buglioni on the weight of the 0 |
| EGO | 4.6 | TALK THEM DOWN | [R] Hamed and Ingle |
| THE MANAGER'S CALL | an amateur Hot for 3 Mondays running with 7 or more wins and no signed offer: a manager calls (a Home need). KEEP THEM CLOSE: one of your pad places, loyalty +3. LET IT RIDE: free; for this fighter v4's outside-manager line moves from loyalty 50 to 60 (under it at turning professional, the club keeps 10%, not 25%) | the call's two answers; the bond (RPGLAYER1) | [R] amateurs who turn professional often sign with a manager outside the club; promoters chase sellers |
| THE CRASH | a loss at Hot or On fire: the buzz cut above, mood -6 more, fans -10% (the people who came for the buzz; v4's home fans never below the count before this bout's hype); SELL or a missed prediction: loyalty -3 and reputation -1 | SHIELD softens it; the record is what you protect | [R] the hometown base forgives, neutral buzz does not; the coach takes the blame (Rubio, Tarverdyan) |
| THE PULL-OUT | pulling a fighter with heat: the home tickets sold on the heat are refunded (the cut above $450), reputation -1, buzz -10 | the injury choice (fight hurt) exists today | [R] Greaves's 7 bouts down to 3; a Chester boxer refunded their own fans |

### 4.8 CASH IT IN OR PROTECT THE RECORD (the pro offer, and the professional's three offers)
- THE PRO OFFER (amateur): taken while Hot, it locks the bigger card (150 tickets) and the terms (x1 + hype / 200) at signing. Declined (v4: back after
  2 more wins at 90% of the terms), the hype at the return is a forecast with its risk: the screen shows both paths' tickets, terms, the club's take and
  the chance that one of the next two bouts is lost (from their win chances), with the crash it would bring.
- A PROFESSIONAL'S OFFERS: PAYDAY and STEP UP sell on hype (tickets on fans + hype / 2); TUNE-UP protects the record but is a dull win (+1 buzz). Each row
  prints its tickets now and what a loss would leave.
- REAL BASIS: promoters move a seller fast "while the crowd is there" (Fisher) and protect a seller's 0 (the "must stay unbeaten to keep selling" category);
  both pay and both cost [R].

### 4.9 The professional and Ana
- Lucy or Josh (the professional): the same rule; the receipts are Matchmaking's tickets on every bout, the ask, the sponsor. The paper is their main heat.
- Ana (the grappler): opens sell no tickets and the belt is the ladder, so no call-out, no entertain, no nerves. Ana's buzz comes from medals (gold +20,
  silver +10) and pays in no-gi members (+1 more at a Hot medal), the sponsor and mood. The stance applies.

## 5. Every decision (B before, D during, A after; the last column is the designer's test, NEVER printed on a screen)
| When | Decision | Options and prices | Right when (never on screen) |
|---|---|---|---|
| B, any Monday, once in 4 weeks | Your stance on a fighter | SELL x1.5 gains, deeper crash, ego, loyalty -3 on a sold crash; QUIET; SHIELD x0.5, cap 50, softer crash, no nerves or scalp, PROTECTED after 8 weeks | Sell: a Confident or Big-heart fighter with the offer or debut inside 8 weeks. Shield: confidence under 50, or a step-up the record cannot take. Quiet: neither |
| B, Monday | The Crowd cell: nothing, a clip, the paper (you or Coach) | Clip free on your pad place with them, +4 heat. Paper: one of your pad places (or 2 of Coach's), +10 heat | Paper: a home bout inside 12 days and no habit needs your pad place. Clip: you already hold a pad place with them. Nothing: no bout booked |
| B, Crowd tab or Rankings | A call-out | +12 heat, the name on the next sheet 8 in 10; win: up to 5 places, buzz +12, fans x1.5; loss: deeper crash, confidence -4, reputation -1; passed: buzz -10 | The name is within 3 points and a win would bring the offer. Not when the win chance is under 40 in 100 |
| B, the sheet | The home card at Hot (tougher) or the name above (further) | Home: the bigger cut, +2 points stronger. Name above: up to 4 places | Home: the bank is short or the debut forecast is under 60. Name above: inside 2 wins of the offer |
| B, the bill | Entertain, box smart, safe | Entertain: about -2 in 100 (by style), +6 buzz, stoppage x1.3; Safe: stoppage x0.7, -3 buzz on a win | Entertain: a puncher, at home, Warm or more. Safe: a cut healing or a weaker opponent |
| B, the bill | Your prediction | None; a win +4 heat; the stoppage +10 heat, landed +2 reputation and +10 buzz | The stoppage: the opponent's file shows a weak chin and the win chance is over 65 in 100 |
| B, Monday at Hot | Talk them down | One of your pad places: buzz -15, no nerves next bout, ego stops 4 weeks, mood -4 | Confidence under 60 and a bout inside 2 weeks, or On fire 2 Mondays running |
| B, Home need | The manager's call | Keep them close: one of your pad places, loyalty +3. Let it ride: the outside-manager line at 60 | Close: the fighter's loyalty is 50 to 65. Ride: loyalty 75 or more |
| B, Money > Deals | The fighter's sponsor | Sign: $150 a week for 12 weeks, hype 40+ at each home bout, one pad place a month. Not now | Sign: home bouts ahead and the stance is not SHIELD |
| A, the offer | Cash it in or protect the record | Turn pro now: bigger card and terms locked while Hot. Not yet: back after 2 more wins at 90%, with the hype forecast and the loss risk shown | Cash in: Hot, and the next two win chances multiply under 0.65. Protect: Warm or less, or both next bouts are 80 in 100 |
| A, a professional's offers | Payday, step up, tune-up (exists) | Each with its tickets from hype now and the crash on a loss | Payday: Hot and the bank short. Tune-up: after a crash |

## 6. Every menu it appears on, and what each is wired to (only what the player can act on; a graphic before any paragraph)
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page > CROWD (new tab, beside Character) | the hype gauge (buzz solid, heat striped, the band words), the 12-week line with its event dots, WHAT MOVED IT (last four, each with its stance factor), the cooling forecast to the next bout, FANS beside it with "+N on a home win tonight", what it buys now and what it costs (locked tiles say what opens them), YOUR STANCE (three cards), THIS WEEK (crowd cell, call-out, prediction, the night's choice, talk them down) | new Hype rule; HypeStance; CallOut; Fans (v4); ProDebut; Matchmaking.pay_of; Loyalty; FighterProfile (mood, confidence, coachability); NextStep |
| Fighter page > Profile | one chip under the name: the band word and the arrow ("Warm, rising"); hover: buzz, heat, the bout it is for | Hype |
| Fighters > Club week | each row: the hype chip; the CROWD cell (nothing, clip, the paper; Coach fronts it); the paper's pad place drawn as a face on the counter; TALK THEM DOWN as a row card at Hot | ClubWeek, ClubDeal, Hype, HypeStance |
| Fighters cards | a flame chip with the band word; corner flag "Manager called" | RosterCards, RosterFlag, Hype |
| Fights (amateur sheet) | on each card: the ticket cut with hype, fans on a win (base + hype), "trained for you" at Hot, CALLED OUT tag, "tops the bill: travel paid" away | BoutSheet (v4), Hype, Fans, Favours, OfferCard |
| Fights (professional) | each offer's tickets from fans + hype, the crash on a loss, the ask's "needs 30 fans or Hot" | ProFights, Matchmaking.pay_of / can_ask, Hype |
| Bout page: the bill | THE NIGHT: Entertain / Box smart / Safe with its price on this bout; YOUR PREDICTION; the heat on the night and the tickets it sells | BoutPage, FightWeek (v4), Hype, LeverSize, CornerJobs |
| World > Rankings | "Call out" on a name 1 to 5 above, with the heat and the risk | World, WorldLadder, CallOut |
| World > News | only lines that touch you: the paper's piece, a call-out answered or ignored, a manager sniffing | News, Hype |
| Fight night | the tale of the tape's crowd line ("Crowd 180, Hot"); nerves on the round-1 tile; the crowd's loop louder with the hype on the night | FightNight, TaleOfTape, Exchanges (nerves), audio crowd bus |
| Result and the Why | HYPE: before, after, each part ("Stoppage +6, Sell x1.5"); FANS earned (base + from hype); the crash in red when it comes | FightWhy, WhyCard, AftermathTiles, Hype, Fans |
| Week review (Monday) | each fighter's hype move with its cause (cooling, the paper, the result); ego lines; the PROTECTED line under SHIELD | WeekReview, ReviewReveal, Hype |
| Home | needs only: a call-out answered, the manager's call, a sponsor waiting, "On fire 2 Mondays: talk them down?" | Home, HomeNeeds, Needs, Hype |
| Pro offer | CASH IT IN or NOT YET, read through hype (drawn: `hype_offer.png`): both paths' tickets, terms, the club's take, the loss risk and the crash, the manager's call if declined while Hot | ProOffer, ProDebut (TICKETS, terms), Roster.check_pro / decline_pro, Hype, Loyalty |
| Club > Money | ticket cuts with the hype part; the fighter's sponsor (Deals); refunds after a pull-out | Money, MoneyPanels, GymBills, Deals, Hype |
| Find a fighter, the trial, the walk-in | a prospect's buzz; their ranges read through it (Knowledge's hype lift: "the talk is louder than the kid"); the trial's watch narrows it (v4) | RecruitPanel, Trial, Knowledge.range_of(hype), Hype |
| Handbook | Words: Hype, Buzz, Heat, Fans, Sell, Shield | Handbook |
THE MECHANIC, MENU BY MENU (the rule: every menu above shows it in the .exe):
| Part | Menus |
|---|---|
| Hype (buzz + heat) | Crowd tab, Profile chip, Club week row, Fighters cards, sheet cards, the bill, Why, Week review, fight night |
| The stance | Crowd tab, Club week row, Week review (PROTECTED) |
| The paper and the clip | Club week crowd cell and counter, Crowd tab, World > News |
| The call-out | Crowd tab, World > Rankings, Fights sheet (tag), Home need, News |
| Entertain / Safe and the prediction | the bill, Crowd tab (this week), fight night, the Why |
| Receipts (tickets, fans, members, debut, offer, sponsor, slot) | sheet cards, Pro offer, Money, Why, Crowd tab tiles |
| Costs (scalp, nerves, ego, the manager's call, the crash) | sheet cards, fight night, Week review, Home, Crowd tab tiles |
THE GOLDEN-PATH STEP (one, inside the club-week golden path): set Samira to SELL; THE PAPER on Thursday of a fight week; ENTERTAIN and THE STOPPAGE on the
bill; a home win: the ticket cut with its hype part on Money, the Why's hype parts and fans from hype, the debut forecast moving on the Crowd tab; a
call-out made the next Monday and answered on the sheet; then the pro offer read through hype and turned down, with the forecast checked a week later.

## 7. How it joins the club week and the RPG layer (hooks, not designs)
| Club week piece (v4) | What hype does with it |
|---|---|
| Pad places (your 2, Coach's evenings) | the paper and talking them down spend them; a clip rides on yours |
| The bout sheet (home, name above, unknown) | the ticket cut and fans by hype; the scalp; the call-out's card; the reach to 4 or 5 places |
| Favours and away travel | a Hot boxer tops an away bill: travel paid, +1 favour |
| Loyalty | a sold crash -3; the manager's call moves the outside-manager line; KEEP THEM CLOSE +3 |
| Mood | +2 a week at Warm; -6 more on a crash; -4 to talk them down |
| Fans | hype turns into fans on the night: the debut's tickets and every professional bout |
| The pro offer and the debut | sooner at Hot; bigger card and terms locked while Hot |
| The trial mat | a Hot month brings a better prospect; a prospect's own buzz lifts the ranges until watched |
RPGLAYER1 hooks (named, not designed here): TRAITS (confidence and heart set nerves; coachability is what ego wears down; a called stoppage moves
confidence), THE BOND (loyalty prices a sold crash and the manager's call; Trusts you skips "you sold me"), THE COACHING STYLE (may price a stance),
THE COACH'S GROWTH (a press area for Coach, or a level-6 "A name in the trade" side that makes the paper cheaper), MOMENTS (moment 2 CALLED OUT pays
in heat; THE MANAGER'S CALL follows the moments' pacing rule: never in a fight week, at most one a week at the club), MARKS (FIRST HOME WIN's +2 fans
stays a fans rule). HOSTSHOW1 hook: our own show's card (+5 heat, main event +10) and its main event picked by hype.

## 8. Real-world numbers this map rests on (from the research)
Club show crowds 200-500 [R]; a boxer sells 20-40 tickets, 10 at a first white-collar night [R]; debut sales 30-70 weak, about 100 the floor, 150-300
good, 300+ strong and usually a known amateur [R]; claimed is not paid (100 becomes about 50, Greaves) [R, left for later]; buzz turns down within days
of a loss, holds for a visible winner [R shape]; about 31% of sports tickets sell in the final week [R]; a medal swells a club (Bolton +83 in a week,
Ludlow 26 to 70) [R]; a coach takes about 10% of a purse [R]; the two-name poster is the one measured marketing lift [R]. No source gives a club-level
fade rate: every cooling number above is ours [E].

## 9. To be measured before the build (on the played bout and the played season, never the harness's average)
THE CUT RULE (v4's, kept): any choice worth under 1.5 wins in 100 on a bout AND with no season effect is cut. Added for hype: a lever that moves under
$150 and under 4 fans in a season is cut, not drawn.
- HYPEFLOW1: a season for each of the four under QUIET, SELL and SHIELD. Targets: QUIET reaches Warm in 1 season in 2; SELL with the paper reaches Hot
  for at least 6 weeks; SHIELD never; nobody stays On fire more than 6 weeks without SELL; the paper in fight week sells at least twice the tickets of
  the paper 3 weeks out (if not, heat and buzz become one number).
- SELLSHIELD1: SELL against SHIELD over a season for a Confident fighter and a Fragile one. SELL must win on money and fans by at least $400 or 8 fans;
  SHIELD must win at least 1.5 in 100 a bout on the Fragile fighter's record; no stance best in more than 2 of 3 line-ups.
- ENTERTAIN1: Entertain's win price by style (out-boxer, pressure, puncher) and its season worth. Kept only if it costs an out-boxer at least 1.5 in 100
  and is worth at least $150 or 4 fans a season to a puncher.
- CALLOUT1: a call-out's value by the rating gap: positive within 3 points, negative past 6; if it is positive everywhere, the tank +4 rises to +8.
- CASHIN1: the pro offer at Hot, cash in against protect, over 1,000 careers: neither best in more than 2 of 3; protecting at Warm is the better path at
  least 1 time in 3.
- CRASH1: a hyped loss costs at least one month's home ticket money; home fans lose at most 10%.
- NERVES1 and SCALP1: each at least 1.5 in 100 on the bout it touches, or cut.
- TICKETCUT1 (inside MONEYFOUR2): hype's ticket part over a season with this line-up: between $600 and $2,000; the sponsor at most a third of it.
- HYPELIFT1: a hyped prospect's lifted ranges mislead a bot that signs on the range centre at least 1 time in 4 when not watched.

## 10. Build order, in small tasks
1. Probes (cloud, pure): HYPEFLOW1, SELLSHIELD1, CASHIN1, ENTERTAIN1, CALLOUT1, CRASH1, then the rest.
2. Pure rule modules with unit tests: Hype (buzz, heat, cooling, gains, crash, conversion to fans and tickets, nerves, scalp, ego roll), HypeStance,
   CallOut. Changes: ProDebut (tickets + hype / 2, a 150 card, terms), Matchmaking.pay_of and can_ask, Roster.check_pro (one win sooner at Hot),
   Knowledge.range_of callers pass a prospect's buzz, BoutRules (members and reputation at Hot), ClubShow (main event), WeekTwist's trash-talk card retired.
3. Screens from the drawings: the Crowd tab (`hype_fighter.png`), the Pro offer (`hype_offer.png`), then the chip, the Club week cell, the sheet card
   lines, the bill's two rows, the Why lines, the Week review lines.
4. The golden-path step in section 6.

## 11. Risks, said plainly
- One more number about a person. Mood is a word, loyalty a bar, hype a flame with a band word; the Crowd tab is the only place all of hype's parts show.
- Hype can become a nag ("cooling!"). Home shows needs only when a choice waits; cooling is never a need.
- Sizes: the money receipts are small against the bank unless hype reaches the debut and the professional bouts; the probes may show amateur hype is
  worth only fans and members. If so, the amateur ticket-cut part is cut and hype stays a fans-and-offer system.
- Every number is ours. No source gives a club fade rate.

## HYPE FOR THIS VERSION
1. HYPE per fighter: buzz (results, entertaining, titles; cools x0.85 idle, x0.93 booked) + heat (poster, the paper, a clip, your prediction, a call-out;
   spent on the night); bands Cold to On fire; one bar, two parts.
2. YOUR STANCE per fighter: SELL, QUIET, SHIELD (with PROTECTED).
3. THE PAPER and A CLIP on Club week, paid in your pad places (or Coach's evening).
4. A CALL-OUT: a name 1 to 5 above, accepted 8 in 10, trained for you, bigger rank prize, deeper crash.
5. ENTERTAIN, BOX SMART or SAFE on the bill; YOUR PREDICTION in fight week.
6. TALK THEM DOWN, and EGO at On fire.
7. RECEIPTS: the home ticket cut, fans on the night, members and reputation at Hot, the debut's tickets, the bigger debut card and terms, the offer one
   win sooner, professional tickets and the top-5 ask, topping an away bill, the fighter's sponsor, mood, your name on new signings and the trial mat.
8. COSTS: the scalp, nerves, ego, the manager's call, the crash, the pull-out refund.
9. CASH IT IN OR PROTECT: the pro offer and a professional's offers read through hype.
10. A prospect's buzz and Knowledge's hype lift on Find a fighter and the trial.

## LEFT FOR LATER
- CLUB V CLUB nights with a team score and a captain's bout, and a show's main event chosen by hype: HOSTSHOW1 (the research's strongest amateur draw).
- REMATCH heat after a close or disputed decision: needs judges with taste (the small living world).
- A rival COACH as a storyline (Frank Doyle of Eastside ABC: feuds, predictions answered): the small living world's rival club.
- CLAIMED AGAINST PAID tickets and the two-week read on our own show (cut or keep a bout when sales are low): HOSTSHOW1.
- CHANGING THE COACH after a heavy loss as the comeback story: needs the rival club and staff moves.
- Fans drifting down after 8 idle weeks (about 3% a month): a fans rule, for FOLLOW1 to size, not hype's.
- A public weigh-in, social follower counts, TV and pay-per-view, world bodies: out of scope (and the research says followers are viewers, not buyers).

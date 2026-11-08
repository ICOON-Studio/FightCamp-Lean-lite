# FightCamp: one list of game mechanics (S401)

For your ruling: IN for Early Access, LATER, or OUT. Menus are finalised only after this list.

Early Access means one gym, up to 8 fighters, an open-ended career with a running pro ladder, boxing and BJJ together (your rulings Q-113, Q-115, Q-116). CURRENT = already in the game today; NEW = an idea or proposal. Size is the work left (S = about 1 session, M = 2-4, L = 5-10; the design's rough guesses). A dash means nothing left to build.

## Counts

- Rows: 103. IN 78, LATER 21, OUT 4.
- CURRENT 56, NEW 47.
- Today in code: BUILT 45, PARTLY 26, NOT BUILT 32.

## Rows that RESHAPE A MENU (8)

- R37 Ask for a fight (a refusal gives its reason) (Fights)
- R41 Camp risk shown for each camp choice (Fight prep)
- R54 Coach runs it, per fighter (Fighters)
- R55 Two fighters, one coach: who gets the pads (Fighter page > Week, Club > People)
- R73 Coach-hours timetable (one pool with pad time) (Club > People)
- R85 A living world: boxers age, peak, retire, arrive; rivals improve (World)
- R92 Home as the Monday page with one next action (Home)
- R102 BJJ on the same week, camp and Why as boxing (Fighter page)

## Approved by you, but I suggest LATER

- R34 Commentary line: because it has no decision and the Why already explains
- R35 Press card in fight week: lowest of the 17 in the design, nothing visible changes
- R59 A named rival gym with a coach and style: because the raid row above gives the pressure
- R88 Named club tiers: because goals carry the shape alone
- R91 In-game editor for the world: named first to drop in the design

## Still your call

- R63 Camp Board card game (Q-S294-117 / 123, you asked to see it first). I suggest closing it and keeping the habits (separate row).
- The static gym picture on Club (the critic says no; I say not before Early Access).
- The two critics split on scars, retired fighters as coaches, and teasing next Monday's twist: all LATER here.


## The week and training

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R01 | Mornings add up to the camp goal | Pick each morning's session and Light/Normal/Hard to land the week on the goal lines (weight, stat, fatigue) | CURRENT | BUILT: rules/WeekPlan.gd, TrainingWeek.gd | Fighter page > Week | - | IN | Core mechanic 1 of your three; the spine of the game | S354; idea 099716215 |
| R02 | The camp phase writes the week; you edit exceptions | Which days to override the coach's week | CURRENT | BUILT: rules/WeekPhase.gd | Fighter page > Week | - | IN | Keeps a week to two minutes | Q-82; idea 163151239 |
| R03 | Camp goal lines and the peak-camp bonus | Hit weight, stat and fatigue lines for a one-fight bonus; a missed weigh-in costs $300 | CURRENT | BUILT: rules/PeakCamp.gd, BoutRules.gd | Fight prep | - | IN | Gives the week a payoff on fight night | S356 |
| R04 | Hard weeks vs injury risk | Push load for faster gains against a higher chance of injury | CURRENT | BUILT: rules/TrainingLoad.gd, InjuryRoll.gd | Fighter page > Week | - | IN | The repeated risk decision of the week | idea 104034749 |
| R05 | Monday twist card | Choose one of two priced answers to the week's event | CURRENT | BUILT: rules/WeekTwist.gd (10 cards, 5 asks) | Home (Monday) | - | IN | Makes the saved week interesting; shows its price | idea 106635523 |
| R06 | She pushes back: overrule or listen | Overrule her ask or give in; trust keeps score | CURRENT | BUILT: rules/PushBack.gd, FighterProfile.gd | Home / Week | - | IN | Links the week to trust and the corner | idea 106635526 |
| R07 | Week review: planned vs actual, with the reason | Read the cause and take the coach's suggestion | CURRENT | BUILT: rules/ReviewReveal.gd, WeekActual.gd, WeekCause.gd | Home (Monday) | S | IN | Fix needed: today it pops up by itself; it becomes the Monday state of Home | idea 106635580; CK refined rule-break 1 |
| R08 | Perk road | Which attributes to build toward which perks | CURRENT | BUILT: rules/PerkRoad.gd | Fighter page | - | IN | The payoff a week of mornings works toward | S354 |
| R09 | Test day: three body tests and personal bests | Nothing to decide; shows the body change for a fighter who is not booked | CURRENT | BUILT: rules/TestDay.gd | Fighter page > History | - | IN | Already built, cheap, feeds Records | S371 |
| R10 | Injuries and suspensions | Rest, rush back or pull her from a bout | CURRENT | BUILT: state/Injuries.gd, rules/InjuryRoll.gd | Fighter page | - | IN | Gives every hard fight a cost | S325 |
| R11 | Every random swing gets a readable reason | Read why it happened and adjust | NEW | PARTLY: rules/WeekCause.gd (gains only; not all swings) | Week review, Why screen | S | IN | Protects the Why, our lead over Corner King; both critics say try | idea 103974457 |
| R12 | Scars change future injury risk | Accept an old injury's higher risk or rest her | NEW | PARTLY: rules/FighterLook.gd (look only) | Fighter page | S | LATER | Critics split (designer try, producer drop); look-only today | ideas 105483024 / 162973750 |
| R13 | Money pushes on training | Pay for extra camp or kit to train harder | NEW | NOT BUILT: none found | Fighter page > Week | M | LATER | Kit budget and the stipend already carry money into training | idea 103974459 |
| R14 | Tease next Monday's twist | See the next event early and plan round it | NEW | NOT BUILT: none found | Home | S | LATER | Critics split; nothing in the week needs it yet | idea 162973753 |

## The fight plan and Playbook

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R15 | Move book with mastery tiers | Which moves to drill and unlock | CURRENT | BUILT: rules/MoveMastery.gd; ui/MoveBook.gd | Playbook > Moves | - | IN | Your own 'really fun to learn from' tab | S359 |
| R16 | Combo lab: own combos and hit rate vs the next opponent | Build a combo; longer is a signature but costs energy | CURRENT | BUILT: rules/OwnCombos.gd, ComboOdds.gd, Combos.gd | Playbook > Combos | - | IN | Core mechanic 2 of your three | S354; idea 099716216 |
| R17 | Game plan on a board: a card for each exchange | Which approach she fights each exchange on | CURRENT | BUILT: rules/PlanFight.gd, PlanLines.gd; ui/GamePlan.gd | Playbook > Game plan | - | IN | Core mechanic 3; the game's reason to exist | S354; idea 099716217 |
| R18 | The plan must bite (a good plan beats a bad one by 30 points) | Nothing directly; makes every plan choice matter | CURRENT | PARTLY: rules/PlanFight.gd, FightWhy.gd, PlanPressure.gd; 59/45/41% measured in S395, target not re-measured | Fight night, Why | L | IN | Build-order rank 3; without it the plan is decoration | STRUCT 5.3 #1; rank 3 |
| R19 | Scout the opponent: file, habits, tape room | Which film to study in camp to reveal a habit | CURRENT | BUILT: rules/OppFile.gd, TapeClips.gd; ui/TapeRoom.gd | Fight prep | - | IN | Gives the plan something to answer | idea 105483021 |
| R20 | Test it: sparring nights run the plan | Which plan to try on which night | CURRENT | BUILT: state/PlanTest.gd, rules/SparNights.gd | Playbook | - | IN | Lets the plan be learned, not guessed | S382 |
| R21 | Test-it accuracy follows scouting | Scout more to trust the test | NEW | PARTLY: rules/OppFile.gd (hides habits until scouted) | Playbook, Fight prep | S | IN | Gives scouting a reason; both critics say try | idea 103974458 |
| R22 | Coach writes a plan if you do not | Write your own or trust the coach's weaker one | CURRENT | BUILT: rules/CoachPlan.gd | Playbook > Game plan | - | IN | Keeps depth optional (rule 1) | STRUCT 5.3a rule 1 |
| R23 | Habits you discover and fix | Spend a corner fix on a habit | CURRENT | BUILT: rules/HabitFix.gd, HabitBeats.gd | Fight night, Playbook | - | IN | Kept even if the card game goes (Q-117) | S309; Q-117 |
| R24 | Fighters who fight differently (styles, traits, fighter model v3) | Who to sign; which plan suits whom | NEW | PARTLY: rules/FighterProfile.gd on main; v3 is on branch cursor/fightermodel3b, NOT on main | Fighters, Playbook | L | IN | What sells over Corner King (its top complaint) | P17; rank 3 |
| R25 | Opponent adapts to your plan by round 2 | Change the line when it stops working | NEW | NOT BUILT: rules/RoundStyle.gd (habits only) | Fight night | M | IN | Makes the plan a living contest; build after fighter model v3 | idea 106015960; STRUCT rule 4 |

## Fight night and corner

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R26 | Corner minute: three fixes, time for two | Pick which fixes to make between rounds | CURRENT | BUILT: fight3d/CornerMinute.gd; rules/CornerCard.gd, CornerJobs.gd | Fight night | - | IN | Your fight-night centrepiece | idea 106635583 |
| R27 | Wrong corner calls cost her trust; a Low fighter ignores shouts | Overrule risk: a bad call she follows costs trust | CURRENT | BUILT: rules/CornerTrust.gd (landed S401; used by BoutNight, LiveRound) | Fight night | - | IN | Gives the corner stakes | ideas 105483022, 106015958 |
| R28 | Cutman: a closing eye, stop it or go on | Stop the fight or risk the eye | NEW | PARTLY: rules/StaffRoles.gd (cutman wage only); no stop-or-go | Fight night | M | IN | Best new fight-night decision; both critics rate it top 8 | idea 106015959 |
| R29 | Scorecards shown after each round | Read the cards and change the plan | NEW | PARTLY: rules/BoutRules.gd (end of bout only) | Fight night | S | IN | Small; makes every fight explainable | idea 106016099 |
| R30 | Why screen: what decided the fight | Learn what to change | CURRENT | BUILT: rules/FightWhy.gd; ui/WhyCard.gd | Fight night | - | IN | Our moat over Corner King | S388 |
| R31 | One concrete change after the Why, carried into the plan | Accept the suggested change for next time | NEW | NOT BUILT: none found | Fight night > Why | S | IN | Closes the loop to chase | CK refined menu 9 |
| R32 | Watch the fight, highlights, or skip it | How much of the night to watch; skip walkout and break | CURRENT | PARTLY: fight3d/ (full and highlights built; skips not found) | Fight night | S | IN | A long career cannot make you watch everything | CK refined menu 9 |
| R33 | Sponsor wants a fight before camp is ready | Take the money or protect readiness | NEW | PARTLY: rules/WeekTwist.gd (photoshoot, short_notice only) | Fights, Home | M | IN | Money against readiness; both critics say try | idea 106607244 |
| R34 | Commentary line | Nothing to decide; shows the plan working | NEW | NOT BUILT: none found | Fight night | S | LATER | You approved this; I suggest later because it has no decision and the Why already explains | P13; Q-120 |
| R35 | Press card in fight week | Talk it up, stay humble, or get under her skin | NEW | NOT BUILT: none found | Fight prep | S | LATER | You approved this; I suggest later: lowest of the 17 in the design, nothing visible changes | P14; Q-120 |

## Booking and the road

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R36 | Amateur bout offers and booking | Accept or turn down an offer; date and weight | CURRENT | BUILT: rules/AmateurBooking.gd; state/Bouts.gd | Fights | - | IN | The base of the career | S294 |
| R37 | Ask for a fight (a refusal gives its reason) **RESHAPES A MENU** | Whom to ask, at what level and date window | NEW | PARTLY: state/ProLadder.gd ask_rows, rules/Matchmaking.gd (pros only; no amateur ask found) | Fights | M | IN | The manager's real job; run the rule-2 bot test first | P1; rank 4 |
| R38 | Scout before you say yes ($250) | Pay to narrow the opponent's range | CURRENT | PARTLY: state/ProLadder.gd scout (pros); amateur not found | Fights | S | IN | Makes scouting a money choice | P1 |
| R39 | Offers pull four ways: rank, growth, money, the unknown | Easy fight or a step up | CURRENT | BUILT: rules/Matchmaking.gd (bot test not verified) | Fights | - | IN | Stops matchmaking being a solved choice | STRUCT 5.3a rule 2 |
| R40 | The Road: the whole ladder with your fighter on it | See where she stands and the next rung | CURRENT | PARTLY: ui/SeasonRoad.gd; ProLadder.road | Fights, Fighter page | S | IN | A plain picture of the long arc | P1 |
| R41 | Camp risk shown for each camp choice **RESHAPES A MENU** | Which camp to run before a fight | NEW | PARTLY: state/CampForecast.gd (dry run exists; risk per choice not verified) | Fight prep | M | IN | One of four things the producer says add to the pitch | CK refined menu 8 |
| R42 | Amateur nationals road | Enter the regional and national draw | CURRENT | BUILT: state/Champs.gd, rules/ChampDraw.gd, SeasonPath.gd | Fights | - | IN | Gives amateurs a goal | S328 |
| R43 | Turn pro: licence, debut, purse | When to turn pro | CURRENT | BUILT: rules/ProDebut.gd | Fights | - | IN | Too soon wrecks a career | K-PROLINE1 |
| R44 | Pro ladder, belts, title fights and defences | Title shot or a safe build-up | CURRENT | PARTLY: state/ProLadder.gd, world/WorldRank.gd (player-side defences not verified) | Fights, World | M | IN | Removes the wall at the pro debut | P3; rank 8 |
| R45 | Pro contract talks: keep share for a bonus, or a lower share | Bonus now or a bigger share later | CURRENT | BUILT: rules/StarDeal.gd | Fighter page | - | IN | A real repeated money choice | S397; idea 106568544 |
| R46 | Sparring supply: pay a visiting partner or use club members | Cash and fit vs free and injury risk | NEW | PARTLY: rules/SparNights.gd (nights only; no partner pool) | Fight prep | M | IN | Ties the gym to camp and the Why | GYM A4; idea 163151244 |
| R47 | Rematches and rivalries across fights | Take the rematch | NEW | PARTLY: rules/RivalPast.gd (history only) | Fights | M | LATER | Needs the running world first | idea 105483025 |
| R48 | Weight class moves | Go up a division or stay | NEW | NOT BUILT: none found | Fighter page | M | LATER | Not in any critic's top list | idea 106568543 |
| R49 | Away shows | Host a show or travel to another club | NEW | NOT BUILT: none found | Fights | M | LATER | Kept on the list by the gym critic | GYM A11 |

## People: fighters, coaches, recruiting

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R50 | Recruit a fighter as an RPG card; trial first | Whom to invite and sign | CURRENT | BUILT: rules/Recruit.gd; ui/RecruitPanel.gd | Fighters | - | IN | Your RPG ask; the first-week hook | S354 |
| R51 | Choose your coach and a starting club | Pick a coach card and one of three starts (also the difficulty) | CURRENT | BUILT: rules/HeadCoach.gd, ClubStart.gd | Start | - | IN | Cheap and answers 'who am I' | P12; Q-121 |
| R52 | A fighter's goal with a deadline | Accept the goal she signs for | CURRENT | BUILT: rules/FighterGoal.gd | Fighter page | - | IN | Needed by the promise system below | S238 |
| R53 | Roster up to 8; places grow with premises and staff | Whom to keep as the club grows | CURRENT | BUILT: state/GymSpend.gd places(): 3/5/7 + staff places (the figure 8 itself not verified) | Fighters | - | IN | You ruled up to 8 (Q-116) | P4; Q-116 |
| R54 | Coach runs it, per fighter **RESHAPES A MENU** | Coach or Me for each fighter's week, offers and camp | NEW | NOT BUILT: ui/RosterTable.gd comment only | Fighters | L | IN | Without it 8 fighters is a chore; hands-on must still win | P4; rank 9 |
| R55 | Two fighters, one coach: who gets the pads **RESHAPES A MENU** | Split scarce coach hours between camps | NEW | NOT BUILT: none found | Fighter page > Week, Club > People | M | IN | Best new week decision; both critics rate it top 8 | idea 106607247 |
| R56 | Staff roles with one visible effect each | Hire, pay or let go | CURRENT | BUILT: rules/StaffRoles.gd | Club > People | - | IN | Covered by your Q-120 | P5 |
| R57 | Staff cards with faces; a members panel (who joined, left, why) | Read who is at risk | NEW | PARTLY: rules/Membership.gd (a smooth number, no joiners or leavers) | Club > People | M | IN | Turns a number into people | CK refined menu 11 |
| R58 | A fighter leaves for a bigger gym (promises, loyalty, poaching) | Match the offer, promise something, or let her go | NEW | NOT BUILT: rules/FighterGoal.gd (goal only) | Fighter page | L | IN | The pressure of years 6-10; build straight after the world runs | P8; GYM A15; Q-120 |
| R59 | A named rival gym with a coach and style | Take the rivalry on | NEW | NOT BUILT: none found | World | L | LATER | You approved this; I suggest later because the raid row above gives the pressure | P9; Q-120 |
| R60 | Career clock: retirement talk and a fights-left forecast | Fight on or stop | NEW | PARTLY: world/WorldAge.gd (world boxers only) | Fighter page | M | IN | An honest end for open-ended careers | P10; Q-113 |
| R61 | Retired fighters come back as coaches | Hire a retired boxer | NEW | NOT BUILT: none found | Club > People | M | LATER | Critics split; needs careers to end first | idea 106568248 |
| R62 | Prospects with a deadline | Sign now or lose her | NEW | NOT BUILT: none found | Fighters | S | LATER | Not shown to be needed | CK refined menu 14 |
| R63 | Camp Board card game (coach plays cards to plan the week) | Remove it and keep habits, or keep it | CURRENT | NOT BUILT: not found in this build (built S390 in the old project per the design) | Home | - | OUT | Your call, still open: you asked 'Show me it first'. I suggest closing it | Q-117 / Q-123 |

## The gym and money

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R64 | Weekly bills, runway, and a club that can close | Spend or hold cash; closes after 4 weeks below $0 | CURRENT | BUILT: rules/GymBills.gd, state/Career.gd | Club > Money | - | IN | Our lead over Corner King (no failure state there) | S324 |
| R65 | Dues bands: cheap, standard, premium | Set the price against how many members | CURRENT | PARTLY: rules/Membership.gd lines 23-65: premium wins at every reputation, so no real choice | Club > Money | S | IN | True defect: fix first; the recruiting row below gives it an identity | GYM verdict |
| R66 | Kit budget low, standard, good | Save cash or lower injury risk | CURRENT | BUILT: state/GymSpend.gd | Club > Money | - | IN | Real but mild trade-off | S397 |
| R67 | Upgrades list and premises tiers | What to buy and when to move up | CURRENT | BUILT: rules/GymUpgrades.gd | Club > Money | - | IN | You said yes to a plain list (Q-114); no gym floor | P11; Q-114 |
| R68 | Stipend or day job for an amateur | Pace vs cash | CURRENT | BUILT: state/Career.gd; state/Data.gd ($250 stipend) | Fighter page | - | IN | The best real choice in the gym layer | GYM section 1 |
| R69 | Club show: pay up front, sell tickets, may lose money | Run a show now or wait | CURRENT | BUILT: rules/ClubShow.gd | Club > Money, Fights | - | IN | An event gamble for a young club | S397 |
| R70 | Overdraft and grant bids | Borrow, or bid for a grant once a year | CURRENT | BUILT: rules/Overdraft.gd, Grants.gd | Club > Money | - | IN | Gives late money a job | S397, S399 |
| R71 | Youth section and junior intakes | How much to spend on juniors | CURRENT | BUILT: state/HomeJuniors.gd; rules/GymUpgrades.gd | Club > Money | - | IN | Members become the talent pipeline | P11 |
| R72 | Who we recruit: white-collar nights or estate kids | Premium dues vs more prospects | NEW | NOT BUILT: none found | Club > People | M | IN | Fixes the dead dues choice with an identity | GYM A3 |
| R73 | Coach-hours timetable (one pool with pad time) **RESHAPES A MENU** | Give coach hours to beginners, kids, sparring or fitness | NEW | NOT BUILT: none found (a cap of 40 members a coach sits in StaffRoles.gd) | Club > People | M | IN | What every tycoon has and we lack; feeds the week | GYM A1 |
| R74 | The 90-day cliff: new joiners at risk | Spend coach time on new joiners or on a prospect | NEW | NOT BUILT: none found | Club > People | M | IN | Folded into the timetable; vendor figures only | GYM A2 |
| R75 | Volunteer or paid coach | Free but unreliable vs $280 reliable | NEW | NOT BUILT: none found | Club > People | S | LATER | Kept on the list; small | GYM A5 |
| R76 | Sparring policy: open for all or coached only | Talent found vs injury and insurance | NEW | NOT BUILT: none found | Club > Money | S | LATER | Kept on the list | GYM A6 |
| R77 | Dust period when you move or fit out | Start the move now or wait | NEW | NOT BUILT: none found | Club > Money | S | LATER | Kept on the list | GYM A8 |
| R78 | Changing rooms upgrade | Changing rooms or the strength corner | NEW | NOT BUILT: none found | Club > Money | S | LATER | Kept on the list | GYM A9 |
| R79 | Coach course | Send a coach away for 3 weeks | NEW | NOT BUILT: none found | Club > People | S | LATER | Kept on the list | GYM A12 |
| R80 | January intake course | Run a beginners' course or save the hours | NEW | NOT BUILT: none found | Home, Club | S | LATER | Kept on the list | GYM A14 |
| R81 | Sponsor line and per-fighter costs | Chase a sponsor; see each fighter's cost | NEW | NOT BUILT: none found | Club > Money | M | LATER | Wait until there are 3+ fighters | CK refined menu 10 |
| R82 | One static gym picture on the Club page | Nothing; hotspots open existing cards | NEW | NOT BUILT: none found | Club | M | LATER | Your call: the critic says no; I say not before Early Access | GYM section 6 |
| R83 | Lease length, ticket price, reception requests, fixed power price | Four small gym choices | NEW | NOT BUILT: none found | Club > Money | S | OUT | Dropped by the gym critic | GYM A7, A10, A13, A16 |
| R84 | Visible-gym ideas: zones, stations, halls, seating, desk | Place and resize rooms | NEW | NOT BUILT: none found | Club | L | OUT | Needs a gym floor; you shelved it | GYM B1-B6 |

## The world

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R85 | A living world: boxers age, peak, retire, arrive; rivals improve **RESHAPES A MENU** | No direct choice; every offer and ranking depends on it | CURRENT | PARTLY: world/WorldGen.gd, WorldAge.gd, WorldSim.gd built; the World screen is 8 rows | World | L | IN | You ruled open-ended (Q-113); the biggest job | P2; rank 7 |
| R86 | Rankings that move by taking places | Pick fights that move you | CURRENT | BUILT: world/WorldRank.gd | World, Fights | - | IN | Simple to read | P1 |
| R87 | Year review and three club goals | Pick three goals for next year | NEW | NOT BUILT: none found | Home (first Monday) | M | IN | Gives a long game its shape | P6; rank 11 |
| R88 | Named club tiers | Nothing directly; unlocks better prospects | NEW | NOT BUILT: none found | Club | M | LATER | You approved this; I suggest later because goals carry the shape alone | P6; Q-120 |
| R89 | Record book: champions, reigns, rivalries, your club's history | Nothing; the pride screen | NEW | PARTLY: rules/Records.gd (your own log only) | Club > Records | S | IN | Cheap; a named gap in rival games | P7 |
| R90 | The world in open files | Fans edit names, clubs, belts | CURRENT | PARTLY: assets/data/world/*.json; Handbook words in an open file | none | S | IN | You said yes (Q-118); cheap if kept from the start | P16; Q-118 |
| R91 | In-game editor for the world | Fans edit in the game | NEW | NOT BUILT: none found | Title screen | M | LATER | You approved this; I suggest later: named first to drop in the design | P16; Q-120 |

## Time and comfort

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R92 | Home as the Monday page with one next action **RESHAPES A MENU** | The one thing to do next; a fight-day state with a countdown | NEW | PARTLY: ui/areas/Home.gd; state/Needs.gd | Home | M | IN | Home does not pay off the spine yet | CK refined menu 1 |
| R93 | CONTINUE says what stops time; Simulate to the next stop | Run to the next decision | CURRENT | PARTLY: state/Needs.gd (NEEDS YOU); simulate-to-stop not found | Top bar | M | IN | Makes 20 weeks not a click chore | CK refined menu 13 |
| R94 | Autosave, Settings, Handbook | Text size, window, going back a week | CURRENT | BUILT: state/AutoSave.gd, Settings.gd; ui/HandbookPanel.gd | Title, Top bar | - | IN | The first things a reviewer opens | P15 |
| R95 | First hour: first offer, first show | Whom to sign first and the first bout | CURRENT | BUILT: rules/FirstHour.gd | Home | - | IN | Fix needed: the guide strip stays on every page at week 20 | P12; rank 5 |

## BJJ (no-gi, ships with boxing)

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R96 | Belt road and stripes | Enter, promote, and when | CURRENT | BUILT: rules/BeltRoad.gd; state/Grapplers.gd | Fighter page (BJJ) | - | IN | You ruled BJJ launches together (Q-115) | S353; Q-115 |
| R97 | The stripe as a choice: now, hold, early | Take the stripe now or wait | CURRENT | BUILT: rules/StripeCall.gd | Fighter page (BJJ) | - | IN | A real cost either way | S363 |
| R98 | BJJ week: classes drill the syllabus | Which move she works on | CURRENT | BUILT: rules/NoGi.gd | Fighter page (BJJ) | - | IN | Your training overview idea | S353 |
| R99 | Belt match: you call her next move | Choose each move on the grappling graph | CURRENT | BUILT: rules/BjjMatch.gd | Fight night (BJJ) | - | IN | The BJJ equivalent of the corner | S369 |
| R100 | Open tournaments with brackets | Which open to enter | CURRENT | BUILT: rules/BjjOpen.gd, NoGi.gd | Fights (BJJ) | - | IN | Gives BJJ a calendar | S384 |
| R101 | BJJ classes as a business | Hire a class coach; grow members | CURRENT | PARTLY: rules/BjjSide.gd (module; wiring not verified) | Club > Money | S | IN | Monthly members who stay | S365 |
| R102 | BJJ on the same week, camp and Why as boxing **RESHAPES A MENU** | Plan a grappler's week like a boxer's | NEW | PARTLY: rules/Bjj*.gd and ui/areas/GrapplerPage.gd run a separate path | Fighter page | L | IN | You ruled launch together; one rulebook, not two | rank 10; Q-115 |

## Removed ideas

| Row | Mechanic | What you decide | Kind | Today (code) | Menu | Size | Rec | Why | Source |
|---|---|---|---|---|---|---|---|---|---|
| R103 | Removed ideas (13): gym culture spreads, legacy, hall of fame wall, visible ageing, retirement montage, rival gym poaching members, crowd sways rounds, walkout song and robe, top-down stool view, sponsor logos on shorts, members train in the background, gym by time of day and season, marker squeak | Nothing | NEW | NOT BUILT: none | none | - | OUT | Both critics dropped them; restorable on the Miro REMOVED frame | IDEAS_VERDICT |

## What I could not verify

- Status is from reading file headers and grepping scripts/rules, scripts/state, scripts/world and scripts/ui. I did not run any test or the game, so BUILT means the code exists, not that it is wired into every screen or plays well.
- The 59/45/41% plan result and the 30-point target come from the S395 design; I did not re-measure.
- Whether an amateur can Ask for a fight or scout (only the pro ladder has them), whether the player's fighters get title defences, and whether Matchmaking's bot test passes: not verified.
- Roster 'up to 8': places are 3/5/7 by premises plus staff places; I did not find the number 8 itself.
- BjjSide.gd (BJJ classes as a business) exists as a module; I did not confirm it is wired.
- The Camp Board card game: no trace in this repo's scripts; the design says it was built in S390 in the old project.
- Fighter model v3 is on branch cursor/fightermodel3b only; I did not read it. Corner trust is on main (rules/CornerTrust.gd, used by BoutNight and LiveRound).
- Gym-idea facts (retention figures, real club practice) are from the gym critic's notes, partly from memory in that document. Sizes S/M/L are the design's rough guesses, mine for rows it did not size.
- 'Removed ideas' is one row; the 13 names are as listed in IDEAS_VERDICT.md.

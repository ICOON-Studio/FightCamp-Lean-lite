# The gym layer against tycoon and sim games (S401)

Read first: YARDSTICK rulings (one top bar + modals, only actionable info, deeper not wider, whiteboard look, no flavour text). Nothing
here asks for an "economic management" page: every idea lives on a screen that exists (Club > People / Money, Home whiteboard, the Week).
Marks: [code] read in the repo this session. [web] seen in a page I opened or a search result. [mem] from memory, NOT checked.

## 1. What our gym layer is today [code]
| Decision | How often | What it changes | Real choice or one-off? |
|---|---|---|---|
| Dues band cheap $25 / standard $35 / premium $45 | any time | member target x draw 1.15 / 1.0 / 0.85 | LOOKS like a choice, is NOT: income per slot is 28.75 / 35 / 38.25, so premium wins at any reputation; when the coaches or the place cap the count (most of the game) premium wins by more. Only side effect I found: show tickets scale a little with members. I did not check every reader of `members`. |
| Kit budget low $0 / std $45 / good $80 a week | any time | injury risk x1.25 / 1.0 / 0.90 (+2 members on Good) | Real but mild: Low is free money until a key boxer is hurt. |
| Upgrades: mats $2,400, strength $3,600, fitness kit $1,500, youth $1,800 | 4 purchases, ever | one number each (risk -15%, gains +10%, +$420/week, juniors + prospects) | One-off buys. Fitness kit needs the $280 assistant and nets about +$125/week: close to a free win. Youth nets about -$53/week on paper (juniors' dues $115 less coach $168): the one honest sacrifice, paid back in prospects and grants. |
| Premises: 3 tiers (cap 70 / 140 / 250, rent $1.8k / 3.4k / 5.5k, moving $12k / $25k) | twice in a whole career | members cap, roster places, a sponsor offer | One-off, and a good one: the double cap (place vs coaches) is printed in words on the card. |
| Staff: assistant $280, S&C $100, physio $75, cutman $150 a night; evening coaches $280 each | hire/let go any time; letting go costs a week's pay | one number each; coach cap 40 members per coach | Hire-and-forget, except evening coaches, which track growth. |
| Stipend per amateur: full time $250, or day job and 15% less gain | per boxer, rare | training pace vs cash | Real choice (the best one in the layer). |
| Club show every 16 weeks, $3,500 up front, luck 0.7-1.15, raffle | 3 a year at most | cash, up to +1 member per 40 tickets | A gamble for a young club (my sums: a 30-member, 1-boxer club loses about $1.2k at bad luck); a no-brainer once the club has 60+ members. |
| Pro contract talks (top 10, belt, then yearly): keep share for a bonus, or take a lower share | 2-3 times per pro, then yearly | the gym's cut (25% down to 12%) | Real and well shaped. |
| Grant bid, overdraft switch, start card, sponsor deals | yearly / once | cash | Timers and one-time switches, not trade-offs. |
Verdict: about two real recurring choices (stipends, kit) and one event gamble (the show). The rest is buy-once. Money pressure is honest
(rent, power by season, insurance, fees, 8 weeks in the red closes the gym, "leaves $X, 7 weeks of costs" on every buy) but the player has
few levers to pull each week. Membership is a smooth walk toward a target (`step_members`: no joins, no leavers, no types of member).

## 2. Game by game: the one mechanic that makes running the place fun
| Game | What the player decides | Pressure that forces it | How the result is shown |
|---|---|---|---|
| Two Point Hospital / Museum [mem + web reviews] | where rooms go, which staff, which exhibit/illness line to chase for stars | queues, staff tiredness, star goals that tighten | overlays, ratings, star list; criticised for staff chores and an unclear "what next" [web] |
| Mad Games Tycoon 2 [mem + Steam threads] | which genre and audience each product targets, who works where, who trains | deadlines, market trend, staff wages | review score per product; players call it micro-heavy and training slow [web] |
| Game Dev Tycoon [mem] | slider mix per development phase, topic and genre pairing | cash runway, a fixed deadline per project | review scores broken down by slider |
| Project Hospital [mem] | which departments, which tests and shifts, who treats whom | patient flow, doctor hours | patient chart and department load |
| Planet Zoo / Coaster [mem] | prices, animal or ride mix, what each guest or animal needs | satisfaction and welfare ratings | per-guest thoughts, welfare bars |
| RimWorld [mem] | who does which job, how to answer an incident | needs/mood, raids and breakdowns | mood bars, event letters |
| Prison Architect [mem] | the daily regime: which hour is work, yard, meals | riots when a need is starved | the schedule grid itself |
| Gym tycoons (Gym Empire idle; Gym Tycoon, delisted) [web, store pages only] | hire staff, buy kit, train clients yourself | a growing client count | idle-game numbers; I found no review text worth quoting |
| Corner King's gym layer [code-study notes] | facility levels, a roster cap with a $2,500 weekly fine, poaching offers | none that ends the game (no failure state) | email text; nothing explains why |
The shape that matters for us: Prison Architect's weekly schedule (a few scarce hours given to competing needs) and Mad Games Tycoon's
"who is this product for". Both are menus, not buildings.

## 3. Gaps and where we are ahead
Gaps that matter here:
1. No schedule for the gym's own hours. The week planner schedules the fighters; the club's coach hours only appear as a member cap number.
2. No kinds of member. 30 identical members walk toward a number. Real clubs have beginners, kids, fitness, competitors, and they leave in different ways.
3. No incidents that force a choice (RimWorld). Our twist cards exist for the week, but the gym has only the heating bill.
4. No cost to growth beyond a bigger cap: a move is instant. Real expansion means dust, lost classes and a signed lease.
5. No supply side for sparring. Fighters can only spar with each other; real clubs live on who turns up.
Where ours is already better: real cost numbers with a sourced basis; a runway line and a club that can close (Two Point has no loss state,
Corner King has none); every buy shows the cash left in weeks; a double cap (place vs coaches); contract talks that never slide silently; and
the link to the fighter (injury, camp bills, stipends) which tycoons lack: nothing in a tycoon touches a person's career the way ours touches Lucy's.

## 4. IDEAS (22). Format: name | the decision (X or Y) | pressure | where on screen | real-world basis | inspired by | size | cost of ignoring
Real-world column: [mem] unless marked. Verdict column of the owner's removed list: none of these is a removed idea; 15 reuses nothing removed.

### A. WORKS WITH THE CURRENT MENUS (no gym floor)
| # | Name | Decision | Pressure | Screen | Real basis | Shape from | Size | Ignore it |
|---|---|---|---|---|---|---|---|---|
| A1 | Coach-hours timetable | give a coach's weekly hours to beginners' class, kids, sparring night or fitness class (X or Y) | coach hours cap (40 members a coach already in code); each class slot has a different payoff | Club > People, a 6-10 slot grid; a sticky note on Home | clubs run fixed weekly sessions, kids early evening, sparring one night [mem] | Prison Architect regime | M | Default timetable runs; fewer joins, sparring weaker; no failure |
| A2 | The 90-day cliff | spend coach time on the new-joiner group (retention) or on the prospect's pads | new joiners quit early: about 1 in 5 inside 90 days, then 2-3.5% a month [J8, vendor figures] | Club > People card "Joined this month 9, 3 at risk", one button | J8 N19 | RimWorld mood, ours | M | member count slides, dues fall, runway shortens |
| A3 | Who we recruit | push white-collar/fitness (premium, high dues, few talents) or the estate kids (cheap, more prospects, grant-friendly) | one recruiting focus at a time; coach and room caps | Club > People, 3-way setting | boxing clubs report engaging deprived areas [web: England Boxing] and run white-collar nights [mem] | Mad Games Tycoon target audience | M | mix stays default; prospect flow flat |
| A4 | Sparring supply | pay a visiting partner (cash, right weight and style) or spar club members (free, injury risk, wrong size) | fight 3 weeks out; weight class fixed | Fighter week, a slot on the fight plan page; Q190 research exists | clubs travel or swap sparring [mem] | ours | M | camp sparring quality drops; the Why shows it |
| A5 | Volunteer or paid | take a volunteer coach (free, sometimes does not turn up, class cancelled) or the $280 assistant (reliable) | coach cap; runway | Club > People | UK clubs rely on volunteers; code already has 30 volunteer members | RimWorld jobs | S | cap stays low, growth stalls at the volunteer number |
| A6 | Sparring policy | open sparring for all (talent found, injuries, insurance up) or coached-only (safe, slower) | injury cost; insurance line already in bills | Club > Money, one switch | public liability insurance is a real line [code]; claims raise it [mem] | RimWorld policies | S | default; a bad injury becomes a news item with no earlier choice |
| A7 | Lease length | 5-year lease (rent down, cannot move up a tier without paying out) or rolling (rent up, free to move) | rent is the one growing bill | Club > Money > Premises | commercial leases run in years [mem] | ours | S | rent keeps the default; nothing |
| A8 | Dust period | start the move or fit-out now (members -15% for about 6 weeks) or wait for a quiet month | the show date and a pro camp need members | Club > Money, "works" chip with a countdown | build-a-wing loses 15-25% capacity meanwhile [G118, proxy] | Two Point build pause | S | moves stay instant and free of timing |
| A9 | Changing rooms | spend $8-25k on changing rooms (opens women's and after-work classes) or on the strength corner | one budget | Club > Money, upgrade row | G118 ranks it second after a kids' hall | Two Point unlock | S | segments stay shut |
| A10 | Ticket price and format | $15 standing hall (full, thin margin) or $40 seated (smaller, richer) | hall 400; luck 0.7-1.15 | Club show card, 2 buttons | clubs choose seated or standing [mem] | Planet Zoo prices | S | $25 default |
| A11 | Away shows | host a show (cost, gate) or take the boxers to another club (cheap, no gate, fatigue) | bouts needed for ranking; cash | Fights tab, a second card beside the show | clubs swap bouts [mem] | ours | M | one show every 16 weeks is the only home fight source |
| A12 | Coach course | send a coach on the badge course (3 weeks of fewer hours, about $400) or keep sessions running | the coach cap drops while away | Club > People coach card | coach badges and renewals are a real cost [code: $400 a year] | Two Point staff training | S | coach stays at today's quality |
| A13 | Reception requests | say yes to one member request this week (a women's class) or no | each yes eats coach hours | a sticky note on Home | members ask for classes [mem] | Planet Zoo needs | S | requests lapse, a few members drift |
| A14 | Intake course | run a 6-week beginners' course in January (pay coach, fill the gym) or save the hours | January joiners are real, Q1 growth [J8 N20] | Home note + Club > People | J8 | ours | S | a flat January |
| A15 | Fighter leaves | let a boxer go to a bigger gym for a fee, or keep him unhappy and cheap | wants more than the share he has | Contract talks card | amateurs move clubs; pros' managers move them [mem] | Corner King poaching, shape only | M | the star simply stays |
| A16 | Fixed power price | lock winter power at a flat rate or float | winter $560 vs summer $280 [code] | Club > Money, one row | real fixed-rate contracts [mem] | ours | S | cost rises or falls with weather |

### B. NEEDS A VISIBLE GYM (floor, rooms or a view)
| # | Name | Decision | Pressure | Screen | Real basis | Shape from | Size | Ignore it |
|---|---|---|---|---|---|---|---|---|
| B1 | Zone split | ring, mats or strength corner for a fixed unit (X or Y) | 1,500 sq ft; a 4.5 m ring needs about 7.5 x 7.5 m | flat plan, bars you resize | G118 (ring kills open-mat revenue) | Two Point rooms | L | default layout |
| B2 | Stations at peak | four more bags (class rotates) or a longer session | peak 17:00-21:00; a heavy bag holds one person [J8] | plan with a 19:00 heat strip | G118/J8 | Planet Zoo queues | M | peak queues eat retention |
| B3 | Two halls, two lanes | kids on mat 2 while adults roll, or sparring uses both halls | second hall only at tier 2 | plan with two timetable lanes | G118: parallel slots are growth | Prison Architect regime | M | one lane only |
| B4 | Sparring floor area | 2 pairs per ring (safe) or 3 (more rounds) | sq ft per person | ring on the plan, pairs shown | G88 crowded floor | RimWorld | M | default |
| B5 | Show seating | seat map: chairs or standing | hall 400 | hall plan on the show card | clubs set out chairs [mem] | Two Point | M | ticket number default |
| B6 | Desk sightline | desk near the door (walk-in conversion, less floor) or more floor | floor area | plan | G118 (desk with sightline) | ours | S | walk-in rate default |

## 5. My top 5 of all 22, and the 3 I would not build
1. A1 Coach-hours timetable: the one thing every tycoon has that we lack, and it feeds the fighter's week directly (scarce hours).
2. A3 Who we recruit: gives the club an identity, feeds the prospect flow and the grant story, and fixes the dead dues choice if the premium band also costs prospects.
3. A2 The 90-day cliff: turns the smooth member walk into people; M, no new screen.
4. A4 Sparring supply: ties the gym to camp and to the Why; money against fight quality.
5. A12 Coach course: small, plain, raises the fight-plan line count the staff card already shows.
Also fix now (not an idea): the dues bands. Premium dominates by arithmetic; give cheap a prospect/loyalty benefit or premium a retention cost.
Would not build, though they sound good:
- A star or "club standard" ladder: Two Point's stars are called unclear and a chore [web]; our goals are already the fight plan and the Why.
- Free room placement with adjacency (noise, flow, sightlines): it is decor with no decision and it re-opens the floor the owner shelved.
- Maintenance breakdown jobs (ring ropes, bag chains): a chore with one right answer; the kit budget already carries that trade-off.

## 6. Should the visible gym come back before Early Access?
For: the Two Point and Mad Games reviews are built on "look what we built" and ours is a text list; the owner's own notes say money stops
mattering and "look what we built needs something to show". A view makes upgrades feel owned. Against: the whiteboard look is chosen; the
lead over Corner King is the Why, the plan and the corner, not rooms; deeper not wider; the 3D fight already competes for the art and
engineering budget; room-building needs pathing, art and balance for a game that is one gym and three boxers; most B ideas are L or M and
are decor beyond B1-B3. Most of the fun in section 4 does not need a floor.
Recommendation: no room-building and no moving people before EA. Do build the smallest view, one static illustrated cross-section of the
unit on Club (hotspots: ring, mats, bag wall, strength corner, changing rooms, desk) that fills as upgrades are bought, with each hotspot
opening the existing card; one art set, no simulation. Revisit B1 (a flat zone-split plan) only if the A-group ideas land and players ask.

## Sources
[web] Two Point Museum reviews via search: player2.net.au, gamingtrend.com, pcgamer.com/games/sim/two-point-museum-review, lootlevelchill.com.
[web] Mad Games Tycoon 2 Steam discussions steamcommunity.com/app/1342330 and patch notes steamdb.info/patchnotes/6189722.
[web] Steam store pages: Gym Empire (756300), Gym Tycoon (1339500, delisted), a co-op gym sim (4436790, unreleased). Store pages only.
[web] England Boxing: englandboxing.org club membership policy, club funding and deprived-areas pages (grants, club support, defibrillator rule).
[code] Membership, GymUpgrades, GymBills, StaffRoles, ClubShow, ClubStart, StarDeal, Overdraft, GymSpend, ClubSpend; screens 25_facilities and 28_members.
[docs] YARDSTICK, IDEAS_VERDICT, STRUCTURE_DESIGN_S395, G118, J8, notes_s395_systems (Corner King).
NOT VERIFIED: Project Hospital, Planet Zoo, RimWorld, Prison Architect, Game Dev Tycoon rows are from memory. Two Point reviews were a search
summary, not read in full. No review text for any real gym tycoon was found. Retention figures are J8's vendor numbers, not mine. Club
timetables, hall hire, volunteers, seated shows, coach badges and lease terms are from memory; England Boxing pages did not cover them.
Dues dominance rests on `members` having no other reader that I checked; Sim.gd and the Fights code were not read.

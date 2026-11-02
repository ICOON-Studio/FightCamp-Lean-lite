# Two Point Museum - economy and progression of a fresh level (S277 study)

Operator S243: "we are not copying anything do it"; S277: "finish your ghidra on 2point and mega games"; S277 direction for the
new career start: "focus on the new start, blank gym player designs everything with limited budget , and slowly everything
tightens on the loop". This file holds NUMBERS, RULES AND STRUCTURE ONLY. No code, text, art or asset of theirs enters the repo.
Every FightCamp value is set by us, using these numbers as reference points.

## Method and sources
- Install: E:\SteamLibrary\steamapps\common\Two Point Museum (Unity 6000.0.63f1, IL2CPP). Python UnityPy 1.25.3,
  FALLBACK_UNITY_VERSION 6000.0.63f1, `read_typetree()` on the shipped config ScriptableObjects, run at IDLE priority (ctypes
  SetPriorityClass; psutil is not installed). Watchdog checked before each heavy step (AMBER 76-78 C, never RED).
- Bundles read by NAME only: configs_assets_all / configs-common / configs-metagame / configs-app. Cross-bundle references
  (staff archetypes, level configs) were resolved by reading only the UnityFS header and block table of each bundle (CAB name ->
  bundle file, a few KB per file). Then the 5 small hashed bundles that hold those objects were opened, and nothing else.
- Identifier names: the existing metadata_strings.txt dump of global-metadata.dat. REA (the IL2CPP metadata decoder the
  coordinator named) was NOT run: it is a third-party binary from an unverified GitHub source, and every number below comes from
  config typetrees, so it was not needed.
- Scripts + raw JSON dumps (outside the repo): E:\FightCamp\tmp\tpm_study\economy\ (list_configs.py, dump_by_name.py,
  dump_by_pid.py, cab_index.py, resolve_ext.py, show.py; dump\*.json; city_objectives_compact.txt; rooms_econ.txt).
- Curves: TPM stores most tunables as a parametric curve {type, minX..maxX -> minY..maxY, factor}. The ENDPOINTS below are exact.
  The shape between them (type 0-3, factor) is code and was not decoded.

## 1. Level start
| Level (Config_FinanceManager_*) | InitialBalance |
|---|---|
| City (first level, tutorial) | 100,000 |
| Coastal, TreeTops, Wildlife DLC, Pleasure Garden DLC | 150,000 |
| Bob DLC | 175,000 |
| Desert | 200,000 |
| Arctic | 0 (starts broke; its grant threshold drops to 100,000) |
- Sandbox presets (Config_GameMode_Sandbox), the clearest "difficulty = a few multipliers" table:
| Preset | Cash | Kudosh | Donations x | Salaries x | Monthly grant max | Everything unlocked |
|---|---|---|---|---|---|---|
| Creative | 1,000,000 | 1,000 | 1.5 | 0.5 | 10,000 | yes |
| Career | 250,000 | 100 | 1.0 | 1.0 | 7,000 | no |
| Hardcore | 50,000 | 0 | 0.75 | 1.25 | 5,000 | no |
- Second currency at career start: InitialKudosh = 5 (Config_Metagame).
- Starting building state: the building is a room type (Room_Building, 0 flat + 100/cell, min 5x5, cap 1,000 + 2/cell). The City
  scene's pre-placed content lives in the level scene, not in configs, so it was not read. The tutorial flow shows the state:
  a museum shell exists, a few starter exhibits arrive in crates, NO staff (objective 3 hires the first expert, objective 6 the
  first assistant), no ticket desk (objective 6 unlocks it, 500).
- Loans are open from the start (Config_LoanManager: Balance.Required 0, Reputation.Required 0 on all three; code flags
  AllowLoan1/2/3 can switch each off per level). See section 3.

## 2. Build costs
- EVERY room has the same flat fee: Cost 5,000 (lecture room 0). Exceptions: aquarium also 75/cell, +75/cell past 40 cells. The
  building shell costs 100/cell. CellConstructionCost 10 (rooms) / 0.75 (shell) is build WORK (time), not money.
- RefundMultiplier: -1 on every room = the default 1.0 (100% back). CanBeSold = 1 on almost every item.
- A room works only when its REQUIRED items are placed. The key item is the real price of a room:
| Room | Key item(s) and price | Room total to function |
|---|---|---|
| Bathroom | door 100 + cubicle 1,000 | 6,100 |
| Gift shop | door 500 + till 1,500 + 1 stand 125 | 7,125 |
| Marketing | door 100 + desk 3,500 + draft table 2,500 | 11,100 |
| Staff room | door 100 + sofa 500 (+ a 20,000 recovery device in the required list, likely a later-act requirement) | 5,600 |
| Training room | door 100 + pod 5,000 + desk 1,500 + return bin 250 | 11,850 |
| Camera room | door 200 + station 7,500 + bell 225 | 12,925 |
| Cafe | door 500 + food stall 10,000 + 4-seat table 500 + bin 150 | 16,150 |
| Workshop / Studio | door 500 + workstation 10,000 (studio: + 7,500 reveal station) | 15,500 / 23,000 |
| Analysis / Vet | door 100 + machine 25,000 | 30,100 |
- So against a 100,000 start: the cheapest working room is ~6% of the start, a typical one 7-16%, the first heavy key item 30%.
- Starter utility prices (items_full.json): ticket desk 500 (self-service booth 25,000), small donation stand 150 (large 1,000),
  info stand 200, bin 50, bench 250-300, plant 150, vending machine 750-3,000, coffee kiosk 2,500, security camera 2,500.
- Item price spread (1,600 items): 10th pct 0, median 50, 75th pct 300, 90th pct 1,000, 99th pct 13,125. Most decor is cheap.
- Walls/doors/floors: plain doors 100, themed archways 150-500, internal walls procedural, wallpaper and floor tiles taught as
  a free foundations step (objective 18: place 5 wallpaper + 5 floor tiles).

## 3. Running costs
- Staff (Staff_* archetypes; BaseSalary; the UI shows salary per year and the code has GetYearlyWages, so the monthly draw is
  the yearly figure / 12 - inference):
| Role | BaseSalary | Rank multiplier, rank 1 -> 20 | Per qualification level (max 3) | Training cost per qualification |
|---|---|---|---|---|
| Expert (the specialist) | 10,000 | +0% -> +60% | +1,296 | 500-10,000 base + 250-2,500/level |
| Janitor | 7,250 | +0% -> +24% | (none; deprecated one 750+500) | - |
| Security guard | 6,000 | +0% -> +20% | +540 | 250-750 |
| Assistant (front desk, shops) | 4,500 | +0% -> +20% | +540 | 250-750 |
- Hiring (Config_JobApplicantManager_City): RecruitmentFeePercent 10 (a one-off 10% of salary), 3 applicant slots per role,
  pool refreshes every 30-40 s, a job advert costs 2,500 and runs 40 s. Staff cap 100-150.
- Pay policy (Config_LevelPolicy): a global salary slider from -25% to +25%. Satisfaction (Config_LevelState): pay ratio 0.75 ->
  1.25 of the desired wage maps to 0 -> 1. A raise is felt within 4 days (SalaryPositiveSmoothTimeInDays) and underpay builds up
  over 365 days. Resignation on salary: warning 10, change-of-mind 5, urgent 1, then a 240 s countdown. "Wants a pay rise" icon
  at 0.2. Happiness from pay: -40 (underpaid) to +15 (well paid), the strongest single staff factor (Config_HappinessCalculator).
- Per-sale cost / restock (Cost_*, Restock_*; negative = expense): restocks 10-45 per run, robot recharge 500, food and drink
  rows carry a per-sale value of 5-50 that the price slider scales. No per-item upkeep field exists. Items only carry a
  MaintenanceMultiplier (staff work), not a money drain.
- Loans (Config_LoanManager). Payments are computed by us assuming the rate is APR, amortised monthly (inference):
| Tier | Amount (slider) | Rate | Term | ~Monthly payment |
|---|---|---|---|---|
| 1 | 75,000-100,000 | 1% | 36 months | ~2,820 |
| 2 | 175,000-200,000 | 3% | 48 months | ~4,430 |
| 3 | 300,000-350,000 | 5% | 60 months | ~6,600 |
- Bills post monthly (MessageMonthlyBreakdown, MonthlyRegularExpenses / MonthlySporadicExpenses, OnMonthlyLoanPayment).
- Monthly grant (Config_MonthlyGrantManager): paid while the balance is below 350,000 (Arctic 100,000), 5,000-6,000 a month on a
  0-100 input (likely the museum rating - the input name was not recovered).
- Sponsors (Config_SponsorshipManager): max 2, a new offer every 180 days, fees x1.0 / 1.25 / 1.75 / 2.0 by museum level 10/25/50/100.

## 4. Income at the start
- Ticket (Config_Pricing_TicketPrice): starts at 75, slider 0-150 (max = 2x start). Value rating: mid price modifier 0.85-1.5,
  then +8.3% per exhibit quality level and +3% per decoration level (ExhibitQuality/DecorationLevelPriceRatingModifier). Guests
  outside the band are tagged great / good / bad / awful value or refuse to pay.
- Every other price follows the same rule: start = half of max (coffee 15 of 30, hot dog 35 of 70, trinket 50 of 100, plushie
  100 of 200, onesie 250 of 500; rides 0-3x).
- Donations (Config_DonationLevels): by the guest's buzz level, 4-7 at buzz 10, 10-12 at 25, 15-17 at 50, 30-32 at 125, 60-63 at
  250, 120-125 at 550, 200-210 at 1,000, capped at 300-310 from 1,500. Small stand max 1,000, medium 10,000 held.
- Guest flow (Config_GuestsManager_City): one group every 12 s (+-10%), the interval x1.0 -> x0.5 as museum level goes 0 -> 50,
  +10% at 200 capacity. Ticket desk distance and queue curves cut arrivals to 0.5x when the desk is far or queued 10 deep.
- Upper bound at 1x speed: 5 groups/min x 75 = ~375/min ticket income if every group pays. Time to positive cashflow cannot be
  derived because the month length is a code constant (see the last section). What the designers ASK for: Act 2's star wants an
  average rolling monthly profit of 3,000 over 3 months, Act 4's 7,500. Profit targets stay small next to the 100,000 start.
- Tutorial objectives are a cash drip: Act 1's 21 objectives pay 101,000 in total (14 x 1,500, 2 x 5,000, 2 x 10,000,
  2 x 25,000). That equals the whole starting balance, paid out over the guided first hour.

## 5. Unlock pacing
- Rooms open at minute 0: only the building shell and the bathroom (InitiallyAvailable 1). Every other room is unlocked by an
  objective. Items: 782 of 1,600 open at the start.
- Order on the first level (rewards resolved by id):
| # | Objective (what the player does) | Cash | Unlocks |
|---|---|---|---|
| 1 | camera pan / rotate / zoom / pitch | 1,500 | - |
| 2 | place the first exhibit | 1,500 | first job advert |
| 3 | hire 1 expert, restore 2 exhibits | 1,500 | - |
| 4 | place 2 info stands | 1,500 | info stand (200) |
| 5 | reach 3 exhibit prestige (decorate) | 5,000 | 10 themed decor items (35-750) |
| 6 | ticket desk + hire assistant + admit 1 guest | 1,500 | ticket desk (500) |
| 7 | earn 50 in donations, 2 stands, 1 hire | 5,000 | donation stand (150), map location |
| 8 | first expedition, place its find | 10,000 | - |
| 9 | build a staff room, hire 1, own 5 themed exhibits | - | STAFF ROOM |
| 10 | unlock a map point, finish 1 expedition | 10,000 | - |
| 12 | build a gift shop, 5 shop sales | 1,500 | GIFT SHOP + 5 shop items |
| 14 | 1 expedition + build + train 1 staff | 1,500 | STAFF TRAINING ROOM |
| 16 | workshop project + qualified staff + build | 1,500 | WORKSHOP |
| 21 | 10 prestige + total buzz 500 (act end) | 25,000 + 150 Kudosh | coffee kiosk, next act, next map |
  Act 2 adds the analysis room, camera room and cafe the same way, one room per objective.
- Kudosh (second currency): start 5, +5 per objective, +150 at each act end, +300 for the first fame tier. Act 1 total ~400.
  Item gates: 1,254 items cost 0 Kudosh, 248 cost <= 50, 42 <= 100, 26 <= 250, 23 <= 500, 20 <= 1,000, 5 above (max 2,500).
  Kudosh buys premium variants (wide or gold info stand, a better cooler at 500), never a room's key item.
- Expeditions (the cash-for-content gate, LocationPOI_*): 2,500-7,500 and 7-15 days for the first ones, rising to 30,000-47,000
  and 40-65 days. Usually 1-2 per region are open at the start.

## 6. The tightening
- Museum level: XP to the next level = 45 + 5 x level (Config_MuseumLevel), cap 200. Staff rank feeds it (expert rank worth up
  to 200, the others 100; qualifications x4).
- Staff costs creep up on their own: rank 1 -> 20 adds +20% to +60% salary, each qualification level adds 540 / 1,296, and the
  pay-rise icon fires at satisfaction 0.2. Underpay is forgiven slowly (365 days) and a raise lands fast (4 days).
- More guests per minute as the level rises (spawn interval x0.5 at level 50). That means more queues, litter and wear.
- Exhibits decay (grubbiness -> restoration jobs; stolen = -100% visit time, grubby -50%, perfect +50%). Staff rank attributes
  decay (RankAttributeDecay 1.0 -> 0.1 over 25).
- Targets rise per act: museum rating 65% -> 75% -> 80%; rolling 3-month profit 3,000 -> 7,500; guest knowledge level 5 -> 20
  -> dynamic 75-115; buzz per guest 200 -> 2,250; "museum level +5 from where you are" (MuseumLevelOffset) and dynamic targets
  so a strong player cannot pre-clear a star.
- End-of-year awards (Config_EndOfYearAwards) by museum level band 15/30/45/50: guest happiness 75-95 -> 90-95, staff
  satisfaction 75 -> 90, total buzz 150-250 -> 750-775, staff XP 100-200 -> 725-750.
- Bankruptcy bail-out terms also tighten by level (next section): minimum income 7,500 at level 1-10, 45,000 at 51+.

## 7. Objectives - the guided first hour
- Act 1 = 21 small objectives, each ONE new verb with 1-5 subgoals, almost all paying 1,500 + 5 Kudosh. The order: look around ->
  place -> hire -> inform -> decorate -> open the door (ticket + staff) -> earn (donations) -> explore (expedition) -> first
  support room -> shop -> rating -> training room -> environment (temperature) -> workshop -> foundations -> 25 guests ->
  entertainment -> act-end star.
- Act ends are STARS: 2-5 measurable targets at once (e.g. Act 2: tour rating 4, rolling profit 3,000 / 3 months, rating 65%,
  3 exhibit varieties). One star per museum opens the next map (fame tier 1 = "1 star in 2 museums").
- Optional side objectives pay 1,000 + 5 Kudosh (spend Kudosh once, staff-only door, gift shop, painting).

## 8. Fail state (Config_BankruptcyManager, Config_SponsorshipManager)
- Negative money is allowed. Advisor warning at -15,000; forced bankruptcy flow at -35,000 (15% and 35% of the City start).
- Bail-out: balance reset to 150,000, 1-3 exhibits repossessed by museum level (1 at level 1-10, 2 at 11-25, 3 at 26+, max 5),
  plus loan objectives demanding a minimum income: 7,500 (level 1-10), 10,000 (11-15), 15,000 (16-20), 20,000 (21-30),
  25,000 (31-40), 30,000 (41-50), 45,000 (51+). A sponsor bail-out offer unlocks at -5,000.
- The career never ends on money. Debt costs content (repossession) and imposes a target.

## What FightCamp's blank-gym start should take from this
FightCamp today: STARTING_CASH 25,000 (GameState.gd:159); equipment_catalog.json 95 items 280-28,000, median 2,400, ring 18,000
(72% of the start); items carry weekly_upkeep + maintenance_cost. Rooms per GYMBUILD_PLAN_S276.md.
1. SIZE THE START TO "THE MINIMUM OPEN GYM + RUNWAY". TPM's cheapest working room is ~6% of the start, a typical one 7-16%, the
   first heavy key item 30%. Make the day-1 must-haves (training floor with 1 bag station, reception desk, office PC) cost ~35-45%
   of starting cash. The 18,000 ring must NOT be a day-1 requirement: it is FightCamp's "analysis machine" (a 25-30% purchase
   the player saves up for). Bouts can be booked at an outside venue until the ring is bought.
2. ROOM PRICE = FLAT FEE + KEY ITEM. TPM: one flat 5,000 (5% of start) for every room, then the key item. Ours: drawing a room
   costs one flat fee (~5% of start, ~1,250 at 25,000) + walls per cell cheap (TPM shell 100/cell). The room works only when the
   key item stands in it (office PC, reception desk, one locker, physio bed; training floor: one station). Refund 100% while
   building (already PLACEMENT1).
3. THE TUTORIAL PAYS BACK THE START. Act 1 pays 101,000 = 1.0x the start, as 1,500 per small goal and 5,000-25,000 on milestones.
   Our first-hour goal chain (draw training floor -> place a bag -> hire coach -> draw reception + desk -> first member pays fee ->
   office PC -> book the first bout -> locker -> physio bed -> first purse) pays ~6% of start per step and ~20-25% on milestones.
   That is roughly 1x start over the first hour, so a cautious builder never stalls.
4. ONE ROOM UNLOCKED PER GOAL, NEVER A WALL OF LOCKS. TPM opens 2 rooms at minute 0 and 1 room per objective after. Ours: the 5
   starter rooms open (operator S276), then SPARRING, STRENGTH, CARDIO, FILM, LOUNGE, TOILETS, STORAGE unlock one per goal, each
   goal teaching that room's use.
5. SALARY LADDER BY ROLE + RANK + SKILL. TPM: specialist 10,000 vs front desk 4,500 (2.2x); rank 1 -> 20 adds +20% (support) to
   +60% (specialist); each skill level adds a flat 540 / 1,296; hiring fee 10%; 3 applicants per role, refresh 30-40 s, paid
   advert to re-roll. Map: head coach = expert curve (+60%), physio = expert-tier base, receptionist/cleaner = assistant curve.
   Coach pay is the main cost that tightens as the boxer climbs.
6. PAY AS ONE POLICY, NOT A CHORE. TPM: one global -25%..+25% salary slider, satisfaction from pay ratio 0.75-1.25, raises felt in
   4 days, underpay over 365 days, resign warnings at 10/5/1 with a 240 s countdown. Copy the MODEL (asymmetric smoothing, one
   slider, an icon when someone wants a raise). No per-person haggling - the Gym Empire bar (S277_GYM_EMPIRE_BENCHMARK.md).
7. EVERY PRICE IS A SLIDER STARTING AT HALF OF MAX. TPM ticket 75 of 150, shop items half of max, value rating great..awful from a
   mid-price curve lifted by quality (+8.3%/level) and decor (+3%/level). Membership fee and class prices work the same, with
   value feeding member satisfaction and churn. Better stations and decor raise what members accept.
8. A SECOND CURRENCY FOR "NICER", NOT "NEEDED". Kudosh: start 5, +5 per goal, +150 per act; 78% of items cost 0 Kudosh; it never
   gates a key item. Ours: reputation points buy premium variants (branded bags, a better ring canvas, wall art), never the
   room's key item.
9. THE TIGHTENING COMES FROM THE GYM'S OWN SUCCESS. TPM tightens through: more guests per minute as level rises (interval x0.5 at
   level 50), staff rank -> salary, decay -> maintenance work, and act targets that rise (rating 65 -> 80%, rolling profit 3,000
   -> 7,500) or are DYNAMIC (level +5 from now). Ours: members per day grow with gym level (busier floor, queues at stations),
   coach rank-ups ask for raises, equipment wear (weekly_upkeep / maintenance_cost) scales with use, and each career star asks
   for a rolling 3-month profit, a rating and a fight record measured from where the player is.
10. STARS, NOT A TIMER. TPM act ends = 2-5 measurable targets at once, and a star elsewhere opens the next map. Ours: "gym
   stars" combining member rating %, rolling profit, boxer record or rank. A star opens the next venue / promoter tier.
11. DEBT COSTS CONTENT, NEVER THE CAREER. Warning at -15% of start, forced at -35%. The bail-out resets cash but repossesses the
   most valuable 1-3 stations (by gym level) and sets a minimum-income goal that rises with level (TPM 7,500 -> 45,000). Three
   loan tiers at 1x / 2x / 3.5x of start, 1-5% over 36-60 months. A small monthly grant while poor (TPM 5-6% of start).
12. DIFFICULTY = FOUR MULTIPLIERS. TPM Hardcore / Career / Creative: start cash 0.5x / 2.5x / 10x of City, salaries x1.25 / 1.0 /
   0.5, donations x0.75 / 1.0 / 1.5, grant max 5,000 / 7,000 / 10,000. One FightCamp difficulty choice sets start cash, staff pay,
   fee acceptance and grant together.

## Not recovered (and why)
- Month / day length in seconds (SecondsPerDay, DaysPerMonth exist as identifiers but are code constants, not config). So time to
  positive cashflow and the salary per real-time minute cannot be derived.
- The shape of TPM's parametric curves between endpoints (the type 0-3 + factor maths is in code). Endpoints are exact.
- Whether BaseSalary is per year (inferred from GetYearlyWages and the UI) and whether loan rates are APR (inferred).
- City's pre-placed building, exhibits and staff (stored in the level scene, not in configs). Inferred from the tutorial flow.
- The plot purchase price (UnlockPlot carries no cost; plot pricing is scene data). The monthly grant's 0-100 input name.
- Main-campaign expedition costs: the first-map POIs are unnamed test assets (7,500 / 45 days each). The named ranges above come
  from the DLC and art maps plus one main-map gate (35,000 / 65 days).

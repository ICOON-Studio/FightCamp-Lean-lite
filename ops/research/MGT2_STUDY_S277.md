# MGT2 study (S277): the first hour of Mad Games Tycoon 2, and how it gets harder

**What this is for:** the operator's S277 direction: "focus on the new start, blank gym player designs everything with limited budget , and slowly everything tightens on the loop".
**Rule (operator S243/S277):** "we are not copying anything do it". This file holds numbers, rules and structure only. No code, text, art or assets from MGT2 went into the repo.

**How it was read (2026-10-20, operator's own install, `E:\SteamLibrary\steamapps\common\Mad Games Tycoon 2`, Unity Mono build `BUILD 2020.08.22A`):**
- **REA 6.7.0** (`rea inspect-managed-members ... --type <T>`) on `Managed\Assembly-CSharp.dll` gave the type and field inventory, field flags (which fields are serialized and which are `const`), signatures and call edges.
- REA's managed output lists call/field anchors but not `ldc` operands. For the constants I wrote a small IL decoder on `dnfile`: the method body bytes, an opcode table, and tokens resolved to field and method names. Every number below that is cited as `Type.Method` comes from that decoder.
- `const` values come from the dnfile `Constant` table.
- Serialized data comes from UnityPy 1.25.3. The files have no typetrees, so I parsed the raw MonoBehaviour bytes using the field order and flags from REA. All 196 `objectScript` blobs parsed to their exact byte length, which validates the layout.
  - `level2`: the `roomDataScript`, `forschungSonstiges`, `unlockScript`, `mapScript`, `Menu_DevGame` and `games` curves.
  - `sharedassets2.assets`: the object prefabs.
  - `level3`-`level8`: the map buildings.
- Plain reads of `Extern\Text\EN\Tutorial_EN.txt`, `Objects_EN.txt`, `Text_EN.txt` and `Extern\Text\DATA\Publisher.txt`. A text index `i` is line `i+1`.
- Scripts and dumps are in `E:\FightCamp\tmp\mgt2_study`, outside the repo. The game was never launched.

## 1. New game
| Item | Value | Source |
|---|---|---|
| Start money (normal game, start year 1976-1984) | **$200,000**, the same on every difficulty | `mainScript..ctor` (`money = 200000`) |
| Start money for a later start year | 1985-94: $2M; 1995-2004: $4M; 2005-14: $8M; 2015-19: $12M; 2020+: $25M. A later start also marks some research as done (B+ size, QA room, sub-genre, sub-theme, and more for later eras) | `Menu_NewGameSettings.UnlockStartjahr` |
| Sandbox money options | 100k / 250k / 500k / 1M / 5M / 10M / 25M / 50M / 100M / 500M / 1B, or debt of -100k to -10M | `Menu_NewGameSettings.BUTTON_OK` |
| Start date | Jan 1976, week 1. A month is **4 weeks** (48 weeks a year) | `mainScript..ctor`, `WochenUpdates` / `MonatlicheUpdates` |
| Difficulty levels | 6: Very easy, Easy, **Medium (default)**, Hard, Very hard, Legendary (index 0-5) | `Menu_NewGame.InitDropdowns` |
| Start staff | **Only the player character (CEO)**. You spend skill points on him, he draws no salary (perk 0) and never loses motivation | `mainScript.CreatePlayer`, `characterScript.CalcGehalt` |
| Start loan | none (`kredit = 0`) | - |
| Start object | "Your sports car" ($40,000 list price) placed in the garage. Selling it pays 50%, so **$20,000** | `mainScript.CreateStartAuto`, `objectScript.GetVerkaufspreis` (×0.5) |
| Start building | The garage in a walled building on a street plot. You own building 1 of the map and buy the others. **Inference:** the warehouse map has only building 1, and its text says "huge building area right from the start" | `level3`-`8` `buildingFloor.buildingID` |

Building 1 size and the number of buildings to buy, per map:

| Map | Building 1 | Buildings to buy |
|---|---|---|
| Business Park (tutorial) | 111 tiles | 6 more, 145-664 tiles |
| Hotel | 182 tiles | 3 |
| Small map | 121 tiles | 5 |
| Warehouse | 3,850 tiles | 0 |
| Bunker | 132 tiles | 8 |
| Lagoon City | 210 tiles | 8 |

## 2. Building costs
- **A room costs its per-tile price × the tiles you draw.** There is no wall cost and no fixed fee. **Doors and windows are free** (`SetDoor`/`SetWindow` never pay). Source: `Menu_BuildRoom.GetRoomPrice = roomData_PRICE[type] × AmountTiles − moneyRedesign`.
- **Redesign** credits the old tiles at the same rate, so you pay only for the growth (`buildRoomScript.CreateOldRoomLayout`).
- **Demolish** refunds 50% of the room's objects and **nothing for the room itself** (`Menu_DemolishRoom.Init`). Selling any object pays 50%.
- **Minimum size:** the biggest square inside the room must reach the minimum (`Menu_BuildRoom.UpdateAcceptButton`):
  - 3×3 by default
  - 2×2 for the stockroom
  - 4×4 for the sound studio
  - 5×5 for motion capture and production
- **Capacity before overcrowding:** floor(tiles / 3.3) people. Sound studio: 10 tiles per person. Motion capture: 5. Training: 2.7 (`roomScript.AnzahlArbeitsplaetzeBisUberfuellt`).
- **Buying the next building** (`Menu_Immobilien.GetPreis`): tiles × 1,600 × (difficulty+1) × a size factor.
  - Size factor: ≤100 tiles ×1; 101-200 ×2; 201-300 ×5; 301-400 ×10; 401-500 ×15; 501-600 ×20; >600 ×30.
  - A property-boom event doubles the price; a slump halves it.
  - Example: Business Park building 4 (145 tiles) on Medium costs **$1.39M**, about 7× the start cash. Building 5 (664 tiles) costs **$95.6M**.

| Room (type id) | $ per tile | Min room | Min room cost |
|---|---|---|---|
| Development (1) | 2,500 | 3×3 | 22,500 |
| Research (2) | 3,000 | 3×3 | 27,000 |
| QA (3) | 2,000 | 3×3 | 18,000 |
| Graphics studio (4) | 3,500 | 3×3 | 31,500 |
| Sound studio (5) | 8,000 | 4×4 | 128,000 |
| Marketing (6) | 2,500 | 3×3 | 22,500 |
| Support (7) | 2,000 | 3×3 | 18,000 |
| Console dev / hardware (8) | 10,000 | 3×3 | 90,000 |
| Stockroom (9) | 1,500 | 2×2 | 6,000 |
| Motion capture (10) | 6,000 | 5×5 | 150,000 |
| Toilets (11) | 3,500 | 3×3 | 31,500 |
| Lounge (12) | 2,000 | 3×3 | 18,000 |
| Training (13) | 2,500 | 3×3 | 22,500 |
| Production (14) | 4,000 | 5×5 | 100,000 |
| Server room (15) | 10,000 | 3×3 | 90,000 |
| Workshop (17) | 2,800 | 3×3 | 25,200 |

Source: `level2` `roomDataScript.roomData_PRICE`. The type ids are the `const` fields.

## 3. Room types and unlocks
Rooms open at the start (no lock hint in Text_EN lines 50-64): **Development, Research, Toilets, Lounge**. The rest unlock like this:

| Room | How it unlocks | Research cost / points |
|---|---|---|
| QA, Support, Marketing, Training | research ("Miscellaneous" tab) | **$200,000** / 400 pts each |
| Graphics studio, Sound studio | research | $500,000 / 800 pts |
| Workshop | research | $350,000 / 500 pts |
| Production | research | **$5,000,000** / 1,000 pts |
| Stockroom | comes with Production | - |
| Console development | research | $10,000,000 / 4,000 pts |
| Motion capture | **date: Nov 1993** | - |
| Server room | after researching Online Multiplayer | - |

- Source: `forschungSonstiges.RES_PRICE` / `RES_POINTS` (41 entries) and `unlockScript.CheckUnlock` (unlock 8 = 1993/11).
- The same research list also unlocks bigger game sizes (B+ $50k, A $200k, AA $500k, AAA $1M, AAAA $5M) and the studio upgrade tiers ($50k-$800k).
- **Object quality tiers unlock by date**, not by research (`unlockScript` inventar2-5): tier 2 Dec 1984, tier 3 Dec 1994, tier 4 Dec 2004, tier 5 Dec 2014.

## 4. Objects
There are 188 prefabs (`sharedassets2` `objectScript`). The index matches `Objects_EN` line+1 through `mapScript.prefabsInventar`. Each prefab has `preis`, `monatsKosten` (upkeep per month), `qualitaet`, `unlockYear` and which rooms it can go in.

**The key item.** A room works only with a **workplace** (`isArbeitsplatz`). The tier-I desk is the cheapest way to make each room work:

| Room | Tier-I key item | Tiers II / III / IV / V | Desk ÷ min room |
|---|---|---|---|
| Development | Work Desk $3,000 (2×2) | 5,000 / 10,000 / 13,000 / 17,500 | 13% |
| Research | $3,500 (2×2) | 6,000 / 11,500 / 14,000 / 18,500 | 13% |
| QA | $2,800 | 4,700 / 9,000 / 11,500 / 15,000 | 16% |
| Marketing / Support | $2,500 | 4,500 / 8,500 / 11,000 / 13,500 | 11-14% |
| Graphics | $5,000 | 8,000 / 12,000 / 15,000 / 20,000 | 16% |
| Sound | **$50,000** (4×2) | 75k / 100k / 150k / 250k | 39% |
| Motion capture | **$80,000** | 160k / 240k | 53% |
| Training | Training Desk $2,500 | 4,000 / 8,000 / 10,000 / 12,500 | 11% |
| Workshop | $3,500 | 5,800 / 11,200 / 18,500 / 23,700 | 14% |
| Console dev | $5,000 (2×2) | 10k / 20k / 35k / 50k | 6% |
| Production | Production machine **$120,000** | 250k / 500k / 750k / 1M | 120% |
| Stockroom | Heavy-duty shelf $2,000 (holds 25,000 games) | 6,500 (50k) / 15,000 (100k) | 33% |
| Server | Server $80,000 **+$10,000/mo** (100k players) | 150k+20k/mo, 280k+50k/mo, 350k+100k/mo, 480k+200k/mo | 89% |
| Toilets | Toilet $6,500 (3×3) + wash basin $1,800 | luxury 25,000 / 9,200 (2010) | 26% |
| Lounge | Armchair $2,180-3,100 (motivation 27-39) | treadmill 8,250 / mini golf 8,000 (motivation 100) | 12-17% |

**Comfort items** work in every room unless noted:

| Item | Price | Upkeep | Effect |
|---|---|---|---|
| Plant / cactus | $300 | - | equipment +1 |
| Trash can | $300 | - | - |
| Clock | $300 | - | - |
| Lamp | $500-1,800 | - | equipment +1/+2 |
| Posters / pictures | $450-2,000 | - | equipment +1/+2 |
| Carpets | $800-3,400 | - | equipment +1 to +3 |
| Radiator | $2,500 | **$50/mo** | heat 5 |
| Electric heater | $2,600 | $100/mo | heat 3 |
| Modern heating (2010) | $8,000 | $250/mo | heat 20 |
| Water dispenser | $1,500 | $50/mo | - |
| Coffee maker | $1,250 | $40/mo | - |
| Medicine cabinet | $2,800 | $50/mo | - |
| Air conditioning (server room) | $4,000 | $120/mo | - |
| Cleaning robot (corridor) | **$15,000** | **$2,500/mo** | - |
| TV | $4,000 | - | equipment +3 |
| Award trophies | free | - | equipment +5 |

Only 13 of the 188 objects have upkeep. Server upkeep doubles during a global event (`objectScript.Monatskosten`).

## 5. Running costs
- **Salary (monthly)** = 10 × round(sum of the 8 skills). Each skill runs 0-100. Source: `characterScript.CalcGehalt`.
  - Positive perk +$500; negative perk -$500; perk 14 +$1,000; perk 15 +$2,000; "legend" +$10,000; perk 18 doubles the total.
  - **Floor: $1,000/month.** The CEO gets $0.
- **Job-market hires at the start:** 7 skills at 10-20 and the main skill at 30-(40 + 3×studio level). That is a skill sum of about 140, so **about $1,400/mo**, $900-2,400 with perks (`charArbeitsmarkt.Create`).
  - Studio level 0-10 comes from studio points (30/150/300/600/800/1000/1500/2000/3000/4000, `mainScript.GetStudioLevel`), so better studios attract pricier candidates.
- **Raises:** a staff member asks for more when his computed salary is more than $500 above what he gets (10% chance per check). Automatic negotiation simply pays the new value (`characterScript.Gehaltsverhandlung`).
- **Bills** fire **monthly** in `mainScript.MonatlicheUpdates`, in this order: object upkeep, then salaries (`Pay` category 9, charged to the project the person works on), then subsidiary admin, unlock checks, loan interest, bank warning.
- **No rent, electricity or property tax was found.** Land is a one-off purchase (section 2). The running costs are only salaries, the 13 upkeep objects, loan interest and the project's own costs.
- **Loans:**
  - Limit = A × (year − 1975) + B × studio points + B × contract reputation (`mainScript.GetKreditlimit`).
    - A/B by difficulty: 300k/30k, 250k/25k, 200k/20k, 150k/15k, 100k/10k, 50k/5k.
    - Medium in 1976: **$200,000**.
  - **Monthly interest** = loan ÷ (140 / 120 / 100 / 80 / 60 / 40) by difficulty, i.e. **0.71% to 2.5% a month**. Medium is 1% a month. A banking-crisis event triples it (`GetKreditZinsen`, `PayBankZinsen`).

## 6. Income at the start
1. **Selling the car: +$20,000** (tutorial step 3).
2. **Contract work** (`contractWorkMain.UpdateContractWork`, new offers weekly):
   - Work points = 20 × Random(10, 30 + 5 × contract reputation).
   - **Pay = round(points × (6 − difficulty)) × 13.** With reputation 0, Medium offers **$10,400-30,160**, Very easy $15,600-45,240 and Legendary $2,600-7,540.
   - Deadline = points/50 + 5-9 weeks. The failure penalty is 10-30% of the pay.
   - Completing contracts raises contract reputation, which raises the pay and the loan limit.
3. **The first game** goes out **through a publisher only**; self-publishing is researched later (tutorial step 15).
   - Base development cost: Classic **$10,000** flat. Other game types cost $7M or $3M × (difficulty+1). Game size B adds $0; B+ $50k, A $250k, AA $1M, AAA $4M and AAAA $10M, each × (difficulty+1) (`Menu_DevGame.CalcDevCosts_Grundkosten`, `level2` `Menu_DevGame.costs_*`). Engine features cost extra.
   - The publisher's payment rate is that publisher's `[SHARE]` (8-13 in `Publisher.txt`, 749 entries). I did not trace how share turns into money.
4. **Worked first build (tutorial route, Medium, 1976):**

| Room | Contents | Cost |
|---|---|---|
| Development, 4×4 | 16 × 2,500 = 40,000; desk 3,000; radiator 2,500; water 1,500; lamp, plant, trash 1,100 | ≈ $48k |
| Toilets, 3×3 | 31,500 + toilet 6,500 + basin 1,800 | ≈ $40k |
| Lounge, 3×3 | 18,000 + armchair 3,100 | ≈ $21k |

   That is **≈ $109k of the $220k**, about half the cash, plus $10k for the first game. Monthly upkeep stays at about $100 until you hire. **Each hire costs about $1.4k a month**, so the cash lasts a long time for a solo CEO.
   - I could not derive the exact time to first profit statically. It depends on sales curves and publisher share. Contract work alone pays back a 3×3 room in 1-2 contracts.

## 7. How it gets harder
- **Quality expectations grow with the square of time; the market grows about 10×.**
  - Review points needed for top marks = base × `games.curveReview(monthsPassed/600)`.
  - Base by difficulty: 7,000 / 10,000 / 15,000 / 18,000 / 22,000 / 30,000. Retro games: 2,500-4,500 (`gameScript.CalcReview`).
  - The curve runs 0.004 → 1.0 with end slope 2, which is about t²:

| Year | 1976 | 1981 | 1986 | 1991 | 1996 | 2006 | 2016 | 2026 |
|---|---|---|---|---|---|---|---|---|
| curveReview | 0.004 | 0.013 | 0.043 | 0.093 | 0.16 | 0.36 | 0.64 | 1.0 |
| curveSells (market size) | 0.1 | 0.14 | 0.19 | 0.24 | 0.29 | 0.44 | 0.67 | 1.0 |

  The bar rises about 250× while sales potential rises about 10×. Each point of quality must cost more over time.
- **Penalties for staying small (in `CalcReview`):**
  - B-size games lose review points by era: -1 (1983-87), -2 (1988-94), -3 (1995-2003), -4 (2004-19), -5 (2020+).
  - Missing a specialist studio costs points once its era arrives: gameplay studio from 1979 (-1), graphics from 1982 (-1), sound from 1985 (-2).
- **Costs that rise as you grow:**
  - Game size steps cost ×5 to ×4 each.
  - Desk tiers cost 1.7×, 3.3×, 4.3× and 5.8× tier I.
  - Salaries track skill, and staff skill grows with work.
  - The next building costs up to 30× more per tile than the first.
  - Server upkeep climbs from $10k to $200k a month.
- **Difficulty scales income, not start cash:**
  - Sales multiplier: ×2.0 / 1.5 / 1.0 / 0.5 / 0.35 / 0.25 (`gameScript.SellGame`).
  - IP fame bonus: ×1 / 0.8 / 0.5 / 0.4 / 0.37 / 0.35.
  - Contract pay: (6 − difficulty).
  - Loan size and interest, land price ×(difficulty+1), development costs ×(difficulty+1).
  - From Medium up (difficulty ≥ 2), random bad-press events can hit a game in market weeks 4-20.
  - Competitors: 20 × (setting+1) studios, or unlimited (`anzKonkurrenten`).

## 8. The first hour, in tutorial order
`Tutorial_EN.txt`, 20 steps, paraphrased:
1. Camera move and rotate (steps 1-2).
2. **Sell the old sports car** for cash (3-4).
3. Open **Build a Room** and choose Development; some rooms are locked behind research or dates (5).
4. **Draw the room, place a door** (it must connect to the corridor), Accept (6).
5. **Buy objects: at least one workplace**, plus heat (radiator) and tidiness (trash can, cleaning robot) (7).
6. Staff have needs: make enough lounges and toilets (8).
7. Drag the CEO into the Development room (9).
8. Click the room's task button, then Develop a Game, then New game; set it up and start (10-12).
9. Fastest speed, wait (13-14).
10. **Publish through a publisher** (15).
11. Experience, sales, rating and reviews (16-18).
12. The next goals: **build a Research room**, then the graphics and sound studios (19-20).

So the game makes you build **one working room, then the needs rooms (toilets and lounge), then Research**. Research is the door to every other room.

## 9. Negative money
Source: `mainScript.UpdateBankWarning`, called monthly, and `Menu_GameOver.OnEnable`.
- Each month-end with money < 0 adds 1 to `bankWarning`. A month-end with money ≥ 0 resets it to 0.
- **A bank warning comes at 6 consecutive negative months.** **Insolvency comes at 19.**
- **Insolvency does not end the game:**
  - Money is set to 0 and every loan is cleared.
  - Studio points are halved. Fans are halved. Contract reputation is halved. Every publisher relation is halved. IP points are halved.
  - The counter is left at 18, so one more negative month triggers insolvency again.
- Purchases are refused when you lack the cash (`mainScript.NotEnoughMoney`).

## What FightCamp's blank-gym start should take from this
Our rooms: TRAINING FLOOR (ring, bags and pads stations), OFFICE (key item PC), RECEPTION (desk), LOCKER ROOM (locker), PHYSIO (bed). Members pay fees, boxers fight for purses, staff draw salaries.

1. **Price rooms per tile by type and keep door, window and wall cost at zero.** Use about a 5× spread between the cheapest and dearest tile (MGT2 runs from $1,500 storage to $8,000-10,000 sound and server).
   - Proposed order, cheap to dear: LOCKER < RECEPTION < TRAINING FLOOR < OFFICE < PHYSIO.
   - Redesign credits the old tiles. Demolish refunds only the items, at 50%.
2. **Minimum square per room.** 3×3 by default; 2×2 for the locker room; 5×5 (or the ring's footprint + 1) for the training floor. Show the minimum in the Build menu the way MGT2 shows its size message.
3. **Every room is dead until its key item is placed, and tier I is cheap.** The key item should cost about **11-16% of the minimum room shell**: PC, desk, locker, physio bed, one heavy bag.
   - Expensive key items stay for late rooms only. The ring should be the one exception, MGT2's production machine at about 120% of the room.
   - Tiers II-V cost about 1.7× / 3.3× / 4.3× / 5.8× and **unlock over time**, not with money.
4. **Start cash ≈ 2× the cheapest "complete first build".** MGT2 gives $220k (cash plus the car) against about $109k for one working room plus toilets and lounge.
   - For us: one training floor with 1 station, plus a locker room and reception, should take about half the start cash. The other half pays for the first months.
   - Start with **one sellable leftover item** in the empty gym (MGT2's car is half its price on sale) as the first decision.
5. **The owner-coach is free; every hire costs money every month from day one.** Use MGT2's form: salary = k × sum of skills, a floor, perks ±, a raise request when the skill-based value passes the current pay by a margin.
   - In MGT2 one early hire costs about 0.7% of the start cash a month. That rate makes a hire a weighed choice without being ruinous.
6. **Bill monthly, and only from a short list:** salaries, a few upkeep items (MGT2: 13 of 188 objects, e.g. heater $50 and cleaner robot $2,500), and loan interest. No hidden rent. The early game should stay readable on one line.
7. **The first money comes from small offers, not the main product.** MGT2 runs contract jobs (pay rises with reputation, failure costs 10-30%) before the first game ships.
   - Our version: walk-in sessions, pad-work gigs and undercard spots as weekly offers with a deadline, before members and big purses take over.
   - Reputation from finished jobs raises the next offers and the loan limit.
8. **Lock rooms in the Build menu and state the unlock rule on the button.** MGT2 starts with 4 rooms open, unlocks the rest through a dedicated "research" room ($200k-$10M) or by date.
   - Our version: start with TRAINING FLOOR, LOCKER, RECEPTION. OFFICE (PC) is the "research" room that unlocks PHYSIO and the rest.
9. **Let expectations rise faster than income.** MGT2's bar grows about t² (250× over the run) while the market grows about 10×. On top come the "too small for this era" penalties (-1 to -5) and the "missing specialist room" penalties once their era arrives.
   - Our version: opponent quality and expected training standards ramp with a quadratic curve. A gym without a physio or a proper ring loses points after month N.
   - This is the "slowly everything tightens on the loop" lever.
10. **Make expansion land a long-term goal.** MGT2: tiles × $1,600 × (difficulty+1) × a size factor of ×1 to ×30, so the first extra building costs about 7× the start cash.
    - Our version: the next unit or floor should cost many months of profit. The start plot holds about 110-210 tiles.
11. **Difficulty should scale income and credit, not start cash.** MGT2 keeps $200k on every level and moves sales (×2 to ×0.25), job pay, loan size and rate (0.7-2.5% a month) and land price.
12. **Soft bankruptcy.** A warning after 6 negative month-ends; at 19 the "insolvency" step clears cash and debt but halves reputation, fans and relationships, and the career goes on. This fits a career game better than a game-over screen.

**Not recovered, and why:**
- The exact time to first profit and the publisher share-to-money formula. Both depend on simulation curves I did not trace through `SellGame` and `publisherScript`.
- The full shape of the AnimationCurves beyond their two keyframes. I evaluated them as Hermite from the stored slopes.
- Which building index is owned at start is an inference: `mainScript.buildings` is serialized in a large `mainScript` blob I did not parse.
- Workplace counts per desk for hire planning.

# G74 — THE GYM MARKET

> Collected S67, 2026-09-24, from Grok's in-app chat "G74 Gym Market Rivals Economics FightCamp Design"
> (https://grok.com/c/cde62f8d-5b3e-4393-91dc-53854114da79), 86 sources (links in the chat; the inline chips
> render as a domain name after a `⁠`). Grok's answer as rendered text; tables re-set as markdown.
> NOTE: written while the member count was still frozen; S67 unfroze it (b6a3d064) before this was collected.

Desk: research + design, no code
Date: 2026-09-24
Status: proposals only. Does not write .gd / .tscn / assets/data. Does not reopen J4 E1–E3, J5 G1 / G3 / G10 / G17 / G24, or J8 N1–N22.

Cite, do not re-litigate: a gym lives on the training floor, not the purse (J5 G3). No sport-wide dollar wearing a citation (J5 G24 / J8 N1). A gym's posted rate is primary for that gym. Aggregates are journalism or vendor samples, not MMA/boxing/Muay Thai as a sport. Named gyms, coaches, and athletes are kinds of source, never catalog rows (J1 4.1).

Number marks: evidenced / vendor-observed / customary / invented / NOT FOUND.

## Live state (what the operator is unfreezing)

Membership.natural_members is a solo function of the player gym. It does not read rivals, coaches, price, condition, or a city pool.

```
target = 48 + 0.6×reputation + 25×(gym_tier−1) + 20×(room_tier−1) + 3×equipment_items
clamped to 400
dues = members × $12 / week
```

Every magnitude is labelled invented in membership.json. weekly_drift_fraction is 0 by operator ruling 2026-09-07 (J8 N2/N3: flat is the honest reading). The walk already exists (step_members, cap 6/week, fraction 0.25). Turning it on is a data edit.

Rival gyms: WorldPopulation seeds 2–3 gyms per detailed city (DEFAULT_DETAIL_GYMS_PER_CITY = 2, max 3). Each carries tier, reputation (25–92), financial_strength (20–96), facility_quality (25–95), ambition (athlete ambition strings reused), relationship, one coach, four athletes. facility_quality is fixed at generation. Rivals do not buy equipment and do not compete for members. They act by poaching unhappy fighters (GameState.get_rival_gyms / _pick_poaching_gym). Station capacity already limits how many fighters train per day. There is no roster cap.

That is the hole: income does not come from a city market, equipment is a flat +3 members with no crowding, rivals are scenery except for poaching.

## 1. Real gym economics

### Market size (industry bodies, not a FightCamp default)
- US boxing gyms & clubs: $1.6bn revenue in 2025, 3,373 businesses, +1.7% that year, 6.9% CAGR 2020–2025 (IBISWorld OD4848). ⁠Ibisworld
- US martial arts studios: $21.2bn in 2026, 76,364 studios, IBISWorld via Gymdesk. ⁠Gymdesk
- General US health clubs are a different product: HFA/IHRSA consumer reports put ~69–77 million members and average dues around $51–$59 / month. That is Planet-Fitness-to-mid-club, not a fight gym. ⁠Mmcginvest

### What members actually pay (bands, not a sport table)

| Source | What it measured | Band | Kind |
|---|---|---|---|
| Gymdesk Benchmark 2026 | 4,594 active gyms, mostly martial arts / combat schools | ~$100 / member / month collected (list often ~$165; family discounts pull the average down) | vendor-observed |
| Gymdesk 2022 baseline | US martial arts schools on the platform | avg school $114,657 / year, 112 members | vendor-observed |
| same, by discipline | MMA / boxing / BJJ | MMA $254,083; boxing $152,544; BJJ $139,193 avg annual revenue | vendor-observed |
| Wellyx 2026 industry recap | secondary compilation | traditional dojo $80–$130; MMA gym $100–$160; hybrid fitness $130–$200+ ARPM | secondary |
| DataIntelo MMA gym report | market-research compilation | dedicated NA MMA centres $120–$280 / month unlimited; drop-in $25–$75 | secondary |
| MarketIntelo combat-fitness studios | market-research compilation | boxing/kickboxing $130–$190; MMA $140–$210; hybrid $160–$250 | secondary |
| TITLE / Rumble FDDs (Item 19) | boutique fitness-boxing franchises | avg unit gross ~$400k–$490k | evidenced for those franchises, G17 scenery |
| UK journalism 2020–2025 | named London / Essex pages | adult unlimited examples £45 → £99, £80 → £110 | primary for those gyms only |
| HFA / IHRSA | health clubs | ~$51–$59 / month average | evidenced for health clubs, wrong product |

FightCamp's $12 / week = $52 / month. That sits on the general-fitness average, not the combat-school collected average (~$100) and not boutique combat-fitness ($130–$210). It is still invented. Do not retune it to $100 and call it evidenced (J5 G24). If the rate ever moves, file it as authored balance and keep the chip.

No commission, ABC page, or catalog org publishes a gym-dues table (J5 G1). NOT FOUND: a sport-wide official price by city-tier.

### Members per gym, and per square metre

Gymdesk size buckets (same 4,594-gym sample): under 50 / 50–99 / 100–199 / 200+. Monthly revenue scales ~$2.6k → $6.9k → $13.3k → $26.8k. Revenue per member falls at 200+ (~$66 vs ~$92–$102) because of family/kids pricing, not because large gyms are "worse." ⁠Gymdesk

Kids-program gyms in that sample average ~237 members vs ~107 for adults-only. That is why 400 is a plausible software ceiling (Gymdesk's own Large tier is 201–400) and a dangerous game ceiling: past ~200 the object starts looking like a kids/fitness box (J8 N18).

Floor density is two different objects (J8 N9):
- IBC 2024 Table 1004.5 exercise rooms: 50 gross sq ft / occupant — egress, simultaneous bodies. Evidenced as code, not as join demand.
- Older IHRSA consultant talk: ~2.5 members / m² roster density for commercial clubs. Customary, not combat-gym, not code.
- Combat-gym sq-ft-per-member as a published sport table: NOT FOUND.

Typical independent fight gym is a few thousand sq ft, not a 30–45k Signature box.

### Churn / retention

| Figure | Population | Kind |
|---|---|---|
| 66.4% annual retention (so ~33.6% leave) | HFA 2025 Benchmarking, 175 companies / 17,000+ facilities, FY2024 | evidenced for health/fitness clubs |
| ~1 in 5 quit inside 90 days; then 2–3.5% / month | Gymdesk, 801,000 memberships | vendor-observed martial-arts software |
| Rare attenders cancel 44.2% over 24 months vs 23.2% at 3+ visits/week | same | vendor-observed |
| "Healthy martial-arts school 20–30% annual turnover" | Gymdesk editorial | secondary / customary |

Do not ship 2%, 33.6%, or 66.4% as a game default (J8 N19). Retention is a kind: attendance predicts stay; crowding and a cold room predict leave.

### Revenue split

HFA 2025 responding clubs: membership dues 76.5% worldwide, non-dues 23.5% (PT, wellness, ancillary); US non-dues 29.5%. Evidenced for those clubs, not combat gyms. ⁠Healthandfitness

Gymdesk martial-arts: monthly plan ~63% of people enrolled; ~90% of schools also sell drop-ins / trials. Vendor-observed.

Modeled MMA / boxing P&Ls on Sheets.Market put membership as the base and private lessons as a large second line. Those are modeled, not surveyed. DataIntelo's "PT 28.4% of market / pro end-user 18.5% of revenue / amateur 46.2%" is a market-research compilation — treat as secondary, not a till split.

Fighter purses are not gym income. J4 E1 / J5 G10 stand. Competition-prep fees exist as private contracts (customary). Published gym-of-purse table: NOT FOUND.

Honest FightCamp till for this pack: one membership credit. Privates, merch, seminars, camp fees = scenery unless a later pack evidences a line.

### Equipment cost and payback

Gymdesk boxing-open cost bands: lean studio $20–60k, mid independent $100–250k, full competition $300–560k+. Line items (low–high): ring $3–25k+, bags $5–15k, gloves/pads $1–3k, mats $3–8k, insurance $1–9k / year. ⁠Gymdesk

Member Solutions (via Gymdesk): operational break-even commonly 6–12 months, full profitability including owner draw 12–18 months. Customary operator talk, not a sport table.

Equipment spend per member as a published combat-gym figure: NOT FOUND (J8 N11). Live purchase_cost / weekly_upkeep stay invented gameplay.

Payback of "one more bag" is not published as months-to-member. The honest real link is capacity: a bag or a ring slot is a body that can train at 18:00, not a magnet that pulls the next suburb.

### Hobbyists vs competitors

Published headcount split for a combat gym: NOT FOUND.

Closest evidenced participation split, different grain:
- SFIA 2024 via Gymdesk: 8.4 million Americans in boxing/MMA for fitness (2023) vs 1.16 million who trained MMA for competition. Fitness participation is several times competition participation. That is a national activity count, not "members of one gym." ⁠Gymdesk
- France INJEP ENPPS 2020: among combat-sport practitioners, competition 8% (boxe/pieds-poings) to 14% (judo/luttes). Evidenced for that survey.
- Forum / coach talk (Sherdog and similar): "~10% have competed, ~1% are a serious team; 100–200 members, 5–6 on the fight team." Customary, not a study.
- DataIntelo "pro 18.5% of revenue" is not a headcount. Pros are few and expensive.

Usable kind for design: the floor is mostly hobbyists; the fight team is a small, loud minority; a fighter-only gym is a bad business (customary, and matches the revenue data — membership is the engine).

## 2. What attracts members

Ranked by the retrieved record, not by the current formula.

1. **Coaches / instruction.** Gymdesk visitor survey: level of instruction (including attitude and teaching style, not only accolades) and location dominate every other reason to join. Team / atmosphere next (~12%). Accolades and "we have champions" underperform what owners put on the banner. ⁠Gymdesk
2. **Distance / catchment.** Indonesian conjoint analysis of martial-arts school choice (PMC, 2024): type of art 30%, distance 28%, price 23%, social environment 11%, class format / goal / schedule in the noise. Preferred distance 0–8 km. Hobby intent beat competition intent in that sample. ⁠Pmc.ncbi.nlm.nih
   IHRSA/HFA site-selection (already in J8 N13): primary trade area ~8 minutes, secondary 12; "upwards of 80% of members from within 12 minutes"; site wants ≥60,000, preferably 100,000+ people nearby. Evidenced as that published claim, for health clubs. Combat-gym catchment table: NOT FOUND. Country population must not drive a gym's members (J8 N13).
3. **Price.** Real, but not first. Same conjoint: 23% importance. Combat gyms sit above budget boxes and below boutique premium. Price wars are more a franchise-studio move than an independent fight-gym move.
4. **Facilities and equipment.** Real as capacity and cleanliness, weak as attraction coefficient. Crowding cancels (retention), it does not show up as "three extra members per bag" in any retrieved table. Quality-tier as a join magnet: NOT FOUND. IBC 50 sq ft is a fire-code cap, not a marketing curve (J8 N8).
5. **Community.** Customary and sticky. Members with social ties stay longer (Gymdesk owner stories; combat-sports community interviews). This is retention more than acquisition.
6. **Fight record / famous fighters — published effect on membership?** NOT FOUND as a number. No HFA, IBISWorld, FDD, or peer-reviewed table maps "gym wins" or "UFC champion on the wall" onto recreational headcount.

   What exists:
   - Customary marketing kind. Destination camps (ATT / AKA / Jackson-Wink as a product class) draw amateur and hobby traffic because the room is famous. That is brand, not a coefficient.
   - Media tailwind. Secondary operator copy: UFC cards produce inquiry spikes at MMA schools with a digital front door. Card → trials, not card → +N members forever.
   - Local fight-night as advertising. A 2025 coach video arguing the short answer is "no": the people watching amateur cards are already in the scene or are the fighter's family. They are not a new catchment. ⁠YouTube
   - UFC Gym franchise growth is G17 scenery (fitness chain + brand licence), not evidence that a player title shot fills the bags.

J8 N5–N6 already ranked this: coach above gym reputation above athlete halo. The current 0.6 members per reputation point and +3 per item invert that ranking.

## 3. Rivals

### How real gyms in one city compete
- Catchment overlap. Two fight gyms 10 minutes apart share the same 8–12 minute blob. A third gym in the same blob splits the blob; a gym across the river mostly does not.
- Coaches and fighters, not price lists. Poaching a head coach moves the room. Poaching a name fighter moves a few serious amateurs and some press, not 80 hobbyists. Price-matching is quieter than in boutique fitness.
- Facility one-upmanship is slow. A second ring, a cage, showers, a strength room. Payback is years, funded by dues, not by a purse.
- Saturation. More clubs in a trade area cap growth (customary site-selection / franchise territory). Country gym_count is the wrong object (J8 N16). City rival count is the right grain — and creation already exposes it.

### How management games model a shared local market

| Game | What it models | What worked | What players hated |
|---|---|---|---|
| Football Manager | Reputation + catchment + facilities → attendance / income; AI clubs buy players and upgrade grounds | Local market feels real; poaching and wage gravity create stories | Naive AI deals; catchment that ignores lived geography; stadium upgrades that print money if the formula is loose |
| Two Point Hospital / Campus | Local demand pool + rooms/items as capacity + prestige; overcrowding tanks reputation and income | Visible crowding; items have a job (diagnose / teach / seat); rivals exist as other sites, not as a second till | Invisible modifiers; late-game paint-the-walls busywork; demand that ignores the thing you just built if the pool is wrong |
| Game Dev Tycoon | Market-share pie vs your last score / platforms | Simple pie is readable | Opaque combo tables; feeling you are not actually competing with anyone |
| Boxing Club Manager | 68 gyms, facility upgrades, sponsors, trainers | The fantasy of a gym | Mixed reviews; facilities are a spend sink; no honest local member market; travel/fight logic that breaks immersion |
| Motorsport Manager / F1 Manager | AI teams invest HQ and parts from a budget; shared prize market | Watching a rival spend this season | AI that cheats pace or never spends; HQ upgrades that are mandatory homework |

Lesson that transfers: a visible pool, a visible share, rivals that spend, and a crowding penalty you can see on the floor. Lesson that does not: FM-scale finance AI, Two Point's joke illnesses, GDT's hidden multipliers, BCM's inert upgrade tree.

## 4. Design for FightCamp

One city, one demand pool, every gym in that city takes a share. Members and fighters share the same floor. Rivals spend. Every field below says what reads it and what sets it.

### 4.1 City demand pool D

D is the number of people in this city who will pay some combat gym this week. Not the country's population.

| Field | Who reads it | What sets the number | Mark |
|---|---|---|---|
| city_id / player_city | Membership + WorldPopulation gyms in that city | already live at creation | evidenced as game geography |
| city_size_band | pool | map existing city list to S/M/L from published catchment direction (60k / 100k+ nearby). Magnitude of D per band is invented | direction evidenced (IHRSA site-selection); magnitude invented |
| combat_popularity | pool modifier | already on the country row / WorldPopulation | invented game field (J8 N15) |
| rival_count | saturation | already 2–3 detailed gyms/city | invented world-gen, right grain |
| D_base | D = D_base × combat_mod | pick so that sum of gym members in the city lands in the vendor-observed combat range: roughly 80–250 per gym × 2–3 gyms, not 400 × 3. Suggested authored bands (invented): small city 180, mid 320, large 480 before popularity | invented, aimed at Gymdesk 112-average and N18 "dozens to low hundreds" |
| kids / ClassPass / corporate | — | do not add | scenery (G17 / N18) |

D is a ceiling on the city, not on the player. A mid city of 320 cannot give the player 400 and each rival 200.

### 4.2 Attractiveness A_g and share

```
share_g = A_g / Σ A
target_g = round(share_g × D)
members_g walk toward target_g with existing step_members
```

Weights are invented. Order of weights is not: it follows §2.

| Term in A_g | Weight order | Who reads it | Real figure that sets it | Mark |
|---|---|---|---|---|
| Coaches | 1st | player staff list; rival coach_ids (already seeded, one coach at gen) | Gymdesk: instruction is the join reason. No coefficient published | kind evidenced; weight invented |
| Location / already-in-city | baked into D | gyms not in this city get A = 0 here | 8–12 min catchment | direction evidenced |
| Price | 2nd | a new weekly_dues the player may set later; rivals use a city default | conjoint 23%; collected ~$100/mo vendor-observed | direction evidenced; elasticity invented. Do not ship a price slider in the first slice. First slice keeps $12 and equal price, so price drops out of share |
| Facility / room tier / facility_quality | 3rd | player floor.room_tier; rival facility_quality (live, 25–95) | capacity + cleanliness kind; IBC 50 sq ft is a cap not a pull | kind customary; mapping invented |
| Equipment as capacity | 3rd (same bucket) | station_capacity sum and item condition | one bag ≈ one body in a session (catalog already). Condition: broken kit shrinks effective capacity | capacity shape honest; dollars invented |
| Equipment as attraction | 4th, small | item types present (ring, cage, strength), not raw count | destination rooms have a ring/cage; "+3 per item" is the current lie | attraction coefficient invented and must stay smaller than coaches |
| Gym reputation | 5th, small | live reputation | customary brand; HFA does not publish reputation→joins | invented (J8 N5) |
| Fight record / leading athlete fame | 6th, smallest | live record, leading_athlete_fame | halo customary; elasticity NOT FOUND | invented, tiny, labelled. A title week may add a short inquiry spike (customary media tailwind), not a permanent +80 |
| Community / relationship | skip first slice | — | retention kind | do not author a % |

Replace, do not stack: natural_members stops being 48 + 0.6×rep + 25×tier + 20×room + 3×items. Those five constants were frozen inventions. The new target is share × D.

Suggested first-slice weights (all invented, order not):

```
A = 3.0×coach_score + 2.0×facility_score + 1.0×kit_capacity_score
    + 0.5×kit_attraction_score + 0.4×reputation_score + 0.2×fame_score
```

coach_score / facility_score / etc. are 0–100 normalisations of live fields. Kit attraction is "has a ring / cage / strength block", not 3 × items.

### 4.3 Rivals that invest

Rivals already have financial_strength, facility_quality, ambition, reputation. They do not have cash or a floor list. Do not build them a second Membership.gd.

| Field | Who reads it | What sets it | Mark |
|---|---|---|---|
| financial_strength | investment chance | live 20–96 from country economy ± noise | invented |
| ambition | how aggressively they spend | live string; map "World Title" / "National Recognition" → high spend, "Gym Loyalty" / "Technical Mastery" → hold | invented mapping |
| facility_quality | their facility term in A | live; may now tick | currently fixed — that is the bug |
| rival members | their share of D | new, same formula as the player | invented count |
| rival buy | weekly world tick | if strength high and quality below a band, facility_quality += small or they gain a virtual item flag ("ring", "cage"). Cap the step | invented AI, same shape as player expansion |
| poaching | already live | keep. Unhappy fighters still leave. Do not merge poaching into the member pool — different market (pros vs hobbyists) | live |

A rival that invests raises their A, takes share from the player, and funds it from the same city pool. That is the motive the operator asked for: buy kit and expand because the other desk is doing it too.

### 4.4 Crowding (the actual equipment–income link)

Members use the same floor as the fight team. More members = more dues = worse sessions for pros if stations do not grow.

```
load = fighters_training_today + members × peak_fraction
effective_capacity = Σ station_capacity × condition
crowd_ratio = load / max(effective_capacity, 1)
```

| Field | Who reads it | What sets it | Mark |
|---|---|---|---|
| station_capacity | crowding + fighter training slots | live catalog | honest count-shape; magnitude invented |
| condition | effective capacity | live item wear if present; else 1.0 | gameplay |
| fighters_training_today | load | live training board | live |
| peak_fraction | how many members hit the evening slot | authored 0.15–0.25 | invented. Real peak 17:00–21:00 is customary; utilisation % NOT FOUND for combat gyms (J8 N10) |
| crowd_ratio | two sinks | see below | invented thresholds |

Sinks (both invented magnitudes, real kinds):
- Pro training quality. If crowd_ratio > 1, cut the day's training yield / raise interruption chance on the fight team. This is the "expand so the team can still work" motive.
- Member target. If crowd_ratio > 1.3, shrink this gym's A (retention kind: waits and a packed bag-line). Crowding does not raise D. It steals share from yourself.

IBC 50 sq ft/occupant may later cap simultaneous bodies if the floor has a real m². Do not wire it until total_space is treated as square metres rather than an authored slot count.

### 4.5 Money

```
weekly_dues = members × weekly_rate     # rate stays authored, labelled invented
```

Do not derive the rate from Gymdesk $100. Do not add PT / merch / camp-fee lines. Do not add a gym cut of purses.

Payback of a new item, as the player should feel it:
- item costs purchase_cost + weekly_upkeep (live, invented dollars)
- item raises kit_capacity_score and maybe kit_attraction_score
- A rises → share of D rises → members drift up (cap 6/week already) → dues rise
- if the floor was already crowded, the same item also restores pro training yield

That is the loop. There is no "+3 members" constant.

max_members = 400 can stay as a per-gym safety cap (invented, near Gymdesk's Large-tier ceiling) but D should make it rare. A 400-member fight gym is already G17-adjacent.

### 4.6 Drift

Turn weekly_drift_fraction back to 0.25 and keep max_weekly_member_change = 6. Both invented. Both already tested. A new cage must not print 80 members on Monday.

## 5. What NOT to add, and why
- A sport-wide $199 / $100 / £99 dues table. J5 G24. File a rate as invented or omit.
- gym_cut of purses, corner invoices, naming-rights sim. J4 E3 / J5 G10 / G11 / G14 / G16.
- Kids program, PT studio, merch shop, ClassPass, UFC Gym franchise occupancy. J5 G17, J8 N18. That is a different game and it is how you accidentally hit 400 members for the wrong reason.
- Fame × k as evidenced. Halo is a kind. Coefficient is a lie (J8 N6). Keep it tiny or off in slice 1.
- Country population / gdp_per_capita / gym_count as member drivers. Wrong grain (J8 N12–N16).
- Churn % or seasonal % as a default. Kind is real; a shipped percentage is J5 G9.
- Rival cash ledgers, payroll, and sponsorship AI. Motorsport-Manager HQ homework. Use the three live stats plus a virtual kit flag.
- Price wars in slice 1. Equal price means share is about the room. Price is a second slice, labelled invented elasticity.
- Member agents / individual member sims. Two Point already teaches that one pool + crowding is enough. 400 simulated hobbyists is a new career.
- Raising ATHLETES_PER_GYM or adding a roster cap to "solve" crowding. Crowding is a floor problem, not a contract problem.

## Smallest first slice

One data change, one formula change, one sink. No new screen required beyond numbers the office already shows.
1. Set weekly_drift_fraction to 0.25 in membership.json (unfreeze). **[DONE in S67, b6a3d064.]**
2. Replace natural_members with share × D using live fields only: player room tier + item capacity + coach count + reputation; each city rival's facility_quality + coach presence + reputation. Equal price. Fame weight = 0 in this slice.
3. Apply crowd_ratio as a multiplier on fighter training yield when members + fighters exceed Σ station_capacity.

Stop. Ship that. Then watch whether the player buys a second ring to protect the team or to steal share.

Slice 2 (later): rival facility_quality can tick; kit type flags; a labelled fame spike the week after a home title.

Slice 3 (later, optional): player-set dues, invented elasticity, still no sport-wide dollar.

Still unknown: a published combat-gym table that maps equipment spend, pro-fight success, or city income onto member headcount — there isn't one.

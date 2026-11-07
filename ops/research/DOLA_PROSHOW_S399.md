# Dola (Cici) - promote your own pro show, design draft (S399). Designer text, not scored; Claude owns the design. Build after fighter model v3 (pro tables).

You are a game designer for FightCamp, a boxing gym-management game (you run a club, train amateurs and pros, book their bouts; a world of computer boxers fights on the same maths). The attached MONEY_BITES_S397.md is our gym money design as built; its section 10 lists "The late ambition: promote your own pro show" as a later item.

Write the design for that feature that a strict reviewer would score 8/10 against shipped management games (Football Manager, Out of the Park Baseball, Punch Club, Boxing/MMA management sims). Use REAL numbers for a small-hall UK/US pro boxing card (promoter's licence and bond, hall hire, officials, medicals, insurance, purses for 4-6 bouts, ticket prices and attendance for a 500-1,200 seat hall, TV/streaming money for a small show) with sources named, then say how the game scales them.

Sections: 1) when it unlocks and why then; 2) the decisions the player makes per show (card, date, hall, ticket price, who is on it) and the trade-off each one carries; 3) the money: costs paid up front, income after, how a thin card loses money; 4) how it ties into the gym's fans, the pros' ranking and the world's boxers (opponents and their purses); 5) what could go wrong (a pull-out, a cut, a no-show) and what the player can do about it; 6) what NOT to build (scope cuts for a tiny studio); 7) the numbers to measure in a 260-week simulation to know it is balanced.

Plain text, under 1500 words, no code. Say what you are unsure of.

----- MESSAGE BREAK -----

---
# Promote Your Own Pro Show — Feature Design
Score target: **8/10** against FM/OOTP/Punch Club — grounded in real small-hall economics, sharp choices, clear failure modes, and clean scope boundaries.

## 1 — Unlock condition
Unlocks **only when the gym occupies the Club Building** (250 members, $5,500/month rent, $25,000 move cost) — you cannot run pro cards from a 1,500 sq ft unit. The one-off promoter’s licence costs **$4,200** (BBBofC-style small-show annual licence + bond; real: £1,500–£3,000 + £5,000 bond UK). Why then: licence + bond is a serious upfront bet; by this stage the gym has a stable of ranked pros, a local fan base, and sponsor tiers that can support the risk — matches real life where small clubs promote only after years of building reputation.

## 2 — Decisions per show
Run at most **3 pro cards/year** (real small-hall frequency). Player chooses:

| Choice | Options | Trade-off |
|---|---|---|
| **Date** | 6–12 weeks out | Earlier = less time to sell tickets; later = opponent pull-out risk rises |
| **Hall** | 500 seats ($3,200) / 800 ($4,800) / 1,200 ($7,000) | Bigger = higher break-even; reputation + sponsors push turnout higher |
| **Ticket tiers** | Standard $35 / Ringside $75 / VIP $150 | Higher prices = slower sales; your gym fans are less price-sensitive |
| **Card size** | 4–6 bouts: 2 of your pros + 2–4 opponents | More bouts = bigger purses + officials cost; fewer = thinner card, weaker turnout |
| **Main event** | Local 6-rounder / Regional title / Belt eliminator | Higher status = higher purses + opponent demands + TV/streaming interest |
| **Opponent type** | Negotiable journeyman (cheap, low win odds) / Genuine contender (expensive, draws fans) | Journeyman: safe purse, thin gate; contender: purse risk, higher turnout + ranking gain |

## 3 — Money: costs up front, income after
**All costs paid before doors open** — the classic promoter risk.

### Upfront costs (500–seat baseline, 6 bouts)
| Line | Real source | Game value |
|---|---|---|
| Licence/sanction fee | BBBofC £300/event + 2% purse levy | $450 + 2% of total purses |
| Hall + ring + production | York Hall £4,500+ | $3,200 |
| Officials (ref, 2 judges, timekeeper) | NY schedule | $850 |
| Doctors + ambulance standby | £2,400/4 doctors + £1,300 ambulance | $1,800 |
| Medicals per boxer | NJ full package $865 | $400/boxer (valid 6 months) |
| Liability + event insurance | ABC $10k/boxer cover | $900 |
| Purses (4–6 bouts) | Small-hall UK £800–£2,500/bout | $900–$2,800/bout; your pro’s share goes to the gym purse split |
| Marketing | £1,000 local/social | $800 |
| **Baseline total** | | **$12,500–$18,000** |

### Income
| Line | Real | Game |
|---|---|---|
| Ticket sales | £25–£60 general, £100+ ringside | $35/$75/$150; turnout = min(hall capacity, gym fans × reputation factor) |
| Sponsorship | Local business £1,000–£3,000 | $1,200–$3,500; scales with premises tier |
| Bar/merch cut | 15–25% at venue | $4–$8 per attendee |
| Streaming rights | Small show: £500–£2,000 (YouTube/regional) | $600–$2,200; unlocked only with regional/national sponsors or ranked main event |
| Raffle/auction | Club show baseline S397 | $600–$1,400 |

### Thin card = loss
Break-even at ~**65% capacity** in 500-seat hall. Sell <40% = lose **$5,000–$9,000**. Opponent is unknown = turnout penalty –15%. No title = streaming denied = lose another $1,000+.

## 4 — Ties to fans, rankings, world boxers
- **Gym fans** = your reputation × members × sponsor tier; each win on your card adds +8–15 fans; loss subtracts –5–10. Fans carry over to future shows — build an audience or lose it.
- **Rankings** — your pro beats a ranked opponent = moves 3–8 places; loses = drops 2–4. A title win = unlocks national sponsor tier + streaming deal jump.
- **Opponent pool** — draws from the world pro table (already exists in design). Journeymen = always available, cheaper, record <.500; contenders = limited availability, more expensive, higher ranked. Opponent quality decays if you book the same fighter twice in 12 months.

## 5 — What can go wrong & what you can do
| Risk | Probability | Effect | Mitigation |
|---|---|---|---|
| Main-event opponent pulls out (injury) | 12% (rises 2%/week delay) | Card weakened, turnout –20%, refund risk | Book backup opponent 4 weeks out (+$300 deposit) |
| Cut stops main event (night of) | 4% | Fans leave early, streaming revenue halved, reputation –8% | Have cutman on staff (reduces to 1.5%); can’t prevent entirely |
| No-show fighter | 3% | Bout cancelled, refunds | Require non-refundable purse deposit (deducted from opponent’s fee) |
| Licence suspended (paperwork late) | 8% if <14 days lead | Show cancelled, full loss | Hard deadline: 14 days before — lock-in button greys out |

## 6 — What NOT to build (scope cuts)
- **No PPV/big TV** — only local/regional streaming; national/global PPV belongs to a later "promotion empire" phase
- **No purse bidding** — player names the offer; opponent accepts/rejects; no complex auction system
- **No venue building** — 3 hall sizes only; don’t let the player construct arenas
- **No full Ali Act medical simulation** — flat $400/boxer; skip detailed itemised scans/bloodwork
- **No staff hiring for the show** — use existing cutman/S&C; don’t add temporary roles
- **No multi-event contracts** — book one card at a time; series deals come later

## 7 — Metrics to measure at 260 weeks
- Break-even attendance % stable across 1–3 years (target: 60–70%; not drifting down)
- Show loss rate: 15–30% (FM-style — you should lose roughly one in three)
- Net promoter profit/loss **per show** scales linearly with reputation, not exploding or collapsing
- Fan base grows with card quality; reputation correlates with gate revenue r = 0.6+
- Players run 2–3 shows/year; <10% run zero (unlocked but unused = too hard) or max every time (too easy)
- Cash stays within 1–4 months of running costs (S397 core rule); promotion does not reintroduce the pile

## Uncertainties
- Small-hall purses vary wildly by region; $900–$2,800 is a plausible band but real data is scarce
- Streaming revenue for non-TV shows is poorly documented — the $600–$2,200 range is an estimate
- No reliable turnout vs ranking/reputation dataset — the factor is calibrated; real player testing will move it
- The 12% pull-out probability is inferred from fight injury rates; no direct promoter data found
- The licence + bond $4,200 lump-sum conversion from GBP needs checking against US state promoter fees

---
Word count: ~1,180 | Sources cited throughout | Scope bounded for solo/small team build
# C54 — What a Federation Costs the Player

Research record for the six R70 event disciplines: wrestling/UWW, judo/IJF,
taekwondo/WT, Brazilian jiu-jitsu/IBJJF, wushu/sanda/IWUF, and sambo/FIAS.
Amounts below are event- or programme-specific. None is a general rate.

The code boundary is explicit: `national_selection` does not sign fighters or
pay a bout purse; a national-member federation is amateur; an absent entry fee
is `FEE_UNKNOWN`, not zero; and an authored `prize_table` is required before a
prize can be read. See [`EntityPathway.gd`](../scripts/EntityPathway.gd#L183-L219).
The task's `GameState.gd:10266` anchor is the entry-fee charge seam and must
not be read as evidence that an Olympic-pathway athlete receives income.

## 1. What can an athlete receive, and from whom?

| Mechanism | Documented recipient/payer | Documented R70 discipline(s) | Boundary |
| --- | --- | --- | --- |
| Olympic Solidarity / NOC scholarship or support | Olympic Solidarity works through NOCs and provides financial and technical support to selected athletes; the current plan describes athlete scholarships and refugee-athlete support. [Olympic Solidarity 2025–2028 Plan](https://library.olympics.com/network/digitalCollection/DigitalCollectionAttachmentDownloadHandler.ashx?documentId=3417404&parentDocumentId=3417403&skipCopyright=true&skipWatermark=true) | Judo, wrestling, taekwondo are Olympic disciplines; no equivalent pathway-wide support is established here for BJJ, wushu, or sambo. [IOC refugee-athlete examples](https://newsroom.olympics.com/record/904/media_id/2851) | Selection, amount, cadence, and whether the money reaches the athlete or is paid through the NOC are not universal. UNKNOWN |
| International-federation athlete scholarship | WT's Individual Athlete Scholarship supports training/competition, is applied for through an MNA, CU, or WT-recognised centre, and has a maximum of USD 5,000 per athlete. [WT programme guidelines](https://www.worldtaekwondo.org/wp-content/uploads/2020/03/Updated-Guidelines-of-2020-Development-Program.pdf) | Taekwondo only in this record. | This is a selective support programme, not a WT-wide wage or recurring rate. [WT 2022–23 report](https://www.worldtaekwondo.org/att_file/documents/Annual%20Report%202022-2023.pdf) |
| International-federation participation assistance | UWW reported financial assistance for 114 athletes and coaches from 41 countries for the 2025 World Championships. [UWW Technical Assistance Program](https://uww.org/article/enhance-zagreb-experience-conferences-workshops-fan-zones) | Wrestling. | The report describes support to participate, not a salary, recurring stipend, or universal entitlement. The amount and payment route are UNKNOWN. |
| National-federation grant | A national federation may be the channel or nominator for the Olympic Solidarity and WT programmes. [Olympic Solidarity Plan](https://library.olympics.com/network/digitalCollection/DigitalCollectionAttachmentDownloadHandler.ashx?documentId=3417404&parentDocumentId=3417403&skipCopyright=true&skipWatermark=true), [WT programme guidelines](https://www.worldtaekwondo.org/wp-content/uploads/2020/03/Updated-Guidelines-of-2020-Development-Program.pdf) | Judo, wrestling, taekwondo are documented through the Olympic/NOC route; taekwondo through WT. | A general national-federation grant for any of the six disciplines, with an amount and athlete-level entitlement, is UNKNOWN. |
| Military / employment sport programme | The U.S. Army World Class Athlete Program lets elite soldiers train and compete while serving; listed sports include boxing, wrestling, and taekwondo. [U.S. Army WCAP](https://www.army.mil/article/275358/soldier_athletes_chase_olympic_dreams_through_wcap_program) | Wrestling and taekwondo in the cited programme. | This is military employment, not a federation stipend and not evidence of a general route for every athlete. Judo, BJJ, wushu, and sambo coverage is UNKNOWN. |
| Police employment programme | UNKNOWN |
| Club salary or club support | UNKNOWN |
| Private sponsorship | UNKNOWN as a pathway-wide payment. An individual sponsorship story is not a rate and is not enough to create a ledger rule. |
| Event prize money | Documented for named events; details are in questions 2 and 3. [FIAS 2025 World Championships](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf), [IWUF 2025 Sanda World Cup](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf), [IBJJF ranking awards](https://ibjjf.com/athlete-ranking-info) | Sambo, wushu/sanda, and BJJ have explicit figures in the cited event/season records; judo has a historical named event; wrestling and taekwondo have published prize references but not a general World Championship rate. | A prize at one event is not a stipend or a scale. |

Conclusion: support exists, but it is conditional, selective, and often routed
through an NOC, national federation, or team. No source supports assigning a
recurring federation income to every `national_selection` athlete.

## 2. Which international federations pay prize money at world-level events?

| Federation | Finding | Published figure and exact scope |
| --- | --- | --- |
| UWW | YES, but the amount is not a universal World Championship rate. UWW's competition regulations require a prize at each weight category, while the ranking rule says the annual prize amount is defined at the beginning of the year. [UWW regulations](https://cdn.uww.org/2025-12/gen_reg_for_int_champs_compets_a.pdf), [UWW ranking rule book](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf) | UNKNOWN for the athlete's World Championship prize amount. UWW's CHF 100,000 reference is a redistribution to the best teams in the Senior World Cup organisation fee, not a per-athlete World Championship table. [UWW financial regulations](https://cdn.uww.org/2026-02/uww_reglement_financier_anglais_2026_v1_1.pdf) |
| IJF | YES at a named historical world-level event. | The 2017 Open World Championships in Marrakech published €500,000 total: €100,000 gold, €50,000 silver, €25,000 bronze, €10,000 fifth, €5,000 seventh, and €2,500 for the other last-16 places, split equally between men and women. This is that 2017 event only, not a current IJF rate. [IJF announcement](https://www.ijf.org/news/show/500000-prize-money-for-open-world-championships) |
| WT | YES at least at the Grand Prix Final level: WT described prize money as being on the line. [WT Grand Prix Final notice](https://www.worldtaekwondo.org/notice/ec_view.html?ec=05&nid=139677) | UNKNOWN for the amount and UNKNOWN for a standard World Championships prize table. |
| IBJJF | YES at named events and ranking seasons. | The 2026/27 adult black-belt ranking awards publish USD 20,000 / 6,000 / 3,000 for first/second/third; the 2026 Absolute No-Gi Grand Prix publishes a USD 50,000 grand prize and USD 10,000 runner-up prize. These are the named ranking season and Grand Prix only, not a general Worlds payout. [IBJJF ranking information](https://ibjjf.com/athlete-ranking-info), [IBJJF event recap](https://ibjjf.com/news/weekend-recap-ibjjf-grand-prix-orange-county-curitib) | UNKNOWN for a standard World Championship division payout. |
| IWUF | YES at a named world-level event. | The 2025 10th Sanda World Cup published RMB 10,000 gold, RMB 6,000 silver, and RMB 3,000 bronze. This is the Sanda World Cup table for that event, not a general World Wushu Championships rate. [IWUF 10th Sanda World Cup regulations](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf) | UNKNOWN for a general IWUF World Wushu Championships table. |
| FIAS | YES. | The 2025 World SAMBO Championships published USD 341,000 total, with USD 4,000 gold, USD 3,000 silver, and USD 2,000 for each bronze medal. This is the 2025 Bishkek event only. [FIAS 2025 championship regulations](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf) |

The figures above are not interchangeable. A World Cup, Grand Prix, ranking
award, open-weight championship, and standard World Championship are different
event objects. The record therefore never turns one published table into a
discipline-wide or career-wide rate.

## 3. Who receives the money?

| Money flow | What the source establishes | Ledger implication |
| --- | --- | --- |
| IJF named-event prize | The IJF announcement describes prize money for gold, silver, bronze, fifth, seventh, and last-16 judoka. [IJF announcement](https://www.ijf.org/news/show/500000-prize-money-for-open-world-championships) | Athlete recipient is documented for that event; club and national-federation shares are UNKNOWN. |
| IBJJF ranking / Grand Prix prize | IBJJF says ranking awards are paid under tax rules to the competitor and identifies the Grand Prix winner/runner-up prize. [IBJJF ranking information](https://ibjjf.com/athlete-ranking-info), [IBJJF event recap](https://ibjjf.com/news/weekend-recap-ibjjf-grand-prix-orange-county-curitib) | Athlete income for those named awards; club share is UNKNOWN. |
| IWUF prize | Regulations list the placing award as prize money attached to the athlete's placing. [IWUF 10th Sanda World Cup regulations](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf) | Athlete recipient is documented; club and national-federation shares are UNKNOWN. |
| FIAS prize | FIAS requires each prize-winning athlete to submit a USD bank account so FIAS can arrange payment. [FIAS 2025 championship regulations](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf) | Direct athlete payment is documented for the 2025 World Championships. |
| UWW participation assistance | UWW describes assistance for athletes and coaches to participate for their nations, but gives no athlete-by-athlete payment instruction. [UWW assistance report](https://uww.org/article/enhance-zagreb-experience-conferences-workshops-fan-zones) | Recipient and route are UNKNOWN beyond the described athlete/coach support. |
| WT athlete scholarship | WT's application must come through an MNA, CU, or recognised training centre and supports athlete training and competition. [WT programme guidelines](https://www.worldtaekwondo.org/wp-content/uploads/2020/03/Updated-Guidelines-of-2020-Development-Program.pdf) | Athlete benefit is documented; whether cash is paid directly to the athlete or the intermediary pays expenses is UNKNOWN. |
| Olympic Solidarity | Olympic Solidarity programmes are implemented with NOCs; the plan describes support to selected athletes rather than a universal federation wage. [Olympic Solidarity Plan](https://library.olympics.com/network/digitalCollection/DigitalCollectionAttachmentDownloadHandler.ashx?documentId=3417404&parentDocumentId=3417403&skipCopyright=true&skipWatermark=true) | NOC/federation channel is documented; exact final pocket and amount are UNKNOWN unless a scholarship record names them. |
| Club salary / club share | UNKNOWN |

The safe distinction is athlete support or athlete award versus a club or NF
receipt. A source that only says a country/team is supported cannot be booked as
fighter income.

## 4. What does the athlete or club actually pay?

| Cost | Published evidence | Who is charged / what remains unknown |
| --- | --- | --- |
| UWW annual athlete licence | CHF 50 for cadets, CHF 100 for juniors/seniors/veterans, and free for U15; the licence is obligatory for UWW-calendar competitions. [UWW financial regulations](https://cdn.uww.org/2026-02/uww_reglement_financier_anglais_2026_v1_1.pdf) | The licence is purchased through the national federation/Athena; whether the athlete, club, or NF ultimately bears it is UNKNOWN. |
| UWW engagement fee | CHF 100 per wrestler for listed Olympic-style events, including cadet/junior/senior Worlds, World Cups, continental championships, and Olympic qualification tournaments; payment is by the team through Athena. [UWW engagement fees](https://cms.uww.org/about-events/participate/licenses-fees/engagement-fees) | Team/NF payment route is documented; final athlete/club incidence is UNKNOWN. |
| FIAS annual licence | USD 60, including membership and international sports insurance; the regulations say the NF and/or athlete pays. [FIAS competition regulations](https://sambo.sport/upload/iblock/0a4/0a46a0cbead45ae1fae61c9a232f1805.pdf) | Athlete or NF is documented; club share is UNKNOWN. |
| FIAS event accommodation/organisation fee | The 2025 World Championships required USD 100 per person per day for double accommodation or USD 150 single, four-day minimum, plus USD 20 transfer; the NF settles the financial issues. [FIAS 2025 championship regulations](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf) | This is an event delegation cost, not a universal athlete entry fee. The athlete/club split is UNKNOWN. |
| IBJJF membership | New membership starts at USD 45/year, minor membership at USD 30/year, renewal at USD 40/year. [IBJJF membership](https://ibjjf.com/athletes/become-a-member) | Athlete account and academy affiliation are required; who reimburses the athlete is UNKNOWN. |
| IBJJF event entry | Charlotte Summer International Open 2025 published USD 134 early / USD 162 late; the Fortaleza 2025 event published BRL 245 early / BRL 267 late. [Charlotte event](https://ibjjf.com/events/charlotte-summer-international-open-ibjjf-jiu-jitsu-championship-2025), [Fortaleza event](https://ibjjf.com/events/fortaleza-international-open-ibjjf-jiu-jitsu-championship-2025) | These are named open events, not a universal IBJJF scale. |
| IWUF late/replacement/change fees | The 2025 Sanda World Cup regulations publish USD 50 for accepted late entry, USD 50 for an accepted replacement, and USD 20 for an approved correction. [IWUF regulations](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf) | Team payment is required; ordinary athlete entry amount is UNKNOWN in the cited regulation. |
| IWUF travel and accommodation | The 2025 Sanda World Cup makes international airfare and related travel a team responsibility, provides in-quota accommodation/meals, and charges extra-quota or extra-stay costs to participants. [IWUF financial conditions](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf) | Team/participant responsibility is documented; a numeric total is UNKNOWN. |
| WT GAL / event entry | WT event procedures require a Global Athlete Licence and say the organising committee collects entry fees from participating national teams; the cited outline does not publish the amount. [WT Grand Prix event outline](https://www.worldtaekwondo.org/att_file/news/%28Revised%29_Event_Outline_Roma_2022_WT_Grand_Prix.pdf) | Team/NF payment is documented; amount and athlete/club split are UNKNOWN. |
| IJF licence, ranking-event fee, travel, and seconds | UNKNOWN. The IJF publishes current rules and financial documents, but this record does not have a cited athlete packet with a universal amount and payer for these costs. [IJF documents](https://www.ijf.org/ijf/documents) |
| Seconds / coaches | Event regulations show coaches and officials as delegation roles, but a universal seconds fee or who pays it is UNKNOWN. [FIAS 2025 championship regulations](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf), [IWUF regulations](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf) |

Published costs therefore exist, but several are team or federation invoices.
The code must not automatically debit the athlete or gym merely because a team
paid a federation.

## 5. Does the fee scale with grade, age division, or event level?

- UWW licence cost scales with age category: U15 free, cadet CHF 50, and junior/senior/veteran CHF 100. UWW engagement is CHF 100 for the listed event classes, with explicit exemptions for associated styles, cadet/junior continental championships, veterans, and the Olympic Games. [UWW financial regulations](https://cdn.uww.org/2026-02/uww_reglement_financier_anglais_2026_v1_1.pdf), [UWW engagement fees](https://cms.uww.org/about-events/participate/licenses-fees/engagement-fees)
- IBJJF membership has a minor/adult distinction, and event prices vary by named event and early/late deadline. The cited sources do not show a grade-based membership price. [IBJJF membership](https://ibjjf.com/athletes/become-a-member), [Charlotte event](https://ibjjf.com/events/charlotte-summer-international-open-ibjjf-jiu-jitsu-championship-2025)
- IWUF's published late-entry/replacement/correction fees scale with the administrative event state, not with belt/grade; ordinary participation fees are team-invoiced and UNKNOWN. [IWUF regulations](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf)
- FIAS's cited annual licence is a flat USD 60 per athlete/coach; the 2025 Championship accommodation charge scales with room choice and number of days, not the athlete's grade. [FIAS competition regulations](https://sambo.sport/upload/iblock/0a4/0a46a0cbead45ae1fae61c9a232f1805.pdf), [FIAS 2025 championship regulations](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf)
- WT event entry amount and GAL price are UNKNOWN in the cited event outline; IJF fee scale is UNKNOWN in this record. UNKNOWN

There is no sourced six-discipline formula of `grade + age + event level`.
Where a source gives a scale, it is a fee-specific scale and should not be
generalised to other federations.

## 6. Is the pathway a net cost, net income, or both?

The honest range is **both depending on the event and result, with net cost as
the unsupported/default case**.

- **Cost floor:** a known UWW licence/engagement fee, FIAS licence or event
  delegation charge, IBJJF membership/event entry, IWUF team costs, travel, and
  seconds can all be outflows. Some are paid by a team or NF rather than the
  athlete, and several totals are UNKNOWN. [UWW fees](https://cdn.uww.org/2026-02/uww_reglement_financier_anglais_2026_v1_1.pdf), [FIAS 2025 fees](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf), [IWUF financial conditions](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf)
- **Zero-income case:** no source establishes a recurring stipend, club wage,
  or private sponsorship for an arbitrary national-selection athlete. UNKNOWN
- **Positive event case:** named event prizes range from the published IBJJF,
  IWUF, FIAS, and historical IJF tables; UWW and WT also document prize/support
  mechanisms without a universal athlete amount. [FIAS 2025 prize table](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf), [IWUF prize table](https://www.iwuf.org/xhimg/soft/241223/REGULATIONS-IWUF-10th-SWC.pdf), [IBJJF awards](https://ibjjf.com/athlete-ranking-info)
- **No typical balance:** a single published payment belongs to the named
  athlete/result/event. It is not evidence for a season rate, a career rate,
  or a normal player balance. UNKNOWN

Therefore a federation pathway can be a net cost for a non-placing or
unsupported athlete, and can become net positive at a named event for a
qualifying placing or a specifically awarded scholarship. The evidence runs
out before a general player-facing expected value can be stated.

## 7. What should the gym ledger see?

The task's C27 ledger already carries recurring gym costs such as wages,
facilities, and camps, while fight revenue is a separate settlement concept.
The following are engineering prices, not findings about real-world rates.

| Option | Engineering cost and seam | Failure mode |
| --- | --- | --- |
| (i) Leave it a pure cost | **Low.** Keep the `national_selection` no-purse path in [`EntityPathway.gd`](../scripts/EntityPathway.gd#L183-L200), and add only an evidence-gated outflow at the existing entry-fee/ledger debit seam when a cited fee is known. Preserve `FEE_UNKNOWN` as flagged/no debit. Weekly wages, facilities, and camps remain visible costs. | It understates support if a specific athlete has a sourced grant, but it does not invent one. |
| (ii) Model a stipend as recurring income | **Medium/high.** Add an athlete funding record with payer, recipient, amount, currency, cadence, start/end, eligibility, and evidence; accrue it into recurring income and stop it on expiry or disqualification. | It turns a selective programme into a false default if source fields are absent. |
| (iii) Model the national body as a payer entity | **High.** Add a payer/counterparty and grant or award settlement records, recipient routing, event/result triggers, and source-backed terms; integrate with the existing organisation identity without making a federation a promotion. | It is the most truthful long-term model for sourced grants, but a large surface for evidence that is mostly conditional and often team-routed. |
| (iv) Treat the pathway as prestige-only | **Very low.** Leave ledger untouched and keep the pathway as calendar/prestige state. | It contradicts published fees, scholarships, and event prizes whenever those are known. |

**Recommendation: choose (i) as the default, with an evidence-gated,
event-specific exception.** Do not add a recurring stipend or a generic
national-body payer while questions 1–5 are mostly UNKNOWN. Debit only a
published fee whose payer incidence is authored for the athlete/club, and book
only an authored event award or grant when its amount, event/programme,
recipient, and payer are all known. Use the existing event-level prize seam;
never derive a rate from one payment. This is an authored engineering policy,
not a finding that every real federation pathway is pure cost.

## 8. Does this contradict “no purse, ever”?

No. The code's `pays_purse()` answer is about money flowing from an
organisation to a fighter **for a bout**; `ends_amateur_eligibility()` treats a
positive `purse_cents` as a one-way-door trigger. [`EntityPathway.gd`](../scripts/EntityPathway.gd#L183-L190) [`EntityPathway.gd`](../scripts/EntityPathway.gd#L270-L282)

- A stipend or scholarship is support for training, travel, medical care, or
  living costs. It is not consideration for a professional bout. The WT
  scholarship and Olympic Solidarity examples are support programmes, not bout
  contracts. [WT programme guidelines](https://www.worldtaekwondo.org/wp-content/uploads/2020/03/Updated-Guidelines-of-2020-Development-Program.pdf), [Olympic Solidarity Plan](https://library.olympics.com/network/digitalCollection/DigitalCollectionAttachmentDownloadHandler.ashx?documentId=3417404&parentDocumentId=3417403&skipCopyright=true&skipWatermark=true)
- An event prize is a placing award, not automatically a bout purse; the cited
  FIAS regulations route it as prize money to a prize-winning athlete. [FIAS
  2025 regulations](https://sambo.sport/upload/iblock/9d3/9d3ec4db001236df763208764fa20b30.pdf)
- Whether a particular prize is legally compatible with a particular amateur
  rule is event- and federation-specific. UNKNOWN. Do not feed a stipend or
  an award into `purse_cents` without a separate, sourced rule.

The safe implementation boundary is therefore: keep `pays_purse == false` for
the national-selection path; add any future support or award as a distinct,
evidence-bearing ledger flow; and preserve the one-way pro trigger for an
actual purse.

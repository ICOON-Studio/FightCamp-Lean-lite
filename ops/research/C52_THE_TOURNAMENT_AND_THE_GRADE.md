# C52 — The Tournament and the Grade

**Decision date:** 2026-09-08  
**Scope:** research only. This document proposes no runtime or data edit.  
**Naming law:** a **standing championship belt** is a title object somebody carries and may defend; a **practitioner grade belt** is a rank awarded to the practitioner by an instructor or certifying body. They are separate nouns and never share a save field.

## Decisions page

| Question | Call | One-line why |
|---|---|---|
| A1 | Persist an `event_result` line, not a carried title: `event_id`, organizer, edition/date/week, discipline, age/weight/sex/grade division where applicable, athlete, placing/medal, contest count, ranking points and selection source. | IJF, UWW, WT and IBJJF publish dated editions, brackets/medals and ranking outcomes; the current runtime already treats these disciplines as `event`, not a standing championship object ([R70](R70_DIGEST.md), [IJF](https://www.ijf.org/news/show/baku-set-to-host-the-2026-world-judo-championships), [IBJJF](https://ibjjf.com/news/2026-world-championship-black-belt-recap)). |
| A2 | “World champion” is a historical result label unless an edition rule gives a concrete ranking or entry effect; never print “defending champion” for these event results by default. | The reviewed systems operationalize ranking points, qualification and seeds, not a carried title status ([UWW ranking rules](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf), [WT event outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf), [IBJJF ranking](https://ibjjf.com/athlete-ranking-info)). |
| A3 | Store the organizer’s format and a variable contest count; do not assume one bracket shape. | Judo uses pools/repechage, UWW direct elimination/repechage or Nordic, WT’s Worlds outline uses single elimination, and FIAS currently documents group stage plus knockout/repechage for Sport SAMBO ([IJF draw](https://www.ijf.org/competition/2033/draw), [UWW rules](https://cdn.uww.org/2022-08/rules_v2207_0.pdf), [WT outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf), [FIAS](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda/)). |
| A4 | Choose one game event with an internal ladder resolved as a unit. The existing one-bout-per-card and week medical clock cannot honestly represent every internal contest as an ordinary bout. | A one-day category can contain several contests and repechage paths; splitting it into N current bouts would violate the current card/body contract ([UWW one-day category rule](https://cdn.uww.org/2022-08/rules_v2207_0.pdf), [current body/pathway contract](../scripts/EntityPathway.gd)). |
| A5 | Schedule editions on their own calendars: IJF Worlds annually, UWW Senior Worlds on the annual ranking cycle with Olympic-year exceptions, WT Worlds every two years, IBJJF Worlds annually, Sanda usually on a biennial federation cycle, and Sambo on the FIAS championship calendar. | The frequency is published per body and must not be inferred from the Olympic pathway; the LA28 ladder remains J2’s ruling ([IJF](https://www.ijf.org/news/show/baku-set-to-host-the-2026-world-judo-championships), [WT statutes](https://www.worldtaekwondo.org/att_file/documents/STATUTES%20%28September%2030%2C%202024%29.pdf), [IBJJF calendar](https://ibjjf.com/events), [IWUF](https://www.iwuf.org/en/news/ss/2025/0211/9563.html)). |
| A6 | Entry is federation/national-team selection for IJF/UWW/WT/IWUF/FIAS world events; IBJJF is athlete/academy open entry. Seeds are source-specific rankings or draws. | UWW and WT publish one-athlete-per-country/category rules and ranking seeds; IBJJF requires active membership, academy registration and paid registration ([UWW participation](https://cdn.uww.org/2025-12/gen_reg_for_int_champs_compets_a.pdf), [WT outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf), [IBJJF event](https://ibjjf.com/events/pan-ibjjf-jiu-jitsu-no-gi-championship-2026)). |
| A7 | A medal may change the issuing body’s ranking points or selection standing; it does not create a carried title and does not automatically make the athlete professional. | IJF, UWW, WT and IBJJF each publish ranking consequences; J2 D5 owns the one-way amateur-to-professional door ([IJF](https://www.ijf.org/index.php/news/show/understanding-the-2026-ijf-world-ranking-season), [UWW](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf), [IBJJF](https://ibjjf.com/athlete-ranking-info), J2 D5). |
| B1 | Model levels as organizer-specific ladders: club/local, regional or open, national, continental/international, then world event; use the bodies’ names, not a universal tier enum. | IMMAF explicitly lists club, regional, national, junior/senior and international championships; World Boxing and UWW publish parallel national/continental/world calendars ([IMMAF](https://immaf.org/get-involved/participant-pathways/), [World Boxing](https://worldboxing.org/competitions/), [UWW](https://uww.org/about-events/competitions/wrestling-events/ranking-series)). |
| B2 | Use the existing pathway split: promotion signing, athlete-paid open entry, or national selection. Persist only cited fees; all other entry, travel and accommodation numbers are UNKNOWN. | The live pathway module explicitly uses those three behaviors and `FEE_UNKNOWN`; published examples include IBJJF registration, UWW CHF 100 and WT $150, but they are not universal prices ([EntityPathway](../scripts/EntityPathway.gd), [IBJJF](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026), [UWW](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf), [WT](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4%20August%202025.pdf)). |
| B3 | Division axes are age, weight and sex; grade is a division axis in IBJJF BJJ and an eligibility gate in some pathways, not a universal axis. | IBJJF publishes age/weight/sex/belt divisions; World Boxing, WT, IFMA and FIAS publish age/weight/sex divisions without a grade column ([IBJJF](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026), [World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf), [IFMA](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf), [FIAS](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda/)). |
| B4 | Tournament resolution needs a format field and contest count; amateur formats and round lengths are organizer-specific and must not be copied from professional bout defaults. | World Boxing specifies multi-day single elimination and age-dependent rounds; IMMAF specifies progressive elimination and overtime; UWW, WT and FIAS publish distinct systems ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf), [IMMAF](https://immaf.org/wp-content/uploads/2025/07/IMMAF-FOULS-ALL.pdf)). |
| B5 | Keep an amateur tournament record as event participation/placing. Do not merge it into the professional record; cite J2 D5 for the one-way door. | The event sources expose results and rankings, while professional eligibility is a separate pathway rule (J2 D5; [IBJJF ranking](https://ibjjf.com/athlete-ranking-info)). |
| B6 | Boxing is the first tournament feature: multi-day age/weight/sex elimination with three-round amateur bouts. Amateur MMA follows IMMAF’s club-to-national-to-international ladder and technical minimums. | World Boxing’s rules define the tournament and bout shape; IMMAF publishes the amateur ladder and youth/senior formats ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf), [IMMAF](https://immaf.org/get-involved/participant-pathways/)). |
| B7 | Gym return is medal/result, ranking/selection value where the organizer publishes it, and athlete development; purse is zero on national selection. Travel, preparation time and all unresearched costs are UNKNOWN. | The live pathway module says national selection has no purse and that unknown fees are not free ([EntityPathway](../scripts/EntityPathway.gd)); J2 money rulings are cited rather than re-derived. |
| C1 | **Rule C1:** a standing championship belt is carried and defended as a title object; a practitioner grade belt is awarded to the practitioner by an instructor or certifying body and is never won from an opponent. | This is the separation that preserves R70’s deletion ([R70](R70_DIGEST.md), [C46](C46_THE_BELTS_OWNER.md)). |
| C2 | Grades exist as separate systems: BJJ colours/stripes, judo kyu/dan, karate kyu/dan, taekwondo geup/poom/dan, IMMAF progression, optional WAKO grading, IFMA Khan, and the new FIAS Sambo qualification system. Wrestling has no universal practitioner grade in the reviewed UWW pathway; boxing and sanda have no reviewed international competition grade. | The bodies’ own grading and competition pages support each positive system and the negative findings are deliberately limited to “no universal competition grade found,” not an invented absolute ([IBJJF](https://ibjjf.com/graduation-system), [IJF](https://www.ijf.org/index.php/news/show/towards-a-universal-reference-for-judo-grades), [Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84), [FIAS](https://sambo.sport/en/news/fias-zapustila-ofitsialnyy-sayt-poyasnoy-sistemy/)). |
| C3 | Issuer is discipline/pathway-specific: professor/academy for ordinary BJJ promotion, IJF member federation under IJF validation for judo, school/federation for karate, Kukkiwon/MNA for taekwondo certification, certified coach or federation scheme for IMMAF, WAKO/NF where adopted, IFMA/national federation for Muaythai, and FIAS for Sambo. Portability is never assumed. | The issuers and recognition boundaries are explicit in the relevant regulations ([IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf), [Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84), [IMMAF](https://immaf.org/get-involved/participant-pathways/), [WAKO](https://www.wako.sport/black-belt-directory), [IFMA](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)). |
| C4 | Consume only sourced time/age minima: adult BJJ blue 2 years, purple 1.5 years, brown 1 year; IJF 1st dan at least age 15 plus one year at brown, 2nd dan age 16 plus one year at 1st dan. Taekwondo, karate, IMMAF, IFMA and FIAS exact general time tables remain UNKNOWN here. | Those numbers are in the published IBJJF and IJF systems; Kukkiwon publishes a time/age table but the reviewed page does not expose its row values, so no number is invented ([IBJJF update](https://ibjjf.com/news/ibjjf-minimum-graduation-period-update), [IJF dan rules](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/01/Rules_for_the_awarding_of_IJF_-1768917846.pdf), [Kukkiwon table](https://kukkiwon.or.kr/eng/board/read?boardManagementNo=51&boardNo=1390&menuLevel=2&menuNo=97&page=1&searchCategory=&searchType=&searchWord=)). |
| C5 | A grade can gate BJJ division, WT international entry, IMMAF event entry, IFMA-sanctioned competition and some teaching/refereeing routes; it is not a universal tournament axis. | IBJJF, Kukkiwon/WT, IMMAF and IFMA state those gates; judo dan gates Judobase senior registration and official roles ([IBJJF](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026), [Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84), [IMMAF](https://immaf.org/get-involved/participant-pathways/), [IFMA](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/), [IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf)). |
| C6 | Treat grades as durable records unless an issuing rule says otherwise; regression, lapse and stripping are UNKNOWN; a fighter may hold independent grades in multiple disciplines, with no automatic cross-conversion. | The reviewed sources define award and recognition but do not supply a general regression/lapse rule; separate discipline systems are independent ([IBJJF](https://ibjjf.com/graduation-system), [IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf)). |
| C7 | Implement grade as an independent label plus issuer, awarded week and gate metadata; never derive it from the seven 0–100 stats. | Grade is awarded through instruction, examination, time and certification, while the game’s seven stats are performance attributes ([EntityPathway](../scripts/EntityPathway.gd), [IBJJF](https://ibjjf.com/graduation-system), [Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84)). |

## Evidence and rulings

### 1. The separation that comes first

R70’s runtime contract is already honest: `belt_authority = event` for wrestling,
judo, Brazilian jiu-jitsu, taekwondo, sanda and sambo; those disciplines are
not seeded into `championships`, and old rows are moved to
`retired_championships` as history. The read is copy-safe through
`get_championships()` and `get_retired_championships()` ([championship rules](../assets/data/championship_rules.json), [WorldPopulation window](../scripts/WorldPopulation.gd), [GameState window](../scripts/GameState.gd), [R70](R70_DIGEST.md)).

That rule is not a vocabulary preference. A **standing championship belt** has
a holder, a reign and a future defence. A **practitioner grade belt** is a
qualification a person holds because an instructor or certifying body awarded
it. A tournament medal is neither. In particular, a BJJ blue belt is not a
thing an opponent can take, and an IJF World Championship result is not a
standing championship belt somebody carries into the next card.

### 2. Area A — a championship that is an event

#### A1 — durable object

The smallest honest durable shape is two related records:

```text
championship_event:
  event_id, organizer_id, discipline, edition, date, career_week,
  venue_or_host, format, rules_version, source

event_result:
  event_id, athlete_id, division_age, division_weight, division_sex,
  division_grade_or_null, placing, medal_or_null, contests_in_event,
  ranking_points_awarded_or_UNKNOWN, selection_effect_or_UNKNOWN, source
```

`placing` is a result, not a title status. `division_grade_or_null` is present
for a BJJ grade division and absent for a division that is only age, weight and
sex. `contests_in_event` is a count for the tournament abstraction; it is not a
promise that each internal contest was a normal game bout. Unknown ranking or
selection effects remain UNKNOWN, never zero. This shape follows the published
edition/bracket/medal language of IJF, UWW, WT, IBJJF and FIAS ([IJF](https://www.ijf.org/news/show/baku-set-to-host-the-2026-world-judo-championships), [UWW](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf), [WT](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event_Outline_Wuxi_2025_World_Taekwondo_Championships_4_August_2025.pdf), [IBJJF](https://ibjjf.com/news/2026-world-championship-black-belt-recap), [FIAS](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda)).

Do not add `holder_id`, `since_week`, `defenses` or `last_defended_week` to
this event record. Those are the current standing championship object’s
semantics, and adding them would rebuild the R70 error ([championship rules](../assets/data/championship_rules.json), [C46](C46_THE_BELTS_OWNER.md)).

#### A2 — what persists between editions

The safe persistence is the dated result and whatever points or qualification
the issuing body explicitly carries forward. “World champion” may be printed as
“2026 World Championship gold medallist” in a history line. It does not become
a current holder. A current bracket may say that a person is a former champion
only if the event result is present; it must not say “defending champion” unless
a future source-backed event rule gives that label an operational effect.

The operational effects found are rankings and entry/seeding: UWW uses World
Championship points in its annual ranking and seeds major events from ranking;
WT seeds the World Championship from its World Ranking; IBJJF points are valid
only for the age and grade division in which they were earned and are not
transferable. IJF likewise explains World Championship points as part of the
World Ranking season ([UWW](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf), [WT](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi%202025%20World%20Taekwondo%20Championships_4_August_2025.pdf), [IBJJF](https://ibjjf.com/athlete-ranking-info), [IJF](https://www.ijf.org/index.php/news/show/understanding-the-2026-ijf-world-ranking-season)).

#### A3 — bracket formats and contest counts

| Discipline/event | Published shape | Honest game consequence |
|---|---|---|
| IJF judo Worlds | IJF draw sheets show pools, then repechage and finals; the historical draw material also shows two bronze results in the usual four-pool shape. | A medallist’s contests depend on draw size, pool placement, byes and repechage. Store the result and count; do not hard-code “five contests.” ([IJF draw](https://www.ijf.org/competition/2033/draw), [IJF rules](https://rules.ijf.org/page-24)) |
| UWW wrestling Worlds | Direct elimination with repechage; two repechage winners receive bronze. Under the small-field rule, fewer than six becomes Nordic, while six or seven uses two pools and a semi-final/final path. | A finalist and a repechage medallist have different paths. The category is a one-day competition, but the number of contests is bracket-dependent. ([UWW rules](https://cdn.uww.org/2022-08/rules_v2207_0.pdf)) |
| WT taekwondo Worlds | The Wuxi World Championship outline specifies single elimination, one athlete per MNA per weight and best-of-three rounds; seeding is by WT World Ranking. | Use the event’s published format and result placing. Do not silently insert a repechage or a carried champion status. ([WT outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event%20Outline_Wuxi_2025_World_Taekwondo_Championships_4_August_2025.pdf)) |
| IBJJF Worlds | Published event pages expose bracket, age/grade/weight divisions, official weigh-in and medals; the bracket is an event ladder, not a standing title object. | Contest count varies with bracket size and byes. Preserve the medal/placing and grade division; do not infer a fixed contest count from a single edition. ([IBJJF event](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026)) |
| IWUF sanda | The Sanda World Cup is a federation event, typically biennial, and its current public announcement identifies selection from recent World Wushu Championship top-three athletes; a universal internal bout formula was not located in the reviewed page. | Format and contest count are UNKNOWN until the event regulation is loaded. ([IWUF](https://www.iwuf.org/en/news/ss/2025/0211/9563.html)) |
| FIAS sambo | The 2026 World Championship announcement specifies group stage plus knockout and repechage for Sport and Blind Sambo, with a different group/elimination treatment for Combat Sambo. | The event must carry its format variant; one “Sambo tournament” algorithm would be false. ([FIAS](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda/)) |

#### A4 — the one-day multi-contest problem

The ruling is **(a) one game event with an internal ladder resolved inside it**,
not N separate ordinary bouts. The existing game has a one-bout-per-card
settlement and a medical hold measured in weeks. UWW explicitly says a weight
category is organized in one day, while its published format includes
qualification, elimination, repechage and finals on that day ([UWW rules](https://cdn.uww.org/2022-08/rules_v2207_0.pdf)).

Representing every internal contest as a current bout would require all of the
following new contracts: multiple same-day bookings, same-day weigh-ins and
medical checks, contest-by-contest fatigue and injury, a rest interval shorter
than a game week, and a record that distinguishes tournament contests from
promotion cards. It would also make the current `medical_hold_until_week`
field unable to say whether the athlete can take contest 2 after contest 1.

The smallest honest stage is therefore a `championship_event` that reserves
one date, checks eligibility once, resolves its internal ladder deterministically
and writes one event result line per entrant. It can write an event-level
post-tournament medical hold. It must not pretend that each internal contest
was simulated by the normal bout machinery. Exact contest-by-contest health is
a later body-model project, not a hidden side effect of adding a tournament.

#### A5 — calendar and Olympic cycle

| Event family | Frequency supported by the reviewed source | Game note |
|---|---|---|
| IJF Senior World Judo Championships | Annual editions are explicitly described by IJF. | The Olympic cycle changes qualification/ranking context; J2 owns the pathway and LA28 ladder. ([IJF](https://www.ijf.org/news/show/baku-set-to-host-the-2026-world-judo-championships), J2 LA28 rulings) |
| UWW Senior World Championships | The UWW ranking cycle treats World Championships as an annual ranking anchor, with Olympic-year rules handled by the UWW calendar. | Do not invent a fixed “every X weeks” date; use the edition calendar and retain the ranking season. ([UWW ranking rules](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf), [UWW calendars](https://uww.org/governance/circular-letters-olympic-wrestling)) |
| WT World Taekwondo Championships | Every two years; WT’s statutes say the Senior and Junior World Championships are biennial and not in the same year. | Olympic years affect qualification and weight-category context, not a carried championship status. ([WT statutes](https://www.worldtaekwondo.org/att_file/documents/STATUTES%20%28September%2030%2C%202024%29.pdf)) |
| IBJJF Worlds | Annual event calendar and annual ranking seasons. | Preserve season and grade division because ranking points are not transferable between them. ([IBJJF events](https://ibjjf.com/events), [IBJJF ranking](https://ibjjf.com/athlete-ranking-info)) |
| IWUF Sanda World Cup / Worlds | The Sanda World Cup announcement calls the event typically biennial and selected from recent Worlds. | Treat frequency as event-specific and source-backed; do not make a standing title schedule. ([IWUF](https://www.iwuf.org/en/news/ss/2025/0211/9563.html)) |
| FIAS World Sambo Championships | The FIAS calendar contains annual World Championship editions, including 2025/2026 material reviewed here. | Store the edition date and discipline variant; do not infer a fixed medal-to-ranking conversion. ([FIAS 2026](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda/), [FIAS calendar](https://sambo.sport/en/events/chempionat-mira-po-sambo-2026/)) |

#### A6 — entry and seeding

* IJF world entries are made through eligible national-federation lists and
  weight-category quotas; the exact cap is edition-specific. The 2023 official
  list shows that entries and host allowances are published per edition, so the
  game must not hard-code an old cap ([IJF eligible list](https://www.ijf.org/news/show/the-list)).
* UWW requires a national federation, a current UWW licence, continental
  participation for the relevant age group and normally no more than one
  athlete per weight category. Its ranking rules determine seeds ([UWW participation](https://cdn.uww.org/2025-12/gen_reg_for_int_champs_compets_a.pdf), [UWW ranking](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf)).
* WT’s 2025 World Championship outline is explicit: one athlete per weight
  category per MNA, valid WT licence, national-team registration, and seeding
  by the WT World Ranking, with a host-country seeding rule ([WT outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event_Outline_Wuxi_2025_World_Taekwondo_Championships_4_August_2025.pdf)).
* IBJJF open entry is the different pathway: an athlete needs active membership
  under the current grade and academy, the academy must be registered, and the
  registration is not confirmed until payment. Adult black-belt ranking points
  can also control eligibility at the World Championship ([IBJJF membership](https://help.ibjjf.com/membership/), [IBJJF ranking](https://ibjjf.com/athlete-ranking-info)).
* IWUF and FIAS world events are national-federation/team entries. The FIAS
  rules reviewed here say one athlete per weight category; IWUF’s Sanda World
  Cup announcement identifies selection from recent World Championship
  medallists, not open gym entry ([FIAS](https://sambo.sport/upload/iblock/d10/d10e6b4902ca169b90f27e96a9eb823c.pdf), [IWUF](https://www.iwuf.org/en/news/ss/2025/0211/9563.html)).

#### A7 — what a medal changes

The safe payload is organizer-specific:

| Body | Published consequence | Game field |
|---|---|---|
| IJF | World Championships contribute to IJF World Ranking points and the Olympic qualification context. | `ranking_points_awarded`; selection effect only if the edition packet states it. ([IJF](https://www.ijf.org/index.php/news/show/understanding-the-2026-ijf-world-ranking-season)) |
| UWW | World Championship points remain in the annual UWW ranking and ranking determines seeds; Olympic qualification can award quotas under the edition system. | `ranking_points_awarded`, `seed_effect`, and an edition-specific `quota_effect`. ([UWW](https://cdn.uww.org/2025-12/uww_ranking_rule_book.pdf), [LA28 UWW](https://uww.org/article/uww-announces-new-olympic-qualification-process-la-2028)) |
| WT | WT ranking bylaws assign points by event grade and rank; World Championship rules publish seeds from the ranking. | `ranking_points_awarded`; no universal funding value. ([WT ranking bylaw](https://www.worldtaekwondo.org/att_file/documents/WT%20Ranking%20Bylaw%20%28September%2030%2C%202024_Chuncheon%20Council%20Meeting%29.pdf), [WT outline](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event_Outline_Wuxi_2025_World_Taekwondo_Championships_4_August_2025.pdf)) |
| IBJJF | Points are awarded for the event and remain tied to the age and grade division; points do not transfer between divisions. | `ranking_points_awarded` with `age_division` and `grade_division` frozen. ([IBJJF](https://ibjjf.com/athlete-ranking-info)) |
| IWUF/FIAS | Medal and national medal-table consequences are evidenced; a universal individual ranking-point conversion was not found in the reviewed packets. | Store placing/medal; ranking/selection effect = UNKNOWN unless the event regulation supplies it. ([FIAS](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda), [IWUF](https://www.iwuf.org/en/news/gjwl/2026/0708/10513.html)) |

### 3. Area B — amateur tournaments

#### B1 — real levels

These are calendar families, not a universal progression meter:

| Discipline | Local/grassroots | National or regional | International/world |
|---|---|---|---|
| Boxing | Club/open tournament | National and continental championships; World Boxing Cup/Challenge | Elite and U19 World Boxing Championships, every two years. ([World Boxing](https://worldboxing.org/competitions/)) |
| MMA | Club, regional, national | National federation championships and continental pathway | IMMAF Youth, Junior and Senior Championships. ([IMMAF](https://immaf.org/get-involved/participant-pathways/)) |
| Judo | Club/open and national federation events | Continental Championships/Opens and World Judo Tour | IJF World Championships and Olympic ladder. ([IJF](https://www.ijf.org/news/show/for-a-few-more-points)) |
| Wrestling | Club/regional and national federation events | Continental Championships and UWW Ranking Series | UWW World Championships. ([UWW](https://uww.org/about-events/competitions/wrestling-events/ranking-series)) |
| Taekwondo | MNA and recognized open events | Continental Championships, Grand Prix/recognized events | WT World Championships and Grand Prix circuit. ([WT rules](https://worldtaekwondo.org/att_file/documents/WT%20Competition%20Rules%20%20Interpretation%20%28January%2027%202023%29.pdf)) |
| BJJ | Academy/open IBJJF event | Pan, European, Brazilian and other continental/national events | IBJJF World Championship. ([IBJJF events](https://ibjjf.com/events)) |
| Sanda | National wushu federation events | Continental/multisport events | World Wushu Championships and Sanda World Cup. ([IWUF](https://iwuf.org/en/competitions/)) |
| Sambo | National federation events | Continental youth/junior championships | FIAS World Championships. ([FIAS](https://sambo.sport/en/events/chempionat-mira-po-sambo-2026/)) |

#### B2 — who enters and pays

The existing game’s `EntityPathway` is the authoritative implementation
boundary: `signing` means the promotion contracts and pays; `open_entry` means
the athlete enters and pays; `national_selection` means the national body
enters and there is no purse. It also says an absent fee is `FEE_UNKNOWN`, not
free ([EntityPathway](../scripts/EntityPathway.gd)). J2 D4/D6 already settles
the pathway and money direction; this document does not re-derive it.

Published examples prove why a single fee constant would be false:

| Event | Published athlete fee | Safe use |
|---|---:|---|
| IBJJF São Paulo BJJ Pro 2026 | BRL 286/325 for blue-to-black and BRL 241/281 for white, depending on deadline | Event-local open-entry fee; do not convert to a global IBJJF price. ([IBJJF](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026)) |
| UWW World/Continental regulations | CHF 100 per participating wrestler in the listed championship classes | Source-backed event fee; payer/collection follows the federation entry. ([UWW](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf)) |
| WT Wuxi Worlds 2025 | $150 per athlete; the organizing committee collects from national teams | Edition-specific national-team fee. ([WT](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event_Outline_Wuxi_2025_World_Taekwondo_Championships_4_August_2025.pdf)) |
| Other local, regional, amateur boxing, MMA, judo, karate, sanda and Sambo entries | UNKNOWN in this packet | No plausible fee may be supplied. |

#### B3 — divisions and grade

Every game division remains same-sex, and the sources consistently use age and
weight categories. BJJ is the sharp exception: an IBJJF event publishes age,
sex, weight and practitioner-grade divisions, including adult white/blue/
purple/brown/black and separate youth systems ([IBJJF event](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026), [IBJJF No-Gi](https://ibjjf.com/events/pan-ibjjf-jiu-jitsu-no-gi-championship-2026)).

For boxing, World Boxing rules name age and weight categories and male/female
categories, not a practitioner grade ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf)). WT, IFMA and FIAS likewise publish age/weight/sex competition divisions; their grade systems, where present, are eligibility or training credentials, not a universal fourth bracket axis ([WT](https://www.worldtaekwondo.org/att_file/news/%28v3%29%20Event_Outline_Wuxi_2025_World_Taekwondo_Championships_4_August_2025.pdf), [IFMA](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf), [FIAS](https://new.sambo.sport/en/news/opublikovan-reglament-chempionata-mira-po-sambo-2026-goda)).

#### B4 — format, contests and amateur rules

| Discipline | Tournament format/contest rule found | Game implication |
|---|---|---|
| Amateur boxing | World Boxing generally uses multi-day single elimination; a bout is three rounds with one-minute breaks for Elite/U19 and two-minute rounds for U17. | A boxing tournament is a ladder of separate amateur contests, not one normal card bout. ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf)) |
| Amateur MMA | IMMAF recommends progressive single elimination for Juniors/Seniors/Masters, three-minute rounds and a tournament overtime round; youth uses a round robin in the current formula. | The event object must own rest, progression and youth rules. ([IMMAF formula](https://immaf.org/wp-content/uploads/2025/07/IMMAF-FOULS-ALL.pdf)) |
| BJJ | IBJJF publishes a bracketed event with immediate weigh-in before the first fight, grade/age/weight divisions, and Open Class options for eligible medallists. | Store the bracket result and grade division; exact count varies by bracket. ([IBJJF event](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026)) |
| Judo/wrestling/taekwondo/sanda/Sambo | The federation formats in Area A apply at amateur and international event levels; the relevant edition rules decide pools, repechage or elimination. | Never reuse the professional promotion-card ruleset merely because the result is a bout. |

#### B5 — amateur record

The durable record should be the event result: date, edition, division,
opponent/contest count if the tournament resolver exposes it, placing and any
published ranking points. The federation or operator may also retain a licence,
membership and results history, but a universal cross-sport amateur-record
format was not located. That portion is UNKNOWN and should not be invented.

The result does not silently become a professional record. J2 D5 owns the
one-way door from amateur to professional; use that ruling rather than making
“number of amateur wins” a promotion trigger. U4 owns how one ordinary amateur
bout is produced; C52’s new object is the tournament around those contests, not
a replacement for U4.

#### B6 — boxing first, then amateur MMA

Boxing is the starter discipline, so the first tournament implementation should
be a World-Boxing-shaped event: an entrant in one age/weight/sex division,
single-elimination rounds over one or more days, three amateur rounds (two for
U17), then a placing/medal result. The event can be resolved as a unit while
retaining `contests_in_event`; it must not pretend the ordinary single-bout
offer/settlement loop produced a complete tournament ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf)).

Amateur MMA has a clearer age ladder than a promotion card: club/regional/
national events feed U14, U16, U18, U21 and Senior Championships, with youth
rules and technical minimums. IMMAF also recommends a progression scheme and
minimum grade for official entry. The game should treat that grade as a
separate qualification record, not as a championship belt or a derived combat
stat ([IMMAF](https://immaf.org/get-involved/participant-pathways/)).

#### B7 — the gym’s side

The gym’s direct costs are an event entry fee where sourced, athlete membership
or licence where required, travel/accommodation and preparation time. Only the
first two may be charged when an event packet authors them. Travel, lodging,
per-diem, coach costs and an exact week cost are UNKNOWN in this research; no
plausible number is allowed. National selection has no purse under the current
pathway contract ([EntityPathway](../scripts/EntityPathway.gd)).

The direct return is an event result, medal and any published ranking or
selection effect. A gym’s exact financial return, sponsorship value or facility
reputation multiplier is UNKNOWN. That is preferable to pretending that an
amateur federation pays a promotion purse.

### 4. Area C — the grade

#### C1 — implementer rule

**C1. A standing championship belt is a carried-and-defended title object; a
practitioner grade belt is an awarded practitioner rank and can never be won
from an opponent.** A tournament gold medal is an `event_result`, not either
kind of belt.

#### C2 — ladders and negative findings

| Discipline | Grade ladder found | Game ruling |
|---|---|---|
| Brazilian jiu-jitsu | Adult white, blue, purple, brown, black, then black-belt degrees and red-family ranks; youth uses grey, yellow, orange and green families with stripes/degrees before the adult transition. ([IBJJF](https://ibjjf.com/graduation-system)) | Grade is a label and a BJJ division gate. It is not a standing championship belt. |
| Judo | Kyu coloured grades and dan grades; IJF’s 2026 programme defines official dan recognition, with kyu as the educational progression. ([IJF](https://www.ijf.org/index.php/news/show/towards-a-universal-reference-for-judo-grades), [IJF dan rules](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf)) | Independent grade record; ordinary World Championship division is not grade-split. |
| Karate | Kyu and dan are real practitioner grades, but the issuing syllabus is style/federation-specific. WKF kumite competition is divided by gender, age and weight and does not use grade as a universal World Championship axis. ([WKF rules copy](https://www.nrkcompteam.com/files/WKF_2026_Kumite_Competition_Rules_MASTER_COPY_V11.pdf)) | Grade may be local/federation-scoped; do not make one global karate grade without an issuer. |
| Taekwondo | Geup is the coloured-grade route; Kukkiwon certifies Poom (1–4) and Dan (1–9). WT competition requires Kukkiwon-certified Poom/Dan under the cited certification boundary. ([Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84), [WT/Kukkiwon agreement](https://www.worldtaekwondo.org/wp-content/uploads/2019/06/2018-2019_Annual_Report.pdf)) | Grade is an entry credential for WT competition, not an event championship belt. |
| Wrestling | No universal practitioner-grade ladder was found in the reviewed UWW Olympic wrestling rules, rankings or World Championship entry rules. “Belt wrestling” is a separate UWW discipline and must not be read as a wrestler’s grade. ([UWW disciplines](https://cms.uww.org/disciplines), [UWW participation](https://cdn.uww.org/2025-12/gen_reg_for_int_champs_compets_a.pdf)) | No wrestling grade in the game unless a later named federation source is authored. |
| Boxing | World Boxing’s eligibility and tournament rules use age, weight, sex, membership/licence and nationality; no practitioner-grade ladder was found. ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf)) | No boxing grade. Do not invent one for the starter discipline. |
| MMA | IMMAF has a technical progression/grading scheme, with event minimums such as Orange for U18 and Green for senior entry in its published pathway. ([IMMAF](https://immaf.org/get-involved/participant-pathways/)) | IMMAF grade is a federation/pathway qualification; it is not a universal MMA grade and not a standing championship belt. |
| Kickboxing | WAKO has a grading system and certified black-belt directory, but says the grading system is optional for national federations/members. ([WAKO](https://www.wako.sport/black-belt-directory)) | Grade exists only with WAKO/issuer scope; it is not a universal kickboxing requirement. |
| Muaythai | IFMA launched a standardized 15-level Khan system, with official IFMA certification at Khan 9–15 and a minimum Khan level for IFMA-sanctioned competition. ([IFMA](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)) | IFMA grade is an independent qualification; no generic promotion-card belt is implied. |
| Sanda | No universal practitioner-grade ladder was found in the reviewed IWUF event and competition material; the sources describe age, weight, sex and federation selection. ([IWUF competitions](https://iwuf.org/en/competitions/), [IWUF Sanda World Cup](https://www.iwuf.org/en/news/ss/2025/0211/9563.html)) | No global Sanda grade in the game; local Wushu grades remain UNKNOWN unless scoped to an issuer. |
| Sambo | FIAS launched a 2026 qualification system with ten levels: Beginner, six Student levels and Candidate for Master, Master and Grand Master. ([FIAS](https://sambo.sport/en/news/fias-zapustila-ofitsialnyy-sayt-poyasnoy-sistemy/)) | FIAS practitioner grade is real and new; it remains separate from the FIAS World Championship event result. |

The negative findings are intentionally scoped. “No universal grade found in
the reviewed international competition rules” is not permission to invent a
grade, and it is not a claim that no local school anywhere uses a rank.

#### C3 — issuer and portability

* **BJJ:** an academy professor awards the ordinary practitioner grade; IBJJF
  membership and black-belt certification provide an organizational record.
  The IBJJF system supports instructors and professors, and membership requires
  the professor/academy record ([IBJJF graduation](https://ibjjf.com/graduation-system), [IBJJF membership](https://help.ibjjf.com/membership/)).
* **Judo:** from 2026, IJF member national federations may award grades under
  IJF rules, with IJF validation; the IJF is the international reference and
  foreign-national awards have residence and membership conditions ([IJF regulations](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf)).
* **Karate:** issuer and portability depend on style/federation; WKF
  competition rules do not create one global kyu/dan registry. Store issuer
  rather than assuming a grade transfers ([WKF rules](https://www.nrkcompteam.com/files/WKF_2026_Kumite_Competition_Rules_MASTER_COPY_V11.pdf), [WSKF grade regulation](https://www.wskf.org/images/Dan.pdf)).
* **Taekwondo:** Kukkiwon owns the Poom/Dan certification system; WT governs
  the sport competition and its MNAs administer promotion tests in the cited
  cooperation arrangement. A WT competition credential is therefore not a
  generic school-colour claim ([Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84), [WT annual report](https://www.worldtaekwondo.org/wp-content/uploads/2019/06/2018-2019_Annual_Report.pdf)).
* **MMA, kickboxing, Muaythai, Sambo:** the issuer is respectively the
  IMMAF-certified coach/federation pathway, WAKO where adopted, IFMA/national
  federation, and FIAS. Portability outside that issuer is UNKNOWN and must
  remain a source-backed field ([IMMAF](https://immaf.org/get-involved/participant-pathways/), [WAKO](https://www.wako.sport/black-belt-directory), [IFMA](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/), [FIAS](https://sambo.sport/en/news/fias-zapustila-ofitsialnyy-sayt-poyasnoy-sistemy/)).

#### C4 — what earns a grade

The useful numbers for the game are:

| System | Published minimum | Safe game interpretation |
|---|---|---|
| IBJJF adult | White: none; blue: two years; purple: one and a half years; brown: one year. The 2025/2026 update removes the minimum for an adult World Champion at blue, purple or brown. Ages 4–15 have no minimum stay; ages 16–17 have no white/blue minimum and adult rules govern the later transition. ([IBJJF update](https://ibjjf.com/news/ibjjf-minimum-graduation-period-update), [IBJJF graduation](https://ibjjf.com/graduation-system)) | Store `awarded_week` and compare elapsed weeks. Apply the world-champion exception only when the exact adult BJJ event and grade are present. |
| IJF dan | 1st dan: age 15+ and one year at brown; 2nd dan: age 16+ and one year at 1st dan. The examination includes kata, technical and knowledge components. ([IJF dan programme](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/01/Rules_for_the_awarding_of_IJF_-1768917846.pdf)) | These are sourced week-clock gates; do not reduce them to fight wins. |
| Kukkiwon taekwondo | Kukkiwon publishes a standard time/age table, but the reviewed HTML page exposes only the attachment, not the row values. ([Kukkiwon table](https://kukkiwon.or.kr/eng/board/read?boardManagementNo=51&boardNo=1390&menuLevel=2&menuNo=97&page=1&searchCategory=&searchType=&searchWord=)) | UNKNOWN until the attachment is independently transcribed. Use the published Poom/Dan age boundary only. |
| Karate, IMMAF, WAKO, IFMA, FIAS | The reviewed sources describe examinations, certified coaches, optional systems or a new framework but do not supply one complete general time table usable across all issuers. ([IMMAF](https://immaf.org/get-involved/participant-pathways/), [WAKO](https://www.wako.sport/black-belt-directory), [IFMA](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/), [FIAS](https://sambo.sport/en/news/fias-zapustila-ofitsialnyy-sayt-poyasnoy-sistemy/)) | Store issuer and evidence; do not invent weeks. |

Competition results can be one factor in judo’s grade evaluation and an adult
BJJ World Championship can remove a BJJ minimum, but neither fact turns grade
into a championship object. IJF explicitly describes body, study and spirit;
IBJJF’s exception is a rule for promotion timing, not a title defence ([IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf), [IBJJF](https://ibjjf.com/news/ibjjf-minimum-graduation-period-update)).

#### C5 — what a grade gates

* BJJ grade gates the IBJJF bracket itself: the published event divides age,
  sex, weight and practitioner grade; adult black-belt certification and
  referee routes have separate requirements ([IBJJF event](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026), [IBJJF referee help](https://help.ibjjf.com/rules/)).
* Judo dan is required for Judobase senior registration and for IJF referee,
  coach and instructor roles under the 2026 IJF regulation ([IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf)).
* Kukkiwon Poom/Dan gates entry to WT-organized international competitions;
  this is the sharp Kukkiwon/WT boundary ([Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84)).
* IMMAF publishes minimum technical grades for youth and senior official
  competition, and IFMA says a minimum Khan level will be required for
  IFMA-sanctioned competition ([IMMAF](https://immaf.org/get-involved/participant-pathways/), [IFMA](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)).
* WAKO grading is explicitly optional for national federations/members, so it
  cannot be a universal kickboxing gate; no universal grade gate was located
  for wrestling, boxing or Sanda ([WAKO](https://www.wako.sport/black-belt-directory), [World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf), [IWUF](https://iwuf.org/en/competitions/)).
* FIAS’s 2026 system is a qualification framework, but the reviewed source
  does not yet state a World Championship entry gate. That gate is UNKNOWN
  ([FIAS](https://sambo.sport/en/news/fias-zapustila-ofitsialnyy-sayt-poyasnoy-sistemy/)).

#### C6 — regression, lapse and multiple disciplines

No reviewed official source states a general regression, lapse or stripping
rule that can be applied across these systems. Store `status = active` only as
an internal record state if a later issuer rule supports it; otherwise do not
create automatic expiry, demotion or stripping. Membership expiry is not grade
regression. A person can have independent judo and BJJ records because those
systems have different issuers; no grade should transfer between disciplines.
This is a deliberate UNKNOWN boundary, not a claim that every local issuer
uses identical rules ([IBJJF membership](https://help.ibjjf.com/membership/), [IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf)).

#### C7 — number, label or gate

The recommendation is **label + issuer + awarded week + evidence + optional
gate metadata**. It is not a single numeric stat and it is not derived from
the seven 0–100 performance stats. A grade can be ordered for display, but its
meaning is issuer-specific: BJJ blue is not “40% grappling,” and a WT-required
Kukkiwon certificate is not a second `GRAPPLE` roll. The sources describe
examination, training, minimum time and certification, which are independent
of the game’s performance-stat vector ([IBJJF](https://ibjjf.com/graduation-system), [IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/06/IJF_grades_and_dan_regulations-1780395735.pdf), [Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84), [EntityPathway](../scripts/EntityPathway.gd)).

## Build order — smallest honest change first

1. **Event result abstraction.** Add no standing championship object for the six
   `event` disciplines. Define a dated `championship_event` and per-athlete
   `event_result` contract with placing, medal, division axes, contest count
   and explicit UNKNOWN fields. Keep the existing `championships` and
   `retired_championships` meanings intact ([championship rules](../assets/data/championship_rules.json)).
2. **One-day resolver.** Resolve a tournament’s internal ladder as one event
   using a deterministic format adapter. Write one event-level health outcome;
   do not call the ordinary one-bout-per-card machinery N times. Preserve the
   fact that the exact body clock is not represented yet ([WorldPopulation](../scripts/WorldPopulation.gd)).
3. **Entry pathways.** Reuse `EntityPathway`: IBJJF open entry can debit a
   cited event fee; federation events use national selection with no purse; a
   missing fee remains UNKNOWN ([EntityPathway](../scripts/EntityPathway.gd)).
4. **Boxing starter tournament.** Implement the smallest multi-day amateur
   elimination event around World Boxing’s published age/weight/sex and round
   rules. Do not add a boxing grade ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf)).
5. **Independent grade record.** Add issuer-scoped grade label, awarded week,
   evidence and gates. Start with the sourced IBJJF and IJF time minima; leave
   other times UNKNOWN until the actual issuer table is authored ([IBJJF](https://ibjjf.com/news/ibjjf-minimum-graduation-period-update), [IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/01/Rules_for_the_awarding_of_IJF_-1768917846.pdf)).
6. **Only later:** redesign the body/card model if the product truly needs each
   internal contest to consume real recovery, injuries, medical holds and
   individual bout histories. C52’s finding is that the current machinery
   cannot do that honestly.

## Migration cost table

| Option | Existing saves | Cost/risk | Decision |
|---|---|---|---|
| Leave event disciplines empty | None | Honest current state, but no tournament gameplay. | Keep as baseline. |
| Add event/result records without internal contest simulation | Additive, no retirement rewrite | Low; results are new records and standing championship data stays untouched. | First implementation. |
| Resolve one tournament as one event with internal ladder | Additive event schema; old saves unaffected | Medium; needs deterministic format adapters and event-level health semantics. | Second implementation. |
| Add grade records with issuer and sourced minima | Additive; absent grade remains absent | Medium; portability and issuer evidence must be preserved; no stat migration. | Third implementation. |
| Model every internal contest as a normal bout | Requires body clock, card, booking, medical and record redesign | High; current week hold and one-bout-per-card rules cannot represent a same-day ladder. | Defer; never smuggle this into a tournament feature. |
| Reintroduce a standing championship object under a new name | Requires new belt seeding and migration | High semantic regression; it would undo R70. | Reject. |

## Explicit non-decisions

* No event discipline receives a standing championship belt or a substitute
  federation belt.
* No event gold medal creates `holder_id`, `defenses`, a reign or a future
  defence; “defending champion” is not printed without a source-backed
  operational rule.
* No practitioner grade belt is won from an opponent, defended on a card or
  derived from `GRAPPLE` or another 0–100 stat.
* No universal grade is invented for wrestling, boxing or Sanda; optional or
  issuer-scoped systems remain scoped to their issuer.
* No guessed entry fee, travel cost, accommodation cost, purse, funding value
  or gym return is stored as a number. UNKNOWN is not zero.
* No amateur record automatically converts to a professional record; J2 D5 is
  the one-way door.
* No WBA/WBC/IBF/WBO catalogue expansion, logo, event poster, standing
  championship belt artwork or practitioner grade belt artwork.
* No mixed-sex division and no cross-discipline grade conversion.

## Sources used

Local runtime and prior rulings: [championship_rules.json](../assets/data/championship_rules.json), [EntityPathway.gd](../scripts/EntityPathway.gd), [R70_DIGEST.md](R70_DIGEST.md), [C46_THE_BELTS_OWNER.md](C46_THE_BELTS_OWNER.md), [WorldPopulation.gd](../scripts/WorldPopulation.gd), [GameState.gd](../scripts/GameState.gd). J2 D4/D5/D6 and U4 are cited by ruling number as instructed; they are not re-derived here.

Primary external sources are linked inline above, including IJF, UWW, World Taekwondo, IBJJF, World Boxing, IMMAF, IWUF, FIAS, WAKO, IFMA and Kukkiwon rules, calendars and regulations.


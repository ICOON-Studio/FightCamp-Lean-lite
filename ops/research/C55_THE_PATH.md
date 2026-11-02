# C55 — THE PATH: HOW A FIGHTING CAREER IS ACTUALLY WALKED

**Decision date:** 2026-09-08  
**Scope:** research only. This record does not change runtime, data, tests, or the earlier C52/J2/U4 deliverables.

## Reading rules

The four settled boundaries are carried forward, not re-derived: C52 owns how grades are earned; J2 D5 owns the one-way amateur door; U4 owns the coach-led amateur booking and separate amateur record; C54 owns federation cost and income uncertainty ([C52 digest](C52_DIGEST.md), [J2](J2_THE_FEDERATION_PATHWAY.md), [U4 digest](U4_DIGEST.md), [C54](C54_WHAT_A_FEDERATION_COSTS.md)).

“Common”, “typical”, an age distribution, a conversion rate, a purse rate, and a normal time-to-competence require population evidence. A single biography, event, or athlete study is not such evidence. Where no denominator was found, this record says **UNKNOWN**.

The current seams matter. Athlete creation receives a discipline before the career story exists ([GameState creation window](../scripts/GameState.gd#L821)); `WorldPopulation` uses regional and gym `discipline_weights` when generating an intake ([WorldPopulation](../scripts/WorldPopulation.gd#L553), [WorldPopulation](../scripts/WorldPopulation.gd#L614)); `_turn_pro` stores only a sticky flag, week, and cause ([GameState](../scripts/GameState.gd#L5499)); and its two current causes are `promotion_contract` and `paid_bout` ([GameState](../scripts/GameState.gd#L5619), [GameState](../scripts/GameState.gd#L11705)). `EntityPathway` keeps the amateur door and purse distinction explicit ([EntityPathway](../scripts/EntityPathway.gd#L183), [EntityPathway](../scripts/EntityPathway.gd#L196), [EntityPathway](../scripts/EntityPathway.gd#L274)).

## A. THE ENTRY — where a career starts

### Q1 — At what ages do people actually begin each discipline?

The requested “actual beginning age” is **UNKNOWN** for every discipline as a population fact. The sources below document access or competition categories, not the age distribution at which ordinary people first join a gym.

| Discipline | What is sourced | Honest classification |
|---|---|---|
| Boxing | USA Boxing athlete membership is available from age 8, and its published high-performance divisions include junior 15–16, youth 17–18, and elite 19–40 ([USA Boxing membership](https://www.usaboxing.org/membership), [USA Boxing FAQ](https://www.usaboxing.org/high-performance/high-performance-faq)). | Childhood-accessible; actual start-age distribution **UNKNOWN**. |
| Wrestling | UWW publishes U15, U17, U20 and senior categories; U15 is 14–15, with 13 permitted in the year with medical and parental authorization ([UWW rules](https://cdn.uww.org/2026-01/wrestling_rules.pdf)). | Childhood-accessible; actual start-age distribution **UNKNOWN**. |
| Brazilian jiu-jitsu | IBJJF publishes kids/juvenile/adult divisions, and its event pages separate juvenile from adult by birth year and belt ([IBJJF event divisions](https://ibjjf.com/events/fortaleza-international-open-ibjjf-jiu-jitsu-championship-2025)). | Childhood-accessible; actual start-age distribution **UNKNOWN**. |
| MMA | IMMAF publishes Youth C 12–13, B 14–15, A 16–17, junior and senior categories; IMMAF separately says youth programmes may begin as early as 6–7 ([IMMAF participant pathways](https://immaf.org/get-involved/participant-pathways/), [IMMAF grading](https://immaf.org/2022/03/21/grading-in-mixed-martial-arts-what-why-how/)). | Childhood-accessible; actual start-age distribution **UNKNOWN**. |
| Judo | IJF competition and grade sources establish youth and adult pathways, but no reviewed source supplies a population distribution for first practice. | **UNKNOWN** as an actual-start claim. |
| Karate | C52 records kyu/dan systems but no universal age-of-entry statistic ([C52](C52_THE_TOURNAMENT_AND_THE_GRADE.md)). | **UNKNOWN**. |
| Taekwondo | Kukkiwon describes Poom/Dan testing and certification, not the population age at first practice ([Kukkiwon](https://kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=3&menuNo=67)). | **UNKNOWN**. |
| Muaythai | IFMA publishes youth age categories and Khan levels, but not the population age at first practice ([IFMA rules](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf)). | **UNKNOWN**. |
| Kickboxing | WAKO documents an optional grading system, not a population entry-age distribution ([WAKO grading](https://www.wako.sport/black-belt-directory)). | **UNKNOWN**. |
| Sanda | No reviewed IWUF source supplied an actual-start-age distribution; C52 found no universal practitioner grade ([C52 digest](C52_DIGEST.md)). | **UNKNOWN**. |
| Sambo | C52 records a FIAS practitioner qualification system, not an actual-start-age distribution ([C52 digest](C52_DIGEST.md)). | **UNKNOWN**. |

Therefore the game may distinguish “childhood-accessible competition pathway” from “adult-only pathway” where a rule actually says so, but it must not turn competition minimums into a typical joining age.

### Q2 — What do the first two years look like before competition?

There is no single documented two-year sequence shared by all disciplines: **UNKNOWN**. The evidence supports a distinction between a formal requirement and local custom:

* **Boxing, formal example:** USA Boxing requires participating members to be members for USA Boxing activities, requires an annual physical, and issues an athlete passbook that must be present at a sanctioned event; the membership page says the book records membership history, bouts, and events ([USA Boxing membership](https://www.usaboxing.org/membership)). Those are documented requirements for that pathway, not a universal boxing rule everywhere.
* **Wrestling, formal example:** UWW rules require a licence and state that medical and parental authorization can be part of the age-category exception; the licence request is to be sent before the competition ([UWW rules](https://cdn.uww.org/2026-01/wrestling_rules.pdf)). The source does not establish a universal first-two-years training timeline.
* **BJJ, formal example:** IBJJF competition requires an athlete membership under a registered academy with an eligible instructor signing the application ([IBJJF academy certification](https://help.ibjjf.com/academy-certification/)). Academy membership before competition and the first belt period are plausible, but a universal duration is **UNKNOWN**.
* **MMA, formal example:** IMMAF sets youth technical restrictions and minimum technical standards, and its pathway is administered through national federations ([IMMAF participant pathways](https://immaf.org/get-involved/participant-pathways/)). That documents a competition gate, not a universal first-two-years itinerary.
* **Smoker/interclub:** U4 records smoker/interclub practice as a custom that may not create an official record, not as a universal licence or medical requirement ([U4](U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md)).

Membership, class attendance, sparring, and a coach deciding when an athlete is ready are ordinary gym practice, but the reviewed sources do not support one cross-discipline sequence or time budget. They remain **UNKNOWN** as requirements unless a specific pathway packet supplies them.

### Q3 — Do people arrive with a discipline, or does the gym assign one?

Both entry patterns are real, but no reviewed source establishes their prevalence. A person can join a boxing club through a membership that explicitly includes training, while BJJ and IMMAF competition pathways attach the athlete to an academy or national-federation structure ([USA Boxing membership](https://www.usaboxing.org/membership), [IBJJF academy certification](https://help.ibjjf.com/academy-certification/), [IMMAF participant pathways](https://immaf.org/get-involved/participant-pathways/)). Those sources do not say whether the person arrived with a discipline or whether a gym assigned it.

The causal importance of geography, club speciality, family, body type, and prior sport is **UNKNOWN** as a cross-sport rate. `discipline_weights` is therefore a reasonable authored regional intake prior, not evidence that geography is the real-world causal driver ([WorldPopulation](../scripts/WorldPopulation.gd#L553), [WorldPopulation](../scripts/WorldPopulation.gd#L614)). The game should present it as world-generation flavour, not as a finding about why an individual chose a discipline.

## B. THE CROSSOVER — a different event from turning professional

### Q4 — What are the real discipline-transition paths?

The paths in the question are documented as plausible athlete-development routes, but their frequency and usual transition stage are **UNKNOWN**. The sources show no denominator from which to say that one is “typical.” A combat-sport profile study found distinct training backgrounds across sports and notably different non-combat training patterns for MMA and wrestling, but it is not a transition-rate census ([profiling combat-sports athletes](https://pmc.ncbi.nlm.nih.gov/articles/PMC8387537/)).

| Path | What the evidence supports | Frequency / usual stage |
|---|---|---|
| Wrestling → MMA | MMA is explicitly built around wrestling among other combat skills, and IMMAF’s coach pathway recognizes coaches with wrestling or striking backgrounds ([IMMAF annual report](https://immaf.org/wp-content/uploads/2021/01/IMMAF_25644.2-Annual-Report-2020-v6-copy.pdf), [MMA training review](https://opensportssciencesjournal.com/contents/volumes/V8/TOSSJ-8-1/TOSSJ-8-1.pdf)). | The route is real; commonness and transition age/stage **UNKNOWN**. |
| Judo → BJJ or sambo | IJF’s cross-sport rule exists precisely because ranked judoka may seek international combat-sport competition outside judo, subject to permission ([British Judo summary of IJF SOR 4.1](https://www.britishjudo.org.uk/ijf-release-participation-of-judoka-in-other-combat-sports-international-competition/)). | The route is real; commonness and transition age/stage **UNKNOWN**. |
| Karate/taekwondo → kickboxing | WT/Kukkiwon and WAKO have separate credential systems, so a transfer is a move between disciplines rather than a universal grade conversion ([Kukkiwon](https://kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=3&menuNo=67), [WAKO](https://www.wako.sport/black-belt-directory)). | The route is plausible and documented by separate systems; commonness and stage **UNKNOWN**. |
| Kickboxing → Muaythai | IFMA’s Khan system is a distinct Muaythai pathway with its own athlete, coach, and official requirements ([IFMA grading](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)). | A transition can occur; commonness and stage **UNKNOWN**. |
| Amateur boxing → pro boxing → MMA | IMMAF treats a professional combat-sports record or contracted purse as relevant to amateur-MMA eligibility; that establishes a rules interaction, not a prevalence rate ([IMMAF eligibility](https://immaf.org/athletes/athlete-eligibility/)). | The sequence is possible; commonness, stage, and whether it is usually addition or switch **UNKNOWN**. |

These are crossover findings, not turn-pro findings. A wrestler may begin MMA training without accepting a professional bout; the professional door is a separate later decision governed by J2 D5 ([J2](J2_THE_FEDERATION_PATHWAY.md)).

### Q5 — What do governing bodies permit or restrict?

The strongest sourced restriction is IJF-specific: an athlete on an IJF World Ranking List may not take part in an international competition in another combat sport without IJF authorization; the cited IJF release states a first violation can produce a two-month suspension and a second a two-year suspension from IJF/Union activities ([British Judo Association](https://www.britishjudo.org.uk/ijf-release-participation-of-judoka-in-other-combat-sports-international-competition/)). That is a real restriction with a sanction, not a general combat-sport law.

Other sourced boundaries are narrower:

* IMMAF may deny amateur-MMA eligibility for a professional combat-sports record or contracted purse; non-payment alone does not preserve eligibility if a bout contributes to a professional record ([IMMAF 2021 eligibility](https://immaf.org/wp-content/uploads/2021/03/2021-Amateur-MMA-Eligibility-to-Compete.pdf), [IMMAF current eligibility](https://immaf.org/athletes/athlete-eligibility/)).
* IBJJF does not treat prior sport experience as invisible: proven collegiate/national wrestling, Olympic wrestling, Greco-Roman wrestling, professional MMA, or a judo black belt prevents an athlete from entering an IBJJF event as a white belt ([IBJJF event rules](https://ibjjf.com/events/fortaleza-international-open-ibjjf-jiu-jitsu-championship-2025)).
* Kukkiwon/WT and IFMA impose their own grade or certification gates for their own competition and official roles; those are credential rules, not a blanket ban on training another discipline ([Kukkiwon](https://kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=3&menuNo=67), [IFMA rules](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf)).

For World Boxing, UWW, karate, WAKO kickboxing, sanda, and sambo, this review found no universal cross-discipline ban comparable to IJF SOR 4.1, but “the body ignores it” is **UNKNOWN** without a discipline-specific regulation. No general finding supports stripping every old grade, suspending every crossover, or making every second discipline ineligible.

### Q6 — What carries over, and does a wrestling record appear in an MMA record?

Technical experience can carry over as background, but an automatic record, ranking, or grade conversion is not sourced. The relevant bodies keep their own eligibility and credential systems: IJF regulates judo standing, IBJJF recognizes prior wrestling/judo experience for belt placement, and IMMAF evaluates professional combat-sports history separately ([IJF SOR restriction](https://www.britishjudo.org.uk/ijf-release-participation-of-judoka-in-other-combat-sports-international-competition/), [IBJJF event rules](https://ibjjf.com/events/fortaleza-international-open-ibjjf-jiu-jitsu-championship-2025), [IMMAF eligibility](https://immaf.org/athletes/athlete-eligibility/)).

An amateur wrestling record does **not** become an MMA record in the sources reviewed. It should remain a wrestling event history while MMA starts its own amateur/pro record; U4’s settled game ruling is the same two-currency split ([U4 digest](U4_DIGEST.md)). Whether a particular promoter prints the wrestling record in an MMA biography is presentation-specific and **UNKNOWN**; it must not be merged into MMA wins and losses.

What carries: prior skills, prior event history, and any credential that the new organizer explicitly recognizes. What does not carry automatically: ranking points, grade, title, or bout record. The reset/recognition rule is organizer-specific, not a universal zeroing formula.

### Q7 — Is crossover usually a switch or an addition?

The real-world prevalence of switch versus addition is **UNKNOWN**. Training in multiple combat skills is documented for MMA athletes, and MMA itself combines boxing, kickboxing/Muaythai, wrestling, BJJ, and other skills ([MMA training review](https://opensportssciencesjournal.com/contents/volumes/V8/TOSSJ-8-1/TOSSJ-8-1.pdf), [combat-sport athlete profile study](https://pmc.ncbi.nlm.nih.gov/articles/PMC8387537/)). That supports “addition” as a valid training state, not a claim that it is the majority career shape.

**Authored game recommendation:** store a set/history of disciplines and a current competed-in discipline. A transition can be additive in training while being a switch for the new competition record. A second scalar field would encode only one crossover; a history preserves wrestler → MMA → boxing or concurrent BJJ/MMA without erasing provenance.

### Q8 — What does a crossover cost in time and performance?

An exact “competitive after N months” rule is **UNKNOWN**. A combat-sport athlete study reports roughly four combat and three non-combat training sessions per week in its sample, with MMA and wrestling doing more non-combat training; that is a sample description, not a conversion timetable ([profiling combat-sports athletes](https://pmc.ncbi.nlm.nih.gov/articles/PMC8387537/)).

The supported qualitative conclusion is that the converted athlete must learn a new ruleset, distances, scoring/decision environment, and missing technical domains. IMMAF’s pathway uses minimum technical standards rather than simply counting fights, which supports testing competence instead of assuming that the old record transfers ([IMMAF grading](https://immaf.org/2022/03/21/grading-in-mixed-martial-arts-what-why-how/)). Which performance component fails first for a particular conversion—striking, takedown defence, submissions, cage work, conditioning, or judging adaptation—is **UNKNOWN** as a universal rule.

## C. THE GRADE AS A MECHANIC — what it does

### Q9 — What does holding a grade actually get?

Outside the C52 divisions and entry credentials, the benefits are discipline-specific:

* **BJJ:** an IBJJF-registered academy must have a registered black-belt head instructor; this makes a recognized black belt relevant to academy status and teaching authority in that system ([IBJJF academy registration](https://ibjjf.com/academy-registration-informations)). A grade alone does not establish a universal income amount: **UNKNOWN**.
* **Judo:** IJF’s revised grade system requires national-federation dan awards to be validated by IJF from 2026, and official judo coaching roles have separate IJF Academy qualifications ([IJF grade reform](https://www.ijf.org/index.php/news/show/towards-a-universal-reference-for-judo-grades), [IJF documents](https://www.ijf.org/ijf/documents/16)). A dan is not a sourced wage entitlement.
* **Taekwondo:** Kukkiwon Poom/Dan certification is an eligibility credential for WT international competition, and WT referee classes separately require Dan and examination ([Kukkiwon](https://kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=3&menuNo=67), [WT referee regulations](https://www.worldtaekwondo.org/att_file/documents/Regulations%20on%20the%20Administration%20of%20the%20International%20Kyorugi%20Referees%20%28In%20force%20as%20of%20September%201%2C%202022%29.pdf)).
* **Muaythai:** IFMA’s Khan levels can gate athlete entry and official roles; Khan 7 is listed for coaches/seconds and technical officials, while higher levels reach instructor/teacher recognition ([IFMA rules](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf), [IFMA grading announcement](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)).
* **MMA:** IMMAF grades set minimum technical standards for youth/senior competition, while coach certification is a separate three-tier route ([IMMAF participant pathways](https://immaf.org/get-involved/participant-pathways/), [IMMAF coaches](https://immaf.org/get-involved/coaches-area/)).
* **Kickboxing:** WAKO’s grading is explicitly recommended but optional for member federations, so a universal teaching/refereeing/club gate is **UNKNOWN** ([WAKO](https://www.wako.sport/black-belt-directory)).
* **Karate, boxing, wrestling, sanda, and sambo:** C52 found no universal practitioner-grade consequence for the reviewed boxing/wrestling/sanda paths; karate and sambo systems are issuer-specific. A universal income or role entitlement is **UNKNOWN** ([C52](C52_THE_TOURNAMENT_AND_THE_GRADE.md)).

### Q10 — Who awards it, and can the player’s gym award it?

The answer is not one global “coach promotes athlete” rule:

| Discipline | Issuer found | Can an ordinary gym award the recognized competition grade? |
|---|---|---|
| BJJ | A professor/academy promotes ordinary students; IBJJF academy status requires a registered black-belt head instructor ([IBJJF graduation](https://ibjjf.com/graduation-system), [academy registration](https://ibjjf.com/academy-registration-informations)). | **Yes, for ordinary academy promotion where the professor is eligible;** competition recognition remains issuer/registration scoped. |
| Judo | National federations award dan grades, with IJF validation required for national-federation dan awards under the 2026 reform ([IJF](https://www.ijf.org/index.php/news/show/towards-a-universal-reference-for-judo-grades)). | **No** for an unvalidated official dan; local kyu teaching autonomy exists, but the universal local-to-official boundary is **UNKNOWN**. |
| Karate | C52 found school/federation/style-scoped kyu/dan systems, not one universal issuer ([C52 digest](C52_DIGEST.md)). | **UNKNOWN** across karate; depends on style and federation. |
| Taekwondo | Kukkiwon issues Poom/Dan certificates through its promotion-test system; certified examiners administer the tests ([Kukkiwon promotion test](https://kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=3&menuNo=67), [examiner course](https://wta.kukkiwon.or.kr/en/trainingProcess/examinerCourse?lang=en&menuid=1079&topMenuid=1072)). | **No** for the recognized Kukkiwon credential unless the gym participates in the authorized test chain. |
| Muaythai | IFMA and its national-federation/educator structure issue Khan certification and set minimums ([IFMA grading](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)). | **Only if recognized by that structure;** an arbitrary gym’s local rank is not proven portable. |
| MMA | IMMAF’s pathway uses trained coaches and national-federation standards; its coach education is a separate certification route ([IMMAF pathway](https://immaf.org/get-involved/participant-pathways/), [IMMAF coaches](https://immaf.org/get-involved/coaches-area/)). | **A qualified coach may assess within the pathway;** an arbitrary gym cannot be assumed to issue a recognized grade. |
| Kickboxing | WAKO grading exists but is optional for members ([WAKO](https://www.wako.sport/black-belt-directory)). | **UNKNOWN** outside a participating federation. |
| Boxing, wrestling, sanda | C52 found no universal practitioner grade in the reviewed international competition paths ([C52](C52_THE_TOURNAMENT_AND_THE_GRADE.md)). | **N/A / UNKNOWN**; there is no single recognized grade to assign. |
| Sambo | C52 records a FIAS qualification system ([C52 digest](C52_DIGEST.md)). | **FIAS/national-system recognition is required;** ordinary-gym authority is **UNKNOWN**. |

The game should therefore store issuer and evidence, not assume the head coach’s word is portable across disciplines.

### Q11 — What delays or denies a grade beyond time minima?

The sourced non-time gates include demonstrated competence and formal assessment: Kukkiwon describes promotion testing as evaluation of technical and training level; its examiner system exists to standardize judgment ([Kukkiwon](https://kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=3&menuNo=67), [Kukkiwon examiner course](https://wta.kukkiwon.or.kr/en/trainingProcess/examinerCourse?lang=en&menuid=1079&topMenuid=1072)). IJF says its new dan programme defines minimum knowledge and competencies, and IFMA describes merit-based progression plus contribution credits for instructor/master levels ([IJF grade reform](https://www.ijf.org/index.php/news/show/towards-a-universal-reference-for-judo-grades), [IFMA grading](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)).

For BJJ, the IBJJF graduation system supports professors and instructors but does not publish one universal examination-failure or attendance rule ([IBJJF graduation](https://ibjjf.com/graduation-system)). For politics, attendance thresholds, an instructor’s personal refusal, and a universal “failed test” rate across all disciplines: **UNKNOWN**. The honest game rule is that sourced minimum time opens eligibility to be considered; it does not guarantee promotion.

### Q12 — Design: how should white → black be played?

The following is **authored game design**, not a finding about real martial-arts promotion. Every option preserves C52’s settled rule that grade is independent of the seven stats ([C52 digest](C52_DIGEST.md)).

| Option | Engineering cost against current seams | Consequence |
|---|---|---|
| (i) Automatic award when a sourced minimum elapses | **Low.** A week counter and issuer-scoped grade field fit the C52 build order ([C52 digest](C52_DIGEST.md)). | Cheap but falsely guarantees a promotion that the sources describe as competence/issuer dependent. |
| (ii) Gym decision with cost and consequence | **Medium.** Add a pending-grade read, a coach/player decision, an evidence gate, and one ledger/training consequence; it fits the existing gym/desk decision vocabulary and leaves `GameState`’s weekly progression seam intact ([GameState](../scripts/GameState.gd#L821)). | Captures the management question while keeping sourced minimums as gates. The cost and consequence are authored and must be labelled in UI. |
| (iii) Examination that can fail | **High.** Requires per-discipline syllabi, examiner/issuer authority, attempts, failure state, and deterministic test resolution; C52 does not provide those runtime seams ([C52](C52_THE_TOURNAMENT_AND_THE_GRADE.md)). | Most simulation-rich, but it would invent failure probabilities unless each discipline gets evidence. |
| (iv) Pure display, no mechanical effect | **Very low.** Store and print the independent grade only. | Honest about uncertainty but does not make the grade matter in a management game. |

**Recommendation — option (ii), authored design:** use sourced time/age/issuer requirements to make a grade “ready to consider,” then put a one-off gym decision in front of the player with an authored cost and an authored consequence such as training access or coach bandwidth. Do not make the cost, probability, or consequence a real-world finding. Defer actual failed examinations until a discipline-specific evidence packet and seam exist.

### Q13 — What should a grade change mechanically?

The sourced effects are gates and access: IBJJF grade divides events, Kukkiwon Dan/Poom gates WT international competition, IFMA Khan levels gate participation and roles, and IMMAF grades gate technical standards ([IBJJF event](https://ibjjf.com/events/fortaleza-international-open-ibjjf-jiu-jitsu-championship-2025), [Kukkiwon](https://kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=3&menuNo=67), [IFMA rules](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf), [IMMAF pathway](https://immaf.org/get-involved/participant-pathways/)).

It must not change by reading the seven stats; C52 explicitly makes grade an independent issuer-scoped record ([C52 digest](C52_DIGEST.md)). A grade may **influence** access to a class, event, coach role, or competition division as an authored game rule grounded in those sourced gates. The honest causal direction is: training and assessment produce grade; grade can then open opportunities that affect future training and performance. The reverse—stats crossing a threshold and silently producing a grade—is forbidden.

## D. THE DECISION TO TURN PRO

### Q14 — What actually leads an amateur to turn professional?

Documented case-based sport research identifies several real motives and transitions—early-life conditions, amateur experience, an Olympic-medallist route, a struggling amateur route, and a professional launch—but it studies selected narratives, not a population rate ([career trajectories of two world champion boxers](https://www.tandfonline.com/doi/abs/10.1080/17430437.2018.1463727)). C54 separately shows that federation support and prizes are selective and event-specific rather than a universal income stream ([C54](C54_WHAT_A_FEDERATION_COSTS.md)).

Therefore:

* coach judgment, an offer, financial opportunity, a desire for a professional career, and a perceived amateur ceiling are **documented possibilities**, not a ranked universal list ([career trajectories study](https://www.tandfonline.com/doi/abs/10.1080/17430437.2018.1463727));
* an Olympic cycle can be a real alternative in boxing, whose current LA28 qualification system provides a defined federation pathway ([World Boxing LA28](https://worldboxing.org/ioc-approves-olympic-qualification-system-for-boxing-competition-at-la28));
* a universal age, record, win percentage, coach trigger, or failed-Olympic-cycle trigger is **UNKNOWN**.

The game should offer these as competing circumstances, not claim that one threshold makes real amateurs turn pro.

### Q15 — Pros and cons, including the cost of the one-way door

J2 D5 and the current `EntityPathway` rule are settled for the game: a signing, an actually paid purse, or an authored professional ruleset can end amateur eligibility; C54 says a federation grant or event prize must not be confused with a purse ([J2](J2_THE_FEDERATION_PATHWAY.md), [EntityPathway](../scripts/EntityPathway.gd#L274), [C54 digest](C54_DIGEST.md)). Real-world costs remain discipline- and jurisdiction-specific:

| Discipline/path | What is gained | What is lost or at risk |
|---|---|---|
| MMA | A contracted professional bout/purse and access to the professional career market are real distinctions in IMMAF’s eligibility rule ([IMMAF](https://immaf.org/athletes/athlete-eligibility/)). | IMMAF amateur eligibility is lost on the sourced professional triggers; there is no MMA Olympic pathway in the reviewed sources. Going back is not supported by the one-way rule ([J2](J2_THE_FEDERATION_PATHWAY.md)). |
| Boxing | Professional contests can offer a purse and a separate professional career; Olympic qualification remains a live World Boxing pathway under current LA28 rules ([World Boxing LA28](https://worldboxing.org/ioc-approves-olympic-qualification-system-for-boxing-competition-at-la28)). | Whether a particular professional contract or bout ends Olympic eligibility depends on the governing rules in force; a universal permanent loss is **UNKNOWN**. Historical AIBA rules did impose contract-related eligibility restrictions, but that is not a safe current universal rule ([historical AIBA rule](https://www.bgboxing.org/wp-content/uploads/2015/AIBA%20Technical%20Rules%20-%2001.02.2015.pdf)). |
| Judo, karate, taekwondo, Muaythai, kickboxing, sanda, sambo | A professional promotion or paid event may create a different market and purse opportunity where one exists; a universal rate is **UNKNOWN** ([C54](C54_WHAT_A_FEDERATION_COSTS.md)). | These disciplines do not share one reviewed universal “turn pro” door. Olympic, federation, grade, and event eligibility after a paid appearance are **UNKNOWN** unless the relevant body says so. |
| BJJ/open-entry competition | C52/J2 distinguish open-entry tournament prize from a contracted professional purse ([C52 digest](C52_DIGEST.md), [J2](J2_THE_FEDERATION_PATHWAY.md)). | Whether a given event prize or contract changes eligibility is event/ruleset-specific **UNKNOWN**; it must not be assumed from the amount alone. |

In every row the irreversible cost is not “all amateur sport everywhere ends”; it is the specific eligibility rule that the athlete has crossed. The game must expose the applicable rule before the decision.

### Q16 — Is there a typical amateur record or age?

**UNKNOWN.** The reviewed evidence provides selected athlete cases, competition age bands, and discipline-specific eligibility rules, but no cross-discipline published age/record threshold. The study of professional/amateur boxers is a sample, not a typical-career law ([boxing cohort](https://pmc.ncbi.nlm.nih.gov/articles/PMC2579447/)). A single athlete’s record or age must never be generalized into “most fighters turn pro at X.”

### Q17 — Who decides, and who has the veto?

The real conversation is shared, but the athlete’s consent is the hard veto. A promoter or promotion presents an opportunity; the fighter decides whether to accept a contract; a manager may negotiate where one exists; the coach advises on readiness and risk. Professional boxing regulations recognize the boxer/manager/promoter contract relationship, but they do not create one universal workflow for all combat sports ([Philippines professional-boxing regulation](https://elibrary.judiciary.gov.ph/thebookshelf/showdocs/10/57119)).

For the amateur side, U4’s sourced mapping is narrower: the coach is the verb for making a match, and the gym desk confirms or enters it ([U4](U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md)). That is different from deciding to turn professional.

**Authored game mapping:** the player/gym is the management desk; the head coach supplies the readiness recommendation; a manager/promoter role supplies contract or offer context; `FighterRequests` is the fighter’s stated preference. The fighter must retain the refusal/veto before an irreversible professional action. This mapping is design, not a claim that every real gym uses these exact titles.

### Q18 — Design: what should the game put in front of the player?

This is **authored game design**, priced against the current seams. Today `_turn_pro` is silent and is called from signing and paid-bout settlement ([GameState](../scripts/GameState.gd#L5499), [GameState](../scripts/GameState.gd#L5619), [GameState](../scripts/GameState.gd#L11705)).

| Option | Engineering cost | Result |
|---|---|---|
| (i) One-off decision modal at a sourced trigger | **Medium.** Add a pre-action read and decision result before the existing signing/paid-bout call, then preserve `turned_pro_cause` and week. | Clear, irreversible moment; needs a warning seam for every trigger. |
| (ii) Standing athlete choice that can be flipped | **High.** Requires a durable intent state, repeated consequences, cancellation rules, and protection against a “flip” bypassing the one-way door. | More visible but contradicts the settled sticky door unless the flip only changes readiness, never eligibility. |
| (iii) Keep current consequence but warn first | **Low.** Add a preflight warning to signing and paid-bout acceptance; no new career mode. | Preserves current pathways while fixing the silent-door failure. |

**Recommendation — option (iii), authored design:** warn immediately before accepting the contract or paid bout, show the exact sourced cause, what amateur eligibility will be lost, what record freezes, and what money is/ is not guaranteed; require confirmation from the player and fighter preference gate. This lands beside the two existing callers, keeps J2’s one-way rule, and avoids inventing a second “professional career mode.” Option (i) is a valid later expansion if a separate player-initiated readiness trigger is added; option (ii) is not recommended because a standing toggle implies reversibility the rules deny.

## E. THE SHAPE OF THE WHOLE THING

### Q19 — Three contrasting career timelines

These are **authored illustrative scenarios**, not typical biographies and not population findings. Ages, records, and money not supplied by a source are deliberately marked **UNKNOWN**. They show the shape the game needs to represent.

#### 1. Childhood-entry boxer

| Stage | Real-world evidence / honest value | Current game gap |
|---|---|---|
| Childhood entry | Boxing athlete membership is available from age 8; actual starting age for this person is **UNKNOWN** ([USA Boxing membership](https://www.usaboxing.org/membership)). | Creation begins with a discipline already assigned; no entry event or reason ([GameState](../scripts/GameState.gd#L821)). |
| First training period | Membership, annual physical, and passbook are documented in the USA Boxing pathway; duration before first contest is **UNKNOWN** ([USA Boxing membership](https://www.usaboxing.org/membership)). | No career-entry, licence, medical, or readiness timeline. |
| Amateur contests | Amateur record exists as its own competition currency in the settled U4 model; this illustrative athlete’s record is **UNKNOWN** ([U4 digest](U4_DIGEST.md)). | The task’s career-path story is absent even though the record seam exists. |
| Grade | Boxing has no universal practitioner grade in the reviewed C52 path; grade is **N/A** ([C52 digest](C52_DIGEST.md)). | No explicit “no grade” provenance on the career path. |
| Olympic/pro decision | Olympic boxing qualification is a real federation pathway; the decision age, record, offer, and reason are **UNKNOWN** ([World Boxing LA28](https://worldboxing.org/ioc-approves-olympic-qualification-system-for-boxing-competition-at-la28)). | The game has no player/fighter conversation; pro conversion is silent at a caller. |
| Money | Purse, funding, prize, and net balance for this illustrative athlete are **UNKNOWN**; C54 forbids generalizing event money ([C54](C54_WHAT_A_FEDERATION_COSTS.md)). | No path-linked cost/decision explanation. |

#### 2. Adult-entry BJJ player

| Stage | Real-world evidence / honest value | Current game gap |
|---|---|---|
| Adult entry | IBJJF publishes adult age/belt divisions; this person’s actual joining age is **UNKNOWN** ([IBJJF event](https://ibjjf.com/events/fortaleza-international-open-ibjjf-jiu-jitsu-championship-2025)). | No arrival source, academy choice, or adult-entry reason. |
| Academy and first competition | Competition requires IBJJF membership under a registered academy and an instructor signature ([IBJJF academy certification](https://help.ibjjf.com/academy-certification/)). | No academy affiliation/licence path in the career record. |
| Grade progression | C52’s sourced adult minima are blue 2 years, purple 1.5 years, and brown 1 year; they are gates, not a promise of promotion ([C52 digest](C52_DIGEST.md), [IBJJF minimums](https://ibjjf.com/news/ibjjf-minimum-graduation-period-update)). | No independent issuer/grade history or promotion decision. |
| Tournament record and money | Event placing/ranking and any prize are event-specific; this athlete’s record and money are **UNKNOWN** ([C52 digest](C52_DIGEST.md), [C54](C54_WHAT_A_FEDERATION_COSTS.md)). | No event-to-career path or honest money provenance. |
| Professional decision | A contracted purse is a different rule from an open-entry tournament prize; the decision age and record are **UNKNOWN** ([J2](J2_THE_FEDERATION_PATHWAY.md), [C54](C54_WHAT_A_FEDERATION_COSTS.md)). | No warning or fighter/coach decision. |

#### 3. Wrestler who crosses to MMA

| Stage | Real-world evidence / honest value | Current game gap |
|---|---|---|
| Youth/adult wrestling | UWW has youth and senior age categories; this athlete’s start age and wrestling record are **UNKNOWN** ([UWW rules](https://cdn.uww.org/2026-01/wrestling_rules.pdf)). | Only one discipline is stored at creation. |
| Crossover decision | Wrestling-to-MMA is a documented pathway, but its frequency, age, and conversion time are **UNKNOWN** ([IMMAF annual report](https://immaf.org/wp-content/uploads/2021/01/IMMAF_25644.2-Annual-Report-2020-v6-copy.pdf)). | No transition event, prior-discipline history, or missing-skill cost. |
| MMA preparation and amateur bouts | IMMAF technical grades/minimums govern entry; the MMA amateur record is separate from wrestling history ([IMMAF participant pathways](https://immaf.org/get-involved/participant-pathways/), [U4 digest](U4_DIGEST.md)). | No second discipline or separate crossover record narrative. |
| Turning professional | A paid purse, signing, or other settled J2 trigger is a separate later event; this athlete’s trigger, age, and record are **UNKNOWN** ([J2](J2_THE_FEDERATION_PATHWAY.md), [EntityPathway](../scripts/EntityPathway.gd#L274)). | Crossover and pro conversion would otherwise collapse into one discipline/flag story; the current silent caller does not represent the conversation. |
| Money | Contract, purse, grant, prize, and net balance are **UNKNOWN**; federation support cannot be generalized ([C54](C54_WHAT_A_FEDERATION_COSTS.md)). | No path-linked income/cost provenance. |

The wrestler-to-MMA case demonstrates why area B and area D must remain separate: the athlete can cross disciplines while still amateur, and only a later ruleset/contract/purse event closes the amateur door.

### Q20 — One change with the best engineering return

**Authored recommendation:** add one independent `career_path` history made of dated, issuer-aware path events: entry source and start age/week (if known), current and prior disciplines, transition/addition choice, grade record reference, competition record reference, and the exact professional-door cause. Land it at the existing athlete-creation seam and append to it beside the existing `_turn_pro` callers ([GameState](../scripts/GameState.gd#L821), [GameState](../scripts/GameState.gd#L5499), [GameState](../scripts/GameState.gd#L5619), [GameState](../scripts/GameState.gd#L11705)). This is not a claim about real data shape; it is the smallest authored structure that connects entry, crossover, grade decisions, and the pro conversation without deriving grade from stats, merging records, or inventing rates. It yields visible career history before requiring a full examination simulator, new tournament health model, or second career mode.

## Explicit non-decisions

* No typical starting age, amateur record, transition age, conversion rate, or time-to-competence was established.
* No single discipline was declared childhood-entry or adult-entry as a population law; only sourced competition/access bands are recorded.
* No crossover was treated as equivalent to turning professional.
* No wrestling, BJJ, judo, karate, taekwondo, Muaythai, kickboxing, sanda, or sambo record was merged into an MMA record.
* No universal federation ban, suspension, grade stripping, or automatic grade conversion was invented.
* No purse, stipend, grant, prize, travel cost, club salary, or funding rate was generalized from one event or athlete.
* No grade was derived from the seven stats; no sourced grade rule was re-priced.
* Q12, Q18, and Q20 recommendations are authored game design, not findings.
* No code, JSON, test, UI, C52/J2/U4 deliverable, or `HANDOFF.md` change is proposed by this research record.


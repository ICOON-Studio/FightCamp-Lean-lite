# C52 DIGEST — The Tournament and the Grade

**Status:** research complete; two markdown files only.  
**Separation rule:** a **standing championship belt** is a carried-and-defended title object; a **practitioner grade belt** is an awarded rank and is never won from an opponent. A tournament medal is neither.

## Operator decisions

1. The six R70 `event` disciplines do not regain a standing championship
   object. Their durable record is a dated `event_result`: edition, organizer,
   date/week, discipline, age/weight/sex/grade division, athlete, placing,
   medal, contest count, ranking points and selection effect. See [R70](R70_DIGEST.md), [championship rules](../assets/data/championship_rules.json).
2. A tournament is one game event with an internal ladder resolved as a unit.
   The current one-bout-per-card and week medical clock cannot honestly model
   five to seven same-day contests as ordinary bouts. Exact contest-by-contest
   health needs a later body/card redesign ([UWW format](https://cdn.uww.org/2022-08/rules_v2207_0.pdf)).
3. Federation world events use national selection; IBJJF is open athlete entry;
   promotion signing remains separate. Fees are event-specific; only cited
   fees are numbers ([EntityPathway](../scripts/EntityPathway.gd), [IBJJF](https://ibjjf.com/events/sao-paulo-bjj-pro-ibjjf-championship-2026), [UWW](https://uww.org/sites/default/files/media/document/gen_reg_for_int_champs_compets_a.pdf)).
4. Boxing is the first tournament implementation: multi-day age/weight/sex
   elimination with amateur round rules, not a single normal bout ([World Boxing](https://worldboxing.org/wp-content/uploads/2024/11/World-Boxing-Competition-Rules-Nov-2024-Approved.pdf)).
5. Grade is an independent issuer-scoped label, awarded week, evidence and gate
   metadata. It is never derived from the seven stats. Sourced week gates are
   IBJJF adult blue 2 years, purple 1.5 years, brown 1 year, and IJF 1st dan
   age 15 plus one year brown / 2nd dan age 16 plus one year 1st dan ([IBJJF](https://ibjjf.com/news/ibjjf-minimum-graduation-period-update), [IJF](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2026/01/Rules_for_the_awarding_of_IJF_-1768917846.pdf)).

## Grade findings

* BJJ: adult and youth grade colours/stripes; grade is a division axis.
* Judo: kyu/dan; IJF validation and official-role gates.
* Karate: kyu/dan, issuer/style scoped; no universal WKF grade division.
* Taekwondo: geup/poom/dan; Kukkiwon certifies Poom/Dan and WT uses that
  credential for international competition ([Kukkiwon](https://www.kukkiwon.or.kr/eng/contents/view?contentsNo=83&menuLevel=2&menuNo=84)).
* Wrestling: no universal practitioner grade found in the reviewed UWW path.
* Boxing: no practitioner grade in reviewed World Boxing rules.
* MMA: IMMAF progression grades and minimums for official entry ([IMMAF](https://immaf.org/get-involved/participant-pathways/)).
* Kickboxing: WAKO grading exists but is optional for members ([WAKO](https://www.wako.sport/black-belt-directory)).
* Muaythai: IFMA’s 15-level Khan system and minimum competition level ([IFMA](https://muaythai.sport/ifma-launches-international-standard-for-muaythai-grading-system/)).
* Sanda: no universal practitioner grade found in reviewed IWUF material.
* Sambo: FIAS launched a 2026 ten-level practitioner qualification system;
  that does not create a standing championship belt ([FIAS](https://sambo.sport/en/news/fias-zapustila-ofitsialnyy-sayt-poyasnoy-sistemy/)).

## Build order

1. Add event/result abstraction only.
2. Add deterministic one-event tournament resolution and event-level medical
   outcome.
3. Reuse `EntityPathway` for entry/payment.
4. Implement amateur boxing tournament first.
5. Add independent issuer-scoped grade records and sourced time minima.
6. Defer exact internal contest health until the body/card clock is redesigned.

## Explicit non-decisions

No federation substitute belt, no “defending champion” default, no invented
grade, no guessed fee/cost/purse/funding number, no grade derived from stats, no
automatic amateur-to-professional conversion (J2 D5), no WBA/WBC/IBF/WBO
catalogue expansion, and no belt or brand artwork.

See [C52_THE_TOURNAMENT_AND_THE_GRADE.md](C52_THE_TOURNAMENT_AND_THE_GRADE.md) for the full 21-question evidence record, migration costs and inline source links.


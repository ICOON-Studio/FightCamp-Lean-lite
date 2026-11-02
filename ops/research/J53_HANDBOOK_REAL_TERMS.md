# J53: Gym Handbook real-world terms, checked against the rulebooks

Task J53 for FightCamp. Owner: John (research desk). Research only; no game code touched. Read date for every source: 2026-09-25. Glossary input: `/workspace/j53/Glossary.gd` (46 entries, lines 20–203). Context: `/workspace/j52/J52_TOOLTIPS_AND_TUTORIAL.md` §6b rule 6 and §6d.

**Tags.** SOURCED means a primary or named page says it; the source ID is given. PROXY means the source is close but not the exact body or level. JUDGEMENT is my recommendation. NOT FOUND means I looked and found no source. Word limits: rulebook quotes ≤15 words, plain definitions ≤15, "why" lines ≤12. Words are counted by splitting on spaces; a script checked every limited field (see §7).

**How to read the fields.** "Rule" is the rulebook wording, quoted, with source ID and section. "Plain" is the head-coach sentence for the Handbook `short`. "Why" is the gym-owner line for the Handbook `why`.

---

## 0. Headline answer

1. **`sanctioning` is WRONG (Glossary lines 140–143).** It fuses two different real bodies. A *commission* (or a governing body such as England Boxing or the BBBofC) licenses fighters and approves bouts. A *sanctioning body* (WBC, IBF, WBA) ranks fighters and sanctions title bouts; it licenses nobody. US federal law defines them separately (R12 §6301(2) and (14)). The alias COMMISSION maps the wrong word. Split it into two entries (§2 flag F1). SOURCED.
2. **`purse` is MISLEADING (lines 96–99).** The aliases SHOW MONEY and TOTAL PACKAGE treat part of the pay as the whole. Show money is the part paid for fighting; win money is extra and paid only on a win (R17). Purses are a pro-boxing and MMA thing. An amateur club bout pays no purse, and the tutorial books an amateur bout. SOURCED.
3. **`suspension` is MISLEADING (lines 136–139).** Real suspensions are set by the ringside doctor, mostly after a KO or a stoppage for head blows (R1 4.1.1–4.1.2; R2 5.4). They also ban sparring and training (R1 4.1.6; R2 5.4(4)(f)), and a doctor must clear the boxer to return (R2 5.4(7); R8 5.8). Real day counts: England Boxing 30 days, then 30 after a second in 3 months, then 1 year; USA Boxing 30 / 90 / 180 / 1 year / 540 days; ABC pro guideline KO 60 days, TKO 30; BBBofC 28 or 45 clear days. SOURCED.
4. **`weigh_in` is MISLEADING for the tutorial (lines 108–111).** "A fine or the bout is off" is the pro picture. In amateur boxing, failing the weigh-in means the opponent wins by walkover (R1 10.7.2), or you are disqualified (R2 11.1). There is no fine. SOURCED.
5. **J52 carries two real-term errors that the Handbook would repeat.** (a) The "≤2 kg gap" (J52 step 9) is England Boxing's rule only for Minors and Schools (R1 2.3.4, 2.4.4). Juniors, Youth and Seniors may be matched up to "the smaller weight category" apart (R1 2.5.5, 2.6.6, 2.7.8). (b) "OIC" (J52 §6b rule 6) is a USA Boxing title. England Boxing calls that official the **Supervisor** (R1 6.6.1). SOURCED.
6. **Counts over 46 entries: 1 WRONG, 9 MISLEADING, 7 OK, 29 GAME-ONLY.** The MISLEADING ones are record, starting cash, offer, purse, weigh-in, weight cut, medical suspension, ranking and corner. Corrected lines within the word limits are in §2.2. SOURCED/JUDGEMENT.
7. **18 real terms a first-month player meets are missing** (§3). The most important are bout, show, walkover, pre-bout medical, record book (BCR1), headguard, seconds, judges, decision, RSC, standing count, retirement (towel), experience level and Supervisor/OIC. SOURCED.
8. **The game must pick a rulebook per career stage.** The tutorial is an England Boxing club bout, so use England Boxing words for it. Label pro and MMA words as such (§4). JUDGEMENT.

---

## 1. Term table (23 required terms)

Each term has four fields plus how amateur boxing, pro boxing and MMA differ. All rows are SOURCED unless a tag says otherwise.

### 1.1 Weigh-in
- **Rule:** "For domestic boxing, the weigh in should be completed 1 hour prior to boxing commencing." (R1 7.1.3). SOURCED.
- **Plain:** The official scale check that proves your fighter is inside the agreed weight.
- **Why:** Miss it: amateurs lose the bout; pros can forfeit purse.
- **Differences.**
  - *Amateur:* same day.
    - England Boxing: about 1 hour before boxing (R1 7.1.3). Fail and the opponent wins by walkover (R1 10.7.2). Under-18s may only gain or lose small set amounts, 300–700 g (R1 7.1.14). At championships the maximum permissible loss is 1 kg (R1 Annex D).
    - USA Boxing: "All boxers must weigh in on the day they box". There is "zero tolerance for any overweight", one appearance on the scale, and at least 3 h to the first bout (R2 11.1).
  - *Pro:*
    - BBBofC: 24–36 hours before (R8 3.2.2), with 1 hour to make weight (R8 3.2.4) and a medical at the weigh-in (R8 3.9).
    - California: within 30 hours (R24 §297).
    - IBF: 20–30 hours before, plus a fight-day re-weigh with a regain cap (R10 1.A–1.B; R11).
    - WBC: 2–30 hours before, plus 30/14/7-day checks at 10%/5%/3% over the limit (R9 4.14).
    - Nevada: missing the agreed weight forfeits 25% of the purse to the opponent unless the miss is 1 lb or less (R5 NAC 467.522).
  - *MMA:* the ABC Unified Rules set no weigh-in time (R3; NOT FOUND there). The weigh-in is usually the day before, leaving 24–36 h (R15 §5.4, ACADEMIC).

### 1.2 Weight class
- **Rule:** "Boxers must be matched at no greater weight difference than the smaller weight category" (R1 2.5.5, England Boxing juniors; the same wording is in 2.6.6 and 2.7.8). SOURCED.
- **Plain:** A named band of body weight; fighters box others in or near their band.
- **Why:** Sets who he can fight and how much weight he must hold.
- **Differences.**
  - *Amateur:* categories are in kilograms and change by age group. For example, senior men run 47–50, <52.5 … <90, >90 kg (R1 §2.7). Minors and Schools may not be matched more than 2 kg apart (R1 2.3.4, 2.4.4).
  - *Pro boxing:*
    - Divisions are in pounds.
    - BBBofC opponents "must be engaged at the same weight" (R8 3.1).
    - Nevada and the ABC allow a small spread when fighters are in different classes, e.g. 3 lb up to 118 lb (R5 NAC 467.476; R4).
  - *MMA:* ABC classes run from atomweight ≤105 lb to super heavyweight >265 lb (R3).

### 1.3 Agreed weight / catch weight
- **Rule:** "there is no weight spread allowance between contracted catch weight fighters" (R3, Weight Classes c). SOURCED.
- **Plain:** A weight limit both camps agree for this bout, instead of a standard class limit.
- **Why:** Agreeing the wrong number can force a dangerous cut.
- **Differences.**
  - *Amateur:* no catch weights. Bouts are matched by category, or by a small gap agreed between coaches (R1 §2; R2 9.1(6)).
  - *Pro:* the weight is written in the bout agreement. Nevada fines a miss (R5 NAC 467.522: "fails to make the weight agreed upon in his or her bout agreement").
  - *MMA:*
    - A "Weight Miss Catch Weight" is allowed only if the heavier fighter is within 5 lb of the lighter (R3).
    - Commissions may refuse contracted catch weights (R3).
    - The word "catch weight" is mainly used in pro boxing and MMA. PROXY (R3 usage).

### 1.4 Walk-around weight
- **Rule:** no rulebook defines it (NOT FOUND in R1–R11). The nearest is academic: "Walk-around weight is generally defined as the athlete's weight outside of the fight camp" (R15 §5, ACADEMIC). PROXY.
- **Plain:** What the fighter weighs in normal life, between camps.
- **Why:** A big gap to the limit means a long, risky cut.
- **Differences:** the term is the same everywhere. R15 suggests about 12–15% above the class as an upper limit for a safe weight descent (R15 §5, ACADEMIC). Amateurs with same-day weigh-ins have little time to regain weight, so the gap should be smaller. JUDGEMENT, based on R1 7.1.3 and R15 §5.4.7.

### 1.5 Weight cut (and rehydration clauses)
- **Rule:** no rulebook defines it (NOT FOUND). Academic: "Weight cutting is a process that includes weight loss (RWL) to qualify" (R15 §5.4, ACADEMIC). R15 continues: "followed by rapid weight gain (RWG)". PROXY.
- **Plain:** Losing weight fast before the weigh-in, then eating and drinking it back before the bout.
- **Why:** Big cuts sap strength and health; some rules cap the regain.
- **Rehydration clauses (rules that limit regain after the weigh-in).**
  - WBC checks weight 30, 14 and 7 days out "due to the possible adverse results of dehydration and subsequent rehydration of boxers" (R9 4.14). SOURCED.
  - IBF second-day weigh-in: fight-day morning, 8–10 a.m. Caps include 147→158 lb and 160→172 lb, about 10 lb over the limit up to 140 lb (R10 1.B; R11). SOURCED.
  - ABC guideline: if the weigh-in is 12–24 h before, the boxer re-weighs 2 h before the bout and may not be more than 10 lb over the contract weight (R4). SOURCED.
  - California's 2017 plan used a fight-day check with no more than 10% regain (R18, PRESS). SOURCED.
  - Nevada: no more than 2 lb may be lost after the official weigh-in, within 1 hour (R5 NAC 467.476). SOURCED.
- **Differences:** amateur same-day weigh-ins leave little time to rehydrate (R1 7.1.3; R2 11.1). England Boxing limits under-18 change at the weigh-in (R1 7.1.14). Pro boxing and MMA mostly weigh in the day before, so bigger cuts happen there (R15). SOURCED.

### 1.6 Medical suspension
- **Rule:** "all periods of suspension are determined by the Ringside Doctor and are not negotiable." (R1 4.1.1). SOURCED.
- **Plain:** Days a doctor bans a fighter from boxing and sparring, usually after head blows.
- **Why:** No bouts or sparring until it ends and a doctor clears him.
- **Real day counts (all SOURCED).**

| Body | After KO / stoppage for head blows | Repeats | Other |
|---|---|---|---|
| England Boxing (R1 4.1.2, 4.1.6, Annex B3/B4) | KO(H), or RSC(H) with concussion: **30 days**, then graded return; RSC(H) with no concussion: no mandatory suspension (the doctor may still set one) | 2 in 3 months: ≥30 days after the second. 3 in 12 months with concussion: **1 year** | No training or sparring while restricted. Return to competition not before day 35 (19 and over) or day 39 (18 and under). Recorded in the Digital BCR1 |
| USA Boxing (R2 5.4; R22 §7) | KO or referee stop for hard head blows: **≥30 days**. By loss of consciousness (LOC): none 30, under 1 min **90**, over 1 min **180** | 2 in 90 days: ≥90 days. 3 in 12 months: **1 year**. 3 LOCs in 365 days: **540 days**. The Medical Handbook says 18 months for a third KO in 365 days | Written clearance to return (5.4(7)); no training or sparring |
| ABC pro guideline (R4) | KO **≥60 days**; TKO from head blows **≥30 days** | Doctor may extend | Mandatory **7-day** rest after every event |
| California pro (R7 §352) | KO or TKO: **≥30 days** on the unavailable list | — | — |
| Nevada (R5 NAC 467.562, 467.472) | Suspended until shown fit; the doctor sets the length | — | Minimum rest days between bouts: 4 days (≤4 rounds) up to 30 days (11–12 rounds) |
| BBBofC pro (R8 5.8, 5.4(a)) | Any referee stop, retirement or count-out: licence **automatically suspended for 28 or 45 clear days** or more | — | Fitness certificate before return; at least 6 clear days between contests |
| MMA, ABC Unified Rules (R3) | No day counts (NOT FOUND in R3) | — | Set by each commission. Kentucky: KO ≥60 days, TKO up to 30 (R13 §20) |

- **Differences:** amateur suspensions are triggered by the medical diagnosis and cover training too. Pro suspensions attach to the licence and are set per commission. MMA has no unified number. SOURCED.

### 1.7 RSC (Referee Stops Contest)
- **Rule:** "If a Boxer in the Referee's opinion, is being outclassed or is receiving excessive punishment" (R1 10.3.2). SOURCED.
- **Plain:** The referee ends the bout early because one boxer is outclassed or can't continue.
- **Why:** A head-blow stoppage can start a medical suspension.
- **Differences:** RSC is amateur wording. It covers RSC(H) (head), RSC(B) (body), failing to come out after the rest, and a stop on the doctor's advice (R1 10.3; R2 15.3). RSC-I is for injury (R1 10.4; R2 15.4). Pro boxing and MMA record the same outcome as **TKO** (R4; R3 decisions list; R5 NAC 467.748). SOURCED.

### 1.8 OIC (Official in Charge)
- **Rule:** "The Official in Charge will be responsible for all decisions in the FOP." (R2 Rule 31; FOP = field of play). SOURCED.
- **Plain:** The senior official who runs the whole show and has the final say.
- **Why:** He approves matches and settles disputes on the night.
- **Differences.**
  - *USA Boxing:* the OIC also gives final match approval (R2 9.1(6)).
  - *England Boxing:* has **no OIC**. The same job is the **Supervisor**: "The Supervisor shall have complete charge of the club tournament, and their decision is final" (R1 6.6.1).
  - *Pro and MMA:* the commission's inspectors or representative hold this role (R5 NAC 467). There is no single OIC title. PROXY.

### 1.9 Referee
- **Rule:** "the appointed Official responsible for ensuring all Rules are followed by the Boxers" (R1 6.4.3). SOURCED.
- **Plain:** The official in the ring who enforces the rules and can stop the bout.
- **Why:** He decides counts, warnings and stoppages that end fights.
- **Differences.**
  - *Amateur:* the referee does not score (R2 20.1), except in England Boxing referee-only bouts (R1 9.1.1).
  - *ABC pro:* the referee is "the sole arbiter of a bout" and the only person who may stop it (R21 rule 2).
  - *BBBofC:* the referee **scores** ordinary pro contests alone. Three judges score only British and Commonwealth title fights (R8 3.5.1).
  - *MMA:* same role, with ground-fighting rules (R3).

### 1.10 Judges
- **Rule:** "the appointed Official responsible for allocating points during a bout" (R1 6.4.4). SOURCED.
- **Plain:** Officials at ringside who score each round to decide the winner.
- **Why:** If nobody is stopped, their cards decide the result.
- **Differences:**
  - *England Boxing:* 5 or 3 judges, or the referee alone (R1 9.1.1).
  - *USA Boxing:* 5 judges at nationals, otherwise 3 or 5 (R2 14.1).
  - *ABC pro:* 3 judges (R21 rule 3). *BBBofC:* the referee alone, except British and Commonwealth titles (R8 3.5.1).
  - *MMA:* at least 3 judges (R3).

### 1.11 10-point must system
- **Rule:** "For all contests, the '10 point must' scoring system is to be employed." (R1 9.1.4). SOURCED.
- **Plain:** Each judge gives the round winner 10 points and the loser 9 or fewer.
- **Why:** Knockdowns and clear rounds widen the gap on the cards.
- **Differences:**
  - *Amateur:* no even rounds. "Every round must have a declared winner" (R1 9.1.5). The loser gets 9 down to 7 (R1 9.1.5).
  - *Pro boxing:* even rounds are allowed, and each boxer then gets 10 (R8 3.29; R5 NAC 467.612).
  - *MMA:* allows a "rare even round" scored 10-10 (R3).

### 1.12 Sanctioning body vs commission
- **Rule:** a commission is an "entity authorized under State law to regulate professional boxing matches" (R12 §6301(2)). A sanctioning organization "sanctions professional boxing matches" (R12 §6301(14)). SOURCED.
- **Plain:** The commission licenses and polices fights; a sanctioning body ranks fighters and awards titles.
- **Why:** You need the commission to fight and the body for titles.
- **Differences.**
  - *Amateur:* the national federation does both jobs. USA Boxing issues a "Sanction", which is "A certificate of approval issued by USA Boxing for events" (R2 definitions). England Boxing requires every event to be licensed (R1 1.6.6).
  - *UK pro:* the BBBofC licenses boxers and also runs British titles (R8).
  - *US pro and MMA:* the state commission licenses (R6 NRS 467). The WBC, IBF and WBA sanction title bouts (R9, R10).

### 1.13 Matchmaker
- **Rule:** "a person that proposes, selects, and arranges the boxers" (R12 §6301(6)). SOURCED.
- **Plain:** The person who picks and pairs fighters for a show.
- **Why:** Good relations with matchmakers get your fighters fair bouts.
- **Differences.**
  - *Pro:* the matchmaker works under the promoter's authority (R8 19.4). In Nevada the commission reviews each match on records and experience (R5 NAC 467.182).
  - *Amateur:* coaches match bouts, with final approval by the OIC or Supervisor (R2 9.1(6); R1 6.6.1). Clubs list carded boxers for matching (R19, COMMUNITY).

### 1.14 Promoter
- **Rule:** "the person primarily responsible for organizing, promoting, and producing" (R12 §6301(9)). SOURCED.
- **Plain:** The business that stages the show, pays the purses and sells tickets.
- **Why:** Promoters make pro offers; a good relationship means more bouts.
- **Differences:** a promoter must be licensed in pro boxing and MMA (R6 NRS 467.0104; R8). Amateur shows are run by clubs or federations under a licence or permit (R1 1.6.2, 1.6.6). Club shows "may also provide a fund-raising opportunity for the club" (R1 1.6.2). SOURCED.

### 1.15 Purse vs show money vs win bonus
- **Rule:** a purse is "the financial guarantee or any other remuneration for which contestants are participating" (R6 NRS 467.0105). SOURCED.
- **Plain:** Purse is total fight pay; show money is guaranteed; the win bonus needs a win.
- **Why:** Manager and trainer cuts come out of the fighter's purse.
- **Differences.**
  - *Pro and MMA:* one fighter was paid "$66,000 to show and $66,000 to win"; the win bonus is paid only on an official win (R17).
  - *Cuts:* a BBBofC trainer may take up to 10% of a gross purse of £10k or less (R8 16.3), and the standard manager contract takes 25% (R8).
  - *Amateur:* club bouts pay no purse. PROXY: R1 has no purse rules; World Boxing allows prize money only at some elite competitions (R23 1.13.1).

### 1.16 Carded / registered boxer
- **Rule:** "The BCR1 card acts as both a record of competition" (R14), and it also stores the medical details (R14). SOURCED.
- **Plain:** A boxer registered with the federation, medically passed and holding a record book.
- **Why:** Only carded boxers can be matched and box on shows.
- **Differences.**
  - *England Boxing:* registration on The Locker, then the Digital BCR1 with an initial and an annual medical (R1 2.2.1, 3.2.1). From 1 June 2026, 30 days of sparring are also required before a first bout (R1 5.7.1(f)).
  - *Usage of "carded":* it is club slang. R19 says "These boxers are referenced as 'carded'" (COMMUNITY, PROXY).
  - *USA Boxing:* a passbook (R2 8.3).
  - *Pro:* a licence from the commission or BBBofC (R6; R8).

### 1.17 Record (W-L-D, NC)
- **Rule:** "Tie-Breaker – Tied bouts are not permitted." (R2 15.1(5), amateur). MMA "No Contest": a bout stopped early by accidental injury before enough time for a decision (R3 e.i). SOURCED.
- **Plain:** His bouts won, lost and drawn, written W-L-D; no contests are listed separately.
- **Why:** Matchmakers and coaches pair fighters by experience and results.
- **Differences.**
  - *Amateur:* no draws (R1 9.1.5; R2 15.1(5)). Results are written as WP, RSC, KO, ABD, DQ or WO (R1 §10).
  - *Pro boxing:* draws exist. A stop after an accidental foul before 4 rounds is a "NO DECISION" (R21 12.B.1).
  - *MMA:* draws and no contests (R3).
  - *Official record keepers:* the ABC names BoxRec for boxing and mmareg.com for MMA (R4 page).

### 1.18 Corner (seconds, cutman, one-minute rest)
- **Rule:** "Each Boxer is permitted up to 3 seconds in his/her corner." (R1 5.6.1). SOURCED.
- **Plain:** The coach and helpers who look after the fighter between rounds.
- **Why:** Their one-minute advice and cut care can turn a bout.
- **Differences.**
  - *Rest:* 1 minute everywhere (R1 2.7.7; R2 24.1; R3; R8 3.7).
  - *Number of seconds:*
    - England Boxing: 3, with one inside the ring (R1 5.6.1).
    - USA Boxing: count NOT FOUND in R2 26.
    - World Boxing: up to 3 (R23 3.1.2).
    - ABC pro: 3, or 4 for titles (R4).
    - Nevada: 3, or 4 for a main event or title (R5 NAC 467.635).
    - BBBofC: 4, one inside the ring (R8 3.11).
  - *Cutman:*
    - Nevada boxing: only the cutman is inside the ropes during the rest. MMA: one second plus the cutman inside the cage (R5 NAC 467.635).
    - ABC MMA: only an approved cutman or licensed cornerman may apply substances (R3).
    - England Boxing: only water in the corner, and cuts are treated only by accredited people (R1 Annex C1 2.4–2.4.1).
  - *Retiring the boxer:*
    - Amateur: the coach throws the towel (R1 10.2.1).
    - BBBofC: the manager or chief second retires the boxer, never during a round (R8 3.43).

### 1.19 Fight camp
- **Rule:** no rulebook term (NOT FOUND in R1–R11). Academic: "Fight camp refers to the formalized training period leading up to a pre-determined fight date" (R15 §5.2). PROXY.
- **Plain:** The weeks of focused training aimed at one fight date.
- **Why:** A good camp peaks him on the right night.
- **Differences:** R15 gives a typical length of 8–10 weeks, mostly for pro boxing and MMA. Amateur boxers compete more often, and matching happens weeks before the show (R19, COMMUNITY). The shorter amateur build-up is JUDGEMENT.

### 1.20 Fight week
- **Rule:** no rulebook term (NOT FOUND). Academic usage: R15 §5.4 is titled "Fight week/rapid weight-loss strategies" (ACADEMIC). PROXY.
- **Plain:** The last days before the bout: lighter training, final weight, then the weigh-in.
- **Why:** Hard work now costs freshness on the night.
- **Differences:** pro events add media and a weigh-in the day before (R8 3.2.2; R10 1.A). Amateur weigh-ins are on show day (R1 7.1.3; R2 11.1). SOURCED.

### 1.21 Ranking
- **Rule:** "Ratings are and may be largely subjective." (R9 6.4(b)); the WBC rates 40 boxers per division (R9 6.4(d)). SOURCED.
- **Plain:** A sanctioning body's ordered list of the best fighters in each division.
- **Why:** Higher rank brings bigger offers and a path to title shots.
- **Differences.**
  - *Pro:* each body keeps its own list. The WBC updates it monthly (R9 6.3), and the IBF uses monthly ratings (R10 9.A).
  - *Amateur:* World Boxing has points-based world rankings for elite boxers (R23 1.10). Club boxers are matched by experience, not ranked (R1 2.7.8).
  - *MMA:* NOT FOUND as a rulebook item. Rankings are set by promotions (not checked).

### 1.22 Title eliminator
- **Rule:** the IBF notifies "the two highest ranked available contenders ranked #10 or above" to meet in a twelve-round elimination bout (R10 9.A). SOURCED.
- **Plain:** A bout between top contenders whose winner earns the next title shot.
- **Why:** Winning one is the usual route to a title fight.
- **Differences:** the IBF's eliminator is for the #1 or #2 position (R10 9.A). The WBC calls it a "final elimination" (R9 3.9). There is no amateur equivalent; amateurs box tournaments. SOURCED/JUDGEMENT.

### 1.23 Mandatory challenger
- **Rule:** "Only the winner of a final elimination bout shall become a mandatory challenger" (R9 3.9). SOURCED.
- **Plain:** The contender a champion is ordered to fight next, or lose the belt.
- **Why:** Only this status guarantees a title shot, not ranking alone.
- **Differences.**
  - *WBC:* the top-rated boxer "is never, solely by virtue of such position, the official mandatory challenger" (R9 3.7). A champion must make at least one mandatory defence a year (R9 3.5).
  - *IBF:* first mandatory defence within 9 months (R10 5.A).
  - *Amateur and MMA:* no such term found. NOT FOUND.

---

## 2. Glossary.gd audit

### 2.1 Verdict for every entry (46)

Verdicts: OK means consistent with real usage. WRONG means the rules contradict it. MISLEADING means partly true but it would teach a false idea. GAME-ONLY means not a real-world fight term, so no rule check is needed. Notes on some GAME-ONLY entries are JUDGEMENT.

| # | Entry id | Lines | Verdict | Note |
|---|---|---|---|---|
| 1 | `proficiency` | 20–23 | **GAME-ONLY** | Game stat. |
| 2 | `condition` | 24–27 | **GAME-ONLY** | Equipment wear. Same word as the `conditioning` area label; consider renaming (JUDGEMENT). |
| 3 | `conditioning` | 28–31 | **OK** | Real training word; the plain line fits (JUDGEMENT). |
| 4 | `fatigue` | 32–35 | **GAME-ONLY** | General word, used as a game stat. |
| 5 | `morale` | 36–39 | **GAME-ONLY** | Game stat. |
| 6 | `loyalty` | 40–43 | **GAME-ONLY** | Game stat. |
| 7 | `record` | 44–47 | **MISLEADING** | Amateur bouts cannot be drawn; no contests are missing (F6). |
| 8 | `roster` | 48–51 | **GAME-ONLY** | Game list. |
| 9 | `starting_cash` | 52–55 | **MISLEADING** | 'Until purses arrive' does not fit an amateur club (F10, minor). |
| 10 | `cash` | 56–59 | **GAME-ONLY** | Game money. |
| 11 | `upkeep` | 60–63 | **GAME-ONLY** | Game money. |
| 12 | `floor_space` | 64–67 | **GAME-ONLY** | Game grid. |
| 13 | `repair_cost` | 68–71 | **GAME-ONLY** | Game money. |
| 14 | `tier` | 72–75 | **GAME-ONLY** | Game progression. |
| 15 | `market` | 76–79 | **GAME-ONLY** | Game setting. |
| 16 | `city` | 80–83 | **GAME-ONLY** | Game setting. |
| 17 | `gym_heat` | 84–87 | **GAME-ONLY** | Game rivalry stat. |
| 18 | `hype` | 88–91 | **GAME-ONLY** | 'Raises purses' is pro-only (note in §2.2). |
| 19 | `offer` | 92–95 | **MISLEADING** | Amateur bouts are matched by coaches, not offered by promoters (F5). |
| 20 | `purse` | 96–99 | **MISLEADING** | Show money is only part of a purse; there is no amateur purse; the cuts go to the manager and trainer (F2). |
| 21 | `pay_vs_market` | 100–103 | **GAME-ONLY** | Game comparison. |
| 22 | `weight_class` | 104–107 | **OK** | Consistent with R1 §2, R3 and R8 3.1. |
| 23 | `weigh_in` | 108–111 | **MISLEADING** | Amateur failure means a walkover or DQ, not a fine (F4). |
| 24 | `walk_weight` | 112–115 | **OK** | Matches the academic usage (R15). |
| 25 | `weight_cut` | 116–119 | **MISLEADING** | Leaves out rehydration; the why line uses 'condition', which is the equipment term (F9). |
| 26 | `fight_week` | 120–123 | **OK** | Matches R15 §5.4 usage. For amateurs there is no media and the weigh-in is on the day (§1.20). |
| 27 | `fight_camp` | 124–127 | **OK** | Matches R15 §5.2. |
| 28 | `readiness` | 128–131 | **GAME-ONLY** | Game stat. |
| 29 | `injury` | 132–135 | **OK** | General term; consistent. |
| 30 | `suspension` | 136–139 | **MISLEADING** | Set by the doctor, not after every bout; also bans sparring; needs clearance (F3). |
| 31 | `sanctioning` | 140–143 | **WRONG** | Merges commission and sanctioning body; the alias COMMISSION is wrong (F1). |
| 32 | `ruleset` | 144–147 | **OK** | Real usage; amateur vs pro boxing are also different rulesets (§4). |
| 33 | `discipline` | 148–151 | **GAME-ONLY** | Training category. |
| 34 | `technique` | 152–155 | **GAME-ONLY** | Game move list. |
| 35 | `training_plan` | 156–159 | **GAME-ONLY** | Game system. |
| 36 | `fight_iq` | 160–163 | **GAME-ONLY** | Game stat. |
| 37 | `potential` | 164–167 | **GAME-ONLY** | Game stat. |
| 38 | `age` | 168–171 | **GAME-ONLY** | Game stat. Optional: amateur age categories limit matching (§2.2 note). |
| 39 | `ranking` | 172–175 | **MISLEADING** | Each body has its own list; rank alone gives no title shot (F7). |
| 40 | `corner` | 176–179 | **MISLEADING** | The corner is the seconds and their care, not only instructions (F8). |
| 41 | `scouting` | 180–183 | **GAME-ONLY** | Real word, game system; no rule to check. |
| 42 | `staff` | 184–187 | **GAME-ONLY** | Game system. |
| 43 | `wage` | 188–191 | **GAME-ONLY** | Fighters are paid per bout, not wages (note in §2.2). |
| 44 | `goodwill` | 192–195 | **GAME-ONLY** | Game stat. |
| 45 | `must_answer` | 196–199 | **GAME-ONLY** | UI. |
| 46 | `continue` | 200–203 | **GAME-ONLY** | UI. |

**Totals:** WRONG 1, MISLEADING 9, OK 7, GAME-ONLY 29 (46 entries).

### 2.2 Detailed flags with proposed replacement lines

Every proposed `short` is ≤15 words and every `why` is ≤12 (script-checked). Ranked by impact.

**F1. `sanctioning` (lines 140–143): WRONG.**
- Glossary line 141: `"short": "The body that licenses fighters and approves bouts in a market."`. Line 143 aliases include `"COMMISSION"`.
- **What the rules say:** the commission is the licensing regulator; a sanctioning organization sanctions matches (R12 §6301(2), (14); R6 NRS 467). WBC and IBF rules deal with ratings and title bouts, not licences (R9, R10). In amateur boxing the federation licenses events (R1 1.6.6), and USA Boxing calls its event approval a "Sanction" (R2).
- **Fix: split into two entries.**
  - `commission`: name "Commission". Short: The official regulator that licenses fighters and officials and approves each bout. Why: No licence or approval, no fight; breaking rules brings fines or bans. Aliases: COMMISSION, LICENCE, LICENSED.
  - `sanctioning`: name "Sanctioning body". Short: A title organisation, like the WBC or IBF, that ranks fighters and approves title bouts. Why: Its rankings and rules decide who gets title fights. Aliases: SANCTIONED, SANCTIONING, SANCTIONING BODY.
  - If the game keeps one "market body" entry for amateurs, call it "Federation" (England Boxing, USA Boxing). JUDGEMENT.

**F2. `purse` (lines 96–99): MISLEADING.**
- Line 97: `"short": "What the fighter is paid for the bout; the gym takes its cut."`. Line 98: `"why": "The gym's main income."`. Line 99 aliases: `"TOTAL PACKAGE", "SHOW MONEY"`.
- **What the rules say:**
  - Purse is the guarantee or other pay for the contest (R6 NRS 467.0105).
  - Show money is only the part paid for fighting; the win bonus is separate and conditional (R17).
  - Cuts go to the manager and trainer under contract (R8 16.3).
  - Amateur club shows are fundraisers, not paid bouts (R1 1.6.2). PROXY.
- **Fix.** Short: A pro fighter's pay for one bout, set in his contract. Why: Manager and trainer take agreed cuts; club amateur bouts pay no purse. Remove SHOW MONEY and TOTAL PACKAGE from the aliases. If the UI shows them, add `show_money`: The part of the purse paid just for turning up and fighting. Why: Win money on top is paid only if he wins.

**F3. `suspension` (lines 136–139): MISLEADING.**
- Line 137: `"short": "Days a fighter may not compete after a bout or knockout."`. Line 138: `"why": "He cannot be booked until it ends."`.
- **What the rules say:**
  - The ringside doctor sets it, mostly after KO or RSC for head blows (R1 4.1.1–4.1.2; R2 5.4).
  - It also bans training and sparring (R1 4.1.6; R2 5.4(4)(f)).
  - A doctor must clear the boxer to return (R2 5.4(7); R8 5.8).
  - It is not applied after every bout. In England Boxing, an RSC(H) without concussion needs none (R1 4.1.2). The ABC pro 7-day rest and the BBBofC 6-day gap are rest rules, not suspensions (R4; R8 5.4(a)).
- **Fix.** Short: Doctor-set days a fighter may not box or spar, usually after head blows. Why: No bouts or sparring until it ends and a doctor clears him.

**F4. `weigh_in` (lines 108–111): MISLEADING (for the amateur tutorial).**
- Line 110: `"why": "Over the limit means a fine or the bout is off."`.
- **What the rules say:** amateur failure means a walkover loss or a DQ (R1 10.7.2; R2 11.1). Fines or purse forfeits are pro-only (R5 NAC 467.522).
- **Fix.** Short: The official scale check before a bout; amateurs weigh in on fight day. Why: Amateur over the limit loses by walkover; pros may forfeit purse.

**F5. `offer` (lines 92–95): MISLEADING.**
- Line 93: `"short": "A promoter's invitation to fight on a dated card."`.
- **What the rules say:** amateur bouts are matched between coaches and approved by the OIC or Supervisor (R2 9.1(6); R1 6.6.1). J52 step 7 books an amateur bout. Promoters make offers only in pro boxing (R12 §6301(9)).
- **Fix.** Short: A proposed bout on a dated show, from a promoter or another club. Why: Accept to book it; each offer expires on its date.

**F6. `record` (lines 44–47): MISLEADING.**
- Line 45: `"short": "Wins, losses and draws, written W-L-D."`. Line 46: `"why": "Promoters and matchmakers book on the record."`.
- **What the rules say:** amateur bouts cannot be drawn (R1 9.1.5; R2 15.1(5)). No contests are a real result in MMA and pro boxing (R3; R21). Amateur matching weighs bouts boxed and win rate, done by coaches (R2 9.1(5)–(6); R1 2.7.8).
- **Fix.** Short: Wins, losses and draws (W-L-D), plus no contests; amateur bouts never end drawn. Why: Coaches and matchmakers match on bouts boxed and results.

**F7. `ranking` (lines 172–175): MISLEADING.**
- Line 173: `"short": "Where the fighter stands in his division's table."`. Line 174: `"why": "Higher rank brings bigger offers and title shots."`.
- **What the rules say:** each sanctioning body keeps its own list, and ratings "may be largely subjective" (R9 6.4(b)). A high rank alone does not earn a title shot (R9 3.7). Title shots come via eliminators and mandatory status (R9 3.9; R10 9.A).
- **Fix.** Short: A sanctioning body's or federation's ordered list of fighters in a division. Why: Rank helps offers, but title shots need eliminators or mandatory status.

**F8. `corner` (lines 176–179): MISLEADING.**
- Line 177: `"short": "Your instructions to the fighter in the minute between rounds."`.
- **What the rules say:** the corner is the seconds themselves, up to 3 or 4 people (R1 5.6.1; R8 3.11; R5 NAC 467.635). They also treat cuts and can retire the boxer (R1 10.2.1; R8 3.43). The one-minute rest is SOURCED (R2 24.1).
- **Fix.** Short: The seconds beside your fighter, and their advice in each one-minute rest. Why: Good advice changes his plan; the corner can also retire him.

**F9. `weight_cut` (lines 116–119): MISLEADING.**
- Line 117: `"short": "Losing weight in the final days to make the limit."`. Line 118: `"why": "Big cuts drain condition before the fight."`.
- **What the rules say:** a cut includes regaining weight after the weigh-in (R15 §5.4). Several rules cap that regain (R9 4.14; R11; R4). "Condition" in this Glossary means equipment wear (line 25), so the why line points at the wrong term. JUDGEMENT.
- **Fix.** Short: Losing weight fast before the weigh-in, then rehydrating before the bout. Why: Big cuts sap strength and health, with little recovery time.

**F10. `starting_cash` (lines 52–55): MISLEADING (minor).**
- Line 54: `"why": "Upkeep and wages come out of it until purses arrive."`.
- **What the rules say:** an amateur club earns no purses (PROXY; see F2). Club shows raise funds (R1 1.6.2).
- **Fix.** Why: Upkeep and wages come out of it until income arrives.

**Notes on OK and GAME-ONLY entries (optional, JUDGEMENT).**
- `condition` (24) vs `conditioning` (28, area "Condition"): these three uses of one word will confuse players. Consider renaming equipment `condition` to "Wear" or "Kit condition".
- `age` (168): amateur age categories decide who may be matched (R1 §2; R1 2.7.4). An optional why: Shapes growth, recovery, career length and who amateurs may box.
- `wage` (188): fighters are paid per bout (purse, show and win money), not wages (R17). Keep the entry for staff. An optional short: What you pay a staff member each period.
- `hype` (88): "raises purses" is pro-only. That's fine if hype only applies to pro careers.

---

## 3. Missing first-month terms (J52 §6d steps 7–18)

Only terms the player actually meets in those steps are listed. The step number is given. Every row is SOURCED unless tagged.

### 3.1 Bout (step 7–9)
- **Rule:** "A boxing contest between two boxers taking place as part of a competition." (R2 definitions). SOURCED unless tagged.
- **Plain:** One fight between two boxers on a show.
- **Why:** Each bout adds to his record and experience.
- **Differences:** Nevada: "an individual contest or exhibition of unarmed combat" (R5 NAC 467.0018). Same meaning in pro and MMA.

### 3.2 Show / card (step 10)
- **Rule:** "Program of unarmed combat means a program of one or more contests or exhibitions." (R5 NAC 467.0029). SOURCED unless tagged.
- **Plain:** An event with several bouts on one night; the list of bouts is the card.
- **Why:** Your bout date and weigh-in follow the show's schedule.
- **Differences:** England Boxing club shows are local and can be fundraisers (R1 1.6.2), and every event must be licensed (R1 1.6.6). Pro shows are staged by a licensed promoter (R6; R8).

### 3.3 Experience level (novice / open; development / elite) (step 8)
- **Rule:** "Experience of boxers must be considered when making match bouts." (R2 9.1(5)). SOURCED unless tagged.
- **Plain:** How experienced a boxer is, counted in bouts; novices meet novices.
- **Why:** Fair matches keep new boxers safe and winning.
- **Differences:** England Boxing: senior Development vs Elite (R1 2.7.2–2.7.3); matching on experience and weight (R1 2.7.8). USA Boxing: Experienced/Open vs Inexperienced/Novice divisions (R2 Appendix K). Pro: the commission reviews records and experience (R5 NAC 467.182).

### 3.4 Carded / registered boxer (step 7)
- **Rule:** See §1.16: "The BCR1 card acts as both a record of competition" (R14). SOURCED unless tagged.
- **Plain:** A boxer registered with the federation, medically passed and holding a record book.
- **Why:** Only carded boxers can be matched and box on shows.
- **Differences:** As in §1.16. "Carded" is club usage (R19, COMMUNITY, PROXY).

### 3.5 Agreed weight (step 9)
- **Rule:** See §1.3: "fails to make the weight agreed upon in his or her bout agreement" (R5 NAC 467.522). SOURCED unless tagged.
- **Plain:** The weight limit both sides agree for this bout.
- **Why:** He must make it at the weigh-in or lose the bout.
- **Differences:** As in §1.3. Amateur gaps: ≤2 kg for Minors and Schools, otherwise up to one category (R1 2.3.4, 2.5.5).

### 3.6 Taper (step 12)
- **Rule:** NOT FOUND in any rulebook. The sport-science definition is a grok lead, unverified (Appendix A item 8). PROXY/JUDGEMENT. SOURCED unless tagged.
- **Plain:** Cutting training load in the final days so the fighter arrives fresh.
- **Why:** Too much work in fight week leaves him flat.
- **Differences:** Same idea in all three sports. No rule governs it. JUDGEMENT.

### 3.7 Walkover (WO) (step 14)
- **Rule:** "fails the Medical Examination or Daily Weigh-In, the opponent will win by WO." (R1 10.7.2). SOURCED unless tagged.
- **Plain:** A win without boxing, because the opponent missed weight, failed the medical or didn't appear.
- **Why:** Missing weight hands the other boxer the win.
- **Differences:** England Boxing: also after a one-minute no-show (R1 10.7.1). USA Boxing: an overweight boxer "is disqualified" (R2 11.1(4)), with a separate no-show rule (R2 15.8). Pro: a weight miss usually means a purse forfeit, not an automatic loss (R5 NAC 467.522).

### 3.8 Pre-bout medical (step 15)
- **Rule:** "Prior to a contest, a Boxer must receive a pre-bout medical" (R1 3.4.1). SOURCED unless tagged.
- **Plain:** A doctor's check on show day that the boxer is still fit to box.
- **Why:** Fail it and he cannot box that night.
- **Differences:** England Boxing: it checks for changes to "Fit to Box" status (R1 3.4.1), and failing it is a WO (R1 10.7.2). BBBofC: a medical at the weigh-in and after every contest (R8 3.9). Nevada: an exam at the weigh-in plus a questionnaire (R5 NAC 467.528).

### 3.9 Record book (BCR1) / passbook (step 15)
- **Rule:** "in the Digital BCR1 of the boxer receiving the suspension." (R1 4.1.2). SOURCED unless tagged.
- **Plain:** The boxer's official book of bouts, results, medicals and suspensions.
- **Why:** Officials check it before he is allowed to box.
- **Differences:** England Boxing: the Digital BCR1 (R1 2.2.1; R14). USA Boxing: the passbook must be handed in at events (R2 8.3). Pro: licence records; the ABC names BoxRec as the boxing record keeper (R4 page).

### 3.10 Headguard (step 15–16)
- **Rule:** "All male senior Boxers will box without head guards." (R1 8.3.1). SOURCED unless tagged.
- **Plain:** Padded head protection most amateurs must wear; senior men box without it.
- **Why:** The rule changes with the boxer's age and sex.
- **Differences:** USA Boxing: "Headgear must be worn at all LBC competitions" (R2 9.1(3)). World Boxing: elite women wear one and elite men must not (R23 13.3.2–13.3.3). Pro and MMA: none. The last point is JUDGEMENT; no rule text was checked for it.

### 3.11 Seconds / cutman (step 16)
- **Rule:** See §1.18: "Each Boxer is permitted up to 3 seconds in his/her corner." (R1 5.6.1). SOURCED unless tagged.
- **Plain:** Helpers allowed in the corner; the cutman treats cuts and swelling.
- **Why:** Too few or unaccredited helpers breaks the rules.
- **Differences:** As in §1.18.

### 3.12 Judges and 10-point must (step 17)
- **Rule:** See §1.10–1.11 (R1 6.4.4, 9.1.4). SOURCED unless tagged.
- **Plain:** Ringside officials score each round 10 to 9 or less.
- **Why:** Their cards decide any bout that goes the distance.
- **Differences:** As in §1.10–1.11.

### 3.13 Decision (points win: unanimous / split) (step 17)
- **Rule:** "Unanimous decision by points: all judges appoint the same winner" (R2 14.5(1)). SOURCED unless tagged.
- **Plain:** A points win from the judges' cards: unanimous if all agree, split if not.
- **Why:** A split decision means the bout was close.
- **Differences:** England Boxing: unanimous and split (R1 10.1). MMA adds majority and technical decisions and several kinds of draw (R3 f–g). The amateur result code is WP, win on points (R2 15.1).

### 3.14 RSC (step 17)
- **Rule:** See §1.7 (R1 10.3.2). SOURCED unless tagged.
- **Plain:** The referee ends the bout early because one boxer is outclassed or can't continue.
- **Why:** A head-blow stoppage can start a medical suspension.
- **Differences:** As in §1.7. Pro and MMA say TKO.

### 3.15 Knockdown and standing count (step 17)
- **Rule:** "is in a semi-conscious state and cannot, in the opinion of the Referee, continue" (R1 11.1.1). SOURCED unless tagged.
- **Plain:** When a boxer is down or dazed, the referee counts to eight before boxing resumes.
- **Why:** Too many counts in a bout mean it is stopped.
- **Differences:** Amateur: a standing count is used (R1 11.1; R2 14.8, "standing Eight Count"), with limits per round and per bout (R1 §11). ABC pro: "There is NO Standing Eight (8) Count" and no three-knockdown rule; the eight count after a knockdown is mandatory (R21 rules 5, 7, 8).

### 3.16 Retirement / towel (ABD) (step 16–17)
- **Rule:** "if a coach throws the towel into the ring" (R1 10.2.1). SOURCED unless tagged.
- **Plain:** The corner stops the bout to protect their boxer; the opponent wins.
- **Why:** Retiring him early can spare him worse damage.
- **Differences:** USA Boxing: the same, and coaches must carry a towel (R2 15.2; R2 26). BBBofC: the manager or chief second retires the boxer, and never while a round is in progress (R8 3.43).

### 3.17 Disqualification (DQ) (step 17)
- **Rule:** "If a Boxer is disqualified for a foul or for any other reason" (R1 10.5.1). SOURCED unless tagged.
- **Plain:** A loss for serious or repeated fouls, or other rule breaking.
- **Why:** Dirty fighting can cost the whole bout, not just points.
- **Differences:** USA Boxing: missing weight is also a DQ (R2 11.1(4)). ABC pro: an intentional foul that ends the bout is a DQ (R21 12.A.1). MMA: the same principle (R3).

### 3.18 Supervisor (England Boxing) / OIC (USA Boxing) (step 8–9, 15)
- **Rule:** See §1.8: "The Supervisor shall have complete charge of the club tournament" (R1 6.6.1). SOURCED unless tagged.
- **Plain:** The official in charge of the whole show, whose decision is final.
- **Why:** He signs off matches and settles disputes.
- **Differences:** As in §1.8. Use "Supervisor" in a UK tutorial and alias OIC to it (JUDGEMENT).

**Checked but left out.** These are not met in steps 7–18, or are already covered:
- **walkover** is included above, from step 14.
- **sparring** is not in steps 7–18. But the 30-day pre-first-bout sparring rule (R1 5.7.1(f)) matters when a new boxer is carded in step 7. Optional: Controlled practice boxing with a partner, under a registered coach. Why: England Boxing requires 30 days' sparring before a first bout. (R2 definitions; R1 5.7.1(f)).
- **matchmaking** is covered by §1.13 (matchmaker) and the `offer` fix.
- **agreed weight** is covered by §1.3.

---

## 4. Where amateur, pro and MMA diverge enough that the game must pick one

All recommendations are JUDGEMENT, built on the SOURCED differences in §1.

| Topic | Amateur (England Boxing / USA Boxing) | Pro boxing | MMA | Recommendation |
|---|---|---|---|---|
| Weigh-in timing and failure | Same day; fail = WO or DQ (R1 7.1.3, 10.7.2; R2 11.1) | 24–36 h before (BBBofC); purse forfeit (Nevada) | Usually the day before (R15) | The tutorial and amateur career use the same-day, walkover rule. Pro and MMA use a day-before weigh-in with a purse penalty. |
| Stoppage words | RSC, RSC-I, ABD, WO | TKO, KO, retirement (R8 3.43) | TKO, KO, submission | Show RSC/ABD/WO in amateur results and TKO in pro and MMA. Handbook entries name both. |
| Draws | None (R1 9.1.5) | Allowed | Allowed | The amateur sim must never produce a draw. |
| Head official | Supervisor (England Boxing) / OIC (USA Boxing) | Commission inspector | Commission inspector | The tutorial is UK, so use "Supervisor" and alias OIC to it. |
| Matching gap | ≤2 kg only for Minors and Schools; otherwise up to one category (R1 §2) | Same class, or a small table spread | Within 5 lb on a weight miss | Fix J52 step 9. Use "≤2 kg" only for boxers under 13 (Minors/Schools); otherwise "within one weight category". |
| Suspension days | 30 days, then 1 year (EB); 30/90/180/540 (USA) | KO 60 / TKO 30 (ABC); 28 or 45 (BBBofC) | Per commission | Use England Boxing numbers for amateur careers and state them as minimums set by the doctor. |
| Corner size | 3 (EB 5.6.1) | 3–4 | 3 + cutman | Allow 3 seconds for amateurs and 4 for pro title fights. |
| Headguard | Required except senior men (EB 8.3.1); all LBC (USA) | None | None | Tie it to age and sex in the amateur ruleset. |
| Pay | None at club level | Purse, show and win money | Show and win money | Amateur income comes from club dues and shows, not purses. |
| Rankings | Club boxers are not ranked | WBC/IBF/WBA lists | Promotion rankings | Hide ranking in the amateur career. |

---

## 5. Sources

All read 2026-09-25. Type key: STANDARD = rulebook, regulation or statute. ACADEMIC = peer-reviewed or institutional science. TRADE = court exhibit or industry document. PRESS = news. COMMUNITY = club blog. DEV = internal game document.

| ID | Title | Date | Type | URL | Read |
|---|---|---|---|---|---|
| R1 | England Boxing Technical & Competition Rules 2026 (EB-RB-26.3, valid from 1 Jan 2026; the Jan 2026 file EB-RB-26.pdf matches it) | 2026-08 upload | STANDARD | https://www.englandboxing.org/wp-content/uploads/2026/08/EB-RB-26.3.pdf | 2026-09-25 |
| R2 | USA Boxing National Rulebook, revised 1 Jan 2026 | 2026-01-01 | STANDARD | https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt5ff28f6e78e9624d/695ed2d8b45570d8a64b74b9/USA_Boxing_Rule_Book_Revisions_-_1.1.2026.pdf | 2026-09-25 |
| R3 | ABC Unified Rules of MMA, rev. July 2024 (also the amended Aug 2026 file; the clauses used are unchanged) | 2024-07 / 2026-08 | STANDARD | https://www.abcboxing.com/wp-content/uploads/2024/07/unified-mma-rules-rev-july-2024.pdf ; https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf | 2026-09-25 |
| R4 | ABC Regulatory Guidelines and Rules for World and Regional Championship Bouts (page sidebar names BoxRec and mmareg.com as record keepers) | 2005-07-27 | STANDARD | https://www.abcboxing.com/abc-regulatory-guidelines/ | 2026-09-25 |
| R5 | Nevada Administrative Code ch. 467 (Unarmed Combat) | current online | STANDARD | https://www.leg.state.nv.us/nac/nac-467.html | 2026-09-25 |
| R6 | Nevada Revised Statutes ch. 467 | current online | STANDARD | https://www.leg.state.nv.us/nrs/nrs-467.html | 2026-09-25 |
| R7 | California Code of Regulations, tit. 4 §352 (LII) | current online | STANDARD | https://www.law.cornell.edu/regulations/california/4-CCR-352 | 2026-09-25 |
| R8 | British Boxing Board of Control Rules and Regulations 2026 | 2026 | STANDARD | https://bbbofc.com/build/documents/Rules_and_Regulations_2026.pdf | 2026-09-25 |
| R9 | WBC Rules & Regulations, approved at the 62nd Convention, 8 Dec 2024 | 2024-12-08 | STANDARD | https://wbcboxing.com/en/descarga/reglas-y-regulaciones-5/?wpdmdl=2535 | 2026-09-25 |
| R10 | IBF/USBA Rules Governing Championship Contests (amended to 30 Apr 2025) | 2025 | STANDARD | https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf | 2026-09-25 |
| R11 | IBF Second Day Weigh-in Guidelines (bouts sanctioned after 19 Jan 2021) | 2021 | STANDARD | https://www.ibf-usba-boxing.com/wp-content/uploads/2nd-Day-Weigh-In-Guidlines-Updated-1.pdf | 2026-09-25 |
| R12 | 15 U.S.C. §6301, Definitions (Professional Boxing Safety Act; LII) | current online | STANDARD | https://www.law.cornell.edu/uscode/text/15/6301 | 2026-09-25 |
| R13 | Kentucky 201 KAR 27:016 (mixed martial arts) | engrossed text | STANDARD | https://apps.legislature.ky.gov/law/kar/downloads/docs/14681/document.engrossed.pdf | 2026-09-25 |
| R14 | England Boxing, Phase One Screening, Safeguarding and the BCR1 Medical | 2023-09 upload | STANDARD | https://www.englandboxing.org/wp-content/uploads/2023/09/Phase-One-Screening-Safeguarding-and-the-BCR1-Medical.pdf | 2026-09-25 |
| R15 | ISSN position stand: nutrition and weight cut strategies for MMA and other combat sports (J Int Soc Sports Nutr) | 2025 | ACADEMIC | https://pmc.ncbi.nlm.nih.gov/articles/PMC11894756/ | 2026-09-25 |
| R16 | Reale, Acute weight management in combat sports, GSSI Sports Science Exchange 31(183) | 2018 | ACADEMIC | https://www.gssiweb.org/docs/default-source/sse-docs/reale_sse_183.pdf | 2026-09-25 |
| R17 | Le v. Zuffa, Doc 752-11, Ex. 11 "Forms of UFC Compensation" | 2019-10-07 | TRADE | https://storage.courtlistener.com/recap/gov.uscourts.nvd.108274/gov.uscourts.nvd.108274.752.11.pdf | 2026-09-25 |
| R18 | MMA Junkie, California approves 10-point weight-cutting plan | 2017-05-16 | PRESS | https://mmajunkie.usatoday.com/story/sports/ufc/2017/05/16/california-state-athletic-commission-weight-cutting-10-point-plan/82284470007/ | 2026-09-25 |
| R19 | Stevenage ABC, Between the ropes: weight and amateur boxing (J52 S57) | 2024-12-05 | COMMUNITY | https://www.stevenageboxing.com/post/between-the-ropes-weight-and-amateur-boxing | 2026-09-25 |
| R20 | Honour & Glory, Amateur boxing competition day: what to expect (J52 S58). Read for context; not cited above | 2026-03-17 | COMMUNITY | https://www.honourandglory.co.uk/blog/amateur-boxing-competition-day-what-to-expect | 2026-09-25 |
| R21 | ABC Unified Rules of Boxing (amended 3 Aug 2016) | 2016-08-03 | STANDARD | https://www.abcboxing.com/wp-content/uploads/2016/10/unified_rules_boxing_rev_august2016.pdf | 2026-09-25 |
| R22 | USA Boxing Medical Handbook for Ringside Physicians (revised 15 May 2026) | 2026-05-15 | STANDARD | https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt6207d597c0043641/6a061613b79a656778281a33/USA_Boxing_Medical_Handbook.pdf | 2026-09-25 |
| R23 | World Boxing Competition Rules (in force November 2024) | 2024-11 | STANDARD | https://worldboxing.org/wp-content/uploads/2025/09/World-Boxing-Competition-Rules-Nov-2024-Approved-4.pdf | 2026-09-25 |
| R24 | California Code of Regulations, tit. 4 §297, Weighing Time (LII) | amended 2017-07-12 | STANDARD | https://www.law.cornell.edu/regulations/california/4-CCR-297 | 2026-09-25 |
| R25 | J52 Tooltips and Tutorial memo (§6b, §6d) | 2026 | DEV | /workspace/j52/J52_TOOLTIPS_AND_TUTORIAL.md (local) | 2026-09-25 |

---

## 6. NOT FOUND

- **USA Boxing number of seconds in the corner.** R2 Rule 26 describes coaches and seconds but gives no count in the text I read. World Boxing allows up to 3 (R23 3.1.2).
- **Rulebook definitions of walk-around weight, weight cut, fight camp, fight week and taper.** None of R1–R11 or R21 defines them. §1 uses academic proxies (R15, R16). There is no verified source for taper, because the Mujika & Padilla abstract returned 403 (Appendix A).
- **Weigh-in timing in the ABC Unified Rules of MMA.** It is set by each commission. Nevada gives no hour count: the time and place are "designated by the Executive Director" (R5 NAC 467.514).
- **A unified MMA medical suspension day count.** R3 has none; only state rules (e.g. R13 Kentucky).
- **An England Boxing rule for amateur prize money or pay at club level.** Treat "no purse" as PROXY.
- **An MMA rulebook definition of rankings, mandatory challenger or eliminator.** These come from promotions, not rules.
- **A first-hand England Boxing definition of "carded".** It is only found in club usage (R19).
- **IBA technical rules.** Not fetched; it is a Grok lead only (Appendix A).

---

## 7. Limits

- **Word counts** were checked by a script splitting on whitespace. Hyphenated words ("walk-around", "one-minute") count as one word; "W-L-D" counts as one. Quoted rule text excludes the source ID and my framing words.
- **Rulebook versions:**
  - England Boxing: the 26.3 file (uploaded Aug 2026). It matches the Jan 2026 file in every section used.
  - ABC MMA: the Aug 2026 amendments are not yet in force (implementation requested for Nov 2027). The clauses used are the same in the July 2024 version.
  - WBC: the 2024 edition. The 2015 edition had different safety-check percentages and is not used.
- **Pro rules vary by state and country.** Nevada, California and Kentucky are examples, not a US-wide rule. The ABC guidelines (R4) date from 2005 and are guidance to commissions.
- **The purse and show/win example (R17)** is one UFC court exhibit from 2019. Amounts are illustrative only.
- **PDF text was extracted with pdftotext.** Quotes were matched against that text. A few PDFs have typos (e.g. "orhard" in R1 10.3.2); quotes stop before them.
- **I did not read WBA, WBO or IBA rulebooks.**
- **Glossary line numbers** refer to the file as read on 2026-09-25.
- **Page instructions:** no fetched page tried to instruct me.
- **Grok:** it ran once with grok-4.6, reasoning xhigh and live search, and exited normally after about 7 minutes. My prompt to it included three wrong hints (an England Boxing "OIC", "28/84/365" days, and "2 seconds" for amateurs); Grok corrected all three. Its unverified claims are only in Appendix A.

---

## Appendix A. Grok leads, unverified

These are leads from the Grok research pass (`/workspace/j53/scratch/grok_out.txt`) that I did **not** confirm against the source page. Each one is a grok lead, unverified. Do not use them in the game without checking.

1. IBA Technical & Competition Rules (2026) as a further amateur source, at iba.sport. Grok lead, unverified.
2. California 4 CCR §298, a weight-difference table for pro bouts. Grok lead, unverified. (§297, the 30-hour weigh-in, *was* verified as R24.)
3. The WBC Weight Management Program PDF (abcboxing.com/2019/08) and a fight-day 10% regain cap under WBC 4.15. Grok lead, unverified. R9 4.15 confirms that a WMP exists, but not the 10% figure.
4. WBA Rules (wbaboxing.com, 11.08.2023 file) for WBA mandatory and eliminator wording. Grok lead, unverified.
5. BBBofC 19.6: a matchmaker may not take commission from boxers. Grok lead, unverified.
6. NRS 467.150 as the statutory source of the 60-second rest in Nevada. Grok lead, unverified. (The one-minute rest is otherwise SOURCED: R2 24.1, R3, R8 3.7.)
7. England Boxing Annex C2: skills bouts and a Class A/B scheme with ≤2 kg gaps. Grok lead, unverified in the detail. Skills bouts themselves are confirmed in R1 2.3.5.
8. Taper definition, Mujika & Padilla 2003 (Med Sci Sports Exerc): "progressive nonlinear reduction of the training load". Grok lead, unverified; PubMed returned 403.
9. WBC 2024 4.14 "2 to 30 hours" conflicting with its own "30-24-hour" wording. Grok lead, now **verified**: both phrases appear in R9 4.14. Listed here for traceability.

# C31 — The corner: who is licensed to be there, and what they do

**Research complete 2026-09-07.** This is a rules-and-role study, not a wage
table and not an implementation spec. It uses current published commission
rules where they answer the question and writes **UNKNOWN** where they do not.
Boxing provisions are labelled boxing; they are not silently imported into
MMA.

## Decisions page

| Call | Recommendation | Why |
| --- | --- | --- |
| **Q1 — licence** | Make `second` / `cornerman` a jurisdiction-licensed **event role**, not a synonym for employed coach. | Nevada, California, New York and New Jersey all regulate seconds; the issuer and requirements are the event jurisdiction's commission, not the gym. |
| **Q2 — cutman** | Treat `cutman` as a specialist capability attached to an approved/licensed corner participant; do not create one universal national cutman licence. | Published rules distinguish the work, but the retrieved bodies do not expose one consistent credential named “cutman.” National uniformity is **UNKNOWN**. |
| **Q3 — qualification** | Store licence body, role, validity and any event approval; do not author a universal exam or reciprocity rule. | California publishes an exam and competency demonstration; New York may require demonstrated knowledge/skills and seminars; Nevada's retrieved second rule publishes a licence and fee, not a second-specific exam. |
| **Q4 — corner size** | Put permitted corner count in the event ruleset, never in coach data. | The ABC Unified MMA Rules do not set one count. Nevada MMA permits three seconds, exceptionally four; California's incorporated professional rules describe four; other retrieved texts differ or are sport-specific. |
| **Q5 — access** | Separate `chief_second`, `inside_corner`, `apron/perimeter_second` and `cutman` permissions. | A licence does not mean everyone may enter the ring/cage. Nevada MMA allows one second and one cutman inside during the rest; California permits one inside the ropes, two on the apron and one on the floor. |
| **Q6 — conduct** | Model the corner as a bounded rest-period service: advice, water/ice and approved cut treatment; prohibit interference, excess water, unapproved substances and coaching during a referee timeout. | These are published duties and prohibitions. They are firmer than any numerical “corner bonus.” |
| **Q7 — stoppage** | The corner may **request/signal** a stop only as the event rules permit; the referee/authorized official records and effects it. Never ship an always-legal `THROW TOWEL` verb. | ABC makes the referee sole official arbiter while recognizing corner stoppage as a result; California permits a manager/chief second to toss a towel, while New York MMA treats towel throwing as corner interference and New Jersey names only the referee/physician as authorized stoppers. |
| **Q8 — gym staff kinds** | Keep training staff and fight-night credentials as two axes: head/technical coach, discipline coach, S&C, cut specialist/second, with manager kept on J4's separate desk. | Real high-performance programs publish distinct technical, S&C, medicine, nutrition and performance roles, while commission rules allow some people to wear more than one licensed hat. |
| **Q9 — `coach_rating`** | Keep the single rating as an early compression of **instruction quality**, but do not let it imply corner legality or every specialty. | It is honest for the broad demand kind J8 found; it becomes flattening when used as licence, cut skill, S&C skill or event access. |
| **Q10 — pay** | Author no corner purse percentage and no default corner fee. Keep the gym corner-income line absent/zero. | The retrieved statutes/rules publish licence fees and conduct, not a standard compensation table. J6 A4/A6/A10 remains unlifted. |
| **Q11 — next build** | Do **not** interrupt R46. After the queued money screen, the first corner slice should be a small event-rule/assignment read: eligible chief second, optional cut capability, allowed count and stop-signal policy. | That turns evidenced rules into a useful gate without inventing performance magnitudes, wages, a new screen or a staff rewrite. |

## Priority ruling

**Priority: immediately after the already-queued R46 desk/money screen, before
adding another live corner command.** R46 is a committed screen backed by live
reads and C31 does not invalidate it. C31 instead gates the next corner-facing
work: before another call can be offered, the bout should know whether a
licensed/eligible chief second is assigned and what that event ruleset permits.

The smallest honest slice is data/read authority, not UI:

1. Event jurisdiction/ruleset supplies `max_seconds`, inside-area permissions,
   and `corner_stop_signal_policy`.
2. Staff assignment supplies a chief second and optional cut-treatment
   capability; a training coach may fill either only when eligible.
3. The bout exposes whether a corner-stop **request** is legal and who has
   authority to effect the stoppage.

No coach-effect coefficient, wage, purse percentage, rapport change or new
screen follows from this study.

---

## 1. Evidence method and limits

The rule spine is the Association of Boxing Commissions and Combative Sports'
2024 Unified Rules of Mixed Martial Arts plus commission law/rules from Nevada,
California, New York and New Jersey. The ABC text is a model ruleset, not a
federal licence and not proof that every commission has adopted every revision.
The event jurisdiction remains authoritative.

The retrieved material is strong on licence, access, equipment, conduct and
stoppage authority. It is weak or silent on employment relationships and
compensation. Silence is not filled with custom, interviews, remembered purse
percentages or a game's need for a number.

## 2. The licence

### Q1 — a second is a regulated event role

This is not merely a job title printed by a gym:

- **Nevada:** NRS Chapter 467 requires seconds and trainers, among other event
  participants, to be licensed. NAC 467.012 publishes a second's licence fee
  and calendar-year validity. NAC 467.057 lets a licensed manager act as a
  second without a separate second licence.
- **California:** Business and Professions Code §18642 says a person may not
  serve as a trainer or second without a commission licence. The commission
  licenses trainers, chief seconds and seconds. BPC §18811 publishes their
  application/renewal fee.
- **New York:** 19 NYCRR §207.1 bars acting as a trainer or second in
  professional boxing or MMA without a commission licence. Section 207.9 lets
  a licensed manager second an athlete covered by that manager's contract;
  otherwise a second licence is required.
- **New Jersey:** the State Athletic Control Board's current licensing page
  says managers and seconds must be licensed for combative sports, including
  MMA and kickboxing, and routes applications through the promoter/event.

**Game consequence:** `employed_by_gym` and `eligible_at_event` are different
facts. Employment cannot manufacture a commission credential. Licence data
needs at least jurisdiction/body, role, status/validity and event approval where
the body uses it. A single global `licensed = true` would overstate reciprocity.

### Q2 — cutman is a distinct capability; its credential is jurisdictional

The rules plainly recognize specialized cut work:

- ABC permits petroleum jelly between rounds by an approved cutman or licensed
  cornerman.
- Nevada identifies a cutman separately in its MMA access rule and requires
  the chief second to carry approved haemorrhage solution, gauze, tape,
  scissors, ice, clear water and an extra mouthpiece; ammonia is forbidden.
- New York publishes a substantially similar chief-second kit.

Those provisions prove that cut treatment is different work. They do **not**
prove a nationally uniform licence class called `cutman`. In some text the
person is “approved”; elsewhere the person is one of the licensed seconds.
Whether a separate credential exists outside each event body's process is
**UNKNOWN** and must remain jurisdiction data.

### Q3 — requirements are not one national exam

- **California 4 CCR §545:** a martial-arts/kickboxing second must pass a
  written examination on fundamentals and California rules and demonstrate
  competency; the commission may waive this for a valid, discipline-free
  licence from another jurisdiction.
- **New York 19 NYCRR §207.7:** the commission may require a second applicant
  to demonstrate rule knowledge and relevant skills and may require seminars.
- **Nevada:** the retrieved current rules establish the licence, fee, validity,
  ethics/discipline and event duties. A second-specific practical exam was not
  found: **UNKNOWN**, not “none.”
- **New Jersey:** the current licensing page establishes the application path.
  The published examination rule retrieved in Subchapter 7 is expressly for a
  **boxing** second; applying it to MMA without an incorporation rule would be
  an unsupported transpose. MMA exam requirement: **UNKNOWN** this pass.

The design should therefore validate against a chosen commission ruleset. It
should not invent universal experience points, training hours, age limits,
fees or automatic reciprocity.

---

## 3. The corner as a published rule

### Q4 — permitted count belongs to the event ruleset

| Source / sport | Published count | Boundary |
| --- | --- | --- |
| ABC Unified MMA 2024 | **Not specified in the retrieved unified text** | ABC cannot supply a universal count. |
| Nevada MMA, NAC 467.635 | Maximum **three** seconds; commission may permit **four** for a main event, world title or special event | One second and a cutman may be inside the fenced area during the rest period. |
| California professional rules, 4 CCR §§361 and 502 | **Four** seconds under the professional rules incorporated into martial arts except listed exclusions | One inside the ropes, at most two on the apron, one on the floor. Confirm event instructions for cage geometry. |
| New York boxing, 19 NYCRR §211 | Up to **three**, or **four** for a championship | This is a boxing provision. A parallel numeric MMA rule was not found in Part 212: **UNKNOWN**. |
| New Jersey boxing, N.J.A.C. 13:46-7.2 | At least **two**, at most **three**, or **four** for a championship | This is boxing. The current MMA subchapter retrieved does not publish a parallel count: **UNKNOWN**. |

“Three cornermen” is therefore not an MMA law of nature. The count, exceptional
count and physical positions belong to the event, discipline and commission.

### Q5 — who may be where, and when

The ordinary cadence is a one-minute rest after an MMA round under the ABC
rules. Within that minute, access is constrained:

- Nevada requires the referee to identify the chief second, makes that person
  responsible for assistants, and permits one second plus a cutman inside the
  MMA fenced area during the rest.
- California's incorporated professional provisions distinguish the one
  person inside the ropes, up to two on the apron, and one on the floor.
- New York's MMA foul rule requires seconds/cornermen/trainers to remain in
  their designated area during the round.
- New Jersey's MMA stoppage rule reserves entering the fighting area **during
  competition** to the referee and ringside physician.

That calls for permissions, not cosmetic slots. `chief_second` is the
accountable role; `inside_corner` is a temporary access permission; cut
treatment is a capability. They may attach to the same person, but are not the
same field.

### Q6 — permitted service and prohibited conduct

Published positive duties/materials include clear water, ice, an approved
haemorrhage-control solution, tape, gauze, scissors and a spare mouthpiece.
ABC permits petroleum jelly between rounds through an approved cutman or
licensed cornerman. These establish a bounded service vocabulary: advise,
hydrate, cool, inspect/treat a cut with approved materials, manage equipment,
and have the fighter ready for the next round.

Published boundaries include:

- no ammonia in the corner kit (Nevada and New York);
- no excessive water/ice and responsibility for a dry corner (Nevada and
  California);
- no corner interference with the contest or attempts to distract/influence
  the referee (ABC; interference also appears as a state-rule foul);
- no coaching during an ABC referee timeout, including a foul-cut treatment
  interval; and
- jurisdiction-specific limits on loud, excessive or disruptive coaching.

California and Nevada wording about “excessive coaching” does not justify a
universal volume meter or advice quota. It supports a prohibited-conduct state
and commission/referee enforcement. The actual penalty and threshold stay in
the ruleset or **UNKNOWN**.

### Q7 — what “the corner stopped it” legally means

Three different concepts must not be collapsed:

1. **Authority:** ABC 2024 says the referee is the sole arbiter and only person
   authorized to stop the contest. New Jersey MMA names the referee and
   ringside physician as the sole arbiters/authorized stoppers.
2. **Result classification:** ABC recognizes a technical knockout by referee
   stoppage, including a corner stoppage and a fighter who does not answer the
   bell. “Corner stoppage” can therefore describe why the authorized official
   ended it without making the corner the official arbiter.
3. **Signal legality:** California 4 CCR §364 permits a manager or chief second
   to toss a towel and follow it into the ring. By contrast, New York MMA lists
   corner interference, including throwing in the towel, as a foul; Nevada's
   foul list also includes throwing in the towel during competition. New
   Jersey MMA reserves stoppage authority to referee/physician and lists
   interference from a fighter's seconds as a foul.

The safe game verb is `REQUEST CORNER STOP` or `DO NOT ANSWER`, resolved under
the active ruleset and official authority. A visually familiar towel may be a
legal signal in one event and prohibited interference in another. C31 supplies
no evidence for an automatic, universal or consequence-free towel button.

---

## 4. What staff a combat gym has

### Q8 — roles as kinds, without pretending every gym has departments

The UFC Performance Institute's published service/team structure is useful as
evidence of **role kinds**, not as a claim about every independent gym. It
separates MMA technical coaching (including discipline/coordinator roles),
strength and conditioning, sports medicine/physical therapy, performance
science, nutrition and psychology. Commission rules separately establish
fight-night chief-second, assistant-second and cut-treatment responsibilities.

For FightCamp, the honest minimal taxonomy is:

| Axis | Kinds established by the record | What not to infer |
| --- | --- | --- |
| Training | head/technical coach; discipline coach; strength and conditioning | No universal headcount, rating effect or payroll band. |
| Fight night | chief second; assistant second; cut specialist/capability | No universal number of slots or separate cutman licence. |
| Performance support | medicine/therapy; nutrition; performance science/psychology | Kinds exist at a high-resource institute; every gym employing each is **UNKNOWN**. |
| Business representation | manager | J4 E1–E3 stand. This is a separate desk, not a coaching subtype. |

One human may wear more than one hat. Nevada lets a licensed manager act as a
second; New York lets a manager second the athlete under that manager's
contract; California permits the manager or chief second to signal with a
towel. Those rules establish overlap as possible, not mandatory. Each hat must
still pass the event body's rule.

### Q9 — `coach_rating` is both useful and incomplete

J8 N7 remains the demand finding: coach quality is the strongest retrieved
combat-gym demand **kind**, while its numerical effect is unknown. A single
rating is therefore an honest early compression when the question is “how good
is this person's general instruction?” It is a flattening when the same number
answers any of these:

- may this person legally work this event's corner?
- may this person enter the fighting area during the rest?
- can this person perform approved cut treatment?
- is this person a discipline specialist or S&C coach?
- may this person make a particular stop signal under this commission?

Keep the rating and add orthogonal capabilities/credentials only when a system
uses them. Nothing here supports splitting the training formula, rewriting
`CoachRapport.gd` / `PlanCoach.gd`, or assigning numeric specialty bonuses.

---

## 5. What the corner is paid

### Q10 — no published default percentage was found

The commission record retrieved for C31 publishes licensing fees, application
rules, conduct, equipment and authority. It does **not** publish a standard
trainer/cornerman/cutman share of a fighter's purse or a standard gym corner
fee. An official licence fee is money paid **to the regulator**; it is not
evidence for compensation paid **to the corner**.

Therefore:

- trainer percentage: **UNKNOWN**;
- cornerman percentage: **UNKNOWN**;
- cutman percentage: **UNKNOWN**;
- flat event fee: **UNKNOWN** as a universal default;
- gym corner income: **absent / zero** until a real contract or sourced game
  object exists.

J6 A4 stands: the fighter receives the bout agreement amount subject only to
itemized approved deductions. J6 A6 stands: no tax settlement line. J6 A10
stands: no trainer/cutman percentage is authored, and a contest-related share
at or beyond the manager threshold may legally turn the arrangement into
management rather than “just a corner fee.” No primary source retrieved here
lifts any refusal.

---

## 6. Implementation boundary implied by the evidence

This is a later contract shape, not authorization to build it in C31:

- **Person/staff facts:** training role kinds and optional cut capability.
- **Credential facts:** commission/jurisdiction, licensed role, validity,
  discipline/approval state where published.
- **Bout assignment:** chief second, assistants, inside-area participants.
- **Event rules:** permitted count, inside permissions, allowed equipment,
  timeout-coaching rule, corner-stop signal policy and official stop authority.
- **Read outcome:** eligible / ineligible / unknown, with a one-line reason.

This preserves one person wearing several hats without turning one
`coach_rating` into a legal credential. It also lets missing jurisdiction data
return **UNKNOWN** instead of silently applying Nevada, California, boxing or a
television convention everywhere.

## Sources

### Unified rules

- [ABC — Unified Rules of Mixed Martial Arts, revised July 2024](https://www.abcboxing.com/wp-content/uploads/2024/07/unified-mma-rules-rev-july-2024.pdf?cb=1753559792): round/rest cadence; referee authority; petroleum jelly; corner interference; timeout coaching; corner-stoppage result category.

### Nevada

- [Nevada Revised Statutes, Chapter 467](https://www.leg.state.nv.us/nrs/nrs-467.html): commission licensing authority and regulated participants.
- [Nevada Administrative Code, Chapter 467](https://www.leg.state.nv.us/nac/NAC-467.html): NAC 467.012, 467.057, 467.437, 467.628, 467.635, 467.642 and the published foul provisions.

### California

- [California State Athletic Commission — Laws and Regulations](https://www.dca.ca.gov/csac/stats_regs/calregs.html): current commission index, applications and rule links.
- [CSAC Laws and Regulations manual](https://www.dca.ca.gov/csac/stats_regs/lawreg_manual.pdf): BPC §§18642 and 18811; 4 CCR §§361–365, 502 and 545. The commission index is the current routing authority; event staff must verify the live section text rather than treating this downloaded compilation as permanent.

### New York

- [New York Department of State — 19 NYCRR Parts 206–214](https://dos.ny.gov/19-nycrr-parts-206-214-0): §§207.1, 207.7, 207.9; boxing Part 211; MMA Part 212 licence, conduct, equipment and foul rules.

### New Jersey

- [New Jersey State Athletic Control Board — licensing](https://www.njoag.gov/licensing-permits/athletic-control-board-licensing/): current participant/licensing route.
- [N.J.A.C. 13:46-24A.12 — stopping an MMA contest](https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-24A-12), [24A.15 — fouls](https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-24A-15), and [24A.17 — bout results](https://www.law.cornell.edu/regulations/new-jersey/N-J-A-C-13-46-24A-17): quarterly-updated codified rule text. This mirror is used because the official licensing page's rule portal was not machine-readable in this pass.

### Staff-role kinds

- [UFC Performance Institute](https://www.ufcpi.com/): published performance services.
- [UFC Performance Institute teams](https://www.ufcpi.com/teams): technical MMA, discipline/coordinator, strength and conditioning, medicine, nutrition and performance-science role kinds. Used only to establish kinds at a high-resource program, not universal staffing.

### Standing FightCamp rulings preserved

- `J8_THE_MEMBERS.md` N7: coach quality is the strongest retrieved demand kind; magnitude unknown.
- `J6_THE_ATHLETES_OWN_LEDGER.md` A4/A6/A10: full-purse/itemized-deduction rule; no tax model; no trainer/cutman percentage.
- `J4_THE_DESK_AND_THE_CUT.md` E1–E3: athlete is bout-contract party; manager caps are not defaults; a contest-related share can cross the manager boundary.

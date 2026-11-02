# TASK C55 — CODEX — THE PATH: HOW A FIGHTING CAREER IS ACTUALLY WALKED

Model: gpt-5.6-luna, effort **high**, Fast off. One session, after C54.

**Agent:** codex · **Opened:** 2026-09-08 · **Runs after:** C54

**Research only. Two markdown files. No script, no scene, no data, no test.**

## Why this exists

The game can simulate a fight, a card, a belt, a ledger and an injury. It
cannot answer the question a management game exists to answer: **what is this
fighter's path, and what did the gym and the fighter decide together to get
there?** Four specific things are missing.

1. **The career has no entry.** An athlete is created with a `discipline`
   already set (`GameState.gd:821`) and a rating already assigned. Nothing
   models how a person arrives at a gym, why in that discipline, or what the
   first two years look like.
2. **An athlete holds exactly ONE discipline, forever.** There is no second
   discipline, no crossover, no "wrestler who moved to MMA". The single
   `discipline` string is the whole model. Nothing in the research record
   touches this — it is the largest gap in the task.
3. **A grade has no consequence.** C52 settled what a grade IS. It
   deliberately did not say what a grade DOES in a game, or how a player
   experiences white → black over a career.
4. **Turning pro is a side effect, never a decision.** `_turn_pro`
   (`GameState.gd:5499`) has exactly two callers: `:5619`
   (`promotion_contract`) and `:11705` (`paid_bout`). Both are consequences of
   something the player did for another reason. The player is never told the
   door is there, never weighs it, and is never advised by the gym.

## GROUND ALREADY SETTLED — do NOT re-derive, cite it and move on

Re-answering any of these wastes the session and risks contradicting a module
being built against the first answer right now.

* **How grades are earned, per discipline.** `C52_THE_TOURNAMENT_AND_THE_GRADE.md`
  has the ladders (BJJ, judo, karate, taekwondo, muaythai, MMA, kickboxing),
  the sourced time minima (IBJJF blue 2y / purple 1.5y / brown 1y; IJF 1st dan
  age 15 + 1y brown, 2nd dan age 16 + 1y 1st dan) and the disciplines with no
  universal grade (wrestling, boxing, sanda). `GradeLadder.gd` is being
  written from it. **Take those as given.**
* **What legally ends amateur eligibility.** `J2_THE_FEDERATION_PATHWAY.md` D5
  and `EntityPathway.ends_amateur_eligibility` (`:274`). The one-way door and
  its triggers are settled. You are asked about the DECISION, not the rule.
* **How an amateur fight is made.** `U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md` — the
  coach is the verb, ticket quotas are house policy, the amateur record is a
  separate currency.
* **Federation money.** J2 and your own C54. Do not re-price it.

## The questions

Answer each with sourced evidence and an inline link, or write **UNKNOWN**.
An UNKNOWN is as valuable as a source — do not invent an age, a rate, a
percentage or a typical timeline you cannot cite.

### A. THE ENTRY — where a career starts

1. At what ages do people actually begin each of the game's disciplines, and
   which are childhood-entry sports versus adult-entry sports? Boxing and
   wrestling versus BJJ and MMA differ sharply here; say which are sourced.
2. What does the first two years look like before anyone competes — gym
   membership, club affiliation, licence, medical, first smoker or interclub?
   Which of these is a documented requirement and which is custom?
3. Do people arrive at a gym already having a discipline, or does the gym
   assign one? What actually decides it — geography, the club's own
   speciality, family, body type? `WorldPopulation` already models regional
   `discipline_weights` (`:553`, `:614`); say whether that matches reality or
   whether the real driver is something else.

### B. THE CROSSOVER — the biggest gap

4. **What are the real, common discipline-transition paths?** Wrestling → MMA,
   judo → BJJ or sambo, karate/taekwondo → kickboxing, kickboxing → muaythai,
   amateur boxing → pro boxing → MMA. For each, say how common it is and at
   what career stage it happens.
5. **What do the governing bodies actually permit?** J2's sources already
   surfaced IJF SOR 4.1 on judoka competing in other combat sports — follow
   that thread. Which federations restrict, sanction or ignore an athlete
   competing in a second discipline? Is anyone stripped, suspended or made
   ineligible?
6. What CARRIES OVER and what does not? When a wrestler moves to MMA, what
   part of the record, ranking, grade or credential follows them and what is
   reset to zero? Be specific about the record: does an amateur wrestling
   record appear anywhere in an MMA record?
7. Is a transition usually a SWITCH (the old discipline is left behind) or an
   ADDITION (both are trained and one is competed in)? The answer decides
   whether the game needs a second `discipline` field or a set.
8. What does a crossover cost in time and in performance — how long before a
   converted athlete is competitive, and what typically fails first?

### C. THE GRADE AS A MECHANIC — what it DOES, not what it is

9. Outside the divisions and entry credentials C52 already documented, what
   does holding a grade actually get a person? Teaching rights, coaching
   licences, refereeing, seconding, club status, income. Which are sourced?
10. **Who awards it, and can that person be the player's own gym?** Is it the
    instructor, the club, a national body, a certifying authority? This is the
    load-bearing question for the game: if the gym's own head coach can award
    a grade, the mechanic is a gym decision; if a certifying body must, it is
    an external event the gym only prepares for. Answer per discipline.
11. What can DELAY or DENY a grade that the time minima do not capture —
    examination failure, attendance, competition requirement, politics,
    the instructor simply not promoting someone?
12. **Design: how should white → black be played in a management game?** Price
    at least four options — (i) an automatic award when the sourced minimum
    elapses, (ii) a gym decision the player makes with a cost and a
    consequence, (iii) an examination the athlete can fail, (iv) grade as
    pure display with no mechanical effect. Give each an engineering cost
    against the existing seams and **recommend one.**
13. What should a grade change mechanically, if anything? Note the standing
    C52 rule it must not break: **a grade is never derived from the seven
    stats.** Say whether it may INFLUENCE them, and what the honest direction
    of causation is.

### D. THE DECISION TO TURN PRO — and who makes it

14. What actually leads a real amateur to turn professional? Age, amateur
    record, a ceiling reached, money, an offer, a coach's judgement, a failed
    Olympic cycle. Which of these are documented and which are folklore?
15. **The pros and cons, honestly stated.** What is gained (purse, ranking,
    career) and what is permanently lost (amateur eligibility, Olympic
    pathway, funding, the ability to go back). J2 D5 says the door is one-way;
    say what walking through it COSTS in each discipline.
16. Is there a typical amateur record or age at which the decision is made,
    and is any of that published, or is it UNKNOWN?
17. **Who decides?** The fighter, the coach, the gym, a manager, a promoter?
    Describe the real conversation. The game has a gym, a head coach, a desk
    and a fighter with `FighterRequests` — say which real role each maps to,
    and who in reality holds the veto.
18. **Design: what should the game put in front of the player?** Price at
    least three options — (i) a one-off decision modal at a trigger, (ii) a
    standing choice on the athlete the player can flip with consequences,
    (iii) keep it a consequence of signing or taking a paid bout as today, but
    warn first. Note that today it is silent: `_turn_pro` fires from
    `accept_signing_offer` and from a paid bout, and the player is never asked.
    **Recommend one.**

### E. The shape of the whole thing

19. Draw the realistic path end to end for THREE contrasting careers — a
    childhood-entry boxer, an adult-entry BJJ player, a wrestler who crosses
    to MMA — as a timeline of ages, grades, records, decisions and money. Mark
    every point that the game currently cannot represent.
20. Of everything above, **what is the ONE change that would most improve the
    game per unit of engineering?** One paragraph, with the seam it lands on.

## Owned files

Create only:

* `research/C55_THE_PATH.md` — the evidence record, one section per
  question, every claim carrying its link or the word UNKNOWN.
* `research/C55_DIGEST.md` — short: the decisions, the three
  recommendations (Q12, Q18, Q20), and an explicit non-decisions list.

Do NOT edit `HANDOFF.md`, any `.gd`, any `.json`, any test, or any C52/J2/U4
deliverable.

## Anchors, verified 2026-09-08 against `43f2f64`

`GameState.gd` is 12,900+ lines — **never open it whole.** Only these windows:

* `:821` — an athlete is created with `discipline` already set
* `:5499` — `_turn_pro(athlete, cause, career_week)`
* `:5619` — caller one, cause `promotion_contract`
* `:11705` — caller two, cause `paid_bout`

`EntityPathway.gd` is 282 lines, readable whole: `ends_amateur_eligibility`
at `:274`, `is_amateur` at `:196`, `pays_purse` at `:183`.
`WorldPopulation.gd` regional culture at `:553` and `:614`.

## The traps

**One.** C47, C49 and C54 all hit this: a published figure is usually one
person at one event, not a rate. Never turn one reported career timeline into
a typical one. "Most fighters turn pro at 22" needs a source or it is UNKNOWN.

**Two, specific to this task.** Question 12 and question 18 are DESIGN
questions and the temptation is to answer them from what would be fun. Price
them against the seams named above and say plainly which parts of your
recommendation are authored invention rather than findings — the same way C31
was cited as the reason the corner rule is authored. An invented mechanic
labelled as such is welcome; an invented mechanic presented as a finding is
not.

**Three.** Do not let area B collapse into area D. A discipline crossover and
turning professional are different events that happen to co-occur in the
wrestler-to-MMA case. Keep them separate throughout.

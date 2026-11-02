# C53 — The Belt Nobody Sanctions

**Decision date:** 2026-09-08
**Scope:** research only; no runtime or data changes.
**Subject:** the championship belt — a title one fighter carries and defends —
not a grade awarded by an instructor or certifying body.

## Decisions page

1. **Keep boxing unsanctioned for this stage.** The honest display is
   `no sanctioning body`. The empty `organization_id` on the twelve seeded
   boxing world titles is an intentional truth after R70, not a failed lookup.
2. **Do not add WBA, WBC, IBF, or WBO, including under aliases.** J3 D4 is a
   project boundary. Do not add a generated market association either; that is
   the exact false authority R70 removed.
3. **The only clean future replacement is a deliberately authored fictional
   sanctioning body** — working name `FightCamp Boxing Authority` — with
   published in-game ratings, mandatory-defence, approval, fee, vacancy and
   appeal rules. A name without those behaviours is not worth modelling.
4. A promoter-owned title may be added later only as a clearly labelled house
   championship, such as `FightCamp Boxing World Championship`; it is not a
   sanctioning-body world title and must not be put into the same semantic
   bucket.
5. Regional and national titles are a possible future middle layer, but the
   real bodies that award the cited examples are not nameable in this
   catalogue. An authored regional series would be a new title family, not a
   repair to the anonymous world belt.

## The local contract

`championship_rules.json` sets boxing's `belt_authority` to
`sanctioning_body`. Its note distinguishes a ratings-and-sanctioning authority
from a promoter, and says that the alphabet bodies are absent from the
catalogue. The same file says the belt-authority list is closed.

The permitted `WorldPopulation.gd` windows agree:

- `BELT_AUTHORITY_SANCTIONING_BODY` is the boxing value; the fallback table
  does not make a generated organization a sanctioning body.
- `belt_authority()` returns the discipline's authored authority, defaulting to
  `event` for an unlisted discipline.
- `sanctioning_organization_id()` returns `""` whenever the authority is not
  `promotion`. Its comment explicitly rejects letting a generated market
  association become boxing's authority.

R70 records the measured fresh-world result: twelve boxing belts remain and
  each has an empty `organization_id`. Event disciplines were retired; boxing
  was not. C46's Boxing boundary established the distinction between a
  sanctioning organization and a promoter under the Muhammad Ali Boxing Reform
  Act. Those local rulings are the starting facts, not hypotheses to be
  re-derived here.

## D1 — What a sanctioning body does

A promoter organizes, finances, markets and matches a card. A sanctioning body
owns or recognizes the title, ranks eligible boxers, decides which contest is a
title contest, controls the line of mandatory challengers, and can withdraw
recognition. The following is the gameplay-relevant difference.

| Power | Published rule or obligation | Discretion that remains | Game meaning |
|---|---|---|---|
| Publish ratings criteria and changes | U.S. law requires public ratings criteria, policies, general sanctioning-fee schedule, bylaws, appeal procedure and ratings officials. A top-ten rating change must be posted with an explanation within seven days. | A body can choose stricter criteria and its published method can still contain judgment. | A player can inspect why a boxer is ranked and when the next ratings update occurs. |
| Rate boxers | ABC guidance says ratings should use win/loss record, level of competition and activity, with explicit activity and ranked-opponent tests. | WBC's rules add result quality, significance, experience, amateur accomplishments, location, decisiveness, style and controversial losses; that is a mixed system, not a pure formula. | A rankings cycle is separate from the promoter's matchmaking choice. |
| Designate a mandatory challenger | WBC rules permit a final elimination, direct designation of a qualified challenger, or a unification route. The WBC expressly says the highest-rated boxer is not automatically mandatory. ABC recommends an elimination between the two highest-rated available boxers. | The body decides availability, can order a different route, and can remove mandatory status for loss, inactivity, testing or rule violations. | A named contender can acquire a protected title shot rather than merely being offered a fight. |
| Order and sanction the defence | WBC requires at least one mandatory defence per year unless it grants an exception. IBF uses an initial six-month obligation after acquisition in the cited rule set, then no more than nine months between mandatory defences. | Extensions, exceptions, the exact order and special circumstances are body decisions. | A title produces a deadline and a forced opponent, not only a champion label. |
| Approve or refuse a title matchup | The IBF championship contract says the title belongs to the IBF and that it may refuse to sanction a fight as its title contest. WBC rules require express approval for a mandatory defence and allow approval, denial or conditions in special cases. | The sanctioning body's approval is distinct from the local commission's safety and licensing approval. | A booked bout can be valid boxing but not a sanctioned title bout. |
| Strip or vacate recognition | IBF rules provide for withdrawal and vacancy when a champion fails the mandatory obligation or violates contract rules; an unsanctioned contest can also make the title vacant. WBC rules provide forfeiture for missed obligations unless an exception is granted. | The board can grant an exception, alter timing, or withdraw a challenger's status. | Refusing the order has a durable consequence: the belt becomes vacant or loses recognition. |
| Charge a sanctioning fee | The law requires the general schedule and event charges to be disclosed. The IBF rules require a championship-belt fee from the promoter; WBC publishes a boxer-fee rule and has documented case-specific exceptions. | Waivers, altered percentages and special decisions can be discretionary. | Sanctioning is an economic choice with a visible cost, not a free name stamp. |
| Hear ratings challenges | The statute requires a written explanation of the criteria, rating and rationale within seven days after a qualifying challenge; bodies publish their own appeal procedures. | The body still decides the appeal under its rules. | A boxer can challenge a ranking change and receive a traceable answer. |

Sources: [15 U.S.C. §6307c](https://uscode.house.gov/view.xhtml?req=%28title%3A15+section%3A6307c+edition%3Aprelim%29),
[15 U.S.C. §6307d](https://uscode.house.gov/view.xhtml?req=%28title%3A15+section%3A6307d+edition%3Aprelim%29),
[ABC objective ratings criteria](https://www.abcboxing.com/abc-ratings-criteria/),
[WBC Rules and Regulations](https://wbcboxing.com/en/download/wbc-rules-and-regulations/),
[IBF Championship Contest Rules, posted 2025](https://www.ibf-usba-boxing.com/wp-content/uploads/IBFChampionshipContestRules06_25.pdf),
and the [IBF official championship bout contract](https://www.ibf-usba-boxing.com/wp-content/uploads/IBFOfficialChampionshipBoutContract.pdf).

The key boundary is that the sanctioning body does not merely supply the
authority string. It creates an enforceable state machine around ratings,
eligibility, deadlines, approval, fees and vacancy.

## D2 — The mandatory challenger

There is no single worldwide mandatory-challenger algorithm. The citeable
mechanics are body-specific, but they share a useful shape:

1. **Eligibility begins with a published rating and availability.** ABC's
   recommendation is the two highest-rated available boxers. The IBF cited
   rules refer to the leading available contender designated by its
   Championships Chairman. “Available” must remain a real status with evidence
   such as activity, medical clearance and an existing obligation; it must not
   be guessed from rank alone.
2. **The body creates mandatory status.** Under the WBC rules, it may order a
   final elimination between two qualified contenders, designate a qualified
   challenger directly, or use a unification bout. The highest-rated boxer is
   explicitly not the mandatory solely because of that position.
3. **An eliminator earns the privilege; it is not the world title itself.** A
   semifinal elimination can feed a final elimination. The winner of the final
   elimination becomes the named mandatory challenger. A draw can produce a
   rematch or another board decision under the applicable rules.
4. **The champion gets a window.** The WBC rule set cited here requires at
   least one mandatory defence in a year and states that timing can be extended
   in the body's discretion. The IBF rule set gives a vacant-title winner six
   months for the first mandatory defence and then requires a mandatory defence
   at intervals of no more than nine months. These are examples of real body
   windows, not a universal boxing constant.
5. **Refusal or failure costs the title.** IBF Rule 4 provides for withdrawal
   of recognition and vacancy when a champion fails to fulfil the scheduled
   mandatory bout. The WBC rules say a champion who misses the required periods
   forfeits the title unless the WBC permits otherwise. A challenger can also
   lose mandatory status for inactivity, a loss before receiving the privilege,
   an adverse anti-doping finding or violation of a WBC order.

The WBC's published mandatory-status notices show the behaviour in practice:
it orders final eliminations, names mandatory challengers, grants voluntary
defences, and records cancellations or changes. The [WBC mandatory-status
page](https://wbcboxing.com/en/wbc-official-mandatory-status-updated-as-of-january-27th-2026/)
is evidence of decisions, not a claim that every body uses the same process.
The [WBC mandatory-defense convention notice](https://wbcboxing.com/en/wbc-convention-mandatories-session-tuesday-nov-16-2021/)
also describes semifinal and final eliminations for mandatory status.

### Minimum authored gameplay contract

If a future fictional body is built, its public rules must state, at minimum:

- which ratings snapshot and availability conditions qualify a contender;
- whether rank, a direct designation, or an eliminator creates mandatory status;
- the mandatory window and how medical or contractual exceptions are recorded;
- the negotiation or purse-bid step for the ordered fight;
- the champion's consequence for refusal or missed deadline;
- the challenger’s consequence for withdrawal or loss; and
- whether the eliminator is a separate non-title bout and how a draw resolves.

Until those rules exist, the empty authority is more honest than inventing a
mandatory challenger from the existing ranking points.

## D3 — Options, priced

The prices below are relative build costs, not invented monetary fees. A future
task would need its own authored economy and save contract.

| Option | Build cost | Honesty cost | Existing-save effect | Assessment |
|---|---|---|---|---|
| **Authored fictional sanctioning body** (`FightCamp Boxing Authority`, working name) | **High.** New named authority, published criteria, ratings cycle, mandatory state, eliminators, approval/refusal, fee schedule, appeals, vacancy and text-only reads. | **Low** if it is labelled fictional and its rules are actually implemented. **High** if it is only a name. | Do not backfill the twelve empty authorities: that would invent a sanctioning history. Existing belts can stay `no sanctioning body`; new titles and future title changes can opt in. | Best long-term replacement, but only if the whole D1/D2 behaviour is funded. |
| **Promoter-owned house title** | **Medium-low.** Existing promotion-owned belt machinery can carry a promotion title, but boxing must be explicitly separated from sanctioning-body titles and generated organizations must never become the owner. | **Medium.** Real precedent exists, but the label must say whose house championship it is, not imply a universal boxing crown or independent ratings authority. | Additive if new and promotion-scoped. Re-labelling existing anonymous world titles would be a retroactive fiction; leave them unsanctioned or create a new title family. | Good for a promotion's own card identity; it does not supply mandatory-challenger governance. |
| **Accept unsanctioned** and print `no sanctioning body` | **Low.** Text/read semantics only if the current belt mechanics remain valid. | **Lowest.** It says exactly what the catalogue and R70 migration establish. | No migration. The twelve empty rows remain valid and retain their champion, defence and history fields. | **Recommended now.** The product cost is anonymity, not a broken save or a false authority. |
| **Regional and national layer** | **High** for a useful ladder: title tiers, territory eligibility, promotion/authority ownership, contention and promotion between tiers, plus new history reads. | **Medium-high** unless the game clearly says it is an authored regional series. Real examples are awarded by real bodies that this catalogue policy does not permit to be added. | Additive if new title rows are separate. Existing world belts need no authority migration; do not silently convert them into regional titles. | Worth a later career-middle stage, not a patch for the world belt. |

### Real precedent for promoter-owned titles

The precedent is real but not equivalent to a sanctioning authority. Official
UFC material calls the `Zuffa Boxing World Championship` an inaugural Zuffa title
and describes Zuffa Boxing as the promotion. That supports a promotion-owned
house title. It does not establish independent ratings, mandatory defences,
appeals, or sanctioning control. The [official Zuffa Boxing 04 preview](https://kr.ufc.com/news/brandon-glanton-chasing-immortality-zuffa-boxing-04)
and [Zuffa Boxing 10 official results](https://www.ufc.com/news/zuffa-boxing-10-results)
show the promotion/title naming pattern.

The normal sanctioning-body boundary is also explicit in the [IBF contract](https://www.ibf-usba-boxing.com/wp-content/uploads/IBFOfficialChampionshipBoutContract.pdf):
the IBF title belongs to the IBF, while the promoter stages the bout. The
IBF's [2026 cruiserweight ruling](https://www.ibf-usba-boxing.com/ibf-cruiserweight-title-status/)
further records that an unsanctioned contest can vacate its title even when a
separate `Zuffa World Cruiserweight Championship` is present. That is exactly
why the two title families must not be merged.

### Real regional and national examples

The WBC's own affiliated-title catalogue names `NABF`, `USNBC`, `Continental
Americas`, `Continental Latino`, `Mediterranean`, `Youth` and other layers. Its
description says the NABF title is regional for Canada, the United States and
Mexico and can earn important places in world rankings; it describes
Continental Americas as a regional title. The [WBC affiliated titles page](https://wbcboxing.com/en/about-us-affiliated-titles/)
is good evidence for a layer beneath a world title.

The [British Boxing Board of Control 2025 rules](https://www.bbbofc.com/build/documents/Rules_and_Regulations_2025.pdf)
are evidence of a national `British Championship` rule set. These are real
regional/national authorities, but J3 D4 prevents adding their real names or
the alphabet bodies to this catalogue. A fictional regional series must be
named as authored, not dressed up as a real federation.

## D4 — Does the layered ladder exist?

**Partly, but not as one universal route.** Boxing has a citeable layered
ecosystem: youth and regional affiliated titles sit alongside world titles,
and national championships such as the British title are separately governed.
Those layers can create a believable career middle.

What the evidence does **not** establish is a general rule that every boxer
must pass through `novice → area → regional → national → world`, in that order,
with automatic promotion at each step. The ABC rating criteria describe
activity, record and level of competition; they do not impose that title ladder.
The WBC's affiliated titles show multiple routes and eligibility bands, not a
single universal queue.

Therefore:

- `novice` may be a game career state, but it must not be presented as a
  universally sanctioned boxing title;
- regional and national titles can be an authored career layer with explicit
  territory and eligibility rules;
- a world title should remain a separate championship belt, not a grade and not
  the automatic reward for clearing a fixed real-world ladder; and
- the future ladder should be described as an in-game authored pathway unless
  a later study supplies a narrower jurisdiction and authority.

The project should cite [J3 D4](J3_THE_DECISION_QUEUE.md) for the existing
catalogue boundary rather than reopen or reinterpret it.

## D5 — Ratings and `ranking_mode`

For a real-world boxing authority represented faithfully, the safest value is
**`mixed`**. The WBC publishes thresholds and factors, but its rules include
qualitative factors and board discretion; its own rules say a top-rated boxer
is not automatically mandatory. That is not a deterministic published formula.

There is, however, a sufficiently specific implementable foundation. The ABC
criteria say ratings must use win/loss records, level of competition and
activity; they specify a minimum bout history for a top rating, twelve-month
activity, an eighteen-month ranked-opponent test, and movement after wins or
losses. Those are implementable rules, though the ABC page also allows a
sanctioning organization to be stricter and is guidance rather than this
project's title authority.

For the future fictional body, the choice is:

- set `ranking_mode: published_criteria` only if the body adopts an explicit
  formula/ordered tie-breaks and the game records each input; or
- set `ranking_mode: mixed` if a ratings board may apply qualitative review or
  exceptions.

Do not use `discretionary` merely because the promoter wants a convenient
matchup. That describes matchmaking, not a boxing ratings authority.

Evidence: [ABC ratings criteria](https://www.abcboxing.com/abc-ratings-criteria/)
and [WBC Rules and Regulations, ratings section](https://wbcboxing.com/en/descarga/reglas-y-regulaciones-5/?refresh=69824908ea7561770146056&wpdmdl=2535).

## D6 — What breaks if we do nothing?

Very little of the existing title object breaks. R70 deliberately leaves the
twelve boxing belts in place with `organization_id: ""`; the belt can remain
the championship somebody carries and defends. A no-op therefore avoids a
save migration, avoids retroactively inventing a sanctioning history, and
keeps the alphabet-body boundary intact.

The concrete product costs are:

- a player cannot see a sanctioning-body name on the first and most-used
  championship;
- there is no named authority to publish boxing rankings, order a mandatory
  challenger, approve/refuse a title matchup, charge a title fee, or withdraw
  recognition; and
- the game cannot honestly present an authority-driven boxing storyline until
  it authors one.

Those costs are real but bounded. Leaving the title unsanctioned is not the
same as deleting the title, assigning it to a generated association, or
claiming a real organization owns it.

## Build order if a future stage funds the recommendation

1. Keep current empty authorities readable as `no sanctioning body` and do
   not rewrite the twelve existing title histories.
2. Author the fictional body's text rules first: ratings inputs and cycle,
   eligibility, mandatory designation, eliminators, windows, exceptions,
   approval/refusal, fee schedule, appeals and vacancy.
3. Add the authority as an explicitly fictional catalogue entity, never by
   aliasing a real alphabet body and never by allowing generated market
   associations to qualify.
4. Scope new authority-owned belts by discipline, weight class and same-sex
   division. Keep a promoter-owned house title as a distinct type if it is
   also built.
5. Add the mandatory-challenger lifecycle: named contender, deadline,
   negotiation/booking state, refusal consequence, and challenger replacement.
6. Add the ratings read and a visible update cycle. Use
   `published_criteria` only after the rules are deterministic enough to run;
   otherwise use `mixed` and expose the discretionary step.
7. If the regional layer is approved, add it after world-authority behaviour
   is stable. It is a separate title family with territory and progression
   rules, not a migration of the current world belts.

## D7 — Explicit non-decisions

- No WBA, WBC, IBF or WBO catalogue entry, alias, thin wrapper or logo.
- No generated market association as boxing's authority.
- No decision that a promoter-owned `Zuffa Boxing`-style title is a universal
  boxing championship or a sanctioning body.
- No real WBC affiliate, BBBofC, EBU, NABF, USNBC or other regional/national
  body's name added to the catalogue under a new justification.
- No claim that novice, area, regional, national and world are one mandatory
  universal ladder.
- No grade, belt-colour, instructor award or tournament-medal model in this
  task. Those are grades or events, not the championship belt being studied.
- No invented numeric fee, window, ranking weight or UNKNOWN value. Unknown
  mechanics remain UNKNOWN until a source or an authored rule exists.
- No retroactive sanctioning stamp on the twelve existing empty-authority
  belts.
- No belt artwork, logos or brand imagery; this remains text-only research.
- No code, JSON, tests, save migration or UI implementation in C53.

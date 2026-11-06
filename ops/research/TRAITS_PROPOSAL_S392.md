# Fighter traits: a proposal for C238 (S392, 2026-11-06, version 3, proposal, nothing built)

His comment on the offer rows: "very little information is displayed on the fighters here, the rpg elements needs to show more often and maybe add more if it can make each playthrough random and unique". Board Q-S294-104: "Yes, propose".

**STATUS: NOT READY, 5/10, under the bar of 7. Do not build from this version.** Blind critics: version 1 scored 5/10 (ten traits no model could hold), version 2 scored 4/10 (new tells that could not punish a wrong plan), version 3 scored 5/10.

What version 3's critic found, read from the code, nothing run:
- **The table below is misread.** The probe's "wrong" plan is not truly wrong: `3b-3` is ok against press and best against range, tiring and hurt, and -2.1 is about one standard error. "A wrong plan is nearly free" is NOT established. The bible says -4.
- **TellEdge as written cannot be built.** `PlanFile.rows` is not the ring's answer (it blanks unfound tells and picks on another card), `plan_edge` and `FilmEdge` already pay the same label, and no data names a tell's mistake. Paying on unfound tells breaks `BoutRead`'s rule that a hidden tell moves nothing.
- **Breaks when pressed fails:** it re-triggers itself, `d` has no hurt term, and it rewards whoever is already winning.
- **The free tell informs no choice:** an offer is one bout plus a refused mismatch, and declining brings the same opponent back. There is no "offered three".
- **Our own fighters stay untouched,** though his comment asks for more RPG.

Next, in this order: 1. rerun the probe with a truly wrong arm and paired seeds; 2. replace the plus-and-minus E with a punish-only `mistake` move id on each tell row, so tells differ from style; 3. make offers a real choice between opponents, or the row has nothing to inform; 4. rewrite, judge again.

## What we measured
`tools/plan_effect_probe.gd`, 1,000 bouts, same boxer, one pressing opponent, on the merged footwork branch:

| Plan | Bouts won | Against no plan |
|---|---|---|
| None | 43.3 % | - |
| Good | 56.8 % | +13.5 |
| Wrong | 41.2 % | **-2.1** |

A right plan pays. A wrong plan is nearly free. That is the actual hole: scouting an opponent's tell has almost no downside if you ignore it, so traits on that opponent would be flavour however many we add. This is one matchup, so step 0 repeats it across styles.

## What the code says
- The row in his screenshot shows opponents. An opponent is a `rating` plus `threat` and `weak` (`Data.gd:60`), identical every career.
- `OppFile` and `PlanFile` already turn a tell into a situation, a round and a rated plan line. Tape needs a booked camp (`Bouts.gd:267`), so at offer time the row only says "File: 0 of 3 found" (`OfferCard.gd:73`).
- Only three weakness words change the ring (`Exchanges.gd:189,191,197`); "legs late" and "gives away round 1" are rated but not played.
- The exchange's power is one sum, `d`, in `LiveRound.gd:226-261`. An opponent's mode changes which answer scores, but no term says "you walked into her tell".
- Offers read `c.rival(name)` (`Bouts.gd:120`), which is saved with the career. Lucy and the five prospects are fixed.

## The proposal
**1. Make the wrong plan cost (TellEdge).** One new term in `d`. When the fight is in the situation a found or unfound tell names, and the plan's arrow fits it, add E. When the arrow is the tell's named mistake, subtract E. `PlanFile.rows` already computes that fit for the board; the bout uses the same answer, so what the board promises is what the ring does. `BoutRead` and `FilmEdge` include it, or WIN CHANCE goes stale. The fight line says so, so the Why panel can name it: "Walked into the right hand over the jab".

**2. Deal the opponents once.** At career start, write `threat`, `weak` and habits onto `c.rivals` from `c.seed`, picking from values that fit the style, with no shared weakness inside a division's offered three. Dealing into saved data keeps rematches stable and old saves untouched. Any `weak` we deal must be one the ring plays, so "legs late" and "gives away round 1" get played or dropped.

**3. Show one tell free on the row.** Each offer row shows one dealt tell at no cost: the word around the gyms. The rest show as locked slots. The offer decision now has a reason in it: "Fades after round 2, 2 unknown", and the first rows of two careers differ. The same chips appear on the bout page, fight prep and tale of the tape. Stars do not: opponents have no potential.

**4. One new tell, only if 1 passes.** Breaks when pressed: while we are on push pace and win 2 exchanges running, she plays `hurt` for one exchange. The trigger needs push pace, so a plan that boxes at range never sets it off, and push's 1.35x gas is the real price. Pace is in the plan's ROUND row. Body-shy, Late surge and Quick read are dropped: aim is not in the plan, no quiet mode exists, and no opponent reads our plan.

**5. Then the prospects.** Dealt from `c.seed`: authored name and face, class, a written personality pair from a table of pairs that read differently, and a habit, so `FighterProfile`'s fallback never brings the S375 repeat back. Stats stay in class bands.

## Out of scope
New body traits for our fighters, cuts, BJJ (its own tells follow), a lifetime damage clock, any Blood & Canvas value.

## How we would know
- **Step 0:** rerun the probe across all six styles, and add a universal plan (one safe plan used against everyone).
- **Wrong plan costs:** with TellEdge, a wrong plan loses at least 6 points against no plan, in every style, 1,000+ paired bouts. Good stays at +10 to +16: E must not simply inflate plans.
- **Tell-specific:** the answer to tell A used against tell B earns nothing, and a universal plan trails a tell-reading plan by at least 5 points. If a universal plan wins, the design has failed.
- **Careers differ:** blind readers given the first offers of two careers tell them apart and say the plan would differ, 8 of 10 pairs.
- **The row:** a blind reviewer scores it 8 beside a reference game (the bible's screen bar).
- **The hook:** the bible's own test. Strangers can say why they won or lost. The Why line goes in that test.

## Cost and risk
- Touches `LiveRound`, `BoutRead`, `FilmEdge`, `PlanFile`, `Exchanges.next_mode`, `Career`, `OfferCard`. Tests naming fixed tells need a seed that deals authored values.
- Balance: E moves every bout. The balance harness and goldens get rerun, and wins will drop for careless players. That is the point, but the first hour must stay survivable: the first opponents deal easy tells, and a free tell helps.
- Every dealt value needs words and a `WEAKNESS_ANSWERS` row.

## Order, once approved
0. Measure across styles.
1. TellEdge alone, measured. Stop and rethink if the bars fail.
2. Deal the opponents, free tell, row chips, through a blind reviewer.
3. Breaks when pressed.
4. Deal the prospects.

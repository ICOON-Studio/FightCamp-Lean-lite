# G138 - Where a Unified-Rules MMA fight spends its time

**Owner:** Grok (Expert, grok.com/c/6be161ae-a9fd-4cbb-8f85-7f0f10a2128e) | collected by Claude S102, 2026-09-27, verbatim.
UFC / FightMetric / Fightnomics baseline. Grades: S sourced · P proxy · J judgement. Grok cited 105 sources in-chat.

## 1. Stance time-share

Modern UFC (post-~2010), FightMetric TIP via Kuhn:

| Phase | Share of fight clock | Notes | Grade |
|---|---|---|---|
| Distance (open standing) | ~50% (2013); rising after | Hovered ~50% by early 2010s; later charts put ground under 25% | S |
| Clinch (any standing grip) | ~15-18% | 16% (2001) -> 18% (2013). Smaller 25' cage adds +2.3 pp, almost all fence control | S |
| Ground (any knee/hip down) | ~25-32% | 58% (2002) -> ~1/3 (2013) -> <1/4 by 2018 | S |
| Of clinch, vs cage | majority (~70-85%) | "Virtually all" extra small-cage clinch is fence pin | P |

Per 5:00: ~2:30 distance / ~0:50 clinch / ~1:20-1:40 ground. Ground with control = 38.1% of clock (1:54 / 5:00) in a 2014 FightMetric cut - that is top-control, not "someone on a knee." (Bloodyelbow)

Weight / sex. Heavier = shorter bouts, more KO, lower takedown density. Lighter historically more ground. Women: far more decisions (straw ~67%, fly ~64% vs HW ~33%), fewer KDs; standing share likely higher. No public women's TIP table. (Fightalpha)

Light-division 91-bout UFC slice (FLW/BW/FTW): stand 49.6 / clinch 13.4 / ground 36.2; cage embedded in those phases = 20.9% of clock. P for lighter classes only. (Cambridge)

**Sim prior (J): Distance 52 / Clinch 16 (of which fence 12, open 4) / Ground 28. Women +4-6 pp distance, -4-6 pp ground.**

## 2. Ground, by seat

No public UFC second-by-second split for NS / KoB / crucifix / butterfly / legs. FightMetric records guard / half / mount / back / misc internally (Sportradar fields exist); league averages unpublished.

Kuhn: most of the remaining third is full guard or hovering; half / side / mount are "increasingly hard to achieve and held less." BE 2014 judge-value ladder (same data family): guard < half ~ side < mount ~ back. Extra idle time helps submissions from half/side/mount, not from back (RNC attempt rate already high).

LW division average: ~17% of total fight time is one fighter's ground control (Khabib 41%). Top ~ control; bottom ~ ground - control. (ESPN)

Working split of ground time (J, anchored on Kuhn + hierarchy):

| Seat | % of ground | % of whole fight |
|---|---|---|
| Guard (closed/open) | 40-50 | 11-14 |
| Half | 20-25 | 6-7 |
| Side | 10-15 | 3-4 |
| Mount | 8-12 | 2-3 |
| Back | 8-12 | 2-3 |
| Turtle / NS / KoB / crucifix / legs / scramble | 5-10 | 1-3 |

Top:bottom on ground ~ 2:1 to 3:1 in a typical control-heavy bout; closer to 1:1 in guard-heavy striking wars.

## 3. Event rates (per fight)

| Event | Rate | Grade |
|---|---|---|
| Knockdowns | 0.41-0.52 / fight by division; ~0.52 overall. ~35% of fights have >=1 KD (2,930 / 8,337). Clinch KDs <1/5 of distance KDs. 1 KD / ~10 min of distance time | S |
| One-down, one-standing (upkicks / stand-over) | No TIP code. Follows almost every standing KD + some stuffed shots. Usually seconds-~20 s then join-down, wall-walk, or ref stand | J |
| Wall-walk / cage stand-up | Unpublished. Standard after fence TD | J |
| Front headlock / turtle after failed shot | Primary wrestling residue of a stuffed shot. High event rate (see §4) | P |
| Standing back-take | Rare vs back-take from turtle/ground | J |
| Thai plum as a held seat | Small slice of clinch. MMA clinch is over-under / body-lock / single-collar / fence pin | J |
| Leg-lock attempts | Minority of UFC subs (RNC / guillotine / arm-triangle / armbar dominate). Low time share | P |

Takedowns: 1.5 attempts / 5:00, 39% land (UFC since 2008). ~1.2 landed/fight men, ~0.9 women. ~61% of shots fail.

## 4. Stuffed-shot destinations

No published FightMetric transition matrix. Rates below are J/P from wrestling-MMA charting practice, conditioned on a failed attempt (~61% of shots):

| Destination | Share of stuffed shots | Why |
|---|---|---|
| Reset to distance | 25-35% | Early sprawl, hips clear |
| Clinch on cage | 25-35% | Drive continues into fence - the modal UFC shot |
| Front headlock (sprawler on top) | 15-25% | Crossface -> snap after sprawl |
| Turtle | 10-15% | Shooter curls; often from front headlock |
| Guard pulled / shooter on bottom | 5-10% | Late/poor finish, or defender sits |
| Standing back | <5% | Needs spin-behind, not a sprawl |

## 5. Fouls (per 100 bouts)

| Foul / result | Per 100 | Grade |
|---|---|---|
| Eye poke (any recorded) | 7-8 fights; UFC PI ~1 per 14. 36 pokes / 397 UFC+Bellator+PFL (H1 2022). Pause 36-50 s. 7 UFC NCs from eye poke 2005-Oct 2019 | S |
| Groin strike | No league rate. Warnings common; deductions rare. 2024: 2 of 5 listed point fouls were groin | P |
| Fence grab | Warnings common; deducted point rare | P |
| Point deduction (any) | 1.60 fights (120 / 7,491 UFC, 2010-2026) | S |
| DQ | 0.26 (23 / 8,954) | S |
| No contest | 0.87 (78 / 8,940). Combined NC+DQ ~1.3 | S |

Fouls are frequent; scored fouls are not. Do not weight DQ/NC as gameplay states - weight the pause and the rare point.

## 6. Build these three missing states first

1. **Fence clinch / cage pin** (split from open clinch). Largest missing time - most of the 15-18% clinch, plus the wall-walk recovery off a TD. Scores rounds; feeds the next takedown.
2. **One-down / one-up** (KD residue, upkicks, stand-over, wall-walk). Modest clock share, highest finish leverage of anything not already in the engine. ~1 KD every other fight; 63.5% of fights with a KD end KO/TKO.
3. **Front headlock + turtle** (stuffed-shot residue). Highest event rate among missing seats - majority of 1.5 shots / 5:00 fail, and this is where they go. Feeds guillotine, back-take, and ref stand-up.

Defer: NS, KoB, crucifix, butterfly, leg entanglements, Thai plum as its own seat, standing-back as a lasting state, foul state machines beyond a pause + rare point.

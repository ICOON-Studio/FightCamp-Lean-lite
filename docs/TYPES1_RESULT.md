# TYPES1 - the owner's four card types (Attack / Counter / Feint / Defend) measured on Puncher's chance (S571)

Task: ops/research/TASK_TYPES1.md (console worker, rules of ops/research/WORKER_S566.md). The page was not changed: every
version is a tweak file (src patches only) on order.html's rules, read through rules.mjs / balance.mjs.

## The answer in four lines
- **None of the versions passes the one-rep trial gate.** T1 and T2 (as the brief wrote them) and one repair of my own (T3)
  all fall into the same game: **Feint and Defend make up 75-88% of the plans, more than half the beats have no punch, and
  knockdowns drop from 2.3 a bout to 0.0-0.6.**
- The reason is the rule the brief named as the risk: a Defend that stops every Attack and ties everything else gives a
  man a safe beat. Against a Defender a Feint, or a plain step in, is just as safe, so neither man has a reason to punch.
- **It makes the feint loop worse, not better.** The feint-then-overhand-then-clinch loop wins 35 / 53 / 37% today
  (Jabber / Slugger / Body Snatcher). Under T1 it wins 72 / 92 / 67%, and under T3 37 / 72 / 57%. Feint-then-punch is now
  a FEINT card, and a Feint card beats the counters the solved mix throws.
- The full runs (each version's own look-ahead table, n=56 on seeds 1 and 2) were **not run**: the brief's own gate says the
  trial comes first, and all three versions failed it on structure, not on noise.

**For the owner, in plain words: as written, the four types make the safest card the best card. You would cover up or fake
nearly every beat and few punches would land. The triangle needs a cost on Defend before it is worth playing. Ideas for
that are at the end.**

## What was built (tweak files)
How a plan gets its type each beat (both plans are known once the beat is resolved):
- **Counter (C)**: his first punch comes in a later moment than the other man's first commit (a punch, a feint or a step
  in), or in the same moment as the other man's step in.
- **Attack (A)**: any other plan that throws a punch.
- **Feint (F)**: a feint before any punch, or a step in with no punch.
- **Defend (D)**: no punch and no feint, both hands home, staying put (not on the ropes) or backing off.
- **None**: a clinch, a push off on its own, or holding his ground on the ropes.

| File | What it does |
|---|---|
| types1_t0.json | **T0, the control.** Today's rules, with the types only labelled (N.tyOff). Checked: a 3-bout run is line for line the same as the page's. |
| types1_t1.json | **T1.** The triangle is settled first: Attack beats Feint, Feint beats Counter, Counter beats Attack. The loser of the triangle lands nothing. If Attack beats Feint, the feint also draws nothing. A winning Counter gets +N.counter. If Feint beats Counter, the feinter gets +1 stamina and the counter-puncher loses 2. Nothing lands on a Defender. Defend gives +1 stamina, and one ropes mark when he stands still (backing off already gives ground). Today's range and guard rules then size whatever is left. |
| types1_t2.json | **T2.** T1 plus the reads (N.ty2): a Counter beats only an Attack whose first punch reaches at that moment's range, and the same Feint two beats running loses its win over Counter. |
| types1_t3.json | **T3, my addition after T1 and T2 failed.** T2, but Defend blocks **most** rather than all (the owner's own words: "blocks all or most damage"). It stops only his first punch of the beat; a second punch meets today's guard, so a combination breaks the cover. |

"Feint won: +1 stamina **or** +1 to the next Attack": I chose +1 stamina, because the look-ahead table has no slot for a
next-Attack bonus.

## The trials (n=12, seed 1, jobs=1, the page's own look-ahead table; results/types1_*_trial.txt)
| | T0 today | T1 | T2 | T3 |
|---|---|---|---|---|
| Bars passed (of 9) | 6 | 4 | 4 | 4 |
| Stoppages / knockdowns a bout | 0% / 2.3 | 0% / 0.1 | 0% / 0.0 | 0% / 0.6 |
| Draws | 17% | 25% | 8% | 17% |
| Plans with no punch | 14% | 56% | 54% | 50% |
| Two punches | 20% | 2% | 4% | 10% |
| Health dealt a bout (both men) | 43.3 | 22.3 | 20.6 | 26.3 |
| Mirror fair (40-60%) | 50% | 22% | 36% | 20% |
| Top switches | back off 35, step in 31, cross 27 | step in 37, **feint 34**, back off 28 | step in 34, back off 32, feint 25 | step in 35, back off 29, feint 25 |
| Dead switches | feint 3% | jab, body jab, lead hook, lead uppercut, body hook, rear uppercut, clinch | jab, the three lead power punches, rear uppercut, clinch | lead hook, lead uppercut, body hook |
| On the ropes (2 marks), share of beats per man | 9% | 20% | 20% | 19% |
| **Types picked A / C / F / D** | 45 / 37 / 3 / 13% | 6 / 5 / **49 / 39%** | 15 / 7 / **36 / 41%** | 14 / 11 / **39 / 35%** |
| Commonest matchups | AvA 25, CvC 25, AvC 21% | **DvF 31, FvF 27, DvD 20%** | DvF 28, AvD 22, DvD 16% | DvF 26, FvF 18, AvD 17% |
| Counter loses its beat | (labels) 4% | 91% | 30% | 30% |

Gate (the brief): no switch over 40% and stoppages 5-50%. **Every version fails it on stoppages (0%).** One caveat: today's
page also showed 0% stoppages on this 12-bout trial (the bar needs n=56 to read well), so stoppages alone would not prove
much. The verdict rests on the numbers beside it. Knockdowns fall from 2.3 to 0.0-0.6, half the plans throw nothing, and
Feint plus Defend take 75-88% of the plans where today they take 16%. That is the change the rules made, and a bigger
sample would not undo it. **The brief's stop rule, "T1's plan mix equals T0's", did not fire: T1's mix is far from T0's,
just the wrong way.**

The control's labels show what today's solved play already does: it is mostly Attack v Attack, Counter v Counter and
Attack v Counter (71% of beats). Feint is 3%.

## The feint loop (probe_clinch.mjs n=60; results/types1_*_loop.txt)
The fixed loop player: step in, feint, overhand (or cross), and clinch when Inside, against the page's three opponents.
| | Jabber | Slugger | Body Snatcher | bar |
|---|---|---|---|---|
| T0 today (the red test) | 35% | 53% | 37% | under 30% |
| T1 | **72%** | **92%** | **67%** | |
| T3 | 37% | 72% | 57% | |
The T0 loop matches COUNTERS2's figure for today's page exactly (35/53/37). T2 was not run: the background run was stopped
by Claude Code for low memory while ArcheAge was open. T3's file is complete for the loop rows; it is missing only the
last control row (no clinch v the Body Snatcher). Note that probe_clinch reads the page's look-ahead table, not a
version's own; the opponents play the version's rules beat by beat.

## Why it fails, and what would have to change
1. **Defend has no cost that bites inside a beat.** +1 stamina and a ropes mark come back as soon as he steps in, and the
   judges see "gave ground" only on level rounds. In real boxing a man who covers up is still hit, to the body and around
   the gloves, and he loses the round. Defend has to let damage through (to the body, or every punch after the first, as
   T3 does) **and** lose points, for example a passivity point to the other man when he defends two beats running.
2. **Feint and the empty step are free against Defend.** If they tie, the safest pair of cards ends every beat level.
   Feint against Defend should cost the feinter, for example by letting the Defender recover more.
3. **Typing feint-then-punch as Feint protects the loop.** The plan the owner wanted capped is now the card that beats
   counters. A plan that feints and then punches should be an Attack from the moment it punches, so a Counter can answer it.
4. Counters lose 91% of their triangle beats in T1, because almost everything they meet is a Feint. T2's read rule (a
   repeated feint loses) helps: 30%.

These are design changes, not number tweaks. Under the depth rule (probe first, then critics) they would be a new round
(TYPES2). No version goes to the critics from this one.

## Files
- Rules: ops/research/s558_balance/types1_t0.json, types1_t1.json, types1_t2.json, types1_t3.json.
- Results: ops/research/s558_balance/results/types1_t0_trial.txt, types1_t1_trial.txt, types1_t2_trial.txt,
  types1_t3_trial.txt, types1_t0_loop.txt, types1_t1_loop.txt, types1_t3_loop.txt.
- The counting script (bars, comeback, types) is E:/FightCamp/wt_tmp/TYPES1/measure.mjs, outside the repo because the brief
  owns no script path. It imports balance.mjs and probe_punch_chance.mjs.
- Regression: the page is unchanged, so rules_test is unaffected (no page or rule file edited).
- All runs used jobs=1, one at a time, and waited while the watchdog was RED or RAM was 88% or more. ArcheAge was open for
  most of the session.

## Decisions I took without asking
- I typed a plan by both men's plans together, because the brief defines Counter by the other man's commit.
- I gave Feint the +1 stamina rather than "+1 to the next Attack", because the look-ahead table cannot see the second one.
- I added T3 once T1 and T2 failed, staying inside the owner's own words ("most damage").
- I did not build the versions' own tables or run n=56, because the trial gate failed on structure.

TYPES1 DONE

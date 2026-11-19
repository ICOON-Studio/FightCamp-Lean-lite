# KNOWLEDGE scope (S525) - does knowing a boxer pay in today's world?

Rule: CLAUDE.md item 8 (findings drive the queue). Mechanic: PROGRESSIVE KNOWLEDGE v3 (approved Q-S294-228).
Design: `DESIGN_KNOWLEDGE_V3_REVISE_KALLI_KALLI.md`. Built: Knowledge.gd + KnowReads.gd (Goose #378), KnowWire step 2 (S524).

## The finding (docs/KNOWBOTS4_RESULT.md, Goose #379, seeds 7000/8000/9000 x 60 worlds x 4 years)
ORACLE (signs the highest TRUE rating, pays nothing) against BLIND (signs the best SHOWN centre, buys nothing):
top-10s 100/90, 101/92, 103/96; bout wins 1950/1930, 2005/2042, 2000/1957; final true rating +0.6%. No measure gives
ORACLE - BLIND >= 8% on every set: VOID. Two runs (S524 rerun, KNOWBOTS4) agree. So it is not the scoreboard (bout wins and
final rating are VOID too): in today's world, the perfect read of TODAY'S rating barely changes a career. A paid read can
never earn more than ORACLE's edge, so v3's prices cannot pay whatever they cost.

## Why it may be (unmeasured - KNOWBOTS5 measures these first)
1. ORACLE reads the wrong truth. It signs on today's rating; over 4 years the training clamp
   `clamp((potential - stat) / 25, 0.10, 1.25)` may make POTENTIAL (and age) decide where a boxer ends, not the start.
2. The pool is flat. If the walk-ins' true ratings sit within a few points of each other, any pick is about as good.
3. The shown centre is already near the truth (hype offset 2-8 only on Hyped prospects), so BLIND is almost ORACLE.

## Plan (phases, in order; nothing of knowledge step 3 - bands on the week review - is built until phase 2 decides)
1. KNOWBOTS5 (probe, Goose): print the pool (true rating spread, potential spread, shown-centre error per prospect) and
   add ORACLE-POT (signs the highest potential) and ORACLE-BOTH (rating + potential, the 4-year projection of the
   training clamp). Measure every bot on bout wins and final true rating. Brief: TASK_KNOWBOTS5.md.
2. Decide from it (Claude):
   - ORACLE-POT or ORACLE-BOTH beats BLIND by 8%+ -> the reads must reveal POTENTIAL (what a boxer will become), not
     today's numbers. Revise v3 (Kalli) so Look closer / Trial / Test day narrow potential; rerun K1.
   - All oracles VOID -> the world gives the pick no stakes. Design levers (Kalli, two critics, his board): a wider walk-in
     spread, hidden flaws that decide bouts (chin, cuts, temperament), the costs of a wrong signing (stipend, the boxer's
     ambition leaving). Pick one, probe it, then rerun K1.
3. Only after K1 passes: knowledge step 3 (bands on the week review) per the design's section 14.

## Until then
KnowWire step 2 stays (it counts what we see; nothing shown). No new knowledge screen, no price tuning.

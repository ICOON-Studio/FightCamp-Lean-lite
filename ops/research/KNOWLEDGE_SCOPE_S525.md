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

## Phase 2 decision (S526, Claude, from docs/KNOWBOTS5_RESULT.md)
Pool not flat (rating spread best-median 20, best-worst 30.5). ORACLE vs BLIND top-10s +11.1 / +9.8 / +7.3% (VOID by a
hair); ORACLE-POT and ORACLE-BOTH LOSE to BLIND (to -18.8%): potential is not the missing truth - no v3 revise toward
potential. Mean |shown - true| on the rating is 0.83: cause 3 holds. Why: Knowledge._offset is independent per attribute,
so ~20 errors cancel in the rating. A real first look misreads the whole kid. Next: KNOWBOTS6 (Goose, TASK_KNOWBOTS6.md)
adds a shared per-prospect misread (rho 0 / 0.5 / 0.8 / 1.0). A rho that passes 8% -> Knowledge gets the shared term
(a code change Claude makes, test red first), then K1 reruns. None passes -> the "no stakes" levers above go to Kalli.

## Until then
KnowWire step 2 stays (it counts what we see; nothing shown). No new knowledge screen, no price tuning.

## Phase 2 outcome (S527, Claude, from docs/KNOWBOTS6_RESULT.md)
KNOWBOTS6 (Goose #391): a shared per-prospect misread makes knowing a boxer pay. Smallest passing rho = 0.5: ORACLE beats
BLIND on top-10 finishes by 8.7 / 9.8 / 14.4% on the three seed sets (8% bar on every set). Mean |shown - true| on the rating
0.86 -> 1.77 (rho 0.5). Note: the probe's "control match" line is hard-coded true; at rho 0 its formula IS Knowledge's, so
the arm is the control by construction. BUILT: Knowledge.SHARED_MISREAD 0.5 (_offset = 0.5 x one per-prospect misread +
0.5 x the attribute's own; same hash as the probe, band unchanged so the truth stays inside every range);
tests/knowledge_shared_test.gd red before (correlation 0.00, rating off 0.84), green after with knowledge / keep / reads /
wire / golden_path. NEXT: K1 reruns on the real Knowledge (the potential readers / reads worth), then knowledge step 3.

## K1 rerun on the real Knowledge (S527, docs/KNOWBOTS7_K1_RESULT.md = tools/knowbots5_probe.gd after the shared misread)
ORACLE vs BLIND top-10s: +4.4 / +9.2 / +7.9% (KNOWBOTS5 before the change: +11.1 / +9.8 / +7.3). Shown rating error 0.83
-> 1.70, so the misread is real now, but the oracle's edge did NOT grow: KNOWBOTS6's +8.7 / +9.8 / +14.4 came from its own
probe-side formula and does not reproduce through the game's path; set-to-set swings of ~5 points on top-10 counts of ~90
are noise at 60 worlds a set. VERDICT: K1 still VOID. The shared misread STAYS (a first look misreads the whole kid; it
makes the reads' words honest, costs nothing), but it is not the lever. Per phase 2: the "no stakes" levers go to design
(Kalli is down, so Dola SQ, then two critics): a wider walk-in spread, hidden flaws that decide bouts (chin, cuts,
temperament), the cost of a wrong signing (stipend weeks, the boxer's ambition leaving). Brief: DESIGN_KNOW_STAKES1_DOLA.md.
A future probe needs 150+ worlds a set or a paired design (same world, both bots) before an 8% bar means anything.

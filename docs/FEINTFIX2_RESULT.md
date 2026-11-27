# FEINTFIX2 — feint answers measured against the page's bars

**Method.** Five versions of the same change (a JSON tweak of the rules above the page's
`// ---- the page` mark — `ops/research/s558_balance/feintfix2_g1.json`, `_g2`, `_g3`, `_g12`
(G1+G2), `_g13` (G1+G3)), each run in order: trial gate, its own table
(`vt_feintfix2/<v>.vt.json`), `play n=84` seeds 1 and 2, `probe_clinch` loop n=60,
`probe_clinch` opus play + feint-then-cross n=60, `probe_feint` counts n=84 ×2 seeds,
`scene_check feint_overhand` with the tweak. G0 (the page table, no tweak) measured the same
way on the same seeds; its loop file is byte-identical to the old `clinchx_base_loop.txt`
(the red test: loop 38/63/70, punch after a feint lands 88.9% pooled — inside 83–94%).
Every number below is quoted from `ops/research/s558_balance/results/feintfix2_*.txt`.

**What each version changes.** **G1** — in a beat where your lead hand feints, that hand
guards nothing in the moments before its feint (today it is "still up"); everything else is
unchanged. **G2** — a speed-3 punch (overhand, rear uppercut) that lands only because the feint
drew his hand does 2 less (never under 1); fast/medium punches unchanged. **G3** — if the other
man holds BOTH hands that beat (no punch, no feint, no push, feet free), the feint draws
nothing. **G12** = G1+G2, **G13** = G1+G3.

**Loop / opus / feint-cross / film are version-level** (one run each, on that version's own
table) and repeat in the seed rows. Bars are out of 9, G0's own count per seed: 7/9 (seed 1),
8/9 (seed 2). The red numbers after each bars cell are that seed's failing bar(s), verbatim.
Feint / overhand share = both men pooled (the floor bar runs on unrounded numbers, so a cell
can print 3% and still be the dead one). Landing = `probe_feint` FEINT_COUNTS pair, both men
pooled. Health a round = damage taken a bout × 84 ÷ rounds. Jab share = head-jab throws ÷
punches thrown (both men pooled). bothHeld = share of beats a man holds both hands (both men).

| version | seed | bars (red numbers) | loop J/S/B | opus J/S/B | feint-cross J/S/B | feint % | overhand % | landing after a feint | health a round | KD | stoppages % | jab % | Long % | bothHeld % | Hearns beat (film) |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| G0 (page) | 1 | **7/9** — push off 3%; Jab lands 70% (short 4%), Overhand 74% (short 16%) | 38/63/70 | 12/13/7 | 18/42/30 | 7.5 | 4.5 | 178/194 = 91.8% | 14.46 | 2.4 | 20 | 8.0 | 33 | 11.0 | lands −4, down ✓ (3/3) |
| G0 (page) | 2 | **8/9** — Jab lands 66%, Overhand 71% | (same run) | (same run) | (same run) | 7.0 | 4.5 | 160/186 = 86.0% | 14.40 | 2.4 | 21 | 7.0 | 32 | 11.7 | (same run) |
| G1 | 1 | **8/9** — Body jab lands 69%, Overhand 77% (short 16%) | 35/53/37 | 7/10/7 | 20/38/20 | 4.5 | 3.5 | 113/122 = 92.6% | 14.53 | 2.5 | 23 | 7.8 | 32 | 11.8 | lands −4, down ✓ (3/3) |
| G1 | 2 | **8/9** — Overhand lands 77% (short 13%) | (same) | (same) | (same) | 5.5 | 4.5 | 131/142 = 92.3% | 14.41 | 2.5 | 23 | 9.0 | 33 | 12.8 | (same) |
| G2 | 1 | **6/9** — Overhand 1%; Jab lands 65%, Body hook 67%; stoppages 23%, draws 4%, KD 2.5 | 32/53/50 | 12/15/7 | 17/47/28 | 5.5 | **1.0 dead** | 131/144 = 91.0% | 14.53 | 2.5 | 23 | 8.1 | 32 | 11.4 | lands −2, down ✗ (2/3) |
| G2 | 2 | **7/9** — Push off 3%, Overhand 1%; Jab lands 70% | (same) | (same) | (same) | 6.0 | **1.0 dead** | 149/162 = 92.0% | 14.35 | 2.4 | 27 | 7.7 | 34 | 12.0 | (same) |
| G3 | 1 | **8/9** — Overhand 3% (unrounded under the floor) | 30/43/42 | 12/17/7 | 7/17/18 | 3.0 | **dead** | 72/82 = 87.8% | 14.07 | 2.3 | 17 | 6.5 | 32 | 14.7 | **blocked** ✗ (1/3) |
| G3 | 2 | **7/9** — Jab lands 67%; mirror 62% | (same) | (same) | (same) | 3.0 | 3.0 | 69/90 = 76.7% | 14.09 | 2.3 | 19 | 7.5 | 30 | 14.2 | (same) |
| G12 | 1 | **7/9** — Overhand 1%; Jab lands 66% | 35/40/37 | 10/15/5 | 18/52/20 | 3.5 | **1.0 dead** | 90/94 = 95.7% | 14.20 | 2.3 | 15 | 7.1 | 31 | 12.4 | lands −2, down ✗ (2/3) |
| G12 | 2 | **6/9** — Overhand 1%; Jab lands 69%, Lead uppercut 71%; mirror 61% | (same) | (same) | (same) | 3.5 | **1.0 dead** | 94/98 = 95.9% | 14.50 | 2.3 | 23 | 8.0 | 32 | 10.7 | (same) |
| G13 | 1 | **7/9** — Feint 2%, Overhand 2%; Jab lands 69% | 25/45/33 | 5/5/3 | 10/22/15 | **1.5 dead** | **2.5 dead** | 31/44 = 70.5% | 13.94 | 2.2 | 18 | 7.3 | 32 | 13.2 | **blocked** ✗ (1/3) |
| G13 | 2 | **7/9** — Feint 2%, Overhand 2%; Jab lands 65% | (same) | (same) | (same) | **2.0 dead** | **2.0 dead** | 34/45 = 75.6% | 13.85 | 2.2 | 19 | 6.8 | 29 | 14.5 | (same) |

Health a round never fell under 90% of G0 (floor ≈ 13.0; lowest is 13.85). Knockdowns stayed
inside G0 ± 0.3 everywhere (2.2–2.5 vs 2.4). Stoppages: G1 23/23, G3 17/19, G12 15/23,
G13 18/19, all inside G0 ± 5 points; G2's own page bar already failed on that seed
("stoppages 23%, draws 4%, knockdowns 2.5" — the unrounded KD sits over the page's 2.5 cap).
Long stayed 29–34% (bar: under 45%). bothHeld never passed G0 + 10 points (worst +3.7, G3 seed 1).
Beats with no punch landed (feedback loop): G0 36.9/37.3%, G1 35.6/37.0, G2 35.9/36.0,
G3 37.9/37.7, G12 36.1/34.6, G13 37.0/39.1. Health after a feint-pair landed: G0 ≈ 3.6,
G1 ≈ 3.7, G3 ≈ 3.6, G13 ≈ 3.5–3.9; G2/G12 ≈ 3.0–3.2 (the −2, by design).

**The bar by bar.** Bars vs G0's own count: G1 8/9, 8/9 ≥ 7, 8 ✓; G2 6/9, 7/9 ✗;
G3 8/9 ✓, 7/9 ✗; G12 7/9 ✓, 6/9 ✗; G13 7/9 ✓, 7/9 ✗. Mirror never left 40–60% on a seed
G1/G2/G13 passed, but G3-s2 (62%) and G12-s2 (61%) lost it. Loop under 30%: nobody — G0 38,
G1 35, G2 32, G3 30 (equal is not under), G12 35, G13 25/45/33 (Slugger 33). Opus under 35%:
everybody (worst 17%). Feint-cross under 35%: only G3 (18) and G13 (22); G0 42, G1 38,
G2 47, G12 52. Feint ≥3% and overhand ≥3% both seeds: G0 ✓ and G1 ✓; G2, G12, G13 dead;
G3 dead on seed 1. Landing 45–75% both seeds: only G13 got near (70.5% seed 1) — every other
cell is 76.7–95.9%, and G13 seed 2 is 75.6%. Hearns's feint and overhand still land: G0, G1,
G2, G12 ✓; G3 and G13 blocked (G3's no-bite rule — Duran holds both hands and does not bite).

**Not versions, and why.** *"A lead feint never pulls the rear hand" (Dola's second answer) —*
not run: it removes the Hearns exchange itself — the whole point of the beat is that Hearns's
feint pulls Duran's rear hand open for the overhand. *"A 50% chance the hand still blocks"
(Dola's first answer) —* not run: it puts a die in a beat (randomness in the combat rules is
forbidden; a coin flip decides whether the drawn guard is really drawn).

**What failed, in one breath.** G1 never touched the landing bar (a feint-drawn guard cannot
be blocked while the feint is live — 92%) and its feint answers still beat the loop (35%) and
Slugger (38%). G2 poisoned its own overhand (share 1%) — the solver will not throw a −2 punch
— and the landing bar stayed at 91%. G3 moved the landing bar with the no-bite rule (87.8/76.7)
but killed the film (Hearns blocked), sat on the loop floor (30.0 is not under 30) and lost the
mirror on seed 2. G12 stacked every failure. G13 proved the 45–75% landing bar is reachable
(70.5% seed 1, 73.0% pooled) but did it by killing the feint outright (1.5–2% share) — the
overhand died with it and the film went with them.

**Which version goes on the page: none — no version passed all the bars.**
**What the player would see: the page as it is today — the lead guard still up before its own
feint, the drawn overhand still at full damage, a man holding both hands still pulling the
feint, the loop still beaten 38% by the Inside clinch.**
**What is still wrong: the landing bar cannot be moved without the no-bite rule, and the
no-bite rule kills the feint, the overhand and the Hearns film; the loop (≥30%) and
feint-cross (≥35% vs Slugger) bars hold under every feint change that leaves the feint alive;
and any damage cut on the feint-drawn punch drives the solver off the overhand entirely.**

FEINTFIX2 BLOCKED: no version passed all the bars — the landing-after-a-feint bar (45–75%)
and the no-bite rule that could reach it are a pair with the feint itself (G3/G13 lose the
film, G1/G2/G12 never move the landing), while the loop and feint-cross bars hold under
every change that leaves the feint alive.

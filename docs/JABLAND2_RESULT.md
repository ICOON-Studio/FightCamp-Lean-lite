# JABLAND2 — the overhand's feint opening (S564)

Task: `ops/research/TASK_JABLAND2.md`. Node only; no page, rules, balance tool or test changed. `node proto/twohands/tools/rules_test.mjs`: **37 passed**, before and after. The supplied tweaks were not changed.

## Method

D keeps the feint's overhand opening only at Inside. E wastes a feint when a punch lands in its own moment, adding one counter; F combines D and E. All three retain JABLAND1 c's jab guard and zero-stamina jab, with the overhand at 3 stamina.

For each version, first `balance.mjs play who=mix opp=mirror n=12 seed=1 jobs=2 tweak=<file>` on the page table, then `balance.mjs table tweak=<file> out=<version>.vt.json jobs=2` (default 500 iterations), then two `balance.mjs play who=mix opp=mirror n=84 seed=<1|2> jobs=2 tweak=<file> table=<version>.vt.json`. Each trial and each seed's result was committed and pushed as it finished. Tables are local only, not committed. Results and trial output are in `ops/research/s558_balance/results/jabland2_<d|e|f>[_s2].txt`.

For counts, `proto/twohands/tools/probe_feint.mjs` is a counting copy of the balance instrument, not a changed game or solver. It replayed each exact 84-bout seed, table and worker configuration. Each replay's entire normal report and bars matched its original run, apart from elapsed seconds; counts were appended and pushed individually. A pair is an **actually resolved** hit/block/miss in the moment immediately after an emitted feint by the same boxer, pooled across both men. A shot prevented by a clinch, knockdown or stun is not counted as thrown. `caught` counts an opponent's landed punch in the feint moment; `wasted` counts the specific E/F event text confirming cancellation. Blocked and short punches cannot waste a feint: the tweak's cancellation is in the hit path, after both checks.

## Main results

Bars in order: 1 every range, 2 no must, 3 no dead, 4 landing, 5 bout endings, 6 one/two/none, 7 clinch, 8 order, 9 mirror. P = pass, F = fail. Landing is pooled by throws from the instrument's bar lines, except overhand, which is **you / him** because it was too rare for the instrument's pooled bar. The latter two percentages have very small samples. Use is the individual beat share **you / him**, rounded by the instrument. The instrument excludes punches with fewer than one combined throw per bout from its landing bar; hence its passing landing bar does not establish that a dead overhand is acceptable.

| Version / seed | Bars | 1–9 | Jab | Body jab | Cross | Body cross | Overhand (you / him) | Lead hook | Body hook | Lead upper | Rear upper | Jab / overhand / feint use (you / him) | Back off / step in | Mirror | KD per bout / stoppages |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| D / 1 | 7 | PPFPFPPPP | 39% | 64% | 47% | 48% | 59% / 45% | 42% | 54% | 62% | 52% | 7% / 8%; 1% / 2%; 6% / 5% | 34% / 34% | 53% | 2.5+ / 19% |
| D / 2 | 7 | PPFPFPPPP | 42% | 60% | 49% | 48% | 31% / 52% | 42% | 63% | 61% | 50% | 8% / 8%; 1% / 2%; 6% / 6% | 35% / 33% | 50% | 2.6 / 27% |
| E / 1 | 8 | PPFPPPPPP | 42% | 58% | 39% | 46% | 57% / 73% | 40% | 57% | 60% | 58% | 8% / 8%; 2% / 2%; 2% / 1% | 34% / 33% | 49% | 2.4 / 20% |
| E / 2 | 8 | PPFPPPPPP | 38% | 60% | 41% | 47% | 50% / 61% | 37% | 60% | 57% | 55% | 9% / 10%; 2% / 2%; 1% / 2% | 34% / 34% | 48% | 2.3 / 23% |
| F / 1 | 7 | PPFFPPPPP | 34%* | 62%* | 38%* | 48%* | 37% / 56% | 38%* | **69%** | 62%* | 58%* | 9% / 9%; 2% / 2%; 2% / 1% | 35% / 33% | 59% | 2.5 / 21% |
| F / 2 | 7 | PPFPPPPPF | 38% | 60% | 44% | 48% | 64% / 27% | 45% | 64% | 62% | 55% | 8% / 10%; 1% / 1%; 2% / 2% | 33% / 34% | **63%** | 2.4 / 19% |

\* F seed 1's passing punch rates are approximate pooled values computed from rounded per-man lines; the failed body-hook rate comes from the exact bar line. D seed 1's 2.5+ rounds to 2.5 but exceeds the unrounded 2.5 limit and fails. Use percentages can round up to 3% while still failing the unrounded threshold; the dead-switch verdict uses the instrument's actual counts. Stoppages include both fighters; mirror is wins among decided bouts. Range shares were Inside 31–35%, Mid 37–38%, Long 28–31%; no must failed.

The n=12 trials were D 7/9 (overhand dead and landing failed), E 7/9 (feint, push and overhand dead and landing failed), F 6/9 (feint and overhand dead, landing and stoppage floor failed). Small trials were screening only, not substitutes for the solved-table seeds.

## Feint then next-moment punch

Cells are **thrown / landed** across both fighters, with — meaning zero / zero. These are actual shot events, whether or not the opening remained active; a wasted feint can still be followed by a punch. The overhand pair is not under 65% in any run, though samples are small.

| Version / seed | Cross | Rear uppercut | Overhand | Body cross | Overhand pair landing | Landed on feint / actually wasted, by punch |
|---|---|---|---|---|---|---|
| D / 1 | 122 / 108 | 12 / 11 | 12 / 9 | — | 75% | 23 / 0: body cross 7, body jab 3, cross 7, body hook 2, lead upper 4 |
| D / 2 | 147 / 137 | 11 / 9 | 8 / 6 | 2 / 2 | 75% | 46 / 0: lead upper 4, cross 19, body cross 11, body hook 6, body jab 3, rear upper 3 |
| E / 1 | 9 / 8 | 13 / 11 | 16 / 15 | 2 / 2 | 94% | 4 / 4: body cross 1, lead upper 2, body jab 1 |
| E / 2 | 13 / 12 | 10 / 9 | 15 / 14 | — | 93% | 4 / 4: lead upper 2, body hook 1, cross 1 |
| F / 1 | 25 / 24 | 10 / 8 | 6 / 5 | 3 / 3 | 83% | 3 / 3: body cross 1, body hook 1, cross 1 |
| F / 2 | 35 / 33 | 8 / 6 | 7 / 6 | 3 / 3 | 86% | 2 / 2: body jab 1, body cross 1 |

The free **head jab** caught zero feints in every run, including E despite its 8–10% per-man beat share. Body jabs are listed separately and caught one feint in E seed 1 and one in F seed 2. E/F's observed landed catches all wasted their feints; D records the same-moment hits for comparison but does not cancel feints. This observation does not imply a causal estimate: the solved mixes and actual feint frequencies change between versions.

## Feedback and verdict

Compared with D's 5–6% per-man feint use, E and F fall to 1–2%, below the 3% floor. E's 4 wasted feints per seed and F's 2–3 coincide with fewer opportunities, but even the surviving feint–overhand pairs land 83–94%. D's overhand is also dead despite live feints. Knockdowns are D 2.5+–2.6, E 2.3–2.4, F 2.4–2.5 per bout; stoppages are respectively 19–27%, 20–23%, and 19–21%, all above the 10% floor. Thus E meets the ending bar but its dead feint and overhand and very high pair landing prevent a solution. Relative to JABLAND1's base 2.4–2.6 knockdowns and 24–30% stoppages, these are modest changes, not proof that the intended feedback loop caused them.

**none: E is nearest**, with 8/9 on both seeds and the landing bar nominally passing, but the feint and overhand are dead (1–2% and 2% of beats), the overhand is omitted from that bar, and feint–overhand lands 15/16 and 14/15. Neither D nor F meets the combined conditions. Do not put any version on the page.

JABLAND2 DONE

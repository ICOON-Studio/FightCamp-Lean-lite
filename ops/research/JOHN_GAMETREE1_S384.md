# JOHN on GAMETREE1 (S384)

Seat: John Research (real-world numbers), operator's Grok bot, via Tools/gbot.py send/thread (Grok Bot gateway).
Asked: 5-8 short points checking the real-world numbers in ops/research/GAMETREE1_DESIGN_S384.md - right, wrong (real figure + source), one missing number.
Brief sent: design text minus sections 8, 9, 11, test lists 10.1/10.3/10.4 and appendix A (29,897 chars).
Reply received 2026-11-05, thread seq 598 (596-597 were status lines). Verbatim below; the only change: unreadable dash characters
(U+FFFD from the gateway, en dashes in ranges) written as '-'. Sources are John's; not yet re-checked by Claude.

---

1. **Clock and points are right.** IBJJF adult matches run white 5, blue 6, purple 7, brown 8 and black 10 minutes, in both gi and no-gi. Points are 2/2/2/3/4/4 with a 3-second hold, and ties go to advantages, then penalties, then the referee ([IBJJF rules 2024](https://www.ligabjj.com/ibjjfrules/2024JUN_IBJJF_Rules_EN.pdf)). If you ever run ADCC rules, they differ a lot: no points in the first 5 of 10 minutes, mount 2 and back 3 ([ADCC rules](https://adcombat.com/adcc-rules-regulations/)).

2. **Leg-lock legality is right.** Since 1 January 2021, heel hooks, knee-twisting locks and reaping are legal only for adult brown and black belts in no-gi ([IBJJF 2021](https://ibjjf.com/news/new-rules-updates)). The straight ankle lock is legal at every belt. I found no change through 2026 that extends this to purple or below. Kneebar, toe hold and calf slicer from brown fits the IBJJF table, but stage 1 should still read the illegal-techniques page itself.

3. **Submission split: arms and legs are swapped.** No-Gi Worlds 2022, women's brown and black: 54% submissions (57 of 106) is right. The source counts 27 chokes, 17 arm locks and 14 leg locks, which is about chokes 47%, **arms 30% and legs 25%**. The doc has legs 29 and arms 24 ([FloGrappling 2022](https://www.flograppling.com/articles/10161810-by-the-numbers-abundant-submissions-in-female-divisions-at-no-gi-worlds)). Fix bar 3.

4. **Some per-attempt rates are wrong.** The overall 15–17% is right, and so are ADCC 2022 guillotine at 9.3% and kneebar at 27.2%.
   - **RNC 0.29 matches no single year.** It was 25.7% in 2024, 34.7% in 2022 and 41.8% in 2023 ([Grappling Conjecture 2024](https://thegrapplingconjecture.blogspot.com/2025/01/the-year-in-nogi-grappling-2024-pt2.html), [2023](https://thegrapplingconjecture.blogspot.com/2024/01/the-year-in-nogi-grappling-2023-pt2.html)). Pick one year and say which.
   - **Mat return at 0.47 doesn't match 2023, when it was 70.8%.** It may come from a year I didn't check, so name the year.
   - **WNO 5:17 for leg locks against 8:38 for chokes are averages, not medians** ([FloGrappling 2022](https://www.flograppling.com/articles/10249567-by-the-numbers-50-submission-rate-at-tezos-wno-in-2022)). Rename bar 8.
   - **No source found:** back conversion at 0.36 and ADCC women's takedowns at 33%. Mark both unverified.

5. **Williams 2019 is a gi study.** Its 140 white and blue belt matches support guard pulls at 94%, scissor sweep 55%, sit-up 38%, X-guard 63% and back takes 60% ([Williams 2019](https://www.tandfonline.com/doi/abs/10.1080/24748668.2019.1611290)). Ana competes in no-gi, so flag these as gi figures.

6. **BEAT_S = 22 s has no measured source.** Dos Santos 2023 (422 women's bouts) exists, but its abstract doesn't contain "12–18 actions in 311–408 s", and I couldn't open the full text ([PubMed](https://pubmed.ncbi.nlm.nih.gov/36860781/)). Relabel 22 s as a tuning value. Measured effort-to-pause ratios run 6:1 to 9:1 ([Andreato 2015](https://pubmed.ncbi.nlm.nih.gov/25559902/)).

7. **Belt time is right, but the technique counts aren't measured.** The Gold BJJ survey of 1,948 people gives years spent at each belt of 2.3 (white), 3.3, 3.4 and 4.4, about 13.3 years to black ([Gold BJJ](https://goldbjj.com/blogs/roll/statistics)). For techniques, I found no measured count for any belt. The Gracie Combatives "36" is a curriculum, not a usage count, so mark the 8–12 and 25–36 bands ESTIMATE. No study measures how often a game plan works either. The nearest is that whoever scores first wins 87% of women's bouts ([Sports 2026](https://doi.org/10.3390/sports14100445)), so the walk's first scorer should win about 80–87%.

8. **The missing number is how bouts end at white and blue belt: submission, points, advantages or referee decision.** One analytics site gives IBJJF overall as 42% submission, 38% points, 12% advantages and 8% DQ or referee ([BJJ Analytics](https://www.bjjanalytics.com/competition-stats)), but its method is unknown. I found no source for amateur belts.

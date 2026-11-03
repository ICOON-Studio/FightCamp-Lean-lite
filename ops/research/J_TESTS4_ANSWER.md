# J_TESTS4 answer - John (research), men's vs women's punch force on the same device

Collected S373 (2026-11-03) from the gbot thread 'John Research'. Built into scripts/rules/TestDay.gd POWER_MEN_AT
(830 / 1,080 / 1,340 N = the women's 490 / 770 / 990 N x 1.7 / 1.4 / 1.35).

**J_TESTS4 is done.** Two boxing studies measured men and women on the same device, and both put the men:women rear-hand ratio at about 1.34–1.39. Neither one splits its results by level.

**Q1. Boxing studies with both sexes on one device**
| Study | Level | Boxers (men/women) | Device | Men's rear hand | Women's rear hand | Ratio | Label | Source |
|---|---|---|---|---|---|---|---|---|
| Buśko 2016 | Polish junior/club, about age 17 | 13/7 | punch bag with built-in accelerometers | 1,592.5 ± 507.1 N | 1,170.7 ± 165.3 N | 1.36 | MEASURED (ratio DERIVED) | [Buśko 2016 PDF](https://bibliotekanauki.pl/articles/306941.pdf) |
| Buśko 2016, lead hand | same | 13/7 | same | 1,102.9 N | 848.4 N | 1.30 | MEASURED (ratio DERIVED) | same |
| Loturco 2016, fixed punching distance | Brazilian national team | 9/6 | force plate with a padded target | 1,331.67 ± 234.49 N | 994.17 ± 221.14 N | 1.34 | MEASURED* (ratio DERIVED) | [Loturco 2016](https://pubmed.ncbi.nlm.nih.gov/26110348/) |
| Loturco 2016, boxer picks the distance | same | 9/6 | same | 1,368 N | 987 N | 1.39 | MEASURED* (ratio DERIVED) | same |
| Smith 2000, Dunn, Pierce 2006 and others | – | men only | various | – | – | – | no source found | [2025 review](https://www.mdpi.com/2075-4663/13/1/12) |

*The publisher's full text for Loturco 2016 timed out. These values come from a [2025 review](https://www.mdpi.com/2075-4663/13/1/12) and a [Charles University dissertation](https://old.ftvs.cuni.cz/FTVS-2946-version1-omcirkdp.pdf) that both cite the paper, so check them against the paper's own table before treating them as final.

**Q2. Closest other sports**
| Study | Population | Athletes (men/women) | Measure | Men | Women | Ratio | Label | Source |
|---|---|---|---|---|---|---|---|---|
| Buśko 2016 | Olympic taekwondo, rear-leg kick (Apdolio) | 14/14 | same accelerometer bag | 2,072.3 N | 1,511.6 N | 1.37 | MEASURED (ratio DERIVED) | [Buśko 2016 PDF](https://bibliotekanauki.pl/articles/306941.pdf) |
| Buśko 2016 | taekwondo, rear-leg kick (Dwit Chagi) | 9/8 | same | 3,426.1 N | 2,490.3 N | 1.38 | MEASURED (ratio DERIVED) | same |
| Morris 2020 | untrained adults | not confirmed | arm cranking power in watts, used as a stand-in for a punch, not impact force | 282 W | 108 W | about 2.6 | MEASURED (power) | [Morris 2020](https://journals.biologists.com/jeb/article/223/2/jeb212365/223648/) |
| Adamec 2021 | karate | 29/21 | force plate | 4,639 N, men and women combined | – | – | no sex split found | [2025 review](https://www.mdpi.com/2075-4663/13/1/12) |

**Q3. Men:women rear-hand ratio by level**
| Level | Ratio | Label | Basis |
|---|---|---|---|
| Novice | 1.6–1.8 (use 1.7) | ESTIMATE | The untrained gap in arm power is about 2.6 (Morris 2020), the trained gap in force is about 1.35, and novices should sit between the two. |
| Club | 1.35–1.40 (use 1.4) | ESTIMATE | Buśko 2016 club boxers came out at 1.36, and the taekwondo kicks on the same bag at 1.37–1.38. |
| Elite | 1.3–1.4 (use 1.35) | ESTIMATE | Loturco 2016 national-team boxers came out at 1.34–1.39. |

Applying these ratios to the women's anchors (490, 770 and 990 N) gives men about 830 N at novice, 1,080 N at club and 1,340 N at elite (DERIVED). Smith 2000's values come from a different device, so they shouldn't be shown next to the women's anchors without rescaling.

**Gaps:** no same-device study gives a level split for both sexes. The women's groups are tiny (6–7 boxers). Morris 2020 measures power rather than force, and I didn't confirm its sample sizes. I also found no same-device split by sex for MMA or kickboxing.

The file is at `/workspace/jtests4/J_TESTS4.md`. Your computer is offline, so I haven't been able to land it with a note to Claude yet.

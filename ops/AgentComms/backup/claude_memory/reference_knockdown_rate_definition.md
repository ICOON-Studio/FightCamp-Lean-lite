---
name: reference_knockdown_rate_definition
description: "FightMetric/Fightnomics 3.9% knockdown rate - the verbatim definition R151 recovered, and the two J20 rates it is often confused with"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2e39c758-1950-4071-b0d8-82b8b3911060
  modified: 2026-09-20T14:29:22.238Z
---

**Reed Kuhn (Fightnomics), via MMAOddsBreaker — verbatim, opened 2026-09-20 (R151, DIRECT):**

> "Knockdown Rate is calculated as total Distance Knockdowns divided by Total Landed Distance Power
> Head Strikes. … The UFC average is 3.9%"

So **both halves are narrow**: the numerator is *distance* knockdowns only, and the denominator is
landed, at distance, power role, head. J20 section F carries the 3.9% but cites "Fightnomics PDF
extracts" **with no URL and no definition**, which is what made it mis-readable.

**The three rates that get confused, all from J20 and all true at once:**

| rate | what it is a share of | value |
|---|---|---|
| 3.9% (section F) | landed **distance power head** strikes | FightMetric/Fightnomics |
| ~1.0% (derivable) | **all** landed head strikes (71.3 landed x 63% head = 44.9) | section A + B arithmetic |
| **63.5%** (section 3.4) | **bouts with a knockdown that end KO/TKO** — the *conditional finish* | "KD should raise finish probability, not guarantee it" |

**Why:** in S26 I argued the 3.9% and the ~1.0% contradicted each other and that this voided S25's
"3.6x too gentle" finding. They do not contradict — they are the same knockdowns over different
denominators, and dividing one by the other was my error. S25's reading was right. Getting this
wrong would have closed a real defect as an artefact.

**How to apply:** when comparing engine lethality to 3.9%, the engine's denominator must be landed
distance power-head strikes AND its numerator must exclude clinch/ground knockdowns — FightCamp's
probe counts knockdowns in every position, so its figure (1.06%) *over*-states the comparable rate.
The 63.5% conditional is a separate, much more actionable anchor and was unread in J20 for weeks.
**A figure whose source states no denominator is not an anchor**; get the verbatim line first.

Related: [[feedback_anchor_miss_is_not_its_own_constant]], [[feedback_quote_rulings_verbatim]],
[[feedback_ground_tests_in_real_studies]].

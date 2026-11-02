# S4J — Does BoxMind publish the distance mix? (fetch, then the decision)

**Stage:** S4j. **Owner:** Claude. **Date:** 2026-09-17.
**Question, from S4i finding 5 and S4I_BAND_OCCUPANCY.md open question 1:**
the solver derives that LONG must rise from **25.6% of named throws to about
40%**, and S4i wrote that this "is what the solver needs, not what a fight
does". J21 §1 names **BoxMind** (Wang et al., arXiv:2601.11492v2) whose atomic
punch event carries `distance ∈ {Long, Mid, Close}` and whose eighteen
indicators begin with "distance mix". **Does the paper publish the numbers?**

## VERDICT: NO. THE DERIVED 40% STAYS DERIVED — BUT THE DIRECTION IS CORROBORATED, AND 40% IS A FLOOR

**BoxMind publishes no population distance mix on our axis.** The three-way
`{Long, Mid, Close}` lives on the ATOM; the published INDICATORS collapse it to
**two buckets** — `Close- & Mid-Range` against long range. The only distance
numbers that surface are **one athlete's coached trajectory over one training
cycle**, not a population. So S4I's open question 1 is still open, and the ~40%
must keep its derived label.

What the fetch DID buy, and it is not nothing: the one published elite figure
sits **further out than our derived target**, from a direction the solver could
not have manufactured. See §4.

## 1. PROVENANCE — READ THIS BEFORE CITING ANY NUMBER BELOW

**The paper was NOT read directly from this container.** `arxiv.org`,
`huggingface.co` and `www.alphaxiv.org` are all **blocked by the cloud
container's network egress proxy** (`EGRESS_BLOCKED`, a policy denial — not a
transient failure, and not to be routed around). Everything in §2–§5 came
through the sanctioned `WebSearch` tool, which reads the page server-side and
quotes it back.

So, in J21's own vocabulary: J21 §1's tuple is **DIRECT** (John read the
paper). **Every figure below is UNVERIFIED_SECONDARY.** A quoted figure
relayed by a search tool is not a table anyone here has looked at, and this
project has a standing rule that a carried-forward claim is verified before it
is repeated.

**VERIFICATION OWED, AND IT IS ~2 MINUTES ON THE PC:** open
`https://arxiv.org/html/2601.11492v2`, find **Figure 5(b)** (the Li Qian
monitoring panel) and the indicator list, and confirm or correct §2 and §3.
Nothing should be built on §3's numbers until that is done.

## 2. THE PUBLISHED AXIS IS BINARY, AND THAT IS THE WHOLE ANSWER

The atom is three-way — J21 §1 has it DIRECT:
`(t_start, t_end, hand, distance ∈ {Long, Mid, Close}, technique, target, effect)`.

The **indicators are not**. Two of the eighteen carry distance:

| indicator | axis |
| --- | --- |
| Number of Effective Close- & Mid-Range Punches | Close+Mid (count) |
| Proportion of Close- & Mid-Range Punches | Close+Mid (share) |

and the grouping is deliberate: close and mid are pooled **because they share
infighting characteristics**, and the contrast drawn is against long-range
punching as an **out-boxing** strategy. A high Close+Mid share reads as an
infighter; dominance at long range reads as an out-boxer using reach.

**This is a style classifier, not a distance histogram.** It answers "which of
the two men is the infighter", which is not the question S4i asked.

**AND THE BOUNDARIES ARE NOT PUBLISHED.** No threshold, no metric, no
centimetre figure separating Long from Mid from Close surfaced anywhere. The
pipeline is Detectron2 for bounding-box localisation plus PHALP tracking with
**UV pixel counts** — so `distance` is a vision-derived / annotated label in
image space, **not a distance in metres**. There is therefore **no way to map
BoxMind's cut onto `SCALED_LONG := 1.17` / `SCALED_MID := 0.88`**, even if the
numbers had been published.

Note the shape of that: S4i's second earned rule says a cut at the terciles of
your own distribution cannot disagree with reality. BoxMind's cut is not ours,
is not in our units, and is not stated. **Two incomparable cuts is a worse
problem than one self-referential cut**, and it is why the number below is
directional only.

## 3. THE ONE PUBLISHED NUMBER — NAME ITS POPULATION

**Li Qian**, Chinese national team, women's middleweight (75 kg), over the
**January–July 2024** Olympic training cycle, monitored by BoxMind and
**coached on BoxMind's own gradient**:

| indicator | start | end |
| --- | --- | --- |
| **Proportion of Close- & Mid-Range Punches** | **28.5%** | **39.0%** |
| Proportion of Mid- & Long-Range Hook Punches | not published | **+3.1 pts** |
| Proportion of Lead Hand Punches | not published | **+0.7 pts** |

Implied on the other side of the binary: **long-range share 71.5% → 61.0%.**

**This is one athlete, and she is the worst possible sample for a population
mean**, for a reason that is in the paper's own logic: BoxMind took the
gradient of win probability with respect to the indicators, found a **high
strategic gradient** on Close+Mid volume, and the cycle then deliberately drove
that number up. 28.5% is one elite amateur's baseline; 39.0% is an intervention
target she was trained toward. Neither is "what an elite bout looks like".

**Population of record:** elite **Olympic amateur** boxing, female, 75 kg, one
athlete, coached intervention. Amateur rules reward the clean scoring blow and
the bouts are 3×3, which favours out-boxing on its own — some of that 61–71.5%
long share is the **ruleset**, not the sport.

Datasets named, for the record (no distance table surfaced from any of them):
BoxingWeb + BoxingStudio, **80 match rounds / 240 minutes / 10.9K atomic
events**, manually annotated; **BoxingWeb-Full, 1,909 rounds / 119 hours**,
2021–2024, male and female, eight weight classes.

## 4. WHAT THIS DOES TO THE DERIVED 40%

Our engine, S4i, **named throws** (679 / 646 / 1330), fixture = the seeded
boxing bout of two differentiated men (A reach 1.446 m, B 1.296 m):

| | LONG | MID | POCKET | Close+Mid |
| --- | --- | --- | --- | --- |
| engine today | 25.6% | 24.3% | 50.1% | **74.4%** |
| S4i derived target | ~40% | (24.3 pinned) | ~35.2% | **~60%** |
| Li Qian, pre-cycle | — | — | — | **28.5%** |
| Li Qian, post-cycle | — | — | — | **39.0%** |

Read across the last column only — it is the only column the two sources share.

1. **The direction is independently corroborated.** The solver says LONG must
   rise; the one published elite figure has long share at 61–71.5% against our
   25.6%. Two unrelated instruments, the same sign. That is the third time this
   arc has landed on position mix (S4g from the leg share, S4i from the J21
   error, now this).
2. **~40% LONG is a FLOOR, not a target.** Our derived Close+Mid ~60% is still
   well above the coached-infighter endpoint of 39.0%. The engine at 74.4%
   Close+Mid is further inside than an elite athlete who was being *deliberately
   pushed toward infighting*.
3. **It is NOT an observed target and must never be recorded as one.** Different
   axis (binary vs ternary), unstated boundaries, image-space units, one
   athlete, coached trajectory, amateur ruleset, women's 75 kg. Any one of those
   disqualifies it as an anchor. **Do not fit to 61%.**

**So S4I open question 1 remains open** and the honest statement is unchanged
from S4i: 40% is what the solver needs. What changed is that we now know
nobody is about to hand us the observed number, and that the correction is
pointing the right way.

## 5. WHAT IS CLOSED BY THIS STAGE

- **BoxMind is spent as a source for this question.** Do not re-fetch it for a
  distance mix; it does not have one. It remains DIRECT and correct for J21's
  purpose — the unit of analysis — which is what J21 cited it for.
- **The "go and get the observed number" lead is closed NO.** If the band
  occupancy of a real bout is wanted as an anchor, it has to be **measured**,
  not found — and it would need a source that publishes range in metres or a
  tracked video pass in our own units. That is a study, not a fetch.
- **K63 still does not cover this** (its Q3 is the UFC's distance/clinch/ground
  split, a coarser axis on which a boxing bout is 100% "distance"). Unchanged.

## 6. THE DECISION IS NOW THE OPERATOR'S — UNCHANGED SHAPE, ONE LEVER STRENGTHENED

S4i left three, A and B independent (S4i finding 2), order free:

- **(A)** flip `usage_prior` ON and re-baseline. 57.9 → 22.2 points against
  J21; throws 4,900 → 5,243, so damage, stamina and bout length all move and
  every seeded pin riding a bout's course is **re-found by sweep, never
  re-pinned**.
- **(B)** move position so LONG rises toward 40% of named throws.
  `FightIntent.preferred_range` (`FightIntent.gd:30`) derives the standoff from
  stats and reach; both men stand beyond `STRIKE_RANGE` 1.1 m
  (`FightRealtime.gd:314`) and what closes the gap is unmeasured.
  **THIS STAGE STRENGTHENS B**: the only outside elite figure we own agrees
  with its sign and says the target is conservative.
- **(C)** `commit_s` — `FightCommitment.COMMIT_S := 0.267`
  (`FightCommitment.gd:86`) commits a jab and a spinning back kick for the same
  time, where Stanley 2018 via J21 has the jab at 405 ± 150 ms. Boxing's six are
  documented; everything else would be invented.

**A band-conditioned prior stays answered NO** (S4i). Nothing here reopens it.

## Verification

Research stage. **No `.gd` touched, so no parse gate and no test** — the tier
rule for a research file is `git status -s` before staging, which was clean.
The instrument of record for the figures in §4 is unchanged and still only
reads:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_band_occupancy.gd
```

# TASK K35 — KALLI — THE KNOCKDOWN COUNT: DOES THE ROUND CLOCK RUN, AND WHICH RULESETS COUNT AT ALL

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a item (3) THE COUNT - forecast research for the engine slice.

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

We are building a knockdown COUNT into our fight engine: when a boxer is knocked down and the fight continues,
nobody strikes until the count ends. Our operator ruled it for boxing. Before we build, we need the rule text on
two things our existing study does not state outright, and we need to know whether the other striking rulesets
we simulate (kickboxing, muay thai, taekwondo) count knockdowns too - that question will come next.

## What we already hold - do NOT re-research, cite only if you extend or correct

- Professional boxing (ABC Unified Rules 2016 + ABC Referee Manual Rev. 08/2025, NAC 467.740, Ontario s.14,
  WBA Contest Rules 10-14, BBBofC 3.32-3.35, USA Boxing 19.2-19.4): the ordinary continuing knockdown lasts
  about 10-25 s (inherited from the 1-second cadence + mandatory eight + glove wipe; no stopwatch study
  found); the mandatory eight applies even if the man rises at once; the opponent goes to the farthest neutral
  corner and the count pauses if he leaves it; no standing eight in pro ABC; three-knockdown stop is WBA Rule
  12, not ABC; BBBofC: no save by the bell in any round including the last; USA Boxing: mandatory 8 even if
  the round is over.
- Professional MMA: no ten-count, no mandatory eight, no standing eight (NAC 467.740(9)).
- Wisconsin Muay Thai SPS 192.79(2): a "flash knockdown" (rises immediately) skips the count.

## What to find - one table row per finding

1. **Boxing - does the ROUND CLOCK keep running during a knockdown count?** The rule or manual sentence that
   says so (or says the clock stops), per body: ABC Unified Rules / ABC Referee Manual, Nevada NAC 467, WBA,
   WBC, WBO, IBF, BBBofC, USA Boxing / World Boxing (amateur). Quote the sentence.
2. **Boxing - the bell rings during a count.** Is the man "saved by the bell"? Per body, and whether it
   differs by round (every round / last round only / never).
3. **Kickboxing** (K-1, Glory, ONE Championship kickboxing, WAKO Pro, ISKA), **muay thai** (IFMA, the Thai
   stadium rules - Lumpinee / Rajadamnern / Sports Authority of Thailand, ONE Championship muay thai) and
   **taekwondo** (World Taekwondo competition rules): per body - is there a knockdown count? to what number? is
   there a mandatory eight? a standing count? a three-knockdowns-in-a-round (or in-a-bout) stoppage? does the
   round clock stop or run during the count? a flash-knockdown exception?
4. **Any TIMED measurement of real knockdown pauses** in any of these sports - canvas touch (or the referee's
   "down") to the fight resuming, in seconds, with the sample size: a video-analysis study, a thesis, a
   broadcast statistic. NOT FOUND is a valid answer.

## Rules

- Label every row: **DOCUMENTED** (read in the primary rule text), **SECONDARY** (an article or encyclopedia
  quoting it), or **NOT FOUND**. Never fill a cell with a guess, a forum post or "commonly".
- Every row: the finding, the source (body, document title, version or date, section number, URL).
- Where two bodies disagree, give both rows - do not pick one.

## Deliverable

One markdown table per section (1-4), columns: Body | Finding | Rule text or number | Label | Source. Then a
short **GAPS** list, and one closing paragraph: for each of boxing, kickboxing, muay thai and taekwondo, one
sentence on whether a simulated bout under that ruleset should pause for a count, and whether its round clock
runs meanwhile.

## Owned files

- `research/K35_THE_COUNT_ACROSS_RULESETS.md` - Claude writes it from the reply; Kalli pushes nothing.

# TASK K36 — KALLI — WHEN A FIGHTER GOES TO THE FLOOR: WHICH RULESETS LET THE FIGHT CONTINUE THERE, AND FOR HOW LONG

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: Stage A correctness - forecast research for a finding.

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

Our fight engine lets two fighters wrestle on the ground and finish by submission under EVERY ruleset: in a test
of 400 muay thai bouts, 150 ended by submission. Before we fix it we need the rule text, per sport, for what
happens the moment a fighter lands on the floor - so the fix copies real rules instead of inventing them.

## What we already hold - do NOT re-research, cite only if you extend or correct

- Judo (IJF): matte, ne-waza length and how bouts end - our J26 study.
- Knockdown counts in boxing, kickboxing, muay thai and taekwondo - your K35 (today).
- MMA (ABC Unified): ground fighting and submissions legal; no knee/kick to the head of a grounded opponent.

## What to find - one table row per body per question

For **boxing** (ABC Unified, WBC), **kickboxing** (GLORY, K-1, ONE Championship kickboxing, WAKO K-1 / low-kick,
ISKA), **muay thai** (IFMA, Lumpinee, ONE Championship muay thai), **karate** (WKF kumite), **taekwondo** (World
Taekwondo), **sport sambo and combat sambo** (FIAS), **freestyle and Greco-Roman wrestling** (UWW) and **BJJ**
(IBJJF):

1. **A fighter is thrown, swept, dumped or slips to the floor - may the bout continue on the ground at all?** If
   not, what does the referee do (break, stand-up, restart), and is a time or a number of seconds written down?
2. **Strikes to a grounded opponent**: legal, illegal, or legal with limits (which strikes, for how long - e.g.
   WKF's follow-up technique after a takedown)?
3. **Submissions (chokes, joint locks)**: legal or not; if legal, any restriction (e.g. sambo: no chokes in sport
   sambo; wrestling: none at all).
4. **Does the throw, dump or sweep itself SCORE?** (e.g. IFMA muay thai scores an off-balancing; K-1 bans throws.)
5. **How long may a ground exchange last before the referee stands them up**, where the rules give a number
   (e.g. sambo hold-down seconds, combat sambo ground time, wrestling par terre). Any timed study of ground-spell
   length in these sports, with sample size.

## Rules

- Label every row: **DOCUMENTED** (read in the primary rule text), **SECONDARY** (an article or encyclopedia
  quoting it), or **NOT FOUND**. Never fill a cell with a guess or "commonly".
- Every row: the finding, the source (body, document title, version or date, section number, URL).
- Where two bodies in one sport disagree, give both rows.

## Deliverable

One markdown table per question (1-5), columns: Sport | Body | Finding | Rule text or number | Label | Source.
Then a short **GAPS** list, and one closing paragraph: for each sport, one sentence on what a simulated bout
should do the moment a fighter lands on the floor.

## Owned files

- `research/K36_THE_FLOOR_BY_RULESET.md` - Claude writes it from the reply; Kalli pushes nothing.

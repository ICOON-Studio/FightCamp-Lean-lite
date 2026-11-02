# TASK K38 — KALLI — HOW OFTEN AND HOW LONG FIGHTERS CLINCH, SPORT BY SPORT

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: Stage A realism - forecast research for a finding.

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

Our fight engine measured 60 bouts each of boxing, kickboxing, muay thai and MMA between two legal, different
fighters: **boxers and kickboxers never clinched at all (0.0% of the fight), muay thai fighters clinched 1.9% of the
time, MMA fighters 1.8%.** Real boxers hold, real muay thai is fought in the clinch for long stretches. Before
anyone changes the engine, we need the real numbers.

## What we already hold - do NOT re-research, cite only if you extend or correct

- Movement events per minute in boxing (Thomson 2015, via your K32); punch timings (K32, K33).
- What happens when a fighter reaches the floor, by ruleset (your K36); knockdown counts (your K35).

## What to find - one table row per finding

1. **Time-motion studies** (any level: professional, elite amateur, national team) of **boxing, kickboxing (K-1,
   full contact, low kick), muay thai and MMA** that report the clinch: clinches per round or per minute, mean
   clinch duration (seconds, with SD), share of fight time spent clinching, and the sample (bouts, rounds, level).
   Also the attack-to-clinch or strike-to-clinch sequences where reported.
2. **The referee's clinch rules**: when a referee must break a clinch - boxing (ABC Unified / Referee Manual, WBC),
   kickboxing (GLORY, K-1, ONE, WAKO K-1 and low-kick, ISKA), muay thai (IFMA, Lumpinee, ONE), MMA (ABC Unified) -
   including any number: "one knee then break", seconds of inactivity before a break, strikes allowed from the clinch.
3. **Who clinches**: any study relating clinch frequency to style, fatigue, being hurt, the round or the score.
4. **Timed break intervals**: how long from "break" to the fighters striking again, if any study measured it.

## Rules

- Label every row: **DOCUMENTED** (read in the primary study or rule text), **SECONDARY** (quoted by another source),
  or **NOT FOUND**. Never fill a cell with a guess.
- Every row: the finding, the number with its SD and sample, the source (authors, year, journal or rulebook, section,
  URL or DOI).

## Deliverable

One markdown table per section (1-4), columns: Sport | Finding | Number (mean +- SD, sample) | Label | Source. Then a
short **GAPS** list, and one closing paragraph: for each sport, the one number a simulated bout's clinch share should
be judged against, and how confident that number is.

## Owned files

- `research/K38_THE_CLINCH_BY_SPORT.md` - Claude writes it from the reply; Kalli pushes nothing.

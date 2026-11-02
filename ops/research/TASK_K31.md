# TASK K31 — KALLI — HOW FIGHTERS MOVE AROUND THE RING: DIRECTION, DISTANCE, AND WHO GOES WHERE

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

Our next movement stage lets the two fighters move freely around the ring or cage instead of along one
line. Its automated tests must compare what the game shows with real bouts, so we need the movement
structure of real bouts BEFORE we build it: which way fighters move, how far, how fast, how close they
stand, and how that differs between the man going forward and the man going back.

## What we already hold - do NOT re-research, cite only if you extend or correct

- Schortgen 2023 (ECSS abstract, 32 French elite boxing bouts): distance between the men 1.23 +- 0.16 m;
  155 +- 28 m travelled per round (about 0.86 m/s).
- Thomson (as cited in our M18 study): mean ring movement speed 0.6 m/s.
- Dunn 2017 (PLoS ONE): bounce time R1 57.3 +- 27.3 s, step time R1 64.0 +- 22.3 s per round (your K30).
- JPES 2016: active 1.2 +- 0.8 s, inactive 2.3 +- 1.8 s.

## What to find - one table row per quantity, per discipline where it differs

1. **Direction of movement:** share of time or distance moving forward, backward, laterally (left/right
   circling) and diagonally, for boxing, kickboxing/muay thai and MMA (standing). Split by the fighter's
   role (the one pressing forward vs the one moving back) if any study does.
2. **Circling:** which way fighters circle (toward the lead hand or away), how often per round, and
   whether stance (orthodox/southpaw) changes it.
3. **Distance bands:** the share of a round spent at long range, mid range, and in the clinch or at close
   range, with each band's distance in metres if given.
4. **Speed profile:** mean and peak movement speed (m/s) in a bout or sparring, and how often a fighter is
   essentially stationary on the spot (speed near zero).
5. **Ring or cage position:** share of time in the centre versus near the ropes/fence and in corners; how
   often a fighter is pressed to the ropes/fence per round.
6. **Tracking data sources:** any published position-tracking of real bouts (optical tracking,
   broadcast tracking, wearable positioning) - what it measured and where the numbers are.

## Rules

- Label every number: **DOCUMENTED** (read in the primary study), **SECONDARY** (a review quoting a named
  study), **LAB** (drills, not a bout), or **NOT FOUND**. NOT FOUND is a valid answer - never fill a cell
  with a guess, a coaching rule of thumb or a betting statistic.
- Every row: the number with its spread (mean +- SD or range), the sample (n, level, sex, weight class),
  and the source (authors, year, title, journal, DOI or URL).

## Deliverable

One markdown table per quantity (1-6), columns: Quantity | Sport and sample | Number (+- spread) | Label |
Source. Then a short **GAPS** list of what is still NOT FOUND, and for each, the kind of source that
could answer it.

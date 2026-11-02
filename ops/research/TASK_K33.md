# TASK K33 — KALLI — HOW FAST ONE FIGHTER'S PUNCHES FOLLOW EACH OTHER IN A REAL BOUT

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (d) part 3 findings, forecast for the engine.

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

Our fight now plays in real time. It showed that the engine can land one fighter's blows only 0.1-0.2 s apart,
faster than the combination timing we hold, so the second punch has to start before the first one has landed.
Before anyone changes the engine we need the real distribution: how much time separates consecutive punches
thrown by the SAME fighter, inside a combination and between exchanges, in real bouts or sparring.

## What we already hold - do NOT re-research, cite only if you extend or correct

- Piorkowski, Lees and Barton 2011: contact of the 1st punch to contact of the 4th in a combination -
  out-of-synch 1.35 +- 0.27 s, in-synch 1.04-1.06 s (a bag/dummy, lab); the next punch starts at the previous
  one's impact.
- Your K32: delivery start->contact by clock (Stanley 2018 jab 405 +- 150 ms ... hooks 586-657 ms; Menzel 2021
  fist-onset 71-132 ms; Cheraghi 2014 310 +- 60 ms).
- JPES 2016: active phases 1.2 +- 0.8 s, inactive 2.3 +- 1.8 s. BoxMind (arXiv 2601.11492) calls a pause over
  1 s a new attack.
- CompuBox-style punch counts per round (we hold rates, not intervals).

## What to find - one table row per quantity

1. **Inter-punch interval inside a combination**, in milliseconds - contact to next contact, or launch to next
   launch (say which) - by punch pair where given (jab-cross, cross-hook, double jab), from any study of bouts,
   sparring or instrumented pads/bags. Include the fastest documented and the typical.
2. **Punches per combination** in real bouts (how many punches a flurry holds) - distribution or mean +- SD.
3. **The shortest physically possible interval** between two punches by one fighter (any lab or elite data).
4. **Interval between exchanges** by the same fighter if any study separates it from JPES's inactive phase.

## Rules

- Label every number: **DOCUMENTED** (read in the primary study), **SECONDARY** (a review quoting a named
  study), **LAB** (drills, not a bout), or **NOT FOUND**. NOT FOUND is a valid answer - never fill a cell
  with a guess, a coaching rule of thumb or a blog figure.
- Every row: the number with its spread, the sample (n, level, sex, weight class), and the source (authors,
  year, title, journal, DOI or URL).

## Deliverable

One markdown table per quantity (1-4), columns: Quantity | Sport and sample | Number (+- spread) | Label |
Source. Then a short **GAPS** list of what is still NOT FOUND, and the kind of source that could answer each.

## Owned files

- `research/K33_INTER_PUNCH_INTERVALS.md` - Claude writes it from the reply; Kalli pushes nothing.

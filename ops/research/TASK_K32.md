# TASK K32 — KALLI — HOW LONG A PUNCH TAKES TO ARRIVE, AND HOW LONG A HIT MAN TAKES TO COME BACK

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (d) part 3, forecast research.

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

Our fight room is about to show the fight at the speed it really happens, one engine moment at a time,
instead of a highlight reel. The engine decides the moment a punch LANDS. The animation of that punch has
to START before that moment, by as long as a real punch takes to travel, or the head snaps back before
the fist arrives. And after a man is hit, the animation decides how long he takes to come back to guard.
We need the real numbers for both BEFORE the automated tests that judge the room are written.

## What we already hold - do NOT re-research, cite only if you extend or correct

- JPES 2016 boxing time-motion: active 1.2 +- 0.8 s, inactive 2.3 +- 1.8 s.
- Piorkowski, Lees and Barton 2011 (Sports Biomechanics): combination sequence time from contact of the
  1st punch to contact of the 4th: out-of-synch 1.35 +- 0.27 s, in-synch left lead 1.06 +- 0.46 s,
  in-synch right lead 1.04 +- 0.42 s; the next punch does not start projecting until the previous one
  lands; contact speeds 7.5-9.3 m/s. We hold the ABSTRACT-LEVEL finding that jab and cross delivery times
  are shorter than hooks, but NOT the delivery times themselves.
- Menzel (bag, lab): retraction jab 262 +- 42 ms, cross 169 +- 41 ms, hook 168 +- 97 ms, uppercut 171 +- 33 ms.
- Your K30: contact to peak head acceleration ~3-4 ms (Walilko, Hybrid III); return to stance after a hit
  NOT FOUND; contact to next throw NOT FOUND.
- Your K31: Schortgen 1.23 +- 0.16 m apart, 155 m a round; Thomson 0.6 m/s.

## What to find - one table row per quantity, per punch type where it differs

1. **Delivery time, start of the punch to contact**, in milliseconds, for the jab, cross, lead hook, rear
   hook and uppercut: Piorkowski 2011's own table if you can read it, and any other study (for example
   Kimm and Thiel 2015, Whiting 1988, Lenetsky, Cheraghi, Dinu) - say whether it was a bag, a pad, a
   dummy, sparring or a bout, and how "start" was defined (first hand movement, shoulder, hip).
2. **Return to guard after being hit**: time from a landed punch to the struck man's head and hands back
   in his guard position, or to his next action. Search high-speed video and motion-capture studies of
   sparring or bouts, boxing or any striking sport. K30 did not find it; try video-analysis and
   "recovery" / "restoration of guard" / "reaction time after impact" wording before calling it NOT FOUND.
3. **Steps per second while in stance** (not walking gait), and step length in cm, any striking sport.
4. **Thomson's thesis (the source behind our 0.6 m/s)**: the full citation, and its table of movement
   DIRECTION shares (forward / backward / lateral), which we believe is Table 6.2.

## Rules

- Label every number: **DOCUMENTED** (read in the primary study), **SECONDARY** (a review quoting a named
  study), **LAB** (drills, not a bout), or **NOT FOUND**. NOT FOUND is a valid answer - never fill a cell
  with a guess, a coaching rule of thumb or a blog figure.
- Every row: the number with its spread (mean +- SD or range), the sample (n, level, sex, weight class),
  and the source (authors, year, title, journal, DOI or URL).

## Deliverable

One markdown table per quantity (1-4), columns: Quantity | Sport and sample | Number (+- spread) | Label |
Source. Then a short **GAPS** list of what is still NOT FOUND, and for each, the kind of source that could
answer it.

## Owned files

- `research/K32_PUNCH_ARRIVAL_AND_RECOVERY.md` - Claude writes it from the reply; Kalli pushes nothing.

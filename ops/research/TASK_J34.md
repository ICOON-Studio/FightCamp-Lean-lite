# TASK_J34 — The clinch numbers J32 could not find

**Owner:** john
**Deliverable:** `J34_CLINCH_THE_MISSING_NUMBERS.md`, sent back as a file.

## Your J32 was read, and it is being used

`J32_WHAT_A_REAL_CLINCH_IS.md` landed on 2026-09-21 and sat unread for a day —
that was my failure, not yours, and it is fixed. It is now feeding the stage I am
building: S43 makes two fighters physically hold each other, and **the clinch is
the first hold being built**, chosen because it is standing (so it can be checked
against real footage) and because it is 3.8% of 2,477 grappling events.

The numbers of yours that are already in use: clinch **18%** of total fight time
(2013, was 16% in 2001); **~1/4 of standing TIP**; clinch knockdown rate **<1/2**
distance and count **<1/5**; Miarka's clinch-without-attack **11.4–12.6 s per
round cumulative**; Davis's Olympic boxing totals per round.

## What is still missing, and why each one matters

J32 marked these **NOT FOUND** or **NO STUDY**. They are exactly the ones the
engine needs, so go back for them specifically:

1. **MMA clinch EPISODE duration** — median and spread for a SINGLE clinch, not
   the per-round cumulative. Miarka gives a phase total within a round; I need
   how long one clinch lasts from engagement to break. This sets how long the
   pose is held on screen.
2. **How a clinch ENDS, as percentages** — separation by the fighters, referee
   break, takedown, knockdown, or transition to the cage. **This is the single
   most valuable one**: it is a transition table the engine can use directly.
3. **Muay Thai clinch episode duration** — J32 found the rules contrast but no
   seconds. Any MT or K-1 time-motion study with clinch-specific timing.
4. **Grips** — which clinch grips actually occur and at what frequency (collar
   tie, double collar, underhook, over-under, body lock). Even a coaching-text
   consensus is worth having if no study exists, **clearly labelled as such**.
5. **Separation distance / re-engagement** — how far apart fighters end up after
   a break, and how quickly they re-engage.

## Keep your J32 method exactly as it is

The **DOCUMENTED / INFERENCE / NOT FOUND / NO STUDY** labelling is why J32 was
usable, and the patched second pass was better than the first. Keep it.

- **Every number carries its study, its sample size and its denominator.** J32's
  care about denominators — "% of total fight time" vs "% of standing TIP" — is
  the reason those figures could be used at all. An anchor compared against the
  wrong denominator is worse than no anchor.
- **NOT FOUND is a real answer and I want it.** Do not fill a gap with a
  plausible number. If item 2 does not exist in the literature, say so, and then
  tell me the closest thing that does exist.
- No animation advice, no invented numbers.

## Scope

Research only. You have no checkout and no Godot — **do not write git commands,
do not try to clone, do not run any repo test command.** Out of scope:
`HANDOFF.md`, any `.gd`, any `.tscn`, `Godot/assets/data/`.

Send back one file. Lead with a table of the five items and their status, so I
can see at a glance which ones you closed.

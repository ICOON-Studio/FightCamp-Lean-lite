# TASK G59 — GROK — HOW LONG DOES A FIGHTER STAY OFF BALANCE

**Model:** Grok Expert / research mode. **NEVER Build mode.** One query's worth —
Grok is at ~18% of its weekly limit, which resets 2026-09-14 13:42.

**Submitted 2026-09-12 in the in-app browser.** Grok has no checkout, no engine
and no repo access, and needs none. Recorded here so what was asked is
recoverable from git.

## Why this exists

R131 wrote balance break (kuzushi) as a spec on the operator's design ruling:
**balance is a transient STATE, not an eighth attribute.** That ruling is settled.
Three sub-questions were left open and **all three currently hold invented
placeholder answers**, which is exactly the failure mode the standing rule against
un-researched open questions exists to stop. R131 §7 says plainly of the decay
rate: *"ENGINEERING CHOICE, NEEDS A RULING."*

This task assigns the research **before** the operator is asked to rule, so the
ruling is made from evidence rather than from our own guess handed back to us.

## The three questions

1. **THE DECAY RATE — the one that matters most.** How long, in real seconds,
   does a fighter remain measurably compromised after his base is broken? Split
   four ways because we expect an order of magnitude between them: a judo kuzushi
   converted through tsukuri to kake; a sweep or trip the man recovers from; a
   **stuffed takedown, where the SHOOTER is the compromised man**; and a stagger
   from a strike short of a knockdown. **Our placeholder is linear decay over
   `magnitude * 0.1` seconds** with magnitude 1–20, so half a second at 5 and two
   seconds at 20. Is that order of magnitude defensible?
2. **VECTOR OR SCALAR.** Is happo-no-kuzushi (the eight directions) a real
   analytical tool for coaches or a teaching mnemonic? And what do **shipped**
   games do — Tekken, Virtua Fighter, EA UFC, Sifu, Sekiro, For Honor, any
   wrestling or judo game — scalar meter or directional, and what did the choice
   buy or cost? A developer interview or GDC talk outweighs a wiki here.
3. **DOES A FAILED TAKEDOWN BREAK THE ATTACKER?** Is the man whose shot is
   stuffed left worse than neutral, and for how long? What actually happens to
   him — taken down, front-headlock submitted, or hit standing up? Any published
   figure for how often the defender scores in the following ten seconds.

## Rules given

Every claim labelled **DOCUMENTED** (named and linked), **INFERENCE** (and from
what), or **NOT FOUND** (and what was searched). **No invented numbers** — the
task file says why in plain terms: a fabricated recovery time goes straight into
a decay curve and is then defended for months as though it were measured. Real
combat and game design distinguished throughout. Lead with three lines: the decay
number, scalar or vector, yes or no on the failed takedown.

## Collection

Grok has no checkout and cannot push. **Claude collects this from the browser and
writes `research/G59_BALANCE_RECOVERY.md`.** G58 sat submitted and
uncollected for a day; do not repeat that.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real
regardless: Claude collects the answer and writes the file below. Naming it here
is what lets `python Tools/agent_comms.py done --task G59` mean *"has this been
collected yet?"* rather than passing on nothing.

- `research/G59_BALANCE_RECOVERY.md`

**The agent is not asked to create it and must not be given a git command.**

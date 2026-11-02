# TASK K29 — KALLI — THE REAL BOUT, MEASURED: GROUND FOR EVERY TEST THAT CLAIMS REALISM

**Research only.** No code, no engine, no downloads. Prose, numbers, citations. One pass.

## Why this exists - the operator's words, 2026-09-13

*"i want your tests to be based on reality, how you compare results from your tests with real
studies, when you have not done real studies to give ground to your tests ... the space between
exchanges should have been in your test from the very first test."*

We are building a fighting game that must LOOK like a real bout: when a fighter attacks, how long an
exchange lasts, how long both men sit in stance and move their feet before the next one, how fast a
hand comes back to guard, how a man moves when he is hit. Every automated test we write for that has
to compare what the game shows against numbers MEASURED IN REAL BOUTS. Where no real number exists,
the test must say so instead of pretending. This task collects those real numbers.

## What we already hold - do NOT re-research these, cite them only if you extend them

- **Boxing time-motion (JPES 2016, art178; 64/69/75 kg later winners):** active phase 1.2±0.8 s,
  inactive 2.3±1.8 s, individual attack 0.7±0.2 s, attack+counter 0.9±0.2 s, clash 1.9±0.9 s,
  inactive >4 s averaging 5.6±1.7 s about 7.6 times a round, activity:rest about 1:2.
- **MMA effort:pause 1:2 to 1:4** (Del Vecchio et al., via a 2011 review).
- **Punch phases on a BAG** (Menzel & Potthast, Sensors 2021, n=11 experienced): retraction to guard
  cross 169±41 ms, hook 168±97, jab 262±42, uppercut 171±33. A bag, single maximal punches - NOT a bout.
- **Mean ring movement speed 0.6 m/s** (Thomson, as cited in our M18 study).
- **Knockout video analysis:** loss of muscle tone within tens of milliseconds of impact.

## What to find

For each discipline we present - **boxing, kickboxing, muay thai, MMA (standing phase), karate
(kumite), taekwondo** - and for amateur and professional levels separately where studies differ:

1. **Exchange structure.** Duration of active (attacking) phases, inactive (neutral) phases, and the
   effort:pause ratio, from time-motion or notational analyses of REAL BOUTS. Boxing is covered above;
   find the other five, and any boxing study that contradicts or refines JPES 2016 (for example
   female boxers, or elite vs novice).
2. **What happens in neutral.** Measured, not coached: footwork step frequency (steps per second),
   step length, share of neutral time spent moving vs standing, stance switches per round, feints per
   round, and the vertical bounce of the body in guard (amplitude in cm, frequency in Hz) if anyone has
   measured it.
3. **Return to guard IN A BOUT OR SPARRING**, not on a bag: how long after a punch or a kick lands (or
   misses) the striking limb is back in guard. Kicks especially - we have NOTHING for kicks.
4. **Being hit.** How long a light hit, a hurting hit, and a knockdown blow disturb posture: head
   kinematics duration after impact in boxing/sparring studies (instrumented mouthguards, head-impact
   telemetry, video biomechanics), time from impact to hitting the canvas, time on the canvas before
   rising in non-knockout knockdowns.
5. **Movement around the opponent.** Share of time circling vs moving straight in or out, turning /
   pivoting frequency, and mean distance between the fighters in neutral, from bout tracking studies.

## Rules for the answer

- **Every number carries its source, its sample (n, level, sex, weight class), and a label:
  DOCUMENTED** (you read it in the study itself) **or NOT FOUND**. A number seen only in a blog, a
  coaching site or a review quoting a review is **SECONDARY** - say which study it claims to come from.
- **Never infer a number.** A missing quantity is NOT FOUND, and NOT FOUND is a useful answer: it tells
  us which of our tests has no real ground yet.
- Bag work, pad work and lab tests are NOT bouts. Label them LAB when they are the best there is.
- No UFC or league broadcast footage analysis of your own; published studies only.

## Deliverable shape

Open with **DECISIONS**: one line per quantity above, per discipline - the number, the source, the label
- in a table a test-writer can copy ranges from. Then a short **GAPS** list: every quantity that is NOT
FOUND anywhere. Body and full citations below.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real regardless: Claude collects the
answer and writes the file below.

- `research/K29_THE_REAL_BOUT_MEASURED.md`

**The agent is not asked to create it and must not be given a git command.**

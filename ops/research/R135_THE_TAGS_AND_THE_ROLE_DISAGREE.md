# R135 — THE COUNTER MECHANIC IS HALF-BUILT ALREADY, AND THE TAGS DISAGREE WITH IT

**Prompted by the operator, 2026-09-12, in three sentences:** *"these are tags for
those techniques"* … *"all techniques have those?"* … *"or there are more
categories that are already associated"*.

All three were right, and together they overturn how R130 framed the work.
**This is measured off the shipped catalogue, not researched.**

---

## 1. YES — EVERY TECHNIQUE CARRIES TAGS. ALL 272 OF THEM.

`Godot/assets/data/technique_catalog.json`, effects live at
`node["match"]["effects"]`:

- **272 techniques, and not one has an empty effects block.**
- 262 carry exactly **2** tags; 10 carry **3**.
- **140 distinct tag names** across the corpus.

So the 55 "unread" tags are not a fringe of odd entries. Tagging is universal and
deliberate: somebody gave every technique in the game exactly two or three.

## 2. YES — AND THERE ARE SIX MORE CLASSIFICATIONS ALREADY ON EVERY TECHNIQUE

This is the part that changes the plan. Every node already carries:

| field | distinct values | read in `scripts/` |
|---|---:|---:|
| `kind` | 3 — move / skill / sequence | 255 |
| `tier` | 4 | 112 |
| **`match.role`** | **10** | **77** |
| `match.range_band` | 5 | 36 |
| `match.phases` | 29 | 9 |
| `branch` | 63 | 5 |
| `match.range_delta` | 4 | 4 |
| `match.effects` (the tags) | 140 | **17** |

The ten roles: `setup, damage, counter, defense, control, takedown, transition,
escape, submission, adaptation`.

**The role is the operative classification — read 77 times — and the tags are read
17 times.** `_apply_landed_effect` pays a technique out BY ROLE.

## 3. THEREFORE: THE COUNTER MECHANIC IS NOT MISSING. IT IS HALF-BUILT.

R130 said *"today NOTHING can strike a man as he shoots"* and framed the nine
counter tags as an unimplemented mechanic needing design. **That framing is
wrong.** `role: "counter"` sits on **43 techniques** and the engine already
resolves them as counters.

**And the tag and the role disagree on 32 of the 56 techniques involved:**

| | count |
|---|---:|
| carry a counter TAG | 37 |
| have `role: "counter"` | 43 |
| **both** | **24** |
| **tagged, but the role says something else** (damage, adaptation, defense, setup, takedown) | **13** |
| **role says counter, but carries no counter tag** | **19** |

Neither set contains the other. Examples of each:

- **Role only, no tag:** `boxing_rear_uppercut`, `judo_uranage_counter`,
  `karate_uramawashi`, `kickboxing_spinning_back`, `capoeira_negativa_sweep`.
  These are *already treated as counters by the engine* and nothing tags them.
- **Tag only, role says otherwise:** `boxing_shoulder_roll`,
  `judo_grip_break_counter`, `karate_gyakuzuki`, `capoeira_rasteira`,
  `bjj_submission_chain`. These *describe* countering and the engine files them
  as something else.

**So the question in front of us is not "what should a counter do".** It is:
**for 32 techniques, which of the two labels is right?** That is a reconciliation
against the data we already own, not a research project.

## 4. THE SAME PATTERN, WEAKER, IN THE OTHER GROUPS

| group | techniques | dominant role | dominant branch |
|---|---:|---|---|
| balance (`balance_break`) | 18 | **takedown 10** | clinch, sweeps, grips_throws, ashi_waza |
| rhythm (`combo_speed`…) | 28 | **damage 16**, adaptation 8 | **combinations 9** |
| finish (`finish_chance`…) | 22 | damage 8, counter 4, adaptation 4, control 4 | elbows, hooks_bodywork |
| deception (`feint`, `surprise`) | 14 | damage 7, setup 4 | **spinning_kicks 5** |

Two of these are self-evident from the structure and need no research at all:

- **`combo_speed` sits on `branch: combinations`.** A combination's tag saying it
  is fast is not a mystery mechanic; it is a combination.
- **`feint`/`surprise` sit on `branch: spinning_kicks`.** A spinning attack IS a
  deception. The tag restates the branch.

- **`balance_break` sits on `role: takedown`** — which is exactly what the
  operator's own briefing says: *"a balance break is the mandatory first step
  before executing any successful throw or takedown."* **The authored data and the
  briefing independently agree**, which is the strongest evidence we have that the
  balance model is right.

## 5. WHAT THIS CHANGES

**Cancelled as framed:** a broad research commission on all five mechanics. Most
of what it would have returned is already encoded in `role` and `branch`, and
research that re-derives data we own is the R132 mistake in another costume —
measuring the fixture instead of the thing.

**What is actually needed, in order:**

1. **The 32-technique reconciliation** (tag vs role on countering). Measurable,
   no ruling needed to *produce* — a ruling needed to *apply*, because changing a
   role moves seeded verdicts.
2. **A narrow research question that the data genuinely cannot answer:** what a
   stop-hit costs **when it fails**. Nothing in the catalogue encodes a failure
   cost — every tag is a benefit. That is the real hole, and it is one question,
   not five. (Kept in J24; the rest of J24 is cut.)
3. **The rename pass**, unchanged and still zero-risk — 23 duplicate tag names
   onto the keys already read. Magnitude ignores the name, so the fight does not
   move.

**And one thing to stop saying.** "55 effect keys read by nothing" is true of the
*tags* and false of the *mechanics*. Counters, takedowns, submissions, setups and
defence are all already routed by role. The catalogue is far less inert than R130
made it sound; what it is, is inconsistently labelled.

---

## CORRECTION (C97, same day) — MY 32 WAS INFLATED BY MY OWN TAG LIST

C97 was sent to reconcile the 32 and came back with the finding that the 32 is
partly my artefact. **Nine of the nineteen "role says counter, carries no counter
tag" cases DO carry a counter tag** — `counter_throw` or `counter_takedown` —
which I simply left out of the nine names I hand-picked.

| tag | techniques | roles |
|---|---:|---|
| `counter_takedown` | 10 | counter 8, takedown 2 |
| `counter_throw` | 4 | takedown 2, counter 2 |
| `counter_open` | 4 | counter 2, defense 2 |
| `counter_score` | 1 | takedown 1 |

Re-measured with those included:

| | my 9 tags | the fuller 13 |
|---|---:|---:|
| tagged as counter | 37 | **53** |
| role says counter, no tag | **19** | **10** |
| tagged, role says otherwise | 13 | 20 |
| **total disagreeing** | **32** | **30** |

The disagreement is real and barely smaller — but its **composition changes
materially**. Half of what I read as "the role invented a counter out of nowhere"
was the tag list failing to name tags that were sitting right there.

**AND IT IS THE SAME DEFECT AS R136, COMMITTED THE SAME HOUR.** R136 is about a
validator that carried its own hand-typed copy of a vocabulary instead of
deriving it from the catalogue. R135 then hand-typed its own counter-tag list
instead of deriving it from the catalogue. The rule R136 earned applies to
analysis exactly as it applies to gates: **derive the vocabulary from the thing
you are measuring; never type your own copy of it.**

C97's verdicts over the 32: **ROLE IS RIGHT 7 · TAG IS RIGHT 11 · THE VOCABULARY
IS THE PROBLEM 14 · UNDECIDED 0.** The largest bucket is the vocabulary one, and
C97's summary of why is worth keeping: the data uses `counter` for **at least
four different ideas** — the action itself, reactive timing, readiness for a
later action, and a multi-action response chain.

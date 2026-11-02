# INPUT FOR U60 — the operator's BJJ belt progression checklist, and what it misses

Supplied by the operator 2026-09-12 as `bjj_belt_progression_checklist.pdf`.
Transcribed here so the U60 researcher has it without needing the file.

**STATUS OF THIS SOURCE: USEFUL SKELETON, NOT A FEDERATION SYLLABUS.** The PDF's
own footer reads *"This is for informational purposes only ... AI responses may
include mistakes."* So it is **INFERENCE-grade**: treat its BAND STRUCTURE as a
strong starting point and every individual entry as a claim to verify against a
named source (IBJJF, Gracie Barra, Alliance — they differ, and which one is used
must be stated).

---

## What it contains — 27 checkpoints in three bands

### White → Blue — "The Foundations & Survival"
**Positional Escapes & Survival:** shrimping & bridging (mount → guard) ·
frame & recomp (side control → guard) · seatbelt counter (back escape / hand
fighting) · posturing up (breaking closed guard)
**Guard Passing & Sweeps:** torreando (bullfighter) pass · knee cut pass ·
scissor sweep · hip bump / kimura sweep
**Takedowns & Submissions:** double leg · straight armbar (closed guard and
mount) · kimura / americana (from side control) · rear naked choke

### Blue → Purple — "Game Development & Transitions"
**Advanced Guard Systems:** De La Riva · single leg X / X-guard · half guard /
deep half
**Dynamic Transitions & Passes:** over-under / leg drag · back takes from guard
(arm drags, berimbolo entries) · submission chains (armbar → triangle → kimura)
**High-Percentage Offense:** triangle choke · guillotine · straight ankle lock
(ashi garami)

### Purple → Brown & Black — "Mastery & Systemization"
**Advanced Open Guards & Submissions:** spider & worm guard · heel hooks
(inside/outside) · kneebars & toe holds
**High-Level Concepts & Systems:** the 32 principles · counter-passing systems ·
teaching & strategy

---

## THE BAND STRUCTURE IS THE VALUABLE PART

It maps onto the contract's tiers almost directly, and it is exactly the
"expertise progression" axis the operator asked for:

| PDF band | our tier |
|---|---|
| White → Blue | 1 Foundation |
| Blue → Purple | 2 Core |
| Purple → Brown | 3 Advanced |
| Black | 4 Signature |

**But the PDF merges purple, brown AND black into one band, so tier 4 has no
content of its own.** Splitting brown from black is part of the job.

---

## WHAT IT IS MISSING — and this is why U60 is still a research task

**1. IT IS A CHECKLIST, NOT A VOCABULARY.** Several entries are CONCEPTS rather
than techniques — "The 32 Principles", "Teaching & Strategy", "Submission
Chains", "Counter-Passing Systems". In our schema those are `kind: "skill"`, not
`kind: "move"`, and they carry no `range_band`. Do not emit them as moves.

**2. WHOLE SUBMISSION FAMILIES ARE ABSENT.** Against the operator's stated 30–60
root families, this lists roughly a dozen. Not present and expected:
- **Chokes:** bow-and-arrow · cross-collar / lapel · Ezekiel · arm-triangle
  (kata gatame) · D'Arce · anaconda · north-south · clock · baseball bat
- **Joint locks:** omoplata · gogoplata · wrist locks · bicep and calf slicers
  (**flag these — illegal under many rulesets**)

**3. POSITIONS ARE IMPLIED, NEVER NAMED.** Knee-on-belly, north-south, turtle
and 50/50 all appear nowhere, yet BJJ is a positional art before it is a
submission art. Several should be `kind: "skill"` control nodes.

**4. SWEEPS AND PASSES ARE THIN.** Sweeps: flower/pendulum, butterfly, X-guard,
tripod/sickle, lumberjack. Passes: stack, long step, smash, folding, body lock.

**5. TAKEDOWNS ARE ONE ENTRY.** Only the double leg. BJJ competition uses the
single leg, ankle pick, arm drag to the back, and a real slice of judo — osoto
gari, seoi nage, uchi mata. **U60 also covers judo, so cross-reference rather
than duplicating: a throw shared by both arts should be ONE id, referenced by
both, not two ids with different names.**

**6. NO GI / NO-GI AXIS, AND IT MATTERS MORE THAN ANY OTHER OMISSION.** Spider,
worm and lapel guards are **gi-only**; heel hooks are effectively **no-gi** under
most rulesets. This is not a footnote for us: the game has an open question about
whether a gi can exist at all (Q63 — the twelve fighters are one mesh, one
material, so a gi is a SHAPE we cannot currently make). **A discipline whose
tier-3 content is gi-dependent needs that flagged per node**, so the engine can
refuse gi-only techniques in a no-gi ruleset.

**7. NO LEGALITY AXIS.** Heel hooks and slicers are banned below brown belt under
IBJJF and banned outright in some promotions. We already have
`assets/data/combat_rulesets.json`. Nodes that are ruleset-restricted must say
so, or the simulation will score a technique that would have been illegal.

---

## Instruction to the researcher

**Use the band structure. Verify every entry. Fill the six gaps above.** Where the
checklist and a named federation syllabus disagree, report the disagreement
rather than silently picking one — that is a finding, not a nuisance.

# THE TECHNIQUE CATALOGUE CONTRACT — how a discipline gets researched and added

Written 2026-09-12 by Claude, on the operator's instruction: *"i want a separate
deep analysis on all available technique separate for each discipline, i want
them all in the game ... we have to categorize them by expertise so the research
needs to be a real research and it should show the real progression on getting a
black belt in karate for example."*

**Every per-discipline research task points here for its schema and its rules.
Read this once; your own task file carries only the discipline.**

---

## 1. THE FINDING THAT STARTED THIS

`Godot/assets/data/technique_catalog.json` holds **15 disciplines and 272
technique nodes**, and the distribution is the tell:

| | nodes | branches |
|---|---:|---:|
| Boxing | 18 | 5 |
| Kickboxing | 18 | 5 |
| Muay Thai | 18 | 5 |
| Wrestling | 18 | 5 |
| **Brazilian Jiu-Jitsu** | **20** | **6** |
| Judo | 18 | 5 |
| Karate | 18 | 5 |
| Taekwondo | 18 | 5 |
| Sanda, Sambo, Savate, Capoeira, Arnis, Pencak Silat, MMA | 18 each | 5 each |

**Fourteen of fifteen disciplines have identical vocabulary sizes.** Real martial
arts do not. That is a fixed-size template filled in, not an art transcribed.

**The naming is genuine, which is why this is worth expanding rather than
replacing.** `karate_kizamizuki` is Kizami-zuki, `karate_gyakuzuki` is
Gyaku-zuki. Somebody knew the terminology and was working to an 18-slot frame.

**The real sizes, per the operator and checkable against published syllabi:**

| discipline | real vocabulary | we have |
|---|---|---:|
| Karate | 150–200 techniques | 18 |
| Muay Thai | ~55 base + 30 master (Mae Mai 15 + Luk Mai 15) | 18 |
| Judo | 68 nage-waza + 32 katame-waza | 18 |
| Brazilian Jiu-Jitsu | ~30–60 core submission root families | 20 |

---

## 2. A TECHNIQUE WITHOUT FILM STILL WORKS — THIS IS NOT AN ANIMATION TASK

**Say this out loud before worrying about the clip library.** The simulation
scores techniques from their `effects`; the presenter then tries to find a clip
and, when it cannot, degrades honestly (the man holds his guard and his opponent
still reacts — M19). **So a technique with no animation still changes the fight.**
It is simply not yet SEEN.

We own about 40 clips. Nothing in this contract asks anyone to buy or make more.
**Do not trim a discipline's real vocabulary down to what we can animate** — that
is exactly backwards, and the animation gap is tracked separately in R124.

---

## 3. THE SCHEMA, EXACTLY

Every node is an object in `disciplines[<i>].nodes`. This is the live shape, read
off `karate_gyakuzuki`:

```json
{
  "id": "karate_gyakuzuki",
  "name": "Gyaku-zuki",
  "kind": "move",
  "tier": 1,
  "branch": "punching",
  "requires": {
    "discipline": 20,
    "attributes": { "power": 30, "technique": 30, "speed": 28 },
    "prerequisites": ["karate_kizamizuki"],
    "reps": 130
  },
  "match": {
    "role": "damage",
    "phases": ["standing"],
    "effects": { "straight_damage": 9, "counter_accuracy": 5 },
    "range_band": ["LONG", "MID"],
    "range_delta": 0
  }
}
```

**Field rules:**

- `id` — `<discipline>_<romanised name, lowercase, no punctuation>`. Unique across
  the WHOLE file, not just the discipline.
- `name` — the technique's real name, properly spelled and hyphenated
  (`Gyaku-zuki`, `O-soto-gari`, `Sok Tat`). **Not an English paraphrase.**
- `kind` — `move` (a technique thrown in a fight), `skill` (a capability, like
  `karate_kamae`, that modifies rather than strikes), or **`sequence`** (a
  combination — see section 10). **AMENDED BY S1c, 2026-09-12.** This said
  `move | skill` and called `sequence` debt to be remapped. That was wrong: the
  engine fires a chain ONLY on `kind == "sequence"`, at seven sites, so
  remapping the 82 sequences to `move` would stop every combination in the game
  from firing. A sequence is the CHAIN; each of its links is a `move`.
- `tier` — 1 Foundation · 2 Core · 3 Advanced · 4 Signature. **This is the
  expertise axis and section 4 governs it.**
- `branch` — one of the discipline's own branches. The existing five are
  `movement`, `punching`, `kicking`, `timing_counters`, `combinations`; BJJ
  already has six. **You may add branches where the art demands it** — judo needs
  `nage_waza` and `katame_waza`, BJJ needs `guard` and `passing` — and you must
  list any you add.
- `requires.prerequisites` — the ids that must be learned first. **This is where
  the real progression lives.** It must form a DAG; no cycles.
- `requires.reps` / `requires.discipline` / `requires.attributes` — training cost
  and gates. Scale them with tier, consistently within the discipline.
- `match.role` — one of **ten**: `damage`, `setup`, `defense`, `control`,
  `counter`, `takedown`, `submission`, `transition`, `escape`, `adaptation`.
  **AMENDED BY S1c, 2026-09-12, and this was the expensive one.** This line used
  to read `damage, setup, defense, control, finish`.

  **`role` is not a label — it is the physics selector.**
  `FightSimulation._apply_landed_effect` dispatches on it, and only the
  `takedown` arm sets `phase = "GROUND"`, records `top_side`, prices the throw
  against the ruleset's scoring profile and can declare an **ippon that ends the
  bout**. `submission` accumulates an attempt; `control` scores position and
  drains stamina. Those are behaviours, not synonyms for `damage`.

  So the five-word list was never a target the catalogue was failing to reach.
  It was a smaller, different vocabulary that cannot express what the engine
  does — and authoring against it cost judo every throw it had. S1's merge left
  judo with **zero** `takedown` nodes: osoto-gari, uchi-mata and seoi-nage were
  each authored `"effects": {"takedown": N}` with `"role": "damage"`, which does
  health damage and leaves both men standing.

  **`finish` is DELETED.** Zero nodes ever carried it and zero code sites branch
  on it (U65 census: `roles_never_read=finish`). The corner emphasis `"finish"`
  at `FightSimulation.gd:718` is a pace call, not a technique role.

  **Role must agree with effects.** A node whose strongest effect is `takedown`
  carries role `takedown`; `Godot/tools/derive_technique_roles.py` derives that
  from the node's own authored weights and is re-runnable as a gate. The rule is
  ONE-DIRECTIONAL — a `takedown` effect implies the role, the converse does not,
  because a sweep is authored with `sweep` and `balance_break` instead.
- `match.phases` — `standing`, `clinch`, `ground`.
- `match.effects` — see section 5. **The single most important field.**
- `match.range_band` — any of `LONG`, `MID`, `POCKET`.
- `match.range_delta` — how the technique changes range; 0 if it does not.

---

## 4. TIER MUST COME FROM THE REAL SYLLABUS, NOT FROM TASTE

**This is the part the operator asked for specifically and it is what makes the
research real.** The four tiers must map onto the art's OWN published
progression, and you must state the mapping you used:

- **Karate** — the kyu/dan syllabus. 10th–7th kyu is Foundation, 6th–4th Core,
  3rd–1st Advanced, dan grades Signature. Cite the organisation whose syllabus
  you used (JKA, WKF, Shotokan, Kyokushin — they differ, and saying which one is
  the difference between research and assertion).
- **Judo** — the Kodokan Gokyo no Waza is already ordered by teaching sequence:
  its five kyo map almost directly onto tiers, with shinmeisho-no-waza as
  Signature.
- **Muay Thai** — base arsenal is Foundation/Core; **Mae Mai** (the 15 major
  master techniques) and **Luk Mai** (the 15 minor) are Advanced/Signature.
- **BJJ** — the belt syllabus, white through black.

**If an art has no formal syllabus, say NOT FOUND and tier by teaching order from
a named instructional source.** Do not invent a grading system.

---

## 5. EFFECTS ARE THE PART THAT REACHES THE SIMULATION

`match.effects` is what the engine actually reads. **Use effect keys that already
exist in the file** wherever the technique fits one — a new synonym for an
existing key is worse than no key, and this project has already measured the
damage: **55 distinct effect keys across 184 authored entries are read by NOTHING
in the code**, many of them duplicates of keys that ARE read (`angle_read` for
`angle_attack`, `angle_reset` for `angle_exit`). See `U59_THE_UNREAD_EFFECTS.md`.

**So: grep the existing catalogue for an effect key before you coin one.** If you
must coin one, list it separately at the top of your report under NEW EFFECT KEYS
so it can be wired deliberately rather than discovered two months later.

---

## 6. RULES FOR THE RESEARCH ITSELF

**LABEL EVERY CLAIM.** **DOCUMENTED** (a published syllabus, a federation
grading list, a named instructional text — name it and link it), **INFERENCE**
(your reasoning, and from what), **NOT FOUND** (you looked and it is not
published — a good answer, and we want it explicitly).

**NAMES AND COUNTS MUST BE REAL OR MARKED NOT FOUND.** A fabricated technique
name is the worst possible output here: it is unfalsifiable, it looks
authoritative, and it ships. This project has already been burned twice by
plausible-sounding assertions — a whole animation category declared not to exist
anywhere (a ten-euro listing disproved it the same day), and three clip bindings
justified by sentences like *"a spinning elbow IS a horizontal elbow"* that were
simply wrong when somebody finally watched them.

**DO NOT TRIM TO 18.** The frame is the defect. If karate has 150 techniques,
deliver 150.

**DELIVER TWO FILES:**
1. `research/<ID>_<DISCIPLINE>_TECHNIQUES.md` — the research: the full
   list, the syllabus mapping, the sources, the labels, and anything you found
   that contradicts the existing 18 nodes.
2. `research/<ID>_<discipline>_nodes.json` — the nodes themselves, as a
   JSON array matching section 3. **A separate file, NOT an edit to
   `technique_catalog.json`.** Claude validates and merges; a bad merge into the
   live catalogue would move every seeded fight in the game.

**DO NOT EDIT `technique_catalog.json`. DO NOT EDIT `HANDOFF.md`.**

---

## 7. WHAT CLAUDE DOES WITH IT

Validates the JSON against this schema, checks the prerequisite graph is acyclic,
checks every id is unique file-wide, checks effect keys against the read set, then
merges. **Merging changes what the simulation scores, so it moves seeded
verdicts by design and cannot ship silently** — same class as the counter-layer
and balance decisions still sitting with the operator.

---

## 8. THE TREE MUST MAKE SENSE AS DIFFICULTY, NOT ONLY AS SYLLABUS

*Operator, 2026-09-12: "i want the tree to make sense and by technique difficulty
and also have in mind cross over techniques".*

**`tier` and `prerequisites` answer two different questions and both must be
right.**

- **`tier` is WHEN THE ART TEACHES IT** — the syllabus position (section 4).
- **`prerequisites` is WHAT YOU PHYSICALLY CANNOT DO WITHOUT** — the mechanical
  dependency. You cannot throw a spinning back kick without being able to pivot;
  you cannot armbar from mount without holding mount.

**These two orders are NOT the same and pretending they are is how the current
tree stopped making sense.** A syllabus is a teaching sequence shaped by what is
safe to drill, what a grading examines, and tradition. It sometimes teaches an
easy technique late and a hard one early.

**So: tier from the syllabus, prerequisites from the mechanics — and where the
two genuinely conflict, SAY SO IN THE REPORT.** A technique graded at 4th kyu
whose mechanics require something taught at 1st kyu is a real finding about the
art, not a problem to smooth over. Put it under a heading `SYLLABUS/DIFFICULTY
CONFLICTS` and let the operator decide.

**A difficulty check you can apply to every node:** if a beginner with no other
training could be shown this technique once and do a recognisable version of it,
it is tier 1. If it needs a specific earlier technique in the body, it is tier 2+
and that earlier technique is its prerequisite. If it needs timing against a
resisting opponent, it is tier 3+. If it is a technique the art itself treats as
a mark of mastery, it is tier 4.

---

## 9. CROSS-OVER TECHNIQUES — ONE ID, OR TWO, AND THE TEST BETWEEN THEM

Fifteen disciplines share a great deal. **Getting this wrong produces either a
catalogue where the same move exists nine times under nine spellings, or one
where genuinely different techniques are collapsed into one and the disciplines
stop feeling different.**

**THE TEST: is it mechanically the same movement, or only the same NOUN?**

**SAME TECHNIQUE → ONE SHARED ID**, referenced by every discipline that has it:
- The **double leg** is a double leg in wrestling, BJJ, sambo, MMA and judo
  (*morote gari*). One id.
- **Osoto gari** is the same throw in judo, sambo, BJJ and MMA. One id.
- The **rear naked choke** is the same finish in BJJ, judo (*hadaka jime*), sambo
  and MMA. One id.

**SAME NOUN, DIFFERENT MOVEMENT → SEPARATE IDS**, and the report must say why:
- A **karate mawashi geri** and a **muay thai round kick** are both "roundhouse
  kicks" and they are not the same technique. The karate kick snaps from the
  knee and retracts; the muay thai kick swings through from the hip with the shin
  and does not retract. Different contact surface, different recovery, different
  counter-vulnerability. **Two ids.**
- A **boxing jab** and a **karate kizami-zuki** are both lead-hand straights with
  different stance, chamber and retraction. **Two ids.**
- **Taekwondo and karate side kicks** differ in chamber and hip. Check before
  merging.

**HOW TO RECORD IT.** When you find a cross-over, do not silently reuse another
discipline's id — you may not have seen that discipline's file. Put it in your
report under `CROSS-OVER CANDIDATES`, giving: the id you used, the other
discipline(s) you believe share it, and which case above it falls under.
**Claude reconciles across disciplines at merge time**, because no single
researcher sees all fifteen.

**MMA IS THE SPECIAL CASE AND IS MOSTLY REFERENCES.** "MMA Integration" is not a
sixteenth art with its own vocabulary — it is the rules under which the others
combine. Its nodes should overwhelmingly be cross-references to other
disciplines' ids, plus the genuinely MMA-only things: cage work, ground-and-pound
from inside the guard, the wrestling-to-striking transitions that exist only
because both are legal at once. **Do not give MMA 150 techniques of its own.**

---

## 10. COMBINATIONS ARE UNLOCKED BY THEIR COMPONENTS — THIS IS THE SHAPE OF THE TREE

*Operator, 2026-09-12, giving the worked example:*

> **Step 1: The Setup — Kizami Zuki (Leading Blitz Jab).** From Zenkutsu-dachi you
> explosively push off the back leg... an offensive decoy, to force the hands up
> and close distance.
> **Step 2: The Power — Gyaku Zuki (Reverse Punch).** The millisecond the front
> foot lands, violently rotate hips and shoulders, firing the rear hand down the
> centre line. Because the jab forced their hands up, the midsection is exposed.
> **Step 3: The Finisher — Mawashi Geri (Rear Roundhouse).** As the punch retracts,
> pivot 90 degrees on the front foot, chamber the rear leg, whip the kick into the
> ribs or neck. The previous punch pre-loads the hips.
>
> **then you unlock the combo:** the Jab-Cross-Roundhouse Blitz.

**THE RULE, AND IT IS NOT OPTIONAL:**

> **A combination node's `prerequisites` ARE its component techniques — every one
> of them, by id.**

```json
{
  "id": "karate_blitz_combo",
  "name": "Kizami-zuki – Gyaku-zuki – Mawashi-geri (Blitz)",
  "kind": "sequence",
  "branch": "combinations",
  "chain": ["karate_kizamizuki", "karate_gyakuzuki", "karate_mawashigeri"],
  "requires": {
    "prerequisites": ["karate_kizamizuki", "karate_gyakuzuki", "karate_mawashigeri"]
  }
}
```

**THE `kind` IN THIS EXAMPLE WAS `move` UNTIL S1c, AND IT WAS WRONG.** It is the
line the contract test quoted when it declared `sequence` a violation. A
combination is `kind: "sequence"` and carries a `chain` of the ids it plays, in
order; its **links** are `kind: "move"`, which is what the engine requires and
what `combo_chains_test` checks. `prerequisites` and `chain` are both present and
they are not the same thing — prerequisites gate LEARNING it, the chain is what
it THROWS.

**Why this matters more than it looks.** It is what makes the tree a TREE rather
than a list with tier numbers on it. A player who has learned three techniques
has earned the combination that chains them; a player who has learned two has
not. The progression falls out of the vocabulary instead of being asserted on top
of it, and `tier` stops carrying the whole weight.

**It is also the honest model of how the arts teach.** Nobody drills the blitz
before they can throw a gyaku-zuki. The combination is not a harder technique; it
is the same three techniques with the timing between them.

**THE STATE OF PLAY WHEN THIS WAS WRITTEN, so nobody thinks it is already done:**
C95 delivered **160 karate nodes and exactly ONE** node in the `combinations`
branch — `karate_sanbon_chain`, whose single prerequisite is `karate_agezuki`
rather than the three punches it chains. The techniques are there and the
combinations are not.

**WHAT EVERY DISCIPLINE OWES:**
1. A `combinations` branch with real entries — the named, taught chains of that
   art. Boxing's one-two and one-two-hook. Muay thai's teep-cross-round kick.
   Karate's blitz. Judo's renraku-waza (combination attacks) and renzoku-waza.
   BJJ's submission chains — armbar to triangle to omoplata.
2. Every one of them listing **all** its components in `prerequisites`.
3. The component techniques existing as their own nodes first.

`tools/validate_technique_nodes.py` enforces the shape: a node in the
`combinations` branch with fewer than two prerequisites is an ERROR, because a
combination of one thing is not a combination.

---

## 11. `grade` — BECAUSE FOUR TIERS CANNOT TELL WHITE BELT FROM BROWN

*Operator, 2026-09-12: "it has to be distinguishable which moves are required to
get white belt and which are for the brown belt for example".*

**`tier` is four values. Karate has nine or ten kyu grades and then dan grades.
Four buckets cannot express that, and squashing a syllabus into them throws away
the exact thing the research was for.**

So every node gains **two new required fields**:

```json
"grade": "6th kyu",       // the art's OWN rank name, verbatim
"grade_rank": 4           // ordering: 1 = the very first thing taught
```

- **`grade`** is a string in the art's own vocabulary — `"8th kyu"`,
  `"blue belt"`, `"3rd dan"`. **Never a paraphrase, never "beginner".** It is what
  a practitioner of that art would call it, and it is what the UI will show.
- **`grade_rank`** is a monotonic integer for sorting and gating. 1 is the first
  technique a newcomer is taught. It does not have to be dense.
- **`tier` STAYS** — it is the coarse axis the simulation already uses and four
  buckets are right for that. It is now DERIVED from `grade`, not a substitute
  for it.

**THE GRADE VOCABULARIES.** Use the art's own; state the organisation.

| art | grades | note |
|---|---|---|
| **Karate** | 9th–1st kyu, then 1st dan upward | colours differ by organisation — Shotokan/JKA differs from Kyokushin. **Name yours.** |
| **Judo** | 6th–1st kyu, then dan | Kodokan; colours differ by country |
| **BJJ** | white, blue, purple, brown, black | plus stripes, which we do NOT model |
| **Taekwondo** | 10th–1st geup, then dan | Kukkiwon or ITF — they differ |
| **Muay Thai** | **NOT FOUND** | Thailand has no traditional belt system. Use `base`, `mae_mai`, `luk_mai` as the grade strings and say so. |
| **Boxing** | **NOT FOUND** | no graded syllabus at all. Use `novice`, `intermediate`, `advanced`, `elite` from coaching teaching order, and label INFERENCE. |
| **Kickboxing** | varies | some WAKO-affiliated clubs grade, many do not. If NOT FOUND, follow boxing's pattern. |

**Inventing a belt system for an art that has none is worse than saying NOT
FOUND.** Boxing has no grades; pretending otherwise would ship a lie that looks
like research.

---

## 12. BUILD THE TREE FROM THE COMBINATIONS BACKWARD

*Operator: "find which moves make combos and do all trees based [on] that and
based on how difficult are the moves to execute".*

Sections 8 and 10 gave the two halves. This is the method that joins them, and it
is the order the work should actually be done in:

1. **List the art's REAL, NAMED combinations first** — the chains that art
   actually teaches and drills. Karate's blitz. Boxing's one-two-hook. Muay thai's
   teep–cross–round kick. Judo's renraku-waza. BJJ's armbar–triangle–omoplata.
   **These are documented; they are not for you to invent.**
2. **Decompose each into its component techniques.** Those components are now
   REQUIRED nodes — the vocabulary is derived from what the art actually chains,
   not from a list somebody thought looked complete.
3. **Rank the components by execution difficulty** (section 8's test: can a
   beginner do a recognisable version? does it need a prior technique in the body?
   does it need timing against resistance? is it a mark of mastery?).
4. **Place each at its real `grade`** from the syllabus (section 11), and derive
   `tier` from that.
5. **The combination node then sits at the grade of its HARDEST component, or
   later** — never earlier. A chain cannot be taught before its pieces.

**THE CHECK THAT FALLS OUT OF THIS, and the validator enforces it:** every
combination names all its components, and no component has a higher `grade_rank`
than the combination that uses it. A tree built this way is coherent by
construction rather than by assertion.

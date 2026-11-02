# K74_TECHNIQUE_MODAL_STATES.md

**Job:** The words on the technique skill-tree modal in each of its four clip states.
**Not the job:** Layout/geometry (UI task), colour/treatment (M26), wiring EXACT/NEAR keys (Q133), fight-presenter missing-clip policy (M19).

**Budget:** label chip <=**14** · line <=**60**. Counts in `(n)`.

**Catalogue facts used (checked 2026-09-22 on `technique_catalog.json`):** 696 nodes · `skill` 162 · `move` 452 · `sequence` 82 (534 motion). Task numbers 162 / 534 / ~519 unbound match this split; unbound count falls as Q133 and clip work land.

---

## Three lines first

1. **The load-bearing sentence:** NEAR — `Same motion under another name - not this technique.` (52)
2. **The sentence I would fight hardest to keep:** NO MOTION — `No motion by design - this is an attribute, not a throw.` (56) — stops 162 passives reading as broken gaps.
3. **Least sure:** Whether firing NEAR is **COMPUTED** today. Q133 will mark NEAR on technique-id bindings; that field is not on disk yet. The sentence is written; the gate is **NOT COMPUTED** until Q133 lands.

---

## What already answers part of this (index grep)

| Prior | What it owns | How K74 uses it |
|---|---|---|
| **M19_THE_MISSING_CLIP** | Fight presenter: never silently play a *different* technique's clip as the named one; drop picture, keep ledger | **Builds on** the honesty rule. **Does not contradict** for the fight beat. Skill-tree **NEAR** is a *labelled* browsing stand-in on a different surface — not silent fight substitution. |
| **TECHNIQUE_CATALOGUE_CONTRACT** | `kind`: move / skill / sequence; sim scores from `effects`; no-film technique still works | State 3 line leans on effects; state 4 = `kind == skill` |
| **S4H_CATALOGUE_FIELDS** | Presenter historically binds by **role**, not technique id; `clip_role` sparse | Explains why most tree nodes look unbound today |
| **R124** | Clip count strategy; do not buy hundreds | State 3 must not apologise or promise a date |
| **K70 / K72** | Do not lie about wiring; COMPUTED / NOT COMPUTED | Same discipline on this modal |
| **TASK_Q133** | Will add technique-id EXACT / NEAR / NONE bindings and a NEAR field | State 1–3 gates become fully COMPUTED after that lands |
| **TASK_M26** | Art treatment for the same four states; **no copy** | Sibling — Maria owns look; K74 owns words |

**Negative result (do not re-run):** M19 already rejected generic secretly sold as the named technique and casual purchase-list growth. K74 does not reopen that.

---

## Labels

| Label | Meaning |
|---|---|
| **COMPUTED** | Catalogue field or binding the engine can know today (or will know via the named gate once Q133 lands — called out per row) |
| **NOT COMPUTED** | Asserts a distinction or promise the engine cannot know yet |
| **INFERENCE** | Design rule for when to show the state, not an engine claim |

---

## 1. Four states — label · line · honesty

| State | Label | (n) | Line | (n) | Honesty |
|---|---|---:|---|---:|---|
| **1. PLAYING** | `EXACT CLIP` | 10 | Own clip bound - this is the named technique on film. | 53 | **COMPUTED** when a technique-id binding exists and is **not** marked NEAR (~15 ids resolve by own id today per Q133 task text; grows as binds land). |
| **2. NEAR** | `NEAR MATCH` | 10 | Same motion under another name - not this technique. | 52 | Line is the contract. **Gate NOT COMPUTED today** — no NEAR field on bindings yet (Q133). After Q133: **COMPUTED** when binding is marked NEAR. |
| **3. NO CLIP YET** | `NO CLIP YET` | 11 | No clip bound yet - the move still scores from effects. | 55 | **COMPUTED** — `kind` in {move, sequence} and no technique-id clip. Effects claim **COMPUTED** per catalogue contract (sim from effects, film optional). Do not apologise; do not date. |
| **4. NO MOTION** | `NO MOTION` | 9 | No motion by design - this is an attribute, not a throw. | 56 | **COMPUTED** — `kind == skill` (162 nodes). Never a gap. |

**INFERENCE:** Prefer state 4 over state 3 whenever `kind == skill`, even if someone later attaches a decorative clip. Passives are not unbound moves.

---

## 2. A — THE NEAR SENTENCE (the whole task)

### Winner

**`Same motion under another name - not this technique.`** (52)

Works for lead≠check hook, kick retargets, throw re-entries: it names the relation (same motion / other name) and the refusal (not this technique), without listing the kind of nearness.

### Runners-up rejected

| Rejected (n) | Why not |
|---|---|
| `Not exact - showing the nearest motion we own.` (46) | Leads with fault language (Not exact). M26 trap: NEAR must not read as a warning. Nearest we own also sounds like scarcity apology. |
| `Similar clip only - we do not have this one filmed.` (50) | Collapses NEAR into NO CLIP YET. Admits absence instead of useful stand-in; will feel wrong as coverage grows. |

### What NEAR must never do visually-in-words

Do not put the hovered technique's name in the line as if the clip is that name. The chip already carries the node title; the line's job is the mismatch.

---

## 3. B — STATE 4 instead of a viewport

**Line:** `No motion by design - this is an attribute, not a throw.` (56)

**Instead of a viewport (words only — no layout):** show a **facts strip** of what the skill changes on the fighter — the catalogue fields that already exist for that node (branch / requires / match effects / grade), titled as attributes or reads, not as an empty stage waiting for film. The modal is a **different kind of card**, not a card with a hole.

**INFERENCE:** If the node has no useful effect text yet, still keep the NO MOTION chip and line; leave the facts strip sparse rather than swapping to NO CLIP YET.

---

## 4. C — WHAT THE MODAL MUST NEVER SAY

Quiet lies (K70 / K72 discipline):

1. **Animation coming soon / Clip next patch / any date** — nobody has scheduled one; state 3 must stay undated.
2. **Hovered technique name over a NEAR clip as if it were EXACT** — silent M19 substitution on a UI surface.
3. **Missing animation / Preview unavailable / Broken on a skill** — those 162 will never have motion; failure chrome is the lie.
4. **Similar enough / Close enough without not this technique** — softens the mismatch into false identity.
5. **Any claim the engine throws or simulates a technique it only has as catalogue text** — film is not fight authority; effects are. Do not imply the preview is the sim.
6. **Apology copy on state 3** (sorry, still working, bear with us) — 519 unbound today, falling weekly; grovel ages badly.
7. **Warning / danger chrome wording on NEAR** (caution, wrong clip, error) — stand-in is honest and useful, not a fault (aligns with M26 trap).

---

## 5. Builder wiring note (honesty)

| Need | Today |
|---|---|
| `kind == skill` → state 4 | **COMPUTED** — catalogue |
| `kind` in {move, sequence}, no technique-id clip → state 3 | **COMPUTED** — empty bind |
| Technique-id EXACT bind → state 1 | **COMPUTED** for the ~15 that resolve by id; sparse |
| Technique-id NEAR bind → state 2 | **NOT COMPUTED** until Q133 adds the NEAR field |
| Role-only FightClipBinding.clip_for(role) as tree preview | **NOT COMPUTED** as EXACT for a named technique (S4H) — do not pretend role film is that node |
| Effects still apply with no film | **COMPUTED** — catalogue contract |
| Promise a ship date for unbound film | **NOT COMPUTED** |

---

## 6. Acceptance

1. Four states each have label <=14, line <=60, honesty tag.
2. NEAR has one winner + two rejected runners-up with reasons.
3. State 4 names what replaces the viewport, in words.
4. Never-say list present.
5. Index priors cited; M19 tension stated; no geometry; no colour.
6. State 3 does not apologise or date.

---

**K74 complete.** Words only; M26 paints; Q133 wires the NEAR bit.

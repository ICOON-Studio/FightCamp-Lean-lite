# M27_SIGNATURE_BATTLE.md

Maria Art Director · 2026-09-22 · art only — STATE and treatment; **no geometry** (UI owns pixels); **no copy** (Kalli owns sentences)

Cage Desk + M22 tokens + M23–M26 discipline. Skill-tree row: mark **the hinge duel** (FIGHT_PLANS_RESEARCH §3 part 6 — signature battle per discipline).

## Three lines

1. **Fight hardest:** keep the hinge **quieter than selection** — pointer stays loudest.
2. **Keep only one channel:** a **1-bit hinge glyph** (diamond) on the leading edge — greyscale + CVD safe; not a second rim war with focus.
3. **Least sure:** whether a weak+unlearned hinge needs extra chrome — **verdict below: no**; weakness rides a separate mastery channel, not danger-on-the-hinge.

---

## Index build-on

| Doc | Use |
| --- | --- |
| **FIGHT_PLANS_RESEARCH.md §3** | Seven parts; part 6 = signature battle (jab / kumi-kata / guard-vs-pass / tie-up / clinch entry / cage / distance / catch) |
| **M22** | Tokens only — no new hex |
| **M25** | Selection/focus louder than standing properties; hollow link = focus; accent+check = accepted |
| **M26** | Same screen family; near = candour not warning — hinge similarly **not** warning |
| **M23** | Danger chrome reserved for medical/stoppage class — **do not reuse on hinge** |

---

## DECISIONS

1. Hinge channel = **diamond glyph** + optional **thin leading inset** (`color_sunken` strip treatment) — standing property, always on.
2. Selection/hover stay **louder** (M25 rims); hinge never adds a competing outline.
3. **One hinge mark per phase column** on screen; if five phases visible, five small diamonds OK — same quiet treatment, never banners.
4. Weak+unlearned hinge: **do not** add danger/warning chrome to the signature mark — mastery/readiness meter (or absence) carries that; hinge glyph unchanged.
5. Greyscale/CVD: glyph shape + inset vs flat row — hue optional backup only.
6. M22 tokens only.

---

## 1. THE CHANNEL (not hue)

| Priority | Channel | Carries |
| --- | --- | --- |
| 1 | **Hinge glyph** — 1-bit **diamond** (◇) at leading edge of the row | “This is the duel that decides the plan” |
| 2 | **Leading inset** — row ground uses a narrow `color_sunken` inset behind the glyph only | Quiet ground cue when glyph is missed |
| 3 | Hue | **Forbidden as sole cue** — trichromat backup at most (`color_text_secondary` ink on glyph) |

**Why not “selected” chrome:** selection = where the player IS (M25). Hinge = what the plan IS. Different jobs.  
**Why not “important” star/gold:** `color_verdict` / champion metal are reserved (M22); hinge is structural, not a trophy.  
**Why not warning:** signature is true when he is excellent at it too (trap refused).

---

## 2. FOUR STATES ON ONE ROW (stack without Christmas tree)

Orthogonal flags: `signature` | `hovered` | `selected` | `known`.

**Loudness order (who wins the outline):**

1. **`selected`** — loudest — M25 accepted/focus family: hollow `color_link` rim if focus-selected, or accent keyline if committed selection (UI owns which).
2. **`hovered`** — if not selected: lighter link wash on hairline only — **no second heavy rim**.
3. **`signature`** — always-on diamond + inset — **never a rim**.
4. **`known`** — small **check pip** trailing or beside label weight 500 — not a rim.

| Combo | What shows |
| --- | --- |
| signature only | diamond + inset |
| signature + hovered | diamond + inset + soft hairline lift |
| signature + selected | diamond + inset + **selection rim** (rim wins loudness) |
| signature + known | diamond + inset + known pip |
| all four | diamond + inset + selection rim + known pip — **max two rims forbidden**; only selection may rim |

**Christmas-tree ban:** never stack accent rim + link rim + warning hatch + diamond outline. Cap: **one rim (selection/hover) + hinge glyph + optional known pip**.

---

## 3. ONE PER PHASE, OR ONE PER SCREEN?

**Draw: one signature mark per phase column** (tree is cut by phase; each phase may have its own hinge).

| If | Treatment |
| --- | --- |
| One phase visible | One diamond — still quiet |
| Five phases visible | Five diamonds — **same small glyph**, no size escalation |
| Temptation to shout when count &gt; 1 | **Refuse** — a mark that appears five times must stay the quietest treatment or it stops being a mark |

Not “one per whole screen only” — that would hide phase-local hinges (clinch tie-up vs distance jab). Not “banner per row” when multiple show.

---

## 4. THE NEGATIVE CASE (weak + unlearned hinge)

Most important *fact* on screen; wrong *dress* confuses hinge with stoppage.

**Verdict: do NOT give the signature mark its own danger/warning treatment.**

| Channel | Who owns weakness |
| --- | --- |
| Hinge diamond | Unchanged — still “this is the duel” |
| Mastery / readiness fill (if the row has one) | Shows unlearned / weak — M23-style fill% if present |
| M23 `color_negative` / hatch / doctor | **Reserved** for medical/region/gas danger — second job refused |

If the row has **no** mastery meter yet: still **do not** paint the diamond amber/red. Prefer showing weakness elsewhere (phase summary, readiness chip) over overloading the hinge glyph.  
**“Do not mark weakness on the signature chrome”** is the answer — marking the hinge as danger makes excellence-at-hinge and failure-at-hinge look like the same class of chrome.

---

## 5. GREYSCALE AND CVD

| Channel | Greyscale | Red–green CVD |
| --- | --- | --- |
| Diamond glyph shape | Primary | Primary |
| Leading sunken inset vs flat neighbours | Secondary | Secondary |
| Selection rim (hollow) vs no rim | Player location | Same |
| Known pip shape | Tertiary | Tertiary |
| Hue on glyph | Backup only | Do not rely |

---

## 6. NEVER

1. **Never louder than selection** — no heavy accent rim for hinge alone.
2. **Never warning/danger/hatch on the hinge mark** — not a fault state.
3. **Never `color_verdict` / `color_champion` on hinge** — reserved metals.
4. **Never continuous throb** on the diamond.
5. **Never escalate glyph size** when multiple phase hinges are visible.
6. **Never invent new hex** — M22 only.
7. **Never write the hinge sentence** — Kalli.

---

## Cheat sheet

| Flag | Chrome |
| --- | --- |
| signature | ◇ + leading sunken inset |
| hovered (not selected) | soft hairline lift |
| selected | selection rim (wins) |
| known | small check pip |
| weak/unlearned | not on hinge — mastery/other channel |

---

## Agent reader note

UI geometry owns pixels. Kalli owns words. You own **signature / hover / selected / known stacking** with hinge quieter than pointer. Claude lands; Maria does not edit HANDOFF.

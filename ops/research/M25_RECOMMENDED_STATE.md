# M25_RECOMMENDED_STATE.md

Maria Art Director · 2026-09-22 · art only — CONTAINER state and treatment; **no geometry** (G65 owns every pixel); **no copy** (K72/K73 own sentences)

Cage Desk + M22 tokens + M23/M24 discipline (never hue-only; never continuous throb; few named states).

## Three lines

1. **Fight hardest to make unmistakable:** **`accepted` vs `focused`** — most UIs draw both as “blue outline”; here they must diverge at a glance.
2. **Keep only one channel:** **commitment glyph + accent keyline on accepted** (greyscale-safe, CVD-safe).
3. **Least sure:** how strong the danger chrome can be inside a fixed slot without looking like a second UI — treatment below; layout must not grow the box.

---

## DECISIONS

1. Recommended vs alternate = **role chrome** (keyline weight + surface token + optional REC mark), not hue alone.
2. Three control states: **`focused` / `accepted` / `idle`** (neither) — orthogonal to recommended vs alternate.
3. Lock ≠ disabled — lock keeps full ink; adds lock glyph; freezes accepted chrome.
4. Danger = **steady negative keyline + hatch band on container chrome** — same slot; no pulse; no resize.
5. Reuse M22 only — **no new hex tokens**.
6. Never list at bottom.

---

## References (taken / refused)

| Source | Taken | Refused |
| --- | --- | --- |
| **M23 region readout** | Second channel beside colour; doctor ≠ redder red | Hue-only severity |
| **M24 gas instrument** | Steady danger rim; no continuous throb | Throbbing attention steal |
| **FM / dense sim confirm rows** | Clear “selected will apply” vs keyboard focus | Focus==selection |
| **OS focus rings (Win/macOS)** | Hollow focus rim ≠ filled selection | Collapsing both into one blue |

---

## 1. RECOMMENDED vs ALTERNATE

Channels in **priority order** (first survives greyscale; first two survive red–green CVD):

| Priority | Channel | Recommended (560-class slot) | Alternate (chip) |
| --- | --- | --- | --- |
| 1 | **Keyline weight** | `color_accent` keyline **2× hairline visual weight** (treatment: “heavy accent edge”) | `color_hairline` single hairline |
| 2 | **Surface** | `color_panel` (raised) | `color_sunken` |
| 3 | **Mark glyph** | 1-bit **REC mark** (chevron/dot — chrome, not sentence) | no mark |
| 4 | **Label weight** | weight **600** on title line | weight **500** |
| 5 | **Hue** | accent edge (trichromat backup only) | none |

**Greyscale:** heavy edge + raised vs sunken + REC mark still order recommended above alternate.  
**CVD:** same — no dependence on red≠green.

Hue alone is **forbidden** as the sole recommended cue.

---

## 2. FOCUSED vs ACCEPTED vs IDLE (three states)

Orthogonal to recommended/alternate. A chip can be focused; the recommended slot can be accepted.

| State | Treatment | Carries |
| --- | --- | --- |
| `idle` | Hairline only; `color_text_secondary` on non-title chrome | Neither focus nor commit |
| `focused` | Hollow **`color_link` rim** (1px family) — **no fill behind rim** | “Input is here” — temporary |
| `accepted` | **`color_accent` keyline** + **1-bit check glyph** + title weight **700** | “This runs next round” — committed |

**Glance rule:** hollow link rim = focus; check + accent keyline = accepted.  
**Never** use the same outline style for both.  
If recommended is focused but not yet accepted: REC mark + hollow link rim, **no check**.  
If accepted: check wins; link rim off.

---

## 3. THE LOCK AT REST 0:10

| | Locked | Disabled (refuse for this tray) |
| --- | --- | --- |
| Ink | **`color_text` / secondary as normal** — full contrast | `color_text_disabled` |
| Chrome | Last **`accepted`** treatment **frozen** | Grey wash / sunken dead |
| Glyph | Small **lock glyph** beside check | none / block icon that says “broken” |
| Focus | No focus rim possible | Looks like missed input |
| Read | “Set — clock owns it now” | “I broke something” |

**Lock rule:** locked = accepted chrome + lock glyph + no further focus/accept changes.  
**Never** restyle lock as disabled greying — that is the “manager thinks he missed something” failure.

Optional one-shot: on lock instant, rim `color_link` **200 ms** then settle to locked chrome (M23/M24 family). No loop.

---

## 4. THE DANGER CASE

Severity high → danger sentence sits in the **same** recommended slot (G65: no size change, towel does not move). Copy is K72 — you only dress the **container**.

| Channel | Danger recommended treatment |
| --- | --- |
| Keyline | Steady **`color_negative`** edge (not link, not pulse) |
| Hatch | **45° hatch band** on container chrome (M23/M24) |
| Glyph | Keep REC/check rules; add **stop-class mark** only if accepted path is the danger line — still chrome, not new sentence |
| Weight | Title weight **700** |
| Hue | Negative edge = trichromat backup only |

**Refuse even though legible:**
- Grow/move the slot or towel — crosses G65.
- Continuous throb/pulse — M24 ban; steals the live clock.
- Full-screen flash / blood / gore — hobby; not FM density.
- Hue-only red fill with no hatch/keyline change — fails CVD.
- Swap in a second “danger panel” — geometry collision.

---

## 5. NEVER

1. **Never hue-only** recommended vs alternate (green vs grey, red vs blue with identical weight/edge).
2. **Never draw focus and accepted with the same outline.**
3. **Never style lock as disabled** (`color_text_disabled` wash).
4. **Never continuous throbbing** on danger or recommended.
5. **Never specify or rewrite the instruction sentence** — container only (K72/K73).
6. **Never invent new hex** — M22 tokens only (`color_accent`, `color_link`, `color_negative`, `color_panel`, `color_sunken`, `color_hairline`, `color_text`, `color_text_secondary`).

---

## State × chrome cheat sheet

| Condition | Keyline | Glyph | Surface | Weight |
| --- | --- | --- | --- | --- |
| Recommended + idle | accent heavy | REC | panel | 600 |
| Recommended + focused | accent heavy + link hollow rim | REC | panel | 600 |
| Recommended + accepted | accent heavy | REC + check | panel | 700 |
| Alternate + idle | hairline | — | sunken | 500 |
| Alternate + focused | hairline + link hollow rim | — | sunken | 500 |
| Alternate + accepted | accent (chip) | check | sunken→panel lift treatment | 700 |
| Any + locked | freeze accepted | check + lock | freeze | freeze |
| Recommended + danger | negative steady + hatch | REC (± check if accepted) | panel | 700 |

---

## Agent reader note

G65 owns geometry. K72/K73 own words. You own **recommended / focused / accepted / locked / danger container treatments** via M22 tokens + glyph/hatch/weight/keyline. Claude lands; Maria does not edit HANDOFF.

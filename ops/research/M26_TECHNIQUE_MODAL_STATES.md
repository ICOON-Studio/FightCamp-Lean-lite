# M26_TECHNIQUE_MODAL_STATES.md

Maria Art Director · 2026-09-22 · art only — STATE and treatment; **no geometry** (UI task owns pixels); **no copy** (K74 owns sentences)

Cage Desk + M22 tokens + M23/M24/M25 discipline. Skill-tree technique modal on hover.

## Three lines

1. **Fight hardest:** **`playing` vs `near`** — both show moving film; only one is the named technique.
2. **Keep only one channel:** **glyph class** (play △ vs near ≈) plus keyline family (accent vs link) — greyscale + CVD safe.
3. **Least sure:** loading duration before it should flip to `no_clip_yet` if the bind fails — treatment below; engine owns the timeout number.

---

## Index build-on (RESEARCH_INDEX grep)

| Doc | Use here |
| --- | --- |
| **M22** | Tokens only — no new hex |
| **M23 / M24 / M25** | Few states; never hue-only; never continuous throb; hollow vs committed chrome |
| **M19** | Fight night: never silent wrong-technique substitution. **This modal may show NEAR only as labelled candour** — honest stand-in, not a fight-presenter lie. Build-on, not contradiction. |
| **C91 / paired-clip negatives** | Paired packs / AI paired bodies already recorded as NOT workable — do not dress NO MOTION as “missing pair film” |

---

## DECISIONS

1. Four states: `playing` / `near` / `no_clip_yet` / `no_motion` — each has its own chrome class.
2. **`near` is candour, not warning** — `color_link` keyline + ≈ glyph; **never** `color_warning` / `color_negative` / hatch-as-danger.
3. **`no_motion` is a different card kind** — no empty viewport hole; filled passive plate.
4. **`no_clip_yet` keeps a viewport frame** but dashed + gap glyph — temporary gap, not passive.
5. **`loading`** is a fifth *transient* (not a catalogue state): spinner/slide on track; must not equal `no_clip_yet`.
6. Entry **200 ms** one-shot; no loop pulse.
7. M22 tokens only.

---

## 1. THE FOUR STATES (channels)

Priority channels (survive greyscale first; CVD without red≠green):

| State | Primary channel | Keyline | Glyph | Viewport / body | Weight |
| --- | --- | --- | --- | --- | --- |
| `playing` | **Exact-play glyph + accent edge** | `color_accent` heavy | **Play △** (1-bit) | Live clip, solid frame hairline | 600 |
| `near` | **Near glyph + link (candour) edge** | `color_link` heavy | **≈** (1-bit) | Live stand-in clip, solid frame | 500 |
| `no_clip_yet` | **Gap glyph + dashed frame** | `color_hairline` dashed | **Gap / empty-reel** | Empty viewport, dashed inset | 500 |
| `no_motion` | **Passive plate — no player hole** | `color_hairline` solid | **Passive mark** (shield/book class) | **No viewport** — `color_sunken` info plate fills the media area | 500 |

**Hue** = trichromat backup only (accent vs link).  
**Greyscale:** glyph shape + dashed vs solid + presence/absence of viewport still separate all four.  
**CVD:** same — link vs accent is secondary; glyph + frame treatment carry the state.

---

## 2. PLAYING vs NEAR (solve first)

Both move. Difference must be chrome, not “one is redder.”

| | `playing` | `near` |
| --- | --- | --- |
| Meaning | Film is **this** technique | Film is **same motion, other name** — useful stand-in |
| Keyline | `color_accent` | `color_link` (candour — M8/M13 LINK family) |
| Glyph | Play △ | ≈ |
| Hatch | none | none (hatch = danger elsewhere; refuse here) |
| Warning chrome | **forbidden** | **forbidden** |

**Trap refused:** dressing `near` as warning/amber/negative — would make a working feature look like a fault.

**M19 relationship:** fight presenter must not silently play the wrong technique. Skill-tree modal may preview NEAR **only** with ≈ + link candour visible — the player can see it is not exact.

---

## 3. A — STATE 4 IS NOT EMPTY

`no_motion` = **category, not gap** (162/696 never get a clip).

| | `no_clip_yet` | `no_motion` |
| --- | --- | --- |
| Kind | Gap (falling weekly) | Permanent passive skill |
| Media area | **Viewport present**, empty, **dashed** inset | **No viewport** — replaced by sunken **passive plate** |
| Glyph | Gap / reel | Passive mark |
| Read | “Film not bound yet” | “This skill has no motion by nature” |
| Broken look | Avoided by dashed + gap glyph (not a blank hole) | Avoided by **filling** the media area — never an empty player frame |

An empty solid viewport with nothing in it = broken. Passive plate = different card.

---

## 4. B — THE TRANSITION (hover, up to 173 nodes)

| Rule | Spec |
| --- | --- |
| Entry | Modal chrome + media area ease in **200 ms** (band 160–240, M23/M24 family) |
| Exit | Same duration ease out |
| Pulse | **None** continuous — M24 ban |
| Per-node thrash | Switching hover target **cuts** prior modal; new entry 200 ms — no stacked fades |
| State paint | State chrome applied at open; if bind resolves mid-open, swap treatment in **200 ms** slide (see loading) |

---

## 5. C — LOADING vs NO CLIP YET

Most likely “feature looks broken” pair if identical.

| | `loading` (transient) | `no_clip_yet` (settled) |
| --- | --- | --- |
| Frame | Solid hairline | **Dashed** hairline |
| Motion in chrome | **Indeterminate track slide** or 1-bit spinner on rim | **Static** |
| Glyph | none / spinner | Gap / reel |
| Clip | Not yet | Confirmed absent for this bind |
| Duration | Until bind resolves or timeout → then `playing` / `near` / `no_clip_yet` | Stable until catalogue changes |

**Rule:** if chrome is moving (spinner/slide), it is loading — never label that as no-clip.  
If dashed + static gap glyph, it is no-clip — never show spinner.

---

## 6. NEVER

1. **Never hue-only** playing vs near (green vs yellow with same glyph).
2. **Never warning/danger chrome on `near`.**
3. **Never continuous throb** on any modal state.
4. **Never empty solid viewport** for `no_motion` — that reads broken; use passive plate.
5. **Never let `loading` and `no_clip_yet` share the same static empty frame.**
6. **Never invent new hex** — M22 only (`color_accent`, `color_link`, `color_hairline`, `color_panel`, `color_sunken`, `color_text`, `color_text_secondary`).
7. **Never write the technique sentence** — K74.

---

## Cheat sheet

| State | Keyline | Glyph | Media |
| --- | --- | --- | --- |
| playing | accent heavy | △ | live exact clip |
| near | link heavy | ≈ | live stand-in clip |
| loading | hairline + spinner/slide | spinner | waiting |
| no_clip_yet | hairline dashed | gap | empty dashed viewport |
| no_motion | hairline solid | passive | sunken plate, no viewport |

---

## Agent reader note

UI geometry task owns pixels. K74 owns words. You own **playing / near / no_clip_yet / no_motion / loading** treatments. Claude lands; Maria does not edit HANDOFF.

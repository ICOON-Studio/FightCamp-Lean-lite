# M31_CAPSULE_OVERLAY_LOOK.md

Maria Art Director · 2026-09-22 · art only — LOOK for FIFTEEN VOLUMES ON ONE BODY debug overlay; **no geometry, no code claims, no invented engine APIs**

Cage Desk + M22 tokens. Debug instrument over live FightCamp bodies: four band treatments, silhouette-first soup rule, freeze-friendly motion grammar, other-fighter intersection lens, skin stays on.

**References (what was taken):**
1. **M23 / M24 / M25** — never hue-only; second channel mandatory; never continuous throb; freeze-readable instruments.
2. **Technical drawing / CAD wire overlays** — silhouette outlines + sparse fill marks read through motion better than translucent mesh stacks.
3. **Medical contact / crash diagrams** — intersection lens as a qualitatively different mark (not another band fill).

Where they disagree: games often paint fifteen translucent capsules sorted by depth. **Reject soup.** Outlines first; fill only where the band grammar requires it.

---

## DECISIONS

1. **Exactly four bands:** `SEGMENT` / `STOUT` / `NEEDLE` / `BALL` — treatments locked below; no new bands.
2. **Never hue-only.** Every band carries a mandatory non-hue second channel (wire / soft fill / dash / weight+stipple).
3. **Confusion pair = NEEDLE vs BALL** — same near-white/`color_text` hue family on purpose; separation = **dashed empty** vs **2× continuous + sparse stipple**. Do **not** paint NEEDLE red/negative.
4. **Soup recipe = silhouette outlines default.** Stacked translucent meshes REJECT. Fill only where band requires (`STOUT` soft ~18%, `BALL` stipple). No depth-sorted alpha soup of fifteen fills.
5. **Motion:** continuous outlines, weight difference, sparse stipple, **screen-space** dashes SURVIVE. Dense 45° hatch on volumes, crawling dashes, regenerating noise, thick fill stacks, continuous throb DIE (M23/M24 law).
6. **Overlap:** same-fighter joint interpenetrations = quiet (draw normally; no intersection marks). Other-fighter A∩B = **hatched intersection lens** (`color_accent` or near-white ~55–70%, orthogonal cross-hatch). Filter is engine wiring — LOOK assumes it; does not compute it.
7. **Skin stays on.** Overlay on top; no whole-body dim; no skin-to-wireframe. Stroke contrast / 1px dark halo underpaint solves wash — not mesh dimming.
8. **Freeze-friendly.** Treatments must read on a paused frame AND survive fight speed; engineer should support pause-with-overlay.
9. **Never list** below — mechanical bans.

---

## 1. FOUR BAND TREATMENTS (hue + mandatory non-hue)

Use M22 token names where possible; hex only as trichromat backup notes (Cage Desk family).

| Band | Hue (trichromat backup) | Non-hue (mandatory second channel) |
| --- | --- | --- |
| `SEGMENT` | cool link / `color_link` cyan family | **Wire only** — continuous **1px** silhouette, **no fill**, lightest ink |
| `STOUT` | warm gold / `color_warning` family | **Wire 1px + soft fill ~18% opacity** (same hue) — presence without soup |
| `NEEDLE` | near-white / `color_text` (**NOT** negative/red) | **Dashed silhouette** (dash:gap ≈ **6:4 in screen space**), **1px**, **empty interior** — broken stroke is the read |
| `BALL` | same near-white / `color_text` family as NEEDLE (shared hue on purpose) | **Continuous silhouette at 2× weight (2px)** + **sparse stipple fill** (dots, not 45° hatch) inside the volume |

**Confusion pair:** `NEEDLE` vs `BALL` — most at risk. Separation = **dashed empty** vs **heavy continuous + stipple**. Same hue family so CVD still reads structure. Do **NOT** use red/negative to mean bad — NEEDLE on pelvis is a valid anatomy shape class, not a fault flag.

**Board authority:** `M31_board_needle_ball_keep.png` (KEEP) · `M31_board_needle_ball_reject.png` (REJECT hue-only).

---

## 2. Q2 — SOUP (fifteen overlapping translucent volumes)

KEEP recipe:

1. **Default = silhouette outlines** for all bands; stacked translucent meshes are **REJECT**.
2. Fill only where the band requires it (`STOUT` soft fill, `BALL` stipple) — never full opaque capsules.
3. **No depth-sorted alpha soup** of fifteen fills.
4. Optional: nearer limb edges slightly higher opacity (≤20% lift), far edges softer — subtle, not a fog.
5. Selected-volume highlight is **OUT OF SCOPE** (no HUD/controls). If engineer adds pick later, fill-boost belongs there — do not invent a legend.

Fifteen volumes on one body must remain readable as **wire grammar**, not as a gelatin stack.

---

## 3. Q3 — MOTION

| SURVIVES at fight speed | DIES / REJECT |
| --- | --- |
| Continuous outlines | Dense 45° hatch on volumes (strobes) |
| Weight difference (1px vs 2px) | Animated / crawling dashes |
| Sparse stipple | Regenerating noise |
| **Screen-space** dashes (stable on screen, not UV-locked spinning) | Thick filled translucency stacks |
| | Continuous throb / pulse (M23/M24 law) |

Dashes are **screen-space** so the broken stroke stays a stable read while the body moves. UV-locked or world-locked dash crawl is forbidden.

---

## 4. Q4 — OVERLAP (operator complaint)

| Case | Treatment |
| --- | --- |
| **Same-fighter** adjacent capsules interpenetrating at joints | **Expected.** Draw normally. **Do not** paint intersection marks on same-body pairs. Quiet joint merge = one man. |
| **Two different fighters** volumes sharing space | The defect. Draw an **intersection lens**: where A∩B (other fighter), paint a **solid high-contrast lens** with **orthogonal cross-hatch** (not 45° alone) using `color_accent` or near-white at ~**55–70%** — qualitatively different from any band fill. |

No legend: hatched contact lens = two men in one volume; quiet joint merge = one man.

**Honesty:** exact same-body vs other-body filter is **engine wiring — NOT COMPUTED from Maria**. LOOK assumes that filter exists. If the filter is absent, the instrument lies — named again under weakest-point / honesty flags.

Optional board: `M31_board_overlap_keep.png` (same-body quiet vs other-fighter hatched lens).

---

## 5. Q5 — SKIN STILL ON

KEEP:

- **Textured lit mesh stays**; overlay draws on top with depth bias / always-visible wires as engineer chooses.
- **No default whole-body dim** (costs truth of skin-vs-capsule registration).
- **No skin-to-wireframe** (**REJECT** — destroys the registration question).

Cost of no-dim: bright skin highlights can wash 1px wires → solve with **outline contrast / slight dark halo on stroke** (1px dark underpaint), not mesh dimming. Optional operator preference dim later — **not this brief**.

---

## 6. NEVER (mechanical bans)

1. **No HUD panel, legend, or control surface** (toggle exists elsewhere).
2. **No colour-means-bad / red-for-NEEDLE** — NEEDLE is shape class, not fault.
3. **No new bands** — exactly four named above.
4. **Never hue-only** separation (fails CVD / dark scene).
5. **Never continuous throb** / pulse attention steal.
6. **Never** depth-sorted translucent fill soup of fifteen volumes.
7. **Never** dense 45° hatch as a band fill; never crawling / UV-spinning dashes; never regenerating noise.
8. **Never** default whole-body dim or skin-to-wireframe swap.
9. **Never** paint same-body joint intersections as defect marks.

---

## 7. SELF-ATTACK (mandatory)

**Strongest case against the live overlay:** one still frame of two fighters at contact with volumes drawn may teach more than live mid-exchange soup. Developers will toggle once, shrug, leave off. If unread, better not build.

**Maria's position after attack:** still ship the LOOK — but the instrument is **freeze-friendly**: treatments must read on a paused frame **and** survive motion; engineer should support **pause-with-overlay**.

**Weakest point (unprompted):**

1. **Live capsule radii/lengths and HOME-camera on-screen px for NEEDLE/BALL were NOT COMPUTED this pass** — treatments are shape grammar without measured readability at FightCamp HOME distance.
2. **Same-body vs other-body intersection filter is assumed, not verified** — if engine filter is absent or wrong, the hatched lens lies.

---

## 8. HONESTY FLAGS

| Claim | Status |
| --- | --- |
| Four band treatments (wire / soft fill / dash / weight+stipple) | **LOCKED LOOK** — ship |
| NEEDLE vs BALL separation without hue | **LOCKED** — boards A/B |
| Soup = outlines default | **LOCKED** |
| Screen-space dashes | **LOCKED** motion rule |
| Other-fighter intersection lens | **LOCKED LOOK**; filter **ASSUMED** (engine) |
| Capsule radii / lengths at HOME | **NOT COMPUTED** |
| NEEDLE/BALL on-screen px at HOME | **NOT COMPUTED** |
| Same-body vs other-body filter exists & correct | **NOT VERIFIED** this pass |
| Selected-volume highlight / legend / HUD | **OUT OF SCOPE** |
| Geometry / `.gd` / `.tscn` / HANDOFF | **NOT FROM MARIA** |

---

## Agent reader note

You own **band → hue token → non-hue treatment → soup rule → motion survival → overlap lens grammar → skin-on rule**. You do **not** own capsule math, HOME px proof, or the same/other-body filter. If a builder needs a pixel size for a capsule, they measure it — not invent it from this file. Claude lands research; Maria does not edit `HANDOFF.md`.
